# Prune migrated v1 material; assess the remainder; report to the maintainer

The maintainer asks: **delete everything under the v1 legacy tree that has already
been migrated into the new garden, assess the value of any remaining material,
and send the maintainer a message with that assessment.**

## Where the material is

- The legacy tree is `/home/kris/v1` (the maintainer called it "legacy/v1"; the
  actual path is `v1/` at the garden root). It is the **entire v1 garden** — 274
  files, ~3.1M — checked out as a **separate git worktree on branch `main`**
  (`.git` is a gitlink to `/home/kris/.git/worktrees/v1`). The v2 garden is branch
  `main2` at the garden root; the journal is `journal2`. **Do not touch `main2`
  or v2 content** — only the v1 tree.
- The authoritative migration classification is
  [`designs/v1-migration-manifest.md`](designs/v1-migration-manifest.md) (on
  `main2`). It classifies every v1 role (30), juror (33), and skill (83) as
  **CARRY_VERBATIM** (33 jurors), **TRANSLATE** (57), or **LEAVE_BEHIND** (56).

## Task

1. **Delete what is already migrated.** For each CARRY_VERBATIM and TRANSLATE
   item, **verify the v2 counterpart actually exists** before deleting the v1
   copy — confirm the carried juror seat or the translated role/skill/script is
   genuinely present and complete in v2 (`roles/`, `roles/jurors/`, `skills/`,
   `scripts/`). Do not delete off the manifest blindly; the manifest is the map,
   the v2 tree is the territory. Anything whose v2 counterpart is confirmed
   present is redundant in v1 and should be removed.
2. **Keep what is not yet migrated.** TRANSLATE items whose translation has not
   landed, and anything else still of value, stays. Err toward keeping when in
   doubt; deletion is the irreversible direction.
3. **Assess the remaining material's value.** For everything left under `v1/`
   after the prune (LEAVE_BEHIND items, un-landed translations, prompts, designs,
   Dockerfiles, scripts), judge: is it worth migrating, safe to drop later, or a
   maintainer decision? Note anything historically valuable (e.g. the original
   `proposal.md`, project prompts) the maintainer may want to preserve elsewhere.
4. **Message the maintainer** with the assessment via
   `scripts/jobs/message-user.sh <your-base>`: what you deleted (summary, not a
   274-line list), what remains and why, and your value judgment on the remainder
   with a recommendation. Surface any item where you were unsure rather than
   deleting it.

## Mechanics

`v1/` is a worktree on `main`; removing files there commits to `main`. Choose the
cleanest approach (delete files and commit on `main` under the bot identity, or —
if the whole tree turns out fully redundant — propose removing the worktree to
the maintainer rather than doing it unilaterally). Commit under the bot identity;
do not push to `main2`. If git mechanics block you, report the diagnosis and the
exact ready-to-apply steps rather than claiming completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 93
  claimed_at: 2026-06-24T10:02:07Z
