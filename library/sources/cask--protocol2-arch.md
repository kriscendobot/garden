---
source: doc/design/protocol2-arch.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 1
status: superseded
notes: |
  The design brief (a prompt) that requested protocol2.md, which was itself
  never implemented. Retained as the genesis record of fixed-offset
  command-first framing, the TTL-as-relay-deadline translation, and the
  dual-purpose trace-identifier-plus-priority field that protocol2.md named
  "cohort".
---

The short design brief that asked for `PROTOCOL2.md` to be proposed. Not a specification but a statement of requirements, and the genesis of three ideas: fixed-width command-first/block-last packet framing; a TTL-as-deadline relay translation (translate time-to-live to a deadline on enqueue, back to TTL on dequeue, with an integer width and time scale suited to UDP-relay queue delay); and the 64-bit field that is simultaneously a Dapper trace identifier and a priority, whose remaining bits are evenly distributed so packets sharing a trace fail together under relay saturation. The brief asks for that field's name; `protocol2.md` answers "cohort". One section, `status: superseded` (the v2 it requests was never built).

| Section | Topics | Status |
|---------|--------|--------|
| [design-brief](../sections/cask--protocol2-arch--design-brief.md) | networking | superseded |
