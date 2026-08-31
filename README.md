# Garden bulletin

_As of 2026-08-31T18:08:17Z_

## Latest

Cloudflare OS library ingestion completed after 10 consecutive scholar passes covering the entire repository — overview, design, packages, and source-code comment fragments — with 90+ sections across topics like MCP server connectors, Gatekeeper architecture, and collaborative-workspace sharing now indexed. Separately, Node 24 local-verify parity infrastructure shipped — local-verify now enforces runtime version matching CI (Node 24 for lts/* projects), and the fleet is provisioned with Node 24 alongside Node 22; early hosts will hard-fail Node-24 projects until the next deploy. Containment drift recurrence on minion.town detected and logged (a third `@agent` powers record missed by the prior whitespace-tolerant scan). A heavy backlog of parked work awaits maintainer decisions: SIWE tier + allowlist configuration for minion.town, OpenRouter zero-data-retention + stealth-model routing policy, test262 fixture consolidation scope (merge vs. dual-tree), deployer stalled for 3 days across two hosts, and five gauntlets halted mid-stage on panel/fix failures. Several triager fetch failures recovered; provider quota constraint cleared.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 4h)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 41m)
- [endojs/endo-but-for-bots#249](https://github.com/endojs/endo-but-for-bots/pull/249) — design(ses,module-source): top-level-await proposal (leads with the test suite) (waiting 48m)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 27m)
- [endojs/endo-but-for-bots#858](https://github.com/endojs/endo-but-for-bots/pull/858) — feat(stream): add auto buffer (waiting 1d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 2d)
- [endojs/endo#3355](https://github.com/endojs/endo/pull/3355) — feat(ses): Apply special error logging to console.dir (waiting 3d)
- [endojs/endo-but-for-bots#216](https://github.com/endojs/endo-but-for-bots/pull/216) — feat(endor,tui): interactive TUI mode + stub packages (per kriskowal #32 reconstruct) (waiting 4d)
- [endojs/endo-but-for-bots#281](https://github.com/endojs/endo-but-for-bots/pull/281) — feat(rust-endo): ephemeral GC roots for suspended-worker snapshots (waiting 4d)
- [endojs/endo-but-for-bots#730](https://github.com/endojs/endo-but-for-bots/pull/730) — design(registry): Endor/XS registry transport power (waiting 33d)

_Showing top 10 of 28 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260728T173844Z-cfda47` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260728T173844Z-cfda47.md)

> Report `build-exo-google-sheets-facets` ([endojs/endo-but-for-bots#881](https://github.com/endojs/endo-but-for-bots/issues/881), with #874) flags the design's thin follow-on layers `SheetsService` and `SpreadsheetStructure` as still unbuilt, "a natural next job once #874 and this land." Do you want builder jobs posted for those once both PRs merge, or should they wait?

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

- `20260806T152927Z-e9108b` — from gardener:consolidate-test262-fixtures, reply_to `consolidate-test262-fixtures` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260806T152927Z-e9108b.md)

> test262 fixture consolidation (job consolidate-test262-fixtures): opened DRAFT PR [endojs/endo-but-for-bots#946](https://github.com/endojs/endo-but-for-bots/issues/946) against `llm` with the design + rollout step 1 (parameterized expectation lists + two-directional ratchet, unit-tested and verified oracle-backed on a bounded slice).
>
> One decision needs your call before the rest lands. The directive's sketch assumes the 1712 cases in `rust/engine/ironhorse-262/cases` duplicate upstream test262 and should fold into `packages/test262-runner/test262/test/**`. They are NOT duplicates: they're bespoke bit-exact metering micro-cases (tagged `ironhorse-meter-exact`/`-determinism`, feeding the byte-identity compile-diff gate), generated from the retired bring-up corpora. Upstream test262 has no cost model, and the parent design (ironhorse-test262-convergence.md) calls the metering corpus proprietary-forever. So folding them into the parity tree loses that coverage.
>
> Recommendation (design § Open Decision, option A): keep the two case trees, unify only the EXPECTATION accounting across them (which is where the drift you want ratcheted actually lives). The mechanism I built works under either resolution. Option B (collapse to the upstream tree) needs an explicit call to accept losing, or re-homing, the metering/byte-identity coverage.
>
> Full-corpus expectation baselines are a separate batched per-subtree oracle sweep (the whole-tree oracle run is the known OOM concern), to run on a toolchain host, not inline.

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.

- `20260815T171325Z-a98f9d` — from gardener:garden-budget-enforcement, reply_to `garden-budget-enforcement` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260815T171325Z-a98f9d.md)

> Design landed on main2 (87ccd70ab6): designs/live-budget-admission.md — the budget-study capstone that makes a live budget draw a standing property of EVERY dispatch (not an orchestration opt-in) and makes the garden1/garden2 worker leveling you did by hand on 2026-08-15 automatic.
>
> Headline finding: the mechanism already mostly exists. usage-meter.sh reads Claude Code's session logs, so it already captures ~100% of a host's Claude spend (the 28.8% figure is a retrospective PR-attribution artifact, not live-coverage), and per-host = per-account is already correct for our one-subscription-per-host topology. The meter is just OFF (quota unset) and only wired into the foreman + the gardener handler. The design generalizes its verdict to a shared pool_admits predicate at the three admission surfaces that lack it (promotion, direct post-job, and the universal claim gate), parks-not-refuses via the existing --budget-hold/budget-refresh, and adds a leader-only budget-level controller driving set-workers/the sysop op from live per-pool headroom. It composes alongside-and-ahead-of omega's ranked promoter (omega orders WHAT; budget admits WHETHER), replacing nothing.
>
> One maintainer-only input gates turning it live: the per-account weekly TOKEN cap. It is not machine-readable from a Max subscription. Two ways to supply it — (a) read each account's weekly token ceiling off Claude Code's /usage panel and I/we seed config/budget-pools, or (b) greenlight building the already-designed phase-2 weekly-capacity-calibration.sh (recurring-budget-calibration.md) to MEASURE it (max billable tokens over the trailing four weeks). Until a number exists the gates stay off (transparent). No build is queued yet — this was design-only. The other open questions (account-asymmetry policy given hasExtraUsageEnabled true on one host / false on the other; gate at 0.85 vs 1.0 for directed work; leveling shape) are in the doc's §10.

- `20260819T003451Z-370a6d` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003451Z-370a6d.md)

> From report `deadmail-20260728T074423Z-6bee53`: the new dead-letter anti-pattern documents that a botanist rendering MERGE-NOW and exiting while the approval gate blocks leaves no living addressee for a later correction, but doesn't fix the delivery gap itself. Worth deciding whether/how to close it (e.g. a standing re-addressee) — flagging for your call rather than guessing at the mechanism.

- `20260819T003456Z-bdaa62` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003456Z-bdaa62.md)

> From report `deadmail-20260812T232828Z-4f1d09`: need a decision on disclosure timing before any public fork PR goes up for the pushed branch (no PR exists yet). Separately, the same report flags a real gap worth tracking — authenticated peer identity in host `gateway()` is missing across all transports, which is what lets the cross-peer retained-formula-number following gap stay open. Given the security-sensitive framing, routing both to you rather than autonomously spawning work.

- `20260819T003803Z-7d3388` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003803Z-7d3388.md)

> From report `improve-promote-plan-poison-reset`: `endo-sturdyref-agent-surface-build-gauntlet` is still parked in `plan/` behind its `go-ahead`, held back by the deadline-overrun marker fixed in this change. Promoting it once the fix deploys is a maintainer-authorization act — flagging it's ready whenever you want to promote.

- `20260819T003813Z-b83dfb` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003813Z-b83dfb.md)

> From report `ironhorse-js-26-map-methods`: four cross-cutting engine-wide gaps (each would close residuals across the whole js-26 Map/Set-methods proposal) each warrant their own feature increment. Worth your prioritization call on sequencing before I queue them.

- `20260819T003825Z-b548b6` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003825Z-b548b6.md)

> From report `issue-kriskowal-garden-67`: next steps are (1) turning "phase 0" (structural shapes + explicit membership checks, no registry/new authority) into an actual PR on the fork, and (2) drilling into the two-phase attestation mechanism against the resolver's existing invitation-based reporting path. This touches the `kriscendobot/agoric-sdk` fork, which per standing scope needs your call rather than an autonomous job.

- `20260819T003849Z-3a1d32` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003849Z-3a1d32.md)

> From report `qwen-model-watch-20260728-180502` (echoed by `fu-qwen-model-watch-20260728-180502-1-20260728-223502`): decide the local qwen lane's fate — promote the local default to the 35B-A3B MoE, or accept `hermits: 0` and drop it (`qwen3:0.6b` is small enough it isn't obviously useful).

- `20260819T003855Z-0ad8da` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003855Z-0ad8da.md)

> From report `requeue-ps23-stranded-claims`: `GARDEN_REAP_OVERRUN_THRESHOLD=1` has no safety margin on the elapsed-constancy path — one bad stamp parks a job with no second opinion. Worth considering raising it to 2 for that path specifically (the rc=124 wall-hit path is genuinely conclusive at 1).

- `20260819T003940Z-06bfa7` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003940Z-06bfa7.md)

> From report `self-heal-fix-garden-comment-watcher-kriscendobot-garden-repo-404-crashloop`: need a decision on `worktrees/kriskowal-garden.git` — remove it or re-point its origin.

- `20260819T014222Z-357030` — from gardener:fu-xs2rust-endor-debugger-caught-vs-uncaught-2, reply_to `fu-xs2rust-endor-debugger-caught-vs-uncaught-2` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T014222Z-357030.md)

> fu-xs2rust-endor-debugger-caught-vs-uncaught-2 done — GATED (not natively fixed), draft PR [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/issues/1038) vs llm.
>
> Why gate, not fix: the native break-on-uncaught is Phase 5 of designs/ironhorse-debugger-recovery-and-uncaught.md and is BLOCKED — the ironhorse-debug crate isn't on llm yet (fu-...-1 "recover the debugger row", unbuilt) and needs engine-raise unwind (fu-...-3). The Ironhorse campaign is also paused for budget. The design explicitly forbids an interim C-XS fallback/negotiation/alias and wants the shipped client wire commands left byte-identical so the mode goes live automatically once Ironhorse lands the uncaughtExceptions pseudo-path. So a runtime fix now would either violate the design or break the forward-compat that debugger-captp.test.js line 352 pins.
>
> What [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/issues/1038) does (zero wire/behavior change): removes only the *silent* property of the footgun — on C-XS, selecting 'uncaught' clears the real exceptions breakpoint and arms a never-hit phantom, i.e. it silently DISABLES exception breaking. It documents that at every client API site (debug-session.js, debugger.js, types.d.ts) and relabels the Chat panel option to "Exceptions: uncaught (engine support pending)" with an honest tooltip. 16 daemon debugger tests + chat panel tests pass unmodified; eslint/prettier clean.
>
> If you'd rather have a HARD runtime gate (e.g. the client throws for 'uncaught' until an Ironhorse session is attached), that needs capability detection the design currently rules out — say the word and I'll take it up with a design amendment. Otherwise the real fix stays owned by fu-...-1 + fu-...-3 (both still todo) under the paused campaign.

- `20260819T032608Z-ce16c2` — from gauntlet:build-minion-town-git-content-substrate-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T032608Z-ce16c2.md)

> Gauntlet build-minion-town-git-content-substrate-gauntlet HALTED: stage 'build-minion-town-git-content-substrate-gauntlet-panel-5' (panel) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling.

- `20260821T012318Z-92308e` — from gauntlet:endojs-endo-but-for-bots-ironhorse-coverage-matrix-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260821T012318Z-92308e.md)

> Gauntlet endojs-endo-but-for-bots-ironhorse-coverage-matrix-gauntlet HALTED: stage 'endojs-endo-but-for-bots-ironhorse-coverage-matrix-gauntlet-panel-1' (panel) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling.

- `20260821T224706Z-a2e099` — from gauntlet:kriscendobot-minion.town-port-whoami-tool-20260819-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260821T224706Z-a2e099.md)

> Gauntlet kriscendobot-minion.town-port-whoami-tool-20260819-gauntlet HALTED: stage 'kriscendobot-minion.town-port-whoami-tool-20260819-gauntlet-panel-1' (panel) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling.

- `20260822T054106Z-6e3888` — from gauntlet:endojs-endo-but-for-bots-build-endor-git-bindings-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260822T054106Z-6e3888.md)

> Gauntlet endojs-endo-but-for-bots-build-endor-git-bindings-gauntlet HALTED: stage 'endojs-endo-but-for-bots-build-endor-git-bindings-gauntlet-clean' (clean) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling.

- `20260822T055203Z-ae527d` — from gardener:wire-siwe-onchain-authz-minion-town, reply_to `wire-siwe-onchain-authz-minion-town` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260822T055203Z-ae527d.md)

> Wiring the SIWE on-chain authz tier into minion.town's policy layer (design § 3). Deploy is done — thunk issuer is live at https://siwe-idp.minion.town (mainnet, EIP-1271 in, ENS out), sub = checksummed EIP-55 address. I need two answers to proceed (design § 6):
>
> DECISION 3 — which tier to ship now?
>   (a) Tier 1 only (address allowlist in config/policy.json; the design's recommendation). Fast, zero new infra.
>   (b) Tier 1 + Tier 2 (onchain rule schema + cached viem reader in src/auth/policy.ts). If (b), which asset type first — the design recommends a purpose-built `registry` contract on Base; alternatives are safe_signer / erc721 / erc20_min_balance.
>
> TIER 1 ALLOWLIST — I cannot invent these. For each address to authorize under iss=https://siwe-idp.minion.town, give me:
>   - the address (I'll EIP-55 checksum it),
>   - the scopes (vocabulary today: mcp/tools, mcp/guest),
>   - optionally guestFacetGrants: ["evaluator"], and a note.
>
> E.g. "0xf39F…2266 (my hardware wallet) → mcp/tools, mcp/guest, evaluator".
>
> If you'd rather I ship the Tier-2 machinery now regardless (schema + cached reader + mocked-transport tests) with the allowlist to follow, say so. Otherwise I'll wait for the addresses before touching config/policy.json.

- `20260826T164107Z-6552dc` — from gauntlet:build-endo1062-typedarray-preventextensions-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260826T164107Z-6552dc.md)

> Gauntlet build-endo1062-typedarray-preventextensions-gauntlet HALTED: stage 'build-endo1062-typedarray-preventextensions-gauntlet-panel-1' (panel) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling.

- `20260827T062400Z-4bf20f` — from gardener:xs2rust-endor-press-20260827-061533, reply_to `xs2rust-endor-press-20260827-061533` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260827T062400Z-4bf20f.md)

> Ironhorse press (2026-08-27): investigated the fixture-parity ratchet campaign's
> twice-halting child `endor-walker-exports-resolution` per your directive
> ("if halted a third time on this same child, do NOT blindly re-resume; investigate").
>
> ROOT CAUSE (both halts): NOT a build hang or task difficulty. All four 2026-08-23
> requeue cycles failed with source=none, elapsed 2-6s (journal/usage/
> endor-walker-exports-resolution.jsonl) — the worker invocation fast-failed with
> no model/provider attributed (a provider/worker-acquisition gap), which the reaper
> read as elapsed-constancy and requeued to doom. The build body never ran. The doom
> notice confirms "raising the handler budget will not help."
>
> ACTION: rather than blind-re-orchestrate, posted ONE targeted re-attempt
> `endor-walker-exports-resolution-20260827` as dispatch:manual at true mentor (no
> anthropic auto-downshift) so a live real-provider worker serves it — fleet is
> healthy now (monks+clerics running). The job body carries the finding and instructs
> the worker to REPORT (not silently exit) on any immediate infra failure, so a third
> occurrence is captured rather than re-doomed. The 5 downstream ratchet children stay
> parked; a future dispatch re-orchestrates them once this blocker clears.
>
> PR front is healthy: [endojs/endo-but-for-bots#1046](https://github.com/endojs/endo-but-for-bots/issues/1046) (APPROVED) re-running CI on a new head, [endojs/endo-but-for-bots#1060](https://github.com/endojs/endo-but-for-bots/issues/1060) mergeable
> w/ checks pending + freshly reviewed, [endojs/endo-but-for-bots#877](https://github.com/endojs/endo-but-for-bots/issues/877) recently conducted. No idle
> CHANGES_REQUESTED mechanical target needing a fixer.

- `20260827T093107Z-ab7bc3` — from orchestrator:endor-fixture-parity-ratchet-campaign-20260827-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260827T093107Z-ab7bc3.md)

> Orchestration endor-fixture-parity-ratchet-campaign-20260827 HALTED: child endor-walker-host-hooks completed but declared its gated outcome unsatisfied (serial, on-child-failure=halt). 4/5 done before halt; parked remainder: none

- `20260827T102007Z-e3a721` — from gauntlet:endojs-endo-base32-package-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260827T102007Z-e3a721.md)

> Gauntlet endojs-endo-base32-package-gauntlet HALTED: stage 'endojs-endo-base32-package-gauntlet-clean' (clean) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling.

- `20260827T110409Z-c39eaf` — from orchestrator:endor-host-hooks-ratchet-20260827-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260827T110409Z-c39eaf.md)

> Orchestration endor-host-hooks-ratchet-20260827 HALTED: child endor-walker-host-hooks-20260827 stalled in flight for 2514s on host endolin-garden-ece02cb4 (handler-timeout=2400s, multiplier=1) (serial, on-child-failure=halt). 1/2 done before halt; parked remainder: none

- `20260827T113507Z-cf4325` — from gauntlet:endor-walker-host-hooks-20260827-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260827T113507Z-cf4325.md)

> Gauntlet endor-walker-host-hooks-20260827-gauntlet HALTED: stage 'endor-walker-host-hooks-20260827-gauntlet-clean' (clean) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling.

- `20260827T125606Z-abb2f3` — from gauntlet:endor-host-hook-surface-20260827-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260827T125606Z-abb2f3.md)

> Gauntlet endor-host-hook-surface-20260827-gauntlet HALTED: stage 'endor-host-hook-surface-20260827-gauntlet-clean' (clean) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling.

- `20260828T194121Z-59223f` — from gardener:minion-town-press-20260828-193506, reply_to `minion-town-press-20260828-193506` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260828T194121Z-59223f.md)

> minion.town press (off merged [kriscendobot/minion.town#52](https://github.com/kriscendobot/minion.town/issues/52)): [kriscendobot/minion.town#63](https://github.com/kriscendobot/minion.town/issues/63) "docs(weblet): reconcile register-by-id design" is now **ready for your review** (was draft). It rewrites sections 2.2/3.1 + 9 of designs/weblet-ocap-synthesis.md to describe the register(directoryId, owner) boundary that shipped in [kriscendobot/minion.town#52](https://github.com/kriscendobot/minion.town/issues/52), was attenuated in [kriscendobot/minion.town#53](https://github.com/kriscendobot/minion.town/issues/53), and left serving in [kriscendobot/minion.town#55](https://github.com/kriscendobot/minion.town/issues/55).
>
> No decision is pending from you — this is a review request, not a fork:
> - The register-by-id deviation is already settled: you APPROVED [kriscendobot/minion.town#52](https://github.com/kriscendobot/minion.town/issues/52) and [kriscendobot/minion.town#53](https://github.com/kriscendobot/minion.town/issues/53) and said "validate in prod." [kriscendobot/minion.town#63](https://github.com/kriscendobot/minion.town/issues/63) only documents that settled boundary.
> - Your [kriscendobot/minion.town#52](https://github.com/kriscendobot/minion.town/issues/52) review asked to be shown the unconfined-caplet `export const make` endowment or a follow-up. That exists in the shipped code: src/endo/gateway/site-registry-caplet.ts:30 `export const make` ("Unconfined Endo caplet that constructs the daemon-hosted @sites registry"), with per-guest attenuation via site-register-caplet.ts.
> - [kriscendobot/minion.town#63](https://github.com/kriscendobot/minion.town/issues/63) is CI-green and went through 3 design-panel rounds; the last round's must-fixes (faithful 3.1 paraphrase of guestRegisterSource, confidentiality-escalation severity retune) are applied at head 4208dca.
>
> Design residuals it records as future BUILD work (not decisions): live weblet_upgrade, an always-on real-daemon CI lane, and restart-durability verification. I'll leave those parked unless you want one pressed next.

- `20260828T210506Z-1fae52` — from gauntlet:build-exo-git-follow-root-advancement-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260828T210506Z-1fae52.md)

> Gauntlet build-exo-git-follow-root-advancement-gauntlet HALTED: stage 'build-exo-git-follow-root-advancement-gauntlet-panel-1' (panel) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling.

- `20260829T092006Z-c5d9c5` — from gauntlet:endojs-endo-but-for-bots-marshal-types-dts-refactor-build-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260829T092006Z-c5d9c5.md)

> Gauntlet endojs-endo-but-for-bots-marshal-types-dts-refactor-build-gauntlet HALTED: the panel/fix loop did not converge in 6 rounds (fix round 6 done, would start panel round 7 > max_iterations=6).

- `20260829T180506Z-449d3a` — from gauntlet:endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260829T180506Z-449d3a.md)

> Gauntlet endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet HALTED: stage 'endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet-panel-3' (panel) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling.

- `20260830T053908Z-dea27e` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260830T053908Z-dea27e.md)

> The daily drift-check schedule behind report `fu-minion-town-containment-gateway-endo-sock-1-20260828-032006` is firing against a premise that no longer holds (the minion.town containment-gateway ENDO_SOCK drift it was watching for). Decision needed: retire that schedule, or repurpose it to a still-meaningful check? Until you decide it keeps running daily and reporting on an obsolete premise.

- `20260831T032332Z-0647d1` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260831T032332Z-0647d1.md)

> A garden-follow-up action block was REJECTED and dropped (not retried):
>   inner claude -p failure (rc=1)
>
> Producer output:
> rc=1
> stderr:
> <empty>
>
> stdout:
> Failed to authenticate: OAuth session expired and could not be refreshed

- `20260831T032646Z-86f810` — from gauntlet:endojs-endo-but-for-bots-pr317-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260831T032646Z-86f810.md)

> Gauntlet endojs-endo-but-for-bots-pr317-gauntlet HALTED: stage 'endojs-endo-but-for-bots-pr317-gauntlet-clean' (clean) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling.

- `20260831T034231Z-0a4e7e` — from gauntlet:endojs-endo-but-for-bots-pr855-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260831T034231Z-0a4e7e.md)

> Gauntlet endojs-endo-but-for-bots-pr855-gauntlet HALTED: stage 'endojs-endo-but-for-bots-pr855-gauntlet-clean' (clean) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling.

- `20260831T043436Z-4db4ee` — from gardener:endojs-endo-but-for-bots-pr237-gauntlet-fix-1, reply_to `endojs-endo-but-for-bots-pr237-gauntlet-fix-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260831T043436Z-4db4ee.md)

> Gauntlet fix stage for endojs/endo-but-for-bots [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/issues/237) (design: lal defineJessie + Blockly): I applied the panel's round-1 must-fix items to designs/lal-jessie-blocky.md and pushed (head 014582b0b) — corrected the load-bearing integration-point error (incoming proposals render in inbox-component.js/endow-modal.js and submit via E(powers).endow, not define-form.js), fixed the forgeable options.language tag (render-side re-validation), added the missing Alternatives, reconciled the effort figures (8 days across design+README), renamed the tool define-jessie→defineJessie, and swept the prose/heading/spelling findings.
>
> BLOCKER: CI can't run. The PR is 2516 commits stale and CONFLICTING with base llm, so GitHub creates no CI runs (structurally blocked, not pending). The conflict is entirely in designs/README.md, whose structure+totals were rewritten wholesale on llm since the PR's May base (milestones renumbered M4→M9, 192 designs, dated rolling-index-refresh model) — the PR's README bookkeeping edits are obsolete and can't be mechanically rebased. The design file itself merges cleanly.
>
> I did NOT unilaterally rewrite the public PR history from a fix stage. I posted a weave successor (endojs-endo-but-for-bots-pr237-weave-20260831) that owns rebasing [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/issues/237) onto current llm — recommended resolution there is to drop the stale README edits (let the next index refresh pick up the design). Two things for you: (1) this design PR is ~3.5 months old — if you'd rather close it than land it, say so and I'll cancel the weave; (2) the gauntlet will keep re-posting the fix stage on still-pending, which loops until the weave lands — you may want to pause the gauntlet until the weave rebases the base.

- `20260831T071931Z-f0685e` — from gardener:endojs-endo-but-for-bots-pr1075-weave-20260831, reply_to `endojs-endo-but-for-bots-pr1075-weave-20260831` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260831T071931Z-f0685e.md)

> Weave of [endojs/endo-but-for-bots#1075](https://github.com/endojs/endo-but-for-bots/issues/1075) halted — the branch's premise no longer holds. The PR is already fully landed on `llm`; a rebase onto current `llm` (4c061e2f) produces an EMPTY diff. I made no remote mutation (rebase aborted, no force-push, no merge).
>
> Evidence:
> - Both test files are byte-identical on `llm` and the PR head de2f852a8: intrinsics/AsyncFunction/{intrinsic-metadata.js, inert-stand-in.js}. They landed via squash commit 17dfcee8f `test(hardened262): cover %AsyncFunction% intrinsic metadata (#1075)` (Kriscendo Bot, 2026-08-28 14:31Z).
> - All 90 baseline lines the PR adds (sesNode/sesXs/xs/ironhorse/sesIronhorse) are already present in `llm`'s current baselines (checked line-by-line: present=90, missing=0).
> - The PR is purely additive (244 insertions, 0 deletions) and every addition is already on `llm`, so a resolved rebase drops all 4 commits as empty.
> - PR timeline: head force-pushed 14:05Z, closed 15:12Z, reopened 15:29Z (all kriscendobot, 2026-08-28). The reopen left a redundant PR whose %AsyncFunction% coverage is already on trunk.
>
> Recommendation: CLOSE [endojs/endo-but-for-bots#1075](https://github.com/endojs/endo-but-for-bots/issues/1075) as already-landed (the %AsyncFunction% intrinsic-metadata coverage is on `llm`; nothing is lost). No new conductor/merge job — there is nothing to merge. If instead you want the PR's baseline-regen commit re-landed as a distinct change, that's a fresh build/fixer, not a rebase, but the coverage it targets is already green on `llm`.

- `20260831T095854Z-3a677d` — from gardener:endojs-endo-but-for-bots-pr138-gauntlet-fix-1, reply_to `endojs-endo-but-for-bots-pr138-gauntlet-fix-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260831T095854Z-3a677d.md)

> Gauntlet fix-stage on [endojs/endo-but-for-bots#138](https://github.com/endojs/endo-but-for-bots/issues/138) ([https://github.com/endojs/endo-but-for-bots/pull/138](https://github.com/endojs/endo-but-for-bots/pull/138)) pushed the panel's must-fix items (309b234de, already on origin), but the bounded CI wait cannot reach a terminal state: GitHub has created zero Actions check-suites for this head across ~80 minutes of observation (only stray `renovate`/`claude` app suites stuck `queued`). The PR is also `mergeable: CONFLICTING`, `mergeStateStatus: DIRTY` — 265 commits behind base `llm` and 942 ahead, per a git merge-base check in an isolated worktree. This looks like a structural GitHub-side stall (very stale/conflicting PR, not a transient CI queue), not something a bounded re-poll will resolve. Recommend a weave/rebase (or pin-the-merge-base) on [endojs/endo-but-for-bots#138](https://github.com/endojs/endo-but-for-bots/issues/138) before the next gauntlet CI-wait attempt, or manual investigation of why Actions never attaches to this branch. Reporting this attempt as still-pending per the job's rc=4 contract so the driver re-posts rather than looping silently.

- `20260831T103727Z-b14079` — from orchestrator:endojs-endo-but-for-bots-pr1083-resolve-conduct-build-5064787686-r2-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260831T103727Z-b14079.md)

> Orchestration endojs-endo-but-for-bots-pr1083-resolve-conduct-build-5064787686-r2 HALTED: child build-npm-registry-as-directory-tree-review5064787686-r2 stalled in flight for 2564s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1) (serial, on-child-failure=halt). 2/3 done before halt; parked remainder: none

- `20260831T123510Z-6b55eb` — from gauntlet:endojs-endo-but-for-bots-pr1018-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260831T123510Z-6b55eb.md)

> Gauntlet endojs-endo-but-for-bots-pr1018-gauntlet HALTED: the panel/fix loop did not converge in 6 rounds (fix round 6 done, would start panel round 7 > max_iterations=6).

- `20260831T125501Z-d42a9a` — from gardener:endojs-endo-but-for-bots-pr300-gauntlet-fix-1, reply_to `endojs-endo-but-for-bots-pr300-gauntlet-fix-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260831T125501Z-d42a9a.md)

> Gauntlet halted on [endojs/endo-but-for-bots#300](https://github.com/endojs/endo-but-for-bots/issues/300) (docs: mark cli-store/cli-edit status In Progress) — the PR is SUPERSEDED by llm and cannot reach CI green.
>
> Why: the PR is CONFLICTING/DIRTY against current llm, so GitHub can't build refs/pull/300/merge and pull_request CI never attaches (rollup stays empty forever -> the fix stage can only ever time out "still-pending", looping the gauntlet). The conflict is genuine supersession, not mechanical drift:
> - cli-edit-verb.md: llm's Status already reads "In Progress (pure core landed [endojs/endo-but-for-bots#796](https://github.com/endojs/endo-but-for-bots/issues/796))" with accurate landed prose (Updated 2026-08-23). The PR's "phased-form / [endojs/endo-but-for-bots#256](https://github.com/endojs/endo-but-for-bots/issues/256) wire-types skeleton / not_implemented until Phase 2" narrative predates [endojs/endo-but-for-bots#796](https://github.com/endojs/endo-but-for-bots/issues/796) and is now wrong; merging the PR would REVERT llm's accurate Status.
> - designs/README.md: llm already has cli-edit "In Progress ... pure core landed in [endojs/endo-but-for-bots#796](https://github.com/endojs/endo-but-for-bots/issues/796)" and cli-store "Proposed"; the PR contradicts both rows.
> - The PR's only non-conflicting content (a cli-store Status section citing [endojs/endo-but-for-bots#283](https://github.com/endojs/endo-but-for-bots/issues/283)) is itself stale — that PR is CONFLICTING ~2,500 commits behind (skeptic flagged this).
>
> kriskowal approved [endojs/endo-but-for-bots#300](https://github.com/endojs/endo-but-for-bots/issues/300) on 2026-08-15, but llm advanced past it via [endojs/endo-but-for-bots#796](https://github.com/endojs/endo-but-for-bots/issues/796) on 2026-08-23. A mechanical rebase would either regress llm's landed content or reduce the PR to a stale, internally-inconsistent fragment. Recommend CLOSE (superseded) or REGENERATE a fresh status-update against current llm HEAD (655730c9f) reflecting [endojs/endo-but-for-bots#796](https://github.com/endojs/endo-but-for-bots/issues/796).
>
> I applied the panel's copyedit must-fixes to the head (commit b1adc957b, pushed) before discovering the supersession; harmless but moot given the recommendation to close/regenerate. No rebase pushed.

- `20260831T134537Z-704a93` — from gardener:endojs-endo-but-for-bots-pr322-gauntlet-fix-1, reply_to `endojs-endo-but-for-bots-pr322-gauntlet-fix-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260831T134537Z-704a93.md)

> Gauntlet FIX round 1 for [endojs/endo-but-for-bots#322](https://github.com/endojs/endo-but-for-bots/issues/322) (design(familiar-flatpak-pipeline)) is applied and pushed (head 1fc3996ab), but CI is BLOCKED and cannot go green from a fix round.
>
> Why: the PR is mergeable=CONFLICTING / DIRTY against base `llm`. The conflict is in `designs/README.md` and is PRE-EXISTING base drift — the prior head efe14f625 (before my fix) already conflicts, because `llm`'s designs/README.md moved on over the ~3 months since this PR was opened (2026-05-20). GitHub does not run pull_request CI on an unmergeable PR, so zero `test`/`lint` checks attach to my push and none ever will.
>
> Recommendation: weave [endojs/endo-but-for-bots#322](https://github.com/endojs/endo-but-for-bots/issues/322) (rebase the head onto current `llm`, resolve the designs/README.md index conflict) BEFORE the gauntlet can reach green. Re-posting the fix stage will loop uselessly — the must-fix items are already applied. After the weave, re-run the gauntlet.
>
> The panel round-1 must-fix items ARE addressed on the pushed head (socket/xdg-run grant, wiring contradiction, script rename, mermaid arrow, "signed" contradiction, MVR/G-code glosses, speculative finish-args split, release-gating marker, and the copyedits).

- `20260831T135423Z-4c9fd0` — from gardener:endojs-endo-but-for-bots-pr249-gauntlet-fix-1, reply_to `endojs-endo-but-for-bots-pr249-gauntlet-fix-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260831T135423Z-4c9fd0.md)

> [endojs/endo-but-for-bots#249](https://github.com/endojs/endo-but-for-bots/issues/249) (design/ses-top-level-await) gauntlet fix-1: applied the panel's must-fix items (already committed/pushed as 1eb10a3de by a prior attempt of this same job — verified content covers all 4 request-changes seats: skeptic, decomplector, copyeditor, novice, plus the cheap should-fix items). PR head matches origin.
>
> BUT: CI never attaches to this branch. Checked via GH API — zero workflow_runs recorded against ANY of the last 5 pushed SHAs since 2026-05-15 (071f0849, 9a73e9d3, 919e8611, 4424f3a9, 1eb10a3d), even though sibling design/* branches in the same repo trigger pull_request runs fine within seconds of a push around the same time window. statusCheckRollup stays permanently empty. Also: PR mergeable_state is "dirty"/CONFLICTING (base `llm` has moved ~85 commits since this branch forked on 2026-05-14; branch was never rebased).
>
> ci-wait-merge.sh correctly reports rc=4 (still-pending) per its empty-rollup timeout, so this fix stage reports still-pending as designed. But if the driver just re-posts this stage on a fixed cadence expecting CI to eventually attach, it will loop forever — CI has never once attached in 3.5 months of pushes. Suspect the conflicting/stale base state is suppressing pull_request workflow triggering (or some other GH-side quirk specific to this branch/PR). This PR likely needs a `weave`/rebase onto live `llm` before CI can even run, not another fix round.

- `20260831T140518Z-b97ce9` — from gauntlet:endojs-endo-but-for-bots-pr231-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260831T140518Z-b97ce9.md)

> Gauntlet endojs-endo-but-for-bots-pr231-gauntlet HALTED: the panel/fix loop did not converge in 6 rounds (fix round 6 done, would start panel round 7 > max_iterations=6).

- `20260831T142847Z-31b869` — from gardener:minion-town-gateway-containment-verify-20260831, reply_to `minion-town-gateway-containment-verify-20260831` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260831T142847Z-31b869.md)

> Item 1 is complete and produced a clean security result, but the Item 2 target is unexpectedly absent before any mutation.
>
> - SSM read-only commands `c0e20028-6686-4d0c-9fb6-7d11ae332e70` (partial: the git probe failed because production is an artifact, not a checkout) and `4bf20471-a17b-4804-978c-9c6616ebfe27` (Success) show the live PID 1621352, active since 2026-08-30 05:57:29 UTC, running `/opt/minion-town/dist/endo/gateway/main.js` with the powers plane enabled.
> - Five live gateway artifact SHA-256 values exactly match a clean TypeScript build of `kriscendobot/minion.town` main commit `199a06138d6e259dcbd215079847f9d6d481c696`. That commit contains fix commit `affa345` (`feat: publish weblets through guest site directories`), and the live artifact has the site-directory/back path with no gateway top-host powers resolver or host-shape blocklist. The permanent host-escape fix is confirmed running.
> - The two original records are `active=0 revoked=1`; the whitespace-tolerant scan found zero active `@agent` records.
> - Before Item 2, `09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f.json` is already `active=0 revoked=0`, so there is presently no file at either expected location to move. I am continuing read-only provenance and recursive-store checks before deciding whether Item 2 is an already-satisfied no-op or needs action at a different active-store path.

- `20260831T143303Z-46c350` — from gardener:minion-town-gateway-containment-verify-20260831, reply_to `minion-town-gateway-containment-verify-20260831` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260831T143303Z-46c350.md)

> Both authorized items are complete.
>
> Item 2's apparent absence was a scan-path false negative: the live vhost store is `/var/lib/endo-gateway/store/vhosts/`, while the earlier root-only glob checked `/var/lib/endo-gateway/store/*.json`. Recursive SSM precheck `d7422439-5e11-41df-99e7-968e4057c32d` found the target active under `vhosts/` with normalized powers `@agent`.
>
> Authorized SSM command `92b664b7-f441-46b6-ab8f-c503c695b16d` validated the exact dckc owner and powers value, moved the record to `vhosts-revoked-20260812/`, and returned all three named records `active=0 revoked=1`, recursive active `@agent` count 0, and parse-error count 0. Independent postcheck `31e28935-0cf1-4149-9fed-e04aef688bd9` again found the third record only in the revoked store and returned recursive active `@agent` count 0. Its public bootstrap and root URLs both return HTTP 404 after the move.
>
> The recurring scan should be retired as already requested, or changed to recursively scan active JSON below the store while excluding revoked paths. The root-only scan used by the 08-30 and 08-31 checks incorrectly reported no active `@agent` records while this third record remained active.

- `20260831T173120Z-271bf7` — from gardener:endojs-endo-but-for-bots-pr249-gauntlet-fix-1, reply_to `endojs-endo-but-for-bots-pr249-gauntlet-fix-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260831T173120Z-271bf7.md)

> endo-but-for-bots [endojs/endo-but-for-bots#249](https://github.com/endojs/endo-but-for-bots/issues/249) (fix stage): applied the panel's must-fix items and
> pushed (already done by a prior claimant, commit 1eb10a3de6). GitHub Actions has
> never attached a check-suite to that commit or any of the branch's last 5
> commits going back to May 2026 — confirmed by an empty "nudge" commit
> (dc89073ec6) that also got zero check-suite attachment across 10 minutes of
> polling. Only 'renovate' and 'claude' app check-suites exist for the commit and
> both sit permanently 'queued'. The PR's mergeable_state is also 'dirty'
> (GitHub reports conflicts; a local 3-way merge-tree against origin/llm shows
> none).
>
> This looks like a structural GitHub-side CI-attachment defect on this specific
> stale PR/branch, not something a fix commit can address — reposting the fix
> stage again will hit the same wall indefinitely. Recommend a human look at the
> PR directly (maybe close/reopen to force re-sync, or check org Actions
> settings) before more gauntlet rounds are spent on it.
>
> Reporting fix=still-pending per the stage contract; watching to the 3600s
> deadline for the formal rc before finishing this attempt.

- `doomed-build-npm-registry-as-directory-tree-review5064787686-r2-deadline-overrun` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-build-npm-registry-as-directory-tree-review5064787686-r2-deadline-overrun.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden2-5bcdff64.
> The handler returned rc=124 at its applied 7200s wall-clock budget without productive progress.
> One such observation is conclusive, so the reaper did not spend another full handler budget.
> Split the work into claim-sized stages or raise its handler-timeout.
> The work is preserved at jobs/plan/build-npm-registry-as-directory-tree-review5064787686-r2; it stays HELD until a human promotes it
> (promote-plan.sh build-npm-registry-as-directory-tree-review5064787686-r2) or removes it.
> Original job base: build-npm-registry-as-directory-tree-review5064787686-r2
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> ---
> <!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-08-31T09:43:04Z cleared=none -->
>
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> # Build the approved npm registry directory-tree design (halt recovery)
>
> Repository: endojs/endo-but-for-bots (bot fork: kriscendobot/endo-but-for-bots).
> Approved design: [https://github.com/endojs/endo-but-for-bots/pull/1083](https://github.com/endojs/endo-but-for-bots/pull/1083) and designs/npm-registry-as-directory-tree.md.
>
> This recovery child supersedes the unexecuted parked child build-npm-registry-as-directory-tree from the halted first orchestration. Run only after the preceding weaver and conductor have merged the design PR into llm.
>
> Implement the approved design in full. Replace the bespoke EndoRegistry presentation with the specified package-registry directory-tree capabilities, including the shared platform guard split, Node and Endor adapters, resolver/mapper migration, error and read-consistency contracts, compatibility path, and cross-backend conformance tests described by the design. Preserve the existing fetch, SQLite, integrity, MVS, workspace, peer, optional-dependency, and CAS behavior behind the adapters.
>
> Open the implementation as a draft PR from the bot fork against llm, run the repository-local verification required by the builder role, and report the PR URL and exact executed evidence. Do not mutate or merge endojs/endo upstream.
>
> Source authorization: maintainer @kriskowal approved PR 1083 and directed, "Conduct and build this" in review 5064787686.

- `doomed-endojs-endo-but-for-bots-pr1023-gauntlet-panel-2-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-endojs-endo-but-for-bots-pr1023-gauntlet-panel-2-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr1023-gauntlet-panel-2; it stays HELD until a human promotes it
> (promote-plan.sh endojs-endo-but-for-bots-pr1023-gauntlet-panel-2) or removes it, so nothing is lost.
> Original job base: endojs-endo-but-for-bots-pr1023-gauntlet-panel-2
>
> --- original job body ---
> ---
> role: gardener
> tier: minion
> handler-budget-role: panel
> handler-timeout: 7200
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-22T13:56:16Z cleared=none -->
>
> ---
> role: gardener
> handler-budget-role: panel
> handler-timeout: 7200
> gauntlet: endojs-endo-but-for-bots-pr1023-gauntlet
> gauntlet_stage: panel
> gauntlet_iteration: 2
> pr: [https://github.com/endojs/endo-but-for-bots/pull/1023](https://github.com/endojs/endo-but-for-bots/pull/1023)
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
>
> # Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1023
>
> You are ONE stage of a staged gauntlet (endojs-endo-but-for-bots-pr1023-gauntlet). Run EXACTLY ONE panel round, post the
> verdict, then STOP — do NOT fix, do NOT un-draft, do NOT loop.
>
> Garden script names below are repo-relative. Resolve them against THIS claiming
> worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
> posting host's garden root.
>
> 1. Get an ISOLATED project checkout of the PR head:
>    `scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr1023-gauntlet-panel-2 <pr-head-owner>/<repo-name> <pr-head-branch>`.
>    Resolve the head owner and branch with `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1023 --json headRepositoryOwner,headRefName`;
>    do not pass the base repo when the PR head belongs to a fork.
> 2. Run the panel in SINGLE-ROUND mode against that worktree:
>    `GARDEN_PANEL_SINGLE_ROUND=1 \
>      scripts/jobs/gardening/panel.sh <worktree> 1023 <base-ref>`
>    It fans the seats, aggregates, and prints its disposition as the terminal line's
>    last token: `pass` or `must-fix`. It does NOT fix or un-draft in this mode.
> 3. Post the aggregate (in $GARDEN_PANEL_RUNDIR) as a `gh pr review` on [https://github.com/endojs/endo-but-for-bots/pull/1023](https://github.com/endojs/endo-but-for-bots/pull/1023) — the
>    panel-verdict shape the next-stage-owed heuristic recognizes (a request-changes
>    review on must-fix, a comment/approve on pass).
> 4. If panel.sh could not decide (it exits non-zero), this stage FAILS: begin your
>    report with `orchestration-failed: true` and do NOT emit a panel marker.
>
> END your completion report with EXACTLY ONE of these marker lines (last line):
>   <!-- gauntlet-stage-result: panel=pass -->
>   <!-- gauntlet-stage-result: panel=must-fix -->

- `doomed-endojs-endo-but-for-bots-pr807-gauntlet-fix-1-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-endojs-endo-but-for-bots-pr807-gauntlet-fix-1-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr807-gauntlet-fix-1; it stays HELD until a human promotes it
> (promote-plan.sh endojs-endo-but-for-bots-pr807-gauntlet-fix-1) or removes it, so nothing is lost.
> Original job base: endojs-endo-but-for-bots-pr807-gauntlet-fix-1
>
> --- original job body ---
> ---
> role: gardener
> tier: minion
> handler-budget-role: shepherd
> handler-timeout: 7200
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-22T13:57:49Z cleared=none -->
>
> ---
> role: gardener
> handler-budget-role: shepherd
> handler-timeout: 7200
> gauntlet: endojs-endo-but-for-bots-pr807-gauntlet
> gauntlet_stage: fix
> gauntlet_iteration: 1
> pr: [https://github.com/endojs/endo-but-for-bots/pull/807](https://github.com/endojs/endo-but-for-bots/pull/807)
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
>
> # Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #807
>
> You are ONE stage of a staged gauntlet (endojs-endo-but-for-bots-pr807-gauntlet). Apply the panel's must-fix items ONCE,
> push, watch CI, then STOP — do NOT re-run the panel (the driver re-posts panel-2).
>
> Garden script names below are repo-relative. Resolve them against THIS claiming
> worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
> posting host's garden root.
>
> 1. Get an ISOLATED project checkout of the PR head:
>    `scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr807-gauntlet-fix-1 <pr-head-owner>/<repo-name> <pr-head-branch>`.
>    Resolve the head owner and branch with `gh pr view https://github.com/endojs/endo-but-for-bots/pull/807 --json headRepositoryOwner,headRefName`;
>    do not pass the base repo when the PR head belongs to a fork.
> 2. Read the LATEST panel verdict on [https://github.com/endojs/endo-but-for-bots/pull/807](https://github.com/endojs/endo-but-for-bots/pull/807) (the request-changes `gh pr review` the
>    panel-1 stage just posted) for its must-fix items. Apply them.
> 3. Push the fix as review-feedback follow-up commits to the PR head with
>    `scripts/jobs/gardening/safe-push-pr-head.sh`.
> 4. Watch CI to terminal, BOUNDED (same as the clean stage):
>    `GARDEN_CI_DEADLINE_SECS=3600 \
>      scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 807 --no-merge`
>    - rc 0 (GREEN): success.
>    - rc 4 (still PENDING): report still-pending (driver re-posts this stage); no fix=done.
>    - rc 3 (RED): begin your report with `orchestration-failed: true`; no fix=done.
>
> END your completion report with EXACTLY ONE of these marker lines (last line):
>   <!-- gauntlet-stage-result: fix=done -->            (fix pushed, CI green)
>   <!-- gauntlet-stage-result: fix=still-pending -->   (CI still pending at deadline)

- `doomed-endojs-endo-but-for-bots-pr909-gauntlet-fix-1-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-endojs-endo-but-for-bots-pr909-gauntlet-fix-1-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr909-gauntlet-fix-1; it stays HELD until a human promotes it
> (promote-plan.sh endojs-endo-but-for-bots-pr909-gauntlet-fix-1) or removes it, so nothing is lost.
> Original job base: endojs-endo-but-for-bots-pr909-gauntlet-fix-1
>
> --- original job body ---
> ---
> role: gardener
> tier: minion
> handler-budget-role: shepherd
> handler-timeout: 7200
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-22T13:58:22Z cleared=none -->
>
> ---
> role: gardener
> handler-budget-role: shepherd
> handler-timeout: 7200
> gauntlet: endojs-endo-but-for-bots-pr909-gauntlet
> gauntlet_stage: fix
> gauntlet_iteration: 1
> pr: [https://github.com/endojs/endo-but-for-bots/pull/909](https://github.com/endojs/endo-but-for-bots/pull/909)
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
>
> # Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #909
>
> You are ONE stage of a staged gauntlet (endojs-endo-but-for-bots-pr909-gauntlet). Apply the panel's must-fix items ONCE,
> push, watch CI, then STOP — do NOT re-run the panel (the driver re-posts panel-2).
>
> Garden script names below are repo-relative. Resolve them against THIS claiming
> worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
> posting host's garden root.
>
> 1. Get an ISOLATED project checkout of the PR head:
>    `scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr909-gauntlet-fix-1 endojs/endo-but-for-bots <pr-head-branch>`.
> 2. Read the LATEST panel verdict on [https://github.com/endojs/endo-but-for-bots/pull/909](https://github.com/endojs/endo-but-for-bots/pull/909) (the request-changes `gh pr review` the
>    panel-1 stage just posted) for its must-fix items. Apply them.
> 3. Push the fix as review-feedback follow-up commits to the PR head with
>    `scripts/jobs/gardening/safe-push-pr-head.sh`.
> 4. Watch CI to terminal, BOUNDED (same as the clean stage):
>    `GARDEN_CI_DEADLINE_SECS=3600 \
>      scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 909 --no-merge`
>    - rc 0 (GREEN): success.
>    - rc 4 (still PENDING): report still-pending (driver re-posts this stage); no fix=done.
>    - rc 3 (RED): begin your report with `orchestration-failed: true`; no fix=done.
>
> END your completion report with EXACTLY ONE of these marker lines (last line):
>   <!-- gauntlet-stage-result: fix=done -->            (fix pushed, CI green)
>   <!-- gauntlet-stage-result: fix=still-pending -->   (CI still pending at deadline)

- `doomed-endojs-endo-but-for-bots-pr946-conduct-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-endojs-endo-but-for-bots-pr946-conduct-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr946-conduct; it stays HELD until a human promotes it
> (promote-plan.sh endojs-endo-but-for-bots-pr946-conduct) or removes it, so nothing is lost.
> Original job base: endojs-endo-but-for-bots-pr946-conduct
>
> --- original job body ---
> ---
> role: conductor
> tier: minion
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-22T13:58:28Z cleared=none -->
>
> ---
> role: conductor
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
>
> # Finalize (curate → merge) endojs/endo-but-for-bots PR #946
>
> A trusted maintainer APPROVED this PR and the watcher confirmed it is
> OPEN, mergeable, and checks green. This is the CURATION step: dispatch the
> **conductor** to un-draft (if the PR is still draft) and merge. Do NOT name
> a merge method — the conductor owns that choice (roles/conductor/AGENT.md).
>
> Guards (the watcher already enforced these; re-verify before merging):
>   - Bot repo only (endojs/endo-but-for-bots). NEVER merge agoric-sdk or the endojs/endo
>     upstream — those are the maintainers / boatmans call.
>   - The PR must still be OPEN, mergeable, and checks green. If it has
>     regressed (conflicts, red CI), dispatch the shepherd/fixer instead of
>     forcing the merge.
>   - Idempotent: if the PR is already merging/merged/closed, do nothing.
>
> Source: pr-review-body by kriskowal
> Approval: [https://github.com/endojs/endo-but-for-bots/pull/946](https://github.com/endojs/endo-but-for-bots/pull/946)#pullrequestreview-4941598685

- `doomed-endor-walker-exports-resolution-elapsed-constancy` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-endor-walker-exports-resolution-elapsed-constancy.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 2 elapsed-constancy confirmations on endolin-garden-ece02cb4.
> The handler repeatedly failed at a near-constant elapsed below its wall-clock budget.
> The first confirmation was requeued; the reaper parked only after the 2-confirmation threshold.
> Read the handler log for the fast failure cause. Raising the handler budget will not help.
> The work is preserved at jobs/plan/endor-walker-exports-resolution; it stays HELD until a human promotes it
> (promote-plan.sh endor-walker-exports-resolution) or removes it.
> Original job base: endor-walker-exports-resolution
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> ---
> <!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-23T17:05:31Z cleared=none -->
>
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> # Build Increment 2 — conditional & subpath exports/imports (Group C)
>
> Design: `designs/endor-fixture-parity-ratchet.md` (garden main2) — read it first;
> it defines the ratchet mechanism, the emulate-vs-refactor decisions, and the
> per-increment acceptance gates this child must satisfy.
>
> Repo: endojs/endo-but-for-bots. Work against the PR head branch
> `feat/endor-run-entry-point-deps` (or `llm` if it has landed). Manifest:
> `rust/endo/tests/compartment_mapper_fixture_parity.rs`.
>
> Local-build gotcha: endor needs the gitignored Moddable `xs/` sources and empty
> `xsnap/src/*_bootstrap.js` / `ses_boot.js` stubs copied from a sibling worktree at
> the same commit — never commit them. Fixtures stay under
> `packages/compartment-mapper/test`; the top-level `test/fixtures` hoist is OUT OF
> SCOPE. Graduation is atomic: land the capability + commit the node-reference golden
> + flip the fixtures Exclude->Exercise + bump the exercised floor in ONE change, and
> keep the drift guard green.
>
> Implement conditional/subpath `exports` and `#imports` resolution. Graduate
> conditional-host-exports (EMULATE the `endo:lib` condition — supply the same
> condition set to both the node oracle and the walker; do not refactor it away),
> export-patterns, package-imports-exports, nested-pkg, and fixtures-0. Bump floor to
> 16. Depends on Increment 0.

- `doomed-fix-usage-meter-unbound-var-and-widen-shellcheck-ci-deadline-overrun` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-fix-usage-meter-unbound-var-and-widen-shellcheck-ci-deadline-overrun.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden-ece02cb4.
> The handler returned rc=124 at its applied 2400s wall-clock budget without productive progress.
> One such observation is conclusive, so the reaper did not spend another full handler budget.
> Split the work into claim-sized stages or raise its handler-timeout.
> The work is preserved at jobs/plan/fix-usage-meter-unbound-var-and-widen-shellcheck-ci; it stays HELD until a human promotes it
> (promote-plan.sh fix-usage-meter-unbound-var-and-widen-shellcheck-ci) or removes it.
> Original job base: fix-usage-meter-unbound-var-and-widen-shellcheck-ci
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> ## Grounding incident
> While filing a fix job on 2026-08-23, `scripts/jobs/post-job.sh` printed:
>
>     scripts/jobs/usage-meter.sh: line 302: cutoff: unbound variable
>
> a live `set -u` failure in the fleet budget-state read path (the WARN text
> confirms it fell back fail-open: "fleet budget state unreadable; posting ...
> to todo/"). This is exactly the class of bug `shellcheck` catches
> (`SC2154`/unset-variable-under-`set -u` patterns) — but `usage-meter.sh` is
> not in `.github/workflows/checks.yml`'s shellcheck file list, which is a
> curated allowlist (daemons, watcher stub, checks gates, per-test scripts),
> not the full `scripts/jobs/` tree. The workflow's own comment already
> concedes the gap: "Pre-existing scripts outside this scope have known
> issues; widening the lint surface is a separate effort."
>
> Separately (already fixed directly, not part of this job): `checks.yml`'s
> `on: push/pull_request: branches: [main]` pointed at the abandoned `main`
> branch (last touched 2026-07-05, since diverged from `main2`) instead of
> `main2`, the actual development branch — so shellcheck/bash-n/gate-tests
> have not run on a real commit in weeks; only `pages-build-deployment` was
> firing. That trigger fix landed separately; this job is the file-scope
> widening plus the specific bug.
>
> ## Ask
>
> 1. **Fix the specific bug**: `scripts/jobs/usage-meter.sh:302` references
>    `$cutoff` unset under some code path. Trace the call graph, fix the
>    unbound reference (declare/default it, or guard the read), and add or
>    extend a regression test if the file has one (check
>    `scripts/jobs/test/` for a usage-meter test harness first).
>
> 2. **Widen `checks.yml`'s shellcheck step to mandatory, broad coverage.**
>    The maintainer wants shellcheck genuinely in the mandatory pre-commit/CI
>    testing, not a narrow allowlist that happens to exclude the very file
>    that broke. Concretely:
>    - Add `scripts/jobs/*.sh` (at minimum) to the shellcheck file list,
>      ideally the same broad `find scripts skills -name '*.sh'` sweep the
>      `bash -n` step already uses, so newly added scripts are covered by
>      construction rather than requiring a per-file allowlist edit forever.
>    - `shellcheck -S warning` across the full `scripts/jobs/` tree will
>      likely surface real pre-existing warnings beyond the one bug above
>      (the workflow comment already anticipates this) — triage and fix each
>      one rather than silently loosening the severity or excluding files
>      wholesale. Where a finding is a deliberate/false-positive pattern
>      (e.g. an intentionally-unbound variable a caller is expected to set),
>      use a scoped `# shellcheck disable=SCxxxx` with a one-line reason,
>      not a file-level exclusion.
>    - If the full sweep is too large for one pass, land it in the widest
>      scope you can clear in this job and note remaining excluded paths
>      explicitly in the workflow comment (mirroring the existing "known
>      issues" note) rather than leaving the gap implicit.
>    - Keep the check genuinely mandatory: it should fail the workflow (not
>      just warn) on any finding at `-S warning` or above, matching the
>      existing step's behavior.
>
> 3. Confirm the retargeted workflow (now triggering on `main2`) actually
>    runs green on your PR-equivalent push and report the run URL.

- `doomed-fu-guard-worker-self-disqualify-missing-agent-bin-1-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-fu-guard-worker-self-disqualify-missing-agent-bin-1-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/fu-guard-worker-self-disqualify-missing-agent-bin-1; it stays HELD until a human promotes it
> (promote-plan.sh fu-guard-worker-self-disqualify-missing-agent-bin-1) or removes it, so nothing is lost.
> Original job base: fu-guard-worker-self-disqualify-missing-agent-bin-1
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> Garden repo (main2): `run-test.sh` currently has ~30 pre-existing failures (environmental — sandbox lacks network for `github.com:kriskowal/garden.git`, a shellcheck-wrapper subtest, a foreman fill-batch block), leaving the suite red by default so it can't gate anything. Fix or properly skip the environmental failures.

- `doomed-fu-requeue-ps23-stranded-claims-4-elapsed-constancy` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-fu-requeue-ps23-stranded-claims-4-elapsed-constancy.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 2 elapsed-constancy confirmations on endolin-garden-ece02cb4.
> The handler repeatedly failed at a near-constant elapsed below its wall-clock budget.
> The first confirmation was requeued; the reaper parked only after the 2-confirmation threshold.
> Read the handler log for the fast failure cause. Raising the handler budget will not help.
> The work is preserved at jobs/plan/fu-requeue-ps23-stranded-claims-4; it stays HELD until a human promotes it
> (promote-plan.sh fu-requeue-ps23-stranded-claims-4) or removes it.
> Original job base: fu-requeue-ps23-stranded-claims-4
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> Garden repo (main2): SUBTEST 7 of `elapsed-constancy-classifier-test.sh` fails on main2 (explicit-cap exemption not firing — sub-floor reclassification wins instead). Fix it.

- `doomed-ironhorse-fuzz-12aca768c2e73c73-repair-requeue-exhausted` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-12aca768c2e73c73-repair-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/ironhorse-fuzz-12aca768c2e73c73-repair; it stays HELD until a human promotes it
> (promote-plan.sh ironhorse-fuzz-12aca768c2e73c73-repair) or removes it, so nothing is lost.
> Original job base: ironhorse-fuzz-12aca768c2e73c73-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Fix Ironhorse fuzz finding 12aca768c2e73c73 (target `differential_regexp`) and amend the standing PR
>
> The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
> load-bearing regression case AND the causal fix, then amend the ONE standing
> pull request for fuzz findings.
>
> ## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `bceeca5a518f6f60608f8c89d24091431806eebe454eacc00d453b8082d9ee5d` (10 bytes)
> - Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/12aca768c2e73c73/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/12aca768c2e73c73.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `bceeca5a518f6f60608f8c89d24091431806eebe454eacc00d453b8082d9ee5d`.
> 3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
>    before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 12aca768c2e73c73).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-1dc231089278c110-repair-policy-refusal` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-1dc231089278c110-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden2-5bcdff64.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-1dc231089278c110-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-1dc231089278c110-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Fix Ironhorse fuzz finding 1dc231089278c110 (target `differential_regexp`) and amend the standing PR
>
> The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
> load-bearing regression case AND the causal fix, then amend the ONE standing
> pull request for fuzz findings.
>
> ## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under fuzz: `unknown`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `18d835dd78d2328c010598a2e65abf126137e92a88cde2638f52e2d0bf67643a` (3 bytes)
> - Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/1dc231089278c110/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/1dc231089278c110.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `18d835dd78d2328c010598a2e65abf126137e92a88cde2638f52e2d0bf67643a`.
> 3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
>    before changing any code. If it does not reproduce at `unknown`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 1dc231089278c110).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-2cc2ac67ba7e9b9f-repair-policy-refusal` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-2cc2ac67ba7e9b9f-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden2-5bcdff64.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-2cc2ac67ba7e9b9f-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-2cc2ac67ba7e9b9f-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Fix Ironhorse fuzz finding 2cc2ac67ba7e9b9f (target `differential_regexp_surface`) and amend the standing PR
>
> The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
> load-bearing regression case AND the causal fix, then amend the ONE standing
> pull request for fuzz findings.
>
> ## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `aeadab4b457f5d6f444bdc51c1ec6d9a362318f1f45282b21a5e10308b002f6f` (26 bytes)
> - Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/2cc2ac67ba7e9b9f/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/2cc2ac67ba7e9b9f.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `aeadab4b457f5d6f444bdc51c1ec6d9a362318f1f45282b21a5e10308b002f6f`.
> 3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
>    before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 2cc2ac67ba7e9b9f).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-557805e944888b5a-repair-policy-refusal` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-557805e944888b5a-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden2-5bcdff64.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-557805e944888b5a-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-557805e944888b5a-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Fix Ironhorse fuzz finding 557805e944888b5a (target `differential_regexp_surface`) and amend the standing PR
>
> The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
> load-bearing regression case AND the causal fix, then amend the ONE standing
> pull request for fuzz findings.
>
> ## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `6ec8c34eaf1d04f2f67d9964a024e7294d836121f0b836a75209061206ae8af6` (11 bytes)
> - Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/557805e944888b5a/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/557805e944888b5a.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `6ec8c34eaf1d04f2f67d9964a024e7294d836121f0b836a75209061206ae8af6`.
> 3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
>    before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 557805e944888b5a).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-5eeb0aadb2004075-repair-requeue-exhausted` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-5eeb0aadb2004075-repair-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/ironhorse-fuzz-5eeb0aadb2004075-repair; it stays HELD until a human promotes it
> (promote-plan.sh ironhorse-fuzz-5eeb0aadb2004075-repair) or removes it, so nothing is lost.
> Original job base: ironhorse-fuzz-5eeb0aadb2004075-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Fix Ironhorse fuzz finding 5eeb0aadb2004075 (target `differential_regexp`) and amend the standing PR
>
> The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
> load-bearing regression case AND the causal fix, then amend the ONE standing
> pull request for fuzz findings.
>
> ## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `34f722ff054be45a770489eb6ce00ec348bd4eaa33f26529dbdde2801096c673` (30 bytes)
> - Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/5eeb0aadb2004075/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/5eeb0aadb2004075.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `34f722ff054be45a770489eb6ce00ec348bd4eaa33f26529dbdde2801096c673`.
> 3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
>    before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 5eeb0aadb2004075).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-67ca18e4febe7a34-repair-policy-refusal` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-67ca18e4febe7a34-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden2-5bcdff64.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-67ca18e4febe7a34-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-67ca18e4febe7a34-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Fix Ironhorse fuzz finding 67ca18e4febe7a34 (target `differential_source`) and amend the standing PR
>
> The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
> load-bearing regression case AND the causal fix, then amend the ONE standing
> pull request for fuzz findings.
>
> ## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `e19049016d8614f90c078f93b854af0cc1d7142ae509c60bbf5072f2353292df` (3 bytes)
> - Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/67ca18e4febe7a34/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/67ca18e4febe7a34.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `e19049016d8614f90c078f93b854af0cc1d7142ae509c60bbf5072f2353292df`.
> 3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
>    before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 67ca18e4febe7a34).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-7637ac162a0b916a-repair-policy-refusal` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-7637ac162a0b916a-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden2-5bcdff64.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-7637ac162a0b916a-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-7637ac162a0b916a-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Fix Ironhorse fuzz finding 7637ac162a0b916a (target `differential_regexp`) and amend the standing PR
>
> The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
> load-bearing regression case AND the causal fix, then amend the ONE standing
> pull request for fuzz findings.
>
> ## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `a62a861beeaae59d45ec4bad76a22ed6a371a620347a43673bc8d7114f5b1707` (6 bytes)
> - Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/7637ac162a0b916a/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/7637ac162a0b916a.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `a62a861beeaae59d45ec4bad76a22ed6a371a620347a43673bc8d7114f5b1707`.
> 3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
>    before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding 7637ac162a0b916a).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-c9eaa7b5ae02437a-repair-policy-refusal` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-c9eaa7b5ae02437a-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden2-5bcdff64.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-c9eaa7b5ae02437a-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-c9eaa7b5ae02437a-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Fix Ironhorse fuzz finding c9eaa7b5ae02437a (target `differential_regexp_surface`) and amend the standing PR
>
> The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
> load-bearing regression case AND the causal fix, then amend the ONE standing
> pull request for fuzz findings.
>
> ## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `6a9c7d5aa3c0a3cf59823601893c61abf251d4ec1d0cc6b933f51f4863f6155d` (27 bytes)
> - Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/c9eaa7b5ae02437a/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/c9eaa7b5ae02437a.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `6a9c7d5aa3c0a3cf59823601893c61abf251d4ec1d0cc6b933f51f4863f6155d`.
> 3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
>    before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding c9eaa7b5ae02437a).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-d5413146a257bc30-repair-policy-refusal` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-d5413146a257bc30-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden2-5bcdff64.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-d5413146a257bc30-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-d5413146a257bc30-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Fix Ironhorse fuzz finding d5413146a257bc30 (target `differential_regexp_surface`) and amend the standing PR
>
> The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
> load-bearing regression case AND the causal fix, then amend the ONE standing
> pull request for fuzz findings.
>
> ## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `957c39a802d5b3a9f09413832ea4c03dba2d2fed67d8b6da0553a6cb6cef0563` (6 bytes)
> - Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/d5413146a257bc30/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/d5413146a257bc30.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `957c39a802d5b3a9f09413832ea4c03dba2d2fed67d8b6da0553a6cb6cef0563`.
> 3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
>    before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding d5413146a257bc30).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-d87697d49a5f8f67-repair-policy-refusal` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-d87697d49a5f8f67-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden2-5bcdff64.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-d87697d49a5f8f67-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-d87697d49a5f8f67-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Fix Ironhorse fuzz finding d87697d49a5f8f67 (target `differential_source`) and amend the standing PR
>
> The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
> load-bearing regression case AND the causal fix, then amend the ONE standing
> pull request for fuzz findings.
>
> ## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `b4814c1b47ca2297e26e5e27a1151a79dc222cd408f51d4130a07d423229311b` (7 bytes)
> - Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/d87697d49a5f8f67/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/d87697d49a5f8f67.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `b4814c1b47ca2297e26e5e27a1151a79dc222cd408f51d4130a07d423229311b`.
> 3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
>    before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding d87697d49a5f8f67).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-e773681b6d831dc1-repair-policy-refusal` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-e773681b6d831dc1-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden2-5bcdff64.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-e773681b6d831dc1-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-e773681b6d831dc1-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Fix Ironhorse fuzz finding e773681b6d831dc1 (target `differential_regexp_surface`) and amend the standing PR
>
> The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
> load-bearing regression case AND the causal fix, then amend the ONE standing
> pull request for fuzz findings.
>
> ## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)
>
> - Target: `differential_regexp_surface` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `e920afdac5ce7e95c1bc7584407e45fa0cff40756ed0c6493716bc07a31b495f` (4 bytes)
> - Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/e773681b6d831dc1/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/e773681b6d831dc1.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `e920afdac5ce7e95c1bc7584407e45fa0cff40756ed0c6493716bc07a31b495f`.
> 3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
>    before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding e773681b6d831dc1).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-fad9672dc7a6e6be-repair-policy-refusal` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-fad9672dc7a6e6be-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden2-5bcdff64.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-fad9672dc7a6e6be-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-fad9672dc7a6e6be-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Fix Ironhorse fuzz finding fad9672dc7a6e6be (target `differential_source`) and amend the standing PR
>
> The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
> load-bearing regression case AND the causal fix, then amend the ONE standing
> pull request for fuzz findings.
>
> ## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)
>
> - Target: `differential_source` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `676e2c8aa6e7d449bd966554684840708b84656330fadc8b69bff829ef18c94b` (6 bytes)
> - Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/fad9672dc7a6e6be/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/fad9672dc7a6e6be.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `676e2c8aa6e7d449bd966554684840708b84656330fadc8b69bff829ef18c94b`.
> 3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
>    before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding fad9672dc7a6e6be).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-ironhorse-fuzz-fd8517d5f3071227-repair-policy-refusal` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-fuzz-fd8517d5f3071227-repair-policy-refusal.md)

> Job QUARANTINED in jobs/plan/ (held, gate=go-ahead) after a PROVIDER POLICY REFUSAL on endolin-garden2-5bcdff64.
> The provider's safety/usage policy BLOCKED the request (e.g. a content flagged as a
> possible cybersecurity risk). This is DETERMINISTIC: re-running the SAME prompt hits the
> SAME block, so the reaper did NOT requeue it — one refusal is conclusive, and requeueing
> would only repeat the failure and spam the error inbox with an identical capture.
> REMEDY: rephrase / re-scope the job so it no longer trips the policy filter (for a
> security-fuzz repair, describe the fix work WITHOUT the untrusted crash bytes and avoid
> framing that reads as offensive-security), then promote it (promote-plan.sh ironhorse-fuzz-fd8517d5f3071227-repair); or, if
> the work genuinely cannot be authorized, remove it. It stays HELD until then — nothing lost.
> Original job base: ironhorse-fuzz-fd8517d5f3071227-repair
>
> --- original job body ---
> ---
> role: builder
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Fix Ironhorse fuzz finding fd8517d5f3071227 (target `differential_regexp`) and amend the standing PR
>
> The continuous Ironhorse fuzz service reproduced a distinct crash. Own BOTH a
> load-bearing regression case AND the causal fix, then amend the ONE standing
> pull request for fuzz findings.
>
> ## Finding (bounded metadata — the crash bytes are untrusted; never paste them into a prompt or a shell command)
>
> - Target: `differential_regexp` (one of the maintained ironhorse-fuzz targets)
> - Project SHA under fuzz: `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`
> - Toolchain: `nightly-2026-08-15`
> - Minimized input sha256: `69c4d5ae332ac1ddbf55119ab093eaf6d5ac592521784224b09f3e5befe82f4e` (30 bytes)
> - Durable artifact (leader host): `/home/kris/garden2/.garden-state/ironhorse-fuzz/findings/fd8517d5f3071227/input.bin`
> - Portable copy: `input_base64` in journal `ironhorse-fuzz/findings/fd8517d5f3071227.md`
> - Reproduction: `cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1`
>
> ## Procedure
>
> 1. Get an isolated project checkout of `endojs/endo-but-for-bots` @ `ironhorse-fuzz-findings` via ensure-project-worktree.sh.
> 2. Recover the minimized input to a FILE without inlining it into any prompt:
>    decode `input_base64` from the journal finding marker with `base64 -d`, OR copy the
>    durable artifact path above. Verify `sha256sum` equals `69c4d5ae332ac1ddbf55119ab093eaf6d5ac592521784224b09f3e5befe82f4e`.
> 3. Set up the pinned fuzz env (c/moddable submodule peer-init, `nightly-2026-08-15`, cargo-fuzz —
>    see the ironhorse-fuzz-build-setup runbook) and REPRODUCE the crash from that file
>    before changing any code. If it does not reproduce at `38ca1d189384245dd9accfcc2f79763a3b8ec5cb`, report that and stop.
>
> 4. Add a LOAD-BEARING regression case. `fuzz/corpus` and `fuzz/artifacts` are gitignored,
>    so a corpus seed is NOT a permanent regression: add a Rust unit test in `ironhorse-vm`
>    that replays these exact bytes and asserts no panic (it builds without the oracle/submodule).
> 5. Fix the causal defect. Keep the fix minimal and targeted.
> 6. Amend the STANDING branch `ironhorse-fuzz-findings` with fetch/rebase/push CAS discipline, then
>    `scripts/jobs/gardening/ensure-pr.sh ironhorse-fuzz-findings endojs/endo-but-for-bots kriscendobot:ironhorse-fuzz-findings llm` to create-or-adopt the standing
>    PR (the `<!-- garden-job: ironhorse-fuzz-findings -->` marker guarantees every finding amends the SAME PR),
>    and run its required gauntlet.
> 7. Document THIS case and its solution in the standing PR body or a PR comment (finding fd8517d5f3071227).
> 8. If the case cannot yet be solved, still land the regression test as `#[ignore]` with a
>    comment, and record the unsolved finding visibly in the PR — never let it disappear.

- `doomed-kriscendobot-minion.town-pr37-gauntlet-panel-6-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-kriscendobot-minion.town-pr37-gauntlet-panel-6-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/kriscendobot-minion.town-pr37-gauntlet-panel-6; it stays HELD until a human promotes it
> (promote-plan.sh kriscendobot-minion.town-pr37-gauntlet-panel-6) or removes it, so nothing is lost.
> Original job base: kriscendobot-minion.town-pr37-gauntlet-panel-6
>
> --- original job body ---
> ---
> role: gardener
> tier: minion
> handler-budget-role: panel
> handler-timeout: 7200
> token-budget: 250000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-22T13:58:49Z cleared=none -->
>
> ---
> role: gardener
> handler-budget-role: panel
> handler-timeout: 7200
> gauntlet: kriscendobot-minion.town-pr37-gauntlet
> gauntlet_stage: panel
> gauntlet_iteration: 6
> pr: [https://github.com/kriscendobot/minion.town/pull/37](https://github.com/kriscendobot/minion.town/pull/37)
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
>
> # Gauntlet stage: PANEL round 6 — kriscendobot/minion.town PR #37
>
> You are ONE stage of a staged gauntlet (kriscendobot-minion.town-pr37-gauntlet). Run EXACTLY ONE panel round, post the
> verdict, then STOP — do NOT fix, do NOT un-draft, do NOT loop.
>
> Garden script names below are repo-relative. Resolve them against THIS claiming
> worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
> posting host's garden root.
>
> 1. Get an ISOLATED project checkout of the PR head:
>    `scripts/jobs/ensure-project-worktree.sh kriscendobot-minion.town-pr37-gauntlet-panel-6 <pr-head-owner>/<repo-name> <pr-head-branch>`.
>    Resolve the head owner and branch with `gh pr view https://github.com/kriscendobot/minion.town/pull/37 --json headRepositoryOwner,headRefName`;
>    do not pass the base repo when the PR head belongs to a fork.
> 2. Run the panel in SINGLE-ROUND mode against that worktree:
>    `GARDEN_PANEL_SINGLE_ROUND=1 \
>      scripts/jobs/gardening/panel.sh <worktree> 37 <base-ref>`
>    It fans the seats, aggregates, and prints its disposition as the terminal line's
>    last token: `pass` or `must-fix`. It does NOT fix or un-draft in this mode.
> 3. Post the aggregate (in $GARDEN_PANEL_RUNDIR) as a `gh pr review` on [https://github.com/kriscendobot/minion.town/pull/37](https://github.com/kriscendobot/minion.town/pull/37) — the
>    panel-verdict shape the next-stage-owed heuristic recognizes (a request-changes
>    review on must-fix, a comment/approve on pass).
> 4. If panel.sh could not decide (it exits non-zero), this stage FAILS: begin your
>    report with `orchestration-failed: true` and do NOT emit a panel marker.
>
> END your completion report with EXACTLY ONE of these marker lines (last line):
>   <!-- gauntlet-stage-result: panel=pass -->
>   <!-- gauntlet-stage-result: panel=must-fix -->

- `doomed-local-verify-endo-test-xs-cargo-parity-deadline-overrun` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-local-verify-endo-test-xs-cargo-parity-deadline-overrun.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden-ece02cb4.
> The handler returned rc=124 at its applied 7200s wall-clock budget without productive progress.
> One such observation is conclusive, so the reaper did not spend another full handler budget.
> Split the work into claim-sized stages or raise its handler-timeout.
> The work is preserved at jobs/plan/local-verify-endo-test-xs-cargo-parity; it stays HELD until a human promotes it
> (promote-plan.sh local-verify-endo-test-xs-cargo-parity) or removes it.
> Original job base: local-verify-endo-test-xs-cargo-parity
>
> --- original job body ---
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> role: builder
>
> Close the remaining local-verify environment parity exposed after `test:xs` coverage landed in commit 4c1c39ee15. A real run against endojs/endo-but-for-bots@llm used the CI-pinned Moddable 5.0.0 xst successfully, then `@endo/hardened262` failed before exercising Ironhorse because the garden image has no `cargo`; the isolated worktree also has the CI-required `c/moddable` submodule uninitialized. Mirror the `test-xs` workflow prerequisites generically, preserve silent-on-success, and add regression coverage. Evidence blob in project worktree at the originating job was deeb55ea4c940dbbd69335b23b48ed8cac441563.

- `doomed-mtown-git-remote-followup-notice-recheck-20260818-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-mtown-git-remote-followup-notice-recheck-20260818-requeue-exhausted.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
> Its handler appears to fail every time; the reaper stopped requeueing it.
> The work is preserved at jobs/plan/mtown-git-remote-followup-notice-recheck-20260818; it stays HELD until a human promotes it
> (promote-plan.sh mtown-git-remote-followup-notice-recheck-20260818) or removes it, so nothing is lost.
> Original job base: mtown-git-remote-followup-notice-recheck-20260818
>
> --- original job body ---
> ---
> role: gardener
> tier: minion
> token-budget: 100000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-21T22:18:56Z cleared=none -->
>
> ---
> role: gardener
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> # Notice: recheck the minion.town git-remote follow-up on the daemon commit-formula design
>
> This is the notice (sentinel) job of the D->N->F chained follow-up in skills/chained-followup/SKILL.md, re-armed on a short once: schedule because the design had not yet advanced to a build at the last check.
>
> D is ebfb-daemon-commit-formula-design. Its design PR is [https://github.com/endojs/endo-but-for-bots/pull/988](https://github.com/endojs/endo-but-for-bots/pull/988).
>
> Use gh read-only metadata, not comment prose, to determine whether PR #988 has advanced to a build: a build PR referencing or implementing the design has opened, or the design merged and a build is underway. Cross-reference timeline metadata is the preferred mechanical link check (gh api repos/endojs/endo-but-for-bots/issues/988/timeline).
>
> If advanced to build, post F with post-job.sh using base mtown-git-remote-commit-formula-act and this exact body:
> Act on the daemon-native commit formula in minion.town's capability-addressed git remote (design/git-remote-capability). Name the endo-but-for-bots build PR/commit that landed. Update designs/git-remote-capability.md §4 (Strategy B) to reflect git commit/tree/tag identity through the new daemon commit formula — synthetic refs tree rooted at a formula identifier, name-hub lookup paths ending in a readable-tree, synthetic orphan commits enveloping the readable-tree — and carry the design to the implementation increment. Origin review: [https://github.com/kriscendobot/minion.town/pull/41](https://github.com/kriscendobot/minion.town/pull/41)#pullrequestreview-4939454650
>
> If not yet built, re-arm this notice again on a short once: schedule (scripts/jobs/set-schedule-once.sh). If the design was declined (PR #988 closed unmerged), end the chain, message the maintainer through message-user.sh, and do not post F.

- `doomed-openrouter-zdr-policy-and-stealth-lane-deadline-overrun` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-openrouter-zdr-policy-and-stealth-lane-deadline-overrun.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden-ece02cb4.
> The handler returned rc=124 at its applied 2400s wall-clock budget without productive progress.
> One such observation is conclusive, so the reaper did not spend another full handler budget.
> Split the work into claim-sized stages or raise its handler-timeout.
> The work is preserved at jobs/plan/openrouter-zdr-policy-and-stealth-lane; it stays HELD until a human promotes it
> (promote-plan.sh openrouter-zdr-policy-and-stealth-lane) or removes it.
> Original job base: openrouter-zdr-policy-and-stealth-lane
>
> --- original job body ---
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> Follow-up to `design-openrouter-provider` (`designs/openrouter-provider.md`,
> commit `9790c4f4db`), which left two maintainer decisions as open questions.
> The maintainer (kriskowal) has now answered both — this job builds what they
> authorized, not a re-ask.
>
> ## Decision 1 — reject logging/training-use by default (answers Open question 1)
>
> The garden's default OpenRouter posture is: **no prompt/response logging, no
> training on inputs.** Enforce this as a real, code-auditable constraint, not
> an account-page setting someone could forget or reset:
>
> - Investigate OpenRouter's actual current mechanism for this — most likely a
>   per-request `provider: { data_collection: "deny" }` field (routes only to
>   zero-data-retention-capable providers, whatever they don't serve is simply
>   excluded from routing) alongside/instead of the account-level privacy
>   toggle at openrouter.ai/settings/privacy. Confirm current behavior against
>   OpenRouter's own docs rather than assuming; this is a request I have not
>   verified against a live account.
> - Wire the `openrouter`/`cleric-codex.sh` `$custom_openai_compat` request
>   path to send that deny-collection constraint on **every** OpenRouter
>   request, unconditionally — not opt-in per job, not toggleable by a job
>   body. This is a fleet posture, not a per-request choice.
> - **Re-review the two seed inventory rows against this constraint.** The
>   design doc already noted free `:free` variants commonly *require*
>   logging/training to be enabled as the price of the free tier — if that's
>   still true, a deny-collection request to those ids may simply return no
>   eligible provider (empty routing) rather than an error, or may 404/402.
>   Determine empirically (status-only probe, no key exists yet so this may
>   need to wait for §3 below, or can be reasoned from OpenRouter's docs) and
>   either (a) drop the two named-free rows and replace with providers that
>   demonstrably support zero retention even on `:free`, if any exist, or (b)
>   document plainly that under this policy the free lane is currently empty
>   and the garden's OpenRouter reach starts at zero usable named models until
>   a compliant one is found or a paid ZDR-capable route is reviewed and
>   authorized separately. Do not silently keep a non-compliant row enabled.
> - Update `designs/openrouter-provider.md` § Open questions (mark question 1
>   Resolved: with the decision and what it costs) and
>   `context/operations/openrouter.md` to state the enforced policy plainly
>   and reflect the reviewed row set.
>
> ## Decision 2 — admit stealth/cloaked models via a second kind (answers Open question 2)
>
> The maintainer wants to use OpenRouter's rotating cloaked "stealth" models
> (e.g. `openrouter/stealth/ox-alpha`-shaped ids) *while cloaked*, accepting
> the design's stated risk (undisclosed provenance, no reviewed stable id).
> Build the design's already-sketched policy (b):
>
> - A second kind, `openrouter-promo` (or a better name if one occurs to
>   you — say why if you rename it), same handler/provider, same
>   explicit-model-only fencing as `openrouter`, but with its OWN registry
>   namespace so its arms never pool with the stable named lane's
>   (`opencode-alternate-harness.md`'s option-C reasoning applies again here:
>   a distinct kind keeps distinct risk profiles distinctly scored).
> - A **short mandatory re-review cadence** for whatever cloaked ids are
>   enabled (the design flagged this as required but undesigned) — pick a
>   concrete cadence (daily is a reasonable default for something that can
>   vanish or silently become a different model at any time) and a mechanism
>   to enforce it: a scheduled check (skill: [schedule]) that re-probes each
>   enabled stealth id's `/models` listing and a live tool-using canary, and
>   **automatically disables** (not just warns about) an id that 404s or that
>   the maintainer has not re-attested within the cadence window.
> - A documented **rip-cord**: how to immediately zero the pool and drop a
>   specific stealth id's row (`set-openrouter-promos.sh 0` plus removing its
>   inventory row) — mirror the shape of `set-openrouters.sh`.
> - This lane inherits the deny-logging/deny-training constraint from Decision
>   1 unconditionally, same as the stable lane — "we accept not knowing which
>   model this is" is a different risk than "we accept our prompts being
>   logged", and the maintainer has only authorized the former.
>
> ## Decision 2b — reputation continuity on unmask (net-new, not in the prior design)
>
> When a stealth id's identity is later revealed (OpenRouter publishes what it
> was, or the maintainer otherwise learns it), the garden should be able to
> **carry the accumulated reputation forward** onto the now-named model's
> arm(s) rather than discarding it and starting that model at zero history.
> This is genuinely new — the prior design didn't address it. Design and build
> a maintainer-triggered (never automatic — an unmask is an external fact only
> a human confirms) reputation-arm migration:
>
> - Read `reputation.sh` / the reducer (`reputation-reduce.sh`, described
>   elsewhere as the sole writer of arm projections) before proposing a
>   mechanism — the migration must go through whatever the reducer considers
>   its single source of truth, not hand-edit a projection file.
> - Shape: an operator script, `rerecord-reputation-arm.sh <old-arm-key>
>   <new-arm-key> --authorized-by <maintainer>` (or fold into an existing
>   attested-op pattern if one already fits better — the sysop's
>   `authorized_by:` attestation gate on destructive ops is the precedent to
>   follow for who may trigger this and how it's recorded) that relabels the
>   stealth arm's history onto the real model's arm, idempotently, with a
>   journal record of the migration (what was renamed, when, by whom) so it's
>   auditable and never silently double-applied.
> - If a full merge (combining history if the target arm already has some) is
>   materially harder than a clean rename (target arm didn't exist before),
>   it's fine to build the rename case now and leave merge-on-collision as an
>   explicit open question rather than guessing at reducer semantics you
>   haven't verified.
>
> ## Out of scope for this job
>
> Actually supplying `OPENROUTER_API_KEY` or enabling any worker. The pool
> (both `openrouter` and the new `openrouter-promo`) stays at zero. Container
> recreation with the key is a separate, host-side, maintainer-run step
> (cannot be done from inside a garden container — no docker socket there) —
> the liaison is handling that directly with the maintainer, not asking this
> job to do it.
>
> ## Precedents to read first
>
> - `designs/openrouter-provider.md` (this job's predecessor) and
>   `context/operations/openrouter.md`.
> - `skills/schedule/SKILL.md` for the re-review cadence mechanism.
> - `roles/sysop`/`designs/sysop.md` § attestation, as the precedent for a
>   maintainer-attested, auditable, idempotent operator action.

- `watchdog-handler-budget-overrun-ebfb-exo-stream-drop-base64-stream-methods` — from watchdog:cleric/2, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-handler-budget-overrun-ebfb-exo-stream-drop-base64-stream-methods.md)

> gardener job 'ebfb-exo-stream-drop-base64-stream-methods' declared handler-timeout=14400s, which exceeds what a single claim can hold (max 14339s = GARDEN_CLAIM_TTL 14400s − GARDEN_HANDLER_KILL_AFTER 60s − 1). A run-to-completion handler that needs longer than one claim cannot be claim-scoped without breaking the duplicate-execution guard: after GARDEN_CLAIM_TTL the reaper would requeue the same base onto a second gardener while this one is still running. Run it DETACHED (outside the claim-scoped handler) or SPLIT it into claim-sized stages. This cycle the handler runs clamped at 14339s and will be SIGTERM-killed at that bound — it will not complete.

- `watchdog-handler-budget-overrun-endojs-endo-but-for-bots-pr1095-71b4cc20` — from watchdog:cleric/3, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-handler-budget-overrun-endojs-endo-but-for-bots-pr1095-71b4cc20.md)

> gardener job 'endojs-endo-but-for-bots-pr1095-71b4cc20' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2423s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `watchdog-handler-budget-overrun-endojs-endo-but-for-bots-pr881-gauntlet` — from watchdog:cleric/2, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-handler-budget-overrun-endojs-endo-but-for-bots-pr881-gauntlet.md)

> gardener job 'endojs-endo-but-for-bots-pr881-gauntlet' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=7207s ≈ handler-budget=7200s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `watchdog-preflight-gather-fail-endojs-endo-but-for-bots` — from watchdog:pr-feedback-preflight, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-preflight-gather-fail-endojs-endo-but-for-bots.md)

> pr-feedback-preflight could not gather evidence for [endojs/endo-but-for-bots#1098](https://github.com/endojs/endo-but-for-bots/issues/1098) (cid=5069536583) and failed open.
> This is a tool/transport failure, not a no-evidence finding — real feedback may
> have been processed WITHOUT the peer-resolution recheck. Reason:
> evidence gathering failed: could not fetch pull [endojs/endo-but-for-bots#1098](https://github.com/endojs/endo-but-for-bots/issues/1098)
> --- captured stderr ---
> gh: API rate limit exceeded for user ID 279080640. If you reach out to GitHub Support for help, please include the request ID B8F6:160F2F:1B8596A:22F6900:6A95C137 and timestamp 2026-08-31 18:00:23 UTC. For more on scraping GitHub and how it may affect your rights, please review our Terms of Service (https://docs.github.com/en/site-policy/github-terms/github-terms-of-service) (HTTP 403)

- `watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4.md)

> root repo /home/kris/garden deploy has been STALLED for ~3d: deployed sha 745fa90891f8692c12b6b14a06b4a5dbdcbbf503 is 18 commit(s) behind origin/main2 (231ef0576752a29e0f54a3c9316ac812a6790da3) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=endolin-garden-ece02cb4)


## Spend & quota
_Since Friday 21:00 Pacific reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 9.6M | $192.01 _(notional, rate-card)_ | 191% of 5.0M (backoff) |
| Codex | 26.9M _(+624.2M cached)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 69% _(plan; codex-reported)_ |

## Board
### todo (68)
- [`endojs-endo-but-for-bots-pr1013-gauntlet-fix-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1013-gauntlet-fix-4.md) — Gauntlet stage: FIX round 4 — endojs/endo-but-for-bots PR #1013
- [`endojs-endo-but-for-bots-pr1018-review-eccc706c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1018-review-eccc706c.md) — Review directive on endojs/endo-but-for-bots PR #1018
- [`endojs-endo-but-for-bots-pr1098-review-859f9c8f`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1098-review-859f9c8f.md) — Review directive on endojs/endo-but-for-bots PR #1098
- [`endojs-endo-but-for-bots-pr138-gauntlet-fix-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr138-gauntlet-fix-4.md) — Gauntlet stage: FIX round 4 — endojs/endo-but-for-bots PR #138
- [`endojs-endo-but-for-bots-pr231-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr231-conduct.md) — Finalize (curate → merge) endojs/endo-but-for-bots PR #231
- [`endojs-endo-but-for-bots-pr237-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr237-gauntlet-panel-6.md) — Gauntlet stage: PANEL round 6 — endojs/endo-but-for-bots PR #237
- [`endojs-endo-but-for-bots-pr241-gauntlet-panel-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr241-gauntlet-panel-5.md) — Gauntlet stage: PANEL round 5 — endojs/endo-but-for-bots PR #241
- [`endojs-endo-but-for-bots-pr264-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr264-gauntlet-panel-4.md) — Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #264
- [`endojs-endo-but-for-bots-pr266-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr266-gauntlet-panel-4.md) — Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #266
- [`endojs-endo-but-for-bots-pr300-9b91dfc2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr300-9b91dfc2.md) — attention directive on endojs/endo-but-for-bots PR #300
- [`endojs-endo-but-for-bots-pr322-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr322-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #322
- [`endojs-endo-but-for-bots-pr335-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr335-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #335
- [`endojs-endo-but-for-bots-pr356-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr356-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #356
- [`endojs-endo-but-for-bots-pr359-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr359-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #359
- [`endojs-endo-but-for-bots-pr360-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr360-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #360
- [`endojs-endo-but-for-bots-pr431-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr431-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #431
- [`endojs-endo-but-for-bots-pr432-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr432-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #432
- [`endojs-endo-but-for-bots-pr450-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr450-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #450
- [`endojs-endo-but-for-bots-pr463-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr463-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #463
- [`endojs-endo-but-for-bots-pr508-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr508-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #508
- [`endojs-endo-but-for-bots-pr511-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr511-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #511
- [`endojs-endo-but-for-bots-pr529-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr529-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #529
- [`endojs-endo-but-for-bots-pr539-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr539-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #539
- [`endojs-endo-but-for-bots-pr550-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr550-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #550
- [`endojs-endo-but-for-bots-pr551-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr551-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #551
- [`endojs-endo-but-for-bots-pr569-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr569-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #569
- [`endojs-endo-but-for-bots-pr610-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr610-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #610
- [`endojs-endo-but-for-bots-pr631-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr631-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #631
- [`endojs-endo-but-for-bots-pr648-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr648-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #648
- [`endojs-endo-but-for-bots-pr663-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr663-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #663
- [`endojs-endo-but-for-bots-pr664-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr664-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #664
- [`endojs-endo-but-for-bots-pr665-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr665-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #665
- [`endojs-endo-but-for-bots-pr666-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr666-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #666
- [`endojs-endo-but-for-bots-pr673-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr673-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #673
- [`endojs-endo-but-for-bots-pr674-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr674-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #674
- [`endojs-endo-but-for-bots-pr675-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr675-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #675
- [`endojs-endo-but-for-bots-pr690-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr690-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #690
- [`endojs-endo-but-for-bots-pr695-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr695-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #695
- [`endojs-endo-but-for-bots-pr697-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr697-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #697
- [`endojs-endo-but-for-bots-pr709-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr709-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #709
- [`endojs-endo-but-for-bots-pr711-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr711-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #711
- [`endojs-endo-but-for-bots-pr715-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr715-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #715
- [`endojs-endo-but-for-bots-pr717-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr717-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #717
- [`endojs-endo-but-for-bots-pr735-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr735-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #735
- [`endojs-endo-but-for-bots-pr736-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr736-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #736
- [`endojs-endo-but-for-bots-pr741-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr741-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #741
- [`endojs-endo-but-for-bots-pr756-gauntlet-undraft`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr756-gauntlet-undraft.md) — Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #756
- [`endojs-endo-but-for-bots-pr797-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr797-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #797
- [`endojs-endo-but-for-bots-pr814-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr814-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #814
- [`endojs-endo-but-for-bots-pr879-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr879-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #879
- [`endojs-endo-but-for-bots-pr887-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr887-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #887
- [`endojs-endo-but-for-bots-pr891-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr891-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #891
- [`endojs-endo-but-for-bots-pr892-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr892-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #892
- [`endojs-endo-but-for-bots-pr933-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr933-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #933
- [`endojs-endo-but-for-bots-pr935-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr935-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #935
- [`endojs-endo-but-for-bots-pr938-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr938-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #938
- [`endojs-endo-but-for-bots-pr945-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr945-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #945
- [`endojs-endo-but-for-bots-pr996-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr996-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #996
- [`ironhorse-fuzz-1898f584e9bf841a-repair-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ironhorse-fuzz-1898f584e9bf841a-repair-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1088
- [`ironhorse-fuzz-2276f4edebdcb3bb-repair-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ironhorse-fuzz-2276f4edebdcb3bb-repair-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1088
- [`ironhorse-fuzz-314f811064b8febb-repair-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ironhorse-fuzz-314f811064b8febb-repair-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1088
- [`ironhorse-fuzz-66facfd52ae8c673-repair-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ironhorse-fuzz-66facfd52ae8c673-repair-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1088
- [`ironhorse-fuzz-6f0b586a80019097-repair-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ironhorse-fuzz-6f0b586a80019097-repair-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1088
- [`ironhorse-fuzz-91afec2d990bc402-repair-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ironhorse-fuzz-91afec2d990bc402-repair-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1088
- [`ironhorse-fuzz-ab889c8f6184c60d-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ironhorse-fuzz-ab889c8f6184c60d-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1088
- [`kriscendobot-agoric-sdk-pr10-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/kriscendobot-agoric-sdk-pr10-gauntlet-clean.md) — Gauntlet stage: CLEAN — kriscendobot/agoric-sdk PR #10
- [`kriscendobot-agoric-sdk-pr18-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/kriscendobot-agoric-sdk-pr18-gauntlet-clean.md) — Gauntlet stage: CLEAN — kriscendobot/agoric-sdk PR #18
- [`kriscendobot-vattr97-pr1-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/kriscendobot-vattr97-pr1-gauntlet-clean.md) — Gauntlet stage: CLEAN — kriscendobot/vattr97 PR #1

### doin (11)
- [`ebfb-exo-stream-drop-base64-stream-methods`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-exo-stream-drop-base64-stream-methods.md) — Retire streamBase64() from @endo/exo-stream and collapse the bytes surface
- [`endojs-endo-but-for-bots-pr1098-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1098-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1098
- [`endojs-endo-but-for-bots-pr249-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr249-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #249
- [`endojs-endo-but-for-bots-pr356-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr356-shepherd.md) — shepherd (auto: red CI) on endojs/endo-but-for-bots PR #356
- [`garden-pr-review-sequence-refresh-20260831`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/garden-pr-review-sequence-refresh-20260831.md) — What to do
- [`ironhorse-fuzz-45f4af87eaf627c7-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ironhorse-fuzz-45f4af87eaf627c7-repair.md) — Fix Ironhorse fuzz finding 45f4af87eaf627c7 (target differential_regexp) and ...
- [`ironhorse-fuzz-bc3d0df623811a38-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ironhorse-fuzz-bc3d0df623811a38-repair.md) — Fix Ironhorse fuzz finding bc3d0df623811a38 (target differential_regexp_surfa...
- [`ironhorse-fuzz-f2f53bb078bc8a4e-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ironhorse-fuzz-f2f53bb078bc8a4e-repair.md) — Fix Ironhorse fuzz finding f2f53bb078bc8a4e (target differential_regexp) and ...
- [`ironhorse-fuzz-fcbb16f5721e8fd2-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ironhorse-fuzz-fcbb16f5721e8fd2-repair.md) — Fix Ironhorse fuzz finding fcbb16f5721e8fd2 (target differential_source) and ...
- [`ironhorse-fuzz-repromote-quarantined`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ironhorse-fuzz-repromote-quarantined.md) — Re-promote the quarantined ironhorse fuzz-repair jobs
- [`minion-town-weblet-ocap-synthesis-units-4-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/minion-town-weblet-ocap-synthesis-units-4-5.md) — minion.town § 9 residual cleanup — units 4 and 5, BEFORE the weblet→clip rename

### tada (6486)
- [`endojs-endo-but-for-bots-pr300-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr300-shepherd.md) — shepherd (auto) retired: CI recovered/settled before claim
- [`endojs-endo-but-for-bots-pr1098-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr1098-gauntlet-panel-3.md) — Completion report
- [`ironhorse-fuzz-repair-template-policy-rewrite`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/ironhorse-fuzz-repair-template-policy-rewrite.md) — Cost
- [`endojs-endo-but-for-bots-pr1099-e2aa4377`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr1099-e2aa4377.md) — Cost
- [`endojs-endo-but-for-bots-pr266-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr266-gauntlet-fix-3.md) — Completion report
- … and 6481 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`build-kebab-case-lint-wildcard-test262`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-kebab-case-lint-wildcard-test262.md) — _normal_ · Reconstruct the kebab-case file-name linter (endojs/endo#2947) with WILDCARD ...
- [`build-npm-registry-as-directory-tree-review5064787686-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-npm-registry-as-directory-tree-review5064787686-r2.md) — _normal_ · Build the approved npm registry directory-tree design (halt recovery)
- [`build-readableblob-range-attenuation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-readableblob-range-attenuation.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`dependabotany-recheck-endo-but-for-bots-20260817-170501`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/dependabotany-recheck-endo-but-for-bots-20260817-170501.md) — _normal_ · Daily dependabotany backstop for endo-but-for-bots
- [`dependabotany-recheck-endo-but-for-bots-20260819-170501`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/dependabotany-recheck-endo-but-for-bots-20260819-170501.md) — _normal_ · Daily dependabotany backstop for endo-but-for-bots
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`drive-mystic-rollout-20260723`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/drive-mystic-rollout-20260723.md) — _low_ · ---
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
- [`ebfb-llm-xs-daemon-bundle-reconcile`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-xs-daemon-bundle-reconcile.md) — _normal_ · ---
- [`ebfb-pr977-surface-drift-fix-20260822`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-pr977-surface-drift-fix-20260822.md) — _normal_ · Diagnosis (verify before editing)
- [`ebfb-reconcile-xsnap-pending-jobs-861-864`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-reconcile-xsnap-pending-jobs-861-864.md) — _normal_ · Reconcile the two xsnap pending-jobs fixes: adopt #864, close #861
- [`endo-but-for-bots-node-pin-ci-rerun`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-but-for-bots-node-pin-ci-rerun.md) — _normal_ · ---
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`endo-sturdyref-agent-surface-build-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-agent-surface-build-gauntlet.md) — _normal_ · ---
- [`endo-sturdyref-enliven-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-enliven-design.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet-panel-3.md) — _normal_ · Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1085
- [`endojs-endo-but-for-bots-pr1023-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1023-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1023
- [`endojs-endo-but-for-bots-pr1038-c9b18630`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1038-c9b18630.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #1038
- [`endojs-endo-but-for-bots-pr1038-fix-20260828`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1038-fix-20260828.md) — _normal_ · Revalidate endojs/endo-but-for-bots PR #1038 after post-approval head movement
- [`endojs-endo-but-for-bots-pr1046-fuzz-shepherd-20260827-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1046-fuzz-shepherd-20260827-r2.md) — _normal_ · Fix the settled Ironhorse fuzz failure on endojs/endo-but-for-bots PR #1046
- [`endojs-endo-but-for-bots-pr1046-generator-frame-regression-20260828`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1046-generator-frame-regression-20260828.md) — _normal_ · Fix Ironhorse regression: valid generator frames wrongly degraded to Halt (en...
- [`endojs-endo-but-for-bots-pr1051-fixer`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1051-fixer.md) — _normal_ · fixer: migrate release.yml config for changesets/action v2 (endojs/endo-but-f...
- [`endojs-endo-but-for-bots-pr1052-dependabot`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1052-dependabot.md) — _normal_ · botanist (auto: dependabot PR) on endojs/endo-but-for-bots PR #1052
- [`endojs-endo-but-for-bots-pr1056-dependabot`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1056-dependabot.md) — _normal_ · botanist (auto: dependabot PR) on endojs/endo-but-for-bots PR #1056
- [`endojs-endo-but-for-bots-pr1059-rebase-20260828`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-rebase-20260828.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1074-gauntlet-20260828-fix-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1074-gauntlet-20260828-fix-4.md) — _normal_ · Gauntlet stage: FIX round 4 — endojs/endo-but-for-bots PR #1074
- [`endojs-endo-but-for-bots-pr1074-gauntlet-resume-20260828-0935-panel-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1074-gauntlet-resume-20260828-0935-panel-5.md) — _normal_ · Gauntlet stage: PANEL round 5 — endojs/endo-but-for-bots PR #1074
- [`endojs-endo-but-for-bots-pr1075-gauntlet-20260828-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1075-gauntlet-20260828-panel-3.md) — _normal_ · Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1075
- [`endojs-endo-but-for-bots-pr1078-gauntlet-20260828-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1078-gauntlet-20260828-fix-2.md) — _normal_ · Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1078
- [`endojs-endo-but-for-bots-pr1085-b27f483f`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1085-b27f483f.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #1085
- [`endojs-endo-but-for-bots-pr132-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #132
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`endojs-endo-but-for-bots-pr216-review-closeout-20260827`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr216-review-closeout-20260827.md) — _normal_ · Close out the remaining maintainer review state on endojs/endo-but-for-bots P...
- [`endojs-endo-but-for-bots-pr282-gauntlet-20260827-r2-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr282-gauntlet-20260827-r2-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #282
- [`endojs-endo-but-for-bots-pr475-fix-review-5001589064`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-fix-review-5001589064.md) — _normal_ · Address kriskowal CHANGES_REQUESTED review on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr475-review-33691e01`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-33691e01.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr475-review-38d1f281`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-38d1f281.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr475-review-4b9e411c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-4b9e411c.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr796-shepherd-20260827`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr796-shepherd-20260827.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr807-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr807-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #807
- [`endojs-endo-but-for-bots-pr881-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr881-gauntlet.md) — _normal_ · Run the gauntlet: attenuated Google Sheets facets
- [`endojs-endo-but-for-bots-pr890-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr890-gauntlet-panel-3.md) — _normal_ · Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #890
- [`endojs-endo-but-for-bots-pr897-weave`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr897-weave.md) — _normal_ · weave directive on endojs/endo-but-for-bots PR #897
- [`endojs-endo-but-for-bots-pr909-fix-ts-make-daemon`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-fix-ts-make-daemon.md) — _normal_ · Fix: endo make / endo archive TypeScript support is broken (endojs/endo-but-f...
- [`endojs-endo-but-for-bots-pr909-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #909
- [`endojs-endo-but-for-bots-pr946-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr946-conduct.md) — _normal_ · Finalize (curate → merge) endojs/endo-but-for-bots PR #946
- [`endor-host-hook-surface-20260827-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-host-hook-surface-20260827-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #282
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`finbot-pr5-panel-20260801`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-pr5-panel-20260801.md) — _low_ · Run the required merge-governance panel for kriscendobot/finbot PR #5 (curren...
- [`finbot-pr6-fix-panel-r5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-pr6-fix-panel-r5.md) — _low_ · Fix the round-5 merge-governance panel must-fix findings for kriscendobot/fin...
- [`finbot-progress-20260730-020502-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-progress-20260730-020502-gauntlet-panel-1.md) — _low_ · Gauntlet stage: PANEL round 1 — kriscendobot/finbot PR #5
- [`fix-endojs-endo-but-for-bots-pr1059-failclosed`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-endojs-endo-but-for-bots-pr1059-failclosed.md) — _normal_ · fix: address kumavis's fail-closed persistence review on endojs/endo-but-for-...
- [`fix-usage-meter-unbound-var-and-widen-shellcheck-ci`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-usage-meter-unbound-var-and-widen-shellcheck-ci.md) — _normal_ · Grounding incident
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`fu-build-exo-google-sheets-facets-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-build-exo-google-sheets-facets-5.md) — _normal_ · ---
- [`fu-guard-worker-self-disqualify-missing-agent-bin-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-guard-worker-self-disqualify-missing-agent-bin-1.md) — _normal_ · ---
- [`fu-requeue-ps23-stranded-claims-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-requeue-ps23-stranded-claims-4.md) — _normal_ · ---
- [`fu-xs2rust-endor-debugger-caught-vs-uncaught-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-xs2rust-endor-debugger-caught-vs-uncaught-1.md) — _normal_ · ---
- [`fu-xs2rust-endor-debugger-caught-vs-uncaught-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-xs2rust-endor-debugger-caught-vs-uncaught-4.md) — _normal_ · ---
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`improve-auto-gauntlet-issue-ref`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-auto-gauntlet-issue-ref.md) — _normal_ · ---
- [`ironhorse-fuzz-05264cccae42245a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-05264cccae42245a-repair.md) — _normal_ · Fix Ironhorse fuzz finding 05264cccae42245a (target differential_source) and ...
- [`ironhorse-fuzz-12aca768c2e73c73-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-12aca768c2e73c73-repair.md) — _normal_ · Fix Ironhorse fuzz finding 12aca768c2e73c73 (target differential_regexp) and ...
- [`ironhorse-fuzz-13b68e2edb67861a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-13b68e2edb67861a-repair.md) — _normal_ · Fix Ironhorse fuzz finding 13b68e2edb67861a (target differential_regexp) and ...
- [`ironhorse-fuzz-197b32cc30bdd4fe-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-197b32cc30bdd4fe-repair.md) — _normal_ · Fix Ironhorse fuzz finding 197b32cc30bdd4fe (target differential_regexp_surfa...
- [`ironhorse-fuzz-1a2012ae1ec44d21-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1a2012ae1ec44d21-repair.md) — _normal_ · Fix Ironhorse fuzz finding 1a2012ae1ec44d21 (target differential_regexp_surfa...
- [`ironhorse-fuzz-1cb63ec6f8e6fc22-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1cb63ec6f8e6fc22-repair.md) — _normal_ · Fix Ironhorse fuzz finding 1cb63ec6f8e6fc22 (target differential_regexp_surfa...
- [`ironhorse-fuzz-1cd4ddc72d5801c4-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1cd4ddc72d5801c4-repair.md) — _normal_ · Fix Ironhorse fuzz finding 1cd4ddc72d5801c4 (target differential_regexp_surfa...
- [`ironhorse-fuzz-1dc231089278c110-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1dc231089278c110-repair.md) — _normal_ · Fix Ironhorse fuzz finding 1dc231089278c110 (target differential_regexp) and ...
- [`ironhorse-fuzz-27824c75429b8581-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-27824c75429b8581-repair.md) — _normal_ · Fix Ironhorse fuzz finding 27824c75429b8581 (target differential_source) and ...
- [`ironhorse-fuzz-284de587e16bce32-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-284de587e16bce32-repair.md) — _normal_ · Fix Ironhorse fuzz finding 284de587e16bce32 (target differential_source) and ...
- [`ironhorse-fuzz-29a24c1b1052ec91-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-29a24c1b1052ec91-repair.md) — _normal_ · Fix Ironhorse fuzz finding 29a24c1b1052ec91 (target differential_regexp) and ...
- [`ironhorse-fuzz-2a2de75b75de4894-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-2a2de75b75de4894-repair.md) — _normal_ · Fix Ironhorse fuzz finding 2a2de75b75de4894 (target differential_source) and ...
- [`ironhorse-fuzz-2cc2ac67ba7e9b9f-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-2cc2ac67ba7e9b9f-repair.md) — _normal_ · Fix Ironhorse fuzz finding 2cc2ac67ba7e9b9f (target differential_regexp_surfa...
- [`ironhorse-fuzz-3310b49d21f64878-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-3310b49d21f64878-repair.md) — _normal_ · Fix Ironhorse fuzz finding 3310b49d21f64878 (target differential_source) and ...
- [`ironhorse-fuzz-378372c8706a48a8-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-378372c8706a48a8-repair.md) — _normal_ · Fix Ironhorse fuzz finding 378372c8706a48a8 (target differential_regexp_surfa...
- [`ironhorse-fuzz-37e026fd30cbae19-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-37e026fd30cbae19-repair.md) — _normal_ · Fix Ironhorse fuzz finding 37e026fd30cbae19 (target differential_source) and ...
- [`ironhorse-fuzz-3a6aab9d9d140c2c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-3a6aab9d9d140c2c-repair.md) — _normal_ · Fix Ironhorse fuzz finding 3a6aab9d9d140c2c (target differential_regexp_surfa...
- [`ironhorse-fuzz-3fc02d8b57faa79a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-3fc02d8b57faa79a-repair.md) — _normal_ · Fix Ironhorse fuzz finding 3fc02d8b57faa79a (target differential_source) and ...
- [`ironhorse-fuzz-4658b8adc7bdd428-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-4658b8adc7bdd428-repair.md) — _normal_ · Fix Ironhorse fuzz finding 4658b8adc7bdd428 (target differential_source) and ...
- [`ironhorse-fuzz-50834e82d3af453d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-50834e82d3af453d-repair.md) — _normal_ · Fix Ironhorse fuzz finding 50834e82d3af453d (target differential_regexp_surfa...
- [`ironhorse-fuzz-51c6a212946102f6-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-51c6a212946102f6-repair.md) — _normal_ · Fix Ironhorse fuzz finding 51c6a212946102f6 (target differential_regexp) and ...
- [`ironhorse-fuzz-557805e944888b5a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-557805e944888b5a-repair.md) — _normal_ · Fix Ironhorse fuzz finding 557805e944888b5a (target differential_regexp_surfa...
- [`ironhorse-fuzz-5c9d2506e6048f4a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-5c9d2506e6048f4a-repair.md) — _normal_ · Fix Ironhorse fuzz finding 5c9d2506e6048f4a (target differential_regexp_surfa...
- [`ironhorse-fuzz-5e7a173f899ae7a1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-5e7a173f899ae7a1-repair.md) — _normal_ · Fix Ironhorse fuzz finding 5e7a173f899ae7a1 (target differential_regexp) and ...
- [`ironhorse-fuzz-5eeb0aadb2004075-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-5eeb0aadb2004075-repair.md) — _normal_ · Fix Ironhorse fuzz finding 5eeb0aadb2004075 (target differential_regexp) and ...
- [`ironhorse-fuzz-67ca18e4febe7a34-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-67ca18e4febe7a34-repair.md) — _normal_ · Fix Ironhorse fuzz finding 67ca18e4febe7a34 (target differential_source) and ...
- [`ironhorse-fuzz-6ba52f2bdc534545-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6ba52f2bdc534545-repair.md) — _normal_ · Fix Ironhorse fuzz finding 6ba52f2bdc534545 (target differential_regexp_surfa...
- [`ironhorse-fuzz-6be90176ff07c648-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6be90176ff07c648-repair.md) — _normal_ · Fix Ironhorse fuzz finding 6be90176ff07c648 (target differential_regexp) and ...
- [`ironhorse-fuzz-6ca7a76e0bfe3435-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6ca7a76e0bfe3435-repair.md) — _normal_ · Fix Ironhorse fuzz finding 6ca7a76e0bfe3435 (target differential_regexp_surfa...
- [`ironhorse-fuzz-7072dc2d72d9e2fd-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-7072dc2d72d9e2fd-repair.md) — _normal_ · Fix Ironhorse fuzz finding 7072dc2d72d9e2fd (target differential_regexp) and ...
- [`ironhorse-fuzz-7637ac162a0b916a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-7637ac162a0b916a-repair.md) — _normal_ · Fix Ironhorse fuzz finding 7637ac162a0b916a (target differential_regexp) and ...
- [`ironhorse-fuzz-79f0475dd0440b2d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-79f0475dd0440b2d-repair.md) — _normal_ · Fix Ironhorse fuzz finding 79f0475dd0440b2d (target differential_regexp) and ...
- [`ironhorse-fuzz-822848c732a1b805-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-822848c732a1b805-repair.md) — _normal_ · Fix Ironhorse fuzz finding 822848c732a1b805 (target differential_regexp) and ...
- [`ironhorse-fuzz-89e303d17e33b117-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-89e303d17e33b117-repair.md) — _normal_ · Fix Ironhorse fuzz finding 89e303d17e33b117 (target differential_regexp_surfa...
- [`ironhorse-fuzz-8adaa3bbc9cda1ce-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8adaa3bbc9cda1ce-repair.md) — _normal_ · Fix Ironhorse fuzz finding 8adaa3bbc9cda1ce (target differential_source) and ...
- [`ironhorse-fuzz-8b8afc47fcfb223d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8b8afc47fcfb223d-repair.md) — _normal_ · Fix Ironhorse fuzz finding 8b8afc47fcfb223d (target differential_regexp) and ...
- [`ironhorse-fuzz-8ea950859db8a5f7-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8ea950859db8a5f7-repair.md) — _normal_ · Fix Ironhorse fuzz finding 8ea950859db8a5f7 (target differential_regexp) and ...
- [`ironhorse-fuzz-9001b34fa6dd2d80-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-9001b34fa6dd2d80-repair.md) — _normal_ · Fix Ironhorse fuzz finding 9001b34fa6dd2d80 (target differential_regexp_surfa...
- [`ironhorse-fuzz-931a687135cabb0c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-931a687135cabb0c-repair.md) — _normal_ · Fix Ironhorse fuzz finding 931a687135cabb0c (target differential_source) and ...
- [`ironhorse-fuzz-9894aac5ad23c6eb-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-9894aac5ad23c6eb-repair.md) — _normal_ · Fix Ironhorse fuzz finding 9894aac5ad23c6eb (target differential_regexp) and ...
- [`ironhorse-fuzz-9edaa2277fb90f03-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-9edaa2277fb90f03-repair.md) — _normal_ · Fix Ironhorse fuzz finding 9edaa2277fb90f03 (target differential_source) and ...
- [`ironhorse-fuzz-a172d6aba922c9ad-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-a172d6aba922c9ad-repair.md) — _normal_ · Fix Ironhorse fuzz finding a172d6aba922c9ad (target differential_regexp) and ...
- [`ironhorse-fuzz-a7755caa51aa9320-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-a7755caa51aa9320-repair.md) — _normal_ · Fix Ironhorse fuzz finding a7755caa51aa9320 (target differential_source) and ...
- [`ironhorse-fuzz-aaa423e9c5d56067-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-aaa423e9c5d56067-repair.md) — _normal_ · Fix Ironhorse fuzz finding aaa423e9c5d56067 (target differential_source) and ...
- [`ironhorse-fuzz-ab41c5d203ace017-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ab41c5d203ace017-repair.md) — _normal_ · Fix Ironhorse fuzz finding ab41c5d203ace017 (target differential_regexp) and ...
- [`ironhorse-fuzz-ac8a8e3d9d3d7f96-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ac8a8e3d9d3d7f96-repair.md) — _normal_ · Fix Ironhorse fuzz finding ac8a8e3d9d3d7f96 (target differential_regexp) and ...
- [`ironhorse-fuzz-ad5b483fc5e0973f-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ad5b483fc5e0973f-repair.md) — _normal_ · Fix Ironhorse fuzz finding ad5b483fc5e0973f (target differential_regexp_surfa...
- [`ironhorse-fuzz-af5b4a677483eac3-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-af5b4a677483eac3-repair.md) — _normal_ · Fix Ironhorse fuzz finding af5b4a677483eac3 (target differential_regexp_surfa...
- [`ironhorse-fuzz-b95320dfb5dd9d3d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-b95320dfb5dd9d3d-repair.md) — _normal_ · Fix Ironhorse fuzz finding b95320dfb5dd9d3d (target differential_regexp_surfa...
- [`ironhorse-fuzz-baad1f22ef053213-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-baad1f22ef053213-repair.md) — _normal_ · Fix Ironhorse fuzz finding baad1f22ef053213 (target differential_regexp_surfa...
- [`ironhorse-fuzz-bc9529ac5818aa24-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bc9529ac5818aa24-repair.md) — _normal_ · Fix Ironhorse fuzz finding bc9529ac5818aa24 (target differential_regexp_surfa...
- [`ironhorse-fuzz-bd4559ecbc0432c1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bd4559ecbc0432c1-repair.md) — _normal_ · Fix Ironhorse fuzz finding bd4559ecbc0432c1 (target differential_source) and ...
- [`ironhorse-fuzz-bf6cfbd74a7487fc-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bf6cfbd74a7487fc-repair.md) — _normal_ · Fix Ironhorse fuzz finding bf6cfbd74a7487fc (target differential_regexp) and ...
- [`ironhorse-fuzz-c6c71d428a37088c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c6c71d428a37088c-repair.md) — _normal_ · Fix Ironhorse fuzz finding c6c71d428a37088c (target differential_regexp_surfa...
- [`ironhorse-fuzz-c781c9b9de456ab2-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c781c9b9de456ab2-repair.md) — _normal_ · Fix Ironhorse fuzz finding c781c9b9de456ab2 (target differential_regexp_surfa...
- [`ironhorse-fuzz-c99f800f6a36e8a6-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c99f800f6a36e8a6-repair.md) — _normal_ · Fix Ironhorse fuzz finding c99f800f6a36e8a6 (target differential_regexp) and ...
- [`ironhorse-fuzz-c9eaa7b5ae02437a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c9eaa7b5ae02437a-repair.md) — _normal_ · Fix Ironhorse fuzz finding c9eaa7b5ae02437a (target differential_regexp_surfa...
- [`ironhorse-fuzz-ccb76a40851925f9-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ccb76a40851925f9-repair.md) — _normal_ · Fix Ironhorse fuzz finding ccb76a40851925f9 (target differential_regexp) and ...
- [`ironhorse-fuzz-cfdc1a28296f23a1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-cfdc1a28296f23a1-repair.md) — _normal_ · Fix Ironhorse fuzz finding cfdc1a28296f23a1 (target differential_regexp) and ...
- [`ironhorse-fuzz-d38f12f4884e186c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-d38f12f4884e186c-repair.md) — _normal_ · Fix Ironhorse fuzz finding d38f12f4884e186c (target differential_regexp_surfa...
- [`ironhorse-fuzz-d5413146a257bc30-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-d5413146a257bc30-repair.md) — _normal_ · Fix Ironhorse fuzz finding d5413146a257bc30 (target differential_regexp_surfa...
- [`ironhorse-fuzz-d87697d49a5f8f67-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-d87697d49a5f8f67-repair.md) — _normal_ · Fix Ironhorse fuzz finding d87697d49a5f8f67 (target differential_source) and ...
- [`ironhorse-fuzz-daf6694aec7856aa-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-daf6694aec7856aa-repair.md) — _normal_ · Fix Ironhorse fuzz finding daf6694aec7856aa (target differential_source) and ...
- [`ironhorse-fuzz-e0fe14e41d5074a6-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e0fe14e41d5074a6-repair.md) — _normal_ · Fix Ironhorse fuzz finding e0fe14e41d5074a6 (target differential_source) and ...
- [`ironhorse-fuzz-e2a75557f762cd9c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e2a75557f762cd9c-repair.md) — _normal_ · Fix Ironhorse fuzz finding e2a75557f762cd9c (target differential_regexp) and ...
- [`ironhorse-fuzz-e4a8e011666d0362-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e4a8e011666d0362-repair.md) — _normal_ · Fix Ironhorse fuzz finding e4a8e011666d0362 (target differential_regexp_surfa...
- [`ironhorse-fuzz-e773681b6d831dc1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e773681b6d831dc1-repair.md) — _normal_ · Fix Ironhorse fuzz finding e773681b6d831dc1 (target differential_regexp_surfa...
- [`ironhorse-fuzz-ecae051e6e8f5a27-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ecae051e6e8f5a27-repair.md) — _normal_ · Fix Ironhorse fuzz finding ecae051e6e8f5a27 (target differential_source) and ...
- [`ironhorse-fuzz-ed616f6ec22095dc-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ed616f6ec22095dc-repair.md) — _normal_ · Fix Ironhorse fuzz finding ed616f6ec22095dc (target differential_regexp) and ...
- [`ironhorse-fuzz-f83dc8932cd3b41a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-f83dc8932cd3b41a-repair.md) — _normal_ · Fix Ironhorse fuzz finding f83dc8932cd3b41a (target differential_regexp) and ...
- [`ironhorse-fuzz-fad9672dc7a6e6be-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-fad9672dc7a6e6be-repair.md) — _normal_ · Fix Ironhorse fuzz finding fad9672dc7a6e6be (target differential_source) and ...
- [`ironhorse-fuzz-fd8517d5f3071227-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-fd8517d5f3071227-repair.md) — _normal_ · Fix Ironhorse fuzz finding fd8517d5f3071227 (target differential_regexp) and ...
- [`ironhorse-ocap-workload-optimization`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-ocap-workload-optimization.md) — _normal_ · The thesis
- [`ironhorse-test262-fable-supervisor-20260829`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-test262-fable-supervisor-20260829.md) — _normal_ · Fable-supervised Ironhorse test262 compliance ratchet on one pull request
- [`kimi-k3-canary-20260723-c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kimi-k3-canary-20260723-c.md) — _low_ · ---
- [`kriscendobot-minion.town-pr37-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr37-gauntlet-panel-6.md) — _normal_ · Gauntlet stage: PANEL round 6 — kriscendobot/minion.town PR #37
- [`local-verify-endo-test-xs-cargo-parity`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/local-verify-endo-test-xs-cargo-parity.md) — _normal_ · ---
- [`measure-requeue-exit-knowledge-loss`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/measure-requeue-exit-knowledge-loss.md) — _normal_ · Measure and close the cross-host gap in requeue session-resume
- [`merge-upstream-master-into-llm-20260717`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/merge-upstream-master-into-llm-20260717.md) — _normal_ · Merge upstream master into the endo-but-for-bots llm branch (propose PR -> sh...
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`minion-town-endo-b3-daemon-deploy-verify`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-endo-b3-daemon-deploy-verify.md) — _normal_ · ---
- [`minion-town-mcp-b2-first-guest-tools-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-mcp-b2-first-guest-tools-gauntlet.md) — _normal_ · ---
- [`minion-town-pr53-gauntlet-20260827`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-pr53-gauntlet-20260827.md) — _normal_ · ---
- [`mtown-git-remote-followup-notice-recheck-20260818`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/mtown-git-remote-followup-notice-recheck-20260818.md) — _normal_ · Notice: recheck the minion.town git-remote follow-up on the daemon commit-for...
- [`open-signup-gate-flip-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`openrouter-zdr-policy-and-stealth-lane`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/openrouter-zdr-policy-and-stealth-lane.md) — _normal_ · Decision 1 — reject logging/training-use by default (answers Open question 1)
- [`panel-seat-tiering-gather`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/panel-seat-tiering-gather.md) — _normal_ · Panel seat tiering — 1/3: GATHER the evidence
- [`proposal-compartments-xs-parser-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/proposal-compartments-xs-parser-design.md) — _normal_ · ---
- [`propose-merge-upstream-master-into-llm-20260801`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/propose-merge-upstream-master-into-llm-20260801.md) — _normal_ · Propose a fresh upstream-master into llm integration PR
- [`refresh-pr-review-sequence-20260823`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/refresh-pr-review-sequence-20260823.md) — _normal_ · What to do
- [`registry-immutable-byte-array-followup-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/registry-immutable-byte-array-followup-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #888
- [`test262-coverage-ratchet-20260827`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/test262-coverage-ratchet-20260827.md) — _normal_ · Serial test262-coverage ratchet — hardened262 + the proper test262 suites
- [`test262-coverage-ratchet-20260828-005006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/test262-coverage-ratchet-20260828-005006.md) — _normal_ · Serial test262-coverage ratchet — hardened262 + the proper test262 suites
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`weave-base-update-and-pin-alias`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-base-update-and-pin-alias.md) — _normal_ · ---

### deferred (top by priority; foreman auto-promotes when idle)
- [`endojs-endo-but-for-bots-pr475-retcon-pass-style-export-20260825`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-retcon-pass-style-export-20260825.md) — _high_ · ---
- [`implement-worktree-teardown-on-job-completion`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/implement-worktree-teardown-on-job-completion.md) — _high_ · ---
- [`endo-bejar-hofman-box-investigation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-bejar-hofman-box-investigation.md) — _normal_ · Investigate the Bejar-Hofman Box: reachable-only-from-roots monitoring
- [`review-improve-merge-base-pinning`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/review-improve-merge-base-pinning.md) — _normal_ · review-improve: merge-base-pinning (prevention + durable sensing)
- [`ebfb-thixotrope-drop-inert-bundle-filter`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-thixotrope-drop-inert-bundle-filter.md) — _normal_ · ---
- [`endo-daemon-sqlite-wal-limit-measurement`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-daemon-sqlite-wal-limit-measurement.md) — _normal_ · Measure the daemon SQLite WAL size policy
- [`endo-sha256-async-arm-followup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sha256-async-arm-followup.md) — _normal_ · ---
- [`ebfb-sturdyref-stack-modernize`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-sturdyref-stack-modernize.md) — _2_ · The situation
- [`endojs-endo-but-for-bots-248-build-ses-import-attributes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-248-build-ses-import-attributes.md) — _normal_ · Build: SES import attributes (design #248)
- [`scholar-ingest-cap-talk`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/scholar-ingest-cap-talk.md) — _normal_ · Ingest the cap-talk mailing list into the library
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — _normal_ · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`design-slots-ocapn-op-lanes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-slots-ocapn-op-lanes.md) — _normal_ · ---
- [`design-endor-git-windows-followup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-endor-git-windows-followup.md) — _normal_ · Follow-up: Windows (MSVC) support for endor-git bindings
- [`endojs-endo-but-for-bots-pr475-review-237b89d7-followup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-237b89d7-followup.md) — _normal_ · Deferred follow-up for endojs/endo-but-for-bots PR #475 review 4963804507
- [`endo-immutable-arraybuffer-hardened262-coverage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-immutable-arraybuffer-hardened262-coverage.md) — _normal_ · Extend hardened test262 coverage to every immutable-arraybuffer method
- [`endo-marshal-passables-equal-ava-operator`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-marshal-passables-equal-ava-operator.md) — _normal_ · ava context patch: byteArray-aware passablesEqual operator
- [`endojs-endo-but-for-bots-migrate-agents-to-agentry-scuttle-lal`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-migrate-agents-to-agentry-scuttle-lal.md) — _normal_ · Design/plan: migrate remaining agents to agentry; scuttle the lal providers
- [`endojs-endo-but-for-bots-pass-style-src-naming`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pass-style-src-naming.md) — _normal_ · regularize pass-style src file naming convention — endojs/endo-but-for-bots
- [`garden-gauntlet-reexport-policy-check`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-gauntlet-reexport-policy-check.md) — _normal_ · propose a gauntlet check that prevents plain re-export policy violations
- [`ironhorse-iterator-intrinsic-metadata`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-iterator-intrinsic-metadata.md) — _normal_ · fix Ironhorse %IteratorPrototype% / %AsyncIteratorPrototype% intrinsic metadata
- [`minion-town-guest-peer-fetch-verify`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-guest-peer-fetch-verify.md) — _normal_ · Verify peer enlivenSturdyRef fetch of a minion.town guest by formula id
- [`wire-siwe-onchain-authz-minion-town-followup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town-followup.md) — _normal_ · Finish wiring SIWE on-chain authz into minion.town's policy layer (maintainer...
- [`local-verify-zizmor-parity`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/local-verify-zizmor-parity.md) — _low_ · local-verify: cover the zizmor workflow audit (CI parity gap)
- [`endojs-endo-but-for-bots-pr1015-2b55429b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1015-2b55429b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1015 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1015-review-348a2017-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1015-review-348a2017-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1015 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1018-review-cf8012a8-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1018-review-cf8012a8-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1018 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1046-041d3163-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1046-041d3163-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1046 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1046-508512a2-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1046-508512a2-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1046 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1046-9fa4b1fe-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1046-9fa4b1fe-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1046 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1046-b476e995-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1046-b476e995-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1046 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1046-review-d7012ba6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1046-review-d7012ba6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1046 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1057-review-f6afbf40-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1057-review-f6afbf40-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1057 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1058-review-af2aa1d9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1058-review-af2aa1d9-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1058 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-a5d1fff6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-a5d1fff6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1060-review-cb8c64d0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1060-review-cb8c64d0-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1060 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1064-review-159dcf9b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1064-review-159dcf9b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1064 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1064-review-9d21882f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1064-review-9d21882f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1064 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1066-review-9a660f54-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1066-review-9a660f54-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1066 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1071-c86034b6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1071-c86034b6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1071 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1071-review-bd9ecfaa-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1071-review-bd9ecfaa-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1071 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1072-review-73226ec0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1072-review-73226ec0-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1072 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1072-review-bb54af10-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1072-review-bb54af10-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1072 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1072-review-c8a0f42b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1072-review-c8a0f42b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1072 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1078-review-178a2e75-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1078-review-178a2e75-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1078 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1079-review-f762ce23-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1079-review-f762ce23-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1079 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1085-b27f483f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1085-b27f483f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1085 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr282-review-215966e1-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr282-review-215966e1-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #282 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr282-review-56b05d5d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr282-review-56b05d5d-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #282 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr340-review-232e84bf-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr340-review-232e84bf-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #340 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr340-review-310af9d3-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr340-review-310af9d3-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #340 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr388-review-37754f3b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr388-review-37754f3b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #388 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr388-review-3f255add-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr388-review-3f255add-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #388 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-023bfb11-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-023bfb11-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-2d5f96ed-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-2d5f96ed-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-728621c6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-728621c6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-f8479d52-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-f8479d52-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-ironhorse-ses-hostrow`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-ironhorse-ses-hostrow.md) — _low_ · Add an Ironhorse+SES host row to the ImmutableArrayBuffer view-behavior matrix
- [`endojs-endo-but-for-bots-pr475-review-1e3eb099-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-1e3eb099-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-1f118200-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-1f118200-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-27339ee8-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-27339ee8-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-33691e01-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-33691e01-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-38d1f281-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-38d1f281-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-4b9e411c-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-4b9e411c-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-a992c5c4-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-a992c5c4-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-cd8864aa-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-cd8864aa-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-d7b66ffe-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-d7b66ffe-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr647-702dd6ab-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr647-702dd6ab-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #647 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr647-review-3c16353b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr647-review-3c16353b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #647 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr796-2e3ae7fe-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr796-2e3ae7fe-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #796 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr819-review-f8bab00f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr819-review-f8bab00f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #819 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr832-e39ce097-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr832-e39ce097-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #832 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr832-review-7bada805-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr832-review-7bada805-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #832 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr832-review-f3554a0a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr832-review-f3554a0a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #832 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr858-review-8add9193-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr858-review-8add9193-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #858 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr858-review-e6eaf772-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr858-review-e6eaf772-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #858 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr888-review-8b40fdbe-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr888-review-8b40fdbe-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #888 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr889-review-3cda2858-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr889-review-3cda2858-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #889 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr889-review-872e16f4-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr889-review-872e16f4-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #889 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr889-review-a90146c0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr889-review-a90146c0-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #889 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr89-review-094bbf1b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr89-review-094bbf1b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #89 (primary: endojs-endo-but-fo...
- [`endojs-endo-but-for-bots-pr896-review-b7fe106c-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr896-review-b7fe106c-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #896 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr987-7fc4cc3a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr987-7fc4cc3a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #987 (primary: endojs-endo-but-f...
- [`explore-ironhorse-promise-chain-shortening`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/explore-ironhorse-promise-chain-shortening.md) — _low_ · Explore: promise resolution chain shortening in Ironhorse
- [`explore-ironhorse-ptc`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/explore-ironhorse-ptc.md) — _low_ · Explore: Proper Tail Calls (PTC) in Ironhorse
- [`kriscendobot-minion.town-pr52-review-86b4c679-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr52-review-86b4c679-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #52 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr53-review-90b51c86-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr53-review-90b51c86-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #53 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr66-review-21dce903-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr66-review-21dce903-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #66 (primary: kriscendobot-minio...
- [`endojs-endo-but-for-bots-pr1071-review-03ec1052-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1071-review-03ec1052-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1071 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr475-241ace77-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-241ace77-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1059-43d08bdd-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-43d08bdd-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1094-a93260ad-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1094-a93260ad-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1094 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr475-3020257d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-3020257d-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1059-beaff99f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-beaff99f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-c4d75838-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-c4d75838-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1072-review-070ee47a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1072-review-070ee47a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1072 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1080-review-09542d7d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1080-review-09542d7d-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1080 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-b9fa19b7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-b9fa19b7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-ac4e65b2-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-ac4e65b2-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1015-review-6a83ee90-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1015-review-6a83ee90-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1015 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1083-review-902463ba-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1083-review-902463ba-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1083 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1099-e2aa4377-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1099-e2aa4377-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1099 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1098-review-859f9c8f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1098-review-859f9c8f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1098 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1018-review-eccc706c-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1018-review-eccc706c-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1018 (primary: endojs-endo-but-...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`endojs-endo-but-for-bots-pr132-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-conduct.md) — awaiting `endojs-endo-but-for-bots-pr132-retcon` · Conduct (finalize -> merge) endojs/endo-but-for-bots PR #132
- [`finbot-pr6-panel-r6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-pr6-panel-r6.md) — awaiting `finbot-pr6-fix-panel-r5` · Run the required merge-governance panel for kriscendobot/finbot PR #6 (round ...
- [`kriscendobot-minion.town-pr54-refresh-after-pr69`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr54-refresh-after-pr69.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/69` · Refresh kriscendobot/minion.town PR #54 after §9 cleanup lands
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
kriscendobot-agoric-3-proposals kriscendobot-agoric-sdk kriscendobot-cosgov kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot kriscendobot-list kriscendobot-minion.town kriscendobot-moddable kriscendobot-ocapn kriscendobot-proposal-compartments kriscendobot-test262 kriscendobot-vattr97 kriscendobot-ymax-e2e kriscendobot-ymax-stdio-mcp

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 2 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 1 gardeners
