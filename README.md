# Garden bulletin

_As of 2026-08-22T02:30:20Z_

## Latest

Deploy has stalled for ~3 days on both hosts (behind origin/main2 by 18 commits). The byteArray complement ([endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/pull/475) + [#503](https://github.com/endojs/endo-but-for-bots/pull/503)) is complete and CI-green, awaiting your re-review to clear CHANGES_REQUESTED; the finish-line piece ([endo-but-for-bots#888](https://github.com/endojs/endo-but-for-bots/pull/888)) is auto-drafted and ready to un-draft once those land. Three gauntlets have halted mid-panel (nodes for minion.town#48, endo-but-for-bots#1023, and endo-but-for-bots#796), and an orchestration child stalled after requeues—all parked. Two dependabot PRs ([endo-but-for-bots#1006](https://github.com/endojs/endo-but-for-bots/pull/1006), [#1009](https://github.com/endojs/endo-but-for-bots/pull/1009)) are green except for a recurring node24-runner CI flake, blocking merge. The maintainer inbox has 40+ unread messages—mostly decisions needed (DNSSEC signing, local model lanes, disclosure timing, and several infrastructure issues) and post-mortems on halted work.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/pull/475) — feat(pass-style): narrow byteArray to plain frozen Uint8Array (waiting 22s)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 23d)
- [endojs/endo-but-for-bots#730](https://github.com/endojs/endo-but-for-bots/pull/730) — design(registry): Endor/XS registry transport power (waiting 23d)
- [endojs/endo-but-for-bots#166](https://github.com/endojs/endo-but-for-bots/pull/166) — feat(endor): add rust/endor TUI skeleton (re-opened from #31 under the bot) (waiting 33d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 32d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 35d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 36d)
- [endojs/endo-but-for-bots#670](https://github.com/endojs/endo-but-for-bots/pull/670) — feat(lal): subscription OAuth flow and encrypted auth store (M3) (waiting 39d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 50d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 67d)

_Showing top 10 of 25 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260728T173844Z-cfda47` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260728T173844Z-cfda47.md)

> Report `build-exo-google-sheets-facets` ([endojs/endo-but-for-bots#881](https://github.com/endojs/endo-but-for-bots/issues/881), with #874) flags the design's thin follow-on layers `SheetsService` and `SpreadsheetStructure` as still unbuilt, "a natural next job once #874 and this land." Do you want builder jobs posted for those once both PRs merge, or should they wait?

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

- `20260801T110926Z-9f7599` — from gardener:minion-town-mcp-b5-retire-toy-tools, reply_to `minion-town-mcp-b5-retire-toy-tools` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260801T110926Z-9f7599.md)

> Closing out the B5 builder instance (not actively holding a worker anymore — the reaper kept requeuing it against a human gate, and the board has no park slot for a claimed job).
>
> Where B5 stands: code complete + locally green on PR [kriscendobot/minion.town#20](https://github.com/kriscendobot/minion.town/issues/20); the required deployed-edge validation is NOT done and is waiting on YOUR call (deploying the still-DRAFT B3->B4->B5 stack to the live 5-tenant box, plus federated user tokens / Gate-1 for E1-E4, plus live daemon restart (E3) and account suspension (E4) — none of which I'll do to production unilaterally).
>
> No action from me is pending. When you want it finished, pick a path from my earlier message (a: authorize me to SSM-deploy + mint/hand a token and I run tools/list + E1-E4; b: you validate at the edge; c: merge the stack so CD deploys, then validate) and re-post/promote the B5 job — a gardener will pick it up and run the deployed-edge sweep.

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

- `20260819T003511Z-93753f` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003511Z-93753f.md)

> From report `dependabotany-recheck-endo-but-for-bots-20260729-012002`: four endojs/endo-but-for-bots dependabot PRs are blocked solely on your approval — #556, #558, #869, #870. #869 has real teeth: it closes GHSA-37j7-fg3j-429f (CRITICAL, VM escape to RCE) in the in-tree happy-dom. Requesting review/approval on these.

- `20260819T003718Z-8431ee` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003718Z-8431ee.md)

> From report `fu-fu-qwen-model-watch-20260728-180502-1-20260728-223502-2`: the ollama container image needs a rebuild to actually land commit `d4a40ed9ba`'s invariant — a consequential host op I'm not spawning autonomously.

- `20260819T003747Z-62301d` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003747Z-62301d.md)

> From report `fu-qwen-model-watch-20260728-180502-1-20260728-223502`: re-enabling the local-model hermit lane (or any systemd change) is a consequential host op — left to you, with the models-dir option laid out in the report.

- `20260819T003803Z-7d3388` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003803Z-7d3388.md)

> From report `improve-promote-plan-poison-reset`: `endo-sturdyref-agent-surface-build-gauntlet` is still parked in `plan/` behind its `go-ahead`, held back by the deadline-overrun marker fixed in this change. Promoting it once the fix deploys is a maintainer-authorization act — flagging it's ready whenever you want to promote.

- `20260819T003813Z-b83dfb` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003813Z-b83dfb.md)

> From report `ironhorse-js-26-map-methods`: four cross-cutting engine-wide gaps (each would close residuals across the whole js-26 Map/Set-methods proposal) each warrant their own feature increment. Worth your prioritization call on sequencing before I queue them.

- `20260819T003825Z-b548b6` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003825Z-b548b6.md)

> From report `issue-kriskowal-garden-67`: next steps are (1) turning "phase 0" (structural shapes + explicit membership checks, no registry/new authority) into an actual PR on the fork, and (2) drilling into the two-phase attestation mechanism against the resolver's existing invitation-based reporting path. This touches the `kriscendobot/agoric-sdk` fork, which per standing scope needs your call rather than an autonomous job.

- `20260819T003838Z-76d819` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T003838Z-76d819.md)

> From report `minion-town-containment-gateway-endo-sock`: the permanent fix (`minion-town-weblet-powers-host-escape-fix`) is not yet deployed. A CD gateway redeploy won't re-arm the hole, but the two un-removed records could reappear and would need the de-registration re-run. Flagging for your awareness given the security-sensitive nature rather than spawning autonomous follow-up.

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

- `20260819T021547Z-7f9907` — from gardener:dependabotany-recheck-endo-but-for-bots-20260818-170501, reply_to `dependabotany-recheck-endo-but-for-bots-20260818-170501` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T021547Z-7f9907.md)

> # Dependabotany (endo-but-for-bots): two MERGE-NOW dependabot PRs blocked on the fleet node24-runner CI flake — decision needed
>
> From the 2026-08-18 daily dependabotany backstop sweep. Two `dependabot[bot]` PRs on `endojs/endo-but-for-bots` have passed full botanist diligence with verdict **MERGE-NOW**, but their autonomous conduct is blocked by the **recurring fleet-wide node24-runner infra flake** (`.../actions-runner/.../externals/node24/bin/node: No such file or directory`) plus a heavy CI-queue backlog. Neither is a PR-diligence problem; both are one green CI run from merge.
>
> **[endojs/endo-but-for-bots#1006](https://github.com/endojs/endo-but-for-bots/issues/1006)** `eslint-plugin-unicorn` 72.0.0 → 73.0.0 (dev-only lint plugin; imported by no runtime/test code). MERGE-NOW: mature (73.0.0 published 2026-08-04, 14d), OSV-clean both sides, no transitive movement, no install script, same publisher `sindresorhus`. I rebased it clean onto live `llm` (head `86b6b4f9913`, ahead 1 / behind ~1). A prior full CI run was 24/25 green with the sole red being the node24 flake on `test (24.18.0, macos-15)` (green on base). Since unicorn runs only at lint time, a `test` cell failure cannot be a regression.
>
> **[endojs/endo-but-for-bots#1009](https://github.com/endojs/endo-but-for-bots/issues/1009)** `npm-packlist` 10.0.4 → 11.3.0 (root devDependency). MERGE-NOW on merits (established 2026-08-16; ledger + PR comments). Sole red is the identical node24 flake on `test (24.x, ubuntu-latest)`. Head is ~65 behind and needs a rebase, which triggers a fresh full CI run that re-rolls the flake.
>
> **Why the conductor spine cannot converge here:** `ci-wait-merge.sh` refuses to merge past ANY failing cell and binds the merge to a rebased (behind=0) head. With CI presently ~30+ min (queue backlog) and base `llm` drifting faster than that, every rebase-to-green cycle re-rolls the node24 flake across ~25 cells and is invalidated by fresh base movement before it can land. This is the same fleet flake escalated on 2026-08-16 (still unanswered), now blocking a second PR.
>
> **Decision needed (either unblocks both):**
> 1. **Merge [endojs/endo-but-for-bots#1006](https://github.com/endojs/endo-but-for-bots/issues/1006) and [endojs/endo-but-for-bots#1009](https://github.com/endojs/endo-but-for-bots/issues/1009) directly** — `llm` has no branch protection, so the node24 flake is a non-required check; both are green but for it and one-click mergeable; or
> 2. **Fix the fleet node24-runner issue** (runner loses its cached node24 binary) so the spine can auto-conduct — this also unblocks [endojs/endo-but-for-bots#877](https://github.com/endojs/endo-but-for-bots/issues/877) / [endojs/endo-but-for-bots#475](https://github.com/endojs/endo-but-for-bots/issues/475) which the 2026-08-16 note tied to the same flake.
>
> The daily backstop (`dependabotany-recheck-endo-but-for-bots`) will keep re-sweeping both rows until they reach a terminal state, so nothing rots; this message is to move the decision off the backstop and onto you.

- `20260819T032608Z-ce16c2` — from gauntlet:build-minion-town-git-content-substrate-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T032608Z-ce16c2.md)

> Gauntlet build-minion-town-git-content-substrate-gauntlet HALTED: stage 'build-minion-town-git-content-substrate-gauntlet-panel-5' (panel) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling.

- `20260819T065506Z-e0dd69` — from orchestrator:endor-fixture-parity-ratchet-campaign-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260819T065506Z-e0dd69.md)

> Orchestration endor-fixture-parity-ratchet-campaign HALTED: child endor-walker-cjs-require stalled after 3 requeues on host endolin-garden-ece02cb4 (limit 2, no progress hint this cycle) (serial, on-child-failure=halt). 1/8 done before halt; parked remainder: endor-walker-exports-resolution endor-walker-dep-classification endor-walker-dynamic-import endor-walker-nested-resolution endor-walker-language-extensions endor-walker-host-hooks

- `20260821T012318Z-92308e` — from gauntlet:endojs-endo-but-for-bots-ironhorse-coverage-matrix-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260821T012318Z-92308e.md)

> Gauntlet endojs-endo-but-for-bots-ironhorse-coverage-matrix-gauntlet HALTED: stage 'endojs-endo-but-for-bots-ironhorse-coverage-matrix-gauntlet-panel-1' (panel) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling.

- `20260821T224706Z-a2e099` — from gauntlet:kriscendobot-minion.town-port-whoami-tool-20260819-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260821T224706Z-a2e099.md)

> Gauntlet kriscendobot-minion.town-port-whoami-tool-20260819-gauntlet HALTED: stage 'kriscendobot-minion.town-port-whoami-tool-20260819-gauntlet-panel-1' (panel) failed or vanished from the board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather than stalling.

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

- `watchdog-handler-budget-overrun-endojs-endo-but-for-bots-pr475-c55fb1c4` — from watchdog:cleric/1, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-handler-budget-overrun-endojs-endo-but-for-bots-pr475-c55fb1c4.md)

> gardener job 'endojs-endo-but-for-bots-pr475-c55fb1c4' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2401s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4.md)

> root repo /home/kris/garden deploy has been STALLED for ~3d: deployed sha 745fa90891f8692c12b6b14a06b4a5dbdcbbf503 is 18 commit(s) behind origin/main2 (231ef0576752a29e0f54a3c9316ac812a6790da3) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=endolin-garden-ece02cb4)

- `watchdog-root-repo-deploy-stalled-endolin-garden2-5bcdff64` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-endolin-garden2-5bcdff64.md)

> root repo /home/kris/garden2 deploy has been STALLED for ~3d: deployed sha 745fa90891f8692c12b6b14a06b4a5dbdcbbf503 is 18 commit(s) behind origin/main2 (231ef0576752a29e0f54a3c9316ac812a6790da3) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=endolin-garden2-5bcdff64)

- `watchdog-triager-fetch-failed-kriscendobot-agoric-3-proposals` — from watchdog:triager/kriscendobot-agoric-3-proposals, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-triager-fetch-failed-kriscendobot-agoric-3-proposals.md)

> RECOVERED — the watchdog condition `triager-fetch-failed-kriscendobot-agoric-3-proposals` has CLEARED (first seen 2026-08-19T00:20:03Z, cleared 2026-08-19T00:20:03Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> triager: fetch for kriscendobot-agoric-3-proposals at /home/kris/garden/worktrees/kriscendobot-agoric-3-proposals.git is SUCCEEDING again; kriscendobot-agoric-3-proposals is being triaged normally.

- `watchdog-triager-fetch-failed-kriscendobot-cosgov` — from watchdog:triager/kriscendobot-cosgov, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-triager-fetch-failed-kriscendobot-cosgov.md)

> RECOVERED — the watchdog condition `triager-fetch-failed-kriscendobot-cosgov` has CLEARED (first seen 2026-08-19T00:19:32Z, cleared 2026-08-19T00:19:32Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> triager: fetch for kriscendobot-cosgov at /home/kris/garden/worktrees/kriscendobot-cosgov.git is SUCCEEDING again; kriscendobot-cosgov is being triaged normally.

- `watchdog-triager-fetch-failed-kriscendobot-endo` — from watchdog:triager/kriscendobot-endo, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-triager-fetch-failed-kriscendobot-endo.md)

> RECOVERED — the watchdog condition `triager-fetch-failed-kriscendobot-endo` has CLEARED (first seen 2026-08-19T00:19:43Z, cleared 2026-08-19T00:19:43Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> triager: fetch for kriscendobot-endo at /home/kris/garden/worktrees/kriscendobot-endo.git is SUCCEEDING again; kriscendobot-endo is being triaged normally.

- `watchdog-triager-fetch-failed-kriscendobot-finbot` — from watchdog:triager/kriscendobot-finbot, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-triager-fetch-failed-kriscendobot-finbot.md)

> RECOVERED — the watchdog condition `triager-fetch-failed-kriscendobot-finbot` has CLEARED (first seen 2026-08-19T00:18:25Z, cleared 2026-08-19T00:18:25Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> triager: fetch for kriscendobot-finbot at /home/kris/garden/worktrees/kriscendobot-finbot.git is SUCCEEDING again; kriscendobot-finbot is being triaged normally.

- `watchdog-triager-fetch-failed-kriscendobot-minion.town` — from watchdog:triager/kriscendobot-minion.town, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-triager-fetch-failed-kriscendobot-minion.town.md)

> RECOVERED — the watchdog condition `triager-fetch-failed-kriscendobot-minion.town` has CLEARED (first seen 2026-08-19T00:19:43Z, cleared 2026-08-19T00:19:43Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> triager: fetch for kriscendobot-minion.town at /home/kris/garden/worktrees/kriscendobot-minion.town.git is SUCCEEDING again; kriscendobot-minion.town is being triaged normally.

- `watchdog-triager-fetch-failed-kriscendobot-ocapn` — from watchdog:triager/kriscendobot-ocapn, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-triager-fetch-failed-kriscendobot-ocapn.md)

> RECOVERED — the watchdog condition `triager-fetch-failed-kriscendobot-ocapn` has CLEARED (first seen 2026-08-19T00:20:16Z, cleared 2026-08-19T00:20:16Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> triager: fetch for kriscendobot-ocapn at /home/kris/garden/worktrees/kriscendobot-ocapn.git is SUCCEEDING again; kriscendobot-ocapn is being triaged normally.

- `watchdog-triager-fetch-failed-kriscendobot-proposal-compartments` — from watchdog:triager/kriscendobot-proposal-compartments, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-triager-fetch-failed-kriscendobot-proposal-compartments.md)

> RECOVERED — the watchdog condition `triager-fetch-failed-kriscendobot-proposal-compartments` has CLEARED (first seen 2026-08-19T00:19:02Z, cleared 2026-08-19T00:19:02Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> triager: fetch for kriscendobot-proposal-compartments at /home/kris/garden/worktrees/kriscendobot-proposal-compartments.git is SUCCEEDING again; kriscendobot-proposal-compartments is being triaged normally.

- `watchdog-triager-fetch-failed-kriscendobot-test262` — from watchdog:triager/kriscendobot-test262, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-triager-fetch-failed-kriscendobot-test262.md)

> RECOVERED — the watchdog condition `triager-fetch-failed-kriscendobot-test262` has CLEARED (first seen 2026-08-19T00:19:09Z, cleared 2026-08-21T13:57:26Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> triager: fetch for kriscendobot-test262 at /home/kris/garden/worktrees/kriscendobot-test262.git is SUCCEEDING again; kriscendobot-test262 is being triaged normally.

- `watchdog-triager-fetch-failed-kriscendobot-vattr97` — from watchdog:triager/kriscendobot-vattr97, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-triager-fetch-failed-kriscendobot-vattr97.md)

> RECOVERED — the watchdog condition `triager-fetch-failed-kriscendobot-vattr97` has CLEARED (first seen 2026-08-19T00:20:16Z, cleared 2026-08-19T00:20:16Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> triager: fetch for kriscendobot-vattr97 at /home/kris/garden/worktrees/kriscendobot-vattr97.git is SUCCEEDING again; kriscendobot-vattr97 is being triaged normally.


## Spend & quota
_Trailing 7d window; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 98.9M | $907.59 _(notional, rate-card)_ | no quota set |
| Codex | 12.8M _(+597.4M cached)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 50% _(plan; codex-reported)_ |

## Board
### todo (8)
- [`endojs-endo-but-for-bots-pr282-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr282-shepherd.md) — shepherd directive on endojs/endo-but-for-bots PR #282
- [`endojs-endo-but-for-bots-pr475-review-e560d700`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr475-review-e560d700.md) — Review directive on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr475-review-f1438d1b`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr475-review-f1438d1b.md) — Review directive on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr475-review-f66ed689`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr475-review-f66ed689.md) — Review directive on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr719-d5f6af54`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr719-d5f6af54.md) — attention directive on endojs/endo-but-for-bots PR #719
- [`endojs-endo-but-for-bots-pr796-resume-gauntlet-after-crc32-20260821`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr796-resume-gauntlet-after-crc32-20260821.md) — Resume the halted gauntlet on endojs/endo-but-for-bots PR #796
- [`fu-minion-town-containment-gateway-endo-sock-1-20260822-000501`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/fu-minion-town-containment-gateway-endo-sock-1-20260822-000501.md) — ---
- [`refresh-pr-review-sequence-20260821`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/refresh-pr-review-sequence-20260821.md) — Refresh pr-review-sequence.md (endojs/endo-but-for-bots) — 3 weeks stale

### doin (3)
- [`endojs-endo-but-for-bots-pr398-conduct-20260822`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr398-conduct-20260822.md) — Conduct endojs/endo-but-for-bots PR #398
- [`endojs-endo-but-for-bots-pr475-c55fb1c4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr475-c55fb1c4.md) — attention directive on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr475-review-90ef14d6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr475-review-90ef14d6.md) — Review directive on endojs/endo-but-for-bots PR #475

### tada (5279)
- [`endojs-endo-but-for-bots-pr475-review-13c49ed1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr475-review-13c49ed1.md) — Cost
- [`endojs-endo-but-for-bots-pr475-review-489e73fc`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr475-review-489e73fc.md) — Cost
- [`endojs-endo-but-for-bots-pr398-shepherd-20260822`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr398-shepherd-20260822.md) — Cost
- [`endojs-endo-but-for-bots-pr475-review-5b54f00b`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr475-review-5b54f00b.md) — Cost
- [`endojs-endo-but-for-bots-pr475-559e6ef8`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr475-559e6ef8.md) — Cost
- … and 5274 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`build-kebab-case-lint-wildcard-test262`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-kebab-case-lint-wildcard-test262.md) — _normal_ · Reconstruct the kebab-case file-name linter (endojs/endo#2947) with WILDCARD ...
- [`build-minion-town-git-content-substrate-gauntlet-panel-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-git-content-substrate-gauntlet-panel-5.md) — _normal_ · Gauntlet stage: PANEL round 5 — kriscendobot/minion.town PR #48
- [`build-readableblob-range-attenuation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-readableblob-range-attenuation.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`dependabotany-recheck-endo-but-for-bots-20260817-170501`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/dependabotany-recheck-endo-but-for-bots-20260817-170501.md) — _normal_ · Daily dependabotany backstop for endo-but-for-bots
- [`dependabotany-recheck-endo-but-for-bots-20260819-170501`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/dependabotany-recheck-endo-but-for-bots-20260819-170501.md) — _normal_ · Daily dependabotany backstop for endo-but-for-bots
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`drive-mystic-rollout-20260723`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/drive-mystic-rollout-20260723.md) — _normal_ · ---
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
- [`ebfb-llm-xs-daemon-bundle-reconcile`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-xs-daemon-bundle-reconcile.md) — _normal_ · ---
- [`ebfb-pr882-bootstrap-generators`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-pr882-bootstrap-generators.md) — _normal_ · ---
- [`ebfb-pr977-lint-unstick`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-pr977-lint-unstick.md) — _normal_ · State
- [`ebfb-reconcile-xsnap-pending-jobs-861-864`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-reconcile-xsnap-pending-jobs-861-864.md) — _normal_ · Reconcile the two xsnap pending-jobs fixes: adopt #864, close #861
- [`endo-but-for-bots-node-pin-ci-rerun`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-but-for-bots-node-pin-ci-rerun.md) — _normal_ · ---
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`endo-sturdyref-agent-surface-build-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-agent-surface-build-gauntlet.md) — _normal_ · ---
- [`endo-sturdyref-enliven-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-enliven-design.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-build-endor-git-bindings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-build-endor-git-bindings.md) — _high_ · build: Endor Git bindings — libgit2 via Zig cross-builds (design PR #987)
- [`endojs-endo-but-for-bots-pr1006-dependabot`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1006-dependabot.md) — _normal_ · botanist (auto: dependabot PR) on endojs/endo-but-for-bots PR #1006
- [`endojs-endo-but-for-bots-pr1023-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1023-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1023
- [`endojs-endo-but-for-bots-pr1024-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1024-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1024
- [`endojs-endo-but-for-bots-pr1026-4e268706`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1026-4e268706.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #1026
- [`endojs-endo-but-for-bots-pr1026-d59ca42b`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1026-d59ca42b.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #1026
- [`endojs-endo-but-for-bots-pr1026-ddfd6228`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1026-ddfd6228.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #1026
- [`endojs-endo-but-for-bots-pr132-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #132
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`endojs-endo-but-for-bots-pr282-pin-rebase-reconcile`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr282-pin-rebase-reconcile.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr286-refresh`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr286-refresh.md) — _normal_ · refresh directive on endojs/endo-but-for-bots PR #286
- [`endojs-endo-but-for-bots-pr340-shepherd-20260816`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr340-shepherd-20260816.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr398-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr398-conduct.md) — _normal_ · Finalize (curate → merge) endojs/endo-but-for-bots PR #398
- [`endojs-endo-but-for-bots-pr403-e97aa392`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr403-e97aa392.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #403
- [`endojs-endo-but-for-bots-pr475-54294cd3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-54294cd3.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr475-arraybuffer-tests-5362070662`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-arraybuffer-tests-5362070662.md) — _normal_ · Add the requested ArrayBuffer and view behavior matrix to pull 475
- [`endojs-endo-but-for-bots-pr475-e8792d98`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-e8792d98.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr475-review-07347c0d`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-07347c0d.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr475-review-1c227402`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-1c227402.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr475-review-1c83e1bb`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-1c83e1bb.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr475-review-92a260ae`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-92a260ae.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr475-review-c85b88c9`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-c85b88c9.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr475-review-f1df1c4f`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-f1df1c4f.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr592-cancel-in-options`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr592-cancel-in-options.md) — _normal_ · Fixer: reshape watchDirectory cancellation API (endojs/endo-but-for-bots #592)
- [`endojs-endo-but-for-bots-pr763-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr763-shepherd.md) — _normal_ · shepherd (auto: red CI) on endojs/endo-but-for-bots PR #763
- [`endojs-endo-but-for-bots-pr796-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr796-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #796
- [`endojs-endo-but-for-bots-pr807-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr807-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #807
- [`endojs-endo-but-for-bots-pr856-weave`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr856-weave.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr881-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr881-gauntlet.md) — _normal_ · Run the gauntlet: attenuated Google Sheets facets
- [`endojs-endo-but-for-bots-pr897-657aab6a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr897-657aab6a.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #897
- [`endojs-endo-but-for-bots-pr897-weave`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr897-weave.md) — _normal_ · weave directive on endojs/endo-but-for-bots PR #897
- [`endojs-endo-but-for-bots-pr909-5e6ae075`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-5e6ae075.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #909
- [`endojs-endo-but-for-bots-pr909-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #909
- [`endojs-endo-but-for-bots-pr946-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr946-conduct.md) — _normal_ · Finalize (curate → merge) endojs/endo-but-for-bots PR #946
- [`endojs-endo-but-for-bots-pr977-64413faf`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr977-64413faf.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #977
- [`endojs-endo-but-for-bots-pr980-review-aa7b9d57`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr980-review-aa7b9d57.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #980
- [`endojs-endo-but-for-bots-pr993-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr993-shepherd.md) — _normal_ · shepherd directive on endojs/endo-but-for-bots PR #993
- [`endojs-endo-but-for-bots-pr998-review-322c54b7`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr998-review-322c54b7.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #998
- [`endojs-endo-but-for-bots-pr998-review-684b93c1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr998-review-684b93c1.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #998
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`finbot-pr5-panel-20260727`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-pr5-panel-20260727.md) — _normal_ · Run the required panel for kriscendobot/finbot PR #5
- [`finbot-pr5-panel-20260801`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-pr5-panel-20260801.md) — _normal_ · Run the required merge-governance panel for kriscendobot/finbot PR #5 (curren...
- [`finbot-pr6-fix-panel-r5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-pr6-fix-panel-r5.md) — _normal_ · Fix the round-5 merge-governance panel must-fix findings for kriscendobot/fin...
- [`finbot-progress-20260730-020502-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-progress-20260730-020502-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — kriscendobot/finbot PR #5
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`fu-build-exo-google-sheets-facets-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-build-exo-google-sheets-facets-5.md) — _normal_ · ---
- [`fu-guard-worker-self-disqualify-missing-agent-bin-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-guard-worker-self-disqualify-missing-agent-bin-1.md) — _normal_ · ---
- [`fu-requeue-ps23-stranded-claims-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-requeue-ps23-stranded-claims-4.md) — _normal_ · ---
- [`fu-xs2rust-endor-debugger-caught-vs-uncaught-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-xs2rust-endor-debugger-caught-vs-uncaught-1.md) — _normal_ · ---
- [`fu-xs2rust-endor-debugger-caught-vs-uncaught-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-xs2rust-endor-debugger-caught-vs-uncaught-4.md) — _normal_ · ---
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _normal_ · ---
- [`ironhorse-campaign-paused-20260816`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-campaign-paused-20260816.md) — _normal_ · ---
- [`ironhorse-js26-milestone-consolidation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-js26-milestone-consolidation.md) — _normal_ · ---
- [`ironhorse-ocap-workload-optimization`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-ocap-workload-optimization.md) — _normal_ · The thesis
- [`kimi-k3-canary-20260723-c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kimi-k3-canary-20260723-c.md) — _normal_ · ---
- [`kriscendobot-agoric-sdk-pr15-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-agoric-sdk-pr15-shepherd.md) — _normal_ · shepherd (auto: red CI) on kriscendobot/agoric-sdk PR #15
- [`kriscendobot-list-pr1-1238bca7`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-list-pr1-1238bca7.md) — _normal_ · attention directive on kriscendobot/list PR #1
- [`kriscendobot-minion.town-pr20-merge-20260819`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr20-merge-20260819.md) — _normal_ · ---
- [`kriscendobot-minion.town-pr20-review-c7ac7b26`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr20-review-c7ac7b26.md) — _normal_ · Review directive on kriscendobot/minion.town PR #20
- [`kriscendobot-minion.town-pr21-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr21-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/minion.town PR #21
- [`kriscendobot-minion.town-pr37-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr37-gauntlet-panel-6.md) — _normal_ · Gauntlet stage: PANEL round 6 — kriscendobot/minion.town PR #37
- [`kriscendobot-minion.town-pr39-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr39-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — kriscendobot/minion.town PR #39
- [`kriscendobot-minion.town-pr47-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr47-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — kriscendobot/minion.town PR #47
- [`measure-requeue-exit-knowledge-loss`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/measure-requeue-exit-knowledge-loss.md) — _normal_ · Measure and close the cross-host gap in requeue session-resume
- [`merge-upstream-master-into-llm-20260717`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/merge-upstream-master-into-llm-20260717.md) — _normal_ · Merge upstream master into the endo-but-for-bots llm branch (propose PR -> sh...
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`minion-town-endo-b3-daemon-deploy-verify`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-endo-b3-daemon-deploy-verify.md) — _normal_ · ---
- [`minion-town-mcp-b2-first-guest-tools-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-mcp-b2-first-guest-tools-gauntlet.md) — _normal_ · ---
- [`mtown-git-remote-followup-notice-recheck-20260818`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/mtown-git-remote-followup-notice-recheck-20260818.md) — _normal_ · Notice: recheck the minion.town git-remote follow-up on the daemon commit-for...
- [`open-signup-gate-flip-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`panel-seat-tiering-gather`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/panel-seat-tiering-gather.md) — _normal_ · Panel seat tiering — 1/3: GATHER the evidence
- [`pr910-mustfix-round2-06-repanel`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/pr910-mustfix-round2-06-repanel.md) — _normal_ · PR #910 fix round 2 — child 06: panel re-run and conditional un-draft
- [`pr910-review-4941452327-fuzz-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/pr910-review-4941452327-fuzz-build.md) — _normal_ · Address errors discovered by the disposable PR 910 fuzzer
- [`proposal-compartments-xs-parser-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/proposal-compartments-xs-parser-design.md) — _normal_ · ---
- [`proposal-compartments-xs-source-phase-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/proposal-compartments-xs-source-phase-design.md) — _normal_ · ---
- [`propose-merge-upstream-master-into-llm-20260801`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/propose-merge-upstream-master-into-llm-20260801.md) — _normal_ · Propose a fresh upstream-master into llm integration PR
- [`registry-immutable-byte-array-followup-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/registry-immutable-byte-array-followup-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #888
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`weave-base-update-and-pin-alias`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-base-update-and-pin-alias.md) — _normal_ · ---
- [`weave-endo-but-for-bots-pr626-stack-surgery-eval`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-endo-but-for-bots-pr626-stack-surgery-eval.md) — _normal_ · Weave endojs/endo-but-for-bots PR #626 (Phase-5 stack-surgery eval) onto llm
- [`wire-siwe-onchain-authz-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town.md) — _normal_ · Wire the chosen SIWE on-chain authorization tier into minion.town's policy layer

### deferred (top by priority; foreman auto-promotes when idle)
- [`design-endor-git-windows-followup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-endor-git-windows-followup.md) — _normal_ · Follow-up: Windows (MSVC) support for endor-git bindings
- [`design-slots-ocapn-op-lanes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-slots-ocapn-op-lanes.md) — _normal_ · ---
- [`ebfb-sturdyref-stack-modernize`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-sturdyref-stack-modernize.md) — _2_ · The situation
- [`ebfb-thixotrope-drop-inert-bundle-filter`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-thixotrope-drop-inert-bundle-filter.md) — _normal_ · ---
- [`endo-bejar-hofman-box-investigation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-bejar-hofman-box-investigation.md) — _normal_ · Investigate the Bejar-Hofman Box: reachable-only-from-roots monitoring
- [`endo-daemon-sqlite-wal-limit-measurement`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-daemon-sqlite-wal-limit-measurement.md) — _normal_ · Measure the daemon SQLite WAL size policy
- [`endo-sha256-async-arm-followup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sha256-async-arm-followup.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-248-build-ses-import-attributes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-248-build-ses-import-attributes.md) — _normal_ · Build: SES import attributes (design #248)
- [`endojs-endo-but-for-bots-pr475-review-237b89d7-followup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-237b89d7-followup.md) — _normal_ · Deferred follow-up for endojs/endo-but-for-bots PR #475 review 4963804507
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — _normal_ · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`review-improve-merge-base-pinning`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/review-improve-merge-base-pinning.md) — _normal_ · review-improve: merge-base-pinning (prevention + durable sensing)
- [`scholar-ingest-cap-talk`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/scholar-ingest-cap-talk.md) — _normal_ · Ingest the cap-talk mailing list into the library
- [`endojs-endo-but-for-bots-pass-style-src-naming`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pass-style-src-naming.md) — _normal_ · regularize pass-style src file naming convention — endojs/endo-but-for-bots
- [`garden-gauntlet-reexport-policy-check`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-gauntlet-reexport-policy-check.md) — _normal_ · propose a gauntlet check that prevents plain re-export policy violations
- [`endojs-endo-but-for-bots-pr475-guard-passstyle-emulated-tests`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-guard-passstyle-emulated-tests.md) — _normal_ · Guard @endo/pass-style byteArray tests against native immutable ArrayBuffer
- [`endojs-endo-but-for-bots-pr282-review-336f6623-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr282-review-336f6623-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #282 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr282-review-c41f9d4a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr282-review-c41f9d4a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #282 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr340-review-833774e0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr340-review-833774e0-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #340 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr388-review-04154a91-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr388-review-04154a91-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #388 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr398-review-262cd801-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr398-review-262cd801-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #398 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-495be080-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-495be080-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-54294cd3-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-54294cd3-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-6bff44d0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-6bff44d0-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-6c19a076-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-6c19a076-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-9885f3d8-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-9885f3d8-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-c4ef0155-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-c4ef0155-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-d34b881a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-d34b881a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-e3925eb5-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-e3925eb5-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-fa8acb7f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-fa8acb7f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-07347c0d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-07347c0d-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-1c83e1bb-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-1c83e1bb-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-237b89d7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-237b89d7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-41c12eb0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-41c12eb0-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-54cdd039-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-54cdd039-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-662af34e-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-662af34e-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-6c57250a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-6c57250a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-92a260ae-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-92a260ae-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-b3132dc6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-b3132dc6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-b4dd5851-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-b4dd5851-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-c85b88c9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-c85b88c9-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-f1df1c4f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-f1df1c4f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-f55c1aef-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-f55c1aef-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr877-review-e5dd1111-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr877-review-e5dd1111-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #877 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr910-43cbbffe-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr910-43cbbffe-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #910 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr972-review-2e698a5b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr972-review-2e698a5b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #972 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr972-review-2f41d5f1-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr972-review-2f41d5f1-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #972 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr972-review-649a8108-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr972-review-649a8108-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #972 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr987-review-a172f78f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr987-review-a172f78f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #987 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr989-review-984f73e9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr989-review-984f73e9-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #989 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr990-review-120b6af8-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr990-review-120b6af8-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #990 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr992-review-9566dff9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr992-review-9566dff9-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #992 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr995-review-5310a0c9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr995-review-5310a0c9-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #995 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr998-review-322c54b7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr998-review-322c54b7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #998 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr998-review-4bd2ba34-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr998-review-4bd2ba34-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #998 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr998-review-619b094b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr998-review-619b094b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #998 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr998-review-65e24259-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr998-review-65e24259-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #998 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr998-review-684b93c1-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr998-review-684b93c1-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #998 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr998-review-833f01c8-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr998-review-833f01c8-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #998 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr998-review-e7a43b46-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr998-review-e7a43b46-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #998 (primary: endojs-endo-but-f...
- [`kriscendobot-list-pr1-1238bca7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-list-pr1-1238bca7-retro.md) — _low_ · Retrospective on kriscendobot/list PR #1 (primary: kriscendobot-list-pr1-1238...
- [`kriscendobot-minion.town-pr20-review-c7ac7b26-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr20-review-c7ac7b26-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #20 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr37-1d4d0715-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr37-1d4d0715-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #37 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr39-review-fb0be7ca-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr39-review-fb0be7ca-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #39 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr47-review-237136a0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr47-review-237136a0-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #47 (primary: kriscendobot-minio...
- [`local-verify-zizmor-parity`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/local-verify-zizmor-parity.md) — _low_ · local-verify: cover the zizmor workflow audit (CI parity gap)
- [`kriscendobot-minion.town-pr48-review-b8fd1e6b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr48-review-b8fd1e6b-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #48 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr21-review-cdeb6f79-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr21-review-cdeb6f79-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #21 (primary: kriscendobot-minio...
- [`endojs-endo-but-for-bots-pr987-2cc814f3-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr987-2cc814f3-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #987 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr719-cc0b4130-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr719-cc0b4130-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #719 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr282-review-d4cb53a7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr282-review-d4cb53a7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #282 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1040-091aec5d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1040-091aec5d-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1040 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr475-review-79645bf9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-79645bf9-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-538450f1-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-538450f1-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-69a8dffc-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-69a8dffc-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-9fe4e7c7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-9fe4e7c7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-e8792d98-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-e8792d98-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-605988a6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-605988a6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-60fc33cf-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-60fc33cf-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-2c700561-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-2c700561-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-5aae699b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-5aae699b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr807-review-ae1e614a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr807-review-ae1e614a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #807 (primary: endojs-endo-but-f...
- [`kriscendobot-garden-pr74-review-f1f9adaa-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr74-review-f1f9adaa-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #74 (primary: kriscendobot-garden-pr7...
- [`endojs-endo-but-for-bots-pr475-review-2ea278c9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-2ea278c9-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-1c227402-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-1c227402-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-cb751bbb-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-cb751bbb-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1040-review-4ed39ee7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1040-review-4ed39ee7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1040 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1040-review-4b910966-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1040-review-4b910966-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1040 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1040-a5932e30-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1040-a5932e30-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1040 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1040-6d1df97f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1040-6d1df97f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1040 (primary: endojs-endo-but-...
- [`explore-ironhorse-promise-chain-shortening`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/explore-ironhorse-promise-chain-shortening.md) — _low_ · Explore: promise resolution chain shortening in Ironhorse
- [`explore-ironhorse-ptc`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/explore-ironhorse-ptc.md) — _low_ · Explore: Proper Tail Calls (PTC) in Ironhorse
- [`endojs-endo-but-for-bots-pr475-2cf2d662-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-2cf2d662-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`kriscendobot-minion.town-pr37-review-41d400bb-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr37-review-41d400bb-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #37 (primary: kriscendobot-minio...
- [`kriscendobot-list-pr1-67917e4b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-list-pr1-67917e4b-retro.md) — _low_ · Retrospective on kriscendobot/list PR #1 (primary: kriscendobot-list-pr1-6791...
- [`endojs-endo-but-for-bots-pr475-review-1011c1c5-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-1011c1c5-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1046-review-f8cbbd32-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1046-review-f8cbbd32-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1046 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr796-95d66baa-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr796-95d66baa-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #796 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr796-review-d2f129fc-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr796-review-d2f129fc-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #796 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr719-d5f6af54-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr719-d5f6af54-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #719 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr398-4bfee361-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr398-4bfee361-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #398 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-5b54f00b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-5b54f00b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-2f4785d0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-2f4785d0-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-5453eefb-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-5453eefb-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-f1438d1b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-f1438d1b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-e560d700-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-e560d700-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-489e73fc-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-489e73fc-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-f66ed689-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-f66ed689-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-90ef14d6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-90ef14d6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-13c49ed1-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-13c49ed1-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`endojs-endo-but-for-bots-pr132-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-conduct.md) — awaiting `endojs-endo-but-for-bots-pr132-retcon` · Conduct (finalize -> merge) endojs/endo-but-for-bots PR #132
- [`finbot-pr6-panel-r6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-pr6-panel-r6.md) — awaiting `finbot-pr6-fix-panel-r5` · Run the required merge-governance panel for kriscendobot/finbot PR #6 (round ...
- [`pr910-review-4941452327-base64-cleanup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/pr910-review-4941452327-base64-cleanup.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/475` · Remove superfluous ReadableBlob base64 machinery after byte-array work lands
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
kriscendobot-agoric-3-proposals kriscendobot-agoric-sdk kriscendobot-cosgov kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot kriscendobot-list kriscendobot-minion.town kriscendobot-moddable kriscendobot-ocapn kriscendobot-proposal-compartments kriscendobot-test262 kriscendobot-vattr97 kriscendobot-ymax-e2e kriscendobot-ymax-stdio-mcp

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 0 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 0 gardeners
- [ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/ps23): 1 gardeners
- [ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/ps23-garden-f65473ae): 8 gardeners
