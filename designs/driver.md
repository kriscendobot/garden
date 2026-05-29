# design(driver): script-orchestrated PR-creation flow

| Created | 2026-05-29 |
| Author  | gardener   |
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

A driver is a bash process bound to one garden-authored PR. It is launched by the **driver supervisor** (a host-wide service or a `liaison`-driven dispatch) when a new garden-authored DRAFT PR is detected, and it exits when its PR is merged, closed without merging, or abandoned.

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

- `roles/driver/AGENT.md`: the driver's contract as a *script* rather than a *subagent operating brief*. Documents the state machine, the worker-pool relationship, the event sources, and the escalation pattern. The role is dispatchable in the sense that the supervisor launches drivers, but each driver is a bash process not an LLM session.
- `skills/driver-state-machine/SKILL.md`: the formal state diagram and transition predicates. Names which transitions are deterministic and which escalate to the LLM.
- `skills/prompt-on-failure-capture/SKILL.md`: the `git hash-object` / `git cat-file blob` capture pattern, prompt template shape, claude invocation, and known-SHA short-circuit.
- `skills/role-job-board/SKILL.md`: the role-specific job board contract. Extends the existing `skills/job-board/SKILL.md` with the per-role subdirectories.
- A `skills/$ROLE/$ROLE.sh` companion script for each role with a deterministic-enough body. Initially: `builder.sh`, `cleaner.sh`, `fixer.sh`, `weaver.sh`. The judges (`barrister`, `justice`, `solicitor`, `appellate`) and the conductor may have thinner scripts and more LLM body.

### Modified artifacts

- `roles/steward/AGENT.md` § PR-creation-flow scan: marked for retirement after driver migration completes. The scan exists because the chain breaks at role-seams; drivers subsume the seam-bridging. Phase-3 of the migration retires the scan.
- `roles/steward/AGENT.md` § Maintainer-feedback response (landed today): the trigger surfaces remain valid, but the action becomes "post a job to the appropriate role-specific board" rather than "Agent-dispatch a fixer or designer."
- `roles/general-contractor/AGENT.md`: re-scoped or retired. The contractor's slot machinery was per-cycle scan + dispatch; under drivers, foreground maintainer-facing visibility is the only remaining function. The design proposes retirement and absorption into the liaison.
- The existing `shepherd` role: unchanged in scope. The driver may invoke a shepherd worker for a CI-recovery substate when the state machine reaches `[await-ci-recovery]`.
- `skills/job-board/SKILL.md`: generalized to support per-role boards.
- `CLAUDE.md` § Current inventory: updated to add the driver role, the new skills, and the role-companion scripts.

### Migration plan

- **Phase 1: design + scaffolding** (this PR plus follow-ups). Lands `roles/driver/AGENT.md`, `skills/driver-state-machine/SKILL.md`, `skills/prompt-on-failure-capture/SKILL.md`, and the role-specific job board pattern. No live drivers yet.
- **Phase 2: one shape end-to-end.** Implement the driver for design-only PRs (the simplest state subset: solicitor only, no cleaner, no fixer-loop typically). Shake out on `endojs/endo-but-for-bots`. Steward continues to handle source-touching PRs.
- **Phase 3: source-touching support.** Implement the cleaner / barrister / fixer / justice / appellate substates. Drivers claim all garden-authored DRAFT PRs on the chosen repo. Steward's PR-creation-flow scan becomes a fallback (only acts on PRs without an active driver).
- **Phase 4: retire the scan.** Once drivers handle ≥95% of PR-flow advancement reliably, retire `roles/steward/AGENT.md` § PR-creation-flow scan. Steward becomes monitor-and-meta only (issue surveillance, maintainer-feedback routing to driver supervisor, bulletin housekeeping).
- **Phase 5: cross-repo rollout.** Extend to other monitored repos (`endojs/endo`, `agoric/agoric-sdk`) as their gating allows.

## Open questions

1. **Worker pool sizing.** One driver per active PR; what's the cap on concurrent drivers per host? One worker per role today (analogous to the host's single-cleaner cap); when do we need more?

2. **Failure modes for the LLM.** What if claude is rate-limited or unavailable when the driver escalates? Options: park the driver in `awaits-llm` state with a retry timer; surface to maintainer via the bulletin; fall back to the steward's old `Agent`-dispatched subagent shape as a degraded mode.

3. **Observability.** How does the maintainer see driver state? The proposal includes `journal/drivers/<repo>--<pr>.md` per-PR state files; a bulletin section summarizing active drivers; the existing journal-side `result` and `tick` entries from each worker invocation.

4. **Credentials and identity.** Workers run continuously as the bot identity. The existing host-pinned identity (`kriscendobot` on `kmkmbp2021`, `endolinbot` here) is preserved. Boatman is the special case as today; the boatman worker remains the only one authorized to switch identity.

5. **Tooling boundaries.** The driver invokes `gh`, `git`, `yarn`, etc. directly. Today some operations live inside subagent contexts (the cleaner reads test output via `Bash`). The driver runs them in the parent. Sandboxing? Resource limits? The host's existing pinning of `user.name` / `user.email` per worktree is one example of the same discipline.

6. **State machine determinism.** Some transitions today are LLM-classified: a maintainer's `COMMENTED` body needs reading to decide if it's substantive feedback (fixer dispatch) or chatter (no-op). The script needs either a deterministic fallback (always escalate to LLM with `<COMMENTED body>` capture) or a strict predicate (length-and-keyword filter). The design assumes escalate-on-ambiguous; the threshold is open.

7. **Relationship to standing monitors.** Existing standing-monitor daemons (per-repo bash poll daemons writing to `/tmp/garden-monitor-*.log`) remain. The driver subscribes to events from a per-PR fanout that the existing daemons feed. The `at-mention surveillance Monitor` becomes a router (forwards `@kriscendobot` mentions to the relevant PR's driver) rather than a parent-context Monitor in the orchestrator's session.

8. **Liaison and steward retention.** Both roles persist as meta-layer postures. The liaison remains the user-in-the-loop surface; the steward remains for cross-PR coordination, housekeeping, and the per-cycle survey of inbox and job board for items not driver-bound (boatman dispatches, gardener dispatches, scholar work, etc.). The steward's PR-creation-flow scan is the part that retires; the role itself does not.

9. **Driver supervisor.** Is the supervisor a bash daemon (analogous to `job-board-poll.sh`), a systemd unit, or a liaison-invoked process? The proposal assumes a bash daemon to match existing patterns, but the supervisor is a distinct conceptual layer worth deciding deliberately.

10. **Capture blob lifecycle.** The `git hash-object` blobs are unreferenced and subject to `git gc` after the journal's grace period (default 14 days). For failures we want to keep (recurring operational flakes), the `refs/captures/<role>/<pr>/<short-id>` anchor preserves them. The promotion criterion is open: every capture? Failures the LLM classifies as recurring? Maintainer-flagged?

## Non-goals

- **No change to the panel-review process itself.** Jurors and judges continue to do panel work the same way; only the dispatch / scheduling layer changes. A juror's brief is unchanged.
- **No change to upstream-side identity discipline.** The boatman remains the only role authorized to push under `kriskowal`; the driver layer does not alter this.
- **No change to the journal's role as transcript.** Each worker still writes `dispatch`, `result`, `tick`, `message` entries to `journal/entries/`. The driver state file at `journal/drivers/<repo>--<pr>.md` is supplemental.
- **No change to the design-to-PR pipeline's inventory step.** Detecting a new design and launching a driver is a supervisor responsibility; the inventory walk lives in the existing `skills/design-to-pr-pipeline/SKILL.md`.
