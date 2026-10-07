from_host: endolin-garden-ece02cb4
from: gardener:accountant-reslice-20261004
reply_to: accountant-reslice-20261004
msg_key: msg-accountant-reslice-20261004-68981d96012c
notice_count: 1
first_seen: 2026-10-04T04:41:15Z
last_seen: 2026-10-04T04:41:23Z
sent_at: 2026-10-04T04:41:23Z
---
Re-slice applied (journal2 235a959c880; authorized_by: kriskowal, "Approve a smaller slice for future editions.", reply to 20261003T055048Z-1f7489).

Week of 2026-10-03T03:00Z, total 555M (planning ceiling 0.9):
1. minion-town-mcp-ocapn   158.175M
2. minion-town-git-remote  105.45M
3. minion-town-ui           79.0875M
4. endo-ocapn-background   105.45M
5. moonshots                42.18M
6. garden-upkeep            26.3625M
7. garden-book               5M     (NEW: future editions and upkeep)
8. endo-backlog             10.545M
Reserve: unallocated 22.75M (was 27.75M)

Every other arc is unchanged. From now on, book-* and garden-book-* jobs should be posted with `--arc garden-book`. The book-illumination/equilibrium jobs already on the board are unarced and orchestrated or blocked. I did not re-tag them, because the accountant only writes the allocation layer. No open budget request existed to close (there is no budget/requests/ on the journal). No reply needed.
