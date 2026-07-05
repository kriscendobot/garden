---
gate: orchestrated
orchestrated_by: xs2rust-endor-test262-convergence
priority: normal
posted_by: producer
posted_at: 2026-07-05T23:13:26Z
---

---
model: opus
---
# Builder: fuzz trophies → cases/regressions/ tree (PR #600, test262-convergence child 5/5)

Repo: `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, keep DRAFT).
Design: `designs/xs2rust-endor-test262-convergence.md` § Part 1 (fuzz-grammar arms).

Populate `rust/engine/endor-262/cases/regressions/` from the differential-fuzz trophies
ledger: each minimized, fixed divergence becomes a test262-style case (features
`endor-dual-run`, the generator arm named in `info:`), and the fix workflow is amended
so every future trophy lands a regression case. The endor-fuzz generators themselves
stay unchanged (generative instruments, not corpus).
