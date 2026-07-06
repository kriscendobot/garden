# Garden bulletin

_As of 2026-07-06T14:40:54Z_

## Latest

Little moved on the board itself — the scholar's dialog-DB ingest continues, with `scholar-ingest-dialog-db-remainder-5` now claimed and several earlier remainder cycles completed. The signal is in the maintainer inbox. The gateway build for Feature 8 (the `/ocapn` WebSocket endpoint) was **held rather than opened as a competing PR**: it overlaps [endo-but-for-bots#577](https://github.com/endojs/endo-but-for-bots/pull/577), which lands only the path-scheme half and defers the live listener; the gardener's branch is a superset that adds the socket handoff but is an incompatible rewrite of the same module, so it needs a steer (recommended: re-scope onto #577). Separately, the fable review of the garden's own scripts surfaced a **data-corruption-class bug in the reaper requeue path** — a job requeued every ~18 min against a 40-min handler left the prior handler alive, twice yielding two live writers in one worktree; this is a main2 infra fix warranting a deliberate fix-and-deploy. Finally, the streamlined-onboarding phase-1 job closed as already-landed (commit 8fdbd11e0), noting that design §1.1's `.garden`-first identity is now superseded by the location-derived identity from 6d543582e/367a7543c and should be annotated stale.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 4d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 6d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 7d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 10d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 20d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 45d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 45d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 47d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 46d)
- [endojs/endo#3073](https://github.com/endojs/endo/pull/3073) — feat(patterns): Add `M.choose` (waiting 54d)

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


## Board
### todo (0)
(none)

### doin (4)
- [`build-endo-but-for-bots-daemon-agent-tools-phase1-filesystem-tools`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/build-endo-but-for-bots-daemon-agent-tools-phase1-filesystem-tools.md) — ---
- [`scholar-ingest-dialog-db-remainder-4`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-dialog-db-remainder-4.md) — role: scholar
- [`scholar-ingest-dialog-db-remainder-5`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-dialog-db-remainder-5.md) — role: scholar
- [`xs2rust-endor-stage4-async-await`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-stage4-async-await.md) — Stage-4 child: async/await over the job queue + the promise double-settle key...

### tada (1303)
- [`scholar-ingest-dialog-db-remainder-3`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-dialog-db-remainder-3.md) — Cycle complete. Here is the report.
- [`ebfb-endo-gateway-ocapn-websocket-endpoint`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/ebfb-endo-gateway-ocapn-websocket-endpoint.md) — Completion report
- [`scholar-ingest-dialog-db-remainder-2`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-dialog-db-remainder-2.md) — Cycle complete. Summary of what I did:
- [`scholar-ingest-dialog-db-remainder`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-dialog-db-remainder.md) — Completion report
- [`scholar-ingest-against-sql`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-against-sql.md) — Completion report
- … and 1298 more

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
- [`port-xs-to-rust-memory-safe-engine-s9`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s9.md) — awaiting `xs2rust-endor-build-stage4` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 20 gardeners
