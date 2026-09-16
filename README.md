# Garden bulletin

_As of 2026-09-16T13:15:59Z_

## Latest

Two infrastructure jobs claimed: [garden-gauntlet-reexport-policy-check](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/garden-gauntlet-reexport-policy-check.md) and [minion-town-guest-peer-fetch-verify](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/minion-town-guest-peer-fetch-verify.md). Maintainer inbox holds five real blockers: [endo-but-for-bots#1100](https://github.com/endojs/endo-but-for-bots/pull/1100) base-drifted (needs semantic port of `stringLengthLimit`→`byteLengthLimit` on 3 call sites), ironhorse computron benchmark design needs answers to 6 open questions before build proceeds, credit-controls orchestration halted on viability-gate timeout, [minion.town#81](https://github.com/kriscendobot/minion.town/pull/81) gauntlet uncertain (premise still live?), and gardener-alias retirement gated on oros-studio host migration. Press body contains detailed triage of five early-September halted gauntlets: items 1–2 were transient (quota), 3 is real base drift (re-scope weave), 4 is green/mergeable (route to human review), 5 partially recovered (re-anchor orchestration at child 2). Token spend holding: Claude 43% quota, Codex 29% plan cap. No todo—board empty except the two doin jobs and 8002 completed.

## Parked for maintainer feedback

- [endojs/endo#3073](https://github.com/endojs/endo/pull/3073) — feat(patterns): Add `M.choose` (waiting 21h)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 4d)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 12d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 14d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 14d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 14d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 14d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 15d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 17d)
- [endojs/endo-but-for-bots#216](https://github.com/endojs/endo-but-for-bots/pull/216) — feat(endor,tui): interactive TUI mode + stub packages (per kriskowal #32 reconstruct) (waiting 20d)

_Showing top 10 of 25 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `ev7-host-introduction-request` — from gardener:minion-town-eval-mail-pair, reply_to `minion-town-eval-mail-pair` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ev7-host-introduction-request.md)

> Identity A's authenticated tools/list succeeded. The send schema says recipients are only @self, @host, or a pet name already held for another party; it has no discovery or attachment field. Please arrange a host-side introduction that gives identity A a pet name for identity B and identity B a reciprocal pet name for identity A, then complete the requested GitHub-federation login checkpoint for B. I will not send to @host because the evaluation cannot clean up a host-inbox message.

- `msg-verify-foreman-partial-unquiesce-target-2-3032a182c44a` — from gardener:verify-foreman-partial-unquiesce-target-2, reply_to `verify-foreman-partial-unquiesce-target-2` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-verify-foreman-partial-unquiesce-target-2-3032a182c44a.md)

> I need one read-only observation from leader endolin-garden-ece02cb4 to complete verify-foreman-partial-unquiesce-target-2. Please return its deployed SHA, the rendered garden-foreman.service GARDEN_FOREMAN_ACTIVE_TARGET line, and the exact /home/kris/garden/.garden-state/foreman/decisions.log line with target=2 guard=promoted or guard=pumped. The foreman promoted this job at 2026-09-16T10:04:07Z, so the evidence should exist. No deploy is requested.

- `doomed-weave-ebfb-1100-pin-merge-base-20260916-deadline-overrun` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-weave-ebfb-1100-pin-merge-base-20260916-deadline-overrun.md)

> DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden-ece02cb4.
> The handler returned rc=124 at its applied 2400s wall-clock budget without productive progress.
> One such observation is conclusive, so the reaper did not spend another full handler budget.
> Split the work into claim-sized stages or raise its handler-timeout.
> The work is preserved at jobs/plan/weave-ebfb-1100-pin-merge-base-20260916; it stays HELD until a human promotes it
> (promote-plan.sh weave-ebfb-1100-pin-merge-base-20260916) or removes it.
> Original job base: weave-ebfb-1100-pin-merge-base-20260916
>
> --- original job body ---
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> Pin the merge base of [endojs/endo-but-for-bots#1100](https://github.com/endojs/endo-but-for-bots/issues/1100) onto current `llm`, resolve
> the resulting conflict, then resume its halted gauntlet from the fix stage.
>
> WHY (triage job triage-halted-gauntlets-20260916, 2026-09-16): the
> `ebfb-exo-stream-drop-base64-stream-methods-gauntlet` fix-2 stage correctly
> declared `orchestration-failed`. This is a REAL, non-transient failure — a plain
> gauntlet re-post would re-fail identically — caused by BASE DRIFT:
>
> - [endojs/endo-but-for-bots#1100](https://github.com/endojs/endo-but-for-bots/issues/1100) migrated `@endo/exo-stream`
>   `stringLengthLimit` -> `byteLengthLimit`.
> - Current `llm`'s `packages/9p-server/src/server.js` still calls the REMOVED
>   `stringLengthLimit` API at 3 sites.
> - GitHub tests the merge ref, so llm's stale call sites plus this PR's renamed
>   type produce tsc + runtime failures. CI is confirmed RED right now (lint +
>   test FAILURE on every leg).
> - The branch is ~360 commits behind.
>
> TASK, in order:
> 1. Pin the merge base per skills/frozen-base-branch and
>    skills/verify-upstream-state-before-pinning: repoint the PR's base onto a
>    pinned `llm-<sha>` branch, then rebase the head onto it.
> 2. Resolve the `9p-server` conflict. This is a SEMANTIC PORT, not a rename —
>    `stringLengthLimit` and `byteLengthLimit` do not mean the same thing, so
>    carry the intent at each of the 3 call sites rather than sed-ing the
>    identifier. Say in your report what you concluded the correct byte limit is
>    at each site and why.
> 3. Verify CI green on the rebased head before handing on.
> 4. Then resume the gauntlet from the FIX stage (not from clean/panel).
>
> The PR premise is LIVE: [endojs/endo-but-for-bots#1100](https://github.com/endojs/endo-but-for-bots/issues/1100) is OPEN draft, not merged,
> not superseded.

- `msg-endojs-endo-but-for-bots-rust-module-lexer-build-c7571ff4a706` — from gardener:endojs-endo-but-for-bots-rust-module-lexer-build, reply_to `endojs-endo-but-for-bots-rust-module-lexer-build` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-endojs-endo-but-for-bots-rust-module-lexer-build-c7571ff4a706.md)

> Re: build job `endojs-endo-but-for-bots-rust-module-lexer-build` (consolidate the Rust module lexer, design PR [endojs/endo-but-for-bots#1019](https://github.com/endojs/endo-but-for-bots/issues/1019)).
>
> I did NOT start the build — its precondition is unmet and its premise is stale. Re-parked it blocked on [endojs/endo-but-for-bots#1019](https://github.com/endojs/endo-but-for-bots/issues/1019) instead of burning a large multi-phase Rust refactor. Details:
>
> 1. Design PR [endojs/endo-but-for-bots#1019](https://github.com/endojs/endo-but-for-bots/issues/1019) is NOT maintainer-accepted. Still OPEN; zero reviews from you. All reviews are the bot design panel, which across 6 rounds still aggregates to **must-fix** with unresolved should-fix items (corpus fixture home; template-literal divergence). The job body is explicit: "promote only after design PR [endojs/endo-but-for-bots#1019](https://github.com/endojs/endo-but-for-bots/issues/1019) is reviewed/accepted by the maintainer. Do not start ahead of design acceptance." It was promoted off the plan queue today (cleared=none), but the design-acceptance gate was not satisfied.
>
> 2. Stale premise: job targets branch `feat/endor-run-entry-point-deps` "where entry_walk.rs lives, not yet on llm." But PR [endojs/endo-but-for-bots#282](https://github.com/endojs/endo-but-for-bots/issues/282) MERGED 2026-08-27 — both `entry_walk.rs` and `cjs_lexer.rs` are on `llm` now. Any real build should target `llm`, and I updated the re-parked body to say so.
>
> 3. Substantive design contradiction the panel flagged: the two scanners the design unifies "with no behavior change" actually DISAGREE on nested template literals — `cjs_lexer.rs` uses a correct depth stack; `entry_walk.rs::scan_static_imports` uses a single counter its own comment admits is incomplete. "Unify byte-identically" is not literally achievable as written; the design must first pick which behavior wins.
>
> Recommendation: land/accept [endojs/endo-but-for-bots#1019](https://github.com/endojs/endo-but-for-bots/issues/1019) (resolving the template-literal-behavior question and the corpus-home should-fix) before I build. Once it merges, the re-parked job auto-unblocks. Or, if you want to proceed now against `llm` accepting the design as-is, reply and I'll pick it up.

- `ironhorse-computron-benchmark-baseline-terminal-complete` — from orchestrator:ironhorse-computron-benchmark-baseline-terminal-complete, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-computron-benchmark-baseline-terminal-complete.md)

> orchestration-event: orchestration-terminal
> orchestration: ironhorse-computron-benchmark-baseline
> orchestration-status: complete
> order: serial
> children-total: 2
> children-failed: 0
> failed-children: 
>
> Orchestration ironhorse-computron-benchmark-baseline complete (serial): all 2 children reached tada without a machine-readable failure declaration.

- `20260904T121309Z-462d5d` — from gardener:publish-overnight-chronicle-clip, reply_to `publish-overnight-chronicle-clip` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T121309Z-462d5d.md)

> publish-overnight-chronicle-clip: could NOT publish the overnight clip — the minion-town MCP server needs interactive OAuth (GitHub browser login) that a non-interactive gardener session can't perform, so mcp__minion-town__publish is unavailable to me (same failure class you hit). I verified all five facts and BUILT the clip (static index.html + style.css, CSP-clean, light/dark, evidence links). I sent the liaison inbox the ready-to-publish base64 payload (msg 20260904T121238Z-b3f04f) — it can publish in one call once its MCP session re-initializes, then send you the <hash>.ocap.site URL. Nothing is serving yet.

- `20260904T231419Z-abbbf9` — from gardener:minion-town-clip-content-store-gc-build, reply_to `minion-town-clip-content-store-gc-build` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260904T231419Z-abbbf9.md)

> The clip GC implementation is committed and pushed on kriscendobot/minion.town branch feat/clip-content-store-gc at 1e4e0e9, but the required ensure-pr.sh cannot create the draft PR: this host cannot resolve a valid kriscendobot gh token, and the unauthenticated REST limit is also exhausted. Please restore the kriscendobot gh login/token on endolin-garden-ece02cb4; I will then rerun the idempotent PR opener and continue into the gauntlet.

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-2.md)

> budget-level changed endolin-garden-ece02cb4 monk workers 3 -> 2 (target 2): budget pool anthropic:endolin-garden-ece02cb4 spend=61369085 cap=143000000 ceiling=4 target=2

- `credit-controls-20260916-halted` — from orchestrator:credit-controls-20260916-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/credit-controls-20260916-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: credit-controls-20260916
> orchestration-status: halted
> child: credit-controls-stale-pr-viability-gate
> failure-kind: handler-timeout
> children-completed: 2
> children-total: 4
> halt-parked-remainder: credit-controls-panel-seat-metering-and-tiering
>
> Orchestration credit-controls-20260916 HALTED: child credit-controls-stale-pr-viability-gate stalled in flight for 2505s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1) (serial, on-child-failure=halt). 2/4 done before halt; parked remainder: credit-controls-panel-seat-metering-and-tiering

- `msg-reminder-daemon-revival-failure-6e023fc1b25f` — from gardener:reminder-daemon-revival-failure, reply_to `reminder-daemon-revival-failure` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-reminder-daemon-revival-failure-6e023fc1b25f.md)

> The reminder daemon revival failure has a non-migration path. The exact missing-`registry` repair exists in closed draft [endojs/endo-but-for-bots#1106](https://github.com/endojs/endo-but-for-bots/issues/1106) (`fbf0c7f28`), but kumavis explicitly closed it as back-support they likely do not want to merge. I therefore did not retry or improvise a production-state migration.
>
> I updated `kriscendobot/minion.town` main at `528c8ce` to decouple reminders from the daemon upgrade: keep `@endo/reminder` as the unconfined, VFS-persistent plugin that superseded [endojs/endo-but-for-bots#609](https://github.com/endojs/endo-but-for-bots/issues/609), [endojs/endo-but-for-bots#617](https://github.com/endojs/endo-but-for-bots/issues/617), and [endojs/endo-but-for-bots#619](https://github.com/endojs/endo-but-for-bots/issues/619); turn the proven old-VFS store adapter into a reviewed/pinned compatibility path with conformance and `@pins` revival coverage; treat any future daemon migration as separately authorized operations work.

- `msg-ironhorse-computron-benchmark-baseline-build-88d207a2b27d` — from gardener:ironhorse-computron-benchmark-baseline-build, reply_to `ironhorse-computron-benchmark-baseline-build` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ironhorse-computron-benchmark-baseline-build-88d207a2b27d.md)

> Re: "make a plan and execute that plan" — Ironhorse computron benchmark-baseline regime (design PR [endojs/endo-but-for-bots#1283](https://github.com/endojs/endo-but-for-bots/issues/1283), source: PR [endojs/endo-but-for-bots#1282](https://github.com/endojs/endo-but-for-bots/issues/1282) review comment).
>
> The plan (job `ironhorse-computron-benchmark-baseline-design`) landed as **draft** PR [endojs/endo-but-for-bots#1283](https://github.com/endojs/endo-but-for-bots/issues/1283) with an `## Open questions` section, and it explicitly states the build's implementation specifics are gated on your answers to those questions. As the builder I completed the plan's unblocked step 1 (the audit) and am **holding the rest** rather than committing a measured, provenance-tracked baseline against unconfirmed parameters. Two reasons I did not just build on the defaults:
>
> 1. **The open questions define the substance that gets committed** — the seed roster (which loads to baseline) and the tolerance bands (the actual gate values). Getting these wrong means re-measuring a provenance-tracked artifact = throwaway churn, and it would land a large new CI-gating PR competing with the still-open, unreviewed design PR.
> 2. **Gate 3 (the "benchmark-established" heart) needs wall-clock measurement on a controlled host.** The garden's container can't produce representative medians; that step must run on a benchmark-suitable host regardless.
>
> **Step-1 audit result — loads [endojs/endo-but-for-bots#1282](https://github.com/endojs/endo-but-for-bots/issues/1282) left with NO surviving own-cost constraint (the gap the regime must fill):**
> - async-generator `await` metering (`await_in_try.rs`): former −20 start-reject pin + reject-matrix → advisory only.
> - suspend-in-try metering (`suspend_in_try_metering.rs`): throw-across-yield/await, cross-frame rebased handler, post-resume → advisory only.
> - promise-combinator meter (`promise_combinator_capability_result_parity.rs`) → advisory only.
> - regexp match-meter (`parity.rs` + fuzz) → advisory; partially retained via `work_limits.rs` (`match_meter_raw == 100·XS_REGEXP_METERING`) and the `finding_*` overflow pins, but representative match loads (subject×pattern) are otherwise unconstrained.
> - Kept-constrained (not in the gap): `error_messages_calls.rs` `==14`, the ~15 interp frozen-cost pins, `ironhorse_meter_bounds.rs`, the `ironhorse-meter-5-raw-N` raw pins, the 53-entry golden corpus, `--repeat`.
>
> **The 6 open questions — with the design's recommendations. Please confirm/adjust:**
> 1. Tolerance bands? Proposed: gate-1 exact (0); gate-2 off-ladder ε=±3%, per-doubling class bands ≈ linear [1.8,2.2] / quadratic [3.6,4.4] / constant [1.0,1.15]; gate-3 fidelity (computrons/sec) ±25%. → *right widths?*
> 2. Gate-2 (deterministic growth envelope) on **PR CI** or nightly? → design recommends **PR CI**.
> 3. Authoritative seed roster? → design proposes the §polynomial-built-ins list (named-property insertion [quadratic], string indexing/iteration, Map/Set bulk insert, for..in, regexp match, async-gen await/suspend) + every load from the audit above. Add/drop any?
> 4. COST_TABLE_VERSION bump: auto-regenerate baselines, or always manual `--write-baseline`? → design recommends **manual** (reviewability).
> 5. Fate of [endojs/endo-but-for-bots#1282](https://github.com/endojs/endo-but-for-bots/issues/1282): **revise in place, land the regime first, merge together to avoid a coverage-gap window** (design recommendation) vs. supersede with a fresh combined PR?
> 6. Two-input (grid) baselines (regexp subject×pattern) in this build, or defer? → design recommends **defer**; ship single-input first.
>
> Once you answer (or say "build on the recommended defaults"), the implementation is queued: successor build job `ironhorse-computron-benchmark-baseline-build-exec` is parked on the plan queue owning steps 2–8, ready to promote. Nothing is lost.

- `msg-triage-halted-gauntlets-20260916-d6b4e6e396b6` — from gardener:triage-halted-gauntlets-20260916, reply_to `triage-halted-gauntlets-20260916` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-triage-halted-gauntlets-20260916-d6b4e6e396b6.md)

> # Triage: five halted gauntlets/orchestrations (parked early Sept)
>
> Per-item disposition below. I checked each PR's live state + CI *now* and the actual
> stage records; I did **not** re-post anything. TL;DR: items 1 & 2 were transient
> (capacity-crunch) halts on now-green PRs — cheap re-posts; items 3 & 4 are real
> non-transient failures that must be **re-scoped**, not retried; item 5 has already
> partly landed and needs re-anchoring, not a restart.
>
> Common context: items 1 & 2 both doomed 2026-09-03/04 with
> `doom_signature=requeue-exhausted`, `requeue_cycles=5`, `deadline_overruns=0`,
> `elapsed_constancy_confirmations=1` — i.e. the handler never overran its own
> deadline; it was requeued 5x without progress and exhausted. That window is the
> known capacity/quota outage (temp API key ~1 day around 09-04). `deadline_overruns=0`
> plus that window means these are **transient infra** halts, not work failures — the
> `failure_classification=unknown` only means the reaper couldn't *prove* it at the time.
>
> ---
>
> ## 1. sweep-ci-starved-conflicting-prs-20260901-gauntlet-clean — [endojs/endo-but-for-bots#1013](https://github.com/endojs/endo-but-for-bots/issues/1013)
> - **Premise: LIVE.** [endojs/endo-but-for-bots#1013](https://github.com/endojs/endo-but-for-bots/issues/1013) (`design: relative routing…`, head
>   `design/relative-routing`) is OPEN, not merged, not superseded. **CI is now ALL GREEN**
>   (build/lint/test/browser-tests/zizmor).
> - **Halt: TRANSIENT** (capacity crunch, see common context; no deadline overrun).
> - The `clean` stage is idempotent — step 1 short-circuits to `clean=done` when CI is
>   green at head, and this is a design-doc PR so the coverage pass is a no-op anyway.
> - **→ RE-POST as-is** (no header change). It will idempotently no-op and let the sweep
>   gauntlet advance. Near-zero cost.
>
> ## 2. build-minion-town-invitation-only-guest-onboarding-gauntlet-panel-2 — [kriscendobot/minion.town#81](https://github.com/kriscendobot/minion.town/issues/81)
> - **Premise: LIVE but STALE.** [kriscendobot/minion.town#81](https://github.com/kriscendobot/minion.town/issues/81) (`Build: capability-first
>   guest onboarding — browser core slice`) OPEN draft, CI `test` green, **not superseded**
>   (its parent design [kriscendobot/minion.town#56](https://github.com/kriscendobot/minion.town/issues/56) merged 09-02; adjacent open work
>   [kriscendobot/minion.town#80](https://github.com/kriscendobot/minion.town/issues/80) / [kriscendobot/minion.town#82](https://github.com/kriscendobot/minion.town/issues/82) / [kriscendobot/minion.town#95](https://github.com/kriscendobot/minion.town/issues/95)
>   doesn't replace it). But it's untouched since 2026-09-02 (~2 weeks) and the browser-core
>   slice was noted as blocked on the Endo guest-native invite/accept dependency.
> - **Halt: TRANSIENT** (same capacity crunch).
> - Caution: this stage carries `handler-timeout=10800` (a full ~3h, 29-seat panel) —
>   exactly the expensive-panel churn the credit investigation flagged.
> - **→ RE-POST panel-2, but confirm the premise first.** Deciding question: *is the
>   [kriscendobot/minion.town#81](https://github.com/kriscendobot/minion.town/issues/81) browser-core slice still the intended live path, or is it
>   parked pending Endo guest-native invite/accept?* If still live → re-post
>   (transient-safe). If it's waiting on that dependency → keep it parked (DROP the stage)
>   rather than burn a 3h panel on a slice that can't merge yet.
>
> ## 3. ebfb-exo-stream-drop-base64-stream-methods-gauntlet — [endojs/endo-but-for-bots#1100](https://github.com/endojs/endo-but-for-bots/issues/1100)
> - **Premise: LIVE** (OPEN draft, not merged, not superseded).
> - **Halt: REAL failure, NOT transient.** fix-2 correctly declared `orchestration-failed`.
>   CI is RED (confirmed still red now: lint + test FAILURE on every leg) from **base
>   drift**: this PR migrated `@endo/exo-stream` `stringLengthLimit`→`byteLengthLimit`,
>   but current `llm`'s `packages/9p-server/src/server.js` still calls the removed
>   `stringLengthLimit` API (3 sites). GitHub tests the merge ref, so llm's stale call
>   site + this PR's renamed type = tsc + runtime failures. A plain gauntlet re-post would
>   re-fail identically.
> - **→ RE-SCOPE: weave / pin-the-merge-base of [endojs/endo-but-for-bots#1100](https://github.com/endojs/endo-but-for-bots/issues/1100) onto current
>   `llm`**, resolving the `9p-server` `stringLengthLimit`→`byteLengthLimit` conflict
>   (semantic port, not just a rename; branch was ~360 commits behind), *then* resume the
>   gauntlet from fix. This is the successor fix-2 already named.
>
> ## 4. build-minion-town-claude-harness-provisioning-gauntlet — [kriscendobot/minion.town#99](https://github.com/kriscendobot/minion.town/issues/99)
> - **Premise: LIVE and healthy.** [kriscendobot/minion.town#99](https://github.com/kriscendobot/minion.town/issues/99) (`feat(deploy): provision
>   pinned Claude harness`) OPEN draft, **mergeable=CLEAN, CI ALL GREEN** (Claude harness
>   amd64/arm64 + test), updated 09-09.
> - **Halt: NOT a work failure** — hit `max_iterations=6`. Every panel round 1–6 returned
>   must-fix; fix-6 achieved green and folded polish (locksmith/saboteur should-fix). The
>   29-seat panel structurally always surfaces fresh nits (and own-PR request-changes
>   downgrades to a comment), so it never emits `pass`. This is precisely the "iteration
>   6/6 churn" cost multiplier the credit investigation named.
> - **→ RE-SCOPE: stop the panel loop.** The code is green + mergeable; another 6-round
>   loop would just grind more nits and cap again. Deciding question: *are the recurring
>   panel must-fixes real merge-blockers, or diminishing polish on already-green,
>   mergeable code?* If diminishing (which the fix-6 folded items suggest), route to a
>   final maintainer review → un-draft/merge rather than re-running the gauntlet.
>
> ## 5. minion-town-clipometer-esbuild-orchestration — HALTED, "0/4 children done"
> - **The halt record is stale.** It recorded child 1 (`…-pipeline`) stalling 2501s vs
>   `handler-timeout=2400s`. But child 1 **subsequently recovered on a reaper requeue and
>   completed** — draft PR [kriscendobot/minion.town#84](https://github.com/kriscendobot/minion.town/issues/84) (`CLIPOMETER on real @endo/captp +
>   esbuild pipeline`) is OPEN, CI green. Its own gauntlet reached panel-3 and was then
>   **archived 09-05 by the liaison during a fleet drain** ("archive all scheduled
>   gauntlets during the drain"), which is why [kriscendobot/minion.town#84](https://github.com/kriscendobot/minion.town/issues/84) never un-drafted.
>   So the true state is: **child 1 done (PR [kriscendobot/minion.town#84](https://github.com/kriscendobot/minion.town/issues/84)), children 2–4
>   still parked.** This is drain-parked, not failed.
> - The 2501s>2400s overrun is real but was non-fatal (requeue recovered it). Child 2
>   (`…-validate`) is heavier than child 1 — it does a full build + **live publish to prod
>   + two-window Playwright** validation — so the budget matters more there.
> - **→ RE-SCOPE (do not restart from child 1):**
>   1. Re-anchor the orchestration to **resume at child 2** (`minion-town-clipometer-esbuild-validate`);
>      child 1's deliverable (PR [kriscendobot/minion.town#84](https://github.com/kriscendobot/minion.town/issues/84)) already exists.
>   2. Give child 2 a raised budget: **`handler-timeout: 3600`** (validate's build+publish+
>      dual-browser run exceeds child 1's 2501s at the 2400 default).
>   3. Note child 2 needs the **real guest MCP identity** (not the disposable
>      `minion-mcp-test-cc`) for the canonical publish — child 1's report flags that if the
>      job env lacks it, that publish step hands to the liaison/maintainer.
>   - Deciding question: *is the live-CLIPOMETER-replacement still wanted (dckc's 09-03
>     directive), and should [kriscendobot/minion.town#84](https://github.com/kriscendobot/minion.town/issues/84)'s archived gauntlet be un-archived
>     to un-draft it?*
>   - Also unresolved from child 1: the published `@endo/patterns@2.0.0` /
>     `@endo/marshal@1.10.0` npm version inconsistency (worked around by vendoring
>     `iterate-reader.js`) — child 2's live run is the checkpoint that confirms the vendored
>     approach works against the real daemon.
>
> ---
> **Summary:** 1 → RE-POST (no change). 2 → RE-POST panel-2 *iff* premise confirmed live,
> else DROP the stage. 3 → RE-SCOPE to a weave/pin-merge-base then resume. 4 → RE-SCOPE:
> stop the loop, human review → un-draft (green+mergeable). 5 → RE-SCOPE: resume at child 2
> with `handler-timeout: 3600`, un-archive [kriscendobot/minion.town#84](https://github.com/kriscendobot/minion.town/issues/84)'s gauntlet. I
> promoted/re-posted nothing.

- `watchdog-rolling-deploy-canary-failed-endolin-garden2-5bcdff64` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-failed-endolin-garden2-5bcdff64.md)

> RECOVERED — the watchdog condition `rolling-deploy-canary-failed-endolin-garden2-5bcdff64` has CLEARED (first seen 2026-09-15T22:26:06Z, cleared 2026-09-16T06:41:07Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> canary endolin-garden2-5bcdff64 passed a later roll; clearing.

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-3` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-3.md)

> budget-level changed endolin-garden-ece02cb4 monk workers 2 -> 3 (target 3): budget pool anthropic:endolin-garden-ece02cb4 spend=45294142 cap=143000000 ceiling=4 target=3

- `20260901T210951Z-6f6a42` — from gardener:probe-opencode-anthropic, reply_to `probe-opencode-anthropic` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260901T210951Z-6f6a42.md)

> The opencode-anthropic probe is blocked from its paid canary on this host: opencode 1.18.25 is not installed and neither ANTHROPIC_API_KEY nor stored opencode credentials are present. I can implement and verify the refused-key and killed-run paths locally, but real non-censored Anthropic USD cost requires a credential. Please provision an Anthropic API key into the worker environment if available; otherwise I will report that criterion as an observed gap.

- `ironhorse-computron-benchmark-baseline-build-gauntlet-review-budget-reached` — from gauntlet:ironhorse-computron-benchmark-baseline-build-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-computron-benchmark-baseline-build-gauntlet-review-budget-reached.md)

> INFO: Gauntlet ironhorse-computron-benchmark-baseline-build-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `msg-minion-town-reminder-daemon-redeploy-20260916-7ef3f7827f32` — from gardener:minion-town-reminder-daemon-redeploy-20260916, reply_to `minion-town-reminder-daemon-redeploy-20260916` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-reminder-daemon-redeploy-20260916-7ef3f7827f32.md)

> AUTHORIZED REDEPLOY HALTED — state-revival dry-run failed; no live redeploy attempted.
>
> Re-verification on 2026-09-16:
>
> - Live `/opt/endo/ENDO_COMMIT` is still `f66505034aaa54ac46294347b2bf0e14655b088a`; `endo-daemon` is active and its socket is present.
> - `packages/daemon/src/client.js` and `mail.js` remain byte-identical between `f6650503` and `0eb88836` and match the live files (SHA-256 `0859aeab…` and `6ef7c33b…`). `0eb88836` is still the expected 1317-commit forward move.
> - A quiescent, restorable live-state snapshot was captured before the experiment at `/var/lib/endo-daemon/snapshots/state-pre-0eb88836-20260916T0548Z.tar.gz` (1.5 MiB compressed, 830 members, SHA-256 `c08fa79ffc6e035a3a9a420106dbc008abf8d79c5856b0b9f500d1b6c1f9aba1`). The live daemon restarted successfully at the old pin.
>
> Dry-run result against a copy of that snapshot:
>
> - Built the exact `0eb88836d6e823ec45409a665efcc4f96d7fd09c` runtime on the ARM64 target and started it with isolated state/cache/socket paths. The copied SQLite database opened, the existing node id `9b03f5b4…` loaded, and all 3635 formula rows deserialized.
> - Revival then failed while seeding the new formula graph: `Error: Invalid formula identifier "[undefined]"`, from `graph.js:onFormulaAdded` via `manager.js:seedFormulaGraphFromPersistence`. The new `0eb88836` graph treats `formula.registry` as a required dependency of every `host` formula, but both persisted `host` rows are schema-v2 records with no `registry` property (their keys end at the older `hostHandle/handle/.../pins` shape).
> - The throw occurred before the isolated daemon created its socket. Therefore no persisted names, guests, or formulas became accessible through `endo list`; the pre-existing live root list (61 names, including 14 guest names) could not be compared on the dry-run daemon. The dry-run service exited status 1.
>
> Per authorization, I stopped here. I did not bump either pin, swap `/opt/endo`, touch the live state, remove the reminder shim, or attempt a migration. The production daemon remains active at `f6650503` with its live socket present. Isolated evidence remains at `/opt/endo-revival-dry-run-20260916` and `/var/lib/endo-daemon/revival-dry-run-20260916`; the failed transient unit is `endo-revival-dry-run-20260916.service`.
>
> The next step needs an explicitly designed and reviewed compatibility migration/default for legacy `host.registry`; I have not improvised one.

- `msg-minion-town-dckc-powers-weblet-audit-20260916-bc25b836fd57` — from gardener:minion-town-dckc-powers-weblet-audit-20260916, reply_to `minion-town-dckc-powers-weblet-audit-20260916` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-dckc-powers-weblet-audit-20260916-bc25b836fd57.md)

> dckc POWERS-weblet audit (minion.town, READ-ONLY) — assessment complete.
>
> The two uncatalogued dckc POWERS weblets surfaced by the 09-04 drift check confer ZERO live authority. Both are legacy records predating [kriscendobot/minion.town#51](https://github.com/kriscendobot/minion.town/issues/51):
> - 806fc2ea… powers="counter"  (qbx4f2xd….ocap.site)
> - c016601e… powers="@none"    (yalgahxp….ocap.site)
> Both carry the OLD schema (a `powers` STRING, no directoryId), share one contentRoot, and dead-end.
>
> WHY INERT: the deployed vhost validator (vhost-table.js validateVhostRecord) hard-rejects ANY record with a `powers` key — `"powers" in raw → return undefined`. The mere presence of that field is a poison pill → the record resolves to 404. No serve path reads `record.powers`; the old top-host string resolver is gone. Live-probed both at loopback AND public edge: /=404, bootstrap=404. Defense-in-depth: `counter`→plain Counter exo, `@none`→null; neither is @agent/EndoHost.
>
> POSTURE: both WITHIN the authorized 08-27 open-plane posture of [kriscendobot/garden#58](https://github.com/kriscendobot/garden/issues/58) (containment drop-in disabled Aug 27 23:36). Containment intact; the 3 de-registered records stay absent.
>
> RECOMMENDATION: catalogue BOTH as EXPECTED / known-inert legacy dckc experiments. No de-registration needed for containment (the validator already neutralizes them) — did NOT touch anything. They corroborate the 2026-09-04 security review's open operator item on the untracked containment drop-in ("back-only-attenuated, lower risk").
>
> DECIDING QUESTION (optional, cosmetic only): do you want a hygiene sweep to move stale legacy `powers`-string records into a `vhosts-legacy-*` dir? Not a security need — purely store tidiness. Say the word and I'll post a job.

- `msg-verify-foreman-partial-unquiesce-target-2-bd5941f97768` — from gardener:verify-foreman-partial-unquiesce-target-2, reply_to `verify-foreman-partial-unquiesce-target-2` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-verify-foreman-partial-unquiesce-target-2-bd5941f97768.md)

> Resolved locally through a read-only host-filesystem inspection. No reply or action is needed; please archive my earlier verification request.

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.

- `20260901T175244Z-931faa` — from gardener:minion-town-remove-mcp-tool-prefixes, reply_to `minion-town-remove-mcp-tool-prefixes` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260901T175244Z-931faa.md)

> [kriscendobot/minion.town#75](https://github.com/kriscendobot/minion.town/issues/75) is merged and deployment run 33539977066 succeeded. The remaining required blind live discovery evaluation needs an authenticated minion.town MCP session. This worker container has no AWS CLI/credentials or minion.town OAuth connection, so it cannot read the sanctioned minion/test-cc-client secret or attach the live MCP to a context-free agent. Please either run a connected blind agent with only the directive "evaluate 2 + 2" and send the transcript/result, or make a short-lived sanctioned Bearer token available through this job inbox (do not paste a long-lived client secret).

- `msg-reconcile-gardener-alias-retirement-gate-20260916-70e30735a192` — from gardener:reconcile-gardener-alias-retirement-gate-20260916, reply_to `reconcile-gardener-alias-retirement-gate-20260916` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-reconcile-gardener-alias-retirement-gate-20260916-70e30735a192.md)

> Reconcile of the retirement-gate-1 failure for `retire-gardener-worker-kind-alias`.
> I re-gathered evidence on this host (endolin-garden-ece02cb4, the current LEADER)
> and checked the shared journal fleet-wide. NET: retirement is still correctly
> blocked — but the real blocker is a THIRD host the original plan never accounted
> for. I changed no code, journal state, or units, and did NOT requeue the cleanup.
> Requeuing now would just re-fail gate 1 (it already exhausted its 5 requeue cycles).
>
> Re-verified findings on THIS host (endolin-garden-ece02cb4):
> - `.garden-state/gardeners/` holds 100 legacy `*.garden` identity markers + a
>   `backend/{state,status}` probe-cache. Newest marker `1.garden` is
>   2026-08-31T02:10:35Z (= container recreate; content is the current host name).
>   (garden2 had 101 — different host, so a slightly different count is expected.)
> - Legacy `garden-gardener@1.service`: loaded, INACTIVE, dead (only @1 is present
>   here, not @1..4).
> - Monk count: the host declares `monks: 3` and `garden-monk@1..3` are enabled +
>   active. NO mismatch on this host. The "declares 4 / only 1..3 active" finding
>   was garden2-specific and is now stale (the leveler has since moved garden2 to
>   `monks: 2`).
>
> Are the markers dead / read by anything? Partly:
> - `<id>.garden` is a per-worker IDENTITY marker written by gardener.sh at every
>   spawn to `$GARDEN_STATE/<state_ns>/<id>.garden`, read by the scaler's
>   identity-drift guard. For the `monk` kind state_ns=monks, so live monks write
>   `.garden-state/monks/*.garden` (confirmed fresh today). The `gardeners/*.garden`
>   markers belong to the `gardener` kind (state_ns=gardeners).
> - On endolin-garden hosts no `gardener`-kind worker runs, so those markers are
>   dead residue LOCALLY. BUT they are NOT globally dead — see the blocker below.
> - I therefore did NOT delete them. On a monk host they are harmless, and marker
>   removal is the retirement cleanup's own gated responsibility (it plans to remove
>   them on both endolin hosts as host-side cleanup), not a side effect of a reconcile.
>
> Monk count reconciliation: nothing to reconcile here (3 == 3), and the declared
> count is BUDGET-LEVELER-OWNED (live pool anthropic:endolin-garden-ece02cb4 spend
> 43.8M / cap 143M). I left it untouched, per your directive not to fight the leveler.
>
> THE ACTUAL BLOCKER (new, not in the original plan): a third fleet host,
> `oros-studio-garden-ce242c49` (live follower, active as of 2026-09-15), still
> declares ONLY `gardeners: 2` with NO `monks:` key — it was never migrated to monk.
> So the legacy `gardener` worker kind is STILL IN ACTIVE FLEET USE, which means:
> - Gate 1 ("all fleet inventory reports zero legacy units and state markers")
>   genuinely fails — oros writes/reads `gardeners/*.garden` live.
> - Gate 3 ("all hosts have deployed the canonical release") is also in doubt: oros
>   is currently FAILING to deploy latest main2 (deploy test-gate rejection
>   2026-09-15, policy-refusal-quarantine-test rc=1).
> Retiring the alias now would break oros-studio outright. The plan job's premise
> ("both fleet hosts have cut over") predates oros and is no longer true.
>
> This is your call, so I stopped rather than guess:
>   (a) migrate oros-studio to monk first (`migrate-host-to-monk.sh cutover` ON that
>       host, followers-first per the design) and fix its deploy gate, THEN promote
>       the retirement cleanup; or
>   (b) decide oros stays gardener and the alias is NOT retired for now.
> I left `jobs/plan/retire-gardener-worker-kind-alias` parked (HELD) and did not
> promote/requeue it. Also the original prior-pass message
> `inbox/maintainer/unread/20260901T205650Z-59a6f5` can be marked read — its two
> asks (marker disposition + monk-count) are resolved above; the live blocker is oros.

- `credit-controls-20260916-child-credit-controls-stale-pr-viability-gate-failed` — from orchestrator:credit-controls-20260916-child-credit-controls-stale-pr-viability-gate-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/credit-controls-20260916-child-credit-controls-stale-pr-viability-gate-failed.md)

> orchestration-event: orchestration-child-timeout
> orchestration: credit-controls-20260916
> orchestration-status: running
> child: credit-controls-stale-pr-viability-gate
> failure-kind: handler-timeout
> order: serial
> on-child-failure: halt
> detail: stalled in flight for 2505s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1)
>
> Orchestration credit-controls-20260916 observed child credit-controls-stale-pr-viability-gate: stalled in flight for 2505s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1).


## Spend & quota
_Since Friday 20:00 Pacific reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 61.9M | $462.45 _(notional, rate-card)_ | 43% of 143.0M (ok) |
| Codex | 8.2M _(+207.7M cached)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 29% _(plan; codex-reported)_ |

## Board
### todo (0)
(none)

### doin (2)
- [`minion-town-guest-peer-fetch-verify`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/minion-town-guest-peer-fetch-verify.md) — Verify peer enlivenSturdyRef fetch of a minion.town guest by formula id
- [`garden-gauntlet-reexport-policy-check`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/garden-gauntlet-reexport-policy-check.md) — propose a gauntlet check that prevents plain re-export policy violations

### tada (8002)
- [`claude-on-minion-town-press-20260916-130520`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/claude-on-minion-town-press-20260916-130520.md) — Press report — arc issue #89 (Claude on minion.town)
- [`endojs-endo-but-for-bots-pass-style-src-naming`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pass-style-src-naming.md) — Cost
- [`endojs-endo-but-for-bots-248-build-ses-import-attributes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-248-build-ses-import-attributes.md) — Completion report: Build SES import attributes (design #248)
- [`endojs-endo-but-for-bots-migrate-agents-to-agentry-scuttle-lal`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-migrate-agents-to-agentry-scuttle-lal.md) — Cost
- [`endo-marshal-passables-equal-ava-operator`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/endo-marshal-passables-equal-ava-operator.md) — Cost
- … and 7997 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`ironhorse-fuzz-bd4559ecbc0432c1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bd4559ecbc0432c1-repair.md) — _normal_ · Repair Ironhorse engine defect bd4559ecbc0432c1 (target differential_source) ...
- [`ironhorse-fuzz-baad1f22ef053213-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-baad1f22ef053213-repair.md) — _normal_ · Repair Ironhorse engine defect baad1f22ef053213 (target differential_regexp_s...
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`ironhorse-fuzz-fcbb16f5721e8fd2-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-fcbb16f5721e8fd2-repair.md) — _normal_ · Fix Ironhorse fuzz finding fcbb16f5721e8fd2 (target differential_source) and ...
- [`ironhorse-fuzz-89e303d17e33b117-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-89e303d17e33b117-repair.md) — _normal_ · Repair Ironhorse engine defect 89e303d17e33b117 (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr431-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr431-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #431
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`ironhorse-fuzz-8b8afc47fcfb223d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8b8afc47fcfb223d-repair.md) — _normal_ · Repair Ironhorse engine defect 8b8afc47fcfb223d (target differential_regexp) ...
- [`endojs-endo-but-for-bots-pr663-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr663-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #663
- [`endojs-endo-but-for-bots-pr356-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr356-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #356
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`ironhorse-fuzz-50834e82d3af453d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-50834e82d3af453d-repair.md) — _normal_ · Repair Ironhorse engine defect 50834e82d3af453d (target differential_regexp_s...
- [`make-panel-stage-survive-supervisor-session-exit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/make-panel-stage-survive-supervisor-session-exit.md) — _normal_ · Make panel execution survive supervising agent-session exit
- [`ironhorse-fuzz-27824c75429b8581-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-27824c75429b8581-repair.md) — _normal_ · Repair Ironhorse engine defect 27824c75429b8581 (target differential_source) ...
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`endojs-endo-but-for-bots-pr550-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr550-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #550
- [`endojs-endo-but-for-bots-pr945-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr945-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #945
- [`endojs-endo-but-for-bots-pr241-gauntlet-fix-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr241-gauntlet-fix-6.md) — _normal_ · Gauntlet stage: FIX round 6 — endojs/endo-but-for-bots PR #241
- [`ironhorse-fuzz-12aca768c2e73c73-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-12aca768c2e73c73-repair.md) — _normal_ · Fix Ironhorse fuzz finding 12aca768c2e73c73 (target differential_regexp) and ...
- [`ironhorse-fuzz-c781c9b9de456ab2-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c781c9b9de456ab2-repair.md) — _normal_ · Repair Ironhorse engine defect c781c9b9de456ab2 (target differential_regexp_s...
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
- [`ironhorse-fuzz-bc9529ac5818aa24-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bc9529ac5818aa24-repair.md) — _normal_ · Repair Ironhorse engine defect bc9529ac5818aa24 (target differential_regexp_s...
- [`ironhorse-fuzz-9001b34fa6dd2d80-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-9001b34fa6dd2d80-repair.md) — _normal_ · Repair Ironhorse engine defect 9001b34fa6dd2d80 (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr551-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr551-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #551
- [`build-e-untag-handled-promise-pipelining`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-e-untag-handled-promise-pipelining.md) — _normal_ · What already exists (do not re-derive; verify against current master
- [`open-signup-gate-flip-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`xs2rust-endor-press-20260902-090504`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-090504.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endojs-endo-but-for-bots-pr539-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr539-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #539
- [`endojs-endo-but-for-bots-pr359-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr359-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #359
- [`ironhorse-fuzz-3a6aab9d9d140c2c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-3a6aab9d9d140c2c-repair.md) — _normal_ · Repair Ironhorse engine defect 3a6aab9d9d140c2c (target differential_regexp_s...
- [`ironhorse-fuzz-c6c71d428a37088c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c6c71d428a37088c-repair.md) — _normal_ · Repair Ironhorse engine defect c6c71d428a37088c (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr1089-32c7e8f1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1089-32c7e8f1.md) — _normal_ · attention directive on endojs/endo-but-for-bots PR #1089
- [`ironhorse-fuzz-51c6a212946102f6-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-51c6a212946102f6-repair.md) — _normal_ · Repair Ironhorse engine defect 51c6a212946102f6 (target differential_regexp) ...
- [`ironhorse-fuzz-13b68e2edb67861a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-13b68e2edb67861a-repair.md) — _normal_ · Repair Ironhorse engine defect 13b68e2edb67861a (target differential_regexp) ...
- [`ironhorse-fuzz-e2a75557f762cd9c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e2a75557f762cd9c-repair.md) — _normal_ · Repair Ironhorse engine defect e2a75557f762cd9c (target differential_regexp) ...
- [`endo-claude-agent-sdk-probe`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-claude-agent-sdk-probe.md) — _normal_ · Probe: measure the Agent SDK's confinement claims against a live run
- [`ironhorse-fuzz-f83dc8932cd3b41a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-f83dc8932cd3b41a-repair.md) — _normal_ · Repair Ironhorse engine defect f83dc8932cd3b41a (target differential_regexp) ...
- [`endojs-endo-but-for-bots-pr264-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr264-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #264
- [`gauntlet-endo-pr1113-20260904c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/gauntlet-endo-pr1113-20260904c.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1085-gauntlet-20260901-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1085-gauntlet-20260901-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1085
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr879-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr879-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #879
- [`endojs-endo-but-for-bots-pr897-weave-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr897-weave-20260901.md) — _normal_ · Weave (rebase onto live llm) endojs/endo-but-for-bots PR #897
- [`endojs-endo-but-for-bots-pr664-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr664-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #664
- [`endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source.md) — _normal_ · Build: SES import attributes — Phase 2 (module-source static with capture)
- [`xs2rust-endor-press-20260902-110504`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-110504.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`dependabotany-recheck-endo-but-for-bots-pr1268`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/dependabotany-recheck-endo-but-for-bots-pr1268.md) — _normal_ · botanist recheck: endojs/endo-but-for-bots PR #1268 (re-conduct after rebase)
- [`ironhorse-fuzz-1cd4ddc72d5801c4-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1cd4ddc72d5801c4-repair.md) — _normal_ · Repair Ironhorse engine defect 1cd4ddc72d5801c4 (target differential_regexp_s...
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`ironhorse-fuzz-f2f53bb078bc8a4e-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-f2f53bb078bc8a4e-repair.md) — _normal_ · Fix Ironhorse fuzz finding f2f53bb078bc8a4e (target differential_regexp) and ...
- [`endojs-endo-but-for-bots-pr266-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr266-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #266
- [`ironhorse-fuzz-cfdc1a28296f23a1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-cfdc1a28296f23a1-repair.md) — _normal_ · Repair Ironhorse engine defect cfdc1a28296f23a1 (target differential_regexp) ...
- [`endojs-endo-but-for-bots-pr360-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr360-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #360
- [`endojs-endo-but-for-bots-pr990-refresh`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr990-refresh.md) — _normal_ · refresh directive on endojs/endo-but-for-bots PR #990
- [`xs2rust-endor-press-20260902-130505`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-130505.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`retire-gardener-worker-kind-alias`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/retire-gardener-worker-kind-alias.md) — _normal_ · ---
- [`xs2rust-endor-press-20260902-162005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-162005.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-1a2012ae1ec44d21-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1a2012ae1ec44d21-repair.md) — _normal_ · Fix Ironhorse fuzz finding 1a2012ae1ec44d21 (target differential_regexp_surfa...
- [`ironhorse-fuzz-6ba52f2bdc534545-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6ba52f2bdc534545-repair.md) — _normal_ · Repair Ironhorse engine defect 6ba52f2bdc534545 (target differential_regexp_s...
- [`xs2rust-endor-press-20260902-215005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-215005.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`xs2rust-endor-press-20260902-120504`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-120504.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`kriscendobot-minion.town-pr79-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr79-conduct.md) — _normal_ · Finalize (curate -> merge) kriscendobot/minion.town PR #79
- [`weave-base-update-and-pin-alias`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-base-update-and-pin-alias.md) — _normal_ · ---
- [`ironhorse-fuzz-ccb76a40851925f9-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ccb76a40851925f9-repair.md) — _normal_ · Repair Ironhorse engine defect ccb76a40851925f9 (target differential_regexp) ...
- [`ironhorse-iterator-intrinsic-metadata`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-iterator-intrinsic-metadata.md) — _normal_ · fix Ironhorse %IteratorPrototype% / %AsyncIteratorPrototype% intrinsic metadata
- [`ironhorse-fuzz-d5413146a257bc30-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-d5413146a257bc30-repair.md) — _normal_ · Repair Ironhorse engine defect d5413146a257bc30 (target differential_regexp_s...
- [`kriscendobot-minion.town-pr68-retcon`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr68-retcon.md) — _normal_ · retcon directive on kriscendobot/minion.town PR #68
- [`endojs-endo-but-for-bots-pr675-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr675-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #675
- [`ironhorse-fuzz-ad5b483fc5e0973f-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ad5b483fc5e0973f-repair.md) — _normal_ · Repair Ironhorse engine defect ad5b483fc5e0973f (target differential_regexp_s...
- [`ironhorse-fuzz-79f0475dd0440b2d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-79f0475dd0440b2d-repair.md) — _normal_ · Repair Ironhorse engine defect 79f0475dd0440b2d (target differential_regexp) ...
- [`ironhorse-fuzz-b95320dfb5dd9d3d-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-b95320dfb5dd9d3d-repair.md) — _normal_ · Repair Ironhorse engine defect b95320dfb5dd9d3d (target differential_regexp_s...
- [`ironhorse-fuzz-7072dc2d72d9e2fd-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-7072dc2d72d9e2fd-repair.md) — _normal_ · Repair Ironhorse engine defect 7072dc2d72d9e2fd (target differential_regexp) ...
- [`ironhorse-fuzz-ecae051e6e8f5a27-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ecae051e6e8f5a27-repair.md) — _normal_ · Repair Ironhorse engine defect ecae051e6e8f5a27 (target differential_source) ...
- [`ebfb-llm-xs-daemon-bundle-reconcile`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-xs-daemon-bundle-reconcile.md) — _normal_ · ---
- [`build-readableblob-range-attenuation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-readableblob-range-attenuation.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`weave-ebfb-1100-pin-merge-base-20260916`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-ebfb-1100-pin-merge-base-20260916.md) — _normal_ · ---
- [`xs2rust-endor-press-20260902-183505`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-183505.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-67ca18e4febe7a34-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-67ca18e4febe7a34-repair.md) — _normal_ · Repair Ironhorse engine defect 67ca18e4febe7a34 (target differential_source) ...
- [`ironhorse-fuzz-2cc2ac67ba7e9b9f-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-2cc2ac67ba7e9b9f-repair.md) — _normal_ · Repair Ironhorse engine defect 2cc2ac67ba7e9b9f (target differential_regexp_s...
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr762-gauntlet-20260902`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr762-gauntlet-20260902.md) — _normal_ · Complete the gauntlet for endojs/endo-but-for-bots#762
- [`ironhorse-fuzz-d87697d49a5f8f67-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-d87697d49a5f8f67-repair.md) — _normal_ · Repair Ironhorse engine defect d87697d49a5f8f67 (target differential_source) ...
- [`endojs-endo-but-for-bots-pr463-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr463-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #463
- [`ironhorse-fuzz-e0fe14e41d5074a6-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e0fe14e41d5074a6-repair.md) — _normal_ · Repair Ironhorse engine defect e0fe14e41d5074a6 (target differential_source) ...
- [`ironhorse-fuzz-ab41c5d203ace017-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ab41c5d203ace017-repair.md) — _normal_ · Repair Ironhorse engine defect ab41c5d203ace017 (target differential_regexp) ...
- [`xs2rust-endor-press-20260902-173504`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-173504.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endojs-endo-but-for-bots-pr432-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr432-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #432
- [`garden-build-follower-self-deploy`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-build-follower-self-deploy.md) — _normal_ · Implement — the design's recommended path
- [`kriscendobot-minion.town-pr56-review-7d4dc95d`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr56-review-7d4dc95d.md) — _normal_ · Review directive on kriscendobot/minion.town PR #56
- [`endojs-endo-but-for-bots-pr736-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr736-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #736
- [`endojs-endo-but-for-bots-pr871-weave-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr871-weave-20260901.md) — _normal_ · Weave endojs/endo-but-for-bots#871 — the sturdyref agent-surface build
- [`amend-invitation-oauth-mcp-prerequisite`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/amend-invitation-oauth-mcp-prerequisite.md) — _normal_ · What's actually true today versus what's designed for later — verify,
- [`ironhorse-fuzz-bc3d0df623811a38-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bc3d0df623811a38-repair.md) — _normal_ · Fix Ironhorse fuzz finding bc3d0df623811a38 (target differential_regexp_surfa...
- [`ironhorse-fuzz-fad9672dc7a6e6be-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-fad9672dc7a6e6be-repair.md) — _normal_ · Repair Ironhorse engine defect fad9672dc7a6e6be (target differential_source) ...
- [`ironhorse-fuzz-197b32cc30bdd4fe-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-197b32cc30bdd4fe-repair.md) — _normal_ · Repair Ironhorse engine defect 197b32cc30bdd4fe (target differential_regexp_s...
- [`endo-sturdyref-enliven-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-enliven-design.md) — _normal_ · ---
- [`xs2rust-endor-press-20260902-100504`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-100504.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endo-pr3360-mirror`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-pr3360-mirror.md) — _normal_ · What "mirror" means here
- [`endojs-endo-but-for-bots-pr909-fix-ts-make-daemon`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-fix-ts-make-daemon.md) — _normal_ · Fix: endo make / endo archive TypeScript support is broken (endojs/endo-but-f...
- [`ironhorse-fuzz-c99f800f6a36e8a6-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c99f800f6a36e8a6-repair.md) — _normal_ · Repair Ironhorse engine defect c99f800f6a36e8a6 (target differential_regexp) ...
- [`ironhorse-fuzz-9894aac5ad23c6eb-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-9894aac5ad23c6eb-repair.md) — _normal_ · Repair Ironhorse engine defect 9894aac5ad23c6eb (target differential_regexp) ...
- [`run-the-gauntlet-minion-town-pr90`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/run-the-gauntlet-minion-town-pr90.md) — _normal_ · ---
- [`ironhorse-fuzz-af5b4a677483eac3-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-af5b4a677483eac3-repair.md) — _normal_ · Fix Ironhorse fuzz finding af5b4a677483eac3 (target differential_regexp_surfa...
- [`ironhorse-fuzz-5eeb0aadb2004075-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-5eeb0aadb2004075-repair.md) — _normal_ · Fix Ironhorse fuzz finding 5eeb0aadb2004075 (target differential_regexp) and ...
- [`ironhorse-fuzz-ac8a8e3d9d3d7f96-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ac8a8e3d9d3d7f96-repair.md) — _normal_ · Repair Ironhorse engine defect ac8a8e3d9d3d7f96 (target differential_regexp) ...
- [`ironhorse-fuzz-378372c8706a48a8-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-378372c8706a48a8-repair.md) — _normal_ · Fix Ironhorse fuzz finding 378372c8706a48a8 (target differential_regexp_surfa...
- [`minion-town-endo-b3-daemon-deploy-verify`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-endo-b3-daemon-deploy-verify.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-issue982-build-special-names`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-issue982-build-special-names.md) — _normal_ · ---
- [`kriscendobot-minion.town-pr68-review-45cc89f1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr68-review-45cc89f1.md) — _normal_ · Review directive on kriscendobot/minion.town PR #68
- [`endojs-endo-but-for-bots-pr1018-review-eccc706c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1018-review-eccc706c.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #1018
- [`xs2rust-endor-press-20260902-152005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-152005.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-05264cccae42245a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-05264cccae42245a-repair.md) — _normal_ · Repair Ironhorse engine defect 05264cccae42245a (target differential_source) ...
- [`ironhorse-fuzz-5c9d2506e6048f4a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-5c9d2506e6048f4a-repair.md) — _normal_ · Repair Ironhorse engine defect 5c9d2506e6048f4a (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr897-shepherd-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr897-shepherd-20260901.md) — _normal_ · ---
- [`ironhorse-fuzz-daf6694aec7856aa-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-daf6694aec7856aa-repair.md) — _normal_ · Repair Ironhorse engine defect daf6694aec7856aa (target differential_source) ...
- [`ironhorse-fuzz-a172d6aba922c9ad-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-a172d6aba922c9ad-repair.md) — _normal_ · Repair Ironhorse engine defect a172d6aba922c9ad (target differential_regexp) ...
- [`xs2rust-endor-press-20260902-065004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-065004.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-7637ac162a0b916a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-7637ac162a0b916a-repair.md) — _normal_ · Repair Ironhorse engine defect 7637ac162a0b916a (target differential_regexp) ...
- [`ironhorse-fuzz-931a687135cabb0c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-931a687135cabb0c-repair.md) — _normal_ · Repair Ironhorse engine defect 931a687135cabb0c (target differential_source) ...
- [`ironhorse-fuzz-9edaa2277fb90f03-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-9edaa2277fb90f03-repair.md) — _normal_ · Repair Ironhorse engine defect 9edaa2277fb90f03 (target differential_source) ...
- [`build-usage-scrape-ingest`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-usage-scrape-ingest.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr709-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr709-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #709
- [`endojs-endo-but-for-bots-pr887-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr887-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #887
- [`endojs-endo-but-for-bots-pr1097-fix-review`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1097-fix-review.md) — _normal_ · Fix PR #1097 per @kriskowal review (CHANGES_REQUESTED)
- [`ironhorse-fuzz-1dc231089278c110-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1dc231089278c110-repair.md) — _normal_ · Repair Ironhorse engine defect 1dc231089278c110 (target differential_regexp) ...
- [`ironhorse-fuzz-822848c732a1b805-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-822848c732a1b805-repair.md) — _normal_ · Repair Ironhorse engine defect 822848c732a1b805 (target differential_regexp) ...
- [`drive-mystic-rollout-20260723`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/drive-mystic-rollout-20260723.md) — _low_ · ---
- [`ironhorse-fuzz-e4a8e011666d0362-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e4a8e011666d0362-repair.md) — _normal_ · Repair Ironhorse engine defect e4a8e011666d0362 (target differential_regexp_s...
- [`kimi-k3-canary-20260723-c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kimi-k3-canary-20260723-c.md) — _low_ · ---
- [`endojs-endo-but-for-bots-pr697-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr697-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #697
- [`endojs-endo-but-for-bots-pr631-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr631-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #631
- [`endojs-endo-but-for-bots-pr711-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr711-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #711
- [`ironhorse-fuzz-fd8517d5f3071227-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-fd8517d5f3071227-repair.md) — _normal_ · Repair Ironhorse engine defect fd8517d5f3071227 (target differential_regexp) ...
- [`ironhorse-fuzz-557805e944888b5a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-557805e944888b5a-repair.md) — _normal_ · Repair Ironhorse engine defect 557805e944888b5a (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr511-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr511-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #511
- [`ironhorse-fuzz-284de587e16bce32-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-284de587e16bce32-repair.md) — _normal_ · Repair Ironhorse engine defect 284de587e16bce32 (target differential_source) ...
- [`ironhorse-fuzz-repromote-quarantined`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-repromote-quarantined.md) — _normal_ · Re-promote the quarantined ironhorse fuzz-repair jobs
- [`endojs-endo-but-for-bots-pr529-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr529-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #529
- [`ironhorse-ocap-workload-optimization`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-ocap-workload-optimization.md) — _normal_ · The thesis
- [`ironhorse-fuzz-5e7a173f899ae7a1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-5e7a173f899ae7a1-repair.md) — _normal_ · Fix Ironhorse fuzz finding 5e7a173f899ae7a1 (target differential_regexp) and ...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`kriscendobot-minion-town-pr68-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr68-gauntlet-panel-6.md) — _normal_ · Gauntlet stage: PANEL round 6 — kriscendobot/minion.town PR #68
- [`endojs-endo-but-for-bots-pr648-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr648-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #648
- [`ironhorse-fuzz-e773681b6d831dc1-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-e773681b6d831dc1-repair.md) — _normal_ · Repair Ironhorse engine defect e773681b6d831dc1 (target differential_regexp_s...
- [`build-kebab-case-lint-wildcard-test262-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-kebab-case-lint-wildcard-test262-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #762
- [`build-minion-town-claude-agents-capability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-claude-agents-capability.md) — _normal_ · ---
- [`ironhorse-fuzz-bf6cfbd74a7487fc-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-bf6cfbd74a7487fc-repair.md) — _normal_ · Repair Ironhorse engine defect bf6cfbd74a7487fc (target differential_regexp) ...
- [`daily-progress-summary-20260902-070506`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daily-progress-summary-20260902-070506.md) — _normal_ · Daily midnight Pacific progress summary
- [`endojs-endo-but-for-bots-pr450-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr450-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #450
- [`ironhorse-fuzz-4658b8adc7bdd428-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-4658b8adc7bdd428-repair.md) — _normal_ · Repair Ironhorse engine defect 4658b8adc7bdd428 (target differential_source) ...
- [`explore-ironhorse-promise-chain-shortening`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/explore-ironhorse-promise-chain-shortening.md) — _low_ · Explore: promise resolution chain shortening in Ironhorse
- [`ironhorse-fuzz-45f4af87eaf627c7-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-45f4af87eaf627c7-repair.md) — _normal_ · Fix Ironhorse fuzz finding 45f4af87eaf627c7 (target differential_regexp) and ...
- [`ironhorse-fuzz-37e026fd30cbae19-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-37e026fd30cbae19-repair.md) — _normal_ · Repair Ironhorse engine defect 37e026fd30cbae19 (target differential_source) ...
- [`ironhorse-fuzz-c9eaa7b5ae02437a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-c9eaa7b5ae02437a-repair.md) — _normal_ · Repair Ironhorse engine defect c9eaa7b5ae02437a (target differential_regexp_s...
- [`xs2rust-endor-press-20260902-142005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-142005.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-d38f12f4884e186c-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-d38f12f4884e186c-repair.md) — _normal_ · Repair Ironhorse engine defect d38f12f4884e186c (target differential_regexp_s...
- [`endojs-endo-but-for-bots-pr610-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr610-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #610
- [`xs2rust-endor-press-20260902-205005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-205005.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`endojs-endo-but-for-bots-pr249-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr249-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #249
- [`ironhorse-fuzz-29a24c1b1052ec91-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-29a24c1b1052ec91-repair.md) — _normal_ · Repair Ironhorse engine defect 29a24c1b1052ec91 (target differential_regexp) ...
- [`deploy-siwe-thunk-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-siwe-thunk-minion-town.md) — _normal_ · Deploy the SIWE OIDC thunk (mirroring the GitHub thunk's AWS path)
- [`ironhorse-fuzz-6ca7a76e0bfe3435-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6ca7a76e0bfe3435-repair.md) — _normal_ · Repair Ironhorse engine defect 6ca7a76e0bfe3435 (target differential_regexp_s...
- [`ironhorse-fuzz-aaa423e9c5d56067-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-aaa423e9c5d56067-repair.md) — _normal_ · Repair Ironhorse engine defect aaa423e9c5d56067 (target differential_source) ...
- [`explore-ironhorse-ptc`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/explore-ironhorse-ptc.md) — _low_ · Explore: Proper Tail Calls (PTC) in Ironhorse
- [`endojs-endo-but-for-bots-pr569-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr569-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #569
- [`endojs-endo-but-for-bots-pr797-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr797-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #797
- [`endojs-endo-but-for-bots-pr674-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr674-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #674
- [`proposal-compartments-xs-parser-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/proposal-compartments-xs-parser-design.md) — _normal_ · ---
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`ironhorse-fuzz-8ea950859db8a5f7-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8ea950859db8a5f7-repair.md) — _normal_ · Repair Ironhorse engine defect 8ea950859db8a5f7 (target differential_regexp) ...
- [`kriscendobot-vattr97-pr1-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-vattr97-pr1-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/vattr97 PR #1
- [`xs2rust-endor-press-20260902-193509`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-193509.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`build-minion-town-invitation-only-guest-onboarding-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-invitation-only-guest-onboarding-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — kriscendobot/minion.town PR #81
- [`kriscendobot-minion.town-pr78-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr78-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/minion.town PR #78
- [`ironhorse-fuzz-6be90176ff07c648-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-6be90176ff07c648-repair.md) — _normal_ · Repair Ironhorse engine defect 6be90176ff07c648 (target differential_regexp) ...
- [`kriscendobot-minion.town-pr80-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr80-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — kriscendobot/minion.town PR #80
- [`endojs-endo-but-for-bots-pr690-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr690-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #690
- [`endojs-endo-but-for-bots-pr508-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr508-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #508
- [`gauntlet-endo-pr1113-20260902`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/gauntlet-endo-pr1113-20260902.md) — _normal_ · ---
- [`ironhorse-fuzz-1cb63ec6f8e6fc22-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-1cb63ec6f8e6fc22-repair.md) — _normal_ · Repair Ironhorse engine defect 1cb63ec6f8e6fc22 (target differential_regexp_s...
- [`ironhorse-fuzz-3310b49d21f64878-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-3310b49d21f64878-repair.md) — _normal_ · Fix Ironhorse fuzz finding 3310b49d21f64878 (target differential_source) and ...
- [`xs2rust-endor-press-20260902-075006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/xs2rust-endor-press-20260902-075006.md) — _normal_ · Press Ironhorse (the Rust JS engine, formerly xs2rust-endor) forward
- [`ironhorse-fuzz-8adaa3bbc9cda1ce-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-8adaa3bbc9cda1ce-repair.md) — _normal_ · Repair Ironhorse engine defect 8adaa3bbc9cda1ce (target differential_source) ...
- [`ironhorse-fuzz-ed616f6ec22095dc-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-ed616f6ec22095dc-repair.md) — _normal_ · Repair Ironhorse engine defect ed616f6ec22095dc (target differential_regexp) ...
- [`endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper.md) — _normal_ · Build: SES import attributes — Phase 3 (compartment-mapper plumbing)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`endo-claude-agent-sdk-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-claude-agent-sdk-design.md) — _normal_ · Design: the Claude Agent SDK as an alternative confinement substrate for @end...
- [`ironhorse-fuzz-3fc02d8b57faa79a-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-3fc02d8b57faa79a-repair.md) — _normal_ · Repair Ironhorse engine defect 3fc02d8b57faa79a (target differential_source) ...
- [`endojs-endo-but-for-bots-pr933-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr933-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #933
- [`endo-claude-agent-sdk-backend`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-claude-agent-sdk-backend.md) — _normal_ · Build: a paid-tier Agent SDK backend behind @endo/claude's existing seams
- [`ironhorse-fuzz-2a2de75b75de4894-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-2a2de75b75de4894-repair.md) — _normal_ · Repair Ironhorse engine defect 2a2de75b75de4894 (target differential_source) ...
- [`endojs-endo-but-for-bots-pr938-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr938-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #938
- [`ironhorse-fuzz-a7755caa51aa9320-repair`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-a7755caa51aa9320-repair.md) — _normal_ · Repair Ironhorse engine defect a7755caa51aa9320 (target differential_source) ...
- [`build-claude-usage-dashboard-scraper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-claude-usage-dashboard-scraper.md) — _normal_ · ---

### deferred (top by priority; foreman auto-promotes when idle)
- [`review-improve-merge-base-pinning`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/review-improve-merge-base-pinning.md) — _normal_ · review-improve: merge-base-pinning (prevention + durable sensing)
- [`scholar-ingest-cap-talk`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/scholar-ingest-cap-talk.md) — _normal_ · Ingest the cap-talk mailing list into the library
- [`wire-siwe-onchain-authz-minion-town-followup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/wire-siwe-onchain-authz-minion-town-followup.md) — _normal_ · Finish wiring SIWE on-chain authz into minion.town's policy layer (maintainer...
- [`design-mutable-blob-formula`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-mutable-blob-formula.md) — _normal_ · Design: a mutable-blob daemon formula (readable-blob / blob / appendable-blob)
- [`ironhorse-computron-benchmark-baseline-build-exec`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-computron-benchmark-baseline-build-exec.md) — _normal_ · builder: implement the Ironhorse computron benchmark-baseline regime (steps 2–8)
- [`local-verify-zizmor-parity`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/local-verify-zizmor-parity.md) — _low_ · local-verify: cover the zizmor workflow audit (CI parity gap)
- [`endojs-endo-but-for-bots-pr388-review-3f255add-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr388-review-3f255add-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #388 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr888-review-8b40fdbe-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr888-review-8b40fdbe-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #888 (primary: endojs-endo-but-f...
- [`kriscendobot-minion.town-pr52-review-86b4c679-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr52-review-86b4c679-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #52 (primary: kriscendobot-minio...
- [`endojs-endo-but-for-bots-pr388-review-37754f3b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr388-review-37754f3b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #388 (primary: endojs-endo-but-f...
- [`kriscendobot-minion.town-pr53-review-90b51c86-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr53-review-90b51c86-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #53 (primary: kriscendobot-minio...
- [`endojs-endo-but-for-bots-pr1072-review-73226ec0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1072-review-73226ec0-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1072 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1072-review-bb54af10-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1072-review-bb54af10-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1072 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-a5d1fff6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-a5d1fff6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr819-review-f8bab00f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr819-review-f8bab00f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #819 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr832-review-7bada805-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr832-review-7bada805-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #832 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr858-review-e6eaf772-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr858-review-e6eaf772-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #858 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1018-review-cf8012a8-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1018-review-cf8012a8-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1018 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1015-2b55429b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1015-2b55429b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1015 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1015-review-348a2017-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1015-review-348a2017-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1015 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr832-review-f3554a0a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr832-review-f3554a0a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #832 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1085-b27f483f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1085-b27f483f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1085 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr832-e39ce097-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr832-e39ce097-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #832 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr858-review-8add9193-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr858-review-8add9193-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #858 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1072-review-c8a0f42b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1072-review-c8a0f42b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1072 (primary: endojs-endo-but-...
- [`kriscendobot-minion.town-pr66-review-21dce903-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr66-review-21dce903-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #66 (primary: kriscendobot-minio...
- [`endojs-endo-but-for-bots-pr1015-review-6a83ee90-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1015-review-6a83ee90-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1015 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1018-review-eccc706c-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1018-review-eccc706c-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1018 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-1e30a92e-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-1e30a92e-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-43d08bdd-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-43d08bdd-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-6cbbd9d4-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-6cbbd9d4-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-ac4e65b2-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-ac4e65b2-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-b9fa19b7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-b9fa19b7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-beaff99f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-beaff99f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-c4d75838-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-c4d75838-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1059-fd3c3617-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1059-fd3c3617-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1059 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1072-review-070ee47a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1072-review-070ee47a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1072 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1072-review-e10c72d0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1072-review-e10c72d0-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1072 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1080-review-09542d7d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1080-review-09542d7d-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1080 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1097-review-8f8bb13f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1097-review-8f8bb13f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1097 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1099-e2aa4377-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1099-e2aa4377-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1099 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1099-review-6694e2d7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1099-review-6694e2d7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1099 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1102-review-61dcfee0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1102-review-61dcfee0-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1102 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1105-68436fbc-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1105-68436fbc-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1105 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1107-ca3f4ec6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1107-ca3f4ec6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1107 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1115-8bddd4d7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1115-8bddd4d7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1115 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr264-review-1da7ebe7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr264-review-1da7ebe7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #264 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr897-review-8efe291e-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr897-review-8efe291e-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #897 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr935-review-a285ce89-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr935-review-a285ce89-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #935 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr982-0b4f9f5d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr982-0b4f9f5d-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #982 (primary: endojs-endo-but-f...
- [`kriscendobot-garden-pr72-review-9328ebe3-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr72-review-9328ebe3-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #72 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-garden-pr72-review-e5ce867a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr72-review-e5ce867a-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #72 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-garden-pr73-review-6e23fb68-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr73-review-6e23fb68-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #73 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-garden-pr75-review-c4c627a3-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr75-review-c4c627a3-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #75 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-garden-pr77-review-13d229b9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr77-review-13d229b9-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #77 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-minion.town-pr17-review-72d9bc6d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr17-review-72d9bc6d-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #17 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr17-review-a27f619f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr17-review-a27f619f-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #17 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr41-dadbe275-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr41-dadbe275-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #41 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr56-ebea2826-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr56-ebea2826-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #56 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr56-review-5867a29b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr56-review-5867a29b-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #56 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr56-review-6f509bbb-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr56-review-6f509bbb-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #56 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr56-review-7d4dc95d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr56-review-7d4dc95d-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #56 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr56-review-7fde9428-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr56-review-7fde9428-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #56 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr62-review-353e723b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr62-review-353e723b-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #62 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr63-376756ac-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr63-376756ac-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #63 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr63-c48b67b6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr63-c48b67b6-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #63 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr64-review-54703139-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr64-review-54703139-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #64 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr67-review-19714c10-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr67-review-19714c10-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #67 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr68-review-45cc89f1-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr68-review-45cc89f1-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #68 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr73-34dcca36-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr73-34dcca36-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #73 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr76-review-1635fe3d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr76-review-1635fe3d-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #76 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr77-review-6b8f8a0e-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr77-review-6b8f8a0e-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #77 (primary: kriscendobot-minio...
- [`endojs-endo-but-for-bots-pr264-2f0d1c07-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr264-2f0d1c07-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #264 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1128-7ed93d90-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1128-7ed93d90-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1128 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1018-review-e296b2fe-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1018-review-e296b2fe-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1018 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1083-72bea159-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1083-72bea159-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1083 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1085-review-d35f5e0c-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1085-review-d35f5e0c-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1085 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr855-review-5ac73b99-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr855-review-5ac73b99-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #855 (primary: endojs-endo-but-f...
- [`kriscendobot-garden-pr73-review-af4b21fd-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr73-review-af4b21fd-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #73 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-minion.town-pr85-review-ca62c58f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr85-review-ca62c58f-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #85 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr89-review-5bb156f5-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr89-review-5bb156f5-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #89 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr88-b4391fbf-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr88-b4391fbf-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #88 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr32-review-93782d28-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr32-review-93782d28-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #32 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr45-review-70f2f356-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr45-review-70f2f356-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #45 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr59-review-0aebcb48-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr59-review-0aebcb48-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #59 (primary: kriscendobot-minio...
- [`endojs-endo-but-for-bots-pr1085-review-518814b7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1085-review-518814b7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1085 (primary: endojs-endo-but-...
- [`kriscendobot-minion.town-pr69-review-6989f40d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr69-review-6989f40d-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #69 (primary: kriscendobot-minio...
- [`kriscendobot-garden-pr75-20d9585e-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr75-20d9585e-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #75 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-garden-pr80-review-4ffdbc4c-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr80-review-4ffdbc4c-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #80 (primary: kriscendobot-garden-pr8...
- [`kriscendobot-garden-pr81-review-1ef600fe-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr81-review-1ef600fe-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #81 (primary: kriscendobot-garden-pr8...
- [`kriscendobot-garden-pr83-review-f6162506-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr83-review-f6162506-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #83 (primary: kriscendobot-garden-pr8...
- [`kriscendobot-garden-pr84-review-89b0eda7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr84-review-89b0eda7-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #84 (primary: kriscendobot-garden-pr8...
- [`kriscendobot-minion.town-pr69-review-f7e1d07a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr69-review-f7e1d07a-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #69 (primary: kriscendobot-minio...
- [`kriscendobot-garden-pr80-review-5b40d6f6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr80-review-5b40d6f6-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #80 (primary: kriscendobot-garden-pr8...
- [`endojs-endo-but-for-bots-pr990-review-8896f456-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr990-review-8896f456-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #990 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1085-review-2e93eed1-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1085-review-2e93eed1-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1085 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr858-review-86d198da-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr858-review-86d198da-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #858 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1125-review-b4f3aac8-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-b4f3aac8-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1257-5de2de57-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1257-5de2de57-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1257 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1262-233a2e81-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1262-233a2e81-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1262 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-review-4e1469ed-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-4e1469ed-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-aff3b059-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-aff3b059-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-review-35c43da7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-35c43da7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr945-review-e4e7a891-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr945-review-e4e7a891-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #945 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr877-review-a8763cf9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr877-review-a8763cf9-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #877 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1125-review-da14cc53-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-da14cc53-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-review-b58d5a3f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-b58d5a3f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-3193517b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-3193517b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-review-a74698d6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-a74698d6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1282-d101dbfb-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1282-d101dbfb-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1282 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1281-review-b373c832-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1281-review-b373c832-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1281 (primary: endojs-endo-but-...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`endo-sturdyref-agent-surface-gauntlet-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-agent-surface-gauntlet-20260901.md) — awaiting `endojs-endo-but-for-bots-pr871-weave-20260901` · Run the gauntlet for endojs/endo-but-for-bots#871 (sturdyref agent surface)
- [`build-minion-town-invitation-onboarding`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-invitation-onboarding.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1125` · Build invitation-only guest onboarding for minion.town
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1019` · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`build-exo-sheets-service`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-sheets-service.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---

## Watch set
kriscendobot-minion.town kriscendobot-cosgov kriscendobot-ocapn kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot

## Hosts
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 3 gardeners
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 3 gardeners
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): 8 gardeners
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): 1 gardeners
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 2 gardeners
