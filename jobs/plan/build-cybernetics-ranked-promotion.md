---
gate: orchestrated
orchestrated_by: cybernetics-economic-resilience-build
priority: normal
role: builder
posted_by: gardener
posted_at: 2026-09-17T00:34:50Z
---

---
handler-budget-role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build leaf-first omega promotion

Implement slice 5 of the accepted design at `designs/cybernetics-economic-resilience.md`: section 5's ranked promotion ordering, reconciling it with `designs/omega-task-rank-and-foreman-retirement.md` and `designs/cnf-backlog-triple.md`.

The settled orientation is leaf-first: leaves are `R0`, parents derive `1 + max(child rank)`, and the promoter chooses the lowest-ranked admissible deferred work first. Keep rank derived rather than declared, preserve the existing admission gate and deterministic tie-breaks, fail open as designed when inputs are unavailable, record promotion decisions through the ledger, and add deterministic ordering tests. This is the garden's own repository: commit and push directly to `main2` with the required rebase CAS loop; do not open a PR.
