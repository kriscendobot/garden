Fix the triager's bare-clone lookup path and its handling of a genuinely-missing clone. Two defects, both in scripts/jobs/.

Failure signature (every triager tick, leader host): `FATAL: no bare clone at /home/kris/garden2/repos/<slug>.git (clone the repo first)` from triager.sh:32, self-heal-storming garden-triager@ every 2 minutes. Verified the same failure hits garden-triager@kriscendobot-endo despite worktrees/kriscendobot-endo.git existing.

(A) Wrong default clone directory — SYSTEMIC. `scripts/jobs/triager.sh:25` and `scripts/jobs/comment-watcher.sh:179` both default `: "${GARDEN_REPOS:=$GARDEN_ROOT/repos}"`, but the fleet's standing bare clones live under `$GARDEN_ROOT/worktrees/<owner>-<name>.git`, per clone-keeper.sh (header + GARDEN_TRACKED_CLONES), ensure-project-worktree.sh:63, CLAUDE.md § Layout, and the actual filesystem (repos/ does not exist; worktrees/kriscendobot-endo.git, -finbot.git, -agoric-sdk.git, -minion.town.git, -vattr97.git all do). Change the default in BOTH files to `$GARDEN_ROOT/worktrees`. This alone heals every triager whose fork clone already exists (endo, finbot, agoric-sdk, minion.town, vattr97) and points cosgov at the right directory. Grep for other `GARDEN_REPOS` consumers before landing to confirm none rely on the old `repos` value (the test harness passes GARDEN_REPOS explicitly, so it's unaffected).

(B) Genuinely-missing clone should not FATAL-storm — cosgov-specific but general. After (A), `worktrees/kriscendobot-cosgov.git` still does not exist: the fork was auto-armed today by fork-watch-provisioner.sh (arming record journal/repos/kriscendobot-cosgov, armed_at 2026-07-10T06:01:51Z) but no bare clone was created on this host, and repo-watcher.sh arms the unit without cloning the fork. Preferred fix: make triager.sh clone-on-demand when `$BARE` is absent — derive the fork URL the same way clone-keeper.sh does (its `derive_clone_url`: strip `.git`, split basename on first `-` into `<owner>/<name>`, form `$GARDEN_CLONE_URL_BASE/<owner>/<name>.git`) and do a bounded `git clone --bare` before proceeding, so triage coverage for a newly-armed fork actually starts. Acceptable fallback if clone-on-demand is out of scope: mirror comment-watcher.sh:312 and degrade a missing bare clone to a clean skip (`log` + `exit 0`) instead of `die`, so an armed-but-uncloned fork no longer FATAL-storms the self-heal responder every tick. Either way, add a short comment tying the behavior to this failure signature.

Verify: run scripts/jobs/test/comment-watcher-test.sh (exercises GARDEN_REPOS) and any triager test, then confirm `bash scripts/jobs/triager.sh kriscendobot-endo` on the leader resolves worktrees/kriscendobot-endo.git and exits 0.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 10
  claimed_at: 2026-07-10T22:55:21Z
