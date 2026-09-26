Done. Completion report follows.

---

## prune-v1-legacy — completion report

**Outcome:** Pruned the migrated v1 material, kept the un-migrated remainder, assessed the rest, and messaged the maintainer.

**What I did**
1. Read the migration manifest (`designs/v1-migration-manifest.md`) and treated it as the map, not the territory.
2. Verified every CARRY_VERBATIM / TRANSLATE item's v2 counterpart is **present and substantive** on main2 (file exists, non-empty, no stubs — judicial roles are legitimately smaller because their substance moved into `scripts/jobs/gardening/`). Caught one live change: `coverage-driven-testing` landed in v2 at 07:51 during this job.
3. Deleted the confirmed-redundant v1 copies and committed on v1 `main` under the bot identity (endolinbot), commit `bbea983c`.

**What changed**
- Removed **125 files** from `/home/kris/v1`: the 33 carried juror seats (all of `roles/jurors/`), 18 translated roles, and 38 translated skills. v1 went 274 files/3.1M → 150 files/1.7M.
- **Not pushed.** v1 `main` has diverged from `origin/main` (70 local / 72 remote). The job forbade pushing main2 and was silent on main; pushing a diverged branch unilaterally is risky, so the commit is local-only and flagged for the maintainer.

**What I kept (deliberately)**
- `skills/yarn-lock-separate-commit` — the only TRANSLATE skill whose v2 counterpart has **not** landed.
- All 12 LEAVE_BEHIND roles + 44 LEAVE_BEHIND skills, and every top-level artifact (prompts, designs, Dockerfiles, scripts, references, tests) — these were outside the manifest's role/skill classification, so I assessed rather than deleted them.

**Assessment sent to maintainer** (`message-user.sh prune-v1-legacy`, delivered `20260624T100643Z-c6cc7e`), covering: (1) top-level material already redundant in v2 (`references/endo-but-for-bots`, `scripts/checks` + tests, `designs/driver.md`) → recommend a maintainer-authorized second prune; (2) historically valuable, non-regenerable items to preserve first (`proposal.md` grant proposal, `agoric-prompt.md`, `cosgov-prompt.md`, v1 README/WORKTREES/CLAUDE narrative); (3) superseded driver/daemon infra safe to drop later.

**Follow-ups surfaced**
- Translate `yarn-lock-separate-commit` into v2 (referenced by the v2 retcon-job design).
- Manifest note is stale: v2 `roles/COMMON.md` is now 215 lines (authored). Confirm the 4 house-style rules folded in, then those v1 skills can also drop.
- Maintainer decision: once the historical docs are preserved and the redundant top-level dirs confirmed, the whole `v1/` worktree is a `git worktree remove` candidate rather than a stripped 1.7M shell. I did not do this unilaterally.

**Unsure items I chose to keep rather than delete:** the redundant-but-unclassified top-level dirs (flagged for authorization) and `yarn-lock-separate-commit` (un-landed). No deletions were made off the manifest without a verified v2 counterpart.
