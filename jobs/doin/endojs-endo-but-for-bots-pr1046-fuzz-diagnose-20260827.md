---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
https://github.com/endojs/endo-but-for-bots/pull/1046's `fuzz-ironhorse`
check is a settled failure (GitHub Actions run 33044510961, job
98425299070): the `bytecode_decoder` fuzz target hit an AddressSanitizer
stack overflow on input `[193, 193, 37, 253, 45, 93]` (base64 `wcEl/S1d`,
crash file `crash-9088911a1569310cf434acab63fa872c8c744f5e`). The other 25
checks pass.

A prior attempt at this exact fix
(endojs-endo-but-for-bots-pr1046-fuzz-shepherd-20260827-r2) was doomed by
the reaper after 5 requeue cycles — "handler appears to fail every time."
That is a stronger signal than an ordinary stall: before re-attempting the
actual ASan fix, first figure out WHY the handler itself keeps failing
every cycle (a hung/crashing tool invocation, an environment/toolchain
mismatch, a timeout too short for reproducing the crash under the pinned
nightly sanitizer build, etc.) — check its requeue/usage history for the
actual failure signature. Fix the structural cause if there is one, THEN
reproduce the crash locally, diagnose and fix the decoder's unbounded
recursion/stack growth at the correct invariant, add the minimized input
as a permanent regression test or fuzz corpus seed, run the focused
regression plus applicable Ironhorse tests and the fuzz target, drive CI
to green, and post a completion summary with head SHA and real-execution
evidence. Do not merge.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-27T22:33:19Z
