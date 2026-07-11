---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-11T07:01:05Z -->

---
model: opus
---
# Builder: endor-xst async/$DONE + job-drain wiring (PR #600, test262-convergence child 3/5)

Repo: `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, keep DRAFT).
Design: `designs/xs2rust-endor-test262-convergence.md` § Part 2 (the xst262.c async row).
Gated on the stage-4 async/generator surface.

Wire `flags: [async]` handling into endor-xst: register `$DONE` through the
host-function seam with the did-not-run latch, drain the job queue per case
(fxRunLoop-equivalent over the stage-3b promise pump), and mirror the
unhandled-rejection latch (`the->rejection`). Async tests graduate from
`structural:async-or-can-block` skips to real dual-run verdicts.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 14
  claimed_at: 2026-07-11T07:01:09Z
