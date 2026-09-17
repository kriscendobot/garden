---
gate: orchestrated
orchestrated_by: cybernetics-economic-resilience-build
priority: normal
role: builder
posted_by: gardener
posted_at: 2026-09-17T00:34:37Z
---

---
handler-budget-role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build cost-aware triager pacing

Implement slice 3 of the accepted design at `designs/cybernetics-economic-resilience.md`: section 3's cost-aware triager wake computation.

Estimate the next job's cost from the trailing median billable tokens by role. Derive wake timing from the existing allowed pace and reset epoch, clamp it to the design's floor/ceiling behavior, and fail open to the current cadence with one deduplicated warning when inputs are absent or stale. A real watched event must preempt a paced sleep immediately. Record pacing decisions through the decision ledger and add deterministic tests for projection, fallback, and event preemption. This is the garden's own repository: commit and push directly to `main2` with the required rebase CAS loop; do not open a PR.
