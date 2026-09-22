---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
handler-timeout: 10800
---
The deploy candidate test gate has been RED for days, so NO host can advance. The
whole fleet is frozen 29-35 commits behind `main2`. Fix the failing suites.

## Evidence

- `endolin-garden-ece02cb4` (leader) deployed `917115c9b772` — **35 behind**
  `origin/main2` (`da07ac7ee694`).
- `endolin-garden2-5bcdff64` deployed `ae2a34bac94d` — **29 behind**.
- The maintainer inbox holds **135 unread `deploy-garden` messages**, of which the
  dominant class is "Deploy candidate test gate rejected main2", re-announced every
  few minutes and still firing as of 2026-09-22T04:30:32Z (candidate
  `36750325dfc59a5d343a84ef28deda2e58f223bd`).

## The failing suites — the SAME three, repeatedly

Across candidates `c66038fb38e5` and `6c7e49cab67c` (22 of 25 sampled notices):

    scripts/jobs/test/signal-kill-classifier-test.sh   rc=1
    scripts/jobs/test/retry-narrowing-test.sh          rc=1
    scripts/jobs/test/provider-cooldown-test.sh        rc=1

An earlier candidate (`024f3a012a53`) shows a DIFFERENT and more alarming shape —
`rc=124` (wall-clock timeout) on `terminal-handler-failure-reap-test.sh`,
`retry-narrowing-test.sh`, `policy-refusal-quarantine-test.sh`,
`codex-policy-refusal-resume-test.sh`, plus a `total-wall-clock` failure.

Treat the two shapes as possibly different causes: `rc=1` is a genuine assertion
failure; `rc=124` is the suite not finishing in its budget. The `rc=124` cluster
coincides with a period when this host was running at load 150-168 (a runaway test
leak, since fixed), so those MAY be starvation artifacts rather than real failures
— verify rather than assume. The `rc=1` cluster is the one actually blocking now.

Diagnostics are already captured on-host at:
  `.garden-state/deploy/candidate-gate-diagnostics/<candidate-sha>/NN-<suite>.log`
Read them first — `fix(deploy): retain candidate gate failure diagnostics` landed
precisely so this would not need reproducing from scratch.

## Tasks

1. Read the retained diagnostics for the `rc=1` trio and determine the real cause.
   Note these three are thematically adjacent — signal-kill classification, retry
   narrowing, and provider cooldown all concern how a failed/killed handler is
   CLASSIFIED — so suspect one underlying change in the classifier contract rather
   than three coincidental breakages. Say whether it is one cause or three.
2. Fix them. If a test encodes an assumption that a deliberate behavior change has
   invalidated, update the TEST and say so explicitly; do not weaken an assertion
   merely to turn the gate green.
3. Determine whether the `rc=124` timeouts are independent defects or load
   artifacts. If any suite is genuinely too slow for its budget, say so and either
   speed it up or justify a budget change — do not simply raise the ceiling.
4. Verify the full candidate gate passes end to end, so a deploy can actually land.

## Why this is urgent beyond the red gate

A frozen fleet means every host runs code up to 35 commits stale, and a stale host
silently violates directives newer than its deployed sha — that is exactly how an
8-day-old IronHorse pause was violated for over a week (the leader was running
code that predated it). The gate being red is not only a deploy problem; it is a
correctness problem for every behavior that has landed since.

Do not bypass the gate with `GARDEN_DEPLOY_TEST_OVERRIDE=1`. That is reserved for a
deliberate emergency deploy by the maintainer after assessing the failure, and
using it here would deploy code whose own tests are failing.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T04:48:42Z
