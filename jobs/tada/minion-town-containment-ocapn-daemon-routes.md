Production OCapN containment completed.

- Preserved pre-change evidence under root-only `/var/lib/minion-town-containment/20260812T231300Z-ocapn-daemon-routes`, including Caddy configuration, service/container definitions, checksums, rollback instructions, and the current designator without publishing it. The peer forensics job was given the path and can read it through root-level SSM.
- Pre-change formula index at `2026-08-12T23:11:48Z`: `formula=334`, `agent_key=24`, `remote_agent_key=23`, `retention=0`.
- Installed the reversible Caddy drop-in `/etc/caddy/conf.d/00-containment-ocapn-daemon-routes.caddy`. It returns 404 for `/ocapn-daemon*` and `/.well-known/ocapn-cbor-np*` on both `minion.town` and `www.minion.town`. No other active Caddy route reached loopback port 8931.
- Restarted Caddy to terminate existing public WebSocket sessions, then verified off-host:
  - `/ocapn-daemon` → HTTP/WS `404`
  - `/.well-known/ocapn-cbor-np` → HTTP/WS `404`
  - Real Noise attempts using the preserved designator failed with `Unexpected server response: 404`; no `hello` or `provide` call was made.
  - `/ocapn` remains available: HTTP `426` without upgrade and successful WebSocket `101/open`.
- Confirmed the daemon remains running with zero restarts and remains bound only to `127.0.0.1:8931`. Caddy, `endo-gateway`, `minion-mcp`, `oauth2-proxy`, and `endo-ocapn-daemon` are active; no systemd units are failed.
- Confirmed the earlier weblet containment remains effective: the live gateway process lacks `GATEWAY_ENDO_SOCK` and lacks the `endo-daemon` supplementary group.
- The daemon volume and formulas were untouched. After blocked handshake attempts, the formula count remained 334 and retention remained 0.

Cost: cross-host OCapN invite/accept, reconnection, and every other daemon service depending on these public Noise-over-WebSocket routes are unavailable. The Caddy restart terminated live public peer sessions. Local daemon access and persisted state remain intact. After `ebfb-ocapn-gateway-retention-set-peer-binding` lands and is deployed, service restoration requires explicit authorization, removal of the drop-in, validation/reload, and peer reconnection.

Rollback, not executed:

`rm -f /etc/caddy/conf.d/00-containment-ocapn-daemon-routes.caddy && caddy validate --config /etc/caddy/Caddyfile && systemctl reload caddy`

Garden follow-up: pushed commit `b56405c477` to `main2`, documenting the `/tmp` `noexec` workaround for AWS CLI installation.

Self-improvement: `skills/aws-administration/SKILL.md`; documented executable-scratch `TMPDIR` handling for hardened containers.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-containment-ocapn-daemon-routes.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 925s

<!-- garden-usage-end -->
