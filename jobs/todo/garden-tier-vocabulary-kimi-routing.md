---
model: gpt-5.6-terra
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-29T16:31:04Z cleared=none -->

Repository: kriscendobot/garden (garden library itself; land directly on main2, no PR).

Implement a backend-aware four-tier dispatch vocabulary, ordered from most thoughtful to most expedient: mentat, mentor, minion, myrmidon. Interpret the maintainer directive as follows: mentat is the highest tier overall and is manual-dispatch-only; mentor is the highest tier any automatic producer may select. Map Claude Fable to mentat and Moonshot Kimi K3 to mentor. During the current Claude quota period, route every automatically produced job that would resolve to any Claude model or Claude-backed role default to mentor/Kimi instead. No producer, schedule, role default, follow-up, auction, or other automatic machinery may emit Fable/mentat or another Claude pin. Preserve an explicit manual path for mentat/Fable only. Audit model selection, role defaults including designer/builder, schedules, producer headers, fallback chains, backend-fit eligibility, documentation, and tests. Kimi builder work must remain mechanically claimable without requiring a Claude fallback; use a qualified non-Claude fallback where a safety fallback is required. Make the temporary provider routing reversible without discarding the tier vocabulary. Add regression coverage proving automatic dispatch is capped at mentor and Fable is manual-only. Report the landed main2 commit and exact migration/deployment steps.

<!-- garden-annotation: key=maintainer-tier-map-opus-codex-20260729 by=liaison at=2026-07-29T16:30:53Z -->

Maintainer clarification (2026-07-29): map both Opus and Codex to the minion tier. The resulting order is mentat (highest, manual-only; Fable), mentor (highest automatic; Kimi K3), minion (Opus and Codex), myrmidon (most expedient). Apply this mapping consistently in executable routing, migration, documentation, and tests.
