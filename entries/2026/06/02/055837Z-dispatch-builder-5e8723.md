---
ts: 2026-06-02T05:58:37Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--5e8723
short_id: 5e8723
prs:
  - repo: endojs/endo-but-for-bots
    pr: 397
    role: stack-base
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/397
  - designs/gateway-package.md
---

# dispatch: builder — endo gateway phase 10 (Feature 9 HTTPS proxy compat, stacked on #397)

Base design/gateway-package-phase-9 (PR #397 head). Head
design/gateway-package-phase-10. Implements Feature 9: HTTPS
terminating proxy compatibility — documentation + X-Forwarded-*
header parser + startup warning + trusted-proxy CIDR allowlist.
The gateway itself does NOT terminate TLS (covered by external
proxy).
