# Garden bulletin

_As of 2026-08-16T06:52:00Z_

## Latest

On the board, minion.town's MCP work advanced: [B1 socket-adapter](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/minion-town-mcp-b1-socket-adapter.md) completed (it was already implemented and merged in an earlier commit) and B2 (first real per-session guest tools) was claimed; the PR #701 SturdyRef restack onto the PR #737 line and a fresh red-CI shepherd on [endo-but-for-bots#831](https://github.com/endojs/endo-but-for-bots/pull/831) also went in-flight.

Two things want a maintainer decision. [endo-but-for-bots#824](https://github.com/endojs/endo-but-for-bots/pull/824) is non-draft with green CI and a clean merge state but is stuck on a **stale approval** — kriskowal's APPROVED review is pinned to the old head `9b40eef`, while the current head is `a0cd0d0`, so the conductor gate needs a re-approval on the current head before it can merge. Separately, the [endo-but-for-bots#804](https://github.com/endojs/endo-but-for-bots/pull/804) review is **holding for an intent confirm** before churning design docs: the landed facts (`@endo/syrup-frame` shipped, no CBOR framing pkg landed) contradict `cbors.md`/`syrups.md`, and the gardener wants a Y/N on renaming both docs to the `-frame` convention.

Reliability pressure on the leader host: the hourly [xs2rust-endor #600](https://github.com/endojs/endo-but-for-bots/pull/600) press-driver, `endojs-pr160-ci-fix-finalize`, and `daemon-store-phase4-sorted` all **deterministically overran the 2400s handler budget and were poisoned/parked** — the daemon-store-family-build orchestration halted at 3/6 children as a result. These jobs exceed a single claim-scoped handler and need to be split into stages or run detached before they can make progress.

The finbot [PR #4](https://github.com/kriscendobot/finbot/pull/4) SES-compartment role-program feature reached green CI and is mergeable, but is blocked purely on governance — the 28-seat panel can't run until the panel model's weekly limit resets (Jul 25 03:00 UTC), so no Fable sign-off yet. Research also landed a clear verdict on **Kimi K3**: locally infeasible (>10× the box's memory, weights not public until Jul 27), but cheap to wire as a hosted OpenAI-compatible arm for the bid-auction if a funded Moonshot key and codex tool-call compatibility check out.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/pull/475) — feat(pass-style): narrow byteArray to plain frozen Uint8Array (waiting 2d)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 17d)
- [endojs/endo-but-for-bots#730](https://github.com/endojs/endo-but-for-bots/pull/730) — design(registry): Endor/XS registry transport power (waiting 17d)
- [endojs/endo-but-for-bots#856](https://github.com/endojs/endo-but-for-bots/pull/856) — fix(endor): run ambiguous import-bearing .js entries as ESM (module-syntax detection) (waiting 18d)
- [endojs/endo-but-for-bots#166](https://github.com/endojs/endo-but-for-bots/pull/166) — feat(endor): add rust/endor TUI skeleton (re-opened from #31 under the bot) (waiting 28d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 27d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 29d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 30d)
- [endojs/endo-but-for-bots#670](https://github.com/endojs/endo-but-for-bots/pull/670) — feat(lal): subscription OAuth flow and encrypted auth store (M3) (waiting 33d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 44d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260725T032549Z-31957b` — from gardener:endo-byte-array-press-20260724-105003, reply_to `endo-byte-array-press-20260724-105003` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260725T032549Z-31957b.md)

> Byte-array press status (dispatch 2026-07-24T10:50Z, completed 07-25): both fronts are done on our side and waiting ONLY on human re-review — [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/issues/503) (head 453f6ef0, 15/15 CI green, no reviewer activity since 07-20) and [endojs/endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/issues/475) (head 1b1dc75b, 17/17 CI green, quiet since the 07-17 rebase). reviewDecision on both is stale CHANGES_REQUESTED with re-review pending from kriskowal and erights. [endojs/endo-but-for-bots#671](https://github.com/endojs/endo-but-for-bots/issues/671) is still open, so the registry follow-up stays parked.
>
> Fleet note: this press has produced no completed report since 07-22 — every 6h dispatch since then overran and was reaper-requeued (mine was reaped 4x), and three claims (105003/165003/225004) were live concurrently. With the arc blocked on your re-review, each tick burns a Fable budget to observe "no change". Suggest either pausing the schedule (paused-schedules mechanism) or widening the cadence to 24h until the two PRs get their re-review, and/or giving this press an xs2rust-style preflight circuit-breaker (commit 2898c87d).

- `20260725T171127Z-34b706` — from gardener:endo-npm-cas-registry-press-20260725-170501, reply_to `endo-npm-cas-registry-press-20260725-170501` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260725T171127Z-34b706.md)

> npm-CAS press tick 17:05: Your APPROVED review on draft [endojs/endo-but-for-bots#856](https://github.com/endojs/endo-but-for-bots/issues/856)
> (ambiguous-.js-entry ESM fix) + all-green CI met the conductor's ready-to-land bar,
> so I marked it ready and posted merge job
> `merge-endo-but-for-bots-pr856-ambiguous-entry-esm` (park it if you'd rather hold).
> Drafts [endojs/endo-but-for-bots#857](https://github.com/endojs/endo-but-for-bots/issues/857) (peer/optional deps) and
> [endojs/endo-but-for-bots#859](https://github.com/endojs/endo-but-for-bots/issues/859) (process shim) are CI-green awaiting your review.
> This tick's press: the ".npmrc auth beyond tokens" design gap (Basic auth
> username/_password/_auth + ${VAR} expansion). Also posted
> `ebfb-rust-endo-xs-test-flakiness` for the intermittent parallel XS test failures
> prior ticks kept re-reporting.

- `20260725T190612Z-1377ce` — from gardener:proposal-compartments-v8-validation-20260725, reply_to `proposal-compartments-v8-validation-20260725` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260725T190612Z-1377ce.md)

> v8 validation front done (draft PR [kriscendobot/proposal-compartments#2](https://github.com/kriscendobot/proposal-compartments/issues/2)).
>
> Two things worth a maintainer eye:
>
> 1. Cross-front staging defect (affects jsc/xs/endor too): every nested staged
>    test on kriscendobot/test262 @proposal-compartments imports
>    "./fixtures/NAME_FIXTURE.js", but the shared fixtures dir is one level up at
>    "../fixtures/". All subdir tests reference a nonexistent path and fail to load
>    on ANY engine. source-key/brand-and-identity is the only apparent pass, only
>    because it never calls import(). Fix: "./fixtures/" -> "../fixtures/" per
>    import. This belongs in the test262 fork (consolidate-... front), not the v8
>    PR. Flagging so the other three fronts don't each rediscover it.
>
> 2. Native v8 is blocked and I did not call it green: the reachable engine (Node
>    22.23 / V8 12.4.254) has no source-phase imports, import.source, import defer,
>    or Compartment global, and no v8 source/build toolchain was present. The PR
>    ships a semantic conformance harness (spec.emu operations on
>    vm.SourceTextModule) that runs 9/10 staged families green with a negative
>    control proving teeth; the 10th (import-defer) is blocked on the same missing
>    engine feature. Harness is a behavioral oracle for the native port, not a
>    substitute. Bounded next increment for the native front is in the PR README.

- `20260725T190827Z-b01774` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260725T190827Z-b01774.md)

> The `proposal-compartments-v8-validation-20260725` report leaves one open spec-annex decision that is your call: whether the Compartments proposal adds a host-only synchronous evaluation operation to cover the charter's non-TLA path shortfall. No garden action taken pending your direction. (The native-v8-port follow-up is inert — gated on upstream V8 landing source-phase imports, `import.source()`, and `import defer` — so nothing is posted for it.)

- `20260725T211524Z-18a859` — from gardener:merge-endo-but-for-bots-pr856-ambiguous-entry-esm, reply_to `merge-endo-but-for-bots-pr856-ambiguous-entry-esm` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260725T211524Z-18a859.md)

> Conductor stalled on [endojs/endo-but-for-bots#856](https://github.com/endojs/endo-but-for-bots/issues/856) (ambiguous .js entry ESM detection) — approval went stale.
>
> State: OPEN, not draft, MERGEABLE/CLEAN on base `llm`, all 24 CI checks GREEN on head ca0b6c0.
>
> Blocker: your APPROVED review (2026-07-25T05:48Z) was on commit efe4b29. After that, kriscendobot pushed one more commit — ca0b6c0 `test(endor): cover assigned dynamic import` — a single test-only line in rust/endo/src/cjs_lexer.rs:
>   + assert!(!detect_esm_syntax("const module = import('lazy');\n"));
> No production code changed. GitHub dismissed the approval on that push (reviewDecision now empty), so the current head carries no maintainer approval. Per the conductor approval gate I did not merge.
>
> To land: a fresh approval on head ca0b6c0 (then re-post the merge job, or I can be re-run). [https://github.com/endojs/endo-but-for-bots/pull/856](https://github.com/endojs/endo-but-for-bots/pull/856)

- `20260726T024419Z-9fb3d7` — from gardener:endojs-endo-but-for-bots-pr856-conduct, reply_to `endojs-endo-but-for-bots-pr856-conduct` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260726T024419Z-9fb3d7.md)

> Conductor stall — [endojs/endo-but-for-bots#856](https://github.com/endojs/endo-but-for-bots/issues/856) is ready EXCEPT for a current maintainer approval.
>
> - State: OPEN, non-draft, MERGEABLE/CLEAN, base=llm (live trunk).
> - CI: 24/24 checks green.
> - Approval: the APPROVED review 4778593042 by kriskowal is on the SUPERSEDED commit efe4b29f. The current head is ca0b6c02 (the follow-up that resolved the inline feedback). The only review on the current head is a COMMENTED (non-approving) one by kriscendobot.
> - kriskowal has been re-requested but has not re-approved the current head.
>
> Merge blocked: no maintainer approval on current head. Nothing else stands in the way — a fresh APPROVED review from kriskowal (or another allowlist maintainer) on ca0b6c02 unblocks an immediate merge. Please re-post the conduct job (or nudge the review) once that lands.

- `20260726T113143Z-a39dce` — from gardener:endo-npm-cas-registry-press-20260726-112002, reply_to `endo-npm-cas-registry-press-20260726-112002` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260726T113143Z-a39dce.md)

> npm-via-CAS press (2026-07-26 tick): the finish line is REACHED, gated on one merge.
>
> Real-execution evidence at endo-but-for-bots `llm` HEAD (2be66d9f67), fresh isolated state each run:
> - `endor run entry.mjs` and a CJS `.js` entry both work end to end TODAY: network fetch from registry.npmjs.org → CAS ingest (content-addressed, deduplicated) → SQLite registry-table row → XS execution. Transitive CJS graph (semver@7.5.4 → lru-cache@6 → yallist@4) fetches and executes; `--offline` replay is deterministic (identical hashes, zero network); fresh-state `--offline` correctly refuses. No npm CLI, no node_modules, no lockfile.
> - The ONE remaining execution gap at HEAD: an ambiguous import-bearing `.js` entry (the design's literal `endor run entry.js`) misroutes into the CJS loader and fails. [endojs/endo-but-for-bots#856](https://github.com/endojs/endo-but-for-bots/issues/856) (open, NOT draft, CI green, MERGEABLE, review feedback addressed) fixes exactly this; I built llm plus that branch merged locally and confirmed the exact repro flips to passing. Cross-validation evidence posted: [https://github.com/endojs/endo-but-for-bots/pull/856](https://github.com/endojs/endo-but-for-bots/pull/856)#issuecomment-5083281137
>
> Recommendation: merge [endojs/endo-but-for-bots#856](https://github.com/endojs/endo-but-for-bots/issues/856) — it is the last execution blocker for the npm-registry-proxy finish line. After it lands, the design's Status section can be marked Complete with the evidence above.
>
> Also live on this arc (draft, from prior ticks, all MERGEABLE/green): [endojs/endo-but-for-bots#857](https://github.com/endojs/endo-but-for-bots/issues/857) peer/optionalDependencies, [endojs/endo-but-for-bots#859](https://github.com/endojs/endo-but-for-bots/issues/859) process shim (consolidated with [endojs/endo-but-for-bots#863](https://github.com/endojs/endo-but-for-bots/issues/863)), [endojs/endo-but-for-bots#860](https://github.com/endojs/endo-but-for-bots/issues/860) .npmrc auth, [endojs/endo-but-for-bots#862](https://github.com/endojs/endo-but-for-bots/issues/862) registry CLI.

- `20260726T191230Z-6b2ff0` — from gardener:proposal-compartments-press-20260726-190502, reply_to `proposal-compartments-press-20260726-190502` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260726T191230Z-6b2ff0.md)

> proposal-compartments daily press (2026-07-26): the effort has hit a strategic fork on the fifth finish-line bar (four-engine native agreement) that needs your call.
>
> Findings (all four validation fronts have now run):
> - The spec makes a Compartment source key ONLY a source-phase module source object (the value that `import source` / `import.source()` produce). That syntax is the sole route to a source key, so every staged test opens with it.
> - That syntax is unimplemented in v8 (Node 22 / V8 12.4), JSC (WebKitGTK 2.52.3), and XS/endor (Moddable XS). All four fail at parse before any Compartment code runs. This is intersection-by-design, not a Compartment disagreement.
> - The spec SEMANTICS do validate: the v8 semantic harness over Node vm.SourceTextModule passes 9 of 10 staged families (1 blocked on native import defer), re-verified today against test262 HEAD 63b7e7c.
>
> So four-engine native agreement depends on source-phase imports first shipping in each engine, a large per-engine effort (real C++/Rust work) separate from this proposal. Options:
> (a) Invest in per-engine source-phase-imports ports (JSC closest; already has import defer behind a flag; shared work with v8). Multi-week, arguably out of proposal scope.
> (b) Narrow the bar: accept the vm.SourceTextModule semantic harness (9 of 10) as the spec-semantics proof, plus ONE native engine once any ships source-phase imports.
> (c) Keep the bar but treat it as blocked-upstream: pause the native fronts (stop re-spawning daily, since they only re-report the same blocker) until an engine ships the syntax.
>
> My recommendation: (b) or (c). Continuing to spawn native-engine builders daily would burn Opus re-deriving the same blocker. Which do you want, and should the daily press keep pressing the three open Node-checklist shortfalls (error separation, synchronous-eval entry point, base-loader defaults; two need your decision) meanwhile?

- `20260727T191211Z-927bea` — from gardener:proposal-compartments-press-20260727-190507, reply_to `proposal-compartments-press-20260727-190507` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260727T191211Z-927bea.md)

> Compartments daily press (2026-07-27): still awaiting your call on the four-engine native bar (raised 2026-07-26). Nothing new to fix; the effort is stable, not degrading. State today:
>
> - Spec unchanged at d23d7de (minimum operation surface). Rendered spec live (HTTP 200). Explainer current.
> - test262: 10 staged families on kriscendobot/test262 @63b7e7c cover all 6 charter targets. I reconciled the now-stale test262-reconciliation.md with this reality today (journal2).
> - v8 semantic harness re-run today: 9 passed / 0 failed / 1 blocked, exit 0. The 1 blocked family needs native `import defer`.
> - All four native engines still fail at parse on source-phase imports (unimplemented per engine). That is intersection-by-design, not a Compartment disagreement.
>
> The finish-line bar of four-engine native agreement depends on source-phase imports shipping in each engine, a large per-engine effort outside this proposal. Options from 07-26 stand: (a) fund per-engine source-phase ports, (b) narrow the bar to the semantic harness + one native engine (JSC is closest; it already ships import defer behind a flag), or (c) pause native fronts as blocked-upstream. I recommend (b) or (c) so the daily press stops re-deriving the same blocker. No reply needed if you've already seen this; I'll hold at re-verify-and-report until you decide.

- `20260728T065954Z-dce64f` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260728T065954Z-dce64f.md)

> From report `proposal-compartments-v8-validation-20260725`: a spec-annex decision is still open and is yours — whether a **host-only synchronous evaluation operation** is added, to address the charter's non-TLA path shortfall. The native v8 port is otherwise gated on upstream V8 work (source-phase imports + `import.source()`, then `import defer`), so nothing autonomous is waiting on it; only this annex question is actionable now.

- `20260728T113828Z-1c72c2` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260728T113828Z-1c72c2.md)

> Report `issue-kriskowal-garden-67` (issue [https://github.com/kriskowal/garden/issues/67](https://github.com/kriskowal/garden/issues/67), from dckc) proposes two follow-ups, both against Agoric's agoric-sdk (ERC4626/Morpho vault registration for Ymax, cf. [https://github.com/Agoric/agoric-sdk/pull/12767](https://github.com/Agoric/agoric-sdk/pull/12767)): (1) turn design phase 0 — structural shapes plus explicit membership checks against the existing static vault list, no registry, no new authority — into an actual PR on the `kriscendobot/agoric-sdk` fork; (2) drill into the two-phase attestation mechanism against the resolver's existing invitation-based reporting path. Both are outside the autonomous follow-up service's scope (agoric-sdk is excluded from autonomous JOB/SCHEDULE posting), and (1) commits real builder effort on a fork PR. Your call whether to post a builder job for phase 0 and/or a designer job for the attestation drill-down.

- `20260728T122847Z-7914ec` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260728T122847Z-7914ec.md)

> Two follow-ups need your call.
>
> 1. Report `fu-endojs-endo-but-for-bots-pr556-dependabot-3` (endojs/endo-but-for-bots #556, dependabot): items 1, 3, 4, and 5 of the proposal in `inbox/liaison/unread/20260728T073516Z-b2ee8f.md` are still yours to decide — especially item 3, making the step-5 advisory rule directional. Item 2 has landed; items 1 and 4 have partly landed since the proposal was written, so re-read the message before directing them or you'll pay for duplicated work.
>
> 2. Report `fu-fix-identity-drift-guard-test-inbox-leak-3` (garden repo): tightening shellcheck in CI from `-S warning` to `-S info` would surface info-level SC2015/SC2016 across many scripts, and would first require a sweep adding `# shellcheck disable=SC2015,SC2016` headers to the files that lack them. Do you want that sweep + CI tightening scheduled as its own job?

- `20260728T173844Z-cfda47` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260728T173844Z-cfda47.md)

> Report `build-exo-google-sheets-facets` ([endojs/endo-but-for-bots#881](https://github.com/endojs/endo-but-for-bots/issues/881), with #874) flags the design's thin follow-on layers `SheetsService` and `SpreadsheetStructure` as still unbuilt, "a natural next job once #874 and this land." Do you want builder jobs posted for those once both PRs merge, or should they wait?

- `20260728T224921Z-ee1f4e` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260728T224921Z-ee1f4e.md)

> Report `fu-qwen-model-watch-20260728-180502-1-20260728-223502` (weekly Qwen model watch) leaves one decision to you: whether to re-enable the hermit lane on this host — `garden-ollama.service` is installed but disabled because the hermit worker count is 0, and the report also lays out a models-directory option. Both are consequential host/systemd operations outside a watch job's scope, so nothing was changed; say the word (or send a `host/<GARDEN>` sysop op) if you want the lane armed. I have posted a separate job for the unrelated naming discrepancy in the handler messaging, and follow-up 3 needs no action — `journal/schedules/qwen-model-watch.md` has already been refreshed to name no hardcoded model and to explicitly warn off `qwen.ai/blog`.

- `20260729T013334Z-5d108e` — from gardener:ocapn-noise-press-20260729-012002, reply_to `ocapn-noise-press-20260729-012002` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260729T013334Z-5d108e.md)

> OCapN press (dispatch 23): your two review actions tonight both landed.
>
> 1. [endojs/endo-but-for-bots#340](https://github.com/endojs/endo-but-for-bots/issues/340) (approved 00:09Z, all green) — I marked it READY FOR REVIEW (un-drafted). It's the stack bottom; say "merge [endojs/endo-but-for-bots#340](https://github.com/endojs/endo-but-for-bots/issues/340)" if you want a conductor to land it on llm now, and the press will re-target/restack [endojs/endo-but-for-bots#684](https://github.com/endojs/endo-but-for-bots/issues/684) → [endojs/endo-but-for-bots#688](https://github.com/endojs/endo-but-for-bots/issues/688) → [endojs/endo-but-for-bots#693](https://github.com/endojs/endo-but-for-bots/issues/693) as it goes in.
>
> 2. Your "Authorized." on [endojs/endo-but-for-bots#683](https://github.com/endojs/endo-but-for-bots/issues/683)'s demo report (the live-host / security-group line) — executed. Opened tcp/8929 on minion.town's SG (rule sgr-0d9fc044a33568003, self-describing), deployed endo-ocapn-tcp-demo.service (docker, existing image, new ocapn-tcp-server.mjs bind-mounted), and a garden peer completed a live cross-host Noise IK capability round-trip over raw TCP+CBOR — the last unproven transport/topology cell. Cross-host is now proven over BOTH transports (wss via Caddy, and direct TCP). Artifacts + transcript on [endojs/endo-but-for-bots#693](https://github.com/endojs/endo-but-for-bots/issues/693) (commit 803ef977f); evidence: [https://github.com/endojs/endo-but-for-bots/pull/693](https://github.com/endojs/endo-but-for-bots/pull/693)#issuecomment-5111714349. The TCP toy endpoint stays up (like the ws one) for reproducibility; the SG rule stays unless you want it closed after the demo — say the word and I'll revoke it.
>
> Optional next: daemon-level cross-host TCP (boot script currently gates only ws-listen-addr) — cheap to add if you want the full Pet-Daemon pairing over raw TCP too.

- `20260729T014905Z-e6bc8a` — from gardener:endojs-endo-but-for-bots-pr124-feedback-triage, reply_to `endojs-endo-but-for-bots-pr124-feedback-triage` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260729T014905Z-e6bc8a.md)

> Two items from the [endojs/endo-but-for-bots#124](https://github.com/endojs/endo-but-for-bots/issues/124) feedback triage that need a maintainer decision.
>
> 1. **Promote `garden-style-url-not-path`?** kriskowal asked on
> [https://github.com/endojs/endo-but-for-bots/pull/124](https://github.com/endojs/endo-but-for-bots/pull/124)#discussion_r3548837460 for the
> "prefer `new URL(...)` path math over importing node `path`" convention to be recorded
> in the style guide and added to the reviewer pool. The job was posted 2026-07-09 but
> has sat in `plan/` behind a `gate: go-ahead` ever since, so nothing is recorded yet.
> Its sibling from the same review (`garden-style-typist-codepoints`) landed. A go-ahead
> job is only ever promoted by maintainer authorization, so this needs the word.
>
> 2. **Which sense of "the XS sqlite bindings are ready" gates [endojs/endo-but-for-bots#124](https://github.com/endojs/endo-but-for-bots/issues/124)?** The raw host
> bindings (`rust/endo/xsnap/src/powers/sqlite.rs`) landed 2026-05-02, before the pause
> review, so they cannot be the blocker. The durable-store layer on top
> (PRs 811, 819, 690, 825) is still entirely unmerged. Asked on the PR at
> [https://github.com/endojs/endo-but-for-bots/pull/124](https://github.com/endojs/endo-but-for-bots/pull/124)#discussion_r3670370164 . [endojs/endo-but-for-bots#124](https://github.com/endojs/endo-but-for-bots/issues/124)
> stays draft and unrebased until answered.

- `20260729T015927Z-a33a90` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260729T015927Z-a33a90.md)

> Report `endojs-endo-but-for-bots-pr124-feedback-triage` needs your call on which sense of "sqlite bindings ready" gates [endojs/endo-but-for-bots#124](https://github.com/endojs/endo-but-for-bots/issues/124) — that is the only thing blocking its resume trigger. The same report also asks you to promote the parked plan job `garden-style-url-not-path`, which is a go-ahead gate only you can open.

- `20260729T023815Z-67a944` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260729T023815Z-67a944.md)

> endojs/endo-but-for-bots PR #331 ([https://github.com/endojs/endo-but-for-bots/pull/331](https://github.com/endojs/endo-but-for-bots/pull/331)) — report `endojs-endo-but-for-bots-pr331-refresh` follow-up 1: the PR needs a reconciliation pass repositioning it as the credentials/attenuation layer over `@registry`. The offer is already posted on the PR and the gardener is holding for your word. Say go and I'll post the `fix` job; say drop and I'll close it out.

- `20260729T023820Z-8e1c70` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260729T023820Z-8e1c70.md)

> endojs/endo-but-for-bots PRs #403, #563, #671 — report `endojs-endo-but-for-bots-pr331-refresh` follow-up 2: this trio needs a disposition from you (continue, retire, or fold into #331) before any weaver/builder effort is spent on them.

- `20260729T192421Z-4a2428` — from gardener:proposal-compartments-press-20260729-192002, reply_to `proposal-compartments-press-20260729-192002` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260729T192421Z-4a2428.md)

> The remaining design decision is whether the minimal Compartments surface should add a host-only synchronous evaluation operation and a loader-registration surface for synchronous infrastructure errors, or defer both to a later loader layer. Native v8, JSC, XS, and endor remain blocked before semantics on source-phase-import parsing. Please choose the intended boundary.

- `20260730T002912Z-bf496c` — from gardener:endojs-endo-but-for-bots-pr403-ad7046e4, reply_to `endojs-endo-but-for-bots-pr403-ad7046e4` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260730T002912Z-bf496c.md)

> [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/issues/403) retcon done and pushed (head ae0b1a1d4, base unfrozen to llm, CI running). The conduct merge gate needs your fresh APPROVED review on the new head — the 07-29 approval was on the pre-retcon head. Please re-approve at [https://github.com/endojs/endo-but-for-bots/pull/403](https://github.com/endojs/endo-but-for-bots/pull/403) — I am watching and will carry the merge when CI is green and approval lands.

- `20260730T202712Z-72b792` — from gardener:endo-git-integration-press-20260730-082002, reply_to `endo-git-integration-press-20260730-082002` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260730T202712Z-72b792.md)

> # git-integration press — recommend retirement or re-scope
>
> **[endojs/endo-but-for-bots#691](https://github.com/endojs/endo-but-for-bots/issues/691) merged**: the git-capability stack sequencing
> design is accepted and landed, squash-merged at `eb64412d` (2026-07-30T20:26Z)
> onto base `llm`. CI was SUCCESS, mergeState CLEAN, kriskowal APPROVED at the
> rewoven head `840c3a73`.
>
> This closes the arc's tracked items: the M3 north-star loop
> (`designs/daemon-git-next-steps.md`) is fully landed in `llm` —
> [endojs/endo-but-for-bots#706](https://github.com/endojs/endo-but-for-bots/issues/706), [endojs/endo-but-for-bots#645](https://github.com/endojs/endo-but-for-bots/issues/645),
> [endojs/endo-but-for-bots#740](https://github.com/endojs/endo-but-for-bots/issues/740), [endojs/endo-but-for-bots#708](https://github.com/endojs/endo-but-for-bots/issues/708),
> [endojs/endo-but-for-bots#705](https://github.com/endojs/endo-but-for-bots/issues/705), [endojs/endo-but-for-bots#707](https://github.com/endojs/endo-but-for-bots/issues/707) all merged
> (M3 closed 2026-07-29), and now the sequencing design
> [endojs/endo-but-for-bots#691](https://github.com/endojs/endo-but-for-bots/issues/691) that bound them is merged too.
>
> **Recommendation:** retire or re-scope the `endo-git-integration-press`
> schedule (cadence 6h). The only remaining live item is
> **[endojs/endo-but-for-bots#626](https://github.com/endojs/endo-but-for-bots/issues/626)** (Phase-5 stack-surgery eval), deliberately
> DRAFT at `8e29c292`, parked awaiting a maintainer directive — I will keep
> pressing [endojs/endo-but-for-bots#626](https://github.com/endojs/endo-but-for-bots/issues/626) per whatever directive follows. A
> lighter, [endojs/endo-but-for-bots#626](https://github.com/endojs/endo-but-for-bots/issues/626)-only watch cadence (or folding
> [endojs/endo-but-for-bots#626](https://github.com/endojs/endo-but-for-bots/issues/626) into a general `llm` regression watch) would fit
> better than the current M3-arc press body.
>
> Standing by for a directive on [endojs/endo-but-for-bots#626](https://github.com/endojs/endo-but-for-bots/issues/626) or on retiring
> this press.

- `20260730T204103Z-c93651` — from gardener:endo-byte-array-press-20260730-143501, reply_to `endo-byte-array-press-20260730-143501` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260730T204103Z-c93651.md)

> Byte-array press: real-execution evidence now confirms [https://github.com/endojs/endo-but-for-bots/pull/475](https://github.com/endojs/endo-but-for-bots/pull/475) is the complete green implementation. Checked out `feat/narrow-bytearray-to-uint8` (warm-cache checkout, node-tool-shims installed) and ran the byte-array-critical suites: @endo/pass-style 59 passed (all 25 byteArray admission cases), @endo/bytes 25 passed (emulated-input rejection + shim-order), @endo/marshal 92 passed + 1 skipped (shortlex byteArray rank + encodePassable round-trips), @endo/captp 11 passed (loopback parity). `llm` still throws `encodePassable(byteArray) not yet implemented`; [https://github.com/endojs/endo-but-for-bots/pull/475](https://github.com/endojs/endo-but-for-bots/pull/475) lands it as `a<length>:<hex>`.
>
> Two gates remain, both reviewer-side and both stale: [https://github.com/endojs/endo-but-for-bots/pull/475](https://github.com/endojs/endo-but-for-bots/pull/475) (13 days, all 12 unresolved threads answered, head `1b1dc75ba9`) needs a re-review/merge decision; [https://github.com/endojs/endo-but-for-bots/pull/503](https://github.com/endojs/endo-but-for-bots/pull/503) (10 days, obsolete bare-buffer approach) needs a disposition (close-as-superseded-by-[https://github.com/endojs/endo-but-for-bots/pull/475](https://github.com/endojs/endo-but-for-bots/pull/475) vs narrow). Separately, the registry follow-up advanced: [https://github.com/endojs/endo-but-for-bots/pull/671](https://github.com/endojs/endo-but-for-bots/pull/671) merged, [https://github.com/endojs/endo-but-for-bots/pull/888](https://github.com/endojs/endo-but-for-bots/pull/888) is DRAFT and its gauntlet panel is queued.
>
> No code changes or pushes made — a retarget of [https://github.com/endojs/endo-but-for-bots/pull/475](https://github.com/endojs/endo-but-for-bots/pull/475) to `llm` is a 2437-commit rebase that would invalidate the pending re-review state, so I left it for a maintainer call.

- `20260730T204740Z-5bf711` — from gardener:endo-git-integration-press-20260730-143501, reply_to `endo-git-integration-press-20260730-143501` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260730T204740Z-5bf711.md)

> [endojs/endo-but-for-bots#691](https://github.com/endojs/endo-but-for-bots/issues/691) has merged — git-integration arc tracked items are done
>
> PR [endojs/endo-but-for-bots#691](https://github.com/endojs/endo-but-for-bots/issues/691) (design: accept and sequence the git-capability stack for the version-controlled-filesystem loop, M3) merged 2026-07-30T20:26:28Z:
> - merge commit: eb64412d763a42d3905c0174f496b012464a62fe
> - head: 840c3a73e (design/git-capability-stack-sequencing)
> - merged by: kriscendobot
> - CI: all checks SUCCESS (browser-tests, lint, build, zizmor, test) on the merged head
> - mergeState: CLEAN; zero unresolved threads
>
> With [endojs/endo-but-for-bots#691](https://github.com/endojs/endo-but-for-bots/issues/691) merged, the arc's tracked items are complete: the M3 north-star loop is fully landed in `llm` ([endojs/endo-but-for-bots#706](https://github.com/endojs/endo-but-for-bots/issues/706), [endojs/endo-but-for-bots#645](https://github.com/endojs/endo-but-for-bots/issues/645), [endojs/endo-but-for-bots#740](https://github.com/endojs/endo-but-for-bots/issues/740), [endojs/endo-but-for-bots#708](https://github.com/endojs/endo-but-for-bots/issues/708), [endojs/endo-but-for-bots#705](https://github.com/endojs/endo-but-for-bots/issues/705), [endojs/endo-but-for-bots#707](https://github.com/endojs/endo-but-for-bots/issues/707), and now [endojs/endo-but-for-bots#691](https://github.com/endojs/endo-but-for-bots/issues/691) the sequencing design). The only remaining tracked item is [endojs/endo-but-for-bots#626](https://github.com/endojs/endo-but-for-bots/issues/626) (Phase-5 stack-surgery eval), which is deliberately DRAFT at 8e29c292 and stays parked pending a maintainer directive — no change there.
>
> Recommendation: retire or re-scope this standing press (schedule `schedules/endo-git-integration-press`). The gating-driven standing-watch is no longer needed now that [endojs/endo-but-for-bots#691](https://github.com/endojs/endo-but-for-bots/issues/691) is merged; the only live item ([endojs/endo-but-for-bots#626](https://github.com/endojs/endo-but-for-bots/issues/626)) is a parked draft awaiting an explicit directive, not an actively-pressed loop. If you'd like continued low-rate guarding of [endojs/endo-but-for-bots#626](https://github.com/endojs/endo-but-for-bots/issues/626) plus the llm git-capability surface for regressions, re-scope the press to that narrower watch; otherwise retire it and reopen a fresh job when [endojs/endo-but-for-bots#626](https://github.com/endojs/endo-but-for-bots/issues/626) is to be promoted or post-M3 work (e.g. endor CAS bindings implementation per the merged [endojs/endo-but-for-bots#740](https://github.com/endojs/endo-but-for-bots/issues/740) design) is directed.
>
> Standing by on [endojs/endo-but-for-bots#626](https://github.com/endojs/endo-but-for-bots/issues/626) per whatever directive follows.

- `20260730T211305Z-dda1ac` — from gardener:endojs-endo-but-for-bots-pr241-review-b15e4ef6, reply_to `endojs-endo-but-for-bots-pr241-review-b15e4ef6` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260730T211305Z-dda1ac.md)

> endojs/endo-but-for-bots PR `endojs/endo-but-for-bots#241`, review `4803410792` — conduct step blocked: no maintainer APPROVED review on current head.
>
> Status:
> - Integration DONE. A peer (kriscendobot) integrated all five of your inline answers into the design doc in head commit `ac71c0424b` ("docs(design): resolve familiar VFS open questions"). The resolved open-questions section now records decisions 1-5 verbatim from your inline replies (package.json as go.mod analogue / compartment-map cached by content address; per-daemon module store; Case 2 preserves multi-major semantics; peer/optional dep policy confirmed; re-eject equality is content-hash).
> - Un-draft DONE. The PR is already not a draft (isDraft=false).
> - CI GREEN. All 7 checks SUCCESS on `ac71c0424b`; mergeStateStatus=CLEAN; base is live `llm` (no frozen snapshot); no downstream PR sits on the head branch.
> - Merge BLOCKED. The conductor merge spine refuses: no current APPROVED maintainer review on head `ac71c0424b`. Your review `4803410792` is COMMENTED (the directive itself), not APPROVED, so the deterministic maintainer-approval gate rejects it. The bot cannot self-approve.
>
> To unblock: submit an APPROVED review on `endojs/endo-but-for-bots#241` against head `ac71c0424b`. The next conductor tick (or a re-dispatch of this job) will then merge it via `gh pr merge --merge`. Reply here and the next tick will pick it up.

- `20260730T211653Z-996985` — from gardener:endojs-endo-but-for-bots-pr403-ad7046e4, reply_to `endojs-endo-but-for-bots-pr403-ad7046e4` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260730T211653Z-996985.md)

> Retcon + conduct status for [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/issues/403).
>
> Retcon (verified): all 27 commit messages on `feat/registry-capability` are free of any PR-403 reference (subjects and bodies). This was landed by a prior run of this job (PR comment id=5124816986); I re-verified the current branch HEAD `602b034b78` end-to-end — zero matches. Tree is intact; CI is fully green (all checks SUCCESS), merge state CLEAN.
>
> Conduct — blocked on your re-approval. The merge gate (pr-maintainer-approval-gh.sh) requires an APPROVED review whose commit_id is the current head. The only APPROVED on file is yours on `051baffb9e` (2026-07-29), which is the pre-retcon head — stale. The head has since moved to `602b034b78` (one post-retcon fix on top of the retcon tip `ae0b1a1d`).
>
> Could you re-approve on the current head `602b034b78`? Once that lands I'll carry the merge to completion. Nothing else is gating — CI is clean and the base is unfrozen onto `llm`.

- `20260801T054230Z-416fa8` — from gardener:build-endo-regexp-conservative-subset, reply_to `build-endo-regexp-conservative-subset` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260801T054230Z-416fa8.md)

> Self-improvement: pre-push-gates SKILL.md names scripts/jobs/gardening/pre-push-gates.sh, but that driver is absent; only probe scripts exist. Local verification passed, and I ran package lint/tests plus the Rust corpus test directly. Please repair or relocate the advertised driver so builders can run the required gate.

- `20260801T092701Z-6b0b1f` — from gardener:endo-byte-array-press-20260801-090502, reply_to `endo-byte-array-press-20260801-090502` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260801T092701Z-6b0b1f.md)

> byteArray press — 2026-08-01 observation (no wheel taken; everything green + awaiting human re-review)
>
> Finish-line component 1 — byteArray = frozen Uint8Array view (design [endojs/endo-but-for-bots#572](https://github.com/endojs/endo-but-for-bots/issues/572)):
>   • [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/issues/503) (base master-a7ff191): immutable-arraybuffer shim (freezable TypedArray emulation) + pass-style byteArray brand. All CI green, MERGEABLE/CLEAN. Only 2 unresolved threads, both OUTDATED/trivial.
>   • [endojs/endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/issues/475) (base master-2708cac): narrows byteArray to a plain frozen Uint8Array view + @endo/bytes helpers (shortlex compare, genuine-Uint8Array detection, hex codecs). All CI green (Node 22/24, XS, test262, hermes, guile), MERGEABLE/CLEAN. All 5 current review threads have fixes/answers pushed (genuine-Uint8Array rejection fixed 4f5192232; shim init-order test added 1b6df4a9b; shortlex confirmed w/ upstream evidence; version-bump moved to [endojs/endo-but-for-bots#584](https://github.com/endojs/endo-but-for-bots/issues/584); lexical-vs-shortlex resolved — erights "that makes sense to me, thanks").
>   → These two are complementary layers (shared .changeset/freezable-typedarray-emulation.md), NOT competing: the view redesign REFINES, does not replace, the immutable-arraybuffer emulation (the shim is still the substrate; XS needs it). Blocker is purely maintainer RE-REVIEW to clear CHANGES_REQUESTED — no agent-actionable code left.
>
> Finish-line component 2 — RegistryInterface.resolve → immutable bytes:
>   • [endojs/endo-but-for-bots#888](https://github.com/endojs/endo-but-for-bots/issues/888) (base llm-bfc91f5, DRAFT): auto-promoted after [endojs/endo-but-for-bots#671](https://github.com/endojs/endo-but-for-bots/issues/671) merged 07-29. Accepts immutable UTF-8 package-JSON bytes, hex-backed CapData across the CapTP boundary, host-side conversion back to mutable bytes. All CI green, MERGEABLE/CLEAN, no review yet.
>
> Net: the whole byteArray program is complete-and-green and gated on human re-review ([endojs/endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/issues/475) + [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/issues/503)) and finish-line un-draft/review ([endojs/endo-but-for-bots#888](https://github.com/endojs/endo-but-for-bots/issues/888)). Follow-up when you're ready to land: those two sit on frozen snapshot bases and will need a restack onto current llm as part of the landing sequence. Nothing stalled in code; leaving PRs as-is per DRAFT-until-finish-line policy.

- `20260801T104125Z-f4eda2` — from gardener:kriscendobot-endo-but-for-bots-pr3-rebase, reply_to `kriscendobot-endo-but-for-bots-pr3-rebase` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260801T104125Z-f4eda2.md)

> weaver on [https://github.com/kriscendobot/endo-but-for-bots/pull/3](https://github.com/kriscendobot/endo-but-for-bots/pull/3) (rebase job): the
> stale-base refresh cannot be a clean weaver rebase. The mount stack premise no longer
> holds on current llm, so I did NOT force it. The PR is untouched (no push, no base change).
>
> What the PR actually contains over its frozen base llm-b377b0e (net diff):
>   1. packages/regexp -- the RFC 9485 conservative profile (the PR's real title/intent),
>      self-contained.
>   2. rust/mount_parity -- a Rust crate carried in by a `stack: merge` merge commit.
>      This is [https://github.com/endojs/endo-but-for-bots/pull/654](https://github.com/endojs/endo-but-for-bots/pull/654) 's deliverable
>      (the mount glob/grep parity runner), stack baggage, not the regexp PR's own work.
> The merge discarded the daemon-side [https://github.com/endojs/endo-but-for-bots/pull/127](https://github.com/endojs/endo-but-for-bots/pull/127)
> changes (net packages/daemon == base), so only the rust crate + Cargo/yarn.lock survive
> into the net diff.
>
> Why a refresh onto current llm (67dfc18) breaks:
>   - The crate's tests read case tables via contract_dir() = ../../packages/daemon/test.
>     On llm those fixtures MOVED to packages/platform/test (mount-glob-cases.json,
>     mount-grep-cases.json, mount-fixture-manifest.json). The old daemon/test path is gone,
>     so mount_glob_parity.rs / mount_grep_parity.rs would not find their fixtures.
>   - packages/daemon has no EndoMount.glob() in llm; the mount glob/grep feature relocated
>     to a `platform` package.
>   - Dependency PRs are stale: [https://github.com/endojs/endo-but-for-bots/pull/127](https://github.com/endojs/endo-but-for-bots/pull/127) (the
>     daemon mount glob/grep feature) is CLOSED-not-merged;
>     [https://github.com/endojs/endo-but-for-bots/pull/654](https://github.com/endojs/endo-but-for-bots/pull/654) (the rust parity runner) is still
>     OPEN, stranded on the closed 127 branch.
>   - Even repointing contract_dir to packages/platform/test would not be safe: llm's
>     mount-grep-cases.json has DIVERGED from what the crate was written against, so grep
>     parity could fail against the Rust mirror. (mount-glob and the fixture manifest are
>     still byte-identical; only grep evolved.)
>
> Entanglement note: the regexp Rust parity test lives INSIDE the mount_parity crate
> (rust/mount_parity/tests/i_regexp_profile_parity.rs plus regexp_contract_dir() and the
> validator added to rust/mount_parity/src/lib.rs), so the regexp and mount work cannot be
> split by a mechanical rebase.
>
> This is a fixer/scope decision, not a weaver one. Two paths:
>   A. Treat the PR as regexp-only (matches its title). A fixer drops the mount_parity
>      crate from the branch, moving the regexp Rust parity into its own crate (or dropping
>      the Rust parity and keeping the JS package + JS parity), and lets
>      [https://github.com/endojs/endo-but-for-bots/pull/654](https://github.com/endojs/endo-but-for-bots/pull/654) pursue its own rebase for the
>      mount runner. Cleanest if the mount runner is not meant to ride in the regexp PR.
>   B. Keep the mount_parity crate in the PR. A fixer repoints contract_dir to
>      packages/platform/test AND reconciles the Rust glob/grep mirror against llm's evolved
>      mount-grep-cases.json. Substantive, and duplicates the 654 content into the regexp PR.
>
> Recommendation: A. The PR is titled "feat(regexp): add RFC 9485 conservative profile"; the
> mount runner is a separate PR's job. But the split is your call. Say the word and I will
> post a fixer job for the chosen path.
>
> (The originally-reported lint failure on packages/reminder/test/plugin.test.js does clear
> for free on any refresh -- llm deleted that file -- but the mount staleness blocks the
> refresh, so the lint fix rides along with whichever fixer path you pick.)

- `20260801T105902Z-37e161` — from gardener:minion-town-mcp-b5-retire-toy-tools, reply_to `minion-town-mcp-b5-retire-toy-tools` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260801T105902Z-37e161.md)

> B5 (retire toy MCP tools) — code done + locally green; deployed-edge validation needs your go-ahead.
>
> STATE
> - Code lives on PR [kriscendobot/minion.town#20](https://github.com/kriscendobot/minion.town/issues/20) (feat/endo-daemon-guest-mcp-b5, @fa8667f), stacked on B4 [kriscendobot/minion.town#19](https://github.com/kriscendobot/minion.town/issues/19) (OPEN) → B3 [kriscendobot/minion.town#18](https://github.com/kriscendobot/minion.town/issues/18) (still DRAFT). I reviewed it against designs/mcp-daemon-guest-tools.md §7 B5: toy tools + Map + TOOL_SCOPES + MINIONS_* scopes deleted; guest tools mount unconditionally with a clean daemon-unavailable error; scopes trimmed to `mcp/tools mcp/guest`; README/DEPLOYMENT updated; deploy-cognito-guest-scope.sh added. Complete.
> - Local validation THIS run: typecheck ok, build ok, `npm test` 135 passed / 3 skipped. (Prior PR-body's SIWE-blocked note no longer applies.)
>
> BLOCKER — the job's required "deployed-edge" validation (`tools/list` shows only guest_*, then E1-E4 green) cannot be done without production actions I won't take unilaterally:
> 1) B5 isn't deployed. Deployed edge still advertises mcp/minions:read/write (PRM + Cognito resource server). Making tools/list guest-only requires deploying the B3->B4->B5 stack to the box (SSM to /opt/minion-town, same path B3/B4 got there) AND running deploy-cognito-guest-scope.sh — a change to the live service, with B3 still DRAFT.
> 2) E1-E4 needs a REAL Cognito user token (Gate-1). The repo PKCE client only auto-approves against the local mock AS; real Cognito needs browser login or an admin-minted token.
>
> ASK: how do you want to close out B5's deployed-edge validation?
>  (a) Authorize me to SSM-deploy the stack to the box + run the Cognito scope cleanup, and either you provide a real Cognito token or authorize me to admin-mint one from a test user — then I run tools/list + E1-E4 and report evidence; or
>  (b) you'll deploy/validate at the edge yourself (you can also run Gate-1); or
>  (c) merge the stack first (B3 is draft) so CD deploys it, then validate.
>
> I've left the same summary as a comment on PR [kriscendobot/minion.town#20](https://github.com/kriscendobot/minion.town/issues/20). Holding here pending your call.

- `20260801T110926Z-9f7599` — from gardener:minion-town-mcp-b5-retire-toy-tools, reply_to `minion-town-mcp-b5-retire-toy-tools` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260801T110926Z-9f7599.md)

> Closing out the B5 builder instance (not actively holding a worker anymore — the reaper kept requeuing it against a human gate, and the board has no park slot for a claimed job).
>
> Where B5 stands: code complete + locally green on PR [kriscendobot/minion.town#20](https://github.com/kriscendobot/minion.town/issues/20); the required deployed-edge validation is NOT done and is waiting on YOUR call (deploying the still-DRAFT B3->B4->B5 stack to the live 5-tenant box, plus federated user tokens / Gate-1 for E1-E4, plus live daemon restart (E3) and account suspension (E4) — none of which I'll do to production unilaterally).
>
> No action from me is pending. When you want it finished, pick a path from my earlier message (a: authorize me to SSM-deploy + mint/hand a token and I run tools/list + E1-E4; b: you validate at the edge; c: merge the stack so CD deploys, then validate) and re-post/promote the B5 job — a gardener will pick it up and run the deployed-edge sweep.

- `20260801T150643Z-3c16e0` — from gardener:endo-git-integration-press-20260801-150502, reply_to `endo-git-integration-press-20260801-150502` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260801T150643Z-3c16e0.md)

> git-integration press — arc complete, recommend RETIRE (or re-scope).
>
> **[endojs/endo-but-for-bots#691](https://github.com/endojs/endo-but-for-bots/issues/691) MERGED** 2026-07-30T20:26:28Z into `llm` (merge commit eb64412d763a42d3905c0174f496b012464a62fe): "design: accept and sequence the git-capability stack for the version-controlled-filesystem loop (M3)". That was the last OPEN tracked item awaiting your acceptance.
>
> State of the two live items now:
> - **[endojs/endo-but-for-bots#691](https://github.com/endojs/endo-but-for-bots/issues/691)**: MERGED — done.
> - **[endojs/endo-but-for-bots#626](https://github.com/endojs/endo-but-for-bots/issues/626)** (Phase-5 stack-surgery eval): still OPEN + DRAFT at unchanged head 8e29c292, all-green as of 2026-07-21. Held draft by design; no promote/re-weave/merge without your directive. A MOOT parked weave copy stays parked at jobs/plan/weave-endo-but-for-bots-pr626-stack-surgery-eval (never to be promoted).
>
> With [endojs/endo-but-for-bots#691](https://github.com/endojs/endo-but-for-bots/issues/691) merged, every TRACKED item of the git-integration arc (M3 closed 2026-07-29; [endojs/endo-but-for-bots#706](https://github.com/endojs/endo-but-for-bots/issues/706), [endojs/endo-but-for-bots#645](https://github.com/endojs/endo-but-for-bots/issues/645), [endojs/endo-but-for-bots#740](https://github.com/endojs/endo-but-for-bots/issues/740), [endojs/endo-but-for-bots#708](https://github.com/endojs/endo-but-for-bots/issues/708), [endojs/endo-but-for-bots#705](https://github.com/endojs/endo-but-for-bots/issues/705), [endojs/endo-but-for-bots#707](https://github.com/endojs/endo-but-for-bots/issues/707) all merged) is resolved. The only remaining thread is [endojs/endo-but-for-bots#626](https://github.com/endojs/endo-but-for-bots/issues/626), a deliberate parked draft, not active work.
>
> **Recommendation: retire this press** — remove/disable the recurring schedule `schedules/endo-git-integration-press`. Its 6h dispatches will now be pure no-ops (or a single draft check), which just burns quota.
>
> If instead you want a standing watcher kept alive, **re-scope** it: narrow it to (a) guarding [endojs/endo-but-for-bots#626](https://github.com/endojs/endo-but-for-bots/issues/626)'s draft until you give a promote/merge directive, and/or (b) watching for post-M3 work (e.g. endor CAS bindings implementation — [endojs/endo-but-for-bots#740](https://github.com/endojs/endo-but-for-bots/issues/740) design merged, implement only on explicit directive). Say which and I'll adjust the schedule body accordingly.
>
> Standing by; no further action taken this dispatch beyond this one recommendation.

- `20260801T151122Z-4dee07` — from gardener:finbot-progress-20260801-150502, reply_to `finbot-progress-20260801-150502` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260801T151122Z-4dee07.md)

> finbot progress cycle (15:05 dispatch) — one increment advanced, two pipeline decisions for you.
>
> STATE: [kriscendobot/finbot#4](https://github.com/kriscendobot/finbot/issues/4) (SES compartments) merged 10:00Z — first increment under two-gate governance. Three PRs remain open, all CLEAN/MERGEABLE, none in flight (board was idle for finbot).
>
> ADVANCED THIS CYCLE — [kriscendobot/finbot#6](https://github.com/kriscendobot/finbot/issues/6) (forecast data-sufficiency, the security-hardened gate):
> Its fixer round 2 (finbot-pr6-fix-panel-r2) landed a green head 76bffd4 (DRAFT), clearing the prior panel's must-fix bundle. Per governance the fixer must not self-merge and a full panel re-run is required before sign-off — nothing was on the board for it. I posted finbot-pr6-panel-r3-20260801 (role: builder, tier: mentor, no model pin) targeting 76bffd4 / base main b06cdacf. On a clean pass it posts finbot-pr6-signoff (role: orchestrator, tier: mentor, no pin) then merge. This is the deepest unblocked increment; the pipeline is congested so I opened no 4th PR.
>
> DECISIONS NEEDED:
> 1. [kriscendobot/finbot#5](https://github.com/kriscendobot/finbot/issues/5) (OBSERVE inference dispatch) is STUCK. Its current-head panel finbot-pr5-panel-20260801 (head c1427a66, unchanged) was POISONED via requeue-exhaustion (5 claim-and-die cycles, 0 deadline overruns, poisoned 11:33Z) and now sits inert in jobs/plan/. Its panels complete fine at older heads, so this is undiagnosed worker death on the current-head panel — re-posting the identical job would likely re-poison. Recommend: investigate why workers die on this specific panel (transient 11:33Z outage? a seat crashing the run?) before re-issuing, or authorize a fresh re-post if you judge it transient.
> 2. [kriscendobot/finbot#7](https://github.com/kriscendobot/finbot/issues/7) (docs harness README worker-drift) is a NEW doc-only, non-draft PR (created 10:07Z, reflects the merged compartment work). It has NO governance job on the board. Does a doc-drift PR take the full 28-seat merge-governance panel plus orchestrator sign-off like a code increment, or do you want a lighter path (e.g. orchestrator sign-off only) for doc-only changes? I did not post a job pending your call.
>
> HYGIENE: jobs/plan/finbot-pr4-panel-rerun-20260725 is fully obsolete ([kriscendobot/finbot#4](https://github.com/kriscendobot/finbot/issues/4) merged) — recommend dropping so it can't race. (Flagged in prior cycles too; still parked.)

- `20260803T024348Z-ebba81` — from gardener:garden-budget-omega, reply_to `garden-budget-omega` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260803T024348Z-ebba81.md)

> Budget 5/5 (omega) — one grounding question before this design can be acted on.
>
> You asked me to "look at what Josh Corbin's Unum is doing to classify tasks by
> their omega notation ... the task's rank in a tree of plans." I read all 15
> `library/sections/unum--*` sections, grepped the whole library, and fetched the
> live unum repo overview + a web search. **No omega notation, task-rank scheme, or
> "tree of plans" ranking exists in anything I can reach.** The ingested unum
> material is pinned to early-July commits (per-persona-model-tiers, vigil-charge,
> claim-lifecycle, the cost ledger) and predates whatever you saw. The only `omega`
> hits in the garden are econometrics (Diebold-Mariano, HAR-RV).
>
> So I have written the design with a *reconstructed* interpretation, clearly
> labelled as MINE and provisional — omega as a lower-bound rank = depth in a plan
> tree; lowest rank (leaves) worked first; a task too big for its time window
> creates a plan and promotes its own rank (which the garden's orchestration jobs
> already half-implement). I did NOT invent priorities or reorder anything.
>
> Two asks for @jcorbin (on the maintainers allowlist), whenever convenient — an
> unanswered question is fine, I have flagged the gap in the design rather than
> guessing:
>
> 1. Point me at unum's actual omega/rank definition (a PLAN/ or LORE/ doc, or a
>    commit) so I can ground the scheme instead of reconstructing it.
> 2. Confirm or correct the reconstruction: is "lowest omega" the leaf (do-first)
>    or the root, and is "promote itself in the tree" the same move as the garden
>    posting an orchestration job with parked children?
>
> Design landed at `designs/omega-task-rank-and-foreman-retirement.md` (Status:
> Proposed, changes no dispatch behavior). No rush.

- `20260804T052828Z-2bba29` — from gardener:review-retrospective-consolidated-20260804, reply_to `review-retrospective-consolidated-20260804` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260804T052828Z-2bba29.md)

> Consolidated review-retrospective pass (85 events) — done. Two escalations that
> need your eyes, both about improvements that already shipped yet recurred:
>
> 1. RECURRENCE — cluster `inline-import-jsdoc` (was closed). The no-inline-import-jsdoc
>    gate + typist backstop landed on main2 2026-07-16 (0c569a64e4 / d0da42892a). Yet on
>    [endojs/endo-but-for-bots#792](https://github.com/endojs/endo-but-for-bots/issues/792) (review 2026-07-22) you wrote "Prefer @import. Should
>    have been caught in review." The writer flagged recurrence=1 and reopened the cluster.
>    CAVEAT: 07-22 is only days after the 07-16 commit, so the fleet may not have DEPLOYED
>    the fix when that PR's code was authored (a deploy-lag artifact, not a true failure of
>    the gate). I did NOT auto-start a second improvement round. If it predates the deploy,
>    no action; if not, the gate/probe is under-covering @import in some tag position.
>
> 2. GATE UNDER-COVERAGE — cluster `avoid-name-abbreviations`. The deterministic
>    spell-out-identifiers pre-push gate landed 2026-07-11 (aa2da527e5), but two later
>    PRs still drew abbreviation asks: [endojs/endo-but-for-bots#806](https://github.com/endojs/endo-but-for-bots/issues/806) (07-22, network.js) and
>    [endojs/endo-but-for-bots#684](https://github.com/endojs/endo-but-for-bots/issues/684) (07-29, "Addr is Address" in a test file). The cluster was
>    never marked `closed`, so no auto-recurrence fired. Likely gaps: the probe skips test
>    files, or its dictionary misses `Addr`. Recommend widening the spell-out-identifiers
>    probe scope+dictionary (a builder job).
>
> Landed this pass (main2 37b04ec909): prefer-@endo-primitives and
> capability-hardening-attenuation review checks (builder directives + purist/locksmith
> seats). Dispatched: review-improve-merge-base-pinning (deferred builder). Full report in
> the job completion.

- `20260805T150507Z-ee18e7` — from gardener:minion-town-ocapn-runahead-pin, reply_to `minion-town-ocapn-runahead-pin` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260805T150507Z-ee18e7.md)

> OCapN run-ahead blocker: I opened endojs/endo-but-for-bots branch minion-town at current llm f8c1ca6a63319ec7051a61105bc6188681f1681e, then verified the unpublished API cannot meet design section 6 as written. makeOcapn hard-codes export slot 0 to its own Bootstrap fetch/deposit-gift/withdraw-gift object; it has no option for the weblet granted-powers object, so the remote bootstrap method surface cannot equal the granted powers. The demo proves locator.fetch(secret), not direct powers bootstrap. Per the job stop condition I am stopping rather than pinning a misleading implementation; PR 24 remains unchanged.

- `20260805T153923Z-75062e` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260805T153923Z-75062e.md)

> The 2026-08-04 consolidated review retrospective (`review-retrospective-consolidated-20260804`) names its highest-leverage fix as narrowing `retro_eligible` in `scripts/jobs/comment-watcher.sh`, so that a `review`/`attention` comment whose only actionable content is a pipeline-op verb (conduct/rebase/shepherd/retcon/weave/merge/close), or an empty-body approval with zero inline comments, mints **no** retrospective — cutting the ~85% dismissal flood at its source. The retrospective explicitly declined to act because it reverses your deliberate err-toward-minting choice and edits the comment-watcher's tested hot path. Do you want a builder job posted to narrow the gate as described, or should the watcher keep erring toward minting?

- `20260805T161438Z-4980a4` — from gardener:dependabotany-recheck-endo-but-for-bots-20260805-160502, reply_to `dependabotany-recheck-endo-but-for-bots-20260805-160502` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260805T161438Z-4980a4.md)

> Daily dependabotany backstop for endojs/endo-but-for-bots — one action needed + one operational flag.
>
> TERMINAL MERGE-NOW, waiting only on your approval (embargo matured, CI 24/24 green, migration disclosed):
>   • [endojs/endo-but-for-bots#868](https://github.com/endojs/endo-but-for-bots/issues/868)  eslint-plugin-unicorn 56.0.1 → 72.0.0  (verdict comment: [https://github.com/endojs/endo-but-for-bots/pull/868](https://github.com/endojs/endo-but-for-bots/pull/868)#issuecomment-5194294557)
> Also still queued behind an approval from prior runs: [endojs/endo-but-for-bots#867](https://github.com/endojs/endo-but-for-bots/issues/867) (@noble/curves), [endojs/endo-but-for-bots#915](https://github.com/endojs/endo-but-for-bots/issues/915) (setup-python), [endojs/endo-but-for-bots#916](https://github.com/endojs/endo-but-for-bots/issues/916) (action-gh-release). Each is green + mergeable; the conductor's approval gate is holding all four. An APPROVED review on any head lets it conduct onto `llm` automatically.
>
> OPERATIONAL FLAG: both dependabotany recheck schedules are currently in `paused-schedules/` — the daily backstop (last dispatched 2026-08-01) and [endojs/endo-but-for-bots#868](https://github.com/endojs/endo-but-for-bots/issues/868)'s precise one-shot (was due 2026-08-02T17:15Z, never fired). This sweep ran manually and caught [endojs/endo-but-for-bots#868](https://github.com/endojs/endo-but-for-bots/issues/868), but if the pause was unintended the rechecks are not firing on cadence. The embargoed set is now empty, so no recheck is currently owed regardless.

- `20260806T060842Z-ad8879` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260806T060842Z-ad8879.md)

> Report `xs2rust-endor-debugger-caught-vs-uncaught` (researcher, endojs/endo-but-for-bots, PR [https://github.com/endojs/endo-but-for-bots/pull/600](https://github.com/endojs/endo-but-for-bots/pull/600)) found that the debugger row it was briefed against is no longer on the `xs2rust-endor` branch, and names "recover the debugger row onto PR 600" as blocking its other three follow-ups: (2) `setExceptionBreakMode('uncaught')` is a live silent no-op, (3) Ironhorse's engine-raised errors do not unwind through the jump chain, (4) three `BreakpointTable` parity nits (missing `line == 0 && id == 0` guard, un-ported `start` pseudo-breakpoint, a doc reference to a nonexistent `"unhandled"` pseudo-breakpoint). I am not posting recovery or fix jobs: re-landing a row of work that left the branch for unknown reasons is your call, not the fleet's, and fixes 2–4 target code that is not currently on PR 600, so they would be posted against absent files. Decide whether the debugger row should be recovered onto PR 600 (and by whom — weaver vs. a fresh builder slice); once it is back, 2–4 can be posted as ordinary fixer jobs.

- `20260806T065203Z-f98dfe` — from gardener:minion-town-pr21-a96e97d-design-land, reply_to `minion-town-pr21-a96e97d-design-land` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260806T065203Z-f98dfe.md)

> Weblet-gateway design PR [kriscendobot/minion.town#21](https://github.com/kriscendobot/minion.town/issues/21) — reconciled + gauntleted, deliberately LEFT DRAFT.
>
> On resume I found the branch had advanced past my earlier session (while this
> job was being reaper-doomed): the namespace was corrected to *.weblet.minion.town
> ([kriscendobot/minion.town#25](https://github.com/kriscendobot/minion.town/issues/25)), and Increments 2 and 3 landed
> ([kriscendobot/minion.town#23](https://github.com/kriscendobot/minion.town/issues/23) / [kriscendobot/minion.town#24](https://github.com/kriscendobot/minion.town/issues/24), armed by
> [kriscendobot/minion.town#26](https://github.com/kriscendobot/minion.town/issues/26)). I rebased on current main and ran the design panel
> end to end (9 fix-loop rounds).
>
> Reconciliation + review done (all on the branch):
> - Corrected the id/record model to MATCH SHIPPED CODE. An earlier round of mine
>   had reworked it toward a value-oriented model (record={id,owner}, powers-in-id,
>   formula-deref) — that was BACKWARDS. Shipped reality: id = sha-256(contentRoot)
>   (content only, powers NOT in the id), record stores {id,contentRoot,powers,owner},
>   powers-plane reads record.powers. Fixed throughout.
> - Reconciled the retired seed mechanism (GATEWAY_SEED_WEBLETS/seed.env → the CAS
>   store + seed-weblet-fixture.sh), added As-built notes for Inc 2/3, and recorded
>   the preconditions those increments SKIPPED (control-port split, __Host- rename,
>   browser CORS check, canonicity gate) — re-collected into a new pre-publish
>   hardening increment "H" that gates publish, restoring the halt policy's meaning.
> - Surfaced and closed a real SECURITY hole the content-only id exposes: an attacker
>   can pre-publish content a victim will publish and bind attacker powers to it
>   (fixed: collision is clean owned:false only when EFFECTIVE powers agree, else
>   content-collision reject), and post-unpublish re-registration transfers powers
>   behind cached bytes (fixed: unpublish tombstones the id).
>
> Why I did NOT un-draft it: the design is functioning as a LIVING DOCUMENT — it is
> reconciled in place on the draft branch after each increment merges (Inc 1/2/3 all
> landed against it while it stayed draft; Inc 4 + H remain spec-only). Per the job's
> instruction for exactly this case, I left the rebase + reconciliation commits on the
> branch and did not merge.
>
> ONE DECISION NEEDS YOU (open question 7, now the sharpest call and a publish gate):
> keep the shipped content-only id (id = sha-256(contentRoot)) — which REQUIRES the
> collision rule + the unpublish tombstone above as security machinery — OR adopt a
> composite id = digest(contentRoot, powers), which dissolves both by separating the
> origins. This is a genuine identity-modeling call, not something I should decide.
>
> Branch head: design/weblet-gateway (pushed). Panel state: converging on prose polish
> + this OQ7 decision; not driven to a formal "pass" because the residual is your call.

- `20260806T065908Z-b00670` — from gardener:endojs-endo-but-for-bots-pr877-finalize, reply_to `endojs-endo-but-for-bots-pr877-finalize` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260806T065908Z-b00670.md)

> Conductor for [endojs/endo-but-for-bots#877](https://github.com/endojs/endo-but-for-bots/issues/877) (feat/endor-npm-dual-build-execution → llm).
>
> Status: un-drafted, OPEN, MERGEABLE, CI in flight. NOT merged — blocked on re-approval.
>
> Why: the blocking rebase job (pr877-rebase) resolved the base conflict and force-pushed a new head `c48a7d83d` at 06:49Z, AFTER kriskowal's APPROVED review (06:31Z, on commit `58bdaa60f`). The rebase changed the tree (conflict resolution preserving base dependency-edge / shared-endowment / bundle-doc changes alongside the PR's self-reference + text-codec work), so the deterministic maintainer-approval gate correctly treats the prior approval as stale — there is no APPROVED review on the current head.
>
> Action needed: kriskowal (or a journal maintainer) re-approves [endojs/endo-but-for-bots#877](https://github.com/endojs/endo-but-for-bots/issues/877) at head `c48a7d83d`. Once re-approved and CI is green, re-post a merge/conduct job (or say `merge endojs/endo-but-for-bots#877`) and it will land with `--merge`. Repo has no auto-merge enabled, so I cannot pre-arm `--auto`.
>
> Base is live `llm` (not a frozen snapshot) — no unfreeze needed. No CI failures observed yet (all checks still pending at report time).

- `20260806T144506Z-483fab` — from gardener:endojs-endo-but-for-bots-pr876-shepherd, reply_to `endojs-endo-but-for-bots-pr876-shepherd` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260806T144506Z-483fab.md)

> PR [https://github.com/endojs/endo-but-for-bots/pull/876](https://github.com/endojs/endo-but-for-bots/pull/876) cannot dispatch CI at head f0a0d58eaeb62cda5354543b2a7b2b09d560fd01 because GitHub reports mergeable=CONFLICTING, mergeStateStatus=DIRTY, and an empty statusCheckRollup. The referenced review was re-fetched as an empty-body APPROVED review by kriskowal. next: weaver

- `20260806T151553Z-fdddf7` — from gardener:decommission-cxs-rust-default-xst-ci-parity, reply_to `decommission-cxs-rust-default-xst-ci-parity` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260806T151553Z-fdddf7.md)

> HALTED (no destructive work done): the `decommission-cxs-rust-default-xst-ci-parity`
> plan was promoted, but its hard gate — "run ONLY once the XS->Rust port is complete" —
> is NOT met on `endojs/endo-but-for-bots@llm`. I did NOT drop c/moddable, remove the
> C-binding Endor, or touch CI. Evidence (worktree off origin/llm @ 0c157c49d):
>
> 1. Rust engine NOT the default / NOT daemon-integrated (charter finish-line item one):
>    - `bin/endor.rs:7` comment: "XS is the default engine for every [...]".
>    - Rust `ironhorse` VM is reachable ONLY via explicit `endor run -e ironhorse
>      <script>` / `endor worker ... ironhorse`, behind `#[cfg(feature =
>      "ironhorse-engine")]`. Not dispatched by the daemon/worker CapTP loop.
>    - `inproc.rs` still calls `xsnap::run_xs_manager_inproc` / `run_xs_worker_inproc`;
>      `engine.rs` `Engine::Shared` still uses `xsnap::WORKER_BOOTSTRAP`/`WORKER_CREATION`.
>    - `endojs/endo-but-for-bots#600` ("feat(ironhorse): JavaScript engine in Rust")
>      landed the ENGINE, not the daemon integration.
> 2. No green `test:rust`: there is no `test:rust` npm script at all.
> 3. test262 parity NOT closed: CI `test262` job (.github/workflows/ci.yml line 400) is
>    stubbed `run: exit 0 # TODO remove test262 from required tests for CI`.
> 4. `consolidate-test262-fixtures` groundwork (the CI-parity substrate this depends on)
>    is not landed as a single consolidated corpus.
>
> Performing the decommission now would break the daemon/worker/run default path
> (nothing else drives the in-process shared machine) and delete the parity oracle
> before parity is even measured. Recommend: keep parked. I could not re-park under the
> same base while holding the lifecycle slot — please re-park with
> `scripts/jobs/post-plan.sh --go-ahead decommission-cxs-rust-default-xst-ci-parity`
> once this job clears, and only re-promote after the daemon integration lands +
> `test:rust` is green + test262 parity is closed. Full spec preserved in my tada report.

- `20260806T152927Z-e9108b` — from gardener:consolidate-test262-fixtures, reply_to `consolidate-test262-fixtures` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260806T152927Z-e9108b.md)

> test262 fixture consolidation (job consolidate-test262-fixtures): opened DRAFT PR [endojs/endo-but-for-bots#946](https://github.com/endojs/endo-but-for-bots/issues/946) against `llm` with the design + rollout step 1 (parameterized expectation lists + two-directional ratchet, unit-tested and verified oracle-backed on a bounded slice).
>
> One decision needs your call before the rest lands. The directive's sketch assumes the 1712 cases in `rust/engine/ironhorse-262/cases` duplicate upstream test262 and should fold into `packages/test262-runner/test262/test/**`. They are NOT duplicates: they're bespoke bit-exact metering micro-cases (tagged `ironhorse-meter-exact`/`-determinism`, feeding the byte-identity compile-diff gate), generated from the retired bring-up corpora. Upstream test262 has no cost model, and the parent design (ironhorse-test262-convergence.md) calls the metering corpus proprietary-forever. So folding them into the parity tree loses that coverage.
>
> Recommendation (design § Open Decision, option A): keep the two case trees, unify only the EXPECTATION accounting across them (which is where the drift you want ratcheted actually lives). The mechanism I built works under either resolution. Option B (collapse to the upstream tree) needs an explicit call to accept losing, or re-homing, the metering/byte-identity coverage.
>
> Full-corpus expectation baselines are a separate batched per-subtree oracle sweep (the whole-tree oracle run is the known OOM concern), to run on a toolchain host, not inline.

- `20260810T232710Z-3721ab` — from gardener:minion-town-ocap-site-psl-local-pr, reply_to `minion-town-ocap-site-psl-local-pr` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T232710Z-3721ab.md)

> The Public Suffix List change is prepared in the fork-local PR: [https://github.com/kriscendobot/list/pull/1](https://github.com/kriscendobot/list/pull/1)
>
> The patch adds the single `ocap.site` PRIVATE rule in the Minion Town alphabetical position. Local `make test` passes, including all PSL syntax checks and the libpsl ICU test suites (3/3 fuzz tests and 5/5 rule tests).
>
> This is READY TO FERRY upstream to `publicsuffix/list`, pending the owner's attestations. The local PR keeps ownership, distinct-user count, registration/renewal, abuse-response and role-mailbox, maintenance, third-party-limit, and impact confirmations clearly marked `[owner to complete at ferry]`; a bot cannot make them. After the ferry creates upstream PR number `N`, publish and publicly verify `_psl.ocap.site TXT "https://github.com/publicsuffix/list/pull/N"` from the live zone. No upstream PR or upstream push has been made.

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.

- `20260811T002229Z-10132b` — from gardener:minion-town-pr30-remove-toy-tools-build, reply_to `minion-town-pr30-remove-toy-tools-build` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260811T002229Z-10132b.md)

> minion.town: opened DRAFT PR [kriscendobot/minion.town#36](https://github.com/kriscendobot/minion.town/issues/36) — the decoupled "remove toy minion tools + prune mcp/minions:* scopes" removal mandated by design PR [kriscendobot/minion.town#30](https://github.com/kriscendobot/minion.town/issues/30). Typecheck + 215 tests green; pre-push gate probes pass.
>
> Heads up on an overlap you'll want to reconcile: PR [kriscendobot/minion.town#20](https://github.com/kriscendobot/minion.town/issues/20) (feat/endo-daemon-guest-mcp-b5, OPEN, non-draft) ALSO retires the toy tools and removes mcp/minions:*, but coupled with the B5 "daemon guest = required surface" feature and gated on B4/B5 deploy evidence. The new [kriscendobot/minion.town#36](https://github.com/kriscendobot/minion.town/issues/36) is the pure removal design [kriscendobot/minion.town#30](https://github.com/kriscendobot/minion.town/issues/30) carved out (no feature, not B4/B5-gated). They collide on the removal — likely land one and rebase/close the other. I flagged this in [kriscendobot/minion.town#36](https://github.com/kriscendobot/minion.town/issues/36)'s body rather than silently competing.
>
> Also: the Cognito/IaC part needs `cdk deploy` BEFORE the app roll (resource server + PKCE client drop minions:* first); recorded as Phase 12 in DEPLOYMENT.md. No deploy performed.

- `20260812T053228Z-6aa19b` — from gardener:dependabotany-sweep-approval-held, reply_to `dependabotany-sweep-approval-held` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260812T053228Z-6aa19b.md)

> dependabotany-sweep-approval-held HALTED at its precondition — the deploy is the blocker, not the PRs.
>
> The seven approval-held MERGE-NOW dependabot PRs on endojs/endo-but-for-bots cannot be swept yet. The auto-conduct policy (skip maintainer approval for a dependabot-authored PR on a bot-owned repo) is committed on origin/main2 as `225e364eb0 feat(botany): auto-conduct Dependabot MERGE-NOW`, which adds the `--dependabot-auto-merge` mode to scripts/jobs/gardening/ci-wait-merge.sh.
>
> But the DEPLOYED garden root (HEAD c7d730c36) does NOT carry it: its ci-wait-merge.sh has no `--dependabot-auto-merge` flag and still calls pr-maintainer-approval-gh.sh unconditionally at the merge point. `deploy-garden.sh` has not run since that commit landed.
>
> Per the job's own precondition I did NOT review or merge anything under the old rules, and I am ending the job with orchestration-failed: true so the orchestration HALTS. Re-promote this sweep after deploy-garden.sh advances the root past 225e364eb0.

- `20260812T165812Z-e793d5` — from gardener:ironhorse-test262-restore-and-relaunch, reply_to `ironhorse-test262-restore-and-relaunch` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260812T165812Z-e793d5.md)

> PRECONDITION FAILED. Deployed /home/kris/garden has the orchestrate.sh stall fix (removed requeue-rise heuristic), but does not have ede7f1f467 child-failure stamping. Deployed common.sh tada_failed() only recognizes undecorated orchestration-* fields and does not recognize decorated verdict lines. Deployed complete-job.sh has no --orchestration-failed option or stamping path. Per ironhorse-test262-restore-and-relaunch, I stopped before restoring or posting any children/campaign. Please deploy ede7f1f467 before requeueing this recovery.

- `20260812T170548Z-21924f` — from gardener:ironhorse-test262-restore-and-relaunch, reply_to `ironhorse-test262-restore-and-relaunch` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260812T170548Z-21924f.md)

> HALTED — precondition (fix #two) not met; did NOT restore or relaunch the ironhorse test262 campaign.
>
> Deployed garden root is at commit 225e364eb0 (fingerprinted scripts/jobs/{common.sh,complete-job.sh,orchestrate.sh} blobs against each candidate — all three match 225e364eb0 exactly).
>
> - Fix one (9a16e2a6ef, stall heuristic) IS live: orchestrate.sh has `! has_productive_cycle_hint "$jf" && [ "$n" -gt "$limit" ]` and no "requeue count rose from" string. OK.
> - Fix two (ede7f1f467, child-failure detect/stamp) is NOT live: deployed tada_failed() in common.sh is the OLD 3-line grep that does NOT recognize decorated verdict lines; deployed complete-job.sh has NO --orchestration-failed flag. The three HEAD commits ede7f1f467, b63befa87e, b580e3d51a are on main2/origin but not yet deployed to the root.
>
> Per the job's fail-closed gate, I stopped rather than arm ~2.08M billable tokens of real spend with child-failure detection absent — the old tada_failed would MISS a decorated failure line and let a serial run promote past a genuinely-failed child instead of halting.
>
> ACTION NEEDED: run a deliberate deploy (scripts/jobs/deploy-garden.sh) to advance the root to at least ede7f1f467, then re-post this restore job (new campaign base ironhorse-test262-implementation-completion-resume-2). The 22 swept child bodies are still recoverable from the sweep-commit parent c95607119^. I did not verify the 2.08M budget figure — I halted before that step.

- `20260813T151055Z-707011` — from gardener:endojs-endo-but-for-bots-pr937-rebase-onto-new-llm, reply_to `endojs-endo-but-for-bots-pr937-rebase-onto-new-llm` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260813T151055Z-707011.md)

> Rebased [endojs/endo-but-for-bots#937](https://github.com/endojs/endo-but-for-bots/issues/937) onto the fresh pinned base llm-0c3598a (llm tip after [endojs/endo-but-for-bots#903](https://github.com/endojs/endo-but-for-bots/issues/903)). Result: the rebase revealed [endojs/endo-but-for-bots#903](https://github.com/endojs/endo-but-for-bots/issues/903) landed a refined superset of nearly all of [endojs/endo-but-for-bots#937](https://github.com/endojs/endo-but-for-bots/issues/937) — 9 of its 10 commits collapse to empty against the new llm (the @endo/sha256 package, the daemon host-tool-powers + XS-bundle work, BlobRef/chat/design updates all already in llm; llm's CI already generates the daemon XS bundle). The PR's original "restore XS bundle generation" goal is already met on llm.
>
> What survives is one commit: a `bundle:xs` npm script folding the three explicit node bundle .mjs CI lines into one named script (net +2/-3 across package.json + ci.yml). PR now MERGEABLE, diff clean/interpretable. Verified `yarn bundle:xs` and the daemon bundle script build clean on the new base. Did not merge or request review.
>
> Decision for you: keep [endojs/endo-but-for-bots#937](https://github.com/endojs/endo-but-for-bots/issues/937) as this small cosmetic refactor, or close it as superseded by [endojs/endo-but-for-bots#903](https://github.com/endojs/endo-but-for-bots/issues/903). Details in a PR comment on the PR.

- `20260813T215817Z-006a96` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260813T215817Z-006a96.md)

> Report `endojs-endo-but-for-bots-pr149-review-13c87bef-status-directory-walker` (endojs/endo-but-for-bots PR #149) leaves two judgment calls open: (1) whether to accept the `agentry` disposition, under which the status-directory-walker is a clean lift (module + 5 tests) independent of the PR's blocked sandbox cluster and genie glue; and (2) whether to proceed at all given the feature stays dead code unless the sub-agent-directory arc (TODO/53–61) lands a consumer, which is unimplemented on the branch. No autonomous job posted pending your call.

- `20260813T222721Z-d601d9` — from gardener:genie-docs-delete-from-llm-r3, reply_to `genie-docs-delete-from-llm-r3` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260813T222721Z-d601d9.md)

> Job genie-docs-delete-from-llm-r3 (delete PLAN/TODO/TADA from endo-but-for-bots@llm): migration verified, but I'm holding before deleting — the job's premise is contradicted and this is your call.
>
> VERIFIED (independently):
> - Journal copy at library/endo-but-for-bots/ is byte-identical to origin/llm (diff -rq clean, all three dirs). Counts match: PLAN 11, TODO 1, TADA 172 (184 files + README). Provenance README present.
> - origin/llm HEAD is still exactly the migration source commit a54c3adb — llm has NOT moved.
> - No instruction file (root AGENTS.md/CLAUDE.md/CONTRIBUTING.md/README.md) ever directed agents to WRITE into these dirs. They're cited only as design provenance.
>
> THE PROBLEM the job under-counted:
> - The job said "references ONLY from within the directories themselves." NOT TRUE at this commit. There are 101 references across 43 files OUTSIDE the three dirs — including 10 breaking markdown links (in designs/, packages/genie/README.md, packages/genie/DESIGN.md, packages/sandbox/README.md, and packages/genie/AGENTS.md — an agent-instruction file) and ~91 historical code-comment citations by doc number across shipping genie/sandbox source and tests (e.g. "// Non-zero exits are data, not errors — see TADA/60").
> - The migration destination is the garden's PRIVATE journal (journal2). endo-but-for-bots is PUBLIC. So for a public reader the moved content has no public home EXCEPT this repo's own git history at a54c3adb. Deleting leaves public code citing docs that live only where the public can't see (the journal) or in deleted history.
>
> RECOMMENDATION: keep them in-tree — the journal copy is a good archival backup, but it doesn't make the docs redundant for a public repo that actively cites them 100+ times. If you still want them gone, my proposed shape: delete the 3 dirs, repoint the 10 markdown links to permanent public permalinks (github.com/endojs/endo-but-for-bots/blob/a54c3adb/...), leave the ~91 comment citations as historical (findable via history), and PR-note that content is preserved in git history at a54c3adb + archived in the journal, don't force merge.
>
> llm is UNTOUCHED. Tell me which way and I'll execute.

- `20260813T225701Z-faa5d7` — from gardener:ironhorse-resume-6-launch, reply_to `ironhorse-resume-6-launch` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260813T225701Z-faa5d7.md)

> Ironhorse resume-6 launch is BLOCKED on a deploy gap — did NOT launch.
>
> Precondition failed: the campaign-meter fix (garden-campaign-spend-unmetered-rows)
> is LANDED on main2 but NOT DEPLOYED. Deployed root
> scripts/jobs/campaign-spend.sh still fatals at line 79
> ("… is an unmetered or invalid campaign row"); the main2 version (in a fresh
> main2 worktree) already counts unmetered rows as 0 spend and still rejects
> malformed rows. Launching now would relaunch straight into the same fatal on the
> first cleric child (exactly how resume-5 died after one child).
>
> All 17 children (js-12..js-28) confirmed still parked in jobs/plan/ with
> gate: orchestrated. Nothing to fix on the board.
>
> I did NOT self-authorize a deploy. Handed the launch off to a durable go-ahead
> successor so nothing is lost:
>
>   jobs/plan/ironhorse-resume-6-launch-postdeploy  (gate=go-ahead)
>
> It carries the full precondition + the exact post-orchestration.sh launch line
> (--serial --on-child-failure continue --budget-tokens 10000000, resume-6, children
> js-12..js-28) and re-verifies the deploy before firing.
>
> Next steps:
>   1. Let the deploy-on-upgrade Monitor drive the deploy of main2 to the root (or
>      authorize a sysop deploy op). The deploy needs a drained/quiet fleet.
>   2. After the deploy lands, promote ironhorse-resume-6-launch-postdeploy
>      ("go ahead / promote ironhorse-resume-6-launch-postdeploy"). It re-checks the
>      deployed script, then launches the campaign.

- `20260814T064258Z-213e64` — from gardener:endojs-endo-but-for-bots-pr234-review-03f6892a, reply_to `endojs-endo-but-for-bots-pr234-review-03f6892a` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260814T064258Z-213e64.md)

> Resolved kriskowal's approving-review nit on [endojs/endo-but-for-bots#234](https://github.com/endojs/endo-but-for-bots/issues/234) (follow-stream design).
>
> The one substantial nit ("the handle should be the name assigned by the agent when they call monitor, per petname discipline") is now implemented on the design at head e917b6a800:
> - `monitor` gains a required `name` input — the pet name the AGENT assigns; the result echoes it instead of minting `monitor-7`.
> - `cancelMonitor` takes that name; notifications head with `name=…`; the per-worker registry is keyed by the agent-assigned name and rejects a duplicate open name synchronously.
> - Open Question 4 (handle representation) converted to a RESOLVED decision (agent-assigned pet name), candidates preserved for the record.
> - A peer had already renamed the tool family followStream→monitor but left designs/README.md still saying followStream; I refreshed the README (summary/status/size tables + dependency graph) to monitor naming.
> - The PR was CONFLICTING against llm (pre-existing); I rebased onto llm and re-grafted the README additions, so it is now MERGEABLE and not draft.
>
> Heads-up before merge: the rebase + the new design commit make your APPROVED review stale by the conductor's exact-head invariant (approval was on the old head 0d088af70f). Since the nit fix changed the tool's input contract — a design call — please re-review/approve the new head e917b6a800. Once you re-approve and CI is green (checks currently running, design-only markdown change), say "merge [endojs/endo-but-for-bots#234](https://github.com/endojs/endo-but-for-bots/issues/234)" and the conductor will land it. I did not dispatch the conductor yet because it would immediately stall on the stale-approval gate.

- `20260814T221858Z-889dcc` — from gardener:ironhorse-js-26-residual-gap-closure, reply_to `ironhorse-js-26-residual-gap-closure` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260814T221858Z-889dcc.md)

> Ironhorse js-26 (residual-gap-closure) — scope escalation + handoff.
>
> I ran the authoritative full-suite report on the accumulated PR [endojs/endo-but-for-bots#970](https://github.com/endojs/endo-but-for-bots/issues/970) head b3c3ae93 (pins as specified: test262 be13516fb, XS oracle 23b4d6b0). Result vs the 08-08 baseline:
>   covered 4,740 -> 23,496 ; unsupported 38,400 -> 23,233 ; ironhorse-failure 19 -> 194 ; skipped 8,932 -> 4,406 ; infra 1 -> 647.
>
> The premise that js-26 is a small mop-up is wrong: **23,427 actionable cases remain** (23,233 unsupported + 194 fail), across ~15 causal clusters — several individually multi-day (RegExp u/v/unicode 4,212; TypedArray/ArrayBuffer 3,243; language expr/stmt 2,710; Object/Array/Reflect/Proxy 2,297; eval/Function/dynamic-import 1,945). This is a multi-week engine-completion effort, not a single 2h child. The residual is dominated by exactly the generic reasons the acceptance bar forbids (unsupported-opcode:* 10,313; ironhorse-aborted 9,510; abort-value-differs 1,825; parse-or-decode 512; non-primitive-completion 351).
>
> Per the job's own directive ("if too large for the handler budget, stop before partial relabeling, post a nested halt-on-failure orchestration of bounded causal children"), I did NOT relabel anything. I posted a serial, halt-on-failure orchestration `ironhorse-js-26-residual-closure` with 15 data-grounded causal children (ironhorse-js-26-ca..cz), each carrying its reason-family histogram, top subtrees, example paths, the shared-branch/pins, the full acceptance bar, and the regression invariant. js-26 hands off to that orchestration.
>
> Three things need your decision:
> 1. **Ordering:** js-27-full-suite-report-refresh and js-28-issue-summary sit after js-26 in the serial orchestration `ironhorse-test262-implementation-completion-resume-6`. When js-26 completes they will promote and refresh/report BEFORE the residual work runs. Please re-block js-27 and js-28 on `ironhorse-js-26-residual-closure` (or splice the new children ahead of them) so the report is refreshed only after the residual closes.
> 2. **js-25 died unreported:** ironhorse-js-25-temporal-integration is stuck in jobs/doin/ (claimed 20:34, worker gone — its inbox dead-lettered). Its commits ARE on the branch (a30cceaf30, b3c3ae93b8). It needs reaping; its "zero feature-based Temporal pre-skips" acceptance is unverified.
> 3. **Accumulated regressions on the branch (not introduced by me — I made zero commits):** 6 baseline-covered paths regressed (Set.prototype.keys, String trimLeft/trimRight refs, 3 strict abort-value-differs) plus 19 harness/* reclassified; and 194 new ironhorse-failures (185 are RegExp negative over-acceptances — missing regex early-error validation, folded into cluster ca). These are folded into the causal children for repair.
>
> I'm handing off js-26 to ironhorse-js-26-residual-closure.

- `20260814T223102Z-4d8f01` — from gardener:monthly-progress-report-20260714-20260814, reply_to `monthly-progress-report-20260714-20260814` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260814T223102Z-4d8f01.md)

> The requested monthly report is at journal/reports/monthly-progress-2026-07-14-to-2026-08-14.md. The biggest developments were the merge of the Rust XS replacement in [endojs/endo-but-for-bots#600](https://github.com/endojs/endo-but-for-bots/issues/600), the measured Ironhorse Test262 campaign that raised coverage from 4,740 to 23,496 cases before decomposing the residual work, and minion.town moving to a live weblet gateway while surfacing and fixing a host-authority escape. Garden operations also gained stronger worktree, quota, orchestration, and cost controls; August coverage was reconstructed from raw entries and board history because all recurring schedules, including the daily summary, were paused for token spend on August 1. This report was requested in a liaison conversation on 2026-08-14.

- `20260814T224404Z-ff02c5` — from gardener:ironhorse-js-27-full-suite-report-refresh, reply_to `ironhorse-js-27-full-suite-report-refresh` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260814T224404Z-ff02c5.md)

> Ironhorse full-suite report REFRESHED (interim) — [kriscendobot/garden#51](https://github.com/kriscendobot/garden/issues/51).
>
> Re-ran the authoritative full sweep of the pinned corpus (tc39/test262@be13516f)
> against the language-completion head b3c3ae93b8 ([endojs/endo-but-for-bots#970](https://github.com/endojs/endo-but-for-bots/issues/970)), XS
> oracle 23b4d6b0. Published + verified live (HTTP 200, JSON parses):
>   https://kriscendobot.github.io/garden/reports/ironhorse-test262/20260814-b3c3ae93b8/report.html
>
> Before -> after (52,092 -> 51,976 cases; total shifts because this head excludes
> harness files + reclassifies module cases):
>   covered        4,740 -> 23,496  (x5; Proxy 0 -> 188/311)
>   unsupported   38,400 -> 23,233
>   skipped        8,932 ->  4,406
>   ironhorse-fail    19 ->    194  (185 are built-ins/RegExp negative over-acceptances)
>   infrastructure     1 ->    647  (443 module:evaluation, etc.)
>
> This is INTERIM, not the final zero-everything state the job's gate requires:
> - js-26-ca-regexp-u-core and js-26-cb-with-statement are running RIGHT NOW on the
>   same branch. They own the two biggest residual buckets (u/v-flag: 2,870 unsupported
>   + 185 of 194 failures; with-statement: 943 unsupported). The truly-final refresh +
>   the current-test262-tip sweep should run AFTER js-26 closure lands.
> - 6 cases covered on 2026-08-08 REGRESS to unsupported at this head (Set.prototype.keys,
>   trimLeft/trimRight Annex-B refs, 3 strict-mode cases) — reproduces in isolation, so a
>   genuine branch defect from an earlier child; needs a fixer.
> Exact-metering corpus gate PASSES at this head (1711/1711, 0 failed).
>
> Signalling this child orchestration-failed (gate unmet at a mid-flight head), not a
> clean completion.

- `20260815T010357Z-1b583e` — from gardener:ironhorse-js-26-cf-typedarray-arraybuffer, reply_to `ironhorse-js-26-cf-typedarray-arraybuffer` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260815T010357Z-1b583e.md)

> js-26 TypedArray/ArrayBuffer cluster (3243 cases) — status + a high-leverage finding.
>
> Done this session: landed the ArrayBuffer/SharedArrayBuffer **constructor** ToIndex-coercion +
> catchable RangeError/TypeError surface on feat/ironhorse-262-language-completion (PR
> [endojs/endo-but-for-bots#970](https://github.com/endojs/endo-but-for-bots/issues/970), head 1c41b9a61). built-ins/ArrayBuffer slice: covered 22→28, 0
> regressions; exact-metering corpus (1712/1712) + full Rust workspace green; added
> tests/array_buffer_ctor_coercion.rs.
>
> Cluster too large for one handler → re-decomposed the remainder into a serial halt-on-failure
> orchestration `ironhorse-js-26-cf-resid` (7 parked children: ta-ctor, ta-proto, dataview,
> slice-transfer, resizable-buffers, atomics, array-nondense) on origin/journal2. Handed off.
>
> HIGH-LEVERAGE, CROSS-CUTTING FINDING (worth routing NOW): a large share of the error-path cases
> across the WHOLE language-completion arc are blocked by a general object-model gap, NOT by
> TypedArray semantics — reading `.constructor` on a user-function instance (and
> `Foo.prototype.constructor`, and property access on null/undefined throwing a catchable TypeError)
> currently aborts. Since the ubiquitous `assert.throws(Ctor, fn)` harness reads `thrown.constructor`
> on its success path, every "assert.throws expected-error" case stays `ironhorse-aborted` even when
> the engine throws the correct error. Minimal repro: `assert.throws(Test262Error, () => { throw new
> Test262Error() })` is ironhorse-aborted, while `assert.throws(RangeError, () => new ArrayBuffer(-1))`
> is covered. This belongs to the built-ins/Object / general object-model cluster and would unblock a
> big fraction of js-XX error cases at once — recommend prioritizing it ahead of the deeper
> TypedArray-semantics children.

- `20260815T012602Z-9f7be1` — from gardener:ironhorse-js-26-cg-intl-value-parity, reply_to `ironhorse-js-26-cg-intl-value-parity` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260815T012602Z-9f7be1.md)

> Intl formatter value/parity cluster (js-26 residual, 887 cases): diagnosed and DECOMPOSED, not closeable by one handler.
>
> Key standards finding: the pinned Moddable XS oracle has NO ECMA-402 host (`Intl` is an undefined global). So these cases can NEVER be "covered" in the both-engines-agree sense — the accepted terminal is `oracle-host-missing-intl` (Ironhorse runs to completion with the correct value; XS reports the missing binding), the same host-only-exclusion the child-20 ListFormat/PluralRules work already used. The current `abort-value-differs` reasons are Ironhorse THROWING where it must complete, because four constructors are entirely unimplemented — Intl.NumberFormat, Intl.DisplayNames, Intl.DurationFormat, Intl.RelativeTimeFormat (all typeof==='undefined') — and five are partial (DateTimeFormat/Locale/Collator/ListFormat/Segmenter).
>
> I did NOT relabel or weaken the classifier. Instead I posted a nested serial halt-on-failure orchestration `ironhorse-intl-value-parity-orch` with 10 per-family children (each carries pins, acceptance bar, regression invariant, shared-branch rules, and measured repro). Run order: numberformat first (foundational), then core/toLocaleString, displaynames, relativetimeformat, durationformat, datetimeformat, locale, collator, listformat, segmenter.
>
> Heads-up on cost: these are 10 builder-grade (Opus) engine-implementation children — implementing 4 ECMA-402 constructors from scratch plus 5 completions, with locale data tables. That's a large fleet commitment. Given the gardener-pool quota throttle, you may want to gate promotion cadence or pull specific families forward rather than let all 10 run. The orchestration is serial so it won't stampede. PR [endojs/endo-but-for-bots#970](https://github.com/endojs/endo-but-for-bots/issues/970) stays open/draft; nothing merged. No code landed this pass — pure diagnosis + durable continuation.

- `20260815T014517Z-2da801` — from gardener:ironhorse-js-26-ca-regexp-closure-audit, reply_to `ironhorse-js-26-ca-regexp-closure-audit` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260815T014517Z-2da801.md)

> ca-regexp-closure-audit (final child of ironhorse-js-26-ca-regexp-unicode-closure) done. Landed one bounded genuine fix on PR [endojs/endo-but-for-bots#970](https://github.com/endojs/endo-but-for-bots/issues/970) head 66353cce0: a cleanly-rejected compile now throws SyntaxError instead of decoding empty bytecode (closed all RegExp Annex-B out-of-range-backreference parse-or-decode cases; +5 covered, 0 regressions, exact-meter 1712/1661/51 unchanged, workspace green).
>
> BUT the orchestration gate "zero forbidden reasons in the cluster" is NOT bounded-achievable and I emitted the orchestration-failure signal. The RegExp/Unicode MATCHING+PARSING cluster IS closed (0 ironhorse-failures; u/v, property escapes, unicodeSets, modifiers, named-groups, and now RegExp parse-or-decode all zero). The residual forbidden reasons across the 10 listed subtrees (unsupported-opcode 2330, ironhorse-aborted 1782, abort-value-differs 440, parse-or-decode 33, over-acceptance 1) are dominated by (a) general-engine gaps that merely live in RegExp/String/Array test files (apply/defineProperty MOP, String.split/match/replace dispatch, coercion) — owned by sibling causal clusters, not RegExp; (b) Temporal/Iterator gaps (all 33 remaining parse-or-decode are Temporal Infinity/missing-args, not RegExp); and (c) genuinely RegExp-cluster but unimplemented Annex-B legacy FEATURES (RegExp.prototype.compile + static accessors) — substantial features, not bounded fixes, and the 1 remaining over-acceptance (compile-on-subclass) needs the compile method. These belong to their own children per the residual-gap-closure decomposition. Recommend a dedicated ca-regexp-annexb-legacy-features child for (c).

- `20260815T050827Z-2e98de` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260815T050827Z-2e98de.md)

> Report `ironhorse-js-26-map-methods` closed honestly short of its gated bar: the child delivered Map upsert (`getOrInsert`/`getOrInsertComputed`) coverage with no regressions, but did **not** reach zero test262 aborts for these subtrees because four cross-cutting engine-wide gaps remain open (the same residuals the js-26 parent left open for its Set methods). Two decisions are yours: (1) whether that partial state is acceptable for the parent's gate, or the halt-on-failure orchestration should stay halted until the four cross-cutting fixes land as their own feature increments; and (2) whether to fund the cheap adjacent increment the report flags — the `built-ins/WeakMap/prototype/getOrInsert` slice (weak-key validation, no key canonicalization), explicitly out of this child's scope. The digest names no repo or PR URL for either, so I am not posting jobs on a guess; tell me the target repo/PR and which of these to post and I will queue them.

- `20260815T061624Z-e53a2d` — from gardener:endojs-endo-but-for-bots-pr288-review-b0793cc4, reply_to `endojs-endo-but-for-bots-pr288-review-b0793cc4` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260815T061624Z-e53a2d.md)

> Re: [endojs/endo-but-for-bots#288](https://github.com/endojs/endo-but-for-bots/issues/288) (cbor-frame) — your review "[APPROVED] Please rebase, shepherd, and conduct" is resolved through the weave:
>
> - Rebased feat/cbors-package onto llm (was 786 behind). One real conflict: ocapn's package.json — base grew its own @endo/cbor codec while this PR adds @endo/cbor-frame. Both are genuinely used (base's src/cbor imports @endo/cbor; the PR's tcp-test-only.js imports @endo/cbor-frame), so I resolved it as a union of the two deps. Regenerated composite tsconfigs + yarn.lock, and dropped a now-redundant `/* global setTimeout */` in the cbor-frame test (base eslint now declares it -> no-redeclare). Verified locally: build:types, build:types:check, prettier, package-uniformity, and per-package eslint on cbor-frame + ocapn all pass.
> - Force-pushed to head 33ae7c42a; PR is mergeable (no conflicts). CI is running.
> - Posted a conductor job (endojs-endo-but-for-bots-pr288-conduct) to shepherd CI to green and merge.
>
> ONE human step is needed: the rebase rewrote history, so your approval on the old head (8a4aad504) is stale for the rebased head. The conductor will correctly stall "merge blocked: no maintainer approval" until you re-approve 33ae7c42a. Please re-approve when CI is green and it'll land.

- `20260815T062050Z-9c457b` — from gardener:endojs-endo-but-for-bots-pr286-weave, reply_to `endojs-endo-but-for-bots-pr286-weave` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260815T062050Z-9c457b.md)

> Weave of [endojs/endo-but-for-bots#286](https://github.com/endojs/endo-but-for-bots/issues/286) (`endo http mk` Phase 1) — STOPPED, needs
> your decision. This is a design collision, not a mechanical rebase.
>
> While [endojs/endo-but-for-bots#286](https://github.com/endojs/endo-but-for-bots/issues/286) sat, `llm` landed a SUPERSEDING implementation
> of the same capability:
>   - `@endo/exo-http-client` (`makeHttpClientAndControl`) and `@endo/fetch` are now
>     in `llm`. The `add-endo-fetch` changeset says the confined-HTTP capability was
>     "repackaged as an unconfined caplet ... rather than a daemon formula."
>   - `llm`'s daemon already defines a `http-client` FORMULA (policy-based),
>     `formulateHttpClient(policy, ...)`, `getHttpClientControlForClient`, and
>     `host.makeHttpClient(policy)` returning one client with a WeakMap-held control.
>   - `designs/README.md` on `llm` already marks cli-http-client "Proposed (PR
>     [endojs/endo-but-for-bots#144](https://github.com/endojs/endo-but-for-bots/issues/144) design revision; formula packaging superseded in
>     part by endo-fetch)".
>
> [endojs/endo-but-for-bots#286](https://github.com/endojs/endo-but-for-bots/issues/286) implements the SAME `http-client` formula type a
> DIFFERENT way: local `packages/daemon/src/http-client.js`, a paired
> `http-controller`+`http-client` formula, `formulateHttpClient(allowedOrigins,
> ...)`, and `host.makeHttpClient(controllerName, clientName, allowedOrigins)`
> returning a NAMED PAIR. A straight rebase produces duplicate `const
> formulateHttpClient` (hard redeclaration error), two incompatible `http-client`
> formula shapes, and duplicate maker/dep cases + duplicate host methods with
> clashing signatures.
>
> Resolving would require redesigning the feature onto `llm`'s exo-http-client base
> (drop the duplicate `http-client` formula, keep only the `endo http mk` CLI verb +
> `http-controller`, rewire the CLI to `llm`'s policy-based client) — outside a
> weave's mandate ("do NOT change the feature's design"), and a real design call.
>
> I aborted the rebase; the head branch is UNCHANGED (nothing force-pushed). The
> blocked merge job stays blocked — [endojs/endo-but-for-bots#286](https://github.com/endojs/endo-but-for-bots/issues/286) cannot be made
> mergeable by a weave.
>
> Recommend one of: (a) close/redraft [endojs/endo-but-for-bots#286](https://github.com/endojs/endo-but-for-bots/issues/286) as superseded by
> exo-http-client + endo-fetch; or (b) a builder/designer job to rework the `endo
> http mk` CLI verb onto `llm`'s landed http-client, dropping the duplicate daemon
> formula. Note the approval (kriskowal, 06:09Z today) predates recognizing this
> collision.

- `20260815T063123Z-015827` — from gardener:endojs-endo-but-for-bots-pr301-review-80a22279, reply_to `endojs-endo-but-for-bots-pr301-review-80a22279` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260815T063123Z-015827.md)

> Re: "Please refresh" on [endojs/endo-but-for-bots#301](https://github.com/endojs/endo-but-for-bots/issues/301) (feat: error tracing aggregator + `endo trace`).
>
> I cannot refresh this PR — it is superseded, not stale, and needs your decision.
>
> FINDING
> - The entire error-tracing feature already landed on `llm` via `bbc997dee`
>   (endolinbot, 2026-07-01, 1800 insertions), in an EVOLVED design: traces sit
>   behind a revocable `host.diagnostics().traces()` facet, whereas the PR exposes
>   a flat `EndoHost.traces()`. `bbc997dee` is NOT an ancestor of the PR head — it
>   is a parallel/divergent implementation of the same feature by another of our
>   own bot instances.
> - Every headline capability of the PR already exists on `llm`: the marshal
>   save/load hooks, the captp forwarding, the trace-aggregator (more advanced —
>   its `alias()` handles not-yet-arrived records), the `endo trace` CLI verb, and
>   the CTP_DISCONNECT `@@error` wire-shape reconstitution fix.
> - The base also restructured the daemon package (1782 commits since the PR's
>   merge-base): `daemon.js` / `daemon-go.js` / `daemon-node*.js` / `error-id.js`
>   no longer exist at the paths the PR edits/creates. A rebase would be
>   modify/delete conflicts across the whole daemon plus a semantic re-author onto
>   a facet that already does the job — a rebuild, not a refresh. I did not force
>   it (would silently drop the PR's intent).
>
> RESIDUAL over `llm` (candidates, all needing re-author onto the new structure if
> wanted): `error-id.js` dedup helper, `trace-constants.js`, a network-side
> `network-marshal-save-error.js` hook for ws-relay/libp2p, and chat-client trace
> surfacing. Unclear any is still net-new after the restructure.
>
> RECOMMENDATION: close [endojs/endo-but-for-bots#301](https://github.com/endojs/endo-but-for-bots/issues/301) as superseded by the landed
> error-tracing facility. If any residual (esp. the network-side save-error hook)
> is still wanted, commission a small designer/fixer to graft just that onto the
> diagnostics-facet structure — a fresh, narrowly-scoped item, not a refresh of
> this branch.
>
> Awaiting your call (close vs. graft-residual). Reply routes to my inbox.

- `20260815T063133Z-fe4d8e` — from gardener:endojs-endo-but-for-bots-pr324-conduct, reply_to `endojs-endo-but-for-bots-pr324-conduct` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260815T063133Z-fe4d8e.md)

> Conductor on endojs/endo-but-for-bots PR [endojs/endo-but-for-bots#324](https://github.com/endojs/endo-but-for-bots/issues/324) (test/familiar-primer-cas-smoke → llm).
>
> Your approval was on head f549c003d80. The PR was 883 commits behind llm, so the conductor spine rebased it onto live llm before merging (policy: a pre-rebase green run isn't evidence). The rebase force-pushed a new head 4318246203, which invalidates the approval signature by design — no agent force-push inherits a human approval.
>
> CI is now running on the rebased head. Once it goes green, the only remaining blocker is a fresh maintainer APPROVED review on head 4318246203. Please re-approve the rebased head and the next conduct tick will land it (--merge, merge-commit shape). I'm completing this attempt as a stall pending your re-approval.

- `20260815T063641Z-98fdb6` — from gardener:endojs-endo-but-for-bots-pr313-review-8dbb4e31, reply_to `endojs-endo-but-for-bots-pr313-review-8dbb4e31` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260815T063641Z-98fdb6.md)

> Heads-up (host infra, not blocking my job): on this host (endolin-garden-ece02cb4) the shared yarn berry cache index has hit ext4's 65000-hardlink ceiling. `yarn install` in any fresh project worktree now fails at the link step with:
>
>   EMLINK: too many links, link '/home/kris/garden/.yarn/berry/index/b8/b878c11a77128e74c3cf15c93ef2ceddf2aa0b38.dat' -> ...
>
> Confirmed: that .dat has exactly 65000 hardlinks. The pnpm linker hardlinks every worktree's node_modules from this global index, so the count only grows as worktrees accumulate and won't self-heal. This will break project installs fleet-wide on this host (any job needing `yarn install`).
>
> Likely fixes for a sysop/maintainer: prune the yarn global cache (`yarn cache clean --all` / clear `~/.yarn/berry/index`) to reset link counts, or switch the project's nodeLinker off pnpm-hardlink mode. I worked around it for this job by pointing YARN_GLOBAL_FOLDER at a fresh on-device folder (same filesystem, so hardlinks still work but into an unexhausted index), then cleaned it up.
>
> My job itself is done: PR [endojs/endo-but-for-bots#313](https://github.com/endojs/endo-but-for-bots/issues/313) review tests pushed (commit ceea5f188) and I replied on the PR.

- `20260815T064552Z-e300ce` — from gardener:endojs-endo-but-for-bots-pr324-conduct, reply_to `endojs-endo-but-for-bots-pr324-conduct` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260815T064552Z-e300ce.md)

> Update on [endojs/endo-but-for-bots#324](https://github.com/endojs/endo-but-for-bots/issues/324) (test/familiar-primer-cas-smoke → llm) — correcting my earlier note.
>
> The PR was 883 commits behind llm; the conductor rebased it onto live llm before merging. That rebase surfaced a real CI regression: the `lint` job now FAILS on the rebased head 4318246203 with
>
>   packages/lal/test/primer-cas-smoke.test.js:2:11
>   error  'process' is already defined as a built-in global variable  no-redeclare
>
> Current llm's eslint config now provides `process` as a built-in global, so the new test file's `/* global process */` directive redeclares it. (The pre-rebase green run was not evidence — the code is lint-incompatible with today's llm.) One error, plus 61 pre-existing-style warnings; the single error is the blocker.
>
> I did NOT merge. Stalling `ci red: needs shepherd`: a shepherd/fixer needs to drop the redundant `/* global process */` from packages/lal/test/primer-cas-smoke.test.js (setup.js's identical directive is fine under a different eslint env — worth a quick check), push, then you re-approve the fixed head (the rebase already invalidated your 06:18 approval by design), and a fresh conduct tick lands it. Per conductor discipline I do not post the shepherd job myself; the next triager tick will.

- `20260815T143518Z-27619e` — from gardener:endojs-endo-but-for-bots-pr992-gauntlet-panel-5, reply_to `endojs-endo-but-for-bots-pr992-gauntlet-panel-5` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260815T143518Z-27619e.md)

> Heads-up ([endojs/endo-but-for-bots#992](https://github.com/endojs/endo-but-for-bots/issues/992) gauntlet, panel stage): the panel-stage job
> template leaves the <base-ref> arg to the worker. In the fork clone
> (kriscendobot/endo-but-for-bots), `origin/llm` is a STALE branch 492 commits behind
> endojs/llm, so diffing against it yields a 3424-file bloated diff and mis-senses a CODE
> panel instead of the DESIGN panel. The correct base is `upstream/llm` (endojs), whose
> merge-base with HEAD is 9d86783c0 and yields the true 3-file design diff — matching
> GitHub's PR diff and the base rounds 1-4 used. I caught it, re-ran with `upstream/llm`,
> and posted the correct design-panel verdict (review 4944026686). Suggest the gauntlet
> driver pin the panel-stage base to `upstream/llm` (or the PR's real base branch on the
> upstream remote), not leave it to the worker to guess origin/llm.

- `20260815T171325Z-a98f9d` — from gardener:garden-budget-enforcement, reply_to `garden-budget-enforcement` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260815T171325Z-a98f9d.md)

> Design landed on main2 (87ccd70ab6): designs/live-budget-admission.md — the budget-study capstone that makes a live budget draw a standing property of EVERY dispatch (not an orchestration opt-in) and makes the garden1/garden2 worker leveling you did by hand on 2026-08-15 automatic.
>
> Headline finding: the mechanism already mostly exists. usage-meter.sh reads Claude Code's session logs, so it already captures ~100% of a host's Claude spend (the 28.8% figure is a retrospective PR-attribution artifact, not live-coverage), and per-host = per-account is already correct for our one-subscription-per-host topology. The meter is just OFF (quota unset) and only wired into the foreman + the gardener handler. The design generalizes its verdict to a shared pool_admits predicate at the three admission surfaces that lack it (promotion, direct post-job, and the universal claim gate), parks-not-refuses via the existing --budget-hold/budget-refresh, and adds a leader-only budget-level controller driving set-workers/the sysop op from live per-pool headroom. It composes alongside-and-ahead-of omega's ranked promoter (omega orders WHAT; budget admits WHETHER), replacing nothing.
>
> One maintainer-only input gates turning it live: the per-account weekly TOKEN cap. It is not machine-readable from a Max subscription. Two ways to supply it — (a) read each account's weekly token ceiling off Claude Code's /usage panel and I/we seed config/budget-pools, or (b) greenlight building the already-designed phase-2 weekly-capacity-calibration.sh (recurring-budget-calibration.md) to MEASURE it (max billable tokens over the trailing four weeks). Until a number exists the gates stay off (transparent). No build is queued yet — this was design-only. The other open questions (account-asymmetry policy given hasExtraUsageEnabled true on one host / false on the other; gate at 0.85 vs 1.0 for directed work; leveling shape) are in the doc's §10.

- `20260816T052256Z-02a6ed` — from gardener:endojs-endo-but-for-bots-pr389-conduct, reply_to `endojs-endo-but-for-bots-pr389-conduct` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260816T052256Z-02a6ed.md)

> conductor STALL — [endojs/endo-but-for-bots#389](https://github.com/endojs/endo-but-for-bots/issues/389) (gateway admin daemon, phase 3 of [endojs/endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/issues/343))
>
> You approved [endojs/endo-but-for-bots#389](https://github.com/endojs/endo-but-for-bots/issues/389) at its exact head (ea06d79b, 05:15Z) and CI
> is all-green, but I cannot conduct the merge: it would not reach a live trunk, and the
> path to trunk is blocked upstream in the stack.
>
> Why it can't merge as-is:
>   - The PR's base is `design/gateway-package-phase-2` (a stacked feature branch), NOT
>     llm/main/master. The PR body's own "Restacking discipline" says the stack lands
>     bottom-up: phase-2 must land to trunk first, then the PR rebases onto the new base.
>   - That predecessor, [endojs/endo-but-for-bots#388](https://github.com/endojs/endo-but-for-bots/issues/388) (phase 2), is CLOSED and never merged.
>     Its last review was CHANGES_REQUESTED (you, 2026-06-02). It auto-closed 2026-06-30 as
>     collateral when [endojs/endo-but-for-bots#343](https://github.com/endojs/endo-but-for-bots/issues/343) (phase 1) merged and deleted its base
>     branch `design/gateway-package` (base_ref_deleted cascade), 2s after phase 1 merged.
>   - Phase-2's content is not in llm, and the whole phase-2..phase-12 stack (this PR plus
>     the phase-4..phase-12 PRs `#392 #393 #394 #395 #396 #397 #409 #413 #420` in the same
>     repo) still sits on a stale llm (~a1dcc70, weeks old).
>
> So merging now would pile phase-3 onto a dead, non-trunk branch that carries phase-2's
> unapproved / changes-requested content and reaches no trunk — a discipline violation the
> conductor won't force.
>
> Recommended path (a weaver/orchestration decision, not the conductor's to make):
>   1. Re-land phase 2 bottom-first: reopen [endojs/endo-but-for-bots#388](https://github.com/endojs/endo-but-for-bots/issues/388) (or open a fresh
>      phase-2 -> llm PR), address its CHANGES_REQUESTED, restack onto current llm, land it.
>   2. Then restack [endojs/endo-but-for-bots#389](https://github.com/endojs/endo-but-for-bots/issues/389) onto llm (base retargets to llm) and
>      re-run the gauntlet / re-approve the rebased head; a fresh conduct job then merges it.
>   3. The rest of the stack restacks upward per the same discipline.
>
> I left the PR in draft and untouched (no un-draft, no merge) since it isn't actually
> landable yet. Want me to post a weave/orchestration job to re-land the gateway stack
> bottom-up, starting with phase 2?

- `20260816T062734Z-322a21` — from gardener:endojs-endo-but-for-bots-pr388-reopen-refresh, reply_to `endojs-endo-but-for-bots-pr388-reopen-refresh` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260816T062734Z-322a21.md)

> Re [endojs/endo-but-for-bots#388](https://github.com/endojs/endo-but-for-bots/issues/388) "reopen and refresh" (review 4945543700) — done, plus the direct child restacked.
>
> **[endojs/endo-but-for-bots#388](https://github.com/endojs/endo-but-for-bots/issues/388) (phase-2) — REOPENED + refreshed.** [https://github.com/endojs/endo-but-for-bots/pull/388](https://github.com/endojs/endo-but-for-bots/pull/388)
> - Rebased design/gateway-package-phase-2 onto origin/llm (--onto llm 1a735308de). 7 clean commits; HEAD is the typed-array review note (af550587f).
> - Ported phase-2's type additions onto llm's new layout: getBootstrap on Gateway, crypto/clock on GatewayPowers now live in packages/gateway/src/types.ts (not re-added as inline index.js typedefs); udsBootstrap→sockBootstrap propagated; module cross-refs (AppsNameHub) repointed to types.js.
> - Verified green locally: packages/gateway tsc clean, eslint 0 errors, 125 tests pass.
> - Base retargeted deleted design/gateway-package → llm; commitCount now 7.
> - Reopen mechanics note: GitHub blocked reopen ("head force-pushed after close"). I restored the head to its remembered SHA, reopened, retargeted base to llm, then re-pushed the rebased head, and deleted the transient base branch. Net final state is correct.
>
> **[endojs/endo-but-for-bots#389](https://github.com/endojs/endo-but-for-bots/issues/389) (phase-3) — RESTACKED.** [https://github.com/endojs/endo-but-for-bots/pull/389](https://github.com/endojs/endo-but-for-bots/pull/389)
> - Rebased design/gateway-package-phase-3 onto the new phase-2 head. 2 clean commits (c7307a12a), base still design/gateway-package-phase-2.
> - Ported phase-3's additions the same way: getAdmin on Gateway, resourceLedger on GatewayPowers into types.ts; admin.js/admin.test.js cross-refs repointed to types.js.
> - Verified green: tsc clean, eslint 0 errors, 158 tests pass.
>
> **Remaining chain — NOT restacked (needs your sequencing).** Each phase branch is built on the prior phase branch, so the force-pushes above rewrote their bases. They must be restacked serially, in order, each onto its now-rewritten parent:
>   [endojs/endo-but-for-bots#392](https://github.com/endojs/endo-but-for-bots/issues/392) phase-4 (base phase-3) → phase-5 branch → [endojs/endo-but-for-bots#394](https://github.com/endojs/endo-but-for-bots/issues/394) phase-6 (base phase-5) → [endojs/endo-but-for-bots#395](https://github.com/endojs/endo-but-for-bots/issues/395) phase-7 → [endojs/endo-but-for-bots#396](https://github.com/endojs/endo-but-for-bots/issues/396) phase-8 → [endojs/endo-but-for-bots#397](https://github.com/endojs/endo-but-for-bots/issues/397) phase-9 → [endojs/endo-but-for-bots#409](https://github.com/endojs/endo-but-for-bots/issues/409) phase-10 → [endojs/endo-but-for-bots#413](https://github.com/endojs/endo-but-for-bots/issues/413) phase-11 → [endojs/endo-but-for-bots#420](https://github.com/endojs/endo-but-for-bots/issues/420) phase-12
>   plus [endojs/endo-but-for-bots#410](https://github.com/endojs/endo-but-for-bots/issues/410) (endo gateway cli/systemd, base phase-9) and [endojs/endo-but-for-bots#412](https://github.com/endojs/endo-but-for-bots/issues/412) (distribution packaging, base phase-10).
> Note: no phase-5 PR appeared in the set ([endojs/endo-but-for-bots#394](https://github.com/endojs/endo-but-for-bots/issues/394) phase-6 bases on design/gateway-package-phase-5) — flagging in case phase-5 is a bare branch or a PR I wasn't given.
>
> Each early restack carries the same non-trivial port as [endojs/endo-but-for-bots#388](https://github.com/endojs/endo-but-for-bots/issues/388) and [endojs/endo-but-for-bots#389](https://github.com/endojs/endo-but-for-bots/issues/389): llm relocated the gateway type layout into src/types.ts, and every phase that still re-adds inline Gateway/GatewayPowers typedefs (or imports moved types from config.js/vhost.js) must be ported onto types.js, not merely conflict-resolved. Later phases whose diffs don't touch the moved types should restack more cheaply. Happy to take them one at a time — say the word (e.g. "weave 392") and I'll do the next.

- `pr981-stale-conductor-spine` — from gardener:endojs-endo-but-for-bots-pr981-conduct, reply_to `endojs-endo-but-for-bots-pr981-conduct` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/pr981-stale-conductor-spine.md)

> PR [endojs/endo-but-for-bots#981](https://github.com/endojs/endo-but-for-bots/issues/981) merged successfully, but I found a deployment/process discrepancy: its approved head 42bc7d51613 was 7 commits behind live llm (f5bceffef94). The deployed /home/kris/garden ci-wait-merge.sh lacks the freshness/rebase block present in this main2 job worktree, so it accepted old-head CI and merged via a merge commit without rebasing. Merge commit is a180fcb0997. Please deploy current main2 before the next conductor run; the current main2 spine already contains the intended pre/post-CI rebase gates.


## Spend & quota
_Trailing 7d window; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 48.7M | $861.51 _(notional, rate-card)_ | no quota set |
| Codex | 25.7M _(+804.4M cached)_ | n/a _(ChatGPT plan — no per-token $; plan-metered)_ | no quota set |

## Board
### todo (0)
(none)

### doin (10)
- [`ebfb-pr475-integrate-endo-ascii`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-pr475-integrate-endo-ascii.md) — ---
- [`endojs-endo-but-for-bots-pr282-pin-rebase-reconcile`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr282-pin-rebase-reconcile.md) — ---
- [`endojs-endo-but-for-bots-pr340-shepherd-20260816`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr340-shepherd-20260816.md) — ---
- [`endojs-endo-but-for-bots-pr389-stall-comment`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr389-stall-comment.md) — ---
- [`endojs-endo-but-for-bots-pr856-weave`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr856-weave.md) — ---
- [`endojs-endo-but-for-bots-pr877-weave`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr877-weave.md) — ---
- [`endor-run-compartment-mapper-fixture-parity`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endor-run-compartment-mapper-fixture-parity.md) — Design: compartment-mapper test-fixture parity + drift safeguard for endor-run
- [`endor-run-registry-cache-default-resolution`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endor-run-registry-cache-default-resolution.md) — Design/Build: endor-run non-workspace dependency resolution via the registry ...
- [`ironhorse-branch-regression-fixer`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ironhorse-branch-regression-fixer.md) — ---
- [`weave-base-update-and-pin-alias`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/weave-base-update-and-pin-alias.md) — ---

### tada (4862)
- [`endojs-endo-but-for-bots-pr995-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr995-gauntlet-panel-2.md) — Cost
- [`endojs-endo-but-for-bots-pr282-review-c41f9d4a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr282-review-c41f9d4a.md) — Completion report — review handler for endojs/endo-but-for-bots#282
- [`endojs-endo-but-for-bots-pr937-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr937-conduct.md) — Cost
- [`endojs-endo-but-for-bots-pr388-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr388-shepherd.md) — Diagnosis
- [`endojs-endo-but-for-bots-pr995-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr995-gauntlet-fix-1.md) — Completion report
- … and 4857 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`build-kebab-case-lint-wildcard-test262`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-kebab-case-lint-wildcard-test262.md) — _normal_ · Reconstruct the kebab-case file-name linter (endojs/endo#2947) with WILDCARD ...
- [`build-readableblob-range-attenuation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-readableblob-range-attenuation.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`drive-mystic-rollout-20260723`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/drive-mystic-rollout-20260723.md) — _normal_ · ---
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
- [`ebfb-llm-xs-daemon-bundle-reconcile`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-xs-daemon-bundle-reconcile.md) — _normal_ · ---
- [`ebfb-pr882-bootstrap-generators`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-pr882-bootstrap-generators.md) — _normal_ · ---
- [`ebfb-pr977-lint-unstick`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-pr977-lint-unstick.md) — _normal_ · State
- [`ebfb-reconcile-xsnap-pending-jobs-861-864`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-reconcile-xsnap-pending-jobs-861-864.md) — _normal_ · Reconcile the two xsnap pending-jobs fixes: adopt #864, close #861
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`endo-sturdyref-agent-surface-build-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-agent-surface-build-gauntlet.md) — _normal_ · ---
- [`endo-sturdyref-enliven-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-enliven-design.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr132-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #132
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`endojs-endo-but-for-bots-pr286-refresh`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr286-refresh.md) — _normal_ · refresh directive on endojs/endo-but-for-bots PR #286
- [`endojs-endo-but-for-bots-pr403-e97aa392`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr403-e97aa392.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #403
- [`endojs-endo-but-for-bots-pr592-cancel-in-options`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr592-cancel-in-options.md) — _normal_ · Fixer: reshape watchDirectory cancellation API (endojs/endo-but-for-bots #592)
- [`endojs-endo-but-for-bots-pr763-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr763-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #763
- [`endojs-endo-but-for-bots-pr796-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr796-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #796
- [`endojs-endo-but-for-bots-pr881-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr881-gauntlet.md) — _normal_ · Run the gauntlet: attenuated Google Sheets facets
- [`endojs-endo-but-for-bots-pr909-5e6ae075`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-5e6ae075.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #909
- [`endojs-endo-but-for-bots-pr909-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #909
- [`endojs-endo-but-for-bots-pr946-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr946-conduct.md) — _normal_ · Finalize (curate → merge) endojs/endo-but-for-bots PR #946
- [`endojs-endo-but-for-bots-pr993-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr993-shepherd.md) — _normal_ · shepherd directive on endojs/endo-but-for-bots PR #993
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`finbot-pr5-panel-20260727`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-pr5-panel-20260727.md) — _normal_ · Run the required panel for kriscendobot/finbot PR #5
- [`finbot-pr5-panel-20260801`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-pr5-panel-20260801.md) — _normal_ · Run the required merge-governance panel for kriscendobot/finbot PR #5 (curren...
- [`finbot-pr6-fix-panel-r5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-pr6-fix-panel-r5.md) — _normal_ · Fix the round-5 merge-governance panel must-fix findings for kriscendobot/fin...
- [`finbot-progress-20260730-020502-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-progress-20260730-020502-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — kriscendobot/finbot PR #5
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _normal_ · ---
- [`ironhorse-campaign-paused-20260816`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-campaign-paused-20260816.md) — _normal_ · ---
- [`ironhorse-js26-milestone-consolidation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-js26-milestone-consolidation.md) — _normal_ · ---
- [`kimi-k3-canary-20260723-c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kimi-k3-canary-20260723-c.md) — _normal_ · ---
- [`kriscendobot-agoric-sdk-pr15-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-agoric-sdk-pr15-shepherd.md) — _normal_ · shepherd (auto: red CI) on kriscendobot/agoric-sdk PR #15
- [`measure-requeue-exit-knowledge-loss`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/measure-requeue-exit-knowledge-loss.md) — _normal_ · Measure and close the cross-host gap in requeue session-resume
- [`merge-upstream-master-into-llm-20260717`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/merge-upstream-master-into-llm-20260717.md) — _normal_ · Merge upstream master into the endo-but-for-bots llm branch (propose PR -> sh...
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`minion-town-endo-b3-daemon-deploy-verify`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-endo-b3-daemon-deploy-verify.md) — _normal_ · ---
- [`minion-town-mcp-b2-first-guest-tools-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-mcp-b2-first-guest-tools-gauntlet.md) — _normal_ · ---
- [`monk-finish-gardener-rename`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/monk-finish-gardener-rename.md) — _normal_ · Finish the gardener -> monk worker-kind rename
- [`open-signup-gate-flip-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`panel-seat-tiering-gather`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/panel-seat-tiering-gather.md) — _normal_ · Panel seat tiering — 1/3: GATHER the evidence
- [`pr910-mustfix-round2-06-repanel`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/pr910-mustfix-round2-06-repanel.md) — _normal_ · PR #910 fix round 2 — child 06: panel re-run and conditional un-draft
- [`propose-merge-upstream-master-into-llm-20260801`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/propose-merge-upstream-master-into-llm-20260801.md) — _normal_ · Propose a fresh upstream-master into llm integration PR
- [`registry-immutable-byte-array-followup-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/registry-immutable-byte-array-followup-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #888
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`weave-endo-but-for-bots-pr626-stack-surgery-eval`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-endo-but-for-bots-pr626-stack-surgery-eval.md) — _normal_ · Weave endojs/endo-but-for-bots PR #626 (Phase-5 stack-surgery eval) onto llm
- [`wire-siwe-onchain-authz-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town.md) — _normal_ · Wire the chosen SIWE on-chain authorization tier into minion.town's policy layer

### deferred (top by priority; foreman auto-promotes when idle)
- [`endo-bejar-hofman-box-investigation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-bejar-hofman-box-investigation.md) — _normal_ · Investigate the Bejar-Hofman Box: reachable-only-from-roots monitoring
- [`review-improve-merge-base-pinning`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/review-improve-merge-base-pinning.md) — _normal_ · review-improve: merge-base-pinning (prevention + durable sensing)
- [`ebfb-thixotrope-drop-inert-bundle-filter`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-thixotrope-drop-inert-bundle-filter.md) — _normal_ · ---
- [`endo-daemon-sqlite-wal-limit-measurement`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-daemon-sqlite-wal-limit-measurement.md) — _normal_ · Measure the daemon SQLite WAL size policy
- [`endo-sha256-async-arm-followup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sha256-async-arm-followup.md) — _normal_ · ---
- [`ebfb-sturdyref-stack-modernize`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-sturdyref-stack-modernize.md) — _2_ · The situation
- [`endojs-endo-but-for-bots-248-build-ses-import-attributes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-248-build-ses-import-attributes.md) — _normal_ · Build: SES import attributes (design #248)
- [`local-verify-zizmor-parity`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/local-verify-zizmor-parity.md) — _low_ · local-verify: cover the zizmor workflow audit (CI parity gap)
- [`endojs-endo-but-for-bots-pr388-review-04154a91-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr388-review-04154a91-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #388 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr398-review-262cd801-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr398-review-262cd801-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #398 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr992-review-9566dff9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr992-review-9566dff9-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #992 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr282-review-c41f9d4a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr282-review-c41f9d4a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #282 (primary: endojs-endo-but-f...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`endojs-endo-but-for-bots-pr132-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-conduct.md) — awaiting `endojs-endo-but-for-bots-pr132-retcon` · Conduct (finalize -> merge) endojs/endo-but-for-bots PR #132
- [`endojs-endo-but-for-bots-pr980-node24-ci-retry`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr980-node24-ci-retry.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/980` · ---
- [`finbot-pr6-panel-r6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-pr6-panel-r6.md) — awaiting `finbot-pr6-fix-panel-r5` · Run the required merge-governance panel for kriscendobot/finbot PR #6 (round ...
- [`pr910-review-4941452327-base64-cleanup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/pr910-review-4941452327-base64-cleanup.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/475` · Remove superfluous ReadableBlob base64 machinery after byte-array work lands
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
kriscendobot-agoric-3-proposals kriscendobot-agoric-sdk kriscendobot-cosgov kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot kriscendobot-list kriscendobot-minion.town kriscendobot-moddable kriscendobot-ocapn kriscendobot-proposal-compartments kriscendobot-test262 kriscendobot-vattr97 kriscendobot-ymax-e2e kriscendobot-ymax-stdio-mcp

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 2 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 2 gardeners
- [ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/ps23): 1 gardeners
- [ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/ps23-garden-f65473ae): 8 gardeners
