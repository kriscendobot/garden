---
created: 2026-06-01
updated: 2026-06-01
author: builder
---

# Role: driver

A *script*, not a subagent operating brief. One driver process per active
garden-authored PR (or one generic worker driver, see [Multi-job-kind
drivers](#multi-job-kind-drivers) below). The driver is a deterministic
bash loop that watches its PR's events, evaluates state-machine
predicates, runs the next stage in-process (deterministic) or posts a
job for a role-specific worker (delegated), and escalates to claude only
when judgment is needed.

This role file is read by the maintainer when launching a driver and by
any agent (subagent or orchestrator) that needs to understand the
driver's contract. The driver process itself is `roles/driver/driver.sh`.

## Invocation

```sh
roles/driver/driver.sh <lane>
```

`<lane>` is a small integer (1, 2, 3, ...) chosen by the maintainer at
launch time. The driver uses it to discriminate its per-lane state file,
subscription file, gardener-inbox messages, and journal entries. Two
drivers on the same host must use different lane numbers.

Environment variables the driver honors:

- `GARDEN_ROOT`: the garden checkout. Default: the directory containing
  the driver script's parent's parent (`roles/driver/../..`). The mock
  test harness sets this to a temporary jail.
- `GARDEN_JOURNAL`: the journal worktree. Default: `$GARDEN_ROOT/journal`.
- `GARDEN_HOST`: the host's logical name. Default: `$(hostname -s)`.
- `DRIVER_WORKFLOW`: the workflow the driver should run. Default:
  inferred from the subscribed PR or the claimed job. Test runs pin this
  to a specific workflow.
- `DRIVER_PR`: the PR identifier (`<owner>/<repo>#<n>`) the driver is
  subscribed to. Optional; a generic worker driver has no subscription.
- `DRIVER_TICK_SECONDS`: poll cadence. Default: 30. Test runs use a
  small value or 0 (run-once mode).
- `DRIVER_ONESHOT`: when set to `1`, the driver runs one state-machine
  pass and exits (used by the mock test harness).

## State persistence

Per-lane state file:

```
journal/drivers/<host>/<lane>.md
```

Per-lane subscription advertisement (so the coalesced repo-activity
watcher knows what to fan to whom):

```
journal/drivers/<host>/<lane>.subscriptions
```

A driver may subscribe to zero or more PRs at a time; the subscription
file is the union.

## Error reporting

The driver script wraps its inner body in a `-x` subshell that captures
a transcript. An ERR / EXIT trap discriminates on the exit code:

- Clean exit (state machine reached a terminal state or the driver was
  signalled): the transcript becomes a journal blob, but no gardener
  message is sent.
- Unexpected exit: the trap hashes the transcript into the journal via
  `git hash-object -w --stdin`, appends a section to
  `journal/inboxes/<host>/gardener.md` naming the lane, the PR (if any),
  the state, the transcript SHA, and one paragraph of context, and exits
  non-zero so the maintainer's shell sees the failure.

The error-reporting procedure lives in
[`skills/gardener-inbox-error-reporting/SKILL.md`](../../skills/gardener-inbox-error-reporting/SKILL.md);
the driver inlines a thin wrapper that calls into it.

## State machine

The driver's outer body is a small dispatcher: it reads the workflow
identifier (from `DRIVER_WORKFLOW` or by inferring from the claimed
job's brief), loads the appropriate state-machine skill, and runs its
loop. The loop:

1. Read the current state from the per-lane state file (or `initial`
   on first run).
2. Evaluate the workflow's transition predicate for the current state
   against live GitHub state.
3. Either:
   - **Run a deterministic step** in-process (e.g., `gh pr ready <n>`
     for the `un-draft` transition).
   - **Post a job** to a role-specific board and record `awaits:
     <role>:<slug>` in the state file.
   - **Escalate to claude** with the prompt-on-failure capture pattern
     when the predicate cannot resolve.
4. Persist the new state and (in non-oneshot mode) sleep
   `DRIVER_TICK_SECONDS` before re-evaluating.

The PR-creation workflow's predicates live in
[`skills/driver-state-machine/SKILL.md`](../../skills/driver-state-machine/SKILL.md).
The design-only PR workflow's predicates live in
[`skills/driver-design-only-pr-workflow/SKILL.md`](../../skills/driver-design-only-pr-workflow/SKILL.md).
Additional workflows (issue-response, build-request, design-request,
retcon / rebase) earn their own skill files as they land.

## Multi-job-kind drivers

A driver picks up many kinds of work. The categories the design
recognizes are enumerated in `designs/driver.md` § Multi-job-kind
drivers. Each workflow's predicates live in a dedicated skill file
named `skills/driver-<workflow>-state-machine/SKILL.md` (the
PR-creation workflow uses the unprefixed `skills/driver-state-machine/SKILL.md`
for historical reasons; new workflows are prefixed).

The driver's outer loop, in pseudo-code:

```sh
while true; do
  if [ -n "$DRIVER_PR" ]; then
    run_workflow_pass "$DRIVER_PR" pr-creation
  fi
  CLAIM=$(try_claim_any_eligible_job) || true
  [ -n "$CLAIM" ] && run_workflow_for_claim "$CLAIM"
  [ "$DRIVER_ONESHOT" = 1 ] && break
  sleep "$DRIVER_TICK_SECONDS"
done
```

The Phase-2 implementation lands only the PR-subscribed and
`design-only-pr` workflow paths; the generic-worker job-claim path is
a stub that returns nothing.

## Skills

- [driver-state-machine](../../skills/driver-state-machine/SKILL.md):
  the PR-creation workflow's states and transition predicates.
- [driver-design-only-pr-workflow](../../skills/driver-design-only-pr-workflow/SKILL.md):
  the Phase-2 design-only workflow's states and transition predicates.
- [gardener-inbox-error-reporting](../../skills/gardener-inbox-error-reporting/SKILL.md):
  the uniform trap-and-report pattern.
- [job-board](../../skills/job-board/SKILL.md): the existing post / claim
  / complete primitives.
- [dispatch-worktree](../../skills/dispatch-worktree/SKILL.md): the
  driver calls `dispatch-prepare.sh` and `dispatch-teardown.sh` directly,
  removing the worktree lifecycle from the LLM's responsibility surface.
- [prompt-on-failure-capture](../../skills/prompt-on-failure-capture/SKILL.md):
  the pattern the driver follows on every unresolvable predicate. Lands
  in a sibling PR; this role's `driver.sh` calls into a placeholder that
  exits non-zero with a clear marker until the skill's helper lands.

## Operating norms

- **Run the driver from any working directory.** The driver does not
  assume cwd; it resolves all paths from `GARDEN_ROOT` (which defaults
  to its own script-location-relative parent).
- **Preserve existing systems.** The driver runs alongside the steward,
  contractor, and standing monitors per the design's migration plan.
  The driver does not displace any of them in Phase 2.
- **Stay deterministic above the state-machine line.** Anything the
  driver does in bash should be a deterministic function of GitHub state
  and the per-lane state file. Predicates that cannot resolve escalate
  to claude through the capture pattern; the driver does not embed
  judgment.
- **Never push to the upstream PR branch directly.** The driver dispatches
  the role-specific worker (`builder.sh`, `fixer.sh`, etc.) and those
  scripts push. The driver's role is orchestration, not authorship.
- **Identity discipline.** The driver runs as the bot identity, like
  every other non-boatman role. The boatman exception is unchanged.

## Definition of done

For a Phase-2 driver:

- The driver runs `roles/driver/driver.sh <lane>` cleanly.
- A per-lane state file lands at `journal/drivers/<host>/<lane>.md`
  after the first state-machine pass.
- The design-only PR workflow runs end-to-end against the mock garden
  in `tests/driver/`.
- Unexpected errors fan out to `journal/inboxes/<host>/gardener.md`
  with a transcript SHA the gardener can inspect via
  `git -C journal cat-file blob <sha>`.
- The driver exits cleanly on a terminal state (`merged`, `closed`,
  `abandoned`) and on a `DRIVER_ONESHOT=1` single-pass run.

## What is *not* in scope for this role

- The coalesced repo-activity watcher (separate skill, separate PR).
- The reactji-posting monitor (separate skill, separate PR).
- The pre-CI validation six-step gauntlet (separate skill, separate PR).
- Worker scripts for `cleaner`, `fixer`, `barrister`, `justice`,
  `appellate`, `conductor`, `weaver` (each lands in a sibling PR with
  its own role-companion script).
