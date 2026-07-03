## Completion report

**What the job asked:** harden `journal_remote()` so a dangling/unreadable `$GARDEN_ROOT/journal` gitlink no longer kills every service that resolves the journal remote, plus have the journal-worktree-keeper repair the root cause.

**What I did (landed on `origin/main2` as `cdd341056`):**

1. **`common.sh` `journal_remote()` — root-origin fallback.** While I worked, two peer commits landed the same class of fix and refactored a shared `ensure_journal_worktree_linked` (repair+prune) helper — but that path still `die`d with "broken journal worktree" when the admin dir is *gone* (not just mis-pointed), so it still killed every consumer. I added the fallback this job specifies: after the journal worktree's `git config --get remote.origin.url` fails, try `git -C "$GARDEN_ROOT" config --get remote.origin.url` (journal2 and main2 share one repo/remote → same origin `git@github.com:kriskowal/garden.git`), and `die` only if **both** are empty.

2. **`journal-worktree-keeper.sh` `jw_repair_gitdir()` — prune stale registrations.** The peer's keeper repaired the gitdir but didn't prune. I added `git -C "$GARDEN_ROOT" worktree prune` after the repair to drop the abandoned `garden2/*` admin entries a root relocation leaves behind.

**Verification:** hermetic function-level tests confirm all three cases — dangling journal + valid root origin → fallback URL; nothing anywhere → clean `die`; healthy journal → its own origin, no fallback. The peer's `journal-worktree-keeper-test.sh` DANGLING-GITDIR case passes with the merged logic. Both changes confirmed present on `origin/main2` after push.

**Follow-up worth flagging:** `journal-worktree-keeper-test.sh` is **not hermetic w.r.t. `GARDEN_ROOT`** — run from inside a linked worktree it scrubs `GARDEN_*` env, so `common.sh` re-derives `GARDEN_ROOT=/home/kris` (the real deployed root) and the keeper's `git worktree repair`/`prune` operate on the **real** garden's admin dir. During this job that pruned my own job worktree's registration and broke its gitdir link (ironically the exact bug this job fixes); I recovered by re-applying the work in a fresh recovery worktree. The test should pin `GARDEN_ROOT` to its fixture root before invoking the keeper. Not fixed here (out of scope), but it's a live foot-gun for any gardener that runs that test from a worktree.
