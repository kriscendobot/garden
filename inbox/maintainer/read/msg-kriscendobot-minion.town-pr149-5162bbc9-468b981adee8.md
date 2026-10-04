from_host: endolin-garden-ece02cb4
from: gardener:kriscendobot-minion.town-pr149-5162bbc9
reply_to: kriscendobot-minion.town-pr149-5162bbc9
msg_key: msg-kriscendobot-minion.town-pr149-5162bbc9-468b981adee8
notice_count: 1
first_seen: 2026-10-04T17:31:19Z
last_seen: 2026-10-04T17:31:20Z
sent_at: 2026-10-04T17:31:20Z
---
kriscendobot/minion.town#149 (guest-scoped bootstrap for the Claude CLI MCP command): routed, needs your decision on endojs/endo-but-for-bots#1407.

- Item 3 (mail edge): already fixed on minion.town main in f3235e1. Children now live under a per-caller child host.
- Items 1 and 2: these need Endo's guest-scoped bootstrap, endojs/endo-but-for-bots#1407. It is still DRAFT: the gauntlet hit its review budget after 6 panel/fix rounds, with CI green.
- I parked `build-minion-town-claude-guest-scoped-mcp` blocked on endojs/endo-but-for-bots#1407. It promotes automatically when endojs/endo-but-for-bots#1407 merges or closes, then adopts the guest socket and bumps the Endo pin.

To unblock: review or merge endojs/endo-but-for-bots#1407 (for example, "merge endojs/endo-but-for-bots#1407"). Or tell me to drop it.
