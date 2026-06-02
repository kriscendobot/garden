---
ts: 2026-06-02T05:38:26Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--d1d611
short_id: d1d611
prs:
  - repo: endojs/endo-but-for-bots
    pr: 396
    role: stack-base
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/396
  - designs/gateway-package.md
  - designs/familiar-localhttp-protocol.md
---

# dispatch: builder — endo gateway phase 9 (Feature 5 Familiar-bundled fallback, stacked on #396)

Base design/gateway-package-phase-8 (PR #396 head). Head
design/gateway-package-phase-9. Implements Feature 5: same
package, different configuration — `ENDO_HTTP_ADDR=127.0.0.1:0`
(OS-assigned port); the Familiar `localhttp://` protocol handler
proxies through the OS-assigned port. Composes with Phase 1's
`ENDO_HTTP_ADDR` parsing.
