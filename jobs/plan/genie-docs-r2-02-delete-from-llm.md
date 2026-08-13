---
gate: orchestrated
orchestrated_by: genie-docs-to-journal-orchestration-r2
priority: normal
posted_by: producer
posted_at: 2026-08-13T21:57:45Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 7200
repo: endojs/endo-but-for-bots (base branch `llm`) — PR workflow, NOT a direct push

Delete the `PLAN/`, `TODO/`, and `TADA/` directories from the `llm` branch, now
that their contents live in the garden journal.

**Preconditions, verified before deleting anything:**

1. The sibling stage `genie-docs-r2-01-migrate-into-journal` has completed and its
   count-match reconciled. Confirm the documents are actually present in the
   journal at the location that stage chose. If anything is missing, STOP — the
   journal copy is the only copy after this stage.
2. Re-check for inbound references. At posting time a `git grep` over `llm` found
   references to `PLAN/`, `TODO/`, and `TADA/` ONLY from within those directories
   themselves — nothing in `AGENTS.md`, `CLAUDE.md`, `README.md`,
   `CONTRIBUTING.md`, or `.claude/`. **`llm` moves, so re-verify rather than
   trusting that.** If any file outside the three directories now references
   them, update it in the same PR rather than leaving a dangling link.

## The work

Delete the three directories on a branch off current `llm` and open a PR. The
description should state plainly where the content now lives, so someone looking
for a deleted plan can find it. Keep it factual and short.

Note in the PR whether the repo's agent instructions ever directed agents to
write into these directories. If they did, deleting the directories without
fixing those instructions leaves agents writing into a path that no longer
exists; fix it in the same PR if so.

Run the normal gauntlet for this repo. Do not merge without it, and do not force
the merge if review raises an objection to removing the content from the repo —
report back instead. Some readers may consider these documents worth keeping
in-tree, and that is a maintainer call, not yours.
