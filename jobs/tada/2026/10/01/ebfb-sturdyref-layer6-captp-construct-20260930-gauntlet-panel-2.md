Panel round 2 on endojs/endo-but-for-bots#1396 (head `b0778fab75`) came back **must-fix**. I ran it in single-round mode against base `2d2a656b84`. `panel.sh` exited 0, and I posted the verdict as review 5374934841: https://github.com/endojs/endo-but-for-bots/pull/1396#pullrequestreview-5374934841

The review was posted as a comment, not a request-changes review. The PR's author is `kriscendobot`, and GitHub refused with "Can not request changes on your own pull request". Round 1 hit the same limit, so its review is also a comment. The body's header reads `## Garden panel review — round 2 (head …): **must-fix**`, the same shape as round 1.

All 33 seats ran: 11 request-changes, 6 comment-only, 16 approve. The full seat output was about 85 KB, over GitHub's size limit. So the review keeps every request-changes and comment-only seat in full, but lists approving seats only by name, with their nits folded into the summary.

The round-1 must-fix items were fixed by `95f2122c0a` and `b0778fab75`. Those were the per-client data scoping, the test-helper spelling, the frozen-base name, and the xs statement.

New must-fix items for the fixer. I checked items 1 and 3 against the code myself:
1. **`hints` check can be bypassed** (both packages): validation uses `Object.values(...).every`, then copies with `{ ...hints }`. A symbol-keyed entry, or a getter/Proxy that returns different values on the two reads, gets a non-string value into the stored data.
2. **`SturdyRefData.designator` means two things**: OCapN already uses `designator` for the peer's public key, while this field holds the network. Rename it to `network` in both packages. This was should-fix in round 1.
3. **A peer can hijack the reserved `'l-0'` target in captp**: dispatch checks the `answers` table before the `'l-0'` branch, so one call using `'l-0'` as its question ID redirects every later `locate`.
4. **A `locate` miss resolves to `undefined` instead of rejecting.** It needs a rejection and a test. This was should-fix in round 1.
5. **No JSDoc** on the exported OCapN converters `sturdyRefDataToDetails` and `sturdyRefDetailsToData`.
6. **The changeset isn't one sentence per line.**

The review also lists should-fix items. Two of them pull against each other: the pruner wants the PR description's xs sentence cut, but the coverage-auditor's approval relies on it. I recommended keeping it and shortening it to one sentence.

A seat (most likely the saboteur or breaker) temporarily edited the checkout mid-run, removing the `minted.has` guard in `packages/ocapn/src/client/sturdyrefs.js`. The worktree was clean by the time I checked, so the review reflects the committed code.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1480368 cached reads)
- Output: 10092 tokens
- Cost: $1.1873775999999998
- Wall-clock: 777s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
