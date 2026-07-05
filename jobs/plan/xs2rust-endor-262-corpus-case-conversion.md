---
gate: orchestrated
orchestrated_by: xs2rust-endor-test262-convergence
priority: normal
posted_by: producer
posted_at: 2026-07-05T23:13:12Z
---

---
model: opus
---
# Builder: corpus → test262 cases conversion (PR #600, test262-convergence child 2/5)

Repo: `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, keep DRAFT).
Design: `designs/xs2rust-endor-test262-convergence.md` § Part 1.

Build the `corpus-to-262` converter and generate `rust/engine/endor-262/cases/` from the
22-file, 1374-program corpus: one case per corpus line (1:1, nothing dropped silently),
`assert.*` bodies with expectations recorded from the oracle at conversion time,
frontmatter per the design's mapping table (`endor-dual-run` / `endor-meter-exact` /
`endor-meter-determinism` features; `raw` for meter micro-cases; runtime negatives for
Error throws; parse negatives checked in inactive until stage 5). Includes resolve
against `packages/test262-runner/test262/harness/`. Prove coverage equivalence (same
totals, zero divergence, same bit-exact set under `--gate-meter-exact`), then retire
`corpora/*.js`, the `stage*_corpus()` accessors, and their per-stage tests by name.
