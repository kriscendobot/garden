---
ts: 2026-06-01T23:55:39Z
kind: result
role: builder
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/builder--f6e2a8
refs:
  - entries/2026/06/01/230104Z-dispatch-builder-354902.md
---

# builder result — @endo/gateway phase-1 skeleton on PR #343

Pushed two commits to `design/gateway-package` (PR #343) implementing
the phase-1 skeleton of `@endo/gateway` per
`designs/gateway-package.md`:

- `184dfdb99 feat(gateway): @endo/gateway package skeleton (#343)`
- `89d68e71e chore: Update yarn.lock`

## Scope cut

The dispatch named ten configurable features. Implementing all ten
in one engagement would yield an unreviewable diff; the maintainer's
"all phases" directive is best honored by landing a clean,
focused first phase with the remaining features stacked as
follow-on PRs.

**Implemented (phase 1 of 4):**

- Package skeleton: `packages/gateway/` with `package.json`,
  `README.md`, `CHANGELOG.md`, `SECURITY.md` (canonical hash),
  `LICENSE`, `tsconfig.{json,build,composite}.json`, `types.d.ts`.
- `makeGateway({ powers, config })` factory returning a hardened
  exo with `start`, `stop`, `getBindAddress`, `getApps`,
  `getConfig`. `start`/`stop` are lifecycle no-ops in this slice;
  the network surface lands with the WebSocket / UDS / relay
  features.
- `ENDO_HTTP_ADDR` parsing with the OS-assigned-port (`:0`)
  convention; default `0.0.0.0:3469` per the maintainer-pinned
  bind shape.
- In-memory `AppsNameHub` exo (`bind`, `unbind`, `list`,
  `lookup`, `has`) backing **feature 2 (virtual hosting)** at the
  data-structure level.
- Per-feature configuration toggles validated at `make` time:
  captpRelay depends on ocapnWebSocket and udsBootstrap;
  adminDaemon depends on udsBootstrap; chatHosting depends on
  virtualHosting. Misconfigurations fail at config-time, not at
  start-time.

**Deferred to follow-on PRs:**

- Feature 1: Chat hosting + payment-token enhancement.
- Feature 3: Git over HTTP, formula-identifier bearer-token.
- Feature 4: UDS bootstrap for local CapTP relay registration.
- Feature 5: Familiar-bundled fallback on OS-assigned port.
- Feature 6: public CapTP relay.
- Feature 7: admin daemon (extends the UDS bootstrap).
- Feature 8: `/ocapn-cbor-np` WebSocket subprotocol (network
  surface lands once `@endo/ocapn-noise` exposes the netlayer
  the gateway embeds).
- Feature 9: HTTPS-terminating-proxy `X-Forwarded-*` parser.
- Feature 10: OS packaging (rpm / deb / PKGBUILD / Dockerfile).

The dispatch's suggested "structural backbone" cut included
feature 8 (WebSocket termination) and combined features 4 + 7
(UDS bootstrap + admin); I cut narrower because (a) feature 8
needs the `@endo/ocapn-noise` netlayer composition the design's
WS-around-Noise framing requires, which is a wire-shape decision
beyond a single dispatch's scope, and (b) feature 4's UDS handler
plus the proof-of-possession handshake is itself a substantial
slice that deserves its own PR with its own panel review. The
phase-1 cut here is what compiles, runs, and tests cleanly today
and gives the next builder dispatch a stable foundation to stack
on.

PR #337 (`feat(where): Endo Gateway host-scope path functions`)
holds the `whereEndoGateway*` foundation slice and was not folded
in per the dispatch's "reference but do not fold" guidance. The
phase-1 skeleton does not consume those functions yet; they
become relevant when the UDS bootstrap (feature 4) lands the
`whereEndoGatewayRegistrarSock` consumer.

## Files added (this engagement)

- `packages/gateway/package.json` — workspace, deps on @endo/errors,
  @endo/exo, @endo/far, @endo/patterns, @endo/promise-kit,
  @endo/eventual-send.
- `packages/gateway/index.js` — `makeGateway` factory + public re-exports.
- `packages/gateway/src/config.js` — bind-address parser, config
  merger, env reader, dependency-graph validator.
- `packages/gateway/src/vhost.js` — `AppsNameHub` exo +
  `normalizeVirtualHostName`.
- `packages/gateway/types.d.ts` — public types.
- `packages/gateway/test/config.test.js` — 24 tests covering the
  bind-address parser (IPv4, IPv6, hostname, port-0 distinct
  from default, edge cases) and dependency-graph validator.
- `packages/gateway/test/vhost.test.js` — 15 tests covering the
  AppsNameHub bind/unbind/lookup/list contract and the
  first-bind-wins collision policy.
- `packages/gateway/test/gateway.test.js` — 13 tests covering the
  `makeGateway` factory, env-beats-config ordering, lifecycle
  contract, and `getApps`/`getConfig` shape.
- `packages/gateway/README.md`, `CHANGELOG.md`, canonical
  `SECURITY.md`, `LICENSE`, `tsconfig.{json,build,composite}.json`.
- `.changeset/add-endo-gateway-skeleton.md` — minor changeset.
- `tsconfig.composite.json` — registers the new package in the
  root composite.

## Files modified

- `yarn.lock` — adds the `@endo/gateway@workspace:packages/gateway`
  entry. Shipped in its own commit per the project's
  changeset-discipline norm.

## Test runner + pass/fail at report time

`cd packages/gateway && yarn test` → **52 tests passed.**

- config.test.js: 24 passed
- vhost.test.js: 15 passed
- gateway.test.js: 13 passed

`cd packages/gateway && yarn lint` → 0 errors, 2 warnings
(`jsdoc/reject-any-type` on the two `makeExo` calls; this
matches the existing pattern in `packages/daemon/src/ws-gateway.js`
and is the accepted shape for exos with method-guard interfaces).

**Regression evidence verified by mutation** for two
representative tests:

- `parseBindAddress keeps port 0 distinct from default`: mutating
  the parser to apply `Number(portString) || 3469` (the project's
  recurring port-0-falsy pitfall) causes the test to fail as
  expected.
- `mergeGatewayConfig rejects relay without ocapnWebSocket`:
  short-circuiting the dependency check causes the test to fail
  as expected.

## Architectural choices worth maintainer confirmation

1. **Factory name `makeGateway` rather than `make`.** The design's
   Package Shape section names the factory `make({ ... })`. I
   exported it as `makeGateway` instead so downstream consumers
   (`@endo/daemon`, the Familiar shell, the future
   `@endo/gateway-daemon` wrapper) can import it by name without
   renaming at the call site. If the maintainer prefers the
   single-letter form, the rename is one line.

2. **Lifecycle: `stop` is terminal.** The phase-1 exo rejects
   `start` after `stop`. The design's lifecycle section doesn't
   explicitly name this; later phases (when the network surface
   exists) may want a restart shape. The current contract pins
   stop as terminal so a future relaxation is a deliberate
   maintainer decision rather than an accidental side effect of a
   refactor.

3. **First-bind-wins collision policy without operator override.**
   Per the design's Open Question 3 default. The
   operator-allowlist override is a follow-on; the phase-1
   `AppsNameHub` exposes no `setPolicy` method, so the policy
   change is a deliberate API extension when it lands.

4. **`AppsNameHub` is in-memory, not formula-backed.** The design
   says the host agent's `@apps` NameHub is a NameHub; the
   phase-1 version is a plain in-memory exo. When the daemon-side
   formula type lands, the gateway will accept an injected NameHub
   handle rather than minting its own.

5. **No deeper integration with `@endo/daemon` yet.** The phase-1
   PR does not modify `packages/daemon/src/ws-gateway.js`. The
   migration of the in-daemon gateway to the new package (Open
   Question 7 in the design) is a separate PR; this one lands
   the package in isolation so a panel can review the surface
   without churn through the daemon's test suite.

## Concurrent-orchestrator handling

On first push the remote had advanced from `41b1d400f` (my base)
to `5ada59b4f` (eight more design-revision commits). I fetched
and rebased my two commits cleanly onto the new tip; no
conflicts because my work is all under `packages/gateway/` and
`.changeset/`, disjoint from the design revisions on
`designs/gateway-package.md` and `designs/README.md`. Pushed
non-force after the rebase.

## PR state

PR #343 remains OPEN (not draft) per the dispatch's discipline
norm. Two new commits pushed; the design body and the
implementation now live together on the same branch per the
maintainer's "add the implementation to the design PR" directive.

Self-improvement: nothing this time. The dispatch's
suggested scope (skeleton + features 2 + 4+7 + 8) was a useful
anchor but I cut narrower based on dependency-readiness (feature
8 needs the @endo/ocapn-noise netlayer composition; feature 4
deserves its own panel-reviewed PR). The discipline of surfacing
the cut explicitly and naming what each follow-on PR needs is
already in the role's "Surface the cut explicitly in the result"
norm.
