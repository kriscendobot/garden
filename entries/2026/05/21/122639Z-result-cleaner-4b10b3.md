---
ts: 2026-05-21T12:26:39Z
kind: result
role: cleaner
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/cleaner--4b10b3/project
refs:
  - entries/2026/05/21/120714Z-dispatch-liaison-4b10b3.md
  - entries/2026/05/21/120400Z-result-builder-c3c0dc.md
---

# Cleaner pass on PR #337 (Endo Gateway slice 1, @endo/where)

PR: <https://github.com/endojs/endo-but-for-bots/pull/337> (draft).
Branch: `feat/endo-gateway`.
Cleaner head SHA: `bf4890e92`.

## Coverage assessment

Baseline (builder head `3e3468638`): @endo/where statements 99.5%,
branches 92.68%, functions 100%, lines 99.5%.

After cleaner head `bf4890e92`: statements 99.5%, branches 95.18%,
functions 100%, lines 99.5%.

The new Gateway functions specifically:

- `whereEndoGatewayState`: 100% branch coverage. The builder's
  Windows test covered both PROGRAMDATA-defined and
  PROGRAMDATA-undefined legs.
- `whereEndoGatewayEphemeralState`: previously 1 uncovered branch
  on line 153 (PROGRAMDATA-undefined Windows fallback). Now 100%.
- `whereEndoGatewayCache`: previously 1 uncovered branch on
  line 198 (PROGRAMDATA-undefined Windows fallback). Now 100%.
- `whereEndoGatewayRegistrarSock`: 100% (Windows branch is the
  named pipe constant, no fallback).

Remaining uncovered branches in `index.js` are all pre-existing in
`whereEndoEphemeralState` (line 67) and `whereEndoSock` (lines 82,
94, 95). These are not introduced by this PR; per cleaner doctrine
"one package per engagement" and per the builder's `chore:`-prefers-
separate-PR finding, they are out of scope for this dispatch. A
separate `chore(where): coverage` pass can converge them.

Dead-code audit: the four new exports are referenced in
`types.d.ts` and traced to design slices 2-11. No deletions
warranted.

## Commits landed

- `bf4890e92` `test(where): cover Endo Gateway PROGRAMDATA-undefined
  Windows fallback`

Single commit, two test files modified, +22 lines, no yarn.lock
change, no new test files, no source change. The two additions are
symmetric assertions inside the existing `test('windows', ...)`
blocks of `where-endo-gateway-ephemeral-state.test.js` and
`where-endo-gateway-cache.test.js`, mirroring the same shape the
builder already wired into `where-endo-gateway-state.test.js`.

Regression evidence: perturbing the fallback expression
`` `${info.home}\\..\\..\\ProgramData` `` to
`` `${info.home}\\PERTURBED` `` made both new assertions fail (and
the existing `whereEndoGatewayState` fallback assertion fail in
the same run), confirming the assertions are load-bearing on the
exact branch they target.

`yarn lint` on `packages/where`: clean. `yarn test` on
`packages/where`: 28 pass (same test count as before; new
assertions live inside existing test functions).

## CI status at end of dispatch

Workflow run <https://github.com/endojs/endo-but-for-bots/actions/runs/26225124890>.
10 jobs completed, all 10 succeeded; 1 in progress (`lint`); 4
queued (`check-action-pins`, `cover`, `test (22.x, ubuntu-latest)`,
`test-async-hooks (18, ubuntu-latest)`). Zero failures, zero
cancellations on the cleaner's head.

Confirmed-green relevant to `@endo/where`: `test (24.x,
ubuntu-latest)`, `test (24.x, macos-15)`, `test (22.x, macos-15)`,
`test-hermes`, `test-xs`, `test262 (22.x, ubuntu-latest)`,
`test262 (24.x, ubuntu-latest)`, `test-async-hooks (22,
ubuntu-latest)`, `test-ocapn-python`, `viable-release`.

The four still-queued jobs (`cover`, `test (22.x, ubuntu-latest)`,
`test-async-hooks (18, ubuntu-latest)`, `check-action-pins`) have
been queued for ~14 min after the run started; the org-wide CI
queue was visibly backed up (four parallel branches all in
"queued" CI state during this dispatch), suggesting runner
contention rather than a per-PR problem. Lint is in_progress.

Recommendation to the orchestrator: the cleaner head is green on
every job that has reported; the remaining four are environmental
queue, not signal. Dispatching the judge now is defensible; if
the judge prefers a fully-green matrix it can wait for the queue
to drain (no observed failures across this workflow).

PR is still DRAFT (cleaner does not un-draft; judge handles that).

## Authorization scope used

- Push to `feat/endo-gateway` on `endojs/endo-but-for-bots`: used.
- Read-only elsewhere; no comments; no un-draft. Honored.

Self-improvement: when CI runner contention stalls the full
matrix beyond two cache windows but every reported job is green,
the cleaner's "watch CI converge" norm benefits from a documented
falloff: report the current pass/queue split with the workflow
URL and the observation that other branches are also queued,
rather than waiting indefinitely. The judge can decide whether to
dispatch on the partial signal or wait for the queue to drain.
The skill (`coverage-driven-testing`) and the cleaner role file
could note that all-pass-with-runner-queue is a valid terminal
state for the dispatch.
