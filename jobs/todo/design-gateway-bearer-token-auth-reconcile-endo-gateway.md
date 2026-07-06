---
role: designer
---

Design work on endojs/endo-but-for-bots: reconcile the phantom `gateway-bearer-token-auth` design (frontmatter says Complete but no `GatewayBootstrap`/`ENDO_GATEWAY`/WebSocket bearer gate exists, and it assumes a `--addr` flag and familiar bundle pipeline that don't) against the now-existing `@endo/gateway` package (endo-gateway.md; virtual-hosting phase 1 merged as #578) and the actual UNIX-socket daemon. Produce a buildable, phased spec for authenticated remote access — the bearer-token `fetch(token)` gate riding the OCapN-over-WebSocket subprotocol — correct the design record's true status, and state which design (gateway-bearer-token-auth vs an endo-gateway phase) owns it, so the subsequent builder unblocks M3's remote-control keystone and daemon-docker-selfhost #608's remote-access follow-up.
