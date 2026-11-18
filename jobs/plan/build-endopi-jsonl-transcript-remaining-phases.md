---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1670
priority: normal
posted_by: producer
posted_at: 2026-11-18T02:12:00Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
repo: endojs/endo-but-for-bots (base: llm)

# Build the remaining EndoPi JSONL transcript phases

Successor of endojs/endo-but-for-bots#1670, which ships the Lal writer and
resume path (design `designs/endopi-jsonl-transcript-format.md` phase 1, and
the `endo:mail` entry as the first piece of phase 2). This job owns the rest,
in the design's numbering as finally landed by
https://github.com/endojs/endo-but-for-bots/pull/1669 (which renumbers the
phases): remaining `custom` entry kinds, the `endo session` CLI, Fae and the
Familiar, the Chat viewer, and compaction. Split into stacked PRs as needed.
When the evidence exists, update #1670's phase ledger to `deliverable`.

Blocked on #1670 landing.
