---
ts: 2026-06-03T04:08:00Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: a81757
prs:
  - { repo: endojs/endo-but-for-bots, pr: 409, role: new }
refs:
  - entries/2026/06/03/034801Z-dispatch-builder-a81757.md
  - https://github.com/endojs/endo-but-for-bots/pull/409
---

# result: builder — gateway phase 10 PR #409 (Feature 9 HTTPS proxy compat)

- PR #409 DRAFT, base design/gateway-package-phase-9
  (32c2f7429), head design/gateway-package-phase-10 (4d5cfc5b1).
- 455 tests pass (442 → 455, 13 new + propagation).

Files:
- `src/x-forwarded.js` (new): parseForwardedRequest +
  parseCidr + matchTrustedProxy + isLoopbackBindAddress.
- `src/git-http.js`: handler accepts trustedProxyCidrs +
  maxProxyHops; forwards ForwardedRequest to
  DaemonRepoCapability.
- `index.js`: startup warning + new `logWarning` power.
- `docs/https-proxy.md` (new): nginx/Caddy/ALB/Cloudflare
  examples + security reasoning.
- `test/x-forwarded.test.js` (new, 45 tests).
- Changeset added.

Key choices:
- `logWarning` as optional power (SES hardens console; warning
  was untestable without injectable sink; clean public-API
  addition).
- Pure parser separate from handler integration; embedders
  can feed their own listener.
- `forwarded` is optional field on DaemonRepoCapability args
  (backward-compatible).
- CIDR matcher in-package with file-level
  `eslint-disable no-bitwise, no-continue` for the idiom.

Liaison disposition: dispatch root torn down. Phase 11
(Feature 10 OS packaging) NEXT — but its scope significantly
overlaps with the in-flight #343 follow-up (CLI + systemd).
Waiting for #343 (`builder--0fa673`) to return before deciding
whether Phase 11 is still warranted vs subsumed.
