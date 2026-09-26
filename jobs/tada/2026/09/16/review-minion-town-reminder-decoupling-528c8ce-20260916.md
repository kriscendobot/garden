Review result: approve the reminder/daemon decoupling; do not revert either path.

- The compatibility path is substantive: the pinned upstream store and adapter run through config, write, list, remove, replacement, restart reconstruction, JSON-layout, and write-then-move trace checks. The upstream store SHA matches commit `0eb88836`, and its executable body matches the fixture. `npm test` passed 360 tests with 5 daemon integration tests skipped; `npm run typecheck` passed.
- The `@pins` gate is load-bearing operational evidence, not merely a test stub: the recorded production exercise restarted the unchanged `f6650503` daemon and observed reminder counts advance from 3 before restart to 5 on revival and 8 afterward. I did not rerun it because the directive forbids touching the live daemon.
- One drift guard is missing. `COMPATIBILITY_STORE_PROVENANCE.json` pins `f6650503`, but no test connects that value to `deploy-endo-daemon.sh`. A daemon bump can therefore keep CI green and staging successful while installing the old adapter. At `0eb88836`, its `writeText`/`maybeReadText` calls would no longer match the reconciled store API. Add this relationship to `test/endo-pin-drift.test.ts`, failing until the adapter is removed or requalified.
- Plugin drift fails closed: the source commit, fetched upstream store digest, fixture digest, and adapter digest are pinned. Updating the plugin without updating provenance stops staging.
- The frozen daemon is supportable near-term, but not a durable endpoint. It is 1,317 commits behind the reminder source target and 2,339 behind the cited current `llm` tip. The adapter contains reminder risk but does not reduce the widening daemon migration and missed-fix delta.
- The two paths compose. Decoupling is the safe near-term unblock; the registry migration is the durable daemon-upgrade path. Neither undermines the other. However, closed draft PR https://github.com/endojs/endo-but-for-bots/pull/1106 is diagnosis, not ready migration code: its registry and host writes are two independent `writeFormula` calls, contrary to the design's per-host transactional requirement. A successor must close that atomicity gap before production revival.
- A retroactive review PR is warranted. It should cover both bare commits, `528c8ce` and the load-bearing implementation `e7b3b5a`, against a frozen `c953c03` base, and be explicitly review-only. The implementation currently calls itself reviewed despite having landed without a review surface.
- No repository changes were made.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-minion-town-reminder-decoupling-528c8ce-20260916.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 239s

<!-- garden-usage-end -->
