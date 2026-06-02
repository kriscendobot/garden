---
ts: 2026-06-02T05:56:45Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: d1d611
prs:
  - repo: endojs/endo-but-for-bots
    pr: 397
    role: new
  - repo: endojs/endo-but-for-bots
    pr: 396
    role: stack-parent
  - repo: endojs/endo-but-for-bots
    pr: 343
    role: stack-base
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/397
  - https://github.com/endojs/endo-but-for-bots/pull/343
  - designs/gateway-package.md
---

# result: builder — gateway phase 9 PR #397 (Familiar-bundled fallback publisher)

- **PR #397** DRAFT, base `design/gateway-package-phase-8` (PR #396 head),
  head `design/gateway-package-phase-9`.
- Feature 5: Familiar-bundled fallback on OS-assigned port. The
  Familiar embeds `@endo/gateway`, binds `127.0.0.1:0`, and the
  publisher writes the resolved bind URL to a caller-configurable
  state file so the Familiar's `localhttp://` protocol handler
  proxies to the right port.
- 392 / 392 gateway tests pass (349 -> 392, net +43). Lint 0
  errors, typecheck clean.

## Affected packages

- `@endo/gateway`: new files `src/familiar-publish.js`,
  `src/node-familiar-publish-powers.js`,
  `test/familiar-publish.test.js`; wired into `index.js`,
  `config.js`, `package.json` exports, and the existing
  `test/gateway.test.js`, `test/config.test.js`,
  `test/git-http.test.js`, `test/ocapn-ws.test.js`.

## Choices

- **Two-module split (portable core + Node adapter)**. The
  publisher is platform-agnostic; the Node-backed `IoPowers` adapter
  (`mkdir -p`, `writeFile`, `unlink` with `ENOENT` tolerance) lives
  in a sibling file. Matches the `node-crypto-powers.js` precedent
  from Phase 2.
- **URL line format matches the daemon's
  `${statePath}/gateway`**. The Familiar's existing reader
  (`packages/familiar/src/daemon-manager.js` `getGatewayAddress`)
  parses with `new URL(...)` and pulls `host:port`; the publisher
  renders `http://${host}:${port}\n` so a Familiar that does not
  distinguish daemon-published from gateway-published files ingests
  either uniformly. A separate Familiar-side PR will switch
  `electron-main.js` over when the Familiar-bundled gateway lands.
- **`familiarBundled` toggle, default off**. The Familiar variant
  opts in; the system-service and standalone deployments do not
  gain a new requirement. Toggle-on with no publisher is a startup
  error (fail-closed posture from Phase 7).
- **Publisher independent of every other feature**. The design's
  Feature 5 sample configuration runs with `udsBootstrap`,
  `adminDaemon`, `gitHttp`, `captpRelay`, `ocapnWebSocket` all off.
  No dependency edge into the validator.
- **IPv6 bracket preservation**. The publisher rejects portless
  bind addresses but otherwise passes the `host:port` substring
  through verbatim, so `[::1]:54321` survives intact for the
  Familiar's `new URL` parser.

## Carry-forward from prior phases

- Phase 2 byte-shape convention: not applicable (URL line, not
  byte fields). The exo uses `M.string()` so non-strings reject
  at the wire boundary.
- Phase 7 fail-closed-on-config-drift: applied to construction
  (`familiarBundled=true` with no publisher throws) and to
  `start` (publisher errors propagate rather than degrade to a
  stale file).
- Phase 8 mutual-exclusion idiom: not applicable; the publisher
  power is independent.

## Next stage in chain

The PR opens DRAFT per `pr-creation-flow`. The judge (or barrister
for the first round) drives panel + fixer-loop until termination,
then un-drafts. Phases 10 and 11 (Features 9 and 10) follow.

Self-improvement: nothing this time.
