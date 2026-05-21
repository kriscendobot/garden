---
ts: 2026-05-21T12:48:46Z
kind: result
role: liaison
project: endo-but-for-bots
to: maintainer
refs:
  - entries/2026/05/21/120714Z-dispatch-liaison-4b10b3.md
  - entries/2026/05/21/122639Z-result-cleaner-4b10b3.md
  - entries/2026/05/21/120800Z-result-liaison-c3c0dc.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 337
    role: source
---

# Result: cleaner stage on endo-but-for-bots#337 (Endo Gateway slice 1) — CI green, ready for judge

Cleaner 4b10b3 has returned and CI on the cleaner's head has fully converged. PR remains DRAFT.

## What landed

Single coverage commit on top of the builder's slice-1 scaffolding:

- `bf4890e92` `test(where): cover Endo Gateway PROGRAMDATA-undefined Windows fallback`

`@endo/where` coverage: statements 99.5% → 99.5%; branches 92.68% → **95.18%**; functions 100%; lines 99.5%. The four new Gateway path functions reach 100% branch coverage. Pre-existing uncovered branches on `whereEndoEphemeralState` and `whereEndoSock` are out of scope (separate `chore(where): coverage` PR territory).

Regression evidence: perturbing the fallback expression `` `${info.home}\\..\\..\\ProgramData` `` to `` `${info.home}\\PERTURBED` `` made both new assertions fail (and the existing `whereEndoGatewayState` fallback assertion fail in the same run), confirming the assertions are load-bearing on the exact branch they target.

## CI status

Run [26225124885](https://github.com/endojs/endo-but-for-bots/actions/runs/26225124885) on head `bf4890e92`: **18/18 SUCCESS**. The queue contention the cleaner observed at end-of-dispatch (4 jobs queued ~14 min after start) has drained; every job — lint, cover, all test matrix slices, test-async-hooks, test-xs, test-hermes, test262, test-ocapn-python, viable-release, check-action-pins, zizmor — passed cleanly. Zero failures, zero cancellations.

## Status

| Stage | Status |
|---|---|
| Builder c3c0dc: implement Endo Gateway slice 1 (`@endo/where` host-scope path functions) | ✅ complete (commit `3e3468638`) |
| Cleaner 4b10b3: coverage sweep on `@endo/where` Gateway functions | ✅ complete (commit `bf4890e92`) |
| CI converges to green on cleaner head | ✅ 18/18 SUCCESS |
| Judge: panel + un-draft | ⏳ ready to dispatch when authorized |

PR is in canonical pre-judge shape: DRAFT, CI green, scope kept tight (leaf-package only, scaffolding-only as designed). The judge dispatch would run a code panel against the slice-1 substance, walk any must-fix-loop, then un-draft on termination.

Cleaner dispatch root torn down (done at 12:41Z, prior to the #79 shepherd dispatch).

## Self-improvement surfaced by the cleaner

When CI runner contention stalls the full matrix beyond two cache windows but every reported job is green, the cleaner's "watch CI converge" norm benefits from a documented falloff: report the current pass/queue split with the workflow URL and the observation that other branches are also queued, rather than waiting indefinitely. The skill (`coverage-driven-testing`) and the cleaner role file could note that all-pass-with-runner-queue is a valid terminal state for the dispatch. (Gardener territory — surfacing here for the journal record; not blocking on it.)
