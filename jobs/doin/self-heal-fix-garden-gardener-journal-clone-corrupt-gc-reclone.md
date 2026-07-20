In `scripts/jobs/common.sh`, extend the clone self-heal so a present-but-corrupt journal clone is repaired instead of FATAL-looping. Today `ensure_clone` (~line 1538) only heals the missing-`.git` "poisoned partial clone" case; a clone whose `.git` exists but whose object/ref store is wedged is never detected, so `journal_fetch` exhausts its retries and `gardener.sh` exits rc=1 every tick.

Failure signature to key on (observed on `.garden-state/gardeners/6/journal`): `git fetch origin journal2` fails with `fatal: bad object refs/remotes/origin/journal2` + `error: … did not send all necessary objects`, `refs/remotes/origin/journal2: invalid sha1 pointer 000…`, `fatal: failed to run repack`, and/or a stale `.git/gc.log` present — none of which are in `GARDEN_OFFLINE_SIGNATURES`, so they are (correctly) classified as real repo errors, not offline blips.

Add a corruption-heal step that runs when a journal fetch fails with a corruption signature (`bad object|did not send all necessary objects|failed to run repack|invalid sha1 pointer|bad ref for`) AND `_fetch_stderr_is_offline` is false. Heal in two escalating tiers, both under `clone_lock`:
  1. Cheap repair (what fixed clone 6): `rm -f "$dir/.git/gc.log"`, delete the corrupt remote-tracking ref and its reflog (`rm -f .git/refs/remotes/origin/$JOURNAL_BRANCH .git/logs/refs/remotes/origin/$JOURNAL_BRANCH`, and drop any `packed-refs` line for it), then re-fetch.
  2. If the re-fetch still fails, fall back to the existing atomic re-clone path (`rm -rf "$dir"` → clone into `"$dir".tmp.$$` → atomic `mv`), exactly as the poisoned-partial-clone branch already does.
Log a `WARN: <dir> journal clone corrupt (<signature>); self-healing by <repair|re-clone>` line so recurrences are visible. Precedent for the re-clone-corrupt-clone pattern already exists in `issue-inbox-watcher.sh:heal_verify_clone` and `triager.sh` — reuse that shape. Wire the heal into the claim path so it fires before `journal_fetch` returns FATAL (e.g. in `ensure_clone`/`sync_clone` or the gardener claim preamble), keeping it idempotent and deterministic so an identical recurrence heals silently instead of FATAL-looping.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-20T03:27:07Z
