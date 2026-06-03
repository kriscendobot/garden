---
ts: 2026-06-03T04:08:08Z
kind: result
role: builder
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/builder--a81757/project
---

Phase 10 of the Endo Gateway stack (#343) lands: Feature 9 (HTTPS
terminating proxy compatibility). DRAFT PR #409 opens against
phase-9 head.

## What ships

- `packages/gateway/src/x-forwarded.js`: pure parser
  (`parseForwardedRequest`) returning `{ callerIp, scheme, host,
  trusted }` shape gated on configured `trustedProxyCidrs` CIDR
  allowlist and `maxProxyHops` budget. Lower-level `parseCidr` and
  `matchTrustedProxy` exported. `isLoopbackBindAddress` and
  `renderNoTrustedProxyWarning` support the startup warning.
- `packages/gateway/src/git-http.js` wires parser in: when request
  carries `peerAddress`, handler invokes parser and forwards the
  recovered shape to `DaemonRepoCapability` methods so a daemon
  implementation can key per-caller rate limits or audit logs by
  original client IP.
- `packages/gateway/index.js` emits the design-pinned startup
  warning at `start()` when bound to non-loopback with no trusted
  proxies. New optional `powers.logWarning` overrides default
  `console.error` sink.
- `packages/gateway/docs/https-proxy.md`: deployment doc with
  reverse-proxy examples (nginx, Caddy, AWS ALB, Cloudflare) and
  security reasoning.
- Changeset `.changeset/endo-gateway-https-proxy-compat.md`.

## Tests

- 45 new in `test/x-forwarded.test.js`.
- 4 new gateway-level startup-warning tests (`test/gateway.test.js`).
- 5 new git-http wiring tests (`test/git-http.test.js`).
- 4 new config tests (`test/config.test.js`).
- 455 tests pass total (was 442 on phase 9).

Every new test verified load-bearing by mutation: breaking the
trust gate, breaking the `maxHops` walking direction, disabling
the warning emit, and removing the `forwarded` arg from the repo
call all cause the corresponding test to fail.

## Carry-forward

- `ForwardedRequest` typedef in `src/types.d.ts`; impl uses
  `@import`.
- `peerAddress` on `GitHttpRequest`, optional `forwarded` on the
  three `DaemonRepoCapability` method signatures, `logWarning` on
  `GatewayPowers`.
- Fail-closed defaults: empty `trustedProxyCidrs`,
  `maxProxyHops: 1`.

## PR

#409, DRAFT, base `design/gateway-package-phase-9`, head
`design/gateway-package-phase-10`.

Self-improvement: nothing this time. The dispatch's prescription
matched the package's existing patterns (config field already on
the type, fail-closed defaults already in place from phase 1, the
`@import` typedef convention, the per-feature wiring shape). The
only friction was SES hardening `console.error` so I had to add a
`logWarning` power to make the warning testable; that itself is a
clean public-API addition rather than a workaround.
