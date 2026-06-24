---
ts: 2026-06-03T04:31:50Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--57e6ca
short_id: 57e6ca
prs:
  - { repo: endojs/endo-but-for-bots, pr: 409, role: stack-base }
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/409
  - designs/gateway-package.md
---

# dispatch: builder — endo gateway phase 11a (HTTP listener wire-up, stacked on #409)

Base design/gateway-package-phase-10 (PR #409 head 4d5cfc5b1).
Head design/gateway-package-phase-11.

Resolves the deferred HTTP-listener wire-up that accumulated
across phases 4 (/ocapn-cbor-np WS upgrade), 6 (/git smart
HTTP), and 9-10 (admin sock + Familiar publish + X-Forwarded
parser). Today's `start()` is a no-op at the network layer.

Phase 11a binds the Node HTTP server on `ENDO_HTTP_ADDR`,
multiplexes Host-header → AppsNameHub virtual hosting, routes
`/ocapn-cbor-np` WS upgrade through `OcapnWebSocketHandler`,
routes `/git/...` through `GitHttpHandler`, threads X-Forwarded
parsing per Phase 10, and surfaces the bound port for the
Familiar publisher per Phase 9.

Plus the lifecycle hookup: `start()` actually starts; `stop()`
actually stops.
