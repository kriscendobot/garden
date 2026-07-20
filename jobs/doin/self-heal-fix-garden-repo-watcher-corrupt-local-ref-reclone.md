In `scripts/jobs/common.sh`, add self-healing for a **corrupt local journal clone** (as opposed to a missing `.git`, which `ensure_clone` already handles, and an offline fetch, which `sync_clone` already skips).

Failure signature (repo-watcher, exit 1, recurring every tick): `.garden-state/repo-watcher/journal/.git/refs/heads/journal2` is a zero-byte loose ref shadowing a valid `packed-refs` entry, so `git fetch` dies with `fatal: bad object refs/heads/journal2`, `did not send all necessary objects`, `bad ref for .git/logs/refs/heads/journal2`, `bad ref for .git/logs/HEAD`; `fsck` confirms `invalid sha1 pointer 0000…` / `invalid HEAD`. `journal_fetch`'s bounded retries can never repair local corruption, so `sync_clone` reaches `die "fetch failed in $dir after bounded retries"` (common.sh:2510) and the watcher exits 1 forever.

Change:
1. Add a `_fetch_stderr_is_corrupt <stderr>` classifier next to `_fetch_stderr_is_offline`, gating case-insensitively on a distinct local-corruption signature set: `bad object refs/`, `bad ref for`, `invalid sha1 pointer`, `did not send all necessary objects`, `invalid HEAD`, `corrupt`, `unable to read (tree|sha1)`. Keep this set separate from `GARDEN_OFFLINE_SIGNATURES` — these are the opposite classification (local, not network).
2. In `sync_clone`, before the terminal `die "fetch failed in $dir after bounded retries"`: if the failure is `_fetch_stderr_is_corrupt "$GARDEN_FETCH_STDERR"`, log a WARN (`local journal clone corrupt; self-healing by re-cloning`), `rm -rf "$dir"` while holding the existing `clone_lock "$dir"`, call `ensure_clone "$dir"` to atomically re-create the clone (reusing its temp-clone-then-rename path), then re-run `journal_fetch`/reset once. Only `die` if the re-clone+refetch still fails. Bound the re-clone to one attempt per tick so a genuinely unreachable remote can't loop.
3. Reuse the existing `clone_lock`/`clone_unlock` discipline so a concurrent producer never races the wipe (mirror ensure_clone's poisoned-partial-clone handling, which this generalizes from "missing .git" to "corrupt refs/reflogs").

Because every gardener and watcher routes journal reads through `sync_clone`, this fix covers the whole fleet, not just repo-watcher. Add a unit test alongside the existing sync_clone offline-classification tests: inject a `GARDEN_FETCH_CMD` (or seed a zero-byte loose ref in a throwaway clone) that emits the corruption stderr, and assert sync_clone re-clones and recovers rather than dying. As a one-time unblock, the fix job may also `rm -rf /home/kris/garden/.garden-state/repo-watcher/journal` on the affected host so the watcher recovers on its next tick before the code fix lands.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 7
  worker_kind: gardener
  claimed_at: 2026-07-20T02:58:58Z
