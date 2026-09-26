---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh

`sync_clone`'s hard-reset failure path (`scripts/jobs/common.sh:6595-6606`) classifies only *offline*, never *corrupt*, so a corrupt local object store surfaced by `reset --hard` is a permanent `die`/restart loop instead of the re-clone self-heal the fetch path already implements 40 lines above.

Failure signature (garden-sysop, exit 1, clone `.garden-state/sysop/journal`):

```
error: unable to read sha1 file of reputation/arms/gardener/anthropic/claude-opus-4-8/high/design-l@main2.md (ed1254525695b02c7e0fa6213383a70f4ee40fdf)
error: unable to read sha1 file of schedules/dependabotany-recheck-endo-but-for-bots.md (30ff9c635c7f7fc1a3852eabd02d63eee06c34a9)
fatal: Could not reset index file to revision 'origin/journal2'.
<6>[sysop] journal fetch in …/.garden-state/sysop/journal failed after 3 attempt(s) (last rc=128): fatal: cannot change to '…/.garden-state/sysop/journal': No such file or directory
<3>[sysop] FATAL: hard reset of …/.garden-state/sysop/journal to origin/journal2 failed after retry
```

Two changes, both scoped to `sync_clone`:

1. **Capture the reset's stderr and classify it for corruption.** The reset at `common.sh:6595` currently discards stderr (it goes straight to the log), so nothing can classify it. Capture it through the same `set -e`-safe `if VAR="$(cmd 2>&1 1>/dev/null)"` idiom `journal_fetch` uses, then reuse the **existing** helpers — `_fetch_stderr_is_corrupt` / `_fetch_stderr_corrupt_signature` (`common.sh:4337`, `4343`) plus the `[ -e "$dir/.git/gc.log" ]` check — and on a match take the same self-heal branch as `common.sh:6555-6571`: `rm -rf "$dir"`, `( ensure_clone "$dir" )`, re-fetch, reset, and log the `REPAIRED:` line with the signature. `unable to read` is already in `GARDEN_CORRUPT_SIGNATURES` (`common.sh:4335`), so no signature-set change is needed. Keep the existing once-only discipline: a corruption signature that survives the fresh clone is an upstream fault and must still `die`, never spin a re-clone loop.

2. **Handle a vanished clone directory instead of fetching into it.** Before the re-fetch in the reset-failure path, if `$dir/.git` is missing, call `ensure_clone "$dir"` to recreate it rather than calling `journal_fetch` on a nonexistent path — which wastes three backoff attempts on `cannot change to …: No such file or directory`, an error that is deterministically non-retryable and is deliberately excluded from both the offline and ambiguous-outage classes, so today it reaches no handler and dies.

Ordering note: classify **corrupt before offline** on the reset path, mirroring the fetch path, so a stderr blob containing both shapes self-heals rather than parking the tick as EX_TEMPFAIL forever.

Add regression coverage in `scripts/jobs/test/` alongside the existing `sync_clone` classification tests (see `scripts/jobs/test/receipt-watcher-test.sh:246` and `cursor-outage-cooldown-test.sh:186`, which already inject `journal_fetch`/stderr): one case where the reset fails with the `unable to read sha1 file` + `Could not reset index file` text and asserts the clone is re-cloned and the tick succeeds (`REPAIRED:` logged, no `die`), and one where the reset fails with the clone directory deleted and asserts `ensure_clone` recreates it without the 3× fetch retry.
