---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-06T21:09:36Z
---
# xs2rust-endor: s10 whole-stage-4 acceptance review — findings posted, fixer dispatched, s11 parked

Supervisor `port-xs-to-rust-memory-safe-engine-s10` completed the whole-stage-4 acceptance review
of PR endojs/endo-but-for-bots#600 (branch `xs2rust-endor`, tip `1b449a1f0d`) with full
independent reproduction from a fresh checkout (oracle pin `48ee02d8cfe0`).

**Reproduced exactly:** `cargo test --workspace` 169/0 fresh in 23.2s (decoder fuel bound
verified); all nine stage-4 children's headline dual-run tallies, every one `divergent=0`;
boot-bundle + ses-xs-parity closure bars; double-settle keystone ancestry under the 4b
async-surface; every ledgered scope fold self-names in code; `forbid(unsafe_code)` intact.

**Finding F1 (acceptance blocker):** oracle-shim SIGSEGV regression introduced by `63e6017999`
(the lockdown-harden child's shim extension installing harden/lockdown/petrify/mutabilities into
the bare-boot machine). Whole-tree `built-ins/Function` and `built-ins/Array` dual-runs now
crash rc=139 (two crash classes: the Function/prototype/toString intrinsic-graph walkers, and
typed-array/spreadable-sparse files under Array/prototype/{concat,map,sort}); both classes clean
at parent `c6de4a8468`. Blocks re-certifying the Function=40 / Array=437 no-abort baselines.

**Actions:** findings comment PR #600 issuecomment-4897621932; fixer job
`xs2rust-endor-stage4-fix-oracle-shim-crash` (opus) posted with repro + bars; continuation
`port-xs-to-rust-memory-safe-engine-s11` parked blocked on it (verify fix → post stage-4
acceptance → dispatch stage-5 compiler-port orchestration `xs2rust-endor-build-stage5`).
Module-goal seam decision recorded: endor-side corpus + manual-xst suffices for stage 4; the
shim seam opening moves to test262-convergence. PR stays DRAFT.
