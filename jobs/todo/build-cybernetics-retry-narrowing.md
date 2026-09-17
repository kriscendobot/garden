---
role: builder
tier: mentor
handler-budget-role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-17T01:16:04Z cleared=none -->

---
handler-budget-role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build bounded retry narrowing

Implement slice 2 of the accepted design at `designs/cybernetics-economic-resilience.md`: section 2's retry policy, after the decision-ledger slice lands.

Keep quota-reset and quota-bump recovery behind their existing back-off. A wall-hit overrun becomes split-eligible immediately and is not retried. A plain non-productive, non-quota exit gets exactly one retry with a recorded future not-before time; the second such exit becomes split-eligible or surfaces. Preserve the never-reap-earlier invariant, productive-cycle reset, and doom spool. Record decisions through the ledger from slice 1 and add deterministic regression tests. This is the garden's own repository: commit and push directly to `main2` with the required rebase CAS loop; do not open a PR.
