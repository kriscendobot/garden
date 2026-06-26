# design(driver): script-orchestrated PR-creation flow

| Created | 2026-05-29 |
| Updated | 2026-06-04 |
| Author  | gardener, fixer, designer |
| Status  | Proposed   |

## Update — 2026-06-03 contractor retirement

The `general-contractor` posture this design originally proposed to *preserve through the migration* (per the Migration plan and several § Architecture references below) was **retired** on 2026-06-03 per the maintainer's directive: *"I have dismantled the contractor. The role has not been working and I would like to reconstruct it on the driver. That is, that there will be a new, deterministic systemd service in the driver container that will poll the llm branch for new designs that are ready to be built and then post a job for a driver."*

What changes about this design:

- The contractor-side "preserved through migration" bullets are no longer accurate. Phase 5's planned per-system retirement does not need to wait on the contractor; that retirement already happened.
- The slot-machinery + design-queue-walk function the contractor used to do is reconstructed in the v2 job system as the **triager/poller producer + gardener pool**: the producer walks the project's roadmap branch (today `endojs/endo-but-for-bots:llm`) on a cadence, filters for designs that are *ready to be built*, and posts a `build` job to the journal-backed board that a gardener claims. (The interim `garden-design-poller` systemd daemon proposed here was never ported to v2 — its unit crash-looped on a missing `scripts/daemons/design-poller.sh` and was retired 2026-06-26; the `design-poller` skill is marked superseded by the v2 triager/poller producer + gardener pool in `designs/v1-migration-manifest.md`.)
- The `roles/general-contractor/AGENT.md` file was deleted as part of the retirement. References below to that role file are historical; do not chase the link.

The rest of the design stands. The driver lane architecture, the state machine, the worker pool, the prompt-on-failure capture pattern, the gardener-inbox error reporting, the watcher subscription model, the deterministic reactji and worktree disciplines, and the driver-run pre-CI validation are all unchanged. The seam the contractor's retirement opened is filled in v2 by the triager/poller producer + gardener pool described above.

## Summary

Pivot the garden's PR-creation flow from **claude-on-top** orchestration (the steward and contractor wake on cron, run an LLM tick to scan state, and dispatch subagents via the `Agent` tool) to **claude-under-script** orchestration: a pool of bash worker scripts watches a generic job inbox, claims jobs deterministically, and runs a state machine that invokes claude only when judgment is needed (failure diagnosis, ambiguous classifications). Each invocation captures its failure log via `git hash-object -w --stdin` and passes the SHA into the prompt; claude reads the log on demand via `git cat-file blob`.

The driver is **a script, not a role.** It is a bash program (`scripts/driver/driver.sh <lane>`) that pulls jobs off a generic job inbox, specializes its behavior by the job kind, runs a state machine to completion (or escalation), and delegates judgment-bearing substeps (build, fix, design, classify ambiguous verdicts) to ephemeral subagents invoked via `claude -p`. The script's loop is the orchestrator; the LLM is the worker the script calls when it cannot decide deterministically.

The orchestration system has two daemon shapes, both managed by systemd:

1. **A persistent driver pool.** A maintainer-configured quantity of driver processes, each invoked with a distinct lane number (`scripts/driver/driver.sh 1`, `scripts/driver/driver.sh 2`, ...). Each driver's lifetime spans many jobs and many PRs, not one PR. A driver consumes the generic job inbox, claims one job at a time, runs it to completion, and returns to claim the next.

2. **One daemon per upstream activity feed.** A single deterministic watcher process per activity source (a repo's webhook stream, a poll loop for repos without webhooks, the review-queue feed, an assigned-issues feed). Each watcher translates upstream events into message dispatches to the appropriate inboxes and posts deterministic reactji (`:eyes:`) on first observation. There is exactly one watcher per activity feed across the host, not one per repo and not one per role.

The existing `shepherd` role (CI-to-green) is unchanged and may be the body of work a driver runs when it claims a CI-recovery job.

## Layout pivot: scripts/ at the top level

The garden's top-level directories sort by audience. **Roles and skills** under `roles/` and `skills/` are agent context fragments: they exist to hydrate an ephemeral subagent's context with operating instructions and playbooks. **Scripts** belong in their own top-level directory, `scripts/`, that the maintainer and the systemd unit files read directly. Mixing the two surfaces is the friction the 04:19Z review surfaces: a driver is not a subagent operating brief, it is a program a human or a unit file runs.

```
scripts/                              # executable shell scripts for humans + systemd
  driver/
    driver.sh                         # the per-lane driver entry point
    README.md                         # human-oriented: what it does, how to run it,
                                      # how it integrates with systemd, the lane convention
  watcher/<feed-slug>/
    watcher.sh                        # one watcher per activity feed
    README.md                         # what feed it observes, what messages it appends,
                                      # the reactji policy, the subscription contract
  daemons/
    start.sh                          # bring up the configured set of drivers + watchers
    stop.sh                           # take them down cleanly
    status.sh                         # report which units are active, which lanes are bound,
                                      # which feeds are watched
    README.md                         # human-oriented start/stop guide; systemd integration
  systemd/
    garden-driver@.service            # templated unit, %i = lane number
    garden-watcher@.service           # templated unit, %i = feed-slug
    README.md                         # where to drop unit files, what
                                      # `systemctl --user enable garden-driver@1.service`
                                      # looks like, how to reload, where logs land

roles/                                # unchanged: per-role AGENT.md for ephemeral subagents
skills/                               # unchanged: per-skill SKILL.md playbooks for subagents
```

The split is strict: `roles/` and `skills/` hold no executables; `scripts/` holds no agent-only context fragments. A subagent the driver delegates to still reads `roles/<role>/AGENT.md` to know how it operates; the driver itself reads only its own `scripts/driver/README.md` (for humans) and the state-machine skill files (which are still agent context, consumed when the LLM is invoked, not by bash).

**This dispatch does not move existing files.** Articulating the layout here is enough for the reviewer to confirm the shape; a follow-up implementation dispatch lands the moves (`roles/driver/` → `scripts/driver/`, the watcher daemons that today live behind the standing-monitor system into `scripts/watcher/<feed>/`, the new `scripts/daemons/` and `scripts/systemd/` directories). The migration plan below tracks the move.

## systemd-managed daemons

Both daemon shapes (driver pool, activity-feed watchers) are managed by systemd user units. The maintainer runs `systemctl --user enable garden-driver@<N>.service` for each driver lane wanted, and `systemctl --user enable garden-watcher@<feed>.service` for each feed wanted. systemd handles restart-on-failure, log capture via the journal, and clean shutdown on host reboot.

### Driver pool

A templated unit `garden-driver@.service` instantiates one driver per lane:

```ini
# scripts/systemd/garden-driver@.service
[Unit]
Description=Garden driver lane %i
After=network-online.target

[Service]
Type=simple
WorkingDirectory=%h
ExecStart=%h/scripts/driver/driver.sh %i
Restart=on-failure
RestartSec=30s
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=default.target
```

The maintainer enables N lanes by `systemctl --user enable garden-driver@1.service garden-driver@2.service ...` and starts them via `systemctl --user start ...`. The pool size N is a maintainer-set quantity per the 04:08Z review's "some configured quantity of persistent drivers"; the maintainer scales it by enabling additional lane numbers (per the prior Q1 / Q3 dispositions: "I will manually scale the pool").

Each driver lane is persistent: its lifetime is the host's uptime (modulo systemd-driven restarts on failure), not one PR. A lane claims a job, runs it, and returns to the inbox poll. Lane-to-PR binding is per-job, not per-driver.

### Per-activity-feed watcher daemons

A templated unit `garden-watcher@.service` instantiates one watcher per feed slug:

```ini
# scripts/systemd/garden-watcher@.service
[Unit]
Description=Garden activity-feed watcher (%i)
After=network-online.target

[Service]
Type=simple
WorkingDirectory=%h
ExecStart=%h/scripts/watcher/%i/watcher.sh
Restart=on-failure
RestartSec=30s
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=default.target
```

The maintainer enables one watcher per feed: `systemctl --user enable garden-watcher@endo-but-for-bots.service garden-watcher@review-queue.service ...`. There is one watcher per activity source; multiple repos under one webhook stream share a watcher, multiple feeds with independent polling cadences run independent watchers.

A watcher's responsibilities:

1. **Poll its single feed.** A webhook stream, a `gh api` poll loop, the review-queue endpoint, or any other activity source.
2. **Classify events.** Push, review submission, comment, label change, assigned-issue, CI status, etc.
3. **Append messages to the right inboxes.** A reviewer comment on a driver-subscribed PR goes to that driver's per-PR event log; an assigned-issue lands on the steward's job-board hook; an unsubscribed PR's events go to a default supervisor inbox.
4. **Post deterministic reactji** (`:eyes:` on a new comment) immediately as part of the event handler, before routing the message anywhere. The reactji is a synchronous part of the watcher's loop; no LLM in the path.
5. **Self-heal on transient feed failures** by relying on systemd's `Restart=on-failure` policy; persistent failures escalate to the gardener inbox per the uniform error-reporting pattern.

The single-watcher-per-feed shape (rather than per-repo or per-role) is the 22:20Z review's "coalesce our repository activity watcher into a single process" reinforced by the 04:08Z review's "a single daemon for watching each activity feed". One watcher process owns one polling rate budget, one event schema, one reactji policy. Replacement of today's per-repo standing-monitor daemons (`/tmp/garden-monitor-*.log` writers) by the coalesced watchers is migration plan Phase 5.

### Start, stop, status, and log review

Human-invocable wrappers around `systemctl --user` for maintainers who prefer a script over remembering unit names:

- `scripts/daemons/start.sh` enables and starts the configured set of driver lanes and watchers.
- `scripts/daemons/stop.sh` stops them cleanly (driver lanes drain their currently-claimed job first; watchers stop on the next polling cycle boundary).
- `scripts/daemons/status.sh` reports unit state, which lanes are bound to which jobs, which feeds are watched, and the last-event-seen timestamps.
- `scripts/daemons/logs.sh` is the manual-review helper: tails `journalctl --user-unit garden-driver@*.service` and `journalctl --user-unit garden-watcher@*.service` with sensible filters; a `--lane <N>` filter narrows to one lane; a `--feed <slug>` filter narrows to one watcher. Deeper-investigation paths (capture-SHA lookups, transcript reconstruction) compose on top.

The maintainer configures the desired set of lanes and feeds once in a host-local config (`scripts/daemons/config.sh` or equivalent shell-sourceable file), and `start.sh` reads that config. The 04:08Z review's "scripts for reviewing logs both manually and for deeper investigation" is satisfied by `logs.sh` plus the existing transcript-SHA pattern documented under *Prompt-on-failure capture pattern* below.

### Self-healing

The two-layer self-healing strategy:

- **Systemd-layer** restart-on-failure for drivers and watchers handles transient crashes. The 30-second `RestartSec` is enough to avoid restart storms while keeping the service available.
- **Driver-layer** error reporting (the gardener-inbox pattern) escalates problems systemd cannot fix on its own. A persistent crash loop, a watcher's repeated feed-auth failure, or a driver's repeated terminal failure all land messages on `journal/inboxes/<host>/gardener.md` with the captured transcript SHA. The 04:08Z review's "submit a job for a driver to fix problems and restart the relevant systemd drivers" lands as follows: the gardener-inbox handler can post a job to the inbox describing the failed unit; a driver claims the job, diagnoses, lands a fix-PR or restarts the unit via `systemctl --user restart`, and journals the outcome.

The system is **relatively** self-healing, not fully autonomous: human triage remains the loop closer for shape-changing failures.

### Worktrees per daemon

Both drivers and watchers run from their own long-lived worktrees, not from per-dispatch ephemeral triples. The driver's worktree is the one its lane was launched from; the watcher's worktree is dedicated to its feed. The per-dispatch worktree triple (`garden/`, `journal/`, `project/`) is still created by drivers as needed when they invoke a subagent or run a worktree-requiring substate, but the daemon process itself runs from a stable long-lived worktree so systemd's `WorkingDirectory` and the unit files can name a fixed path. The exact worktree layout for daemons is an implementation detail of the move-files follow-up; this design names the requirement (each daemon has a dedicated worktree) rather than the specific paths.

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

The deterministic steps are no-LLM. Watching for events, reading PR state, running tests, formatting, pushing commits, posting reactjis, the basic git plumbing: all bash. The LLM gets called when the script reaches a step whose output it cannot interpret on its own.

### Why now

Two motives compound. First, **token cost**: most cycles do no substantive work but pay full per-cycle LLM cost. Second, **reliability**: the cycle interval is the floor of hand-off latency; reducing it via shorter cycles would multiply the token cost without addressing the underlying inefficiency. The script-driven pivot addresses both at once.

## Principle

The driver is **a bash script that drives a state machine and delegates judgment.** It is not a role: a role is an agent context fragment; the driver is a program. The driver:

1. Polls the generic job inbox at `journal/jobs/open/` and claims one job at a time via the existing claim-via-push race.
2. Reads the job's `kind` (PR-creation, observed-error response, issue response, build request, design request, retcon/rebase) and looks up the corresponding workflow state machine.
3. Runs the workflow's state machine. Deterministic transitions (worktree setup/teardown, `yarn format`, `gh pr view`, push-to-branch, reactji read-back from the watcher's log) run inline as bash. Judgment-bearing substeps (build, fix, design, classify an ambiguous verdict) delegate to an ephemeral subagent via `claude -p` with a four-slot brief that names the PR, the design, the role, the state, and any capture SHA.
4. On a worker's or subagent's `result`, advances the state machine and continues until the workflow reaches a terminal state.
5. On a failure the script cannot interpret, captures the log via `git hash-object`, constructs the prompt-on-failure brief, and invokes claude.
6. On clean completion, returns to step 1 and claims the next job.

The driver is not an LLM session; the LLM is a substep the driver calls when it cannot decide deterministically. **Many drivers run in parallel** as systemd-managed lanes (`garden-driver@1.service`, `garden-driver@2.service`, ...); each lane is a long-lived process whose lifetime spans many jobs and many PRs. A driver is not bound to a single PR for its lifetime; the binding is per-claimed-job, not per-process.

The PR-creation workflow's state machine (the next subsection) is the canonical example, not the only workflow a driver runs. *Multi-job-kind drivers* below enumerates the other workflows and the dispatch-by-job-kind shape that selects the right state machine on claim.

## Architecture

### Generic job inbox and the driver pool

The driver pool *is* the worker pool. There is one inbox (`journal/jobs/open/`) and one kind of worker (the driver). The 04:10Z review reframes the old per-role-board design: instead of N role-specific job boards each polled by a role-specific worker process, there is a single generic inbox and a pool of generic drivers that specialize their behavior by the job's `kind` field at claim time.

A job's frontmatter names its kind:

```yaml
---
kind: pr-creation           # or: observed-error | issue-response | build-request |
                            #     design-request | retcon-rebase | ci-recovery
pr: kriskowal/garden#3      # optional, when the job is about a specific PR
state: clean                # optional, for resume after a crash
posted_by: watcher@review-queue
posted_at: 2026-06-02T20:48:00Z
---

<one-paragraph brief: what the driver should know to start>
```

The driver's outer loop:

```sh
while true; do
  CLAIM=$(skills/job-board/claim-job.sh)
  [ -z "$CLAIM" ] && { sleep 30; continue; }
  KIND=$(yq '.kind' "$CLAIM")
  WORKFLOW_SKILL=skills/driver-${KIND}-state-machine/SKILL.md
  ( set -x
    run_workflow "$CLAIM" "$WORKFLOW_SKILL"
  ) 2> "$TRANSCRIPT"
  rc=$?
  if [ "$rc" -eq 0 ]; then
    skills/job-board/complete-job.sh "$CLAIM"
  else
    skills/job-board/abandon-job.sh "$CLAIM"
    report_to_gardener "$LANE" "$CLAIM" "$TRANSCRIPT"
  fi
done
```

`run_workflow` reads the workflow skill, runs the state machine, and dispatches to subagents via `claude -p` for substeps that need judgment. Deterministic steps (worktree setup, `yarn format`, the pre-CI gauntlet, `gh pr view`, push) run inline. The 22:20Z review's "certain activities like setting up and tearing down worktrees should be deterministic and run by the driver" lands here: every worktree call is an inline bash call, not a subagent step.

Pool size N is a maintainer-set quantity (per Q1 disposition: "I will manually scale the pool"). Each lane is `garden-driver@<N>.service`. Concurrency caps on operations that need single-flight discipline (one cleaner per estate, one boatman per host) are enforced inside the workflow's state machine via a lock file or a job-board claim on a singleton lock job, not by per-role process count.

### The generic job inbox

The job inbox is the existing `journal/jobs/{open,claimed,done,abandoned}/` directories, unchanged in shape. The `kind` field on each job's frontmatter is the discriminator the driver reads at claim time to pick the workflow. Per-role subdirectories that an earlier iteration of this design proposed (`journal/jobs/<role>/open/`) are **not** part of the pivoted shape: a single inbox + generic drivers + job-kind discrimination is the simpler model the 04:10Z review describes ("a generic inbox for all drivers ... specializes its behavior on the kind of message that was left in its inbox").

The claim-via-push race documented in `skills/job-board/SKILL.md` is the serialization point. Concurrent drivers across lanes race to claim; rejected claims back off without retry.

### Subagent dispatches for judgment-bearing substeps

A driver invokes `claude -p` for substeps that need LLM judgment. Each invocation receives a four-slot brief (PR identifier, design path, role, state, capture SHA if any) and the role's `AGENT.md` content pre-loaded. The subagent runs ephemerally: it returns a result (a patch, a classification, a verdict), the driver applies it, and the subagent context ends.

The roles whose subagent-side bodies a driver invokes:

- **builder, fixer, designer, weaver, shepherd, conductor, cleaner, boatman**: the existing source-touching, design-drafting, and PR-progression roles. Their `AGENT.md` files in `roles/<role>/` remain the operating brief the subagent reads; the driver invokes them as ephemeral subagents, not as long-lived workers.
- **barrister, justice, solicitor, appellate, plus jurors**: the judging roles. Driver invokes them for panel substates.

Each role's `AGENT.md` stays as agent context. No role becomes a long-lived script; the driver is the only long-lived script. The 04:19Z review's "reserving role and skill for agent context fragments" lands here.

### Drivers

A driver is a bash process running as a systemd-managed lane (`garden-driver@<lane>.service`). Its lifetime is the host's uptime modulo systemd-driven restarts; it spans many jobs and many PRs. A driver is also invocable manually via `scripts/driver/driver.sh <lane>` for development, ad-hoc work, and bring-up before the unit files are enabled (per Q9 disposition: the driver is a script invocable by hand or by systemd, not a daemon launched by a separate supervisor process).

A driver does **not** exit when one PR merges. It marks the job done, releases the per-job state, and returns to the inbox poll. It exits only on:

- Systemd asking it to (`systemctl --user stop garden-driver@<lane>.service`).
- An unexpected trap (`ERR` / `EXIT` with discrimination on `$?`) that escalates to the gardener inbox per *Error reporting* above; systemd then restarts the unit per its `Restart=on-failure` policy.
- A clean shutdown request from the maintainer (a SIGTERM that lets the currently-claimed job drain first).

The driver's per-job responsibilities:

1. **Claim a job.** Poll `journal/jobs/open/` via `skills/job-board/claim-job.sh`; on a successful claim, move the job to `claimed/` and read its frontmatter (`kind:`, `pr:`, `state:` if resuming a long-running workflow, etc.).
2. **Select the workflow.** Look up the state machine for the job's `kind`. Each workflow's state machine lives at `skills/driver-<workflow>-state-machine/SKILL.md`; the driver consults it on each transition.
3. **State persistence.** While the driver works the job, it writes its in-progress state to `journal/drivers/<host>/<lane>.md` after every transition. The state file is the canonical record of where this lane currently is. On a clean job completion, the in-progress section is archived (or trimmed); on a crash, the state file is the entry point the next driver instance reads to decide whether to resume or escalate.
4. **Event subscription.** For workflows that depend on upstream events (PR-creation in `[await-maintainer]`, for example), the driver subscribes to its PR by writing a stanza to `journal/drivers/<host>/<lane>.subscriptions`. The coalesced repo-activity watcher reads the union of all driver subscriptions and routes per-PR events to per-driver event logs at `journal/events/<repo>--<pr>.log`. The driver tails its own event log as it processes a job that involves a PR.
5. **Sub-dispatch.** When a state transition requires LLM judgment (build, fix, design, classify), the driver invokes `claude -p` with the four-slot brief. The subagent runs ephemerally, returns its result, the driver advances the state machine.
6. **Result and progress journaling.** Each transition emits a `tick` entry; each terminal state emits a `result` entry; unexpected exits emit a `message` entry to the gardener inbox with the captured transcript SHA.
7. **Failure escalation.** If the script reaches a state whose deterministic predicate cannot resolve the next transition (ambiguous CI failure, contested review classification, conflict with multiple plausible resolutions), the driver invokes claude with a prompt-on-failure capture (see below).
8. **Return to step 1.** On clean job completion, the driver releases per-job state and polls the inbox for the next job.

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
- `[design]`: the design document is being drafted (designer subagent in flight).
- `[build]`: the PR is being opened (builder subagent in flight).
- `[clean]`: the PR is OPEN, DRAFT, no panel verdict yet, cleaner subagent in flight or pending.
- `[panel]`: cleaner has pushed, CI is green, no panel verdict yet; the right judge subagent (barrister for source PRs first time, solicitor for design-only, justice for source-after-fixer) is in flight or pending.
- `[verdict]`: a panel verdict has been submitted as a formal `kriscendobot`-authored review.
- `[fixer]`: panel verdict carries `must-fix-loop` items; fixer subagent in flight or pending.
- `[justice]`: fixer push has landed since last panel verdict; justice subagent re-runs the panel.
- `[appellate]`: terminating verdict; appellate considers promotions before un-draft.
- `[un-draft]`: `gh pr ready <N>` ran; PR is now ready for review.
- `[await-maintainer]`: PR is OPEN, not draft; waiting for a maintainer review event.
- `[changes-requested]`: maintainer event landed with `CHANGES_REQUESTED` (or substantive `COMMENTED`); appropriate response subagent (fixer for source, designer for design-only) dispatches.
- `[approved+green]`: maintainer event landed with `APPROVED` and CI is green; conductor subagent merges.
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
4. The driver exits non-zero. Restart policy is systemd's: `garden-driver@<lane>.service` has `Restart=on-failure` with a 30-second backoff, so the lane comes back automatically. The maintainer is the next responder if the same lane crashes repeatedly (the gardener inbox accumulates the captures).

This pattern is uniform across the driver, the activity-feed watchers (`garden-watcher@<feed>.service`), and any helper scripts the daemons invoke. Anything that is not the LLM-judgement substate inherits the same error fan-out.

### Watcher subscription model and event routing

The §_systemd-managed daemons_ section names the watcher daemon shape (one `garden-watcher@<feed>.service` per activity feed). This subsection covers the architecture detail: how a watcher learns which PRs are subscribed, how it routes events, and how it replaces today's per-repo standing-monitor daemons (per-repo bash poll daemons writing to `/tmp/garden-monitor-*.log`).

The 22:20Z review's "coalesce our repository activity watcher into a single process" and the 04:08Z review's "a single daemon for watching each activity feed" together name the shape. "Single process" is per-feed, not per-host: a host runs as many watcher processes as there are activity feeds, but exactly one watcher per feed. Multiple repos behind one webhook stream share a watcher; a repo polled directly is one watcher's responsibility.

Subscription model:

1. Each driver, while working a job that depends on event-driven progress (a PR-creation workflow in `[await-maintainer]`, an issue-response workflow tailing for replies), advertises its subscription by writing a stanza to `journal/drivers/<host>/<lane>.subscriptions`. The stanza enumerates `repo:pr` pairs or `repo:issue` pairs.
2. Each watcher reads the union of all driver subscriptions for the repos in its feed on each polling tick. The union determines the watcher's fanout: which PRs and issues to poll, and which inboxes (per-driver event logs) to deliver events to.
3. When the watcher detects a new event (CI status change, review submission, push, comment), it deterministically classifies the event and appends a message to the subscribed driver's per-PR event log at `journal/events/<repo>--<pr>.log`.
4. Events with no subscribed driver (a brand-new garden-authored DRAFT PR, a newly assigned issue, a maintainer comment on an idle PR) land on a default supervisor inbox that turns into a new posted job on `journal/jobs/open/`. Any driver lane then claims the job and binds.

Each watcher also owns:

- **Deterministic reactji posting** (see next subsection). The watcher is the single program that posts `:eyes:` on a new comment for the repos it covers; previously this was an agent-task and was unreliable.
- **Per-event message routing**: a `@kriscendobot` mention routes to the subscribed driver's event log; an assigned-issue event routes to a posted issue-response job on `journal/jobs/open/`; an issue body mention routes elsewhere per the watcher's routing table.

Each watcher runs from its own long-lived worktree (per the §_Worktrees per daemon_ note above) and self-heals via the systemd `Restart=on-failure` policy. Persistent feed-auth failures escalate to the gardener inbox per the uniform error-reporting pattern.

The watcher set together subsumes today's per-repo poll daemons, but the substitution is **per feed**, not aggregated to a single host-wide process: the operational coupling between, say, the `endo-but-for-bots` webhook stream and the `review-queue` poll endpoint is zero, so they are independent units. The benefit is one polling rate budget per feed (matched to that feed's natural cadence), one place to land per-feed event-format changes, and a deterministic single source of truth for "this event was seen at SHA X at time T" per feed.

### Deterministic reactji posting

Posting reactji on PR comments today is a soft-real-time responsibility that falls to whichever agent picks up an event next. It is unreliable: the `:eyes:` reactji that acknowledges "the garden has seen this comment" can be delayed by minutes if no agent is scheduled.

Under the driver design, the **per-feed activity watcher** owns reactji posting deterministically:

- New comment detected → `:eyes:` reactji posted immediately as part of the watcher's per-event handler, before routing the message to a driver event log.
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

0. **`scripts/checks/run-all.sh`** (the pre-dispatch grep gates). Each gate under `scripts/checks/<gate-name>/` is a recursive grep that exits non-zero only when a known historical mistake is present, paired with a focused `claude -p` prompt the runner dispatches on a hit. The runner short-circuits before any heavyweight step burns time, and a gate that fires gets a small, focused agent context instead of the parent's. Per `skills/pre-dispatch-grep-gate/SKILL.md` for the contract; per `scripts/checks/README.md` for the installed set.
1. `yarn format` (auto-fix in place; if anything is dirty after, the driver stages and commits the format changes as part of the same push).
2. **Tests relevant to the changes**: a targeted run against the touched packages (e.g., `yarn workspace @endo/<pkg> test`) for fast feedback.
3. `yarn build:types:check` (typecheck the whole monorepo).
4. `yarn lint` (full lint pass).
5. **Full test run** across all packages.
6. **Docs generation** (`yarn docs` or equivalent).

Only after all seven steps pass does the driver push to the PR branch. CI then runs the same set; the driver's local pass is a precondition that catches the bulk of avoidable red-CI handoffs.

When a step fails, the driver either:

- Auto-fixes and re-runs (for `yarn format`).
- Captures the failure log via `git hash-object`, escalates to claude with the prompt-on-failure pattern, applies the response, and re-runs.
- After two unsuccessful escalations, parks the driver, reports to the gardener inbox, and exits.

The class of "I had to ask for `yarn format` again" cannot survive this gate. The class of "tests failed in CI but never locally" reduces to a CI-only environmental shape, which is a much narrower problem.

### Multi-job-kind drivers

A driver picks up *many kinds of job* on a single generic inbox; the job's `kind` field is the discriminator that selects the workflow state machine. The categories the design recognizes (each is a `kind:` value the watchers or the maintainer post):

1. **`pr-creation`**: garden-authored PR shepherding from `[initial]` through `[merged]` per the state machine above. The job's `pr:` field names the PR; the job persists across many driver claims (each claim works the current state once, then releases until the next watcher event posts a follow-up job for the same PR).
2. **`observed-error`**: a triage job posted by the gardener-inbox handler when a captured transcript merits investigation. The job's body names the transcript SHA; the driver investigates, classifies, and lands a fix-PR, files an issue, or escalates.
3. **`issue-response`**: respond to an issue (read, classify, draft a reply or a fix-PR, post). The job's `issue:` field names the issue.
4. **`build-request`**: satisfy a request to build (analogous to the existing builder dispatch). The job's body carries the build brief.
5. **`design-request`**: satisfy a request to design (analogous to the existing designer dispatch). The job's body carries the design brief.
6. **`retcon-rebase`**: a fixer-retcon or weaver-rebase job. The job's `pr:` field names the PR.
7. **`ci-recovery`**: a CI-to-green job; the driver runs the shepherd workflow.
8. **`gardener-task`**: a meta-evolution request (encode a rule, retire a role, audit cited paths, fold a panel's `[proposed-rule]` note into a skill). The job's body names the directive verbatim plus any precipitating evidence the producer cited. The gardener lane runs the workflow at `skills/driver-gardener-workflow/SKILL.md`. Only gardener lanes claim from `journal/jobs/gardener/open/`.
9. **`librarian-task`**: a library-ingest, library-audit, or library-shortcut request. The job's body names the source document and the requested action (ingest a new source page, prune distractions on a concept page, grow a keyword shortcut). The librarian lane runs the workflow at `skills/driver-librarian-workflow/SKILL.md`. Only librarian lanes claim from `journal/jobs/librarian/open/`.

Classification of *which workflow to run* is by **frontmatter `kind:` lookup first**, by inference second. When the frontmatter names a kind, the script short-circuits the LLM. When it does not (a free-form job the maintainer posted), the driver invokes claude to classify the job's body into one of the kinds; the classification SHA is recorded so identical briefs reuse the verdict (per Q6 disposition: escalate-on-ambiguous, cache by SHA).

### Workflow state-machine skills

The driver does not run *one* workflow; it runs the workflow appropriate to the job's `kind`. Each workflow is a state machine fragment with its own predicates:

- **PR-creation workflow** (the canonical state machine above): initial → design → build → clean → panel → verdict → fixer/justice/appellate → un-draft → await-maintainer → changes-requested or approved+green → merged.
- **Issue-response workflow**: triage → classify (bug / feature / question / noise) → either draft-and-post-reply (for question / noise) or open-fix-PR (for bug / feature, which posts a `pr-creation` follow-up job).
- **Build-request workflow**: read the request → check feasibility → if feasible, run the builder subagent and post a `pr-creation` job for the new DRAFT; if not, reply with the blocker.
- **Design-request workflow**: read the request → check existing designs for conflicts → run the designer subagent to draft the design document → open the design-only DRAFT PR (posting a `pr-creation` job with the solicitor / design-panel branch).
- **Retcon / rebase workflow**: read the target PR → run the fixer subagent (retcon) or weaver subagent (rebase) → push → post a follow-up `pr-creation` job at the post-push state.
- **Gardener workflow**: idle → on tick, drain `journal/inboxes/<host>/gardener.md` and scan `journal/jobs/gardener/open/` → if either yields work, classify (panel `[proposed-rule]` to encode; library gap to grow; role-file scrub; inventory drift to repair; routine meta-edit) → invoke the gardener subagent against the engagement brief → write a `result` entry and commit any role / skill / top-level edits → idle. The workflow lives at `skills/driver-gardener-workflow/SKILL.md`.
- **Librarian workflow**: idle → on tick, drain `journal/inboxes/<host>/librarian.md` and scan `journal/jobs/librarian/open/` → classify (ingest a new source; prune a concept page; grow a keyword shortcut; index on the fly) → invoke the librarian subagent → write a `result` entry and commit library edits → idle. The workflow lives at `skills/driver-librarian-workflow/SKILL.md`.

Each workflow's predicates live in `skills/driver-<kind>-state-machine/SKILL.md` (one per workflow kind). The skills are tiny; their job is to enumerate the states and the transition predicates. The driver's outer body reads the workflow's skill on entry and consults it on each transition. These skills are agent context (they hydrate the LLM substep) and stay under `skills/`; the executable that consults them is under `scripts/driver/`.

### Role-prefixed lanes

The lane identifier generalizes from a positive integer to `<role>-<N>`. The role prefix is the canonical handle for *which* role-specific inbox and job board the lane subscribes to; the trailing index distinguishes multiple lanes for the same role on one host. Existing PR-work lanes (`1`, `2`, `3`) are aliased to `builder-1`, `builder-2`, `builder-3` for backward compatibility during the transition, then renamed to the canonical form once all consumers (the journal indexer, the daemons-script, the watchers) understand the new shape.

The role prefix is the discriminator for three resources:

1. **Role-specific job board**: a lane named `<role>-<N>` claims from `journal/jobs/<role>/open/` rather than from the generic `journal/jobs/open/`. The role boards are first-class siblings of the generic board; the generic board is retained for liaison-staged work that does not target a specific role's pool.
2. **Role-specific inbox**: a lane named `<role>-<N>` drains `journal/inboxes/<host>/<role>.md` via `skills/inbox-drain/inbox-drain.sh <role>`. The inbox is the lane's message channel from other lanes, from the maintainer, and from the steward's coordination dispatches. The inbox drain runs alongside the job-board poll on each tick.
3. **Per-lane state file**: the existing `journal/drivers/<host>/<lane>.md` shape is unchanged in path; the schema gains a `role:` field (parsed from the lane prefix) and a `cadence_seconds:` field (per-lane adjustable pace; default per the role's typical workload but editable on the file). A `paused: true` field skips the lane's tick body without exiting the loop, so a maintainer can quiesce a lane without killing the systemd service.

Adjustable per-lane cadence: the `cadence_seconds:` field in the state file. The driver reads it at the top of each loop iteration; an edit to the file lands on the next tick. Default values per role:

| Role         | Default cadence | Why                                                                                                       |
| ------------ | --------------- | --------------------------------------------------------------------------------------------------------- |
| `builder`    | 30s             | PR-work lanes need to react to watcher events promptly; the existing `DRIVER_TICK_SECONDS` default.       |
| `fixer`      | 30s             | same shape as `builder`.                                                                                  |
| `weaver`     | 30s             | same shape.                                                                                               |
| `librarian`  | 300s            | library walks are slow-changing; a 5-minute cadence is generous and the librarian's inbox is the wake.    |
| `gardener`   | 180s            | the gardener's wake is dominated by inbox messages; 3 minutes keeps token cost low without missing asks.  |

The defaults are not load-bearing; editing the state file overrides them. A maintainer who wants the gardener-1 lane to respond faster during a focused engagement bumps the cadence down; the next tick respects it.

#### Lane caps

The gardener role has a per-host cap of **one** lane: there is only one canonical gardener observer per host, and concurrent gardener lanes would race on the same `journal/inboxes/<host>/gardener.md` state and on garden-meta file edits in `roles/` and `skills/`. The cap is enforced by the daemons-script's lane registry; an attempt to launch `gardener-2` is refused with a clear error.

The librarian role's cap is **two** initially (one primary plus one for parallel library walks during catch-up); the cap can grow as the library's ingest rate justifies it. The daemons-script's lane registry encodes the cap; growing it is a config edit, not a code edit.

PR-work roles (`builder`, `fixer`, `weaver`) have **no** hard cap; the host's CPU and the driver-design's general concurrency rules govern (the cleaner-cap-1 across the estate continues to apply for the cleaner stage specifically).

#### One-off interactive variants

The maintainer's interactive `claude` sessions in the garden root continue to enter the `gardener` and `librarian` roles as before. The autonomous lanes do not replace the interactive form; they coexist. The interactive session reads the role file at session start; the autonomous lane reads it at lane-launch time. Both forms write to the same journal, the same role files (subject to authority bounds), and the same library; the difference is just *who initiates the work*: the interactive session is driven by the maintainer's prompt; the autonomous lane is driven by an inbox message or a job-board posting.

When both an interactive gardener and a `gardener-1` lane are active on the same host, they coordinate via the inbox: the gardener-1 lane's `inbox-drain` may surface the same messages the interactive session is also processing. The discipline is the same as for any concurrent reader: the first to push a `result` entry to `origin/journal` claims the work; the second sees the result and stands down. The `paused: true` field on the lane's state file is the maintainer's clean handoff: pause the autonomous lane while the interactive engagement runs, then resume.

### Prompt continuity

Every prompt the driver emits to a `claude -p` substep names:

- The PR identifier (URL).
- The design document path (relative to garden root) or `(none)`.
- The role whose `AGENT.md` the subagent should read (`builder`, `fixer`, `designer`, etc.).
- The state machine state.
- The capture SHA (if any).

The role's `AGENT.md` is the subagent's operating brief, read at the start of the subagent context per the existing dispatch contract. The driver's per-job context is the four-slot brief above. The LLM treats each invocation as a focused micro-task rather than a fresh subagent context boot of an orchestrator.

## What changes in the existing library

### New artifacts

Under the §_Layout pivot: scripts/ at the top level_ shape, the new artifacts split between `scripts/` (executable, for humans + systemd) and `skills/` (agent context, for `claude -p` substeps).

**Executable scripts (`scripts/`)** :

- `scripts/driver/driver.sh`: the driver entry point. Takes a lane number as its first argument; wraps its inner body in a `-x` subshell that captures a transcript; traps `ERR` and `EXIT` to fan unexpected failures out to the gardener inbox with the transcript SHA. Invocable manually (`scripts/driver/driver.sh 1`) or by systemd (`garden-driver@1.service`).
- `scripts/driver/README.md`: human-oriented overview of the driver script (what it does, how to launch a lane, how systemd integrates, how to read the per-lane state file, where the transcript lands on failure). Distinct from the agent-context state-machine skills.
- `scripts/watcher/<feed>/watcher.sh`: one per activity feed. Polls the feed, classifies events, appends messages, posts reactji. The initial feed slugs the design names: `endo-but-for-bots` (webhook stream), `endo-but-for-bots-poll` (poll fallback), `review-queue`, `assigned-issues`. Each feed's watcher has its own README.
- `scripts/watcher/<feed>/README.md`: human-oriented per-feed overview (what the feed delivers, what messages the watcher appends, the reactji policy, the subscription contract).
- `scripts/daemons/start.sh`, `stop.sh`, `status.sh`, `logs.sh`: the human-invocable wrappers over `systemctl --user` documented in §_Start, stop, status, and log review_ above.
- `scripts/daemons/config.sh`: host-local maintainer-edited list of which driver lanes and which watchers to enable.
- `scripts/daemons/README.md`: human-oriented start/stop guide; systemd integration; troubleshooting recipes.
- `scripts/systemd/garden-driver@.service` and `scripts/systemd/garden-watcher@.service`: the two templated unit files documented in §_Driver pool_ and §_Per-activity-feed watcher daemons_. The README in this directory documents drop-in locations (`~/.config/systemd/user/`), `daemon-reload` cadence, and the `enable` / `start` lifecycle.

**Agent context (`skills/`)** :

- `skills/driver-pr-creation-state-machine/SKILL.md`: the formal state diagram and transition predicates for the PR-creation workflow. Names which transitions are deterministic and which escalate to the LLM.
- `skills/driver-<kind>-state-machine/SKILL.md`: one per non-PR-creation workflow (`observed-error`, `issue-response`, `build-request`, `design-request`, `retcon-rebase`, `ci-recovery`). Each is a tiny state machine the driver's LLM substep consults.
- `skills/prompt-on-failure-capture/SKILL.md`: the `git hash-object` / `git cat-file blob` capture pattern, prompt template shape, claude invocation, and known-SHA short-circuit.
- `skills/gardener-inbox-error-reporting/SKILL.md`: the uniform pattern for trapping unexpected errors in driver / watcher shell scripts, capturing the transcript via `git hash-object`, and appending a message to `journal/inboxes/<host>/gardener.md` with the lane / feed discrimination header.
- `skills/driver-pre-ci-validation/SKILL.md`: the deterministic six-step gauntlet (`yarn format`, targeted tests, `yarn build:types:check`, `yarn lint`, full tests, docs generation) the driver runs before pushing changes.
- `skills/activity-feed-watcher/SKILL.md`: the contract every per-feed watcher implements (event classification, subscription union, reactji policy, error escalation). Each `scripts/watcher/<feed>/watcher.sh` consults this skill on the LLM-substep paths it has (most paths are deterministic and skill-free).

**Retired / superseded** (the scripts/ pivot replaces these earlier proposals):

- `roles/driver/driver.sh`, `roles/driver/AGENT.md`: superseded by `scripts/driver/driver.sh` + `scripts/driver/README.md`. The driver is a script under `scripts/`, not a role under `roles/`. A subagent invoked by the driver still reads its own `roles/<role>/AGENT.md`, but no `AGENT.md` exists for the driver itself.
- `skills/$ROLE/$ROLE.sh` companion scripts (`builder.sh`, `cleaner.sh`, etc.): superseded. Roles whose bodies are LLM-driven stay as `roles/<role>/AGENT.md` agent context only; the driver invokes them as `claude -p` subagents, not as bash worker scripts. The narrow exceptions where a role has a deterministic-enough body (the existing `skills/job-board/` helpers) move under `scripts/` if they need to be invoked outside an agent context, or stay under `skills/` if only the LLM substep calls them.
- `skills/role-job-board/SKILL.md` (per-role subdirectories): superseded. The generic inbox at `journal/jobs/open/` plus `kind:` frontmatter discrimination is the simpler model.
- `skills/coalesced-repo-activity-watcher/SKILL.md` (single host-wide watcher): superseded by `skills/activity-feed-watcher/SKILL.md` plus per-feed `scripts/watcher/<feed>/`.

### Modified artifacts

- `roles/steward/AGENT.md` § PR-creation-flow scan: **preserved through the migration** (per kriskowal disposition, 2026-06-01). The scan remains authoritative until drivers demonstrate ≥95% PR-creation-workflow reliability and the maintainer signs off on retirement. Phase 5 of the migration is the earliest point this section is retired.
- `roles/steward/AGENT.md` § Maintainer-feedback response: preserved unchanged through the migration. Once drivers are reliable, the action surface may shift to "post a job to `journal/jobs/open/` with `kind: changes-requested-followup`" rather than "Agent-dispatch a fixer or designer," but the trigger surface is unchanged.
- `roles/general-contractor/AGENT.md`: **preserved through the migration**. The contractor's slot machinery (per-cycle scan + dispatch + foreground visibility) remains the foreground PR-pipeline orchestrator until drivers prove reliable. Re-scoping or absorption into the liaison is deferred to a post-Phase-4 maintainer decision.
- `roles/monitor/AGENT.md` and the per-project monitor skills (`monitor-endo`, `monitor-endo-but-for-bots`, etc.): preserved through the migration. The per-feed watcher daemons (`scripts/watcher/<feed>/`) run alongside them in a verification mode. Per-project monitor retirement is per-project and gated on observed equivalence (Phase 5).
- The existing `shepherd` role: unchanged in scope. The driver may invoke a shepherd subagent for a CI-recovery substate when the state machine reaches `[await-ci-recovery]`.
- `skills/job-board/SKILL.md`: extended with the `kind:` discriminator on job frontmatter. No per-role subdirectory split; the inbox stays generic.
- `CLAUDE.md` § Current inventory: updated to mention the `scripts/` top-level directory, `scripts/driver/`, `scripts/watcher/<feed>/`, the systemd units, and the new state-machine and watcher skills. The existing roles remain listed unchanged through the migration. **No `driver` row is added to the roles inventory.**

### Migration plan

This workflow is **experimental** (kriskowal disposition, 2026-06-01). Existing systems (the steward's per-cycle PR-creation-flow scan, the general-contractor, the standing-monitor daemons, the agent-dispatched workflow) are **preserved** throughout the migration. Drivers run alongside, not instead of, the existing systems; the existing systems remain authoritative until drivers prove reliable. Drivers are **dispatched manually** through the migration period; no automatic supervisor activation. The migration's retirement of any existing system is gated on observed driver reliability (≥95% of PR-flow advancement handled correctly without manual intervention) and the maintainer's explicit go-ahead.

- **Phase 1: design + scaffolding** (this PR plus follow-ups). Lands the file-layout move (the existing `roles/driver/`, `skills/cleaner/`, etc. settle into `scripts/driver/`, `scripts/watcher/<feed>/`, `scripts/daemons/`, `scripts/systemd/` per the §_Layout pivot_ shape); the templated systemd unit files; `skills/driver-pr-creation-state-machine/SKILL.md`; `skills/prompt-on-failure-capture/SKILL.md`; `skills/activity-feed-watcher/SKILL.md`. No live drivers or watchers yet. Existing steward / contractor / monitor remain authoritative. The file-move work is a separate fixer / builder dispatch following this design.
- **Phase 2: one shape end-to-end, manual launch.** Implement the driver for the `pr-creation` job kind on design-only PRs (the simplest state subset: solicitor only, no cleaner, no fixer-loop typically). Shake out on `endojs/endo-but-for-bots`. Drivers launched manually via `scripts/driver/driver.sh <lane>`; steward continues to handle source-touching PRs and serves as a fallback for any design-only PR whose driver is not manually launched. The first watcher (`scripts/watcher/endo-but-for-bots/`) runs alongside the existing standing monitor in a verification mode.
- **Phase 3: source-touching support, manual launch.** Implement the cleaner / barrister / fixer / justice / appellate substates as `claude -p` subagent invocations from the driver. Drivers launched manually. Steward's PR-creation-flow scan remains authoritative; drivers run alongside as a verification mode. Watchers remain alongside the monitors.
- **Phase 4: reliability evaluation + systemd promotion.** Compare driver behavior to steward / contractor / monitor behavior on the same PRs over a representative window. Reliability is measured per workflow shape (`pr-creation`, `issue-response`, `build-request`, `design-request`, `retcon-rebase`, `ci-recovery`) against an explicit checklist. On ≥95% per-workflow reliability and explicit maintainer sign-off, the maintainer enables `garden-driver@1.service ... garden-driver@N.service` and `garden-watcher@<feed>.service` for the verified feeds via `systemctl --user enable`. This is the point at which "manually launched" becomes "systemd-managed."
- **Phase 5: retire scans selectively, systemd-managed drivers running.** Per kriskowal disposition (2026-06-01), the existing scan-based systems are kept and dispatched through the drivers until the driver system is reliable. Retirement is per-system: the steward's PR-creation-flow scan retires first (after ≥95% reliability for `pr-creation`), then the contractor's slot machinery (after the same threshold for its workflows), then the per-repo standing monitors (after the per-feed watchers prove equivalent on their safe-to-monitor sets). Each retirement is a separate maintainer decision.
- **Phase 6: cross-repo rollout.** Extend to other monitored repos (`endojs/endo`, `agoric/agoric-sdk`) as their gating allows. Each new repo's activity feed gets its own `scripts/watcher/<feed>/` and `garden-watcher@<feed>.service` unit.

The bulletin tracks each phase's status. The migration is reversible: if a phase reveals a structural problem, the existing system absorbs the work load without per-PR coordination because it never stopped being authoritative.

## Open questions

Several of the original open questions were resolved by kriskowal's PR-3 review on 2026-06-01. Each resolved question carries a `**Disposition:**` sub-block with the verbatim choice. Questions that remain open are explicitly labeled.

1. **Driver pool sizing.** A configured quantity of persistent driver lanes per the 04:08Z review; what is the right initial N? Each lane is a `garden-driver@<N>.service` unit; the maintainer chooses N at `systemctl --user enable` time and re-chooses by enabling or disabling additional lane units.

   **Disposition (kriskowal, 2026-06-01):** "I will manually scale the pool of concurrent drivers." No automatic supervisor-managed cap. The maintainer enables the desired number of `garden-driver@<N>.service` units; the configured quantity is whatever set is enabled at any moment. Per-job concurrency caps (one cleaner per estate, one boatman per host) live inside workflow predicates, not in the systemd unit set.

2. **Failure modes for the LLM.** What if claude is rate-limited or unavailable when the driver escalates? Options: park the driver in `awaits-llm` state with a retry timer; surface to maintainer via the bulletin; fall back to the steward's old `Agent`-dispatched subagent shape as a degraded mode.

   **Disposition (kriskowal, 2026-06-01):** "Exponential backoff with full jitter." The driver parks in `awaits-llm` and the retry timer uses exponential backoff with full jitter (per the AWS Architecture Blog formulation: `delay = random_between(0, min(cap, base * 2^attempt))`). On persistent unavailability the driver eventually surfaces to the gardener inbox (per *Error reporting* above) so the maintainer can intervene; the existing steward / contractor remain available as a manually-dispatched degraded mode because they are preserved through the migration.

3. **Observability and per-lane discrimination.** How does the maintainer see driver state? The proposal includes `journal/drivers/<host>/<lane>.md` per-lane state files; a bulletin section summarizing active lanes; the existing journal-side `result` and `tick` entries from each driver invocation; systemd's `journalctl --user-unit garden-driver@<lane>.service` for raw stdout/stderr; `scripts/daemons/status.sh` and `scripts/daemons/logs.sh` for a human-friendly summary.

   **Disposition (kriskowal, 2026-06-01):** "I will manually scale the driver pool. Each driver should be given a lane number when invoking the shell script." The driver's first positional argument is its lane number (`scripts/driver/driver.sh 1` for driver one, equivalent to `garden-driver@1.service`). The lane number is carried into:

   - The driver's state file path: `journal/drivers/<host>/<lane>.md`.
   - Subscription advertisement: `journal/drivers/<host>/<lane>.subscriptions`.
   - Gardener-inbox messages (per *Error reporting* above), which name the lane in the message header.
   - Journal entries the driver writes, so per-lane filtering by `grep '^lane: <n>'` works.
   - The systemd unit instance: `garden-driver@<lane>.service`.

   Bulletin observability and the per-lane state files remain as proposed.

4. **Credentials and identity.** Workers run continuously as the bot identity. The existing host-pinned identity (`kriscendobot` on `kmkmbp2021`, `endolinbot` here) is preserved. Boatman is the special case as today; the boatman worker remains the only one authorized to switch identity.

   **Disposition (kriskowal, 2026-06-01):** "Nothing to change here." The existing identity discipline is preserved unchanged.

5. **Tooling boundaries.** The driver invokes `gh`, `git`, `yarn`, etc. directly. Today some operations live inside subagent contexts (the cleaner reads test output via `Bash`). The driver runs them in the parent. Sandboxing? Resource limits? The host's existing pinning of `user.name` / `user.email` per worktree is one example of the same discipline.

   **Status:** Open. No disposition in the 2026-06-01 review pass.

6. **State machine determinism.** Some transitions today are LLM-classified: a maintainer's `COMMENTED` body needs reading to decide if it's substantive feedback (fixer dispatch) or chatter (no-op). The script needs either a deterministic fallback (always escalate to LLM with `<COMMENTED body>` capture) or a strict predicate (length-and-keyword filter). The design assumes escalate-on-ambiguous; the threshold is open.

   **Disposition (kriskowal, 2026-06-01):** "Fine." The escalate-on-ambiguous default stands. The driver captures the body, hashes it, and prompts claude to classify; identical bodies (identical SHA) reuse the prior classification without re-invoking the LLM.

7. **Relationship to standing monitors and the per-feed watchers.** Existing standing-monitor daemons (per-repo bash poll daemons writing to `/tmp/garden-monitor-*.log`) and the proposed per-feed activity-watcher daemons (see *Activity-feed watcher daemons* above).

   **Disposition (kriskowal, 2026-06-01):** "This new workflow is experimental and existing systems should be preserved." The per-feed watcher daemons run alongside the existing standing-monitor daemons through the migration; the existing monitors remain authoritative until each watcher proves equivalent on its feed. Retirement of the per-repo monitors is per-feed and gated on the maintainer's decision after observed reliability (per the migration plan's Phase 5).

8. **Liaison and steward retention through the migration.** Both roles persist as meta-layer postures. The liaison remains the user-in-the-loop surface; the steward remains for cross-PR coordination, housekeeping, and the per-cycle survey of inbox and job board for items not driver-bound (boatman dispatches, gardener dispatches, scholar work, etc.).

   **Disposition (kriskowal, 2026-06-01):** "We will keep these for now and dispatch through the drivers manually until that system is reliable." Both roles are preserved; the steward's PR-creation-flow scan and the contractor's slot machinery remain authoritative through Phase 4. Drivers are dispatched manually during the migration. Per-system retirement is selective and gated on observed driver reliability (per migration plan).

9. **Driver supervisor.** Is the supervisor a bash daemon (analogous to `job-board-poll.sh`), a systemd unit, or a liaison-invoked process?

   **Disposition (kriskowal, 2026-06-01 + 2026-06-02):** the 2026-06-01 disposition was "I am going to invoke the driver manually, like `roles/driver/driver.sh 1` for driver one. It should be bot supervised in the sense that it will trap all errors and report them to the gardener, with a transcript of the failure. This may require subshelling with `-x` so that there's an artifact to submit to the gardener." The 2026-06-02 04:08Z review extends this: "set these up with systemd and provide top-level scripts for starting up and stopping the daemons on Linux ... [a] configured quantity of persistent drivers." Both apply: systemd is the supervisor for the long-lived daemon shape; the driver script is independently invocable by hand for ad-hoc work and for the migration's manual-launch phases.

   Mechanics:

   - Long-lived: `garden-driver@<lane>.service` (templated systemd user unit) invokes `scripts/driver/driver.sh <lane>` with `Restart=on-failure` and 30-second backoff. systemd is the supervisor.
   - Ad-hoc: the maintainer invokes `scripts/driver/driver.sh <lane>` directly. The script behaves identically in both modes; only the supervisor changes.

   Bot-side error supervision (present in both modes):

   - Wraps its inner body in a subshell run with `-x` (`( set -x; <body> ) 2>"$transcript"` or equivalent), so every command and its arguments land in a transcript file.
   - Traps `ERR` and `EXIT` with discrimination on `$?`. On unexpected exit, the trap:
     - Captures the transcript via `git -C journal hash-object -w --stdin < "$transcript"`.
     - Appends a section to `journal/inboxes/<host>/gardener.md` naming the lane, the PR (if any), the state, the transcript SHA, and a one-paragraph context (per *Error reporting* above).
     - Exits non-zero. Under systemd, the unit restarts after the backoff window; under ad-hoc invocation, the maintainer's shell sees the failure.
   - On clean exit (the job reaches a terminal state or the driver is signalled), the transcript is preserved as a journal blob but no gardener message is appended.

   The transcript SHA gives the gardener a deterministic artifact to inspect via `git -C journal cat-file blob <sha>`. Recurring failure shapes (identical transcript prefixes) hash to identical SHAs, so the gardener's triage can short-circuit on a known SHA.

10. **Capture blob lifecycle.** The `git hash-object` blobs are unreferenced and subject to `git gc` after the journal's grace period (default 14 days). For failures we want to keep (recurring operational flakes), the `refs/captures/<role>/<pr>/<short-id>` anchor preserves them. The promotion criterion is open: every capture? Failures the LLM classifies as recurring? Maintainer-flagged?

    **Status:** Open. No disposition in the 2026-06-01 review pass.

## Non-goals

- **No change to the panel-review process itself.** Jurors and judges continue to do panel work the same way; only the dispatch / scheduling layer changes. A juror's brief is unchanged.
- **No change to upstream-side identity discipline.** The boatman remains the only role authorized to push under `kriskowal`; the driver layer does not alter this.
- **No change to the journal's role as transcript.** Each driver invocation still writes `dispatch`, `result`, `tick`, `message` entries to `journal/entries/`. The per-lane state file at `journal/drivers/<host>/<lane>.md` is supplemental.
- **No change to the design-to-PR pipeline's inventory step.** Detecting a new design and posting a `pr-creation` job is a watcher or maintainer responsibility; the inventory walk lives in the existing `skills/design-to-pr-pipeline/SKILL.md`.
- **No physical file moves in this design dispatch.** The §_Layout pivot_ articulates the new top-level `scripts/` directory and the placement of drivers, watchers, daemons, and systemd units, but the moves themselves (relocating `roles/driver/driver.sh` to `scripts/driver/driver.sh`, relocating `skills/cleaner/cleaner.sh` to the appropriate place, creating `scripts/daemons/` and `scripts/systemd/`) are implementation work for a follow-up builder or fixer dispatch.
- **No `driver` role added to the inventory.** The `roles/` and `skills/` top-level directories continue to hold agent context fragments only; `scripts/driver/` is the driver's home, and `CLAUDE.md` § Current inventory mentions the new top-level `scripts/` directory rather than a new role row.
