Fix round 6 is pushed for endojs/endo-but-for-bots#258, and CI came back green on the new head `78b63b2b76` (16 checks, 0 failed).

**Panel must-fix items (round 6, head `d07ab340`) and what I changed:**

1. **Unusable cache entry never recovered (breaker).** If the cache key matched but the archive was missing or empty, every later run re-took the snapshot and then threw it away. The save could never replace the entry, because cache entries can't be overwritten. Changes in `.github/workflows/ocapn-guile-interop.yml`:
   - New `GUIX_STORE_CACHE_SCHEMA: '1'` setting, added to the cache key as `guix-store-v<N>-…`. Bumping it moves past a bad entry. It also versions the snapshot layout, which answers the breaker's should-fix about edits being served old snapshots.
   - The snapshot step now runs only on a cache miss, so a matched key never triggers a snapshot that can't be saved. The `usable` output it used to wait on is no longer needed, so I removed it.
   - The empty-archive warning now tells the reader to bump `GUIX_STORE_CACHE_SCHEMA`.
   - Also from the saboteur's should-fix: before extracting, the step deletes leftover database temp files (`db.sqlite-wal` / `db.sqlite-shm`) so they can't be applied to the restored database.
2. **PR description didn't follow the template (integrator).** I rewrote it with all seven template headings in order, in 282 words (the limit is 300). It now describes the end result rather than the history of fix rounds, and says why the existing `--fallback` isn't enough (the 2026-05-14 outage took down both substitute servers). It also notes the 4 GB cap, the cache-key inputs, the `contents: read` permission, and the separate `ci.yml` comment fix.

The fix went in as one follow-up commit through `safe-push-pr-head.sh`, which moved the branch forward from `d07ab3401c` to `78b63b2b76`. actionlint reports the same 5 shellcheck findings before and after the change, all in lines I didn't touch. I left these should-fix items unaddressed:
- Saving the cache only from the default branch (wire-watcher). The PR description now covers it instead: GitHub keeps cache entries per repository and branch.
- Moving the `ci.yml` comment fix to its own PR.

Panel 7 will be posted by the gauntlet driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr258-gauntlet-20261007-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1266050 cached reads)
- Output: 7987 tokens
- Cost: $1.014726
- Wall-clock: 653s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
