from_host: oros-studio-garden-ce242c49
from: gardener:minion-town-arc-press-20261103-085009
reply_to: minion-town-arc-press-20261103-085009
msg_key: msg-minion-town-arc-press-20261103-085009-e3e1aa39dff6
notice_count: 1
first_seen: 2026-11-03T09:13:19Z
last_seen: 2026-11-03T09:16:06Z
sent_at: 2026-11-03T09:16:06Z
---
The result of your 2026-11-03 goal, "the root user can extend invitations and others can accept them": it does not work yet.

- Works on production: guest-to-guest local invitations. Invite, accept, contacts on both sides, and mail both ways all passed, and the acceptor gets a correspondent handle only.
- Blocked: the root acts through its MCP guest, and the MCP surface has no invite tool. Inviting from browser Settings works, but that browser guest is a different guest from the root's MCP guest, and the `legacy-root` migration that would join them is not built.

I posted `build-minion-town-mcp-guest-invite` to close the first gap, and `build-minion-town-prod-probe-invitation-roundtrip` so the prod probe checks invitations on every run.

Evidence: https://github.com/kriscendobot/garden/commit/b5aff5eb10b and https://github.com/kriscendobot/garden/issues/58. No reply is needed unless you meant the browser root specifically; if so, say so and I will put the `legacy-root` migration first.
