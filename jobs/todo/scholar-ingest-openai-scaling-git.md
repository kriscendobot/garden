---
posted_at: 2026-11-03T02:15:44Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: scholar

Ingest https://openai.com/index/scaling-git-at-openai/ into the library (scholar-ingest-source; fetch via fetch-source.sh, read-only).

Then report on relevant touch points for:
- **Endo** (endojs/endo-but-for-bots @ llm): e.g. the git-integration arc (vfs/git plugin, phase stack), repo scale/monorepo workflows, CI and PR-flow implications, anything bearing on the daemon's storage/CAS and npm-CAS registry designs.
- **Git** itself: scaling techniques described (e.g. repo maintenance, fetch/push protocol, large-repo features) and how they relate to the garden's own shared-repo/worktree/journal-CAS practices.

Write the library entry per journal/library/conventions.md, and put the touch-point report in the job's result entry (cite sections of the source).
