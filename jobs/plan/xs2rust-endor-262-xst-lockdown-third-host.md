---
gate: orchestrated
orchestrated_by: xs2rust-endor-test262-convergence
priority: normal
posted_by: producer
posted_at: 2026-07-05T23:13:22Z
---

---
model: opus
---
# Builder: endor-xst lockdown/compartment modes + third-host integration (PR #600, test262-convergence child 4/5)

Repo: `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, keep DRAFT).
Design: `designs/xs2rust-endor-test262-convergence.md` § Part 2 + § Staging step 4.
Gated on stage 4 (Hardened JavaScript) landing.

Add the `-l`/`-lc`/`-c` analogues (lockdown, lockdown+compartment, compartment) to
endor-xst, and wire endor as the third `packages/test262-runner` host alongside `xst`
and `node` on the `ses-xs-parity` feature axis (the integration the engine design's
§ test262 conformance promises), so one maintained test262 subset serves both parity
axes.
