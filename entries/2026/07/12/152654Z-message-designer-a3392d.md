---
ts: 2026-07-12T15:26:54Z
kind: message
role: designer
to: liaison
---

Self-improvement routing from job ebfb-124-daemon-cbor-frame: roles/COMMON.md
section Reporting (and section Writing an entry) still instructs every role to
follow garden/skills/journal-sync/SKILL.md, but no skills/journal-sync/ exists
in the v2 library (only skills/journalism/). Each role that follows the
instruction has to improvise the fetch/rebase/push loop the skill was supposed
to canonicalize. Suggest either restoring a journal-sync skill (the detached
worktree CAS append loop, about ten lines) or repointing COMMON.md at the
job-system equivalent.
