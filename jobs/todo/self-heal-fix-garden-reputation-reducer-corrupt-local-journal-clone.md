**Failure signature:** `garden-reputation-reducer` (and any `sync_clone` caller) dies exit 1 on every tick when the local journal clone at `$GARDEN_STATE/reducer/journal` contains a corrupt/zero-length loose object: `error: object file .git/objects/7c/57850328...be is empty` → `fatal: fetch-pack: invalid index-pack output` → `sync_clone` reaches `die "fetch failed in $dir after bounded retries"`. Retries and the existing offline classifier cannot fix it because the corruption is in the *local* repo; `ensure_clone`'s poisoned-partial-clone heal doesn't fire because `.git/` is present and structurally valid.

**What to change and why — `scripts/jobs/common.sh`:**

1. Add a corruption classifier next to `_fetch_stderr_is_offline` (~`common.sh:1722`), mirroring the `GARDEN_OFFLINE_SIGNATURES` pattern with a single-source-of-truth signature set:
   ```
   : "${GARDEN_CORRUPT_CLONE_SIGNATURES:=object file .* is empty|loose object .* is corrupt|invalid index-pack output|did not receive expected object|unable to read .* object|fsck error|packfile .* cannot be accessed}"
   _fetch_stderr_is_corrupt() { printf '%s' "$1" | grep -qiE "$GARDEN_CORRUPT_CLONE_SIGNATURES"; }
   ```
   These are *local-repo* failures, distinct from the connectivity signatures — do NOT fold them into `GARDEN_OFFLINE_SIGNATURES` (an offline skip would just wedge again next tick; corruption needs an actual repair).

2. In `sync_clone` (`common.sh:~2506`), before the `die "fetch failed ... after bounded retries"`, add a self-heal branch that fires when `_fetch_stderr_is_corrupt "$GARDEN_FETCH_STDERR"` matches: log a WARN ("corrupt local journal clone $dir; self-healing by re-cloning"), `rm -rf "$dir"`, then `ensure_clone "$dir"` + one more `journal_fetch`/reset (the atomic-temp-then-rename path in `ensure_clone` already makes the re-clone crash-safe). Keep it under the same `clone_lock "$dir"` already held so no producer races the destination. Guard against an infinite reclone loop by only self-healing once per tick (if the post-reclone fetch still fails, fall through to `die` as today). This converges on the next tick exactly like the poisoned-partial-clone heal does.

Optionally, a lighter first attempt before the full reclone — `git -C "$dir" prune-packed` won't clear an empty loose object, but the reclone is the reliable cure, so prefer the reclone path for determinism.
