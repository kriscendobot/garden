---
handed-off: endojs-endo-but-for-bots-pr1397-parcel-restack-20261015-finish-endolin
deliverable-complete: false
---
I restacked #1397 onto #1396's current head and pushed it. The rest of the job (moving the PR base, driving CI green, posting the summary comment) is handed to a successor pinned to the endolin host, because this host's bot token gets a 403 on endojs PR writes.

**Done**
- **Snapshot:** froze #1396's head `609821f` as `build/sturdyref-captp-construct-609821f` and pushed it to endojs/endo-but-for-bots. #1396's finishing job (`…pr1396-parcel-restack-20261015-finish-endolin`) hasn't run yet. It only edits the base, drives CI and comments, so the head should stay put. My successor job re-checks this.
- **Restack:** moved only #1397's own two commits from the old base `3202ecd` onto `609821f`. `git rebase --onto` kept failing on the large checkout and rescheduling the same pick, so I replayed the same two commits with cherry-pick instead. Nothing conflicted. `git diff --stat 609821f..HEAD` shows only #1397's 5 files.
- **Parcel design (#1460):** commit `6973c078` sits on the new base, rebased as `b757b85`. The base already reads OCapN coordinates through the privileged `locate` and keeps the `ocapn-sturdyref` wire tag. I added one commit, `8f3d801` (`refactor(ocapn): open home Parcels through the bootstrap's nonce lookup`). It moves the secret-decoding logic into one `lookupSecretBytes` helper, used both when a Parcel is opened at home and by the bootstrap `fetch` lookup. Remote opens still go through the peer's bootstrap `fetch`. Behavior is unchanged.
- **Push:** force-pushed with lease, `build/sturdyref-ocapn-enliven` 9fda212 → `8f3d80100ff5354d82e4108c788a2a1c883a7552`.
- **Local checks:** `packages/ocapn` `yarn test` passed 546 tests (28 skipped), `yarn lint` had 0 errors, and Prettier is clean on the touched files.
- **Old CI failures:** the old head's CI failed only on files outside #1397: Prettier issues in two test files under pass-style and patterns, and a daemon test that timed out on macOS.

**Not done here**
- `PATCH pulls/1397 base=…` returned 403, so the PR still points at the old base `build/parcel-captp-construct-3202ecd`.
- No CI runs have started for `8f3d801` yet.
- The summary comment isn't posted, and the PR body's "stacked on … b0778fa" line is stale.

**Successor:** `endojs-endo-but-for-bots-pr1397-parcel-restack-20261015-finish-endolin`, pinned to `host=endolin-garden-ece02cb4`, owns the base move, CI, the summary comment and the PR-body fix. Its body records everything above and says to re-freeze and re-weave if #1396's head moves first.

The next child in the orchestration (#1398) can restack on `8f3d801` now.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1397-parcel-restack-20261015-r5527149922.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (2674185 cached reads)
- Output: 14398 tokens
- Cost: $1.4596209999999998
- Wall-clock: 1034s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
