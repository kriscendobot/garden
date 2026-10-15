---
handed-off: endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin
deliverable-complete: false
---
The restack of #1396 is pushed, but the PR's base still isn't updated, CI hasn't run, and the summary isn't posted. All three need write access to endojs pull requests, which the bot's token doesn't have from this host. That work is handed to a successor job.

**Already done (checked again this attempt):**
- **New base:** #1394's current head `6f3185b` is frozen and pushed as `build/sturdyref-captp-wire-6f3185b`.
- **Rebase:** #1396's only commit was rebased onto it with an explicit `--onto` from the old base `build/parcel-captp-wire-6d089a6`.
- **Conflict:** the one conflict was in `packages/ocapn/test/parcel.test.js`, and both sides' tests were kept. I also made #1396's cross-instance test stricter: it now reads the Parcel back through the second instance and checks it gets a separate Parcel with the same location.
- **Push:** the head was force-pushed with lease; it is now `609821f`.
- **Local checks:** `packages/ocapn` tests passed in the earlier attempt (one cache-file error in `bytewise-compare` passed on its own re-run), and lint had 0 errors.
- **Design:** #1396 needed no source changes for the #1460 Parcel design (`6973c07`). #1394's head already builds received Parcels with the receiving client's open hook. It also forwards through `Parcel.locate`, which guests can't reach.

**Still blocked:** changing #1396's base fails with a 403 again this attempt. No GitHub Actions runs exist yet for `609821f`.

**Successor:** `endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin` is in `todo/`, pinned to `host=endolin-garden-ece02cb4`. It will move the base, re-trigger CI if it still hasn't run and get it green, then post the summary comment.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-r5527149922.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (1 unmetered)
- Input: 16 tokens (442947 cached reads)
- Output: 3827 tokens
- Cost: $3.0933539999999997 (1 engagement(s) unpriced)
- Wall-clock: 2464s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
