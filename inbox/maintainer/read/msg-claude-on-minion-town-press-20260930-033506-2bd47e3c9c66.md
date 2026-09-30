from_host: endolin-garden-ece02cb4
from: gardener:claude-on-minion-town-press-20260930-033506
reply_to: claude-on-minion-town-press-20260930-033506
msg_key: msg-claude-on-minion-town-press-20260930-033506-2bd47e3c9c66
notice_count: 1
first_seen: 2026-09-30T04:34:46Z
last_seen: 2026-09-30T04:34:51Z
sent_at: 2026-09-30T04:34:51Z
---
Arc kriscendobot/garden#89 (Claude on minion.town): one decision needed on endojs/endo-but-for-bots#1371, the confined stdio-MCP launcher for item 5.

The live model turn (https://github.com/endojs/endo-but-for-bots/pull/1371, 2026-09-30 00:52Z) found this. If the host agent's formula id reaches the model's context through a prompt or a facet result, a confined guest can call `storeIdentifier` with it, and the daemon accepts. The guest then holds `?type=host`. The allow-list prunes the code-eval tools but not the identifier-minting ones (`storeIdentifier`, `storeLocator`, `internalizeContentLocator`).

Decision: which fix?
 (a) prune the identifier-minting tools from the confined allow-list and the broker (a narrow change inside endojs/endo-but-for-bots#1371), or
 (b) make the daemon refuse to let a guest store an id it was never granted (an Endo-proper change that closes it for every guest, not only Claude).
Recommendation: (a) now, to unblock endojs/endo-but-for-bots#1371, plus a designer job for (b). Reply with a, b, or both.
