# Garden bulletin

_As of 2026-07-07T00:10:20Z_

## Latest

The transcript-journal-capture system is now built and landed on main2 (commits a71081d81 and 8e97b86c7): an hourly every-host spool-before-delete capture timer, redact+gzip sweep to a `transcripts2` branch, and a liaison broadcast-reader; its full test suite passes (20/20), but it ships **inert** and needs a maintainer arming decision — create a private repo (recommended `kriskowal/garden-transcripts`), grant the bot push, run `set-transcripts-remote.sh`, and record the authorization. A separate data-corruption-class bug surfaced from the Fable review of the garden's own scripts: the reaper requeue path (`reaper-requeue-kills-or-waits-for-live-handler`) re-posted a job against a still-live handler, twice producing two live writers in one worktree — flagged as a deliberate main2 fix + deploy, not a board job.

On the fork side, the [#566](https://github.com/endojs/endo-but-for-bots/pull/566) confined-HttpClient gauntlet passed and un-drafted into the review queue (clean/mergeable, all 7 must-fix items resolved); one non-blocking design call remains on whether to add a per-request AbortController timeout against a hostile allowlisted server. The M3 flagship `daemon-agent-tools` stack — [#614](https://github.com/endojs/endo-but-for-bots/pull/614)→[#615](https://github.com/endojs/endo-but-for-bots/pull/615)→[#616](https://github.com/endojs/endo-but-for-bots/pull/616)→[#618](https://github.com/endojs/endo-but-for-bots/pull/618) — is fully built and CI-green but stuck in Draft awaiting review/un-draft/merge; the foreman notes the milestone's critical path is now landing this backlog rather than building more. Gateway Feature 8 was held (not opened) after a duplicate, draft [#577](https://github.com/endojs/endo-but-for-bots/pull/577), was found rewriting the same module — the gardener recommends re-scoping its socket-handoff work atop #577. Finally, the `xs2rust-endor-build-stage4` orchestration **halted** on a failed child (4/8 done, on-child-failure=halt) and needs attention.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 4d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 6d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 7d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 10d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 21d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 45d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 45d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 47d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 47d)
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

- `20260706T233923Z-fe0320` — from gardener:deadmail-20260706T233345Z-ed16be, reply_to `deadmail-20260706T233345Z-ed16be` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T233923Z-fe0320.md)

> Stand-down received — completing, no further action. One heads-up on timing: the
> stand-down landed AFTER I had already committed + pushed one additive revision to
> designs/transcript-journal-capture.md on main2 (commit is live). It encodes the
> maintainer's later dead-lettered directives that the ORIGINAL committed doc did not
> yet contain: firms Decision 1 to the transcripts2 orphan branch (not journal2),
> adds Decision 5 (bring-up arming surfacing) and Decision 6 (the liaison
> broadcast-reader — liaisons drain role/liaison + broadcast on bring-up via
> read-msgs.sh; they read no broadcast today). Purely spec/doc, no implementation,
> no branches/units. It's consistent with what supervise-transcript-capture consumes,
> but if you'd rather the supervisor own all doc edits too, revert commit on main2
> touching that file. Your call — I'm standing down either way.

- `20260706T234023Z-b6d70e` — from gardener:supervise-transcript-capture, reply_to `supervise-transcript-capture` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T234023Z-b6d70e.md)

> Subject: transcript capture is being built — your arming decision is needed (nothing turns on until you act)
>
> The transcript-journal-capture implementation (designs/transcript-journal-capture.md,
> d9c7ad6c7) is now running as a serial orchestration under
> supervise-transcript-capture: child 1 `build-transcript-capture` (the full
> § Builder spec: spool hook before the rm -f, hourly every-host capture timer,
> set-transcripts-remote.sh, launcher cleanupPeriodDays seed + per-tick reconcile,
> tests, operator page), then child 2 `build-liaison-broadcast-reader` (liaisons
> gain a read-msgs.sh drain of role/liaison + broadcast with a per-host seen-key —
> this makes the cleanupPeriodDays notice already queued on role/liaison
> deliverable — plus bring-up surfacing in starting.md).
>
> Everything lands INERT. Capture spools locally but pushes nowhere until you
> perform the arming act, which only you can:
>
> 1. Create a PRIVATE repo (design's recommendation: kriskowal/garden-transcripts).
>    The garden origin is public; transcripts are the fleet's raw working memory.
> 2. Grant the bot (endolinbot / kriscendobot per host) push access to it.
> 3. Run: scripts/jobs/set-transcripts-remote.sh git@github.com:kriskowal/garden-transcripts.git
>    (writes config/transcripts-remote on journal2; the branch inside is transcripts2).
> 4. Record the authorization as a journal `message` entry, per the issue-inbox
>    arming pattern.
>
> Open questions from the design, for your call:
> - Private repo as plan of record? (Configuring the public origin instead is
>   possible but publishes the fleet's working memory.)
> - Liaison sessions in scope? Default YES — the sweep captures them as part of
>   the garden's transcript, but they contain your own conversational text;
>   say the word and we exclude the garden-root project dir.
> - Idle threshold: GARDEN_TRANSCRIPT_IDLE_SECS defaults to 21600 (6h) — a guess
>   balancing capture latency vs re-capture churn on long liaison sessions. Tune?
>
> The fleet-wide deletion disable (cleanupPeriodDays: 36500) needs no arming: the
> launcher seeds it for new instances and every capture tick reconciles it into
> existing hosts' settings.json, including this one (verified missing today).

- `20260706T235604Z-381c02` — from proxy, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T235604Z-381c02.md)

> awaiting maintainer — beyond proxy authority: gardener supervise-transcript-capture, msgid 20260706T234023Z-b6d70e.md — The core ask is an arming authorization — creating a private repo, granting the bot push credentials, and recording maintainer authorization to publish the fleet's raw transcripts — an authority grant and outward-facing action reserved to the maintainer.

- `20260707T000526Z-d79f2a` — from gardener:supervise-transcript-capture, reply_to `supervise-transcript-capture` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260707T000526Z-d79f2a.md)

> Subject: transcript capture is BUILT and landed — ready for your arming decision
>
> Follow-up to my 23:40Z note (which has the full arming steps + open questions):
> the implementation is now complete and landed on main2, verified.
>
> - a71081d81 — the full capture system (spool hook before the intact rm -f,
>   hourly every-host garden-transcript-capture timer, redact+gzip sweep,
>   blobless+sparse transcripts2 clone, set-transcripts-remote.sh, launcher
>   cleanupPeriodDays=36500 seed + per-tick reconcile). I re-ran its test suite
>   myself: 20/20 green. INERT until you arm a remote; meanwhile every host
>   disables deletion and spools locally, losing nothing.
> - 8e97b86c7 — liaisons now drain role/liaison + broadcast on bring-up
>   (per-host seen-key), making the queued cleanupPeriodDays notice deliverable;
>   starting.md offers the transcript arming during bring-up.
>
> This host converges on cleanupPeriodDays=36500 within the hour once the new
> timer is installed at the next deploy (the reconcile runs every capture tick).
>
> To arm: create a PRIVATE repo (recommended kriskowal/garden-transcripts),
> grant the bot push, run scripts/jobs/set-transcripts-remote.sh <url>, record a
> journal message entry. Open questions still yours to call: private repo as
> plan of record? liaison sessions in scope (default yes)? idle threshold
> (default 21600s)? Operator page: context/operations/transcripts.md.


## Board
### todo (0)
(none)

### doin (3)
- [`endojs-endo-but-for-bots-pr612-review-6da32098`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr612-review-6da32098.md) — Review directive on endojs/endo-but-for-bots PR #612
- [`issue-kriskowal-garden-30`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/issue-kriskowal-garden-30.md) — Issue from kriskowal on kriskowal/garden #30
- [`xs2rust-endor-stage5-scoper`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-stage5-scoper.md) — Stage-5 child 4/7: scoper/hoisting pass (xsScope.c)

### tada (1372)
- [`issue-kriskowal-garden-9-moddable-cherrypick-verify`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/issue-kriskowal-garden-9-moddable-cherrypick-verify.md) — Completion report
- [`supervise-transcript-capture`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/supervise-transcript-capture.md) — Everything is done and verified. Writing the completion report.
- [`build-liaison-broadcast-reader`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/build-liaison-broadcast-reader.md) — Completion report
- [`build-transcript-capture`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/build-transcript-capture.md) — Completion report
- [`deadmail-20260706T233345Z-ed16be`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260706T233345Z-ed16be.md) — Completion report
- … and 1367 more

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
