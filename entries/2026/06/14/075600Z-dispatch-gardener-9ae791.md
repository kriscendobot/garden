---
ts: 2026-06-14T07:56:00Z
kind: dispatch
role: liaison
host: endolinbot
project: garden
to: gardener
dispatch_root: /home/kris/dispatches/gardener--9ae791
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/440
---

# dispatch: gardener — infer-PR-base-from-package-availability convention

Maintainer directive (kriskowal on PR #440, 2026-06-14T07:55Z):

> Make a note for the gardener and builder that we can infer
> that the base of a PR should be `llm` if it addresses
> packages that only exist in `llm`.

Convention to land:

- When a builder dispatch needs to touch packages that exist
  only on the `llm` roadmap branch (not on `master`), the
  base of its PR should be `llm` (live trunk for design),
  not `master`.
- Conversely, when a builder touches packages that exist on
  both, base = `master` (the implementation trunk).

The trigger surfaced via PR #440's cut 3 (chat) impasse:
the merged design's `packages/chat/*` exists only on `llm`;
on `master` only `packages/goblin-chat/` exists.

## Task

In your `garden/` worktree:

1. **Identify the right home** for this convention. Likely
   candidates:
   - `roles/builder/AGENT.md` § Operating norms or §
     PR-formation.
   - `skills/pr-formation/SKILL.md` § Base selection (or
     similar).
   - `journal/projects/endo-but-for-bots/README.md` (the
     project-specific rules of engagement, since the
     `llm`/`master` split is endo-but-for-bots-specific).
   Probably the project README plus a short cross-ref in
   one of the role/skill files.
2. **Add the convention** at the chosen home. Suggested
   shape:
   > **Base-branch inference for endo-but-for-bots**: when
   > a builder's task touches packages that exist only on
   > the `llm` branch (e.g. `packages/chat` is on `llm`
   > but not on `master`), the base of the resulting PR
   > should be `llm`, not a `master-<sha>` frozen-base.
   > Reverse: packages present on both branches default to
   > `master-<sha>`. Builders inspect package availability
   > before opening the PR.
3. **Commit** to garden main per garden convention (no PR).
4. **If the home is `projects/endo-but-for-bots/README.md`**
   on the journal branch, commit + push to journal (per
   project README conventions).

## Authorizations

- **Direct push to garden main** (or journal, per which
  file lands).
- Do NOT modify project source.
- Do NOT modify any role file beyond cross-references.

## Deliverable

A `result` entry under `journal/entries/2026/06/14/` naming:

- Which file(s) gained the convention.
- The verbatim section added.
- Cross-references updated.
- Commit SHAs.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
