Reconciled PR #1391 with PR #1460’s accepted Parcel design and verified `%InitialParcel%` retains `locate` while `%SharedParcel%` withholds it.

Confirmed the remote branch is restacked on #774’s exact head `dbd2b003e6` via frozen base `build/sturdyref-shim-first-wins-dbd2b00`. Range-diff preserved all six prior commits and added three Parcel follow-ups without flattening either chain.

Verification passed: 18 focused tests, SES lint with zero errors, vanilla/Hermes builds, XS smoke, nine deterministic gates, and all 35 GitHub CI checks.

Posted the completion summary: https://github.com/endojs/endo-but-for-bots/pull/1391#issuecomment-6187958602

Follow-ups: none.
Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-parcel-restack-20261015-r5527149922.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (3 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (3 engagement(s) unpriced)
- Wall-clock: 6090s

<!-- garden-usage-end -->
