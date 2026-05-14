---
ts: 2026-05-14T23:02:19Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener encodes "retcon" verb + the commit-restructuring procedure

Dispatch root: `dispatches/gardener--c31b1c/`. Garden-meta only.

## Maintainer directive (verbatim)

2026-05-14: *"A new verb I would like to use is 'retcon' meaning 'Please reset this branch and restage the changes in sensibly grouped commits. This should generally have a single commit for each affected package, a separate commit for chore: Update yarn.lock, conventional-commit messages, and a single implementation and test commit.'"*

## Semantics

"Retcon" = "retroactively continuity-fix the branch's commit history." The verb names a procedure, not just a destination:

1. **Reset the branch** to its base (or to a known-good prior tip), keeping the net diff as working-tree changes.
2. **Restage the changes** in **sensibly grouped commits**:
   - **Single commit per affected package** (e.g., one commit for changes in `packages/foo/`, one for changes in `packages/bar/`).
   - **Separate `chore: Update yarn.lock`** commit (per the existing `skills/yarn-lock-separate-commit/SKILL.md`).
   - **Conventional-commit messages** (e.g., `feat(<scope>): ...`, `fix(<scope>): ...`, `chore: ...`).
   - **Single implementation + test commit** — implementation and its tests ship together in one commit (not split). This is a deliberate departure from the "test, then implement" or "implement, then test" patterns that produce two commits per feature; "retcon" wants one.
3. **Force-push** (with `--force-with-lease`) to the same branch. The PR's diff is unchanged; only the commit grouping changes.

The verb is `retcon` (no synonyms requested). Used as: "retcon #N", "please retcon this branch", "retcon and ferry".

## Per-action authorization

Standing on the garden repo. No project-side actions.

## Task

1. **Read** `roles/COMMON.md`, `roles/liaison/AGENT.md` § Vocabulary (the section landed today by gardener `319706`), `roles/steward/AGENT.md` § Vocabulary, `skills/yarn-lock-separate-commit/SKILL.md`, `skills/pr-formation/SKILL.md`, `roles/fixer/AGENT.md` (the role most likely to execute a retcon).

2. **Decide where the procedure lives.** Two options, gardener picks:
   - **Option A**: a new skill `skills/retcon/SKILL.md` (or `skills/retcon-commits/SKILL.md`) that codifies the procedure. The vocabulary entries on liaison/steward then cite the skill rather than duplicating the procedure inline.
   - **Option B**: a notes-from-the-field row on `skills/pr-formation/SKILL.md` that documents the retcon pattern as a variant of pr-formation. Tighter, but pr-formation is already long and a discrete procedure may want its own skill.
   
   The dispatch entry's recommendation: Option A. A new skill `skills/retcon/SKILL.md` captures: reset target (typically `git reset --soft <base>` or `git reset --mixed <base>` keeping working tree), restage by package via `git add packages/<name>/`, commit per package + yarn.lock + implementation+test, force-push with `--force-with-lease`. Cite `yarn-lock-separate-commit` skill from there.

3. **Add `retcon` to the Vocabulary on `roles/liaison/AGENT.md`** under direct-dispatch verbs (the verb dispatches a fixer or whichever role is in the branch's path; "retcon #N" → dispatch fixer with the retcon brief) AND/OR compound chain idioms (since retcon composes with the existing chain). Gardener decides which category fits.

4. **Mirror onto `roles/steward/AGENT.md` § Vocabulary** (the autonomous subset). The steward can issue retcon as part of a fixer dispatch when an inbox `message: liaison → steward` carries the verb.

5. **Update `CLAUDE.md` § Orchestrator vocabulary glossary table** with a one-line entry: `retcon #N` — reset branch + restage per-package + yarn.lock-separate + impl+test combined.

6. **Cite the maintainer's framing** in a notes-from-the-field row on the new skill (or wherever applicable).

7. **Disambiguation**: note in the new skill that retcon does NOT change the net diff (PR contents stay identical); it only changes the commit grouping. The judge's panel review runs against the new commit shape after retcon completes (each per-package commit gets its own scope of attention).

## Out of scope

- No edit to existing PRs.
- No new role.
- No change to existing skills beyond the targeted vocabulary additions.

## Commits

- One commit for the new skill (if Option A).
- One commit per substantively-revised file (`roles/liaison/AGENT.md`, `roles/steward/AGENT.md`, `CLAUDE.md`).

Push at end. Journal result entry.

## Report

≤ 250 words: chosen home (A or B), one-line procedure summary, files revised, one-line `Self-improvement: ...`.
