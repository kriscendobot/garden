---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-25T11:17:43Z
---
sturdyref hourly press (endo-sturdyref-press-20260724-225004, re-claimed 2026-07-25T11:15:08Z) tick observation — no push this tick; the serial CI-green cascade holds the wheel.

Fresh evidence this tick (~11:20Z):
- `gh pr checks 698` — ALL 24 checks pass (build, lint, cover 22/24, test 22/24 ubuntu+macos, test-xs, test-hermes, test-ocapn-python, test-ocapn-guile-interop, test262, viable-release, zizmor, check-action-pins). Bridge cut 1 is green through CI at head c19fdd96cc.
- Orchestration `jobs/orch/endo-sturdyref-ci-green-737-704-20260725.md` state: running, serial, halt-on-failure. Children #737 and #541 complete (pr541 child in tada/), pr698 child live in doin/ (hermit, claimed 10:03:27Z), pr700–pr704 children parked in plan/ awaiting serial promotion.
- Rebase of #698 landed today 05:29Z with confinement verification cited in the PR comment (confined-guest locator/correlation suites); I did not re-run those suites this tick — they ride the cascade child's charter and are inside the green 24-check rollup.

Movement verdict: NOT stalled. Next unblocked artifact is the #700 child (real test failures above bridge cut 2), owned by the running cascade — the orchestrate watcher promotes it when the pr698 child reaches tada/.

Confinement: no artifact landed this tick, so no confinement property changed; the load-bearing invariant (a confined guest cannot read a locator, cannot correlate two tokens, no toString URI leak) is exercised by the suites in #698's green rollup.

Note: sibling press endo-sturdyref-press-20260725-105007 recorded the same non-stall verdict at 10:57Z from endolin-garden2; this stale re-claimed instance (reaped 3×) adds only the all-green #698 confirmation. Duplicate hourly press instances overlapping is benign but worth the schedulers' attention if it persists.
