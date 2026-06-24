# Translate the v1 `yarn-lock-separate-commit` skill into v2

The v1→v2 migration left exactly one TRANSLATE skill unlanded:
**`skills/yarn-lock-separate-commit`** (identified by the prune-v1-legacy job). Its
v2 counterpart does not yet exist, and the v2 **retcon-job** design already
references the lockfile-split practice it encodes — so the skill is a live
dependency, not dead weight.

## Task

1. Read the v1 skill at `v1/skills/yarn-lock-separate-commit/SKILL.md` (the v1
   garden worktree at `/home/kris/v1`, branch `main`) and the
   [`designs/v1-migration-manifest.md`](designs/v1-migration-manifest.md) entry
   that classifies it TRANSLATE (so you apply the same translation lens the other
   57 translated artifacts used: job-board/message-bus coordination, gardener
   fleet, "gauntlet" not "gamut", etc.).
2. Author the v2 skill at `skills/yarn-lock-separate-commit/SKILL.md` on `main2`,
   translated to v2 mechanisms and house style (em-dash, no Latin shorthand,
   relative paths, test-title spelling per `roles/COMMON.md`). Keep the substance
   — a separate `chore: Update yarn.lock` commit, implementation+tests combined —
   and wire it to wherever v2 references the lockfile split (the retcon-job
   design / `scripts/jobs/gardening/`).
3. Add it to the skill inventory in `CLAUDE.md` and cross-link it from the retcon
   design/skill that depends on it.

## Deliverable

`skills/yarn-lock-separate-commit/SKILL.md` on `main2` (committed under the bot
identity), with the inventory and cross-links updated. Report the SHA. Once it
lands, the v1 copy can be dropped in a later prune — note that, do not delete the
v1 copy here.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 44
  claimed_at: 2026-06-24T10:19:33Z
