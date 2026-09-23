---
ts: 2026-06-15T05:45:55Z
kind: result
role: shepherd
repo: endojs/endo-but-for-bots
project: endo
refs:
  - PR https://github.com/endojs/endo-but-for-bots/pull/403
---

Shepherded PR #403 (`feat/registry-capability` at `a7d8a14b`) per maintainer's "Please shepherd. The Mac CI failure is probably a flake" on issue-comment 2026-06-15T05:42:50Z.

## CI rollup

One failing job out of 25 checks:

- `test (20.x, macos-15)` (job [80693199097](https://github.com/endojs/endo-but-for-bots/actions/runs/27314894871/job/80693199097)) on run [27314894871](https://github.com/endojs/endo-but-for-bots/actions/runs/27314894871). All siblings (Ubuntu 20.x, macOS 22.x, macOS 24.x, Ubuntu 22.x, Ubuntu 24.x) pass.

## Classification: flake

Job log summary: `743 tests passed, 4 tests skipped, 1 unhandled rejection`. The unhandled rejection comes from `@endo/daemon`'s `ws-relay > connect fails gracefully when peer is unknown to relay`:

- Test assertion completes and is reported as PASS at the `✔ ws-relay > connect fails gracefully when peer is unknown to relay (30.6s)` line.
- After PASS, a `CTP_RETURN` for question `q-9` arrives with exception `error:captp:Endo#20001 Connection lost`, decoded via `decodeErrorCommon` -> `decodeErrorFromCapData` -> `decodeFromCapData` -> `CTP_RETURN` -> `dispatch` -> `daemon/src/connection.js:178`.
- This is a teardown-timing race: the disconnect arrives after the test reports success, so it escapes the test's promise frame as an unhandled rejection.
- The post-suite block reports `Failed: @endo/daemon#test` and exits 1 because the unhandled rejection is treated as failure-equivalent under the daemon test runner's settings.

The PR diff is scoped to `@endo/exo-npm`, `@endo/registry-capability`, and `@endo/mem-cas`; nothing in the diff touches `@endo/daemon` or `ws-relay`. The failure is not caused by the PR.

## Action

`gh run rerun 27314894871 --repo endojs/endo-but-for-bots --failed` triggered (run is `queued` as of 2026-06-15T05:45:30Z).

## PR comment

Posted top-level summary at https://github.com/endojs/endo-but-for-bots/pull/403#issuecomment-4704924284, naming the failing job, the diagnosis (CapTP teardown race), the rerun action, and the expected outcome.

## Verdict

`next: none` (provisional). The flake is operational and the PR diff is unrelated. If the rerun goes green, the matter is closed; if it reproduces, the proper next step is a flake-broadcast against the `@endo/daemon` `ws-relay > connect fails gracefully when peer is unknown to relay` teardown race, not a fixer dispatch on #403 (the test is not in the PR's diff and a fixer here would have no legitimate fix to make).

The shepherd dispatch brief did not authorize re-marking the PR ready or re-requesting review; the orchestrator decides the next step after verifying the rerun's outcome (a Monitor against `gh pr checks 403` on a one-minute cadence per `skills/pr-ci-watch/SKILL.md` is the right shape; this dispatch ends here and the rerun will converge before the next orchestrator cycle).

Self-improvement: nothing this time.
