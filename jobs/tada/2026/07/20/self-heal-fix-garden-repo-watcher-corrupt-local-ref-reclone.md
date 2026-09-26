Inbox empty. The work is complete and pushed.

## Completion report

**Job:** Add self-healing for a corrupt local journal clone in `scripts/jobs/common.sh` (repo-watcher crash-loop: zero-byte loose `refs/heads/journal2` shadowing valid `packed-refs`, killing every `git fetch`).

**What I found:** The prior commits on `main2` had *already* landed a corrupt-clone heal, but with a defect — a **two-stage** repair whose cheap stage (a) (`update-ref -d refs/remotes/origin/journal2` + `remote prune`) only touches the *remote-tracking* ref. That stage cannot heal the reported failure (a corrupt *local* `refs/heads/journal2` + reflogs), and its extra fetch **broke the committed test** (SUBTEST 5 failed: `fetches=3`, expected `2`; the poison file survived because the wipe/re-clone never ran). So the committed state shipped a red test.

**What I changed (`scripts/jobs/common.sh`):**
- Collapsed the heal to the **spec's single-stage** path: on a corrupt-clone signature, `rm -rf "$dir"` under the already-held `clone_lock`, re-provision atomically via `ensure_clone` (run in a subshell so its terminal `clone_unlock` can't drop the parent's flock), then re-fetch once; `die` only if the re-clone+refetch still fails; offline races still take the clean-skip (`EX_TEMPFAIL`) path. Heals both the remote-tracking null-sha case and the corrupt-local-ref case, one attempt per tick.
- Added `invalid HEAD` to `GARDEN_CORRUPT_CLONE_SIGNATURES` (explicitly named in the failure signature) and updated the rationale comment.

**Test (`scripts/jobs/test/fetch-timeout-test.sh`):** Added a regression assertion that the *exact* reported repo-watcher stderr (`bad object refs/heads/journal2`, `bad ref for .git/logs/HEAD`, `invalid HEAD`, …) classifies as **corrupt and not offline**. Full suite: **14 passed, 0 failed**.

**Merge:** A concurrent commit (`746440995b`, gc.log/repack classifier signatures) landed mid-push; I rebased and merged the classifier sets (union: their `does not point to a valid object` / `failed to run repack` / `gc\.log` / generic `unable to read` + my `invalid HEAD`) and comment, re-ran the suite green, and pushed.

**Pushed:** `194db253c8` on `origin/main2`.

**One-time unblock:** Not needed on this host — the path named in the job (`/home/kris/garden/.garden-state/...`) doesn't exist here (root is `/home/kris/garden2`), and the actual `…/garden2/.garden-state/repo-watcher/journal` clone is already healthy (valid 41-byte `refs/heads/journal2`, `fetch --dry-run` succeeds).

**Follow-ups:** None. The fix routes through `sync_clone`, so it covers the whole gardener/watcher fleet, not just repo-watcher.
