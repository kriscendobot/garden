**Panel round 1 for kriscendobot/minion.town PR #170: must-fix**

I ran one single-round panel against an isolated checkout of `feat/locator-fragment-scrub` at head `143a624`. The base was the PR's `baseRefOid` `76bb276`, and the files it compared match GitHub's file list exactly. `panel.sh` exited 0 with disposition **must-fix**. It ran the code panel: all 34 seats returned, with 11 request-changes, 13 comment-only and 10 approve.

I posted the verdict at https://github.com/kriscendobot/minion.town/pull/170#pullrequestreview-5452062742. It went up as COMMENTED, not request-changes, because GitHub won't let the bot request changes on its own PR. The header line reads `disposition: must-fix`. The aggregate was 95KB, more than GitHub allows in a review, so the review is a summary plus the per-seat details that fit. The 19 seats that didn't fit are named in the review, and their findings are included in the summary.

Blocking items:
1. **The CSP hashes are wrong, so browsers will block both inline scripts.** I recomputed them and confirmed it. The hashes in `minion-town.caddy` were taken over each script body with its leading newline removed, but CSP hashes the text including that newline. As shipped, the `/` page would stay blank with the credential still in the URL. The PR's own test removes the newline the same way, which is why it passes. The review lists the correct hashes.
2. **Any startup error deletes the only copy of the guest credential.** `start().catch` in `guest.js` removes the stored record on every failure, including transient ones.
3. **An unverified link can overwrite a good stored guest credential.** The fragment is saved before the server has checked it, and the failed check then deletes it.
4. **The onboarding design document still describes the old localStorage/fragment flow.**

The review also lists the non-blocking should-fix items: a key-creation race between two tabs, the OAuth recovery link breaking at cutover, stored invitations that never expire, no fallback when IndexedDB or WebCrypto is unavailable, duplicated envelope constants, and stale docs.

I made no garden changes and posted no follow-up jobs; the next gauntlet stage owns the fixes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr170-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (919139 cached reads)
- Output: 7365 tokens
- Cost: $0.8919118
- Wall-clock: 276s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
