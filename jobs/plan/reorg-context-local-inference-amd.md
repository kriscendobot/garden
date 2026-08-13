---
gate: orchestrated
orchestrated_by: reorg-context-library-batch-1
priority: normal
posted_by: producer
posted_at: 2026-08-13T22:07:56Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# reorg-context-local-inference-amd

## Context

Flagged by the focused context-graph size audit
(`journal/reports/context-graph-size-audit-focused-2026-08-13.md`) as the
largest main2 context document: `context/operations/local-inference-amd.md`,
670 lines / ~39.7 KiB, 8 level-two sections. It is exactly the failure shape
[context-library](skills/context-library/SKILL.md) names explicitly: "A single
long file with numbered sections is the failure mode this skill exists to
prevent." Its sections:

```
## 0. The host, as probed
## 1. ROCm for gfx1151 — version, install, and whether an override is needed
## 2. Standing up an OpenAI-compatible `/v1` endpoint
## 3. Model selection for a ~50–110 GB unified-memory budget
## 4. Wiring a local-inference worker backend
## 5. Feeding the bid-auction cost model — local inference is very cheap, not free
## 6. Durability — what to bake into the image
## Sources (primary)
```

## Task

Split this per [context-library](skills/context-library/SKILL.md), following the
sibling pattern already used elsewhere under `context/operations/` (a flat set
of single-topic docs indexed by `context/operations/README.md`):

1. Create `context/operations/local-inference-amd/README.md` as the new
   directory index: a specific abstract at the top (what this tree covers, in
   the reader's query terms), then a routing table naming each child file and
   what it contains — not a "here's what's in this folder" filename dump.
2. Partition the 7 numbered sections (0–6) into child files under that
   directory, one topic each, sized to what the topic actually needs — do not
   force an artificial 1-section-per-file split if two adjacent sections are
   one topic (e.g. sections 0–1 are both "getting ROCm working on this host"
   and may belong together; use judgment against the partitioning rule: "pick
   a hypothetical query that fits the parent's topic; can you predict which
   child it lands in from the children's abstracts alone?"). Each child opens
   with its own abstract per the abstract-at-the-top contract.
3. `## Sources (primary)` becomes either its own child file or folds into
   whichever child cites it most, whichever reads better.
4. Update `context/operations/README.md`'s row for `local-inference-amd.md` to
   point at the new directory's `README.md` instead of the flat file, keeping
   the row's abstract accurate to the new entry point.
5. Delete the old flat `context/operations/local-inference-amd.md` once its
   content is fully migrated (git history preserves it; this is a move, not a
   loss).
6. Grep the repo (`roles/`, `skills/`, `context/`, `journal/`) for any other
   inbound link to `context/operations/local-inference-amd.md` and repoint it
   at the new directory README.

## Notes

- No PR needed; land directly on `main2` per `CLAUDE.md` § Conventions.
- House style: [em-dash-style](skills/em-dash-style/SKILL.md),
  [relative-paths](skills/relative-paths/SKILL.md),
  [no-latin-shorthand](skills/no-latin-shorthand/SKILL.md).
- This is a child of the `reorg-context-library-batch-1` orchestration; report
  through the normal job-board completion, no separate coordination needed.
