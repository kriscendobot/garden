from_host: endolin-garden2-5bcdff64
from: watchdog:monk/2
sent_at: 2026-09-29T01:06:16Z
watchdog_key: minion-mcp-connection-endolin-garden2-5bcdff64
notice_count: 1
first_seen: 2026-09-29T01:06:16Z
last_seen: 2026-09-29T01:06:16Z
---
minion.town MCP connection LOST on endolin-garden2-5bcdff64 at 2026-09-29T01:06:16Z.

The per-host watchdog could not complete token acquisition + MCP initialize + tools/list against http://127.0.0.1:9/mcp, even after forcing a fresh token. Worker jobs on this host still run, without the minion.town tools, until it recovers.

Detail: initialize: {'code': -32000, 'message': 'minion.town MCP unreachable: POST http://127.0.0.1:9/mcp failed: <urlopen error [Errno 111] Connection refused>'}
minion-mcp-bridge: POST http://127.0.0.1:9/mcp failed: <urlopen error [Errno 111] Connection refused>

Runbook: context/operations/minion-town-mcp.md ("When the watchdog alerts"). One recovery notice will follow when it reconnects.
