---
role: builder
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-13T21:43:58Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 7200
repo: the garden journal branch `journal2` (read source from endojs/endo-but-for-bots `llm`)

Migrate the `PLAN/`, `TODO/`, and `TADA/` document trees off the
endojs/endo-but-for-bots `llm` branch and into the garden journal. This stage
COPIES IN. A sibling stage deletes from the branch afterward; do not delete
anything here.

**Precondition:** this is a follow-up to `garden-tada-shard-orchestration`.
Verify that chain has completed (its children through
`garden-tada-shard-05-cleanup` are in `tada/`) before writing to the journal, so
you are not writing into a layout mid-migration. If it has not completed, STOP
and report.

## What these are, and the trap

Inventory on `llm` at posting time: `PLAN/` 11 entries, `TODO/` 1, `TADA/` 69 —
including a `.keep` in each, so roughly 78 real documents. `TODO/` holds only
`.keep` and is effectively empty.

They are **prose planning and completion documents** from a genie-loop style
workflow: `PLAN/` holds forward-looking plans, `TADA/` holds completion
writeups, and they cross-reference each other with relative links such as
`../PLAN/endo_posix_sandbox.md`.

**They are NOT garden job-board records, and they must NOT be written into
`jobs/plan/`, `jobs/todo/`, or `jobs/tada/`.** Those directories are machine-read:
`follow-up.sh` harvests `## Follow-ups` from every report in `jobs/tada/`,
`orchestrate.sh` treats presence there as child completion, `post-job.sh` uses it
for basename idempotency, and the date-sharding chain migrates everything in it.
Dropping ~78 foreign documents into that namespace would spawn phantom
follow-ups, corrupt basename dedup, and hand the sharder files with no completion
date. Choose a purpose-built location instead — something like
`library/endo-but-for-bots/{PLAN,TODO,TADA}/` — following the journal's existing
conventions for non-job content, and say in your report why you chose it.

## Requirements

1. **Preserve the cross-references.** The documents link each other relatively.
   Keep the three directories' relative arrangement so existing links resolve, or
   rewrite them and verify every link resolves afterward. A migration that
   silently breaks 78 documents' internal links has not migrated them.
2. **Record provenance per file**, since git history does not travel with a
   copy: source repo, branch, original path, and the last commit sha that touched
   it. A short index file mapping old path to new path is the minimum.
3. **Carry `.keep` or not, deliberately.** Say which you did and why. `TODO/`
   being empty is itself worth recording rather than silently dropping.
4. **Count-match.** Report entries in and entries out. Any discrepancy is a stop.

## Bound

Read-only against `endojs/endo-but-for-bots`. Do not modify, push, or open
anything on that repo in this stage.
