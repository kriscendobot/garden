---
child-endojs-endo-but-for-bots-pr774-parcel-restack-20261015-r5527149922-host: endolin-garden-ece02cb4
child-endojs-endo-but-for-bots-pr774-parcel-restack-20261015-r5527149922-reap-count: 0
order: serial
children: endojs-endo-but-for-bots-pr774-parcel-restack-20261015-r5527149922 endojs-endo-but-for-bots-pr1391-parcel-restack-20261015-r5527149922 endojs-endo-but-for-bots-pr1392-parcel-restack-20261015-r5527149922 endojs-endo-but-for-bots-pr1393-parcel-restack-20261015-r5527149922 endojs-endo-but-for-bots-pr1394-parcel-restack-20261015-r5527149922 endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-r5527149922 endojs-endo-but-for-bots-pr1397-parcel-restack-20261015-r5527149922 endojs-endo-but-for-bots-pr1398-parcel-restack-20261015-r5527149922 endojs-endo-but-for-bots-pr1399-parcel-restack-20261015-r5527149922
on-child-failure: halt
state: running
created_by: fixer
created_at: 2026-10-15T02:19:58Z
---

# Apply the accepted Parcel design through the existing SturdyRef stack

Sequentially reconcile and restack PRs #774, #1391, #1392, #1393, #1394,
#1396, #1397, #1398, and #1399. Each child snapshots the current predecessor
head as its frozen merge base, rebases only that PR's own commits, resolves
conflicts while preserving the complete parent chain, and applies the relevant
portion of PR #1460's accepted Parcel and Slot Machine contracts.
