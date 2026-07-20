`scripts/jobs/common.sh` — teach `sync_clone` to self-heal a *corrupted* (not just partial) journal clone, mirroring the existing poisoned-partial-clone healer in `ensure_clone`.

**Failure signature (garden-cleric/7, and any per-worker clone under `.garden-state/*/journal`):** `git fetch` fails permanently with
`fatal: bad object refs/remotes/origin/journal2` + `error: … did not send all necessary objects` + `fatal: failed to run repack`, driven by a zeroed remote-tracking ref (`git fsck`: `invalid sha1 pointer 0000…0000`, `bad ref for .git/logs/refs/remotes/origin/journal2`) plus a lingering `.git/gc.log` that blocks the fetch-time auto-repack. Because the dir has a valid `.git`, `ensure_clone`'s partial-clone re-heal never fires and `sync_clone` `die`s on every tick/restart.

**Change:**
1. Add a `_fetch_stderr_is_corrupt` classifier next to `_fetch_stderr_is_offline` (case-insensitive), matching the persistent-corruption signature set — as a single source of truth like the offline regex: `bad object`, `did not send all necessary objects`, `failed to run repack`, `invalid sha1 pointer`, `broken ref`, `unable to read (tree|sha1)`, `loose object .* (is corrupt|empty)`, `object file .* is empty`. Keep it disjoint from the offline set so a network blip is never mistaken for corruption.
2. In `sync_clone`, in the `rc != 0` branch **after** the offline check but **before** `die "fetch failed in $dir after bounded retries"`: if `_fetch_stderr_is_corrupt "$GARDEN_FETCH_STDERR"`, log a WARN (e.g. `"$dir corrupt (bad ref / failed repack); self-healing by re-cloning"`), destroy the clone (`rm -rf "$dir"`), call `ensure_clone "$dir"` to atomically re-clone (its temp-then-rename path is already safe and re-entrant under the held `clone_lock`), then retry `journal_fetch "$dir"` **once**. On success, fall through to the `reset --hard`; on repeat failure, `die` as before so a genuinely unrecoverable remote still surfaces. Guard against a heal loop (heal at most once per `sync_clone` call).
3. Add a regression test under `scripts/jobs/test/` driving a `GARDEN_FETCH_CMD` (or a fixture clone with a zeroed `refs/remotes/origin/journal2` + planted `.git/gc.log`) that asserts `sync_clone` re-clones and recovers rather than dying, symmetric to the existing offline-classification tests.

**Immediate one-shot unblock (safe to do out of band, independent of the code fix):** `rm -rf /home/kris/garden/.garden-state/clerics/7/journal` (a single-branch, hard-reset-on-every-sync disposable clone with no local-only state) so the next tick re-clones fresh.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  claimed_at: 2026-07-20T04:57:16Z
