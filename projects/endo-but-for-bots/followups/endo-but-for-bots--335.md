---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 335
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-05-22T23:52:30Z
last_appended_at: 2026-05-22T23:52:30Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#335

Created from the design-panel verdict (7 seats, in-band fallback) on `design: AI agent requirements reference (Quinn Pig screed)` (branch `designs/ai-agent-requirements-quinnypig-screed`). The PR adds a Reference design that engages Corey Quinn's screed on AI-agent requirements against Endo's standing primitives (SES, exo, CapTP, daemon, OCapN). One deferral warrants revisit when the PR merges.

## Items

- [ ] **Transactional-dry-run design as its own document.**
  **Source juror(s)**: critic, decomplector.
  **Round**: 2.
  **Recommended action**: file a follow-up issue on `endojs/endo-but-for-bots` (or seed a new design under `designs/`) proposing the transactional-dry-run design as a candidate, citing this Reference doc's bullet 7 (lines 358 to 379) as the origin point. The bullet's framing braids two concerns the new design should decomplect: the pricing-preview projection (a `previewCost(args)` projection over a service-aware cost source) and the dry-run economics (who pays for speculative compute against an ephemeral storage proxy mirrored on the CAS). The substrate (CAS, XS worker snapshots, daemon's fork-worker mechanism) is already there; the open problem is the economic shape.
