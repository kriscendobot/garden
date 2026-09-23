The standing clone the job describes (`worktrees/kriscendobot-minion.town.git`, HEAD `main`) exists exactly where the fix now points. Work is complete.

## Completion report

**Finding: the requested fix already fully landed on `main2` before I claimed this job.** This was a fleet-wide outage, so many gardeners raced near-identical self-heal jobs; the code changes this job asks for were committed by peers (`2c76c8cd92` → `83e0eb0f41`, plus test `54ed2c98f0`), all already at `origin/main2` HEAD. My worktree HEAD equals `origin/main2` with a clean tree — there was nothing left to write.

I misread the deployed root's *stale* `triager.sh` first (`/home/kris/garden2/scripts/jobs/...`), which still shows the old `repos/` default and hard `die` — that stale deployed copy is exactly why production `garden-triager@*` units keep FATAL-storming. The `main2` source is already fixed.

**What `main2` now contains (all three job asks satisfied):**
1. **Bare-clone lookup points at `worktrees/`.** A shared `bare_clone_dir` resolver in `common.sh:479-481` defaults to `${GARDEN_REPOS:-$GARDEN_ROOT/worktrees}`; both `triager.sh:46` and `comment-watcher.sh:326` use it, so their defaults can't drift. No `GARDEN_REPOS:=…/repos` default survives anywhere in `scripts/jobs/`. Header comment updated accordingly.
2. **Hard `die` replaced with self-provisioning** (`triager.sh:73-115`), mirroring `clone-keeper.sh`'s `keep_clone`: guards on `is_own_git_repo`; a genuinely-missing clone under opt-in `GARDEN_TRIAGE_SELF_PROVISION=1` does `derive_clone_url` → `bounded_clone` → sets `remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'` → falls through to fetch; unreachable/underivable sources skip cleanly (exit 0, retry) and escalate to the maintainer inbox; a present-but-corrupt dir is surfaced (STALE + escalate), never clobbered. Default (no opt-in) is a benign clone-holder skip, not a die.
3. **Test coverage present and passing** — `triager-test.sh` cases A–G (found-clone reaches fetch/cursor for `kriscendobot-minion.town`, ref `main`), H1/H3/H4 (self-provision success / unreachable / underivable), I (default resolves under `worktrees/`, not `repos/`), J (corrupt dir).

**Validation:** `triager-test.sh` 68/68, `comment-watcher-test.sh` 213/213, `clone-keeper-test.sh` 45/45. Confirmed `worktrees/kriscendobot-minion.town.git` exists with HEAD `main` — the found-clone path resolves against real data.

**Follow-up (out of gardener scope):** the code fix is on `main2` but **not yet deployed** to the root checkout, so production triagers will keep crash-looping until the liaison runs the deliberate deploy (`deploy-garden.sh` via `garden-upgrade-monitor`). The outage stops only after that deploy — worth flagging to the maintainer/liaison.

No commit or push was needed (tree already at `origin/main2`, clean).
