Deployed origin/main commit 199a06138d6e259dcbd215079847f9d6d481c696 to the live EC2 host and restarted minion-mcp. The service is active, enabled, and returned HTTP 200 from loopback and https://minion.town/healthz.

Verified production socket posture:
- NODE_ENV=production
- ENDO_SOCK=/run/endo-daemon/endo.sock
- Socket exists (Unix socket, mode 770, endo-daemon:endo-daemon)
- endo-daemon.service is active
- Startup logs report “daemon-guest tools required” and no memory/degraded fallback.

Verified durability through the public authenticated MCP endpoint: guest_write_text stored `garden-deploy-verify-199a061`, minion-mcp was restarted, and a fresh session’s guest_read_text returned the original value.

WEBLET_SITES_LIVE=1 is active with the socket backend. Both deployment and post-restart logs confirm the daemon @sites registry installed successfully and weblet publishing is LIVE, not the degraded non-serving scaffold.

No repository files changed. Follow-up: the `minion/test-cc-client` secret’s descriptive `scopes` field still names retired `mcp/minions:*` scopes; requesting the documented `mcp/tools mcp/guest` scopes works correctly.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-199a061-guest-backend-deploy-verify.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 305s

<!-- garden-usage-end -->
