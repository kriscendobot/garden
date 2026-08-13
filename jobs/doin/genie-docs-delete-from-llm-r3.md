---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 7200
repo: endojs/endo-but-for-bots (base branch `llm`) — PR workflow, NOT a direct push

Delete the `PLAN/`, `TODO/`, and `TADA/` directories from the `llm` branch. Their
contents are now in the garden journal.

This replaces `genie-docs-r2-02-delete-from-llm`, which correctly refused when it
was dispatched before its migration stage had run. That precondition is now
genuinely satisfied, and the evidence is below — but **verify it yourself rather
than trusting this body**, because after this job the journal copy is the only
copy.

## Migration evidence (verify, do not assume)

Stage `genie-docs-r2-01-migrate-into-journal` migrated from
endojs/endo-but-for-bots@llm commit `a54c3adb` into `journal2` at
`library/endo-but-for-bots/`, pushed as `174c3a976d4fb14b96d5bbdde97719495e2aa75d`.
It reported source and destination git tree hashes matching exactly, preserved the
directory structure and relative cross-link targets, and added provenance and an
inventory in `library/endo-but-for-bots/README.md`.

Independently confirmed counts, recursive, source versus journal:

| dir | source (`origin/llm`) | journal |
|---|---|---|
| `PLAN` | 11 | 11 |
| `TODO` | 1 | 1 |
| `TADA` | 172 | 172 |

184 files plus the provenance README.

**Re-verify before deleting:** the counts still match, the tree hashes still
match, and `library/endo-but-for-bots/README.md` records the provenance. If
anything fails to reconcile, STOP and report with `llm` untouched.

## The work

Delete the three directories on a branch off current `llm` and open a PR whose
description states plainly where the content now lives, so someone hunting a
deleted plan can find it. Keep it factual and short.

Re-check for inbound references at the time you run: an earlier `git grep` over
`llm` found references to these directories ONLY from within the directories
themselves — nothing in `AGENTS.md`, `CLAUDE.md`, `README.md`, `CONTRIBUTING.md`,
or `.claude/`. `llm` moves, so confirm rather than trusting that. If anything
outside the three directories now references them, update it in the same PR.

Note in the PR whether the repo's agent instructions ever directed agents to write
into these directories; if so, fix those instructions in the same PR, or agents
will keep writing into a path that no longer exists.

Run the normal gauntlet. Do not force the merge if review objects to removing the
content from the repo — report back instead. Some readers may want these kept
in-tree, and that is the maintainer's call.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-13T22:11:25Z
