# Harden the deployed garden root repo against job git-escapes (incident 2026-07-17 / 2026-07-21)

Two independent jobs corrupted the DEPLOYED root repo (`$GARDEN_ROOT/.git`, shared
by the root checkout AND the `journal/` worktree) by running git commands with the
root repo as the enclosing repository. Repaired 2026-07-21 ~15:25Z by the
data-plane press gardener; this job is the durable fix.

Evidence (all from the root repo's reflogs before repair):

1. **2026-07-17 11:38Z — native-git test fixture escape.** A test created
   `tmp/native-git-TdaKeS/` under the garden root but never `git init`-ed it, so
   its `git checkout -b feature` / `commit base commit` / `commit feature commit`
   / `commit main commit` ops ascended to the root repo: HEAD moved from the
   deployed detached `374deede65` onto a fixture `feature` branch, and the
   pre-existing v1 `main` branch was moved from `bbea983c7d` to a fixture commit.
   The fleet ran the fixture-branch working tree for four days.
2. **2026-07-21 11:23:19Z — project-work escape (job `xs2rust-endor-press-20260721-110503`,
   claimed by hermit-1 at 11:05Z).** The worker treated the garden root as its
   project checkout: `git remote set-url origin ssh://git@github.com/endojs/endo-but-for-bots.git`,
   fetch (replacing/pruning the true origin refs incl. `origin/journal2`,
   `origin/main2`), and `git branch xs2rust-endor origin/xs2rust-endor` — all in
   the root repo (config mtime 11:23:19 matches the branch-creation reflog
   exactly). This broke journal sync host-wide (journal worktree froze at 11:12Z;
   `inbox-read.sh`/`message-user.sh` FATALed) and poisoned the
   `.garden-state/config/journal-remote` cache. The fleet survived only because
   per-gardener state clones pin their own correct origin. Nothing was pushed to
   endo-but-for-bots (verified: no journal2/main2 branches there).

Also observed: deploys have been stalled since 07-17 (root restored to the
pre-incident deployed commit `374deede65`; `origin/main2` is at `8eb3354a7e`), and
untracked job debris sits at the root (`bin/pnpm`, `bin/pnpx`, `bin286/`,
`pr661-bin/`, plus a large `tmp/` pile).

Proposed hardening (design the right subset, then land it on main2):

- **A root-repo guard/reconciler**: a cheap leader-or-every-host timer (or a step
  in an existing keeper) that asserts the root repo invariants — `remote.origin.url`
  matches `GARDEN_PRODUCTION_JOURNAL_REMOTE_RE`, HEAD is detached at a main2
  ancestor (never a branch like `feature`), no unexpected local branches — and
  repairs + alerts on drift instead of letting the fleet run corrupted for days.
- **Worker discipline**: the escape class is "git command whose repo resolution
  ascends past the intended directory". Candidates: export `GIT_CEILING_DIRECTORIES=$GARDEN_ROOT`
  in gardener/hermit harnesses so an un-inited fixture dir FATALs instead of
  ascending; and/or a pre-claim `git -C $GARDEN_ROOT remote get-url origin`
  checksum the reaper/self-heal can compare.
- **Hermit prompt hardening** for the xs2rust-endor press family: the worker must
  use `ensure-project-worktree.sh` and never run git in `$GARDEN_ROOT`.
- Consider whether the stalled-deploy condition (root ≠ origin/main2 for >N days)
  deserves its own watchman alert.

Full incident narrative: maintainer message from press dispatch
`endo-daemon-data-plane-press-20260721-152002`, 2026-07-21.
