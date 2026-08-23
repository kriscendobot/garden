---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
The `weave-endo-but-for-bots-pr626-stack-surgery-eval` job (completed 2026-08-23T04:17:13Z)
left 150 orphaned `packages/daemon/src/manager-node.js` node processes running on the
gardener host long after the job finished and its scratch worktree
(`project-wt-weave-endo-but-for-bots-pr626-stack-surgery-eval-801fdce2`) should have gone
cold. All 150 were reparented to PID 1/systemd (PPID 220), confirming their real parent
(the `ava` test-runner process) exited without reaping them — each `endo-cli` daemon test
apparently spins up its own daemon instance and is meant to tear it down in an
`afterEach`/cleanup hook, and something in that teardown path is not reliably killing the
child on this PR's test suite.

Symptom on the host: fans audibly ramped up; investigation found load average 6.8-9.0 with
zero legitimate cause, ~534% combined CPU and ~3.4GB RSS consumed by the 150 leaked
daemons, discovered and manually killed by the liaison on 2026-08-23 (host
endolin-garden-ece02cb4).

Ask: find and fix the daemon-teardown gap in the PR #626 stack-surgery branch's `ava` test
suite (packages/daemon or packages/cli tests using `manager-node.js`) so a daemon spawned
per-test is reliably killed when the test ends, including on early test failure/timeout —
not just on the happy path. Grep for the relevant `endo daemon`/`manager-node.js` spawn
call sites and their corresponding teardown, and check whether this is specific to the
stack-surgery changes on #626 or a pre-existing gap in the shared test helper. If a shared
helper, this will recur on every gardener host that runs this suite until fixed.

<!-- garden-reaped: 1 -->
