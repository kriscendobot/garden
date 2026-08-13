---
gate: orchestrated
orchestrated_by: genie-docs-to-journal-orchestration
priority: normal
posted_by: producer
posted_at: 2026-08-13T21:37:48Z
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

1. The sibling stage `genie-docs-01-migrate-into-journal` has completed and its
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

<!-- garden-annotation: key=488b78eb78bb by=producer at=2026-08-13T21:58:06Z -->

SUPERSEDED — do NOT promote. Replaced by 'genie-docs-r2-02-delete-from-llm' under orchestration 'genie-docs-to-journal-orchestration-r2'. The original chain halted at stage 1's precondition (it required garden-tada-shard-orchestration to complete first), which was a scoping error: stage 1 never writes under jobs/ and the sharding chain only touches jobs/tada/, so the two do not overlap. Promoting this copy would delete PLAN/TODO/TADA from the llm branch while its r2 sibling migration may not have run, and after deletion the journal copy is the ONLY copy. Remove it rather than promoting.
