# Garden bulletin

_As of 2026-07-06T18:26:55Z_

## Latest

The **xs2rust-endor-build-stage4** orchestration (Hardened JavaScript port for [endo-but-for-bots#600](https://github.com/endojs/endo-but-for-bots/pull/600)) **halted** after 4/8 children: the serial child `xs2rust-endor-stage4-modules` (module machinery — ModuleSource, records, namespaces) blew its 2400s handler wall twice, so the reaper parked it as a poison job in `plan/` (held pending a human `promote-plan.sh`); the supervisor stage `port-xs-to-rust-memory-safe-engine-s9` was promoted to `doin` to carry the port forward. Triage needs a decision: split the module job, raise its timeout, or fix what runs long.

Three items want maintainer steering. A **garden-infrastructure data-corruption bug** surfaced from the Fable review of the garden's own scripts — the reaper requeue path (`reaper-requeue-kills-or-waits-for-live-handler`) twice left two live writers in one worktree by requeuing a job every ~18 min against a 40-min handler; the liaison flags it as a deliberate main2 fix + deploy (no bot-repo PR). The Gateway `/ocapn` WebSocket handoff build was **held rather than opened as a competing PR**: it's a superset of the in-flight draft [endo-but-for-bots#577](https://github.com/endojs/endo-but-for-bots/pull/577) (path-scheme half only) but rewrites the same module incompatibly; the gardener recommends re-scoping to build the socket handoff on top of #577. Separately, the foreman is holding a re-post of `build-endo-but-for-bots-endoclaw-timer-phase2-tick-delivery`, which recurred without milestone progress and may be stuck.

No action needed on `onboarding-p1-launcher`: phase 1 already landed (commit 8fdbd11e0), and the design's `.garden`-file identity was deliberately superseded by the location-derived identity in 6d543582e/367a7543c.

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

- `20260706T181347Z-a1dca0` — from foreman, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T181347Z-a1dca0.md)

> foreman: next step 'build-endo-but-for-bots-endoclaw-timer-phase2-tick-delivery' recurred after the previous post drained without milestone progress. Holding the re-post pending review; it may be stuck.

- `20260706T182517Z-526c55` — from orchestrator:xs2rust-endor-build-stage4-halted, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T182517Z-526c55.md)

> Orchestration xs2rust-endor-build-stage4 HALTED: child xs2rust-endor-stage4-modules failed (serial, on-child-failure=halt). 4/8 done before halt; swept: xs2rust-endor-stage4-compartment xs2rust-endor-stage4-lockdown-harden xs2rust-endor-stage4-ses-conformance

- `poison-xs2rust-endor-stage4-modules-deadline-overrun` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/poison-xs2rust-endor-stage4-modules-deadline-overrun.md)

> POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 2 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
> Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
> this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
> so the reaper surfaced it after 2 overrun cycles (not the full 5-cycle poison threshold).
> The work is preserved at jobs/plan/xs2rust-endor-stage4-modules; it stays HELD until a human promotes it
> (promote-plan.sh xs2rust-endor-stage4-modules) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
> for this work, or fix what makes it run long.
> Original job base: xs2rust-endor-stage4-modules
>
> --- original job body ---
> ---
> model: opus
> ---
> <!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-06T15:10:25Z -->
>
> ---
> model: opus
> ---
> # Stage-4 child: module machinery: ModuleSource, module records, namespaces
>
> **Program context (read first).** You are one serial child of the `xs2rust-endor-build-stage4`
> orchestration (Hardened JavaScript) in the supervised program `port-xs-to-rust-memory-safe-engine`.
> Repo `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor`, base `llm`. **Keep the PR
> DRAFT.** Get your ISOLATED worktree with
> `/home/kris/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`
> (never share a tree; concurrent pushes race safely at the git-push CAS — rebase and retry).
> The engine lives in `rust/engine/` (independent cargo workspace; `cargo` at `/home/kris/.cargo/bin`).
> Read `rust/engine/README.md` first: oracle pin `48ee02d8cfe0` population fallbacks (the empty-gitlink
> footgun — `git init` in `c/moddable` first, then fetch from a sibling
> `/home/kris/scratch/project-wt-*/c/moddable`), harness invocation, evidence blocks. Read the design
> `designs/xs2rust-endor-engine.md` §§ Value and heap model, Metering, Hardened JavaScript and
> Compartment, Staged Roadmap, and the GC-roots contract note.
>
> **Doctrine (binding): accuracy over parity (2026-07-04).** Result agreement gates; the C-XS oracle
> certifies RESULTS only. The meter is endor's own frozen release-versioned cost table —
> deterministic per release, recalibrated only deliberately, NEVER back-fit to oracle computrons or
> CESU-8 byte lengths. Computron-vs-oracle is advisory telemetry. The branch's dual-run runner still
> gates computrons (stricter than the bar): keep it green via calibrated constants or honest named
> skips; do NOT relax the runner to result-gating (that belongs to the test262-convergence work).
> An unimplementable or oversized surface becomes an **honest named skip** (`Halt::Unsupported`
> self-naming), never a wrong value or a silent divergence.
>
> **GC-roots contract (standing ledger item).** If your work wires GC into the run loop or adds
> allocation pressure triggers, the root set MUST cover the interpreter side tables
> (`functions[*].closures`, `CallerState`, `CatchJump`, `global_props`, and the newer
> regexp/bound/promise side tables — note `FuncInfo.body_start` is now `Option<usize>` with bound
> functions gated at the `enter_call` choke point), with deterministic trigger points. If you do not
> touch GC scheduling, carry the note forward untouched.
>
> **Bar (every child).** `cargo test --workspace -- --test-threads=1` green in `rust/engine/`;
> `#![forbid(unsafe_code)]` intact on all engine crates; affected test262 sections dual-run
> (per-subtree — whole-tree `language/` runs OOM; the runner takes DIRECTORY sections only, a
> single-file arg silently runs 0 files) with **divergent=0** and every skip named; new coverage
> locked into `cargo test` as a section-bar test; corpus fixtures for new grammar; Miri on touched
> allocation/GC paths (`TMPDIR=/home/kris/tmp` — /tmp is noexec for the sysroot build); commit with
> explicit pathspecs and push to `origin/xs2rust-endor` (rebase-CAS loop); update
> `rust/engine/README.md`'s evidence block with your numbers.
>
> **Sizing.** You are sized to ONE 2400s handler invocation. If the scope does not fit, land what is
> green, self-name the remainder as honest skips, and report the **scope fold** explicitly — never a
> half-implemented surface. Report completion (numbers + skips + scope folds) via
> `/home/kris/scripts/jobs/inbox-send.sh port-xs-to-rust-memory-safe-engine-s9` — the supervisor's
> next stage. NEVER message the maintainer inbox; PR #600 comments only if you land a
> notable milestone. Drain your own inbox at checkpoints.
>
> ## Scope (child 5/8)
>
> Port the module machinery from the pin's `xsModule.c` (static half first):
>
> - `XS_CODE_MODULE`, import/export linkage: module records, module environment (indirect
>   bindings — live re-export semantics), module namespace exotic objects (sorted keys, no-set,
>   `@@toStringTag`), cyclic module graphs (DFS instantiate/evaluate ordering), TDZ on
>   un-evaluated bindings.
> - **ModuleSource** as a first-class constructable (the XS/Compartment shape: compile-only,
>   bindings reflection) to the extent the oracle compiler seam supports feeding module source —
>   establish how the oracle compiles a module (xst compiles modules via its runner; if the
>   oracle shim cannot drive module compilation, extend it minimally on the audited FFI seam, or
>   self-name the differential gap honestly and verify module semantics with endor-side unit
>   corpora + the pin run manually via xst, documenting the method in the README).
> - **Module maps** (specifier → module) as the machine-level seam Compartment (child 6) will
>   consume; a minimal host resolve hook (static specifiers; no filesystem).
> - Dynamic `import()` and `import.meta`: named skips (`module:dynamic-import`, `module:import-meta`)
>   unless they fit trivially.
>
> ## Acceptance focus
>
> `language/module-code/` dual-run per-subtree IF the oracle seam supports module goal parsing —
> divergent=0 with named skips; otherwise the documented endor-side corpus + manual-xst method,
> plus namespace/linkage unit tests locked in cargo. Record honestly which path was achieved.
>
>
>
>
> <!-- garden-deadline-overrun: 2 -->


## Board
### todo (0)
(none)

### doin (2)
- [`build-endo-but-for-bots-endoclaw-timer-phase2-tick-delivery`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/build-endo-but-for-bots-endoclaw-timer-phase2-tick-delivery.md) — ---
- [`port-xs-to-rust-memory-safe-engine-s9`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/port-xs-to-rust-memory-safe-engine-s9.md) — Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...

### tada (1327)
- [`xs2rust-endor-build-stage4`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-build-stage4.md) — orchestration xs2rust-endor-build-stage4 — HALTED
- [`build-endo-but-for-bots-filesystem-watchers-endomount-follow-name-changes`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/build-endo-but-for-bots-filesystem-watchers-endomount-follow-name-changes.md) — Findings
- [`endojs-endo-but-for-bots-pr616-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr616-shepherd.md) — CI is green. Job complete.
- [`improve-gardener-deterministic-overrun-alert`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/improve-gardener-deterministic-overrun-alert.md) — Completion report
- [`build-endo-but-for-bots-daemon-agent-tools-phase3-git-tools`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/build-endo-but-for-bots-daemon-agent-tools-phase3-git-tools.md) — Completion report
- … and 1322 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`xs2rust-endor-stage4-modules`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/xs2rust-endor-stage4-modules.md) — _normal_ · Stage-4 child: module machinery: ModuleSource, module records, namespaces

### deferred (top by priority; foreman auto-promotes when idle)
(none)

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 20 gardeners
