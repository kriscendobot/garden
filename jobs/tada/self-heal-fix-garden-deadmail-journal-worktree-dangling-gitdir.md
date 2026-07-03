The job is already fully satisfied by peer-landed work on `origin/main2`, verified below. I did **not** push my duplicate — it would only conflict with and re-do already-landed code.

## Completion report

**Outcome: the job's fix is already landed on `origin/main2` (by a swarm of peer gardeners during the fleet-wide dangling-gitdir recovery storm). Verified complete; no duplicate pushed.**

What the landed commits cover (all three job requirements):
- **Keeper repair (req 1 & 2):** `journal-worktree-keeper.sh:jw_repair_gitdir()` runs as a pre-flight in `keep_journal_worktree()` *before* the fetch. It detects a wedged worktree (resolved gitdir missing / `rev-parse --git-dir` failing), runs `git -C "$GARDEN_ROOT" worktree repair "$JW"` to rewrite both cross-pointers, then `worktree prune` to drop the stale `garden2/*` admin registrations — idempotent and lossless. (commits `ce4b94831`, `b208fb932`, `53a062507`)
- **`common.sh` hardening (req 3):** `journal_remote()` now (a) pre-flight self-heals via `ensure_journal_worktree_linked` (common.sh:643), (b) falls back to the main repo's origin URL (same repo/remote as journal2) so a still-broken worktree no longer kills every remote-resolving service (garden-deadmail included), and (c) emits an explicit "run `git worktree repair`" hint naming the dangling gitdir target instead of the bare "no origin" failure. (commits `ef323fc4a`, `a0ddbce44`, `cdd341056`)

Verification I ran: the landed keeper test passes **43/0** across repeated runs; `ensure_journal_worktree_linked` is present; `git -C /home/kris worktree list` shows `journal` repaired and re-registered — the shared dependency now resolves.

What I changed: nothing on `origin/main2` (my equivalent fix was redundant and unpushed). Cleaned up my recovery/stage worktrees.

**Follow-up worth flagging to the maintainer:** mid-session, a concurrent peer's repair against the *shared* `/home/kris` root wiped the entire `.git/worktrees/` directory, orphaning healthy gardener worktrees (including this job's own cwd — my edits survived on disk and I recovered via a detached worktree). The landed keeper is safe here (it only ever does scoped `worktree repair`/`prune`, never `rm -rf .git/worktrees`), but if any of the sibling `garden-gardener` / `garden-gardener-scaler` repair jobs used a blunt `rm -rf worktrees`-style repair, that is destructive to peer worktrees and should be audited. This also argues for the job's own premise — centralizing the repair in the keeper rather than letting each consumer improvise.
