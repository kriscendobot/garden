---
ts: 2026-05-15T05:01:00Z
kind: dispatch
role: steward
project: garden
to: "*"
refs:
  - entries/2026/05/15/045644Z-message-liaison-73cdf1.md
---

# Dispatch: gardener lands `skills/pr-handoff/SKILL.md` (per liaison brief)

Dispatch root: `dispatches/gardener--9e46be/`. Garden-meta only (no project worktree).

## The directive

Liaison's brief at `entries/2026/05/15/045644Z-message-liaison-73cdf1.md` asks for a gardener dispatch to land `skills/pr-handoff/SKILL.md`. The brief is comprehensive (170 lines covering three ferry shapes, attribution discipline, trailer-strip, subject/body editing, PR-formation, identity, branch naming, scope boundaries, and cross-referenced evidence). Nine ferries across two days provide the working material; the boatman's role file already anticipates this skill.

## Per-action authorization

- Author `skills/pr-handoff/SKILL.md` (new) on the garden's `main` branch.
- Update CLAUDE.md's `## Current inventory` to add `pr-handoff` to the skills list.
- Push to `origin/main` directly per the garden's no-PR-for-own-repo convention.
- Optionally update `roles/boatman/AGENT.md` to cross-reference the new skill (the role file already anticipates it via the "actual rebase-and-rewrite-and-push procedure is not yet a skill" note, which can now be replaced with a link).

## Task

Read `journal/entries/2026/05/15/045644Z-message-liaison-73cdf1.md` for the full brief. Author the skill per its structure:

- Three procedure shapes (first-time ferry, re-ferry with force-push, re-ferry with fast-forward append).
- Attribution discipline (single-author and multi-author cases).
- Trailer-strip discipline (`git interpret-trailers --parse`).
- Subject and body editing (strip suffixes, drop fork-only references, translate substantive cross-refs).
- PR-formation discipline (ferry-specific additions on top of `skills/pr-formation/SKILL.md`).
- Identity discipline (kriskowal-on-upstream-only, no comments on primary upstream repos under kriskowal).
- Branch naming.
- Scope boundary (master-merge conflicts → weaver; title/description updates default-off).
- No-op handling.

The skill should be self-contained (a boatman or liaison can read it without needing the brief message). Cross-reference the brief's `refs:` list for evidence; don't inline all nine result entries.

## Out of scope

- No edit to `roles/boatman/AGENT.md` beyond the cross-reference (the role file is deliberately short).
- No PR workflow against the garden's own repo.
- No project-side changes.

## Commits

- One commit on `main`: `skills(pr-handoff): land procedure for ferrying bot-fork PRs upstream`.
- Push directly to `origin/main`.
- A separate small commit for the CLAUDE.md inventory update is acceptable.

## Report

≤ 500 words. The skill's section headings (so the steward can verify structural coverage), the commit SHAs, any cross-references added to `roles/boatman/AGENT.md`, and one-line `Self-improvement: ...`.
