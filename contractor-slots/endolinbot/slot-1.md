---
slot: 1
status: in-flight
design_path: designs/endor-run-expanded.md
pr_number: null
current_stage: builder
in_flight_dispatch: 8ca10c
last_update: 2026-05-18T00:51:00Z
started_at: 2026-05-18T00:51:00Z
host: endolinbot
---

Slot 1 picks up endor-run-expanded Phase 3 (directory input). Phases
1-2 already shipped (`rust/endo/src/cas_archive.rs`); Phase 3 implements
"endor run /path/to/dir" which ingests a directory into CAS rather than
a ZIP archive.

Implementation base: llm (rust/endo lives only on llm).

Dispatch root: `dispatches/builder--8ca10c`.
