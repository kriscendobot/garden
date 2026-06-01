# design(driver): script-orchestrated PR-creation flow

| Created | 2026-05-29 |
| Updated | 2026-06-01 |
| Author  | gardener, fixer |
| Status  | Proposed   |

## Summary

Pivot the garden's PR-creation flow from **claude-on-top** orchestration (the steward and contractor wake on cron, run an LLM tick to scan state, and dispatch subagents via the `Agent` tool) to **claude-under-script** orchestration: a pool of bash worker scripts watches role-specific job boards, claims jobs deterministically, and runs a state machine that invokes claude only when judgment is needed (failure diagnosis, ambiguous classifications). Each invocation captures its failure log via `git hash-object -w --stdin` and passes the SHA into the prompt; claude reads the log on demand via `git cat-file blob`.

The new orchestrator-equivalent role is the **driver**: one driver per active garden-PR, lifetime equal to the PR's, running the state machine from initial design through merge. The existing `shepherd` role (CI-to-green) is unchanged and may be invoked by the driver for a CI-recovery substate.

## Motivation

### The claude-on-top pain shape

Today's PR-creation flow has every step running inside an LLM tick:

- The **steward** wakes on `ScheduleWakeup` every 1800-3600s, runs its per-cycle survey, scans the PR-creation-flow chain, and dispatches subagents via `Agent`. Even quiet cycles burn LLM tokens: 2026-05-29 had a 5-consecutive-quiet-cycle streak (cycles 14 through 18) each producing a tick of nothing-changed-state.
- The **contractor** runs the same per-cycle pattern on a shorter cadence, foreground, with three slot files. When a slot is unattended for a cycle (e.g. the 2026-05-29T03:09Z silence on contractor host until 06:08Z heartbeat), PRs stall until the steward's broader scan picks them up.
- **Role hand-offs** at the seams of the chain (cleaner returns → barrister gets dispatched; fixer push → justice re-dispatched) require the orchestrator's next LLM tick to read the `result`, classify it, and dispatch the next role. The seam latency is the cycle interval, typically 5 to 30 minutes.

Observable costs from 2026-05-29 alone:

- **28-minute gap on PR #376** (kriskowal `COMMENTED` at 05:01:20Z; steward acted at 05:29Z). Motivated the *Maintainer-feedback response* section landed today.
- **50-minute weaver hand-off on PR #357** (cycle-12 wake found the conflict; the contractor session was silent; steward picked up via the standing PR-creation-flow scan).
- **5 consecutive quiet cycles** between 07:08Z and 09:43Z, each producing a 1-line `tick` entry confirming "state unchanged." Every quiet tick is a parent-context LLM invocation.

The shape is structural: the parent loop is an LLM context, so every wake reads a substantial conversation buffer, every dispatch invokes a fresh subagent context, and every quiet tick is also a billable LLM call.

### The claude-under-script alternative

Invert the stack. The parent loop is a **deterministic bash script**. The LLM is invoked only where judgment is needed:

- A test fails: the script captures the output, summarizes the failure, and (if the failure shape is unfamiliar) prompts claude to diagnose.
- A review comment is ambiguous: the script picks up the `gh pr view` JSON, recognizes that human judgment is needed to map the comment to a code change, and prompts claude.
- A formatter touches files outside the PR's scope: deterministic; the script reverts.
- CI is green and the PR has a maintainer approval: deterministic; the script invokes the conductor merge step.

The deterministic steps are no-LLM. Watching for events, reading PR state, running tests, formatting, pushing commits, posting reactjis, the basic git plumbing — all bash. The LLM gets called when the script reaches a step whose output it cannot interpret on its own.

### Why now

Two motives compound. First, **token cost**: most cycles do no substantive work but pay full per-cycle LLM cost. Second, **reliability**: the cycle interval is the floor of hand-off latency; reducing it via shorter cycles would multiply the token cost without addressing the underlying inefficiency. The script-driven pivot addresses both at once.

## Principle

The driver is **the lowest-level component that has authoritative knowledge of a single PR's state**. Each PR gets one driver. The driver:

1. Listens for events on its PR (CI status, maintainer reviews, push events, scheduled re-checks).
2. Computes the next-stage-owed via the deterministic state-machine predicate.
3. Either runs the next stage in-process (deterministic step) or posts a job to a role-specific board and waits for a worker to claim and execute it.
4. On a worker's `result`, advances the state machine and repeats.
5. On a failure the script cannot interpret, captures the log via `git hash-object`, constructs a prompt that names the PR, the design document, the role, and the current state, and invokes claude.

The driver is not an LLM session; it is a bash process. Multiple drivers run in parallel, one per active PR, bounded by a host-wide pool cap.

## Architecture

### Worker pool

Workers are bash daemons, one process per worker, polling a single role's job board. Each role with deterministic-enough work has its own worker pool:

- `builder` workers consume `journal/jobs/builder/open/`.
- `cleaner` workers consume `journal/jobs/cleaner/open/`.
- `barrister`, `justice`, `solicitor`, `fixer`, `appellate`, `conductor`, `weaver` workers consume their respective role-specific boards.

A worker's loop:

```sh
while true; do
  CLAIM=$(skills/job-board/claim-job.sh $ROLE)  # adapt: role-specific path
  [ -z "$CLAIM" ] && { sleep 30; continue; }
  bash skills/$ROLE/$ROLE.sh "$CLAIM" \
    || skills/job-board/abandon-job.sh "$CLAIM"
  skills/job-board/complete-job.sh "$CLAIM"
done
```

Each role's executable script (`skills/$ROLE/$ROLE.sh`) is the deterministic part of the role's work. It invokes claude only when the script reaches a step its decision tree cannot resolve.

The worker pool size per role is a host-wide config; the existing host-wide concurrency caps (one cleaner per estate, etc.) can be enforced via per-role pool size of 1 where it matters.

### Role-specific job boards

Generalize the current `journal/jobs/{open,claimed,done,abandoned}/` to:

```
journal/jobs/<role>/open/
journal/jobs/<role>/claimed/
journal/jobs/<role>/done/
journal/jobs/<role>/abandoned/
```

The general `journal/jobs/{open,claimed,done,abandoned}/` is retained during migration for liaison-staged work and for backward compatibility with the steward's existing scan.

Each role-specific board uses the same claim-via-push race the current board uses (`skills/job-board/SKILL.md`). The race is the serialization point; rejected claims back off without retry.

### Drivers

A driver is a bash process bound to one garden-authored PR (or to a generic job-board worker role; see *Multi-job-kind drivers* below). It is invoked manually by the maintainer via `roles/driver/driver.sh <lane>` (per Q9 disposition), where `<lane>` is the driver's lane number. The driver exits when its PR is merged, closed without merging, or abandoned, when it traps an unexpected error (and reports to the gardener inbox per *Error reporting* above), or when the maintainer signals it.

The driver's responsibilities:

1. **Event listening.** Subscribe to events for its PR: GitHub Webhook (when available), `journal/events/<repo>--<pr>.log` tail (a per-PR event log written by the existing standing-monitor daemons), and a periodic re-check ticker (default 5 minutes for active PRs, longer for idle).
2. **State persistence.** The driver writes its state to `journal/drivers/<repo>--<pr>.md` after every transition. The state file is the canonical record of where the driver is in the state machine.
3. **Job posting.** When a state transition requires a role's work, the driver posts a job to `journal/jobs/<role>/open/` and records `awaits: <role>:<job-slug>` in its state file.
4. **Result consumption.** The driver watches the job board for its posted jobs reaching `done/` (matched by the slug it posted with). On completion, it reads the worker's `result` journal entry, advances the state machine, and continues.
5. **Failure escalation.** If the script reaches a state whose deterministic predicate cannot resolve the next transition (ambiguous CI failure, contested review classification, conflict with multiple plausible resolutions), the driver invokes claude with a prompt-on-failure capture (see below).

### The driver state machine

Derived from the current PR-creation-flow chain:

```
                       [initial]
                          |
                          v
                       [design]
                          |  designer worker drafts the design document
                          v
                       [build]
                          |  builder worker opens the DRAFT PR
                          v
                  +---[clean]---+
                  |  cleaner    |  (skipped for tiny-PR and design-only variants)
                  |  worker     |
                  +-------------+
                          |
                          v
                       [panel]
                          |  barrister (first round) or solicitor (design-only)
                          v
                  +----<verdict>----+
                  |        |        |
       must-fix-loop   appeal-ok  approve
                  |        |        |
                  v        v        v
              [fixer]   [appellate] [un-draft]
                  |        |        |
                  v        v        v
              [justice]  [un-draft] [await-maintainer]
                  |        |        |
                  +<-------+        v
                  ^                 (event-driven branches)
                  |                 |          |          |
                  +-----------------+          v          v
                                       [changes-requested]  [approved+green]
                                                 |               |
                                                 v               v
                                            [fixer/designer]  [conductor]
                                                 |               |
                                                 +--->[await-maintainer]
                                                                 |
                                                                 v
                                                            [merged]
```

States as predicates (each is a check the script runs against `gh pr view <N> --json ...`):

- `[initial]`: a design document exists; no PR yet.
- `[design]`: the design document is being drafted (designer worker is in flight).
- `[build]`: the PR is being opened (builder worker is in flight).
- `[clean]`: the PR is OPEN, DRAFT, no panel verdict yet, cleaner worker in flight or pending.
- `[panel]`: cleaner has pushed, CI is green, no panel verdict yet; the right judge worker (barrister for source PRs first time, solicitor for design-only, justice for source-after-fixer) is in flight or pending.
- `[verdict]`: a panel verdict has been submitted as a formal `kriscendobot`-authored review.
- `[fixer]`: panel verdict carries `must-fix-loop` items; fixer worker is in flight or pending.
- `[justice]`: fixer push has landed since last panel verdict; justice worker re-runs the panel.
- `[appellate]`: terminating verdict; appellate considers promotions before un-draft.
- `[un-draft]`: `gh pr ready <N>` ran; PR is now ready for review.
- `[await-maintainer]`: PR is OPEN, not draft; waiting for a maintainer review event.
- `[changes-requested]`: maintainer event landed with `CHANGES_REQUESTED` (or substantive `COMMENTED`); appropriate response worker (fixer for source, designer for design-only) dispatches.
- `[approved+green]`: maintainer event landed with `APPROVED` and CI is green; conductor worker merges.
- `[merged]`: terminal.

Transitions are deterministic functions of the PR's current GitHub state. The script evaluates them after each event without LLM involvement. The LLM is invoked only when the predicate has no clear answer (e.g., a panel verdict's body says "almost-approve with one footnote": is that `approve` or `must-fix-loop`? The script captures the verdict body, hashes it, and prompts claude to classify).

### Prompt-on-failure capture pattern

When the driver (or a worker script) reaches a step it cannot resolve deterministically:

1. **Capture.** Write the relevant output (test failure log, CI run JSON, review verdict body, conflict diff) to the journal as an unreferenced blob:

   ```sh
   LOG_SHA=$(some_command 2>&1 | git -C journal hash-object -w --stdin)
   ```

   The blob is in the journal's object database; it has no commit, no tree, no reference. It persists for as long as the next `git gc` allows.

2. **Promote (optional).** If the failure is one we want to survive a `git gc`, anchor the blob with a lightweight reference:

   ```sh
   git -C journal update-ref refs/captures/<role>/<pr>/<short-id> $LOG_SHA
   ```

   Captures under `refs/captures/` are kept indefinitely until explicitly pruned. Most one-off failures do not need this; only failures we expect to repeat (operational flakes, recurring conflict shapes) earn a ref.

3. **Prompt construct.** The script writes a prompt file from a template that fills four named slots:

   - PR identifier: `<owner>/<repo>#<n>` and the HTML URL.
   - Design document: the path to the design that motivated this PR (relative to garden root, or `(none)` if the PR is not design-driven).
   - Role: the role whose work is currently in flight (`builder`, `fixer`, etc.).
   - State machine state: the driver's current state.
   - Capture SHA: the `LOG_SHA` from step 1.
   - Failure context: one paragraph the script writes about why it escalated.

4. **Invoke.** Pipe the prompt to claude (the harness's non-interactive form). Example shape:

   ```sh
   claude -p "$(cat prompt.md)" --output-format json > response.json
   ```

   The prompt instructs claude to read the log via `git -C journal cat-file blob <LOG_SHA>` rather than expecting it inlined. The prompt stays small; the LLM pulls the log on demand only if the four-slot brief is not sufficient.

5. **Apply.** The script reads claude's response (typically a patch, a directive, or a classification). It applies the response, advances the state machine, and resumes.

The capture-by-SHA pattern means identical failure logs produce identical SHAs. Recurring operational flakes (the test-xs esvu download issue that hit PRs #79, #357, #375, #377 today) would all hash to the same blob. The script can short-circuit on a known-SHA: if the failure SHA matches a previously-classified failure, apply the known disposition without re-invoking the LLM.

### Error reporting to the gardener inbox

The general pattern for *any* unexpected error in a driver or worker shell script is to send a message to the gardener's inbox. The inbox is the journal-side mailbox at `journal/inboxes/<host>/gardener.md`; the gardener role drains it via the `inbox-drain` skill on its next dispatch.

Each numbered driver gets its own mailbox so the gardener can attribute failures to a specific lane without forensic ordering across an aggregated stream. The lane number comes from the driver's invocation argument (see *Driver supervisor*, Q9 disposition below): driver one writes to `journal/inboxes/<host>/gardener.md` with a section header that names the lane and includes the captured transcript SHA. The mailbox itself is shared with other gardener-routed messages; the per-lane discrimination is by message header and transcript reference rather than by separate files.

The error-reporting flow:

1. The driver's outer shell traps unexpected exits (`trap '...' ERR EXIT` with discrimination on `$?`).
2. The trap writes the failure transcript (the `-x` subshell capture, see *Driver supervisor*) to the journal as a blob via `git hash-object -w --stdin`.
3. The trap appends a message section to `journal/inboxes/<host>/gardener.md`, naming the driver lane, the PR (if any), the state, the capture SHA, and a one-paragraph context.
4. The driver exits non-zero. Restart policy is the supervisor's concern (Q9 disposition: manual restart, since drivers are manually launched).

This pattern is uniform across the driver, worker scripts (`builder.sh`, `cleaner.sh`, etc.), and the repo-activity watcher described next. Anything that is not the LLM-judgement substate inherits the same error fan-out.

### Coalesced repo-activity watcher

Today's standing-monitor daemons (one per repository) are independent processes writing to `/tmp/garden-monitor-*.log`. The driver design coalesces these into a **single repo-activity watcher process** per host whose responsibility is to deterministically append messages to the relevant inboxes in the journal.

Subscription model:

1. Each driver, on launch, advertises which PRs it is subscribed to by writing a subscription file at `journal/drivers/<host>/<lane>.subscriptions` (or equivalently a stanza in its state file). The file enumerates `repo:pr` pairs.
2. The watcher reads the union of all subscriptions on each polling tick. The union determines its fanout: which PRs to poll, and which inboxes (per-driver) to deliver events to.
3. When the watcher detects a new event (CI status change, review submission, push, comment), it deterministically classifies the event and appends a message to the subscribed driver's per-PR event log at `journal/events/<repo>--<pr>.log` (the driver's tail source per the existing design).
4. Events with no subscribed driver (e.g., a brand-new garden-authored DRAFT PR with no driver yet) go to a default inbox the supervisor watches, so it can launch a driver on demand.

The coalesced watcher also owns:

- **Deterministic reactji posting** (see next subsection). The watcher is the single agent that posts `:eyes:` on a new comment to acknowledge surveillance; previously this was an agent-task and was unreliable.
- **Per-event message routing**: a `@kriscendobot` mention routes to the subscribed driver's inbox; an assigned-issue event routes to the steward's job-board posting hook; an issue body mention routes elsewhere.

The watcher subsumes the role of the existing per-repo poll daemons but with a single process whose subscription set is the union of active driver subscriptions. The benefit is one polling rate budget across the host, one place to land event-format changes, and a deterministic single source of truth for "this event was seen at SHA X at time T."

### Deterministic reactji posting

Posting reactji on PR comments today is a soft-real-time responsibility that falls to whichever agent picks up an event next. It is unreliable: the `:eyes:` reactji that acknowledges "the garden has seen this comment" can be delayed by minutes if no agent is scheduled.

Under the driver design, the **coalesced repo-activity watcher** owns reactji posting deterministically:

- New comment detected → `:eyes:` reactji posted immediately as part of the watcher's per-event handler, before routing the message to a driver inbox.
- The watcher records the reaction SHA (the comment id and reactji id) in `journal/events/<repo>--<pr>.log` so downstream agents do not double-post.
- Acknowledgment reactji (`:+1:`, `:rocket:`) on resolved review comments remain the driver's or fixer's responsibility, gated by the specific action that resolves the comment.

The benefit is the eyes reactji becomes a near-instantaneous deterministic signal to the maintainer that the garden has registered the comment. The watcher is the single place that posts; race conditions between agents are eliminated by construction.

### Deterministic worktree lifecycle

Today the worktree triple (`garden/`, `journal/`, `project/`) is created by `skills/dispatch-worktree/dispatch-prepare.sh` immediately before an `Agent` invocation and torn down by `skills/dispatch-worktree/dispatch-teardown.sh` when the subagent returns. The orchestrator runs both scripts inside its LLM context.

Under the driver design, worktree setup and teardown are deterministic and **driver-run**: the driver (or the worker script the driver dispatches into) calls the prepare and teardown scripts directly as part of its bash flow, not as an Agent-side step inside an LLM context. This:

- Removes the worktree lifecycle from the LLM's responsibility surface, eliminating a class of "the agent forgot to teardown" failures.
- Lets the driver create per-stage worktrees (a fresh `project/` per state-machine transition that needs one) without paying a per-stage LLM-tick cost.
- Aligns the worktree's existence with the deterministic step that produced it, making leaks visible: a worktree that survives a non-failing transition is a deterministic bug, not an LLM oversight.

The prepare and teardown scripts themselves are unchanged; only their caller changes.

### Driver-run pre-CI validation

Before pushing changes to a PR branch (whether the initial DRAFT open or a fixer follow-up), the driver runs a deterministic validation gauntlet locally:

1. `yarn format` (auto-fix in place; if anything is dirty after, the driver stages and commits the format changes as part of the same push).
2. **Tests relevant to the changes**: a targeted run against the touched packages (e.g., `yarn workspace @endo/<pkg> test`) for fast feedback.
3. `yarn build:types:check` (typecheck the whole monorepo).
4. `yarn lint` (full lint pass).
5. **Full test run** across all packages.
6. **Docs generation** (`yarn docs` or equivalent).

Only after all six steps pass does the driver push to the PR branch. CI then runs the same set; the driver's local pass is a precondition that catches the bulk of avoidable red-CI handoffs.

When a step fails, the driver either:

- Auto-fixes and re-runs (for `yarn format`).
- Captures the failure log via `git hash-object`, escalates to claude with the prompt-on-failure pattern, applies the response, and re-runs.
- After two unsuccessful escalations, parks the driver, reports to the gardener inbox, and exits.

The class of "I had to ask for `yarn format` again" cannot survive this gate. The class of "tests failed in CI but never locally" reduces to a CI-only environmental shape, which is a much narrower problem.

### Multi-job-kind drivers

A driver picks up *many kinds of job*, not just per-PR PR-creation work. The categories the design recognizes:

1. **PR-creation flow** (the original motivating shape): one driver per active garden-authored DRAFT PR, lifetime equal to the PR's, running the state machine documented above.
2. **Observed-error response**: a driver can be assigned a captured-error mailbox to triage and act on. The trigger is a gardener-inbox entry with a transcript SHA; the driver investigates the transcript, classifies the failure, and either lands a fix-PR, files an issue, or escalates back to the maintainer.
3. **Issue response**: a driver can pick up a job to respond to an issue (read, classify, draft a reply or a fix-PR, post).
4. **Build request**: a driver can pick up a job to satisfy a request to build (analogous to the existing builder dispatch but driver-mediated).
5. **Design request**: a driver can pick up a job to satisfy a request to design (analogous to the existing designer dispatch).
6. **Retcon / rebase request**: a driver can pick up a fixer-retcon or weaver-rebase job from the job board.

The job-kind dispatch is the driver's outer loop after its primary subscribed PR (if any) reaches a steady state. The driver polls the role-specific job boards for any job it is eligible to claim, claims one, runs the appropriate workflow, then returns to subscribed-PR work. When the driver has no subscribed PR (a generic worker driver), the entire body is job-board-driven.

Classification of *which role's workflow to run* is by **inference**: the LLM reads the job's brief (the job-board entry's body) and selects the role. Where a deterministic predicate is feasible (the job kind is named explicitly in the job file's frontmatter, the PR's labels are unambiguous), the script short-circuits. Where it is not, the LLM classifies and the script records the classification SHA so identical briefs reuse the verdict.

### Role-specific driver workflows

The driver does not run *one* workflow; it runs the workflow appropriate to the job kind it claimed. Each workflow is a state machine fragment with its own predicates:

- **PR-creation workflow** (the canonical state machine above): initial → design → build → clean → panel → verdict → fixer/justice/appellate → un-draft → await-maintainer → changes-requested or approved+green → merged.
- **Issue-response workflow**: triage → classify (bug / feature / question / noise) → either draft-and-post-reply (for question / noise) or open-fix-PR (for bug / feature, which re-enters the PR-creation workflow on the new PR).
- **Build-request workflow**: read the request → check feasibility → if feasible, run builder.sh and enter PR-creation workflow on the new DRAFT; if not, reply with the blocker.
- **Design-request workflow**: read the request → check existing designs for conflicts → run designer.sh to draft the design document → open the design-only DRAFT PR (which re-enters PR-creation workflow with the solicitor / design-panel branch).
- **Retcon / rebase workflow**: read the target PR → run fixer.sh (retcon) or weaver.sh (rebase) → push → re-enter PR-creation workflow at the post-push state.

Each workflow's predicates live in `skills/driver-<workflow>-state-machine/SKILL.md` (one per workflow). The skills are tiny; their job is to enumerate the states and the transition predicates. The driver's outer body reads the workflow's skill on entry to the workflow and consults it on each transition.

### Prompt continuity

Every prompt the driver or a worker emits names:

- The PR identifier (URL).
- The design document path (relative to garden root) or `(none)`.
- The role.
- The state machine state.
- The capture SHA (if any).

This means the LLM does not need to re-read `CLAUDE.md`, `roles/COMMON.md`, or the role's full `AGENT.md` to do its work. The role's `AGENT.md` is read once at worker startup; the per-job context is the four-slot brief. The LLM treats each invocation as a focused micro-task rather than a fresh subagent context boot.

## What changes in the existing library

### New artifacts

- `roles/driver/driver.sh`: the manually-invoked driver entry point. Takes a lane number as its first argument (per Q9 disposition); wraps its inner body in a `-x` subshell that captures a transcript; traps `ERR` and `EXIT` to fan unexpected failures out to the gardener inbox with the transcript SHA.
- `roles/driver/AGENT.md`: the driver's contract as a *script* rather than a *subagent operating brief*. Documents the state machine, the worker-pool relationship, the event sources, and the escalation pattern. Names the manual-invocation convention; documents the per-lane file naming.
- `skills/driver-state-machine/SKILL.md`: the formal state diagram and transition predicates for the PR-creation workflow. Names which transitions are deterministic and which escalate to the LLM.
- `skills/driver-<workflow>-state-machine/SKILL.md`: one per non-PR-creation workflow (issue-response, build-request, design-request, retcon / rebase). Each is a tiny state machine; the driver consults the right one based on the job kind it claimed.
- `skills/prompt-on-failure-capture/SKILL.md`: the `git hash-object` / `git cat-file blob` capture pattern, prompt template shape, claude invocation, and known-SHA short-circuit.
- `skills/role-job-board/SKILL.md`: the role-specific job board contract. Extends the existing `skills/job-board/SKILL.md` with the per-role subdirectories.
- `skills/coalesced-repo-activity-watcher/SKILL.md`: the single repo-activity watcher process that reads the union of driver subscriptions, polls events, fans them to per-driver inboxes, and owns deterministic reactji posting. Replaces the per-repo standing-monitor daemons after observed equivalence (per migration plan Phase 5).
- `skills/gardener-inbox-error-reporting/SKILL.md`: the uniform pattern for trapping unexpected errors in any driver / worker shell script, capturing the transcript via `git hash-object`, and appending a message to `journal/inboxes/<host>/gardener.md` with the lane discrimination header.
- `skills/driver-pre-ci-validation/SKILL.md`: the deterministic six-step gauntlet (`yarn format`, targeted tests, `yarn build:types:check`, `yarn lint`, full tests, docs generation) the driver runs before pushing changes.
- A `skills/$ROLE/$ROLE.sh` companion script for each role with a deterministic-enough body. Initially: `builder.sh`, `cleaner.sh`, `fixer.sh`, `weaver.sh`. The judges (`barrister`, `justice`, `solicitor`, `appellate`) and the conductor may have thinner scripts and more LLM body.

### Modified artifacts

- `roles/steward/AGENT.md` § PR-creation-flow scan: **preserved through the migration** (per kriskowal disposition, 2026-06-01). The scan remains authoritative until drivers demonstrate ≥95% PR-creation-workflow reliability and the maintainer signs off on retirement. Phase 5 of the migration is the earliest point this section is retired.
- `roles/steward/AGENT.md` § Maintainer-feedback response: preserved unchanged through the migration. Once drivers are reliable, the action surface may shift to "post a job to the appropriate role-specific board" rather than "Agent-dispatch a fixer or designer," but the trigger surface is unchanged.
- `roles/general-contractor/AGENT.md`: **preserved through the migration**. The contractor's slot machinery (per-cycle scan + dispatch + foreground visibility) remains the foreground PR-pipeline orchestrator until drivers prove reliable. Re-scoping or absorption into the liaison is deferred to a post-Phase-4 maintainer decision.
- `roles/monitor/AGENT.md` and the per-project monitor skills (`monitor-endo`, `monitor-endo-but-for-bots`, etc.): preserved through the migration. The coalesced repo-activity watcher runs alongside them in a verification mode. Per-project monitor retirement is per-project and gated on observed equivalence (Phase 5).
- The existing `shepherd` role: unchanged in scope. The driver may invoke a shepherd worker for a CI-recovery substate when the state machine reaches `[await-ci-recovery]`.
- `skills/job-board/SKILL.md`: generalized to support per-role boards.
- `CLAUDE.md` § Current inventory: updated to add the driver role, the new skills, and the role-companion scripts. The existing roles remain listed unchanged through the migration.

### Migration plan

This workflow is **experimental** (kriskowal disposition, 2026-06-01). Existing systems (the steward's per-cycle PR-creation-flow scan, the general-contractor, the standing-monitor daemons, the agent-dispatched workflow) are **preserved** throughout the migration. Drivers run alongside, not instead of, the existing systems; the existing systems remain authoritative until drivers prove reliable. Drivers are **dispatched manually** through the migration period; no automatic supervisor activation. The migration's retirement of any existing system is gated on observed driver reliability (≥95% of PR-flow advancement handled correctly without manual intervention) and the maintainer's explicit go-ahead.

- **Phase 1: design + scaffolding** (this PR plus follow-ups). Lands `roles/driver/AGENT.md`, `skills/driver-state-machine/SKILL.md`, `skills/prompt-on-failure-capture/SKILL.md`, the coalesced repo-activity watcher skeleton, and the role-specific job board pattern. No live drivers yet. Existing steward / contractor / monitor remain authoritative.
- **Phase 2: one shape end-to-end, manual launch.** Implement the driver for design-only PRs (the simplest state subset: solicitor only, no cleaner, no fixer-loop typically). Shake out on `endojs/endo-but-for-bots`. Drivers launched manually per PR via `roles/driver/driver.sh <lane>` (Q9 disposition); steward continues to handle source-touching PRs and serves as a fallback for any design-only PR whose driver is not manually launched. Existing standing monitors remain authoritative; the coalesced watcher runs alongside in a verification mode that compares its events to the monitors' events.
- **Phase 3: source-touching support, manual launch.** Implement the cleaner / barrister / fixer / justice / appellate substates. Drivers launched manually per PR. Steward's PR-creation-flow scan remains authoritative; drivers run alongside as a verification mode. The coalesced watcher remains alongside the monitors.
- **Phase 4: reliability evaluation.** Compare driver behavior to steward / contractor / monitor behavior on the same PRs over a representative window. Reliability is measured per workflow shape (PR-creation, issue-response, build-request, design-request, retcon / rebase) against an explicit checklist. Phase 5 is gated on ≥95% per-workflow reliability and explicit maintainer sign-off.
- **Phase 5: retire scans selectively, maintain manual dispatch.** Per kriskowal disposition (2026-06-01), the existing scan-based systems are kept and dispatched through the drivers manually until the driver system is reliable. Retirement is per-system: the steward's PR-creation-flow scan retires first (after ≥95% reliability is shown for PR-creation workflow), then the contractor's slot machinery (after the same threshold for its workflows), then the per-repo standing monitors (after the coalesced watcher proves equivalent on its safe-to-monitor set). Each retirement is a separate maintainer decision.
- **Phase 6: cross-repo rollout.** Extend to other monitored repos (`endojs/endo`, `agoric/agoric-sdk`) as their gating allows.

The bulletin tracks each phase's status. The migration is reversible: if a phase reveals a structural problem, the existing system absorbs the work load without per-PR coordination because it never stopped being authoritative.

## Open questions

Several of the original open questions were resolved by kriskowal's PR-3 review on 2026-06-01. Each resolved question carries a `**Disposition:**` sub-block with the verbatim choice. Questions that remain open are explicitly labeled.

1. **Worker pool sizing.** One driver per active PR; what's the cap on concurrent drivers per host? One worker per role today (analogous to the host's single-cleaner cap); when do we need more?

   **Disposition (kriskowal, 2026-06-01):** "I will manually scale the pool of concurrent drivers." No automatic supervisor-managed cap. The maintainer launches additional driver lanes by hand when more concurrency is wanted; the driver script accepts a lane number as its argument (see Q3 and Q9).

2. **Failure modes for the LLM.** What if claude is rate-limited or unavailable when the driver escalates? Options: park the driver in `awaits-llm` state with a retry timer; surface to maintainer via the bulletin; fall back to the steward's old `Agent`-dispatched subagent shape as a degraded mode.

   **Disposition (kriskowal, 2026-06-01):** "Exponential backoff with full jitter." The driver parks in `awaits-llm` and the retry timer uses exponential backoff with full jitter (per the AWS Architecture Blog formulation: `delay = random_between(0, min(cap, base * 2^attempt))`). On persistent unavailability the driver eventually surfaces to the gardener inbox (per *Error reporting* above) so the maintainer can intervene; the existing steward / contractor remain available as a manually-dispatched degraded mode because they are preserved through the migration.

3. **Observability and per-lane discrimination.** How does the maintainer see driver state? The proposal includes `journal/drivers/<repo>--<pr>.md` per-PR state files; a bulletin section summarizing active drivers; the existing journal-side `result` and `tick` entries from each worker invocation.

   **Disposition (kriskowal, 2026-06-01):** "I will manually scale the driver pool. Each driver should be given a lane number when invoking the shell script." The driver's first positional argument is its lane number (e.g. `roles/driver/driver.sh 1` for driver one). The lane number is carried into:

   - The driver's state file path: `journal/drivers/<host>/<lane>.md`.
   - Subscription advertisement: `journal/drivers/<host>/<lane>.subscriptions`.
   - Gardener-inbox messages (per *Error reporting* above), which name the lane in the message header.
   - Worker dispatch entries the driver writes, so per-lane filtering by `grep '^lane: <n>'` works.

   Bulletin observability and the per-PR state files remain as proposed.

4. **Credentials and identity.** Workers run continuously as the bot identity. The existing host-pinned identity (`kriscendobot` on `kmkmbp2021`, `endolinbot` here) is preserved. Boatman is the special case as today; the boatman worker remains the only one authorized to switch identity.

   **Disposition (kriskowal, 2026-06-01):** "Nothing to change here." The existing identity discipline is preserved unchanged.

5. **Tooling boundaries.** The driver invokes `gh`, `git`, `yarn`, etc. directly. Today some operations live inside subagent contexts (the cleaner reads test output via `Bash`). The driver runs them in the parent. Sandboxing? Resource limits? The host's existing pinning of `user.name` / `user.email` per worktree is one example of the same discipline.

   **Status:** Open. No disposition in the 2026-06-01 review pass.

6. **State machine determinism.** Some transitions today are LLM-classified: a maintainer's `COMMENTED` body needs reading to decide if it's substantive feedback (fixer dispatch) or chatter (no-op). The script needs either a deterministic fallback (always escalate to LLM with `<COMMENTED body>` capture) or a strict predicate (length-and-keyword filter). The design assumes escalate-on-ambiguous; the threshold is open.

   **Disposition (kriskowal, 2026-06-01):** "Fine." The escalate-on-ambiguous default stands. The driver captures the body, hashes it, and prompts claude to classify; identical bodies (identical SHA) reuse the prior classification without re-invoking the LLM.

7. **Relationship to standing monitors and the coalesced watcher.** Existing standing-monitor daemons (per-repo bash poll daemons writing to `/tmp/garden-monitor-*.log`) and the proposed coalesced repo-activity watcher (see *Coalesced repo-activity watcher* above).

   **Disposition (kriskowal, 2026-06-01):** "This new workflow is experimental and existing systems should be preserved." The coalesced watcher runs alongside the existing standing-monitor daemons through the migration; the existing monitors remain authoritative until the watcher proves equivalent on the safe-to-monitor set. Retirement of the per-repo monitors is per-system and gated on the maintainer's decision after observed reliability (per the migration plan's Phase 5).

8. **Liaison and steward retention through the migration.** Both roles persist as meta-layer postures. The liaison remains the user-in-the-loop surface; the steward remains for cross-PR coordination, housekeeping, and the per-cycle survey of inbox and job board for items not driver-bound (boatman dispatches, gardener dispatches, scholar work, etc.).

   **Disposition (kriskowal, 2026-06-01):** "We will keep these for now and dispatch through the drivers manually until that system is reliable." Both roles are preserved; the steward's PR-creation-flow scan and the contractor's slot machinery remain authoritative through Phase 4. Drivers are dispatched manually during the migration. Per-system retirement is selective and gated on observed driver reliability (per migration plan).

9. **Driver supervisor.** Is the supervisor a bash daemon (analogous to `job-board-poll.sh`), a systemd unit, or a liaison-invoked process?

   **Disposition (kriskowal, 2026-06-01):** "I am going to invoke the driver manually, like `roles/driver/driver.sh 1` for driver one. It should be bot supervised in the sense that it will trap all errors and report them to the gardener, with a transcript of the failure. This may require subshelling with `-x` so that there's an artifact to submit to the gardener."

   The driver is a manually-invoked script (`roles/driver/driver.sh <lane>`), not a supervisor-launched daemon. There is no separate supervisor process; the maintainer is the supervisor at launch time. Bot-side supervision is *error supervision*: the driver script:

   - Wraps its inner body in a subshell run with `-x` (`( set -x; <body> ) 2>"$transcript"` or equivalent), so every command and its arguments land in a transcript file.
   - Traps `ERR` and `EXIT` with discrimination on `$?`. On unexpected exit, the trap:
     - Captures the transcript via `git -C journal hash-object -w --stdin < "$transcript"`.
     - Appends a section to `journal/inboxes/<host>/gardener.md` naming the lane, the PR (if any), the state, the transcript SHA, and a one-paragraph context (per *Error reporting* above).
     - Exits non-zero so the maintainer's shell sees the failure.
   - On clean exit (the PR reaches a terminal state or the driver is signalled), the transcript is preserved as a journal blob but no gardener message is appended.

   The transcript SHA gives the gardener a deterministic artifact to inspect via `git -C journal cat-file blob <sha>`. Recurring failure shapes (identical transcript prefixes) hash to identical SHAs, so the gardener's triage can short-circuit on a known SHA.

10. **Capture blob lifecycle.** The `git hash-object` blobs are unreferenced and subject to `git gc` after the journal's grace period (default 14 days). For failures we want to keep (recurring operational flakes), the `refs/captures/<role>/<pr>/<short-id>` anchor preserves them. The promotion criterion is open: every capture? Failures the LLM classifies as recurring? Maintainer-flagged?

    **Status:** Open. No disposition in the 2026-06-01 review pass.

## Non-goals

- **No change to the panel-review process itself.** Jurors and judges continue to do panel work the same way; only the dispatch / scheduling layer changes. A juror's brief is unchanged.
- **No change to upstream-side identity discipline.** The boatman remains the only role authorized to push under `kriskowal`; the driver layer does not alter this.
- **No change to the journal's role as transcript.** Each worker still writes `dispatch`, `result`, `tick`, `message` entries to `journal/entries/`. The driver state file at `journal/drivers/<repo>--<pr>.md` is supplemental.
- **No change to the design-to-PR pipeline's inventory step.** Detecting a new design and launching a driver is a supervisor responsibility; the inventory walk lives in the existing `skills/design-to-pr-pipeline/SKILL.md`.
