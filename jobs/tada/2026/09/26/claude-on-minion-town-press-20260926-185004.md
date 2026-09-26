No change since the last press comment (2026-09-26 09:22Z). The next step still depends on the maintainer merging #118, reviewing #119 and triggering a gauntlet on #120.

**What I checked:**
- **minion.town PRs:**
  - **#118:** still a draft, CI green, mergeable. It is still waiting for a merge directive.
  - **#119:** still a draft at head `2a54dcec37`. Its gauntlet stopped at the review budget, and it has no review yet.
  - **#120:** still a draft, CI green. Nobody has triggered its gauntlet yet.
  - **#81:** merged, and its verification job `minion-town-pr81-verify-live-after-pr118` is still parked waiting on #118.
- **endo-but-for-bots PRs:**
  - **#1227:** the maintainer's last review was "changes requested". It has been rebased, CI is green, and it is waiting for a re-review.
  - **#1015 and #1340:** quiet drafts.
  - **#1125:** closed; its work already landed as #1304, #1305, #1306 and #1310.
- **Activity:** there have been no reviews or comments on any of these PRs since 09:20Z.
- **New PR:** minion.town #121 appeared (a draft docs change clarifying that MCP admission currently requires OAuth, from job `amend-invitation-oauth-mcp-prerequisite`). It doesn't change any checklist item.
- **Maintainer inbox:** the item 5 question (refresh #1015, or answer #1340's open questions) is still unanswered. The notice that the #1015 refresh job was doomed is still unread.

**Actions:**
- **Issue body:** all seven checklist items and their evidence are still accurate, so I left it unchanged.
- **Comment:** I didn't post one, because nothing changed and the job's rules say not to repeat an unanswered ask.
- **Jobs:** I didn't post any. No dependency edge has cleared: #1125 is superseded and done, #1015 is still a draft, and the root-endowment design already landed and was reconciled through #97/#120. The item 5 confined-shape work stays on hold until the maintainer answers.

Still waiting on: merging minion.town #118 (puts #81 live, then unblocks the CapTP eval half of item 7), reviewing #119 (item 3), and "run the gauntlet #120" (item 2). The item 5 question in the inbox is also still open.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-press-20260926-185004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (255098 cached reads)
- Output: 2838 tokens
- Cost: $0.5655156000000001
- Wall-clock: 42s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
