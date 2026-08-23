# Garden bulletin

_As of 2026-08-23T05:29:30Z_

## Latest

Multiple gauntlets halted on [endojs/endo-but-for-bots](https://github.com/endojs/endo-but-for-bots) and [kriscendobot/minion.town](https://github.com/kriscendobot/minion.town) PRs after panel stages failed; five doom jobs parked at requeue exhaustion after handler failures (notably [endojs/endo-but-for-bots#1023](https://github.com/endojs/endo-but-for-bots/pull/1023), [#807](https://github.com/endojs/endo-but-for-bots/pull/807), [#946](https://github.com/endojs/endo-but-for-bots/pull/946)). The garden's deploy is stalled ~3 days across two hosts (18 commits behind main2). A node24 CI runner flake (cached binary loss) is blocking merges on [#1006](https://github.com/endojs/endo-but-for-bots/pull/1006) and [#1009](https://github.com/endojs/endo-but-for-bots/pull/1009)—both are MERGE-NOW verdicts pending only CI green. [ByteArray program](https://github.com/endojs/endo-but-for-bots/issues/503) ([#475](https://github.com/endojs/endo-but-for-bots/pull/475), [#503](https://github.com/endojs/endo-but-for-bots/pull/503), [#888](https://github.com/endojs/endo-but-for-bots/pull/888)) is complete and gated on human re-review + finish-line un-draft. Local-verify parity and Node 24 provisioning landed on main2, but the deploy is needed for fleet-wide adoption. Several decisions awaiting maintainer: OpenRouter ZDR policy tier, SIWE allowlist scope, minion.town daemon-native commit formula promotion, and unfreezing [#1046](https://github.com/endojs/endo-but-for-bots/pull/1046)'s shared frozen base (blocked without weaving the stack).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 24d)
- [endojs/endo-but-for-bots#730](https://github.com/endojs/endo-but-for-bots/pull/730) — design(registry): Endor/XS registry transport power (waiting 24d)
- [endojs/endo-but-for-bots#166](https://github.com/endojs/endo-but-for-bots/pull/166) — feat(endor): add rust/endor TUI skeleton (re-opened from #31 under the bot) (waiting 34d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 36d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 37d)
- [endojs/endo-but-for-bots#670](https://github.com/endojs/endo-but-for-bots/pull/670) — feat(lal): subscription OAuth flow and encrypted auth store (M3) (waiting 40d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 51d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 68d)
- [endojs/endo#3073](https://github.com/endojs/endo/pull/3073) — feat(patterns): Add `M.choose` (waiting 102d)
- [endojs/endo-but-for-bots#170](https://github.com/endojs/endo-but-for-bots/pull/170) — feat(pass-style,marshal,eventual-send,captp): pass-style promise + HandledPromise.settle (per #169) (waiting 102d)

_Showing top 10 of 23 parked PRs (ranked by recency + roadmap relevance)._
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

- `20260822T061158Z-e9d1ab` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260822T061158Z-e9d1ab.md)

> awaiting maintainer — beyond proxy authority: gardener wire-siwe-onchain-authz-minion-town, msgid 20260822T055203Z-ae527d.md — The TIER 1 ALLOWLIST asks who gets authenticated access (specific wallet addresses + mcp/tools/mcp/guest/evaluator scopes) to minion.town — that's an authority grant only the maintainer can make (the proxy cannot invent real addresses or decide who is trusted), and it gates the whole question since the tier-1-vs-tier-2 choice is moot without it.

- `20260822T073308Z-21097b` — from gardener:fix-local-verify-node24-eslint-parity, reply_to `fix-local-verify-node24-eslint-parity` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260822T073308Z-21097b.md)

> Restored local-verify ↔ CI Node parity (main2 57d851dfaf), the CI-parity follow-up to [endojs/endo-but-for-bots#1048](https://github.com/endojs/endo-but-for-bots/issues/1048).
>
> Diagnosis: local-verify used whatever `node` was on PATH (Node 22.23.2) while projects pin `.node-version=lts/*`, which CI's actions/setup-node resolves to Node 24. That version skew is why `yarn lint:eslint` read green locally but the Node 24 CI leg found type-aware @endo/restrict-comparison-operands + import/order errors — a silent local-pass/CI-fail.
>
> Fix: a Node runtime-parity guard now runs before any step — resolves the pinned major (.node-version/.nvmrc, incl. lts/* via a static table), adopts a matching nvm/fnm/n/volta runtime (or GARDEN_NODE) if present, else REFUSES to run (`NODE RUNTIME PARITY`, exit 3). Failing loud is deliberate. Regression tests added (55 pass); documented in the skill + field-notes. I did NOT touch PR [endojs/endo-but-for-bots#1048](https://github.com/endojs/endo-but-for-bots/issues/1048).
>
> Heads-up on rollout: current fleet hosts ship only Node 22 with no version manager, so once this deploys the guard will hard-fail every Node-24-pinned project's local verification here until Node 24 is provisioned. I posted a follow-up job `provision-node24-fleet-hosts-20260822` to install/bake Node 24 so the guard adopts rather than refuses. You may want to hold the deploy, or bypass per-run with GARDEN_SKIP_NODE_PARITY=1, until that lands.

- `20260822T073358Z-5ec034` — from gardener:--help, reply_to `--help` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260822T073358Z-5ec034.md)

> (empty message)

- `20260822T073747Z-651a0a` — from gardener:deadmail-20260822T072116Z-cf8821, reply_to `deadmail-20260822T072116Z-cf8821` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260822T073747Z-651a0a.md)

> Heads-up from deadmail job deadmail-20260822T072116Z-cf8821 (self-disclosure of noise I created).
>
> Root cause of this deadmail job: `inbox-send.sh --help` treated `--help` as the <doer> positional, found no live inbox, and dead-lettered an empty message — which garden-deadmail promoted into this job. Fixed on main2 (commit 33dde773be): inbox-send.sh and message-user.sh now intercept `-h|--help` and print usage before consuming the positional, matching the existing guard in post-job.sh/journal-entry.sh; a `-*` doer is also rejected fast.
>
> While verifying, I accidentally ran the still-unpatched DEPLOYED scripts with --help, which reproduced the misfire and created disposable noise — all safe to discard during muster:
> - 2 duplicate deadmail jobs, msgids 073340Z-0229ab (to `--help`) and 073348Z-2bd99c (to `-h`); both are empty misfires, no action needed (fix already landed).
> - 1 empty message in the maintainer inbox, msgid 20260822T073358Z-5ec034 (reply_to=--help); discard.
>
> No project repos touched; garden-only change.

- `20260822T074128Z-b18104` — from gardener:provision-node24-fleet-hosts-20260822, reply_to `provision-node24-fleet-hosts-20260822` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260822T074128Z-b18104.md)

> Provisioned pinned LTS Node 24 for local-verify parity (main2 c1583f733f).
>
> What landed: Dockerfile now bakes Node 24 alongside primary Node 22 into
> /usr/local/n/versions/node/<v>/ (the `n` root local-verify's parity guard
> searches), via a reusable idempotent scripts/jobs/provision-node-lts.sh; garden's
> build_contract_inputs registers it; skills/node-lts-window-watch documents the
> 3-place lockstep bump for the next LTS advance.
>
> Verified on THIS host (endolin-garden2-5bcdff64): in an endo-but-for-bots
> (.node-version=lts/*) worktree local-verify's parity gate now ADOPTS Node 24 and
> exits 0 — no NODE RUNTIME PARITY. A genuinely-missing major still refuses (exit 3).
>
> Propagation heads-up: this is a Dockerfile change. The image bake reaches ALL
> hosts reproducibly, but only on the next rebuild+deploy (deploy-garden.sh) — the
> other running containers (endolin-garden-ece02cb4, ps23, ps23-garden-f65473ae)
> keep refusing Node-24 projects until they are redeployed. For immediate relief
> before a redeploy, run `scripts/jobs/provision-node-lts.sh` inside each running
> container (I can only reach this one from a per-job worker).

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

- `watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4.md)

> root repo /home/kris/garden deploy has been STALLED for ~3d: deployed sha 745fa90891f8692c12b6b14a06b4a5dbdcbbf503 is 18 commit(s) behind origin/main2 (231ef0576752a29e0f54a3c9316ac812a6790da3) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=endolin-garden-ece02cb4)

- `watchdog-root-repo-deploy-stalled-endolin-garden2-5bcdff64` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-endolin-garden2-5bcdff64.md)

> root repo /home/kris/garden2 deploy has been STALLED for ~3d: deployed sha 745fa90891f8692c12b6b14a06b4a5dbdcbbf503 is 18 commit(s) behind origin/main2 (231ef0576752a29e0f54a3c9316ac812a6790da3) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=endolin-garden2-5bcdff64)

- `watchdog-shared-frozen-base-endojs_endo-but-for-bots-llm-e22e67a` — from watchdog:ci-wait-merge, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-shared-frozen-base-endojs_endo-but-for-bots-llm-e22e67a.md)

> conductor unfreeze BLOCKED for [endojs/endo-but-for-bots#1046](https://github.com/endojs/endo-but-for-bots/issues/1046): frozen base 'llm-e22e67a' is shared by open PRs (#1046, #475). Forwarding #1046 to live 'llm' alone would fork the stack off the shared base. Weave the stack forward together, or merge them in dependency order — do not let me do it unilaterally. (#1046 left on the snapshot: not stranded silently, not force-forked.)

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
| Claude | 116.3M | $948.25 _(notional, rate-card)_ | no quota set |
| Codex | 23.6M _(+1080.3M cached)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 91% _(plan; codex-reported)_ |

## Board
### todo (1)
- [`endojs-endo-but-for-bots-pr1046-retcon`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1046-retcon.md) — retcon directive on endojs/endo-but-for-bots PR #1046

### doin (6)
- [`endojs-endo-but-for-bots-pr475-fix-review-5001589064`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr475-fix-review-5001589064.md) — Address kriskowal CHANGES_REQUESTED review on endojs/endo-but-for-bots PR #475
- [`endojs-endo-but-for-bots-pr796-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr796-conduct.md) — Finalize (curate → merge) endojs/endo-but-for-bots PR #796
- [`endojs-endo-but-for-bots-pr796-gauntlet-resume-20260822-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr796-gauntlet-resume-20260822-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #796
- [`endojs-endo-but-for-bots-pr881-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr881-gauntlet.md) — Run the gauntlet: attenuated Google Sheets facets
- [`endojs-endo-but-for-bots-pr909-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr909-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #909
- [`improve-budget-level-failure-diagnostics`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/improve-budget-level-failure-diagnostics.md) — ---

### tada (5456)
- [`endojs-endo-but-for-bots-pr970-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr970-shepherd.md) — Cost
- [`endojs-endo-but-for-bots-pr475-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr475-shepherd.md) — Shepherd report: endojs/endo-but-for-bots#475
- [`endojs-endo-but-for-bots-pr796-gauntlet-resume-20260822-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr796-gauntlet-resume-20260822-panel-1.md) — Cost
- [`kriscendobot-minion.town-pr51-776f7ed7`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/kriscendobot-minion.town-pr51-776f7ed7.md) — Completion report
- [`kriscendobot-minion.town-pr33-rebase-20260823`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/kriscendobot-minion.town-pr33-rebase-20260823.md) — Cost
- … and 5451 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`build-kebab-case-lint-wildcard-test262`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-kebab-case-lint-wildcard-test262.md) — _normal_ · Reconstruct the kebab-case file-name linter (endojs/endo#2947) with WILDCARD ...
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
- [`endojs-endo-but-for-bots-pr1023-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1023-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1023
- [`endojs-endo-but-for-bots-pr1038-c9b18630`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1038-c9b18630.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #1038
- [`endojs-endo-but-for-bots-pr132-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #132
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`endojs-endo-but-for-bots-pr621-weave-20260823`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr621-weave-20260823.md) — _normal_ · pin the merge base / weave endojs/endo-but-for-bots PR #621
- [`endojs-endo-but-for-bots-pr807-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr807-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #807
- [`endojs-endo-but-for-bots-pr897-weave`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr897-weave.md) — _normal_ · weave directive on endojs/endo-but-for-bots PR #897
- [`endojs-endo-but-for-bots-pr909-fix-ts-make-daemon`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-fix-ts-make-daemon.md) — _normal_ · Fix: endo make / endo archive TypeScript support is broken (endojs/endo-but-f...
- [`endojs-endo-but-for-bots-pr946-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr946-conduct.md) — _normal_ · Finalize (curate → merge) endojs/endo-but-for-bots PR #946
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`finbot-pr5-panel-20260801`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-pr5-panel-20260801.md) — _low_ · Run the required merge-governance panel for kriscendobot/finbot PR #5 (curren...
- [`finbot-pr6-fix-panel-r5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-pr6-fix-panel-r5.md) — _low_ · Fix the round-5 merge-governance panel must-fix findings for kriscendobot/fin...
- [`finbot-progress-20260730-020502-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/finbot-progress-20260730-020502-gauntlet-panel-1.md) — _low_ · Gauntlet stage: PANEL round 1 — kriscendobot/finbot PR #5
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`fu-build-exo-google-sheets-facets-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-build-exo-google-sheets-facets-5.md) — _normal_ · ---
- [`fu-guard-worker-self-disqualify-missing-agent-bin-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-guard-worker-self-disqualify-missing-agent-bin-1.md) — _normal_ · ---
- [`fu-requeue-ps23-stranded-claims-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-requeue-ps23-stranded-claims-4.md) — _normal_ · ---
- [`fu-xs2rust-endor-debugger-caught-vs-uncaught-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-xs2rust-endor-debugger-caught-vs-uncaught-1.md) — _normal_ · ---
- [`fu-xs2rust-endor-debugger-caught-vs-uncaught-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-xs2rust-endor-debugger-caught-vs-uncaught-4.md) — _normal_ · ---
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`ironhorse-campaign-paused-20260816`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-campaign-paused-20260816.md) — _normal_ · ---
- [`ironhorse-js26-milestone-async`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-js26-milestone-async.md) — _normal_ · js-26 MILESTONE — async residue (fromAsync + async-generator/for-await + Prom...
- [`ironhorse-js26-milestone-core-builtins`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-js26-milestone-core-builtins.md) — _normal_ · js-26 MILESTONE — self-contained core builtins residue (Date + String/Number/...
- [`ironhorse-js26-milestone-iterator-collections`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-js26-milestone-iterator-collections.md) — _normal_ · js-26 MILESTONE — Iterator global + Iterator Helpers + Map/Set iterator proto...
- [`ironhorse-js26-milestone-native-callables`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-js26-milestone-native-callables.md) — _normal_ · js-26 MILESTONE — invoking native/bound callables (apply/call/bind + Array-me...
- [`ironhorse-js26-milestone-parser-annexb`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-js26-milestone-parser-annexb.md) — _normal_ · js-26 MILESTONE — parser/compiler-unimplemented constructs + Annex-B parse (p...
- [`ironhorse-js26-milestone-with-opcode`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-js26-milestone-with-opcode.md) — _normal_ · js-26 MILESTONE — the with opcode family (VM prerequisite + Annex-B/language/...
- [`ironhorse-ocap-workload-optimization`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-ocap-workload-optimization.md) — _normal_ · The thesis
- [`kimi-k3-canary-20260723-c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kimi-k3-canary-20260723-c.md) — _low_ · ---
- [`kriscendobot-minion.town-pr37-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr37-gauntlet-panel-6.md) — _normal_ · Gauntlet stage: PANEL round 6 — kriscendobot/minion.town PR #37
- [`measure-requeue-exit-knowledge-loss`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/measure-requeue-exit-knowledge-loss.md) — _normal_ · Measure and close the cross-host gap in requeue session-resume
- [`merge-upstream-master-into-llm-20260717`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/merge-upstream-master-into-llm-20260717.md) — _normal_ · Merge upstream master into the endo-but-for-bots llm branch (propose PR -> sh...
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`minion-town-endo-b3-daemon-deploy-verify`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-endo-b3-daemon-deploy-verify.md) — _normal_ · ---
- [`minion-town-mcp-b2-first-guest-tools-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-mcp-b2-first-guest-tools-gauntlet.md) — _normal_ · ---
- [`mtown-git-remote-followup-notice-recheck-20260818`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/mtown-git-remote-followup-notice-recheck-20260818.md) — _normal_ · Notice: recheck the minion.town git-remote follow-up on the daemon commit-for...
- [`open-signup-gate-flip-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`openrouter-zdr-policy-and-stealth-lane`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/openrouter-zdr-policy-and-stealth-lane.md) — _normal_ · Decision 1 — reject logging/training-use by default (answers Open question 1)
- [`panel-seat-tiering-gather`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/panel-seat-tiering-gather.md) — _normal_ · Panel seat tiering — 1/3: GATHER the evidence
- [`proposal-compartments-xs-parser-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/proposal-compartments-xs-parser-design.md) — _normal_ · ---
- [`propose-merge-upstream-master-into-llm-20260801`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/propose-merge-upstream-master-into-llm-20260801.md) — _normal_ · Propose a fresh upstream-master into llm integration PR
- [`registry-immutable-byte-array-followup-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/registry-immutable-byte-array-followup-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #888
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...
- [`weave-base-update-and-pin-alias`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-base-update-and-pin-alias.md) — _normal_ · ---

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
- [`wire-siwe-onchain-authz-minion-town-followup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town-followup.md) — _normal_ · Finish wiring SIWE on-chain authz into minion.town's policy layer (maintainer...
- [`endo-immutable-arraybuffer-hardened262-coverage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-immutable-arraybuffer-hardened262-coverage.md) — _normal_ · Extend hardened test262 coverage to every immutable-arraybuffer method
- [`endo-marshal-passables-equal-ava-operator`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-marshal-passables-equal-ava-operator.md) — _normal_ · ava context patch: byteArray-aware passablesEqual operator
- [`local-verify-zizmor-parity`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/local-verify-zizmor-parity.md) — _low_ · local-verify: cover the zizmor workflow audit (CI parity gap)
- [`explore-ironhorse-promise-chain-shortening`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/explore-ironhorse-promise-chain-shortening.md) — _low_ · Explore: promise resolution chain shortening in Ironhorse
- [`explore-ironhorse-ptc`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/explore-ironhorse-ptc.md) — _low_ · Explore: Proper Tail Calls (PTC) in Ironhorse
- [`endojs-endo-but-for-bots-pr475-review-cd8864aa-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-cd8864aa-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr340-review-310af9d3-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr340-review-310af9d3-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #340 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr475-review-1f118200-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-review-1f118200-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #475 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1046-9fa4b1fe-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1046-9fa4b1fe-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1046 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr475-ironhorse-ses-hostrow`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr475-ironhorse-ses-hostrow.md) — _low_ · Add an Ironhorse+SES host row to the ImmutableArrayBuffer view-behavior matrix

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
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 1 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 2 gardeners
- [ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/ps23): 1 gardeners
- [ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/ps23-garden-f65473ae): 8 gardeners
