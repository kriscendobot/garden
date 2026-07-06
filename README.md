# Garden bulletin

_As of 2026-07-06T22:21:51Z_

## Latest

The confined-HttpClient gauntlet on [endo-but-for-bots#566](https://github.com/endojs/endo-but-for-bots/pull/566) (M3 confined outbound HTTP) finished: all seven must-fix items resolved and regression-tested, panel re-review passed, and the PR is un-drafted into kriskowal's review queue — clean and mergeable, with one deferred design call (a per-request AbortController timeout the two governing designs disagree on). The M3 flagship `daemon-agent-tools` stack is fully built: phases 1–3 ([#614](https://github.com/endojs/endo-but-for-bots/pull/614), [#615](https://github.com/endojs/endo-but-for-bots/pull/615), [#616](https://github.com/endojs/endo-but-for-bots/pull/616)) are CI-green but still Draft, and phase 4 ([#618](https://github.com/endojs/endo-but-for-bots/pull/618)) has cleared its last un-draft blocker — the critical path is now maintainer review, un-draft, and merge of that stack, a conductor step the foreman cannot post. Gauntlets on #615 and #616 are in flight, and [#617](https://github.com/endojs/endo-but-for-bots/pull/617) completed. The XS→Rust (Endor) port advanced through the stage-5 lexer to the parser expression-grammar child, but the stage-4 orchestration HALTED on a failed `xs2rust-endor-stage4-modules` child (4/8 done). Two items need a maintainer decision: a data-corruption-class bug in the reaper requeue path (a garden-infra fix warranting a deliberate fix + deploy, not a board job), and Gateway Feature 8, whose builder held its branch rather than open a PR competing with the path-scheme draft [#577](https://github.com/endojs/endo-but-for-bots/pull/577) — recommending the socket handoff be re-scoped on top of #577.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 4d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 6d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 7d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 10d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 21d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 45d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 45d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 47d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 46d)
- [endojs/endo#3073](https://github.com/endojs/endo/pull/3073) — feat(patterns): Add `M.choose` (waiting 55d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260706T114016Z-d133d3` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T114016Z-d133d3.md)

> From the fable review of the garden's own scripts (report `fable-review-fix-garden-scripts`): a data-corruption-class bug was found in the reaper requeue path — `reaper-requeue-kills-or-waits-for-live-handler`. The job was requeued roughly every 18 min against a 40-min handler wall while the prior handler was left alive, twice producing two live writers in one worktree (pids/timestamps in the job body). This is a garden-infrastructure fix (main2, no bot-repo PR), so I'm surfacing it rather than posting a board job — it warrants a deliberate fix + deploy. Two lesser items rode along and need no decision: the accepted-but-deferred `watchers-port-fail-floor-to-mention-issue-inbox` fix, and `ci-watcher-test-preexisting-failures` (6/29 failures on a pristine main2 tree, unrelated to that job's changes).

- `20260706T115432Z-634cb5` — from gardener:onboarding-p1-launcher, reply_to `onboarding-p1-launcher` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T115432Z-634cb5.md)

> Job onboarding-p1-launcher (streamlined-onboarding phase 1): no changes made — the work is already landed, and the one remaining design point was deliberately superseded. Detail:
>
> Phase 1 landed 2026-07-04 in commit 8fdbd11e0 ("direct-exec launcher, auto-build, guard-hook seed"). Present in current origin/main2:
>   - garden: auto-build (ensure_container), .claude/settings.json seeding with the SessionStart guard hook (seed_claude_settings), `exec claude --dangerously-skip-permissions` on bare enter (cmd_enter), and the `./garden sh` debug-shell subcommand (cmd_sh).
>   - Dockerfile: claude CLI install + `command -v claude` build assertion + /etc/profile.d/garden.sh PATH wiring.
>   - CLAUDE.md § Container guard: the launcher-seeded-hook sentence.
>
> The ONLY job item not present is the design's ".garden-file-first identity". It is absent on purpose: commits 6d543582e and 367a7543c (both 2026-07-06, ~8h before this job was promoted) deleted the .garden file and GARDEN env knob from the launcher, replacing them with LOCATION-derived identity (<hostname>-<basename>-<hash8>), citing two concrete bugs the .garden model caused (the "lost container" strand and journal-worktree corruption) and verifying with two concurrent instances. That newer decision achieves the same user-facing goal the design wanted — bare `./garden` needs zero required env vars — via a different, better mechanism.
>
> Re-adding .garden-first identity per design §1.1 would revert 6d543582e/367a7543c, so I did not. If you DO want .garden naming back (e.g. as sugar layered on top of location-derivation), please re-post with that reconciliation spelled out; otherwise design §1.1's identity paragraph is stale and could be annotated as superseded. Completing the job as already-satisfied.

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

- `20260706T181347Z-a1dca0` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T181347Z-a1dca0.md)

> foreman: next step 'build-endo-but-for-bots-endoclaw-timer-phase2-tick-delivery' recurred after the previous post drained without milestone progress. Holding the re-post pending review; it may be stuck.

- `20260706T182517Z-526c55` — from orchestrator:xs2rust-endor-build-stage4-halted, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T182517Z-526c55.md)

> Orchestration xs2rust-endor-build-stage4 HALTED: child xs2rust-endor-stage4-modules failed (serial, on-child-failure=halt). 4/8 done before halt; swept: xs2rust-endor-stage4-compartment xs2rust-endor-stage4-lockdown-harden xs2rust-endor-stage4-ses-conformance

- `20260706T201600Z-b1183b` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T201600Z-b1183b.md)

> M3's flagship pillar — Claw-like coding capabilities via `endojs/endo-but-for-bots` `daemon-agent-tools` — is fully built: phases 1–3 (#614, #615, #616) are CI-green and mergeable but still Draft, and phase 4 (#618) had its last un-draft blocker (the live-daemon integration test) closed, so it now only awaits phases 1–3 landing. The decision needed is maintainer review + un-draft + merge of the #614→#615→#616→#618 stack (a conductor/authority step the foreman cannot post); nearly all other M3 designs are likewise already built into open Draft PRs, so the milestone's critical path is now landing this backlog rather than more building.

- `20260706T215117Z-e6d171` — from gardener:endojs-endo-but-for-bots-pr566-gauntlet, reply_to `endojs-endo-but-for-bots-pr566-gauntlet` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T215117Z-e6d171.md)

> Gauntlet on endojs/endo-but-for-bots #566 (confined HttpClient, M3 "confined outbound HTTP") — done: panel re-review passed, PR un-drafted into your review queue, CLEAN/MERGEABLE.
>
> All 7 prior must-fix items are resolved and regression-tested (40 tests green; tsc + eslint + .d.ts emission verified locally). Panel verdict posted on the PR.
>
> One design decision is yours to make (recorded as a follow-up, not merge-blocking): the breaker seat found a hostile-but-allowlisted origin streaming infinite zero-length chunks (or trickling below the byte cap) makes fetchBounded never settle — there's no per-request timeout backstop. It's a hostile-SERVER vector outside the guest-confinement model and recoverable via revoke(), but the clean remedy is a per-request AbortController timeout, which the two governing designs disagree on: cli-http-client.md §Defenses mandates it, endoclaw-network-fetch.md omits it. Want me to add the timeout (and reconcile the designs), or defer it?
>
> Smaller should-fix follow-ups also in the verdict: drop CONNECT/TRACE from the method allowlist (README advertises them but fetch throws), harden json() result, headersToRecord __proto__ footgun, a couple doc reconciliations, and boundary tests.


## Board
### todo (0)
(none)

### doin (3)
- [`endojs-endo-but-for-bots-pr615-gauntlet`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr615-gauntlet.md) — Run the gauntlet on endojs/endo-but-for-bots PR #615 (daemon-agent-tools Phas...
- [`endojs-endo-but-for-bots-pr616-gauntlet`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr616-gauntlet.md) — Run the gauntlet on endojs/endo-but-for-bots PR #616 (daemon-agent-tools Phas...
- [`xs2rust-endor-stage5-parser-expr`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-stage5-parser-expr.md) — Stage-5 child 2/7: parser — expression grammar (xsSyntaxical.c, first half)

### tada (1356)
- [`endojs-endo-but-for-bots-pr617-gauntlet`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr617-gauntlet.md) — Completion report
- [`deadmail-20260706T215253Z-583454`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260706T215253Z-583454.md) — Completion report
- [`xs2rust-endor-stage5-lexer`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-stage5-lexer.md) — Completion report
- [`endojs-endo-but-for-bots-pr566-gauntlet`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr566-gauntlet.md) — Completion report
- [`port-xs-to-rust-memory-safe-engine-s11`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/port-xs-to-rust-memory-safe-engine-s11.md) — Completion report — supervisor s11 (XS→Rust port, PR endojs/endo-but-for-bots...
- … and 1351 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
(none)

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
