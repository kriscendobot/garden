---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`sync_clone()` in `scripts/jobs/common.sh` (~line 6013-6024) has a silent-failure path shared by every watcher (receipt-watcher, ci-watcher, comment-watcher, ...) that calls it. When the first `git -C "$dir" reset -q --hard "origin/$JOURNAL_BRANCH"` fails, the function re-fetches to classify an offline outage; if that re-fetch *succeeds* (rc=0), the `[ "$rc" -ne 0 ] && _fetch_stderr_is_offline ...` guard is false, so it falls through to a second, completely unguarded `git -C "$dir" reset -q --hard "origin/$JOURNAL_BRANCH"` with no `if`, no captured rc, and no `die`/`log` call. Under `set -e` a failure there kills the function on git's raw exit code with no diagnostic text attributed to it via `log`/`die`.

Observed failure signature: `garden-receipt-watcher@kriscendobot-test262` FATAL'd with `receipt journal prerequisite failed for kriscendobot/test262 (rc=1; see prerequisite stderr above)` where the self-heal capture blob (`efa3950926619b2f116ef83c9cd74df47fbdd9e1`, 157 bytes) contains ONLY that final line — `$PREREQ_ERR` in `receipt-watcher.sh` (lines 78-93) was empty when the "see prerequisite stderr above" message was emitted, because the actual failing command upstream in `sync_clone` never routed through `die()`/`log()`.

Fix: wrap the second reset at common.sh:6023 the same way the first one is guarded — capture its rc and call `die "hard reset of $dir onto origin/$JOURNAL_BRANCH failed after re-fetch"` (or equivalent) on failure, so every caller relying on `$PREREQ_ERR`/`shared_availability_failure`-style classification (receipt-watcher.sh, ci-watcher.sh, comment-watcher.sh) gets an actual diagnostic instead of a dangling "see above" with nothing above it. Add/extend the `receipt-watcher-test.sh` structural-failure case to cover a second-reset failure specifically.
