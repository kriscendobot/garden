---
ts: 2026-06-02T04:15:25Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--b53b44
short_id: b53b44
prs:
  - repo: endojs/endo-but-for-bots
    pr: 392
    role: stack-base
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/392
  - designs/gateway-package.md
---

# dispatch: builder — endo gateway phase 5 (Feature 6 public CapTP relay, stacked on #392)

Base `design/gateway-package-phase-4` (PR #392 head). Head
`design/gateway-package-phase-5`. Implements Feature 6: public
CapTP relay (closed-allowlist by default; relay targets must
register before the gateway accepts inbound sessions for their
public key).

Builds on Phase 4's `OcapnWebSocketHandler` — adds the
inbound-policy layer that decides whether to forward to a
registered daemon based on the public-key allowlist.
