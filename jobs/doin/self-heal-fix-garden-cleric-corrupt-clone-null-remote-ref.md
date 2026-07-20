In `scripts/jobs/common.sh`, extend the journal-clone self-heal to cover a clone whose `.git` exists but is internally corrupt — the sibling case to the existing "poisoned partial clone" heal in `ensure_clone` (common.sh:1538-1567).

Failure signature (garden-cleric, work item 7; exit 1): the cleric's clone at `.garden-state/clerics/<id>/journal` had `refs/remotes/origin/journal2` set to a null sha1 (`0000…`) plus a stale `.git/gc.log`, so every `journal_fetch` (→ `sync_clone`, common.sh:2483) failed with `fatal: bad object refs/remotes/origin/journal2` / `did not send all necessary objects` / `fatal: failed to run repack`. That stderr matches no `GARDEN_OFFLINE_SIGNATURES` entry, so `sync_clone` correctly reaches `die "fetch failed in $dir after bounded retries"` (common.sh:2510) and exits 1 — but the corruption is persistent, so systemd's restart re-hits the same wedged clone in an infinite fail loop (mirrors the "145 identical FATALs" partial-clone incident the existing heal was written for).

Change: before `sync_clone` dies on a non-offline fetch failure, attempt a bounded in-place repair, then a reclone. Concretely, when `journal_fetch` returns non-zero AND the captured `GARDEN_FETCH_STDERR` is NOT offline, and the stderr matches a *local-corruption* signature (`bad object`, `did not send all necessary objects`, `invalid sha1 pointer`, `failed to run repack`, `bad ref`) or `.git/gc.log` is present:
  1. Repair in place: `rm -f "$dir/.git/gc.log"`; `git -C "$dir" remote prune origin` and/or delete the null-valued `refs/remotes/origin/$JOURNAL_BRANCH`; retry `journal_fetch` once.
  2. If still failing, treat the clone as disposable: `rm -rf "$dir"` and re-run `ensure_clone "$dir"` (fresh single-branch clone), then `journal_fetch` again.
  3. Only if the reclone also fails do we `die`. Log a `WARN: <dir> corrupt (<signature>); self-healing by prune/reclone` so the event is visible, matching the existing partial-clone WARN at common.sh:1555.

Guardrails: keep this strictly for the cleric/gardener journal *mirror* clones (no local-only state); do not apply reclone to live project/journal worktrees. Reuse `clone_lock`/`clone_unlock` so no concurrent producer races the destination. Add a signature constant next to `GARDEN_OFFLINE_SIGNATURES` (e.g. `GARDEN_CLONE_CORRUPT_SIGNATURES`) as the single source of truth, and a test in `scripts/jobs/test/run-test.sh` that injects a `GARDEN_FETCH_CMD` emitting the `bad object …/failed to run repack` stderr and asserts sync_clone reclones and succeeds rather than dying.

Immediate manual mitigation (independent of the code fix, to unwedge cleric 7 now): `rm -rf /home/kris/garden/.garden-state/clerics/7/journal` so its next tick re-clones cleanly.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: gardener
  claimed_at: 2026-07-20T07:58:19Z
