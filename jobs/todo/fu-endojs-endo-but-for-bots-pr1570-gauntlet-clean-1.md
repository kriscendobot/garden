---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

In endojs/endo-but-for-bots, PR #1570 (https://github.com/endojs/endo-but-for-bots/pull/1570): check whether the bwrap fix (#1542 or #1566) has landed. If it has, weave #1570 onto a base that includes it and re-run the gauntlet. If it has not, only re-run the intermittent daemon durable-environment and floot macOS CI failures, and don't investigate them unless they recur. Post no comments and make no changes if neither applies.
