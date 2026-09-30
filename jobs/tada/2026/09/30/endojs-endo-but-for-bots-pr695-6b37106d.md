I tied the SturdyRef layering effort to the existing garden arc, kriscendobot/garden#47 ("Arc: SturdyRef system"), rather than opening a new one.

**Preflight:** it exited 2, but the only match on the PR was the garden's own "On it" reply, not a real fix. So I did the work.

**Done:**
1. **Comment on #47:** https://github.com/kriscendobot/garden/issues/47#issuecomment-5904010975
   - It restates kriskowal's nine-layer plan from #695 comment 5903472512 in my own words: shim → SES → pass-style → marshal → CapTP wire/construction → OCapN → daemon → Agent API.
   - It says #695 is parked until layer 8.
   - It names the mentat supervisor job `endojs-endo-but-for-bots-pr695-5e067785` and says its stack PRs belong to this arc.
   - It says the supervisor will re-check the older arc PRs (#541, #698, #700–#704, #737, #871) against the new layers.
2. **#47 body:** I added a short "Re-scope (2026-09-30)" paragraph pointing to that comment, so the `arc-status-daily` refresher picks up the new scope.
3. **Reply on PR #695:** https://github.com/endojs/endo-but-for-bots/pull/695#issuecomment-5904012619 (tagged `<!-- garden-reply:5903477054 -->`).
4. **Message to the supervisor job:** a bus message is staged in the inbox of `endojs-endo-but-for-bots-pr695-5e067785` (msg 20260930T042504Z-faf895). It asks the job to link every stack PR to kriscendobot/garden#47 and use that arc instead of starting a new one. That job is still waiting in `todo/`, so it gets the message when it's claimed.

**Follow-ups:**
- The supervisor job still has to actually build the layered stack.
- As the stack progresses, the arc's finish line in the #47 body may need rewriting. Right now it still describes the original goal (sturdyrefs with provide/accept across Endo agents, per design #510).

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `a9decaa5`; this job presented `e22f7e5cd15c5d9776ce0202b0fef3d2f663e4d6`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-6b37106d.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (532460 cached reads)
- Output: 5045 tokens
- Cost: $0.6295440000000001
- Wall-clock: 65s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
