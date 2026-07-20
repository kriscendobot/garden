In `scripts/jobs/common.sh`, extend the clone self-heal to cover a corrupt-but-present `.git`, mirroring the existing "poisoned partial clone" recovery in `ensure_clone` (lines ~1538–1571).

Failure signature (recurs identically, systemd restart cannot clear it): a gardener claim dies at `sync_clone` → `journal_fetch` with
`fatal: bad object refs/remotes/origin/journal2` / `did not send all necessary objects` / `failed to run repack`, plus a leftover `.git/gc.log`, on `/home/kris/garden/.garden-state/gardeners/<n>/journal`. Not an offline signature, so it correctly bypasses the EX_TEMPFAIL skip and hits `die "fetch failed … after bounded retries"` (line ~2510) on every restart.

Change:
1. Add a cheap health probe used by `ensure_clone` (and/or as a fallback in `sync_clone`'s die path): when `$dir/.git` exists, verify the clone is usable, e.g. `git -C "$dir" rev-parse -q --verify "refs/remotes/origin/$JOURNAL_BRANCH^{commit}"` (and/or `git -C "$dir" cat-file -e HEAD^{commit}`). If it fails, or `$dir/.git/gc.log` is present, treat the clone as corrupt.
2. On corruption, self-heal exactly like the partial-clone branch: `log "WARN: … corrupt clone; self-healing by re-cloning"`, `rm -rf "$dir"`, then the same atomic `git clone` into a sibling `.tmp.$$` + `mv` into place under the held `clone_lock`. Do not `die`.
3. Prefer routing `sync_clone`'s non-offline fetch failure through this re-clone recovery instead of dying outright, so a corrupt clone recovers on the next tick rather than marking the unit Failed.
4. As part of landing, clear the currently-wedged dir so gardener/14 recovers immediately: `rm -rf /home/kris/garden/.garden-state/gardeners/14/journal` (ensure_clone will re-clone it), or minimally delete its `.git/gc.log` and re-clone.

Add/extend a test alongside the existing poisoned-partial-clone coverage: seed a clone whose `refs/remotes/origin/$JOURNAL_BRANCH` is a bad object (and a stale `.git/gc.log`) and assert ensure_clone/sync_clone re-clones rather than dies. Land on `main2` (no PR — garden's own repo).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-20T06:27:29Z
