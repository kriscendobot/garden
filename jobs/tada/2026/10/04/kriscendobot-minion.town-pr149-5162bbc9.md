Issue kriscendobot/minion.town#149 is routed but not fixed yet. Two of its three items depend on an Endo PR that is still a draft and needs your review or merge decision. The preflight skipped its checks because #149 is an issue, not a PR.

Status of each item in #149:
- **Item 3 (mail edge):** already fixed on minion.town `main` in commit f3235e1, which came in with PR #148. Claude children are now provided under a per-caller child host, so a child's `@host` is no longer the root host.
- **Items 1 and 2 (root socket handed to the MCP command; same unix user):** the fix needs Endo's guest-scoped bootstrap, https://github.com/endojs/endo-but-for-bots/pull/1407. That PR is still a draft: its gauntlet ran six panel/fix rounds without converging, then stopped with CI green.

What I did:
- **Parked job:** I parked `build-minion-town-claude-guest-scoped-mcp`, blocked on endojs/endo-but-for-bots#1407. It starts automatically when that PR merges or closes. On merge it will:
  - give `brokerFor` a per-guest socket instead of `ENDO_SOCK` plus the guest id;
  - update the argv test so it checks `ENDO_SOCK` is absent;
  - move the Endo pin carefully, since an earlier pin move crashed production;
  - reassess the same-user risk, with running the MCP command as a separate user kept optional;
  - open a draft PR and reply on #149.
  
  If endojs/endo-but-for-bots#1407 is closed without merging, the job only tells you and comments on #149.
- **Message to you:** sent through the maintainer inbox, asking for a review or merge decision on endojs/endo-but-for-bots#1407.
- **Reply on #149:** https://github.com/kriscendobot/minion.town/issues/149#issuecomment-5982599391

I made no garden or project code changes.

**Follow-up:** you need to review or merge endojs/endo-but-for-bots#1407 (for example "merge #1407" to post a conductor job), or tell me to drop it. Until then, items 1 and 2 stay open.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `a62e91aca69f41da51c81bab904a1cb902e79609`; this job presented `a49568bb92f8e9f8776e22d73380cc66097ff58e`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr149-5162bbc9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (903450 cached reads)
- Output: 7661 tokens
- Cost: $0.8567260000000001
- Wall-clock: 100s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
