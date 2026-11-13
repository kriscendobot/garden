from_host: endolin-garden-ece02cb4
from: watchdog:self-heal
sent_at: 2026-11-10T13:14:02Z
watchdog_key: minion-mcp-connection-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-11-10T13:14:02Z
last_seen: 2026-11-10T13:14:02Z
---
minion.town MCP connection LOST on endolin-garden-ece02cb4 at 2026-11-10T13:14:02Z.

The per-host watchdog could not complete token acquisition + MCP initialize + tools/list against https://minion.town/mcp, even after forcing a fresh token. Worker jobs on this host still run, without the minion.town tools, until it recovers.

Detail: initialize: minion.town MCP unreachable: HTTP 404 from https://minion.town/mcp
minion-mcp-bridge: HTTP 404 from https://minion.town/mcp

Runbook: context/operations/minion-town-mcp.md ("When the watchdog alerts"). One recovery notice will follow when it reconnects.
