Opened draft PR https://github.com/kriscendobot/minion.town/pull/188 at commit `a29db77`.

Added debounced clip-list refresh on focus, visibility restoration, and a manual gutter control. Successful refreshes preserve valid selections, clear removed selections to the empty state, and failed reads retain the current list. Updated the design record and added regression tests.

Verification: focused tests passed (33), full `npm test` passed (1,123; 11 skipped), build/typecheck passed, and all 11 pre-push gates passed. Regression breaks produced the expected four test failures before restoration. Rendered-browser behavior was not verified because no browser runner is installed. CI remains queued/in progress; the verification wrapper also exposed unrelated PATH-stub failures in unchanged deployment tests.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ui-gutter-live-refresh.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 643s

<!-- garden-usage-end -->
