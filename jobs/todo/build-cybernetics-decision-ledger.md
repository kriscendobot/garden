---
role: builder
tier: mentor
handler-budget-role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-17T00:46:28Z cleared=none -->

---
handler-budget-role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build the cybernetic decision ledger

Implement slice 1 of the accepted design at `designs/cybernetics-economic-resilience.md` (settled in `main2` commit `2251ecab8ddb7763cccf2e8c4dd9038ed90ba94e`): section 4's durable decision ledger.

Use weekly per-host JSONL files at `budget/decisions/<YYYY-MM-DD>-<host>.jsonl`, where the prefix is the Pacific-local Sunday starting the week and rotation occurs at Sunday 00:00 in `America/Los_Angeles`. Preserve append-only CAS behavior, best-effort/fail-open actuation, the fixed input/decision/reason/outcome shape, and a first-row rotation record. Instrument the existing cybernetic decisions in scope and add deterministic tests, including the weekly boundary. This is the garden's own repository: commit and push directly to `main2` with the required rebase CAS loop; do not open a PR.
