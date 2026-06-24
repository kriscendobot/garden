---
ts: 2026-06-01T23:29:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriskowal/garden
project: garden
to: builder
dispatch_root: /home/kris/dispatches/builder--91f1d3
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - https://github.com/kriskowal/garden/pull/3
  - entries/2026/06/01/230000Z-dispatch-steward-c597ae.md
  - entries/2026/06/01/231200Z-result-builder-c597ae.md
  - entries/2026/06/01/231345Z-result-steward-c597ae.md
---

# dispatch: builder — kriskowal/garden#3 CI job + driver.sh self-improvement loop

kriskowal CHANGES_REQUESTED review on PR #3 (review id 4405327036,
2026-06-01T23:26:59Z):

> Please add a CI job that runs the driver script tests. Shepherd
> until tests pass in CI.
>
> Please alter driver.sh such that it runs the loop body inside of a
> context that captures the stdout and stderr of the current loop
> iteration and feeds this to an agent for analysis and self
> improvement.

Builds on the prior fixer+builder dispatches (`f6ddb6`, `c597ae`)
plus a concurrent parallel-orchestrator's cleaner worker
(`48afa742`). The branch state has the driver scaffolding, mock-
garden harness, and a per-role cleaner worker.

## Task

Two changes on `design/driver`:

### 1. CI job that runs the driver script tests

Add a GitHub Actions workflow (`.github/workflows/driver-tests.yml`
or similar — the garden may not have a `.github/workflows/`
directory yet; check first and follow whatever pattern emerges).

The workflow should:
- Run on `push` to `design/driver` (and any other dev/integration
  branch) and on `pull_request` targeting `main`.
- Run `bash tests/driver/run.sh` from the repo root.
- Run `bash skills/cleaner/test-cleaner.sh` (the parallel
  orchestrator's cleaner self-test).
- Job name something like `driver-tests`; the conventional
  ubuntu-latest runner is fine.

The shepherd that follows this dispatch will watch CI green; if
the workflow fails, the shepherd escalates to a fixer per the
auto-chain rule.

### 2. driver.sh self-improvement loop wrapper

Alter `roles/driver/driver.sh` so the loop body runs inside a
subshell that captures stdout+stderr and feeds the capture to an
agent for analysis. The capture should:

- Wrap each loop iteration (one tick of the state machine) — not
  the entire script — so each iteration's transcript is its own
  artifact.
- Capture stdout+stderr together (probably `{ ... ; } 2>&1`).
- Hash the capture via `git hash-object -w --stdin` to land it
  in the journal worktree's object database.
- Invoke an agent (the existing `claude` shim that the mock garden
  PATH-stubs in tests) with a prompt that says approximately:
  "Here is the driver loop iteration transcript SHA `<sha>`. Please
  analyze it and suggest any self-improvements." The agent's
  response goes to a per-lane file like
  `journal/drivers/<host>/<lane>.improvements.md` so it can be
  reviewed later.
- The capture-and-analyze step happens *after* the state transition
  for the current tick, so the transcript reflects what the tick
  actually did. The agent's analysis happens asynchronously
  (background, or queued via the job board) so it doesn't block
  the next tick. Use whatever existing pattern the driver.sh has
  for this — if there's no existing pattern, fork to a background
  subshell with `&` and let it complete on its own.

The existing skeleton tests should continue passing. Add a new
test that verifies:
- A loop iteration's transcript ends up in the object database
  (i.e., a blob exists for the captured SHA).
- The agent invocation happens (the PATH-stubbed `claude` records
  having been called).
- The per-lane improvements file gets a new entry.

## Scope boundaries

In-scope:
- `.github/workflows/driver-tests.yml` (new).
- `roles/driver/driver.sh` (modify loop wrapper).
- `tests/driver/test_loop_capture_and_self_improve.sh` (new).
- Adjust `tests/driver/lib/mock-garden.sh` if the PATH-stubbed
  `claude` needs new capture behavior (e.g., a counter).

Out of scope:
- Modifying `skills/cleaner/` (parallel orchestrator's territory).
- Modifying `roles/steward/`, `roles/liaison/`, other roles.
- Implementing the coalesced repo-activity watcher or reactji
  monitor (separate dispatches).
- Touching `journal/` content outside the dispatched sub-worktree.
- Un-drafting the PR.
- Posting any PR comment or resolving any review thread.

## Per-action authorizations

- Create + edit `.github/workflows/driver-tests.yml`,
  `roles/driver/driver.sh`, `tests/driver/*.sh`,
  `tests/driver/lib/mock-garden.sh`. Authorized.
- Run `git add`, `git commit`. Authorized.
- Regular append push to `kriskowal/garden:design/driver` under
  `endolinbot` identity. Authorized (no force, no rewrite).
- Run the test harness locally. Authorized.

## Not authorized

- Modifying `skills/cleaner/`, `roles/steward/`,
  `roles/liaison/`, or other roles.
- Force-pushing or rewriting history.
- Touching any other branch.
- Posting a PR comment, resolving a review thread, un-drafting.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/builder--91f1d3/garden/roles/COMMON.md`
2. `/home/kris/dispatches/builder--91f1d3/garden/roles/builder/AGENT.md`
3. `/home/kris/dispatches/builder--91f1d3/project/roles/driver/AGENT.md`
   (the current driver role brief)
4. `/home/kris/dispatches/builder--91f1d3/project/roles/driver/driver.sh`
   (the current driver script you'll be modifying)
5. `/home/kris/dispatches/builder--91f1d3/project/designs/driver.md`
6. Skills referenced just-in-time.

Project worktree at `project/` is on `design/driver` at head
`48afa742` (synced manually after dispatch-prepare's stale-bare-
clone preload; the bare clone has been brought current).

## Report

A `result` journal entry. Include:

- New head SHA(s) after push.
- Files created / modified.
- Test results: which test cases pass (the existing skeleton tests
  must continue to pass; the new capture-and-self-improve test
  passes).
- The CI workflow's path and the precise commands it runs.
- Any clarifying questions raised (the maintainer's "for analysis
  and self improvement" is generic; concrete interpretation
  decisions should be surfaced).
- Confirmation that no PR comments were posted, no review threads
  resolved, PR remains DRAFT, no other PR or branch touched.

The next dispatch (shepherd) will follow this builder to watch CI
green per kriskowal's "Shepherd until tests pass in CI" directive.
