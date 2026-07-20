In scripts/jobs/common.sh, add a corruption self-heal for a per-worker journal clone whose object/ref DB is damaged but whose `.git` dir still exists — the case `ensure_clone`'s existing poisoned-partial-clone heal (the `[ ! -d "$dir/.git" ]` branch) does not cover.

Failure signature (observed on `.garden-state/gardeners/14/journal`, gardener exit 1, recurs every restart):
  fatal: bad object refs/remotes/origin/journal2
  error: <remote> did not send all necessary objects
  ... Please correct the root cause and remove .git/gc.log
  fatal: failed to run repack
`git fsck` shows `refs/remotes/origin/journal2` = all-zeros (`invalid sha1 pointer`) plus a stale `.git/gc.log`. Because none of these strings are in `GARDEN_OFFLINE_SIGNATURES`, `_fetch_stderr_is_offline` is false, `journal_fetch` returns rc=1, and `sync_clone` hits `die "fetch failed in $dir after bounded retries"` — so the worker exits 1 and systemd restarts it into the identical wedge indefinitely.

Fix (mirror the atomic re-clone ensure_clone already does for the missing-`.git` case, keyed on a corruption signature that is deliberately DISTINCT from the offline set):
1. Add a `_fetch_stderr_is_corrupt` classifier (or a `GARDEN_CORRUPT_SIGNATURES` regex) covering at least: `bad object`, `failed to run repack`, `did not send all necessary objects`, `invalid sha1 pointer`, `bad ref for`, `unable to read tree`, `loose object .* is corrupt`, `object file .* is empty`. Keep it separate from `GARDEN_OFFLINE_SIGNATURES` so a corrupt clone is NOT misclassified as a transient outage (which would silently skip forever instead of repairing).
2. In `sync_clone`'s post-fetch failure branch, before `die`: if `_fetch_stderr_is_corrupt "$GARDEN_FETCH_STDERR"` is true OR a stale `.git/gc.log` exists, log a WARN ("corrupt journal clone; self-healing by re-cloning"), remove `.git/gc.log`, then re-clone `$dir` atomically — the same `rm -rf "$dir"` + sibling-`*.tmp.$$` clone + atomic `mv` under `clone_lock` that ensure_clone uses — and retry the fetch/reset once. If the re-clone or the retried fetch still fails, fall through to the existing offline/die classification.
3. Do the repair under the per-clone lock (clone_lock/clone_unlock) so a concurrent producer cannot race the destination, exactly as ensure_clone does.

Keep the change surgical and covered by a test in scripts/jobs/test/ that seeds a clone with a zeroed `refs/remotes/origin/journal2` + a stale `.git/gc.log`, runs the claim/sync path, and asserts the clone is transparently re-cloned and the worker no longer exits 1. Note in a comment that this is the ref/object-DB-corruption sibling of ensure_clone's poisoned-partial-clone heal.
