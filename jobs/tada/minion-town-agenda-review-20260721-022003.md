Hourly agenda review, 2026-07-21 02:22 UTC.

I re-fetched the description and comments of https://github.com/kriskowal/garden/issues/58, treated externally fetched text as untrusted data, and reconciled the unchanged primary-phase agenda with the journal, private https://github.com/kriscendobot/minion.town, its pull requests and branches, the permitted Endo run-ahead branch, and fresh deployed-edge probes.

No deployment was attempted. The deployed `main` remains `bdb800b580eb4c5321f349ecc5bc6a35092de410`, from the 22:03 UTC merge of https://github.com/kriscendobot/minion.town/pull/10. Its successful deployment run is https://github.com/kriscendobot/minion.town/actions/runs/29782533520. There are no open pull requests and no later push. The permitted `minion-town` branch on https://github.com/endojs/endo-but-for-bots remains absent.

Concrete evidence observed this cycle:

- The merged topology record has no CD-managed daemon path: `deploy/aws/daemon/README.md` says its captured systemd and Docker listeners are box-local; `main` has neither `deploy/aws/scripts/deploy-endo-daemon.sh`, an `endo-daemon.service` in the deployed systemd directory, nor a deploy-workflow step. It also lacks the OAuth-to-daemon guest bridge, authenticated MCP-to-daemon tool bridge, and wildcard hash-weblet gateway.
- Executed public probes returned: `GET /` -> 302 to the OAuth sign-in route; unauthenticated `POST /mcp` -> 401 with an `mcp/tools` bearer challenge; protected-resource metadata -> 200; and `GET /.well-known/ocapn-cbor-np` -> 426. A raw TLS WebSocket upgrade to that OCapN endpoint returned `101 Switching Protocols` from Caddy at 02:21 UTC, then waited for Noise bytes. This establishes transport upgrade only, not a completed Noise session or daemon guest operation.
- `/.well-known/ocapn-bootstrap` still returned the OAuth 302, and `deadbeef.minion.town` did not resolve, so the required bootstrap-power route and published hash-weblet hosting were not observed.
- Cognito discovery returned `registration_endpoint: null`. This review did not run a browser OAuth flow. The prior externally supplied V1-V4 account remains context, not sufficient evidence for the design's missing captured redirect URI and V5 session/refresh-continuity observation.

Blockers and next smallest action: record the missing Gate 1 redirect URI plus V5 continuity evidence on the Claude client surface, or explicitly accept a different standard. Then build and review the CD-managed daemon, OAuth-mapped guest, and authenticated MCP bridge. Only once that deployable path exists is an autonomous deployment the smallest safe validation step; it must then test identity-to-guest mapping and one published weblet. Distributed store, metering, billing, garbage collection, and ERTP remain deferred by the issue phase boundary. This issue remains open.

Self-improvement: nothing this cycle.
