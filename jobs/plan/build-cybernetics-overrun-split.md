---
gate: orchestrated
orchestrated_by: cybernetics-economic-resilience-build
priority: normal
role: builder
posted_by: gardener
posted_at: 2026-09-17T00:34:42Z
---

---
handler-budget-role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build ordinary-job overrun splitting

Implement slice 4 of the accepted design at `designs/cybernetics-economic-resilience.md`: section 1's deterministic split trigger and re-post-as-orchestration path.

On one non-productive wall overrun, stamp the ordinary job split-eligible and route deliberate handler decomposition through the existing orchestration substrate. Divisible work becomes parked children under an orchestration; an indivisible leaf becomes one explicitly larger-timeout child with a recorded reason. Do not apply the generic split/retry path to gauntlet-internal stages: those remain solely owned by the gauntlet driver's `max_stage_retries`. Record decisions through the ledger and add deterministic tests for both the ordinary and gauntlet boundaries. This is the garden's own repository: commit and push directly to `main2` with the required rebase CAS loop; do not open a PR.
