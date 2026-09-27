I checked issue #89 this tick, corrected its body, posted one short comment, and posted no jobs.

**What I checked:**
- **Merged since the body was last updated:** minion.town#119 (item 3's build) merged at 07:37Z, minion.town#118 at 08:35Z, and endo-but-for-bots#1227 (item 6's design) at 09:03Z. The job `minion-town-pr81-verify-live-after-pr118` finished and confirmed minion.town#81 is live in production (deploy promoted, service healthy, a "ready for evaluation" note posted on #81 at 08:53Z).
- **Unchanged:** minion.town#120 is still a draft with no gauntlet, CI green and `MERGEABLE`. endo-but-for-bots#1015 and #1340 are still drafts, and #1125 stays closed. Nothing new has been said on #120 or #1340.
- **Item 7:** the evaluation design (`designs/claude-on-minion-town-evaluation.md` § 7 on minion.town `main`) shows #81 going live does not unblock the CapTP eval build. It still needs four prerequisites that nobody has designed or built: the ticket-to-child endowment seam, a credential broker with per-child inference attestation, turn-context nonce propagation, and a durable inbox-driven re-trigger. The body and the last two press comments had said #81 was the last step before that build, which was wrong.

**What I changed:**
- **Issue body:** I updated the evidence lines for items 3, 6 and 7, the "as of" line, the invitation-onboarding blocker (now marked cleared) and the design-PR list (all six resolved). No checkbox changed state: items 3 and 6 stay unchecked until their live proofs are in. The architecture and item specs are unchanged.
- **Comment:** [issuecomment-5855014468](https://github.com/kriscendobot/garden/issues/89#issuecomment-5855014468). It says #81 is live and ready for kriskowal's production evaluation, and corrects the earlier item 7 claim. The review asks are the same as last tick.

**Review asks (smallest set):**
1. **run the gauntlet minion.town#120** — unblocks item 2's root-only `delegate()` reaching merge.
2. **Choose for item 5** between the endo-but-for-bots#1015 refresh and answering #1340's four open questions (already in the maintainer inbox) — unblocks the confined stdio-MCP shape.

**Jobs:** none. Nothing new is unblocked. The item 7 prerequisites need designs first, and the design orchestration or the maintainer should own that scoping rather than the press. The two item 5 jobs (`endojs-endo-but-for-bots-pr1015-refresh-for-review-20260919` and `backfill-endo-claude-design-from-minion-town-production`) are already parked and wait on the item 5 choice.

**Problem:** `inbox-read.sh` failed because its journal clone timed out (rc=124, then the script skipped the drain with rc=75), so I couldn't check this job's inbox. The item 5 answer could be sitting there unread.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-press-20260927-102015.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (910837 cached reads)
- Output: 9380 tokens
- Cost: $0.9062713999999998
- Wall-clock: 156s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
