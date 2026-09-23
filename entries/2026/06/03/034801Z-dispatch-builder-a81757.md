---
ts: 2026-06-03T03:48:01Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--a81757
short_id: a81757
prs:
  - { repo: endojs/endo-but-for-bots, pr: 397, role: stack-base }
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/397
  - designs/gateway-package.md
---

# dispatch: builder — endo gateway phase 10 (Feature 9 HTTPS proxy compat, stacked on #397)

Resume the stack from Phase 9 (PR #397, head 32c2f7429). Base
`design/gateway-package-phase-9`. Head
`design/gateway-package-phase-10`.

Feature 9 (HTTPS terminating proxy compatibility):
- X-Forwarded-* parser, gated on trusted-proxy CIDR allowlist.
- Default empty list (no trust without explicit allowlist).
- Startup warning on non-loopback bind + empty trustedProxies.
- Wire parser into Phase 6's git-http handler for caller-IP /
  scheme awareness.
- Documentation: docs/https-proxy.md or README section.
