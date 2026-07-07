# Garden bulletin

_As of 2026-07-07T05:07:25Z_

## Latest

Little moved on the board this cycle — no new posts, claims, or completions resolved — but one item needs the maintainer's steer: a gardener building the Gateway `/ocapn` WebSocket endpoint (Feature 8) found it overlaps [endo-but-for-bots#577](https://github.com/endojs/endo-but-for-bots/pull/577), an open draft that implements only the path-scheme half and explicitly defers the live listener and Noise frame relay. Rather than open a competing draft against `llm`, the gardener held its superset work on branch `feat/gateway-ocapn-ws-endpoint-handoff` (locally verified: 73 ava pass, tsc/eslint/prettier clean) and asked you to choose between building the socket handoff *on top of* #577, superseding #577 with the superset, or dropping the branch — recommending the first. The only active job is the XS→Rust (Endor) port, now at Stage-5 child 6/7 (coder).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 4d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 7d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 7d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 10d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 21d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 46d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 46d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 47d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 47d)
- [endojs/endo#3102](https://github.com/endojs/endo/pull/3102) — chore(ci): create custom CHANGELOG generator (waiting 54d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260706T141945Z-1a8516` — from gardener:ebfb-endo-gateway-ocapn-websocket-endpoint, reply_to `ebfb-endo-gateway-ocapn-websocket-endpoint` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T141945Z-1a8516.md)

> Gateway Feature 8 (/ocapn WebSocket endpoint) — DUPLICATE FOUND, held rather than opening a competing PR.
>
> My build job asked for the canonical /ocapn WS endpoint that ACCEPTS the upgrade and HANDS the framed connection to the Noise-over-WebSocket OCapN transport (powers-injected). While pre-flighting for duplicates I found:
>
> - **PR #577 (open draft, base `llm`): "OCapN WebSocket path scheme (/ocapn-cbor-np) — Phase 1 feature 8"** — implements ONLY the pure-logic path-naming half (OCAPN_WS_PATH, matchOcapnWebSocketPath, parseOcapnWebSocketPath, ocapnWebSocketConnectionHint) and EXPLICITLY defers "the live WebSocket listener and the Noise frame relay ... to a later phase." It touches the same files I do (src/ocapn-ws.js, index.js, types.d.ts, README, package.json, test/ocapn-ws.test.js) with different symbol names.
> - Also in flight on other design-phase stacks: #392 (phase-4 "OcapnWebSocketHandler" consuming a {reader,writer} pair, base design/gateway-package-phase-3) and #413 (phase-11a HTTP listener wire-up).
>
> My work is a SUPERSET of #577: it does the path matching PLUS the WebSocket→byte-stream adapter PLUS makeOcapnWebSocketEndpoint.accept() that hands the framed connection to an injected sink, PLUS the makeGateway powers.ocapn seam — i.e. the socket handoff #577 defers. But my src/ocapn-ws.js and #577's are incompatible parallel rewrites of the same module, so they cannot both land on `llm` as-is. Opening a second competing draft PR would collide, so I did NOT open one.
>
> Preserved (no PR): branch `feat/gateway-ocapn-ws-endpoint-handoff` pushed to endojs/endo-but-for-bots. Locally verified: yarn ava (73 pass incl. 20 new), tsc clean, eslint clean, prettier clean; regression-tested two core paths via mutation.
>
> Please steer one of:
> (a) Let #577 land the path-scheme half; re-scope my job to build the socket handoff ON TOP of #577 (my makeOcapnWebSocketEndpoint.accept consuming #577's matchOcapnWebSocketPath instead of my own matcher).
> (b) Supersede #577 with my superset (I open the PR, #577 closes).
> (c) Drop my branch.
>
> Recommendation: (a) — #577 is the sanctioned "one uncovered Phase-1 increment" for the naming and is further along the gauntlet; the socket handoff is a clean follow-on that reuses its path scheme.


## Board
### todo (0)
(none)

### doin (1)
- [`xs2rust-endor-stage5-coder-decl`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-stage5-coder-decl.md) — Stage-5 child 6/7: coder — functions, classes, control flow, generators/async...

### tada (1383)
- [`endojs-endo-but-for-bots-pr600-c9c5b892`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr600-c9c5b892.md) — Completion report — endojs-endo-but-for-bots-pr600-c9c5b892
- [`improve-ci-rollup-surface-gh-stderr-reason`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-ci-rollup-surface-gh-stderr-reason.md) — Completion report
- [`endojs-endo-but-for-bots-pr612-conduct`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr612-conduct.md) — Completion report
- [`mention-kriskowal-garden-29-76b1bf4f`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/mention-kriskowal-garden-29-76b1bf4f.md) — Assessment
- [`build-aws-administration-skill`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/build-aws-administration-skill.md) — Completion report
- … and 1378 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`endojs-endo-but-for-bots-pr96-review-94e37389-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr96-review-94e37389-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #96 (primary: endojs-endo-but-fo...
- [`endojs-endo-but-for-bots-pr612-review-6da32098-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr612-review-6da32098-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #612 (primary: endojs-endo-but-f...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s12`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s12.md) — awaiting `xs2rust-endor-build-stage5` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 20 gardeners
