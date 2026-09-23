Restored minion.town with an EC2 reboot. The instance had failed reachability since 17:44 UTC, SSM was ConnectionLost, and external HTTPS timed out. Root cause is not determinable from retained logs; no OOM, kernel panic, or filesystem error was found.

Recovery verified:
- EC2 system and instance checks: `ok`
- SSM: `Online`; snap SSM agent active/enabled
- Caddy, oauth2-proxy, minion-mcp: active; Endo daemon container running
- HTTPS/TLS: valid minion.town certificate; `/` returns expected login redirect
- MCP metadata: 200; unauthenticated `/mcp`: expected 401 Bearer challenge
- Deployed daemon source: `a371b007cccf2dcdda29b600232171fec9495b02`; preserved its untracked `.dockerignore`

B4 was already reaped and did not reply to the coordination message. No deployment state was overwritten; it needs deterministic requeue/resume.

Follow-up: rotate the billing gate secret and stop Caddy startup logs from emitting environment-derived secret material.
