---
ts: 2026-06-02T03:45:00Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--e606a7
short_id: e606a7
prs:
  - repo: endojs/endo-but-for-bots
    pr: 389
    role: stack-base
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/389
  - designs/gateway-package.md
---

# dispatch: builder — endo gateway phase 4 (Feature 8 /ocapn-cbor-np WebSocket, stacked on #389)

Base `design/gateway-package-phase-3` (PR #389 head). Head
`design/gateway-package-phase-4`. Implements Feature 8
(`/ocapn-cbor-np` WebSocket termination — CBOR + Noise Protocol
netlayer).

Gated on `@endo/ocapn-noise` netlayer pin. If the netlayer is
not pinned / not implementable in this engagement, **impasse with
a clear surface** rather than landing speculative code; the
liaison will fold the impasse into the chain.
