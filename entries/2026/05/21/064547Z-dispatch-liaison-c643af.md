---
ts: 2026-05-21T06:45:47Z
kind: dispatch
role: cleaner
project: endo-but-for-bots
to: cleaner
---

# Dispatch: cleaner c643af — gauntlet stage on endo-but-for-bots#334 (mirror of endojs/endo#2887)

Dispatch root: `dispatches/cleaner--c643af/`. Project worktree on `endojs/endo-but-for-bots@mirror/2887-naming-module-location-specifier` (head `c37c80134`).

Continuing the autonomous-loop gauntlet on PR #334 (the bot-pushable mirror of endojs/endo#2887). Builder d7d813 completed (1 conflict cleanly resolved, 1 moot hunk dropped — see `journal/entries/2026/05/21/060752Z-result-builder-d7d813.md`). 18/18 CI checks SUCCESS.

## PR shape

`fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes`. Diff: README rename (9 ins / 9 del) plus the naming-corrections refactor in `@endo/compartment-mapper`. Behavior-preserving renaming of internal terms (moduleSpecifier ↔ moduleLocation distinctions). Existing tests should already cover any path the rename touches; this is a documentation+naming PR, not a behavior change.

## Task

Standard cleaner pass:
- **Coverage sweep**: confirm existing tests exercise the touched paths (likely yes; it's a rename, not a behavior change). If gaps surface for adjacent code that the rename exposes, surface them.
- **Dead-code audit**: a rename PR sometimes leaves stragglers (old name in a comment, an unused export shim from a partial migration). Look for those.
- **CI watch**: push any coverage / dead-code commits to the same branch, watch CI converge to green.

If you push nothing (no coverage gaps, no dead code), say so explicitly. That's a valid outcome.

## Per-action authorization

- Push to `mirror/2887-naming-module-location-specifier` on `endojs/endo-but-for-bots`.
- READ-ONLY everywhere else. No comments. Don't un-draft.

## Out of scope

- Don't broaden beyond the rename scope.
- Don't move to ready-for-review — judge's call.

## Report

≤ 300 words:
1. Coverage assessment for touched files: which existing tests cover the rename's paths.
2. Commits landed (subjects + head SHA). Or "no commits".
3. CI status at end of dispatch.
4. One-line `Self-improvement: ...`.

Write the report into `journal/entries/2026/05/21/<HHMMSS>Z-result-cleaner-c643af.md` and commit+push to origin journal before returning.
