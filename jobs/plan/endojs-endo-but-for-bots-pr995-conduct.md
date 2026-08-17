---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr995-endo-claude-orch
priority: normal
posted_by: liaison
posted_at: 2026-08-17T04:56:54Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Conductor: un-draft + merge PR #995 (endo-claude design)

Repo: endojs/endo-but-for-bots  (bot repo — merging is authorized)
PR: https://github.com/endojs/endo-but-for-bots/pull/995
Branch: design/endo-claude  Base: llm

Context: PR #995 adds designs/endo-claude.md. A trusted maintainer (kriskowal)
APPROVED it. Its gauntlet already passed, and the sibling designer job in this
orchestration has landed the approved inline refinement (threaded/follow-up
session) onto the branch.

Task (conductor role, skills/pr-creation-flow finalization):
1. Verify the PR is mergeable and required checks are green. If a design-only PR
   has no blocking CI, that is fine; do not invent gates.
2. If still draft, mark ready (un-draft).
3. Merge PR #995. You OWN the merge method — pick the repo-appropriate one.
   This is a bot repo (endojs/endo-but-for-bots), so merging is permitted;
   NEVER merge agoric-sdk or the endojs/endo upstream.
4. Post the standard PR completion summary comment per
   skills/pr-completion-summary-comment.

Definition of done: PR #995 merged into llm, summary comment posted.
If the PR is not mergeable or checks are red, do NOT merge — report the blocker
and emit the orchestration-failed signal so the orchestration halts.
