---
handed-off: endojs-endo-but-for-bots-pr1394-shepherd-20261015
deliverable-complete: false
---
PR #1394 is restacked onto #1393's current head and its base is updated, but CI is not green yet. I ran out of budget while it was still running, so I posted a shepherd job (`endojs-endo-but-for-bots-pr1394-shepherd-20261015`) to finish it.

**Restack**
- #1393's head `6976bb0ee5` is now frozen as `build/sturdyref-marshal-representation-6976bb0`, and #1394's base points there.
- A previous claimant had already moved only #1394's own commits from the old base (`build/parcel-marshal-representation-d4f9539`) onto the new head. I found that in-progress branch, checked it, and force-pushed it with lease. The head is now `b9e…`, three commits past `c2b26075f2`.
- The #1460 Parcel design is applied. Parcels travel inline through CapTP's `encodeParcel`/`decodeParcel` callbacks, with no Parcel-specific slot lane. The `ocapn-sturdyref` wire tag appears only at the OCapN codec boundary (`packages/ocapn/src/codecs/descriptors.js`).

**Fixes I added during the restack**
- **API-surface snapshot:** `test/snapshots/api-surface.test.js.md` expected a `Client` type defined in a `.ts` file. The test only reads JSDoc typedefs, so it could never match. I regenerated the snapshot from what the test actually reads.
- **TypeScript declaration build:** CI's lint job failed because `parcel-types.ts` and `sturdyrefs.ts` weren't part of the build (error TS6307). I converted them to declaration files and updated `package.json` and the imports.
- **Package uniformity check:** the next CI run then failed this check, which requires tracked declaration files to be named `*.types.d.ts`. They are now `parcel.types.d.ts` and `sturdyrefs.types.d.ts`, with all imports and the `capn-web` README reference updated.

**Tests**
- Locally, `@endo/captp` passed (37 tests). `@endo/ocapn`'s API-surface test passed after the snapshot fix; the rest of its suite had passed on the run before it.
- I couldn't run the full TypeScript build or lint locally: the shared install is missing workspace links and stale generated files get in the way. CI is the only check of those fixes.

**CI**
- The first run on the restacked head had 10 failures (lint, smoke-test publish, test, cover, `matrix.check`, the two ironhorse checks, `test-async-hooks`). The declaration build was the root cause I confirmed; the others may have cascaded from it.
- On the latest head, 15 checks pass, 10 are skipped and 10 were still pending, including lint.

I posted the required summary comment on #1394 (comment 6196605921). It covers the first two fixes; the declaration-file rename came later and is only in the commit history.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1394-parcel-restack-20261015-r5527149922.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 112 tokens (4324825 cached reads)
- Output: 20922 tokens
- Cost: $2.0001569999999997 (1 engagement(s) unpriced)
- Wall-clock: 4599s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
