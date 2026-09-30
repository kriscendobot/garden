# Garden bulletin

_As of 2026-09-30T21:28:24Z_

## Latest

The SturdyRef 8-layer stack (endojs/endo-but-for-bots#1391–1398) continues advancing through the gauntlet, but layer 2 (SES) halted after its fourth fix round was explicitly declined, and layer 1's shim-build fix round 1 is still in progress alongside layers 3–8 spread across panel and fix stages. The petname-path-only sweep ([endojs/endo-but-for-bots#1390](https://github.com/endojs/endo-but-for-bots/pull/1390)) is deep into its own fix/panel cycle. Separately, [endojs/endo-but-for-bots#1380](https://github.com/endojs/endo-but-for-bots/pull/1380)'s Ironhorse panic live-handle-reseat gauntlet hit its review budget after six panel/fix rounds without converging — CI is green, so it's left for a human merge call — and a macOS daemon-teardown flake is being chased as a likely cross-PR infrastructure issue rather than a PR defect. On the review-tracking side, [endojs/endo-but-for-bots#1357](https://github.com/endojs/endo-but-for-bots/pull/1357) has moved to a new head since its last panel pass, so its earlier review no longer covers the current commits and needs a fresh look before anything proceeds. Several housekeeping notices also came in: two journal-clone-size warnings (deferred remedy) and a contention storm across six clone paths, a stuck rolling-deploy canary on oros-studio that briefly went offline then recovered, and the weekly accountant budget conversation and reset-credit recommendations are open awaiting your input, alongside four other items already queued for a maintainer decision.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#1282](https://github.com/endojs/endo-but-for-bots/pull/1282) — chore(ironhorse): demolish the XS-computron-parity myth (waiting 3d)
- [endojs/endo-but-for-bots#1281](https://github.com/endojs/endo-but-for-bots/pull/1281) — fix(ses): silence lockdown intrinsics report for the WHATWG URL family (waiting 13d)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 18d)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 27d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 29d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 29d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 30d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 29d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 29d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 32d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Screened by proxy (minion.town)

(delegation not armed)

## Messages to the maintainer

- `watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-host-offline-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-09-30T20:47:15Z, cleared 2026-09-30T20:59:05Z).
> It was observed 4 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> heartbeat resumed for oros-studio-garden-ce242c49; it is PRESENT again and will automatically rejoin the canary rotation while its hosts/oros-studio-garden-ce242c49 record remains active. Archived records are not unarchived automatically.

- `msg-book-revise-content-a727eb9546d8` — from gardener:book-revise-content, reply_to `book-revise-content` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-book-revise-content-a727eb9546d8.md)

> Garden book revised and republished: https://dajt26qwtcxayo7bbm5sfokdhosqznrmwm7uahtuyxofbggo5nza.ocap.site/
>
> Title: "The Garden That Tends Code" (subtitle: An agent fleet through its metamorphoses: how it is organized, operated, and paid for, and how it remembers what it has learned).
> New: ch9 (the library: layout, scholar ingestion, library-lookup, researcher, and the context-economy argument) and ch10 (inference tiers reference: tiers, models, worker kinds, role floors, fallback).
> Prior edition kept in build/README.md: https://qxx6onyv2lkrchlytrmh2dos4xndfz5erojrkwfplor65h2ipgrq.ocap.site/

- `stale-panel-head-endojs-endo-but-for-bots-pr1357-50917af1-1ff1c08e` — from gardener:endojs-endo-but-for-bots-pr1357-review-a8630960, reply_to `endojs-endo-but-for-bots-pr1357-review-a8630960` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/stale-panel-head-endojs-endo-but-for-bots-pr1357-50917af1-1ff1c08e.md)

> Stale panel coverage for completed job `endojs-endo-but-for-bots-pr1357-review-a8630960`: [https://github.com/endojs/endo-but-for-bots/pull/1357](https://github.com/endojs/endo-but-for-bots/pull/1357) moved from panel-reviewed head `50917af1a439419d6ccc5b91ceb11acb0c5bff59` to presented head `1ff1c08e71ecec6717004bb2c7060c360163c1e8`.
>
> Disposition: **review required**. The earlier panel does not cover the current head; every commit delta is conservatively review-relevant. A PR metadata-only edit would leave the head unchanged and would not trigger this disposition.
>
> No gauntlet was staged. Route the current head through the existing panel stage only after an explicit maintainer `run the gauntlet` request, or make a maintainer review decision with the stale coverage stated explicitly.

- `msg-accountant-budget-conversation-20260930-4b156353d3b7` — from gardener:accountant-budget-conversation-20260930, reply_to `accountant-budget-conversation-20260930` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-accountant-budget-conversation-20260930-4b156353d3b7.md)

> **Accountant: opening budget conversation (week ending Sat 2026-10-03 03:00Z)**
>
> **Capacity (from your 09-30 checkpoints; ceiling = 90%)**
> - claude-endolin1: 0% after your 19:40Z reset. Cap ~267M meter-tok, so ~240M usable before Sat 03:00Z (~55h). That is where nearly all of this week's budget is. Last week this pool burned ~93% in ~4.5 days, so filling 90% in 2.3 days needs the fleet running flat out.
> - claude-endolin2: 86%, ~5M left before 90%. Effectively closed until Sat. 1 credit (expires 10-22): **I propose holding it for mid-week next week.**
> - codex-endolin: 68% at 17:25Z, cap ~25.6M, ~5.6M left before its ~10-05 reset. 2 credits (expire 10-22, 10-29).
> - claude-oros: offline and derotated, counted as zero.
>
> **Who's asking for tokens (ledger since Sat 03:00Z: 85M notional, no cache reads, shares only)**
> | Arc | Spend | Share | Outstanding demand |
> |---|---|---|---|
> | Endo PR backlog (gauntlets/conducts on `endojs/endo-but-for-bots` 1357, 1362, 1298, 1394, 695, 1389, 1349 …; 8 parked 2026-08 weaves) | 30.3M | 36% | ~10 todo, ~15 plan |
> | minion.town caps (Claude-on-MT press ×2 every 3h, `kriscendobot/minion.town` PRs 86, 119, 120, 135, federation orch) | 21.5M | 25% | federation orch (5 serial children; deploy/acceptance are high), 2 presses |
> | ironhorse (panic reseat/host-call, ratchet, test262 press, ocap audit) | 12.3M | 14% | 1 doin; round-3 floor + iterator parity are waiting on you |
> | garden upkeep (self-heal, pr81, digests) | 10.6M | 12% | ~8 go-ahead plans |
> | ebfb sturdyref 8-layer stack | 4.8M | 6% | 8 layers in gauntlet right now, the largest live queue |
> | ebfb petname-path-only sweep | 2.8M | 3% | 3 gauntlet jobs in todo |
> | book, budget/accountant | 2.8M | 3% | book orch; accountant build waits on go-ahead |
> | **endor metering** | **~0** | **0%** | only `endor-same-process-worker-benchmark` (go-ahead) |
>
> **Proposed slate (share of the foreman's discretionary budget until Sat)**
> 1. **minion.town capabilities, 35%**. mandate priority 1. Keep both presses and git-remote PR `kriscendobot/minion.town#86` moving, and let the federation orchestration reach deploy/acceptance.
> 2. **sturdyref stack + petname sweep, 20%**. They are already in flight. Finishing a stack costs less than parking it, and sturdyref feeds the federation/guest-locator work.
> 3. **ironhorse, 15%**. mandate priority 3. Two items are blocked on your decisions, so this slice may go unspent.
> 4. **endor metering, 10%**. mandate priority 2, and it got nothing this week. I propose promoting the worker benchmark as the explorative probe, capped at this slice.
> 5. **Endo PR backlog (off-mandate), 12%**. It was the biggest spender. I propose gating the 2026-08 weaves off and finishing only the gauntlets already staged.
> 6. **garden upkeep, 8%**. Self-heal and ops are not optional.
>
> **Questions**
> 1. **Cut:** OK to squeeze the off-mandate Endo backlog from 36% to ~12%, and to leave the eight 2026-08 weaves (endo-but-for-bots 395–420) parked this week, or retire them?
> 2. **Rank up:** endor metering got nothing. Should it get a real 10% slice via the benchmark, or stay dormant until minion.town caps land? And does sturdyref count as mandate priority 1 work (sliced with minion.town) or as backlog?
> 3. **Mandate and pace:** does the 09-26 mandate still hold as-is? endolin1 has ~240M to spend in ~55h. Should I recommend raising worker capacity to use it, or let the unspent part lapse?
>
> Budget-request intake (design job `design-accountant-budget-request-intake`): I'll pass any view you have on it to that job, e.g. whether roles should file a request for any job above X tokens, or only for campaigns/presses.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_pages_watcher_verify` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_pages_watcher_verify.md)

> Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/pages-watcher/verify: packs 1001 >= 1000; size=387956736B packs=1001 gc.log=0; automatic remedy=deferred-deadline.

- `watchdog-comment-ack-blind-endojs-endo-but-for-bots` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-ack-blind-endojs-endo-but-for-bots.md)

> WATCHDOG notice — occurrence #58 (first seen 2026-09-30T04:37:42Z, latest 2026-09-30T21:22:18Z).
> The SAME condition (`comment-ack-blind-endojs-endo-but-for-bots`) has now been observed 58 times; this is ONE
> coalesced notice that updates in place, not 58 messages. Latest detail:
>
> Comment acknowledgment blind anomaly for endojs/endo-but-for-bots:
> [https://github.com/endojs/endo-but-for-bots/pull/1340](https://github.com/endojs/endo-but-for-bots/pull/1340)#discussion_r4149165593 (age=2215s; heartbeat=full-poll)

- `ebfb-sturdyref-layer2-ses-20260930-gauntlet-halted` — from gauntlet:ebfb-sturdyref-layer2-ses-20260930-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer2-ses-20260930-gauntlet-halted.md)

> Gauntlet ebfb-sturdyref-layer2-ses-20260930-gauntlet HALTED: stage 'ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `watchdog-comment-watcher-stuck-cooldown-host` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-watcher-stuck-cooldown-host.md)

> RECOVERED — the watchdog condition `comment-watcher-stuck-cooldown-host` has CLEARED (first seen 2026-09-30T20:38:38Z, cleared 2026-09-30T20:42:55Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Comment acknowledgment condition cleared.

- `watchdog-journal-contention-watch-overrun` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-watch-overrun.md)

> RECOVERED — the watchdog condition `journal-contention-watch-overrun` has CLEARED (first seen 2026-09-30T20:43:07Z, cleared 2026-09-30T21:18:08Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-contention-watch-overrun` cleared on endolin-garden-ece02cb4.

- `msg-build-minion-town-mcp-garden2-workers-76b942035c1f` — from gardener:build-minion-town-mcp-garden2-workers, reply_to `build-minion-town-mcp-garden2-workers` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-build-minion-town-mcp-garden2-workers-76b942035c1f.md)

> minion.town MCP standing order: machinery landed on main2 (1f0cc8400b5), and it is proven live on endolin-garden2 for claude -p and codex exec. Two decisions are yours before I widen it past garden2:
>
> 1. PRINCIPAL. Right now every attached job acts as `minion-mcp-test-cc` on PRODUCTION minion.town. Its guest holds real state (34 pet names), and the tools include writeText/remove/send/publish/evaluate. Proposal: create a dedicated garden client/principal, so jobs get their own guest, or a read-only scope if the resource server grows one. I have NOT created any Cognito client or changed any scope. The rollout is pinned to endolin-garden2 via journal config/minion-mcp `hosts:`. Once approved, widening is `scripts/jobs/set-minion-mcp.sh hosts '*'`. Separately, I haven't checked whether oros and endolin-garden can read Secrets Manager minion/test-cc-client; after the widening, the watchdog will report any host that can't.
>
> 2. CONTEXT COST. tools/list is about 10.8 KB, roughly 2.5–3k tokens per attached session (16 tools). Should jurors and myrmidon-tier roles get no tools, or a narrower set such as status/list/readText only? Today panel juror seats don't get it at all, since they aren't launched by a worker handler.
>
> Known gaps: mystic (kimi) connects and lists tools, but Moonshot returns "429 suspended: insufficient balance", so no model turn ran. opencode is not installed here, so that path is unverified. Interactive liaison sessions aren't auto-attached; see context/operations/minion-town-mcp.md.

- `foreman-milestone-M3` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/foreman-milestone-M3.md)

> M3’s next confined-agent step is blocked on your choice between advancing `endojs/endo-but-for-bots#1015` after its `#1348` prerequisite clears, or answering the four open questions on design PR `#1340` to enable its build.

- `msg-ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4-b1f64f3f865a` — from gardener:ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4, reply_to `ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4-b1f64f3f865a.md)

> [endojs/endo-but-for-bots#1391](https://github.com/endojs/endo-but-for-bots/issues/1391) (SturdyRef layer 2, SES): the round-4 must-fixes (changeset major, accessor-safe descriptor read, PR-body trim, completion summary) are all landed on the head. CI is red on ONE leg only — test (22.x, macos-15) — and it's a different @endo/daemon teardown timing test each run:
> - run 36758282366 (head 2a14a08e3f): endo.test.js unhandled 'Termination requested' rejection
> - run 36771953238 (head faefd8e514, empty retrigger commit): daemon-teardown › an orphaned daemon shuts itself down
> All 32 other checks pass (including macOS 24.x and every Linux leg). Looks like a flake unrelated to the SES change. The oros-studio bot PAT can't rerun Actions (403), so a rerun from a credentialed host would likely clear it: gh run rerun 36771953238 --failed -R endojs/endo-but-for-bots, then resume the gauntlet (panel-5).

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal.md)

> Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: packs 1007 >= 1000; size=266704896B packs=1007 gc.log=0; automatic remedy=deferred-deadline.

- `msg-reset-credit-watch-20260930-195052-d223f008fbcb` — from gardener:reset-credit-watch-20260930-195052, reply_to `reset-credit-watch-20260930-195052` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-reset-credit-watch-20260930-195052-d223f008fbcb.md)

> **Reset-credit watch (week of 2026-09-26 → 10-03).** Recommendation: **hold the claude-endolin2 credit for next week; spend a codex credit this cycle, but only if you accelerate codex first.** Nothing expires within 10 days. The codex choice is worth deciding by Thu 10-01.
>
> 1. **claude-endolin2: hold.** It crosses 90% around Wed 22:30Z today (about 1.6–2.2M tok/h, 2.4M to go). A reset tonight buys only about 52h (about 30% of a week) before the natural Fri 20:00 PT reset. The credit lasts until Oct 22, so there are 2–3 better windows left. Plan: from Sat 10-03, pace endolin2 to 90% (about 109M of 121.6M) by **Tue 10-06 evening PT** with an `expected-next-scheduled` marker for 10-07T03:00Z, then reset. That buys about 3+ days. The fallback is Tue 10-13, and the last safe window is the week of Oct 17 (reset by Wed Oct 21).
> 2. **codex-endolin: accelerate, then reset.** It sits at 68% and has been flat since about 03:30Z (it made only +2% in 17h). At that pace it will **not** reach 90% before its natural reset (Mon 10-05 16:46Z), so no credit is useful unless the fleet speeds up. To act, add cleric workers and set an `expected-next-scheduled` deadline around **Fri 10-02 18:00Z**. It needs about 5.6M more tokens (roughly 25h at Mon–Tue pace). Then reset with the **Oct 22** credit. The reset restarts the rolling 7-day window, which gains about 3 days. Keep the Oct 29 credit for a later window.
>
> **Status**
> - claude-endolin1: 1% after the 19:40Z manual reset. Natural reset Sat 10-03 03:00Z. No credits. It has about 54h of nearly free budget, so run it flat out.
> - claude-endolin2: about 88% on the live meter (107.0M of 121.6M), in backoff. Natural reset Sat 10-03 03:00Z. **1 credit, expires Oct 22.**
> - codex-endolin: 68%, pace about 0 since this morning. Natural reset Mon 10-05 16:46Z. **2 credits, expire Oct 22 and Oct 29.**
> - claude-oros: offline and derotated. Credits unknown.
>
> Inventory reconciled: no change since your 19:45Z entry. No actuation taken.

- `endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached` — from gauntlet:endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached.md)

> INFO: Gauntlet endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-journal-contention-storm-clone-oversized` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-storm-clone-oversized.md)

> Journal contention storm on endolin-garden-ece02cb4: 6 clones hit clone-oversized in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
> - Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-endo: packs 1000 >= 1000; size=409749504B packs=1000 gc.log=0; automatic remedy=deferred-deadline.
> - Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-vattr97: packs 1010 >= 1000; size=410876928B packs=1010 gc.log=0; automatic remedy=deferred-deadline.
> - Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-oros-ckm-data-readiness: packs 1001 >= 1000; size=409463808B packs=1001 gc.log=0; automatic remedy=deferred-deadline.
> - Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/pages-watcher/verify: packs 1013 >= 1000; size=391076864B packs=1013 gc.log=0; automatic remedy=deferred-deadline.
> - Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: packs 1030 >= 1000; size=268472320B packs=1030 gc.log=0; automatic remedy=deferred-deadline.
> - Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ymax-e2e: packs 1003 >= 1000; size=409834496B packs=1003 gc.log=0; automatic remedy=deferred-deadline.

- `watchdog-budget-zone-oros-studio-garden-ce242c49-backoff` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-oros-studio-garden-ce242c49-backoff.md)

> subscription claude-oros changed zone ok -> backoff at spend=6052865/73000000.

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.

- `watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49.md)

> Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to c63c16cad579 20 min ago
> but still reports deployed_sha e036bb8e0650b66a4ae00dc1516c4c8df39901ca. Check garden-self-deploy on oros-studio-garden-ce242c49
> (journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
> keeps it from advancing. The leader does not advance past an undeployed canary.
> (leader=endolin-garden-ece02cb4)


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 14.2M | $138.54 _(notional, rate-card)_ | 6% of 256.0M (ok) |
| Codex | 17.7M _(fleet aggregate)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 38% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 186443012 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 4.833768s/45s (/home/kris/garden/.garden-state/state-clone-keeper/journal); 5 open notice(s); checker healthy

## Board
### todo (20)
- [`ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1398
- [`build-accountant-arc-apportionment`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-accountant-arc-apportionment.md) — Build: accountant arc apportionment (garden main2)
- [`book-copyedit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/book-copyedit.md) — Copy-edit pass on the garden book
- [`improve-journal-fallback-warn-dedup`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/improve-journal-fallback-warn-dedup.md) — ---
- [`endojs-endo-but-for-bots-pr1340-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1340-gauntlet-viability.md) — Gauntlet stage: PRE-SPEND VIABILITY - endojs/endo-but-for-bots PR #1340
- [`ebfb-petname-path-only-sweep-3-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-sweep-3-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1390
- [`ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1393
- [`endojs-endo-but-for-bots-pr1357-review-answer-oq1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1357-review-answer-oq1.md) — Record maintainer answer to the Open Question on endojs/endo-but-for-bots PR ...
- [`retire-gardener-worker-kind-alias-env-fallback`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/retire-gardener-worker-kind-alias-env-fallback.md) — Deliberate overrun decomposition for retire-gardener-worker-kind-alias-env-fa...
- [`ebfb-petname-path-only-sweep-4-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-sweep-4-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1390
- [`build-ci-minion-town-actions-runner-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-ci-minion-town-actions-runner-gauntlet-viability.md) — Gauntlet stage: PRE-SPEND VIABILITY - kriscendobot/minion.town PR #145
- [`endojs-endo-but-for-bots-pr1397-1398-sturdyref-rebase-bases`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1397-1398-sturdyref-rebase-bases.md) — Move #1397/#1398 PR bases onto the restacked frozen bases, confirm #1398 lint
- [`ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1392
- [`ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1396
- [`endojs-endo-but-for-bots-pr695-gauntlet-20260930-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr695-gauntlet-20260930-viability.md) — Gauntlet stage: PRE-SPEND VIABILITY - endojs/endo-but-for-bots PR #695
- [`design-mount-root-attenuation-controller`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/design-mount-root-attenuation-controller.md) — Design: filesystem mount attenuation with a root-controller facet
- [`ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1397
- [`endojs-endo-but-for-bots-pr1394-20260930-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1394-20260930-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1394
- [`ebfb-petname-path-only-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1390
- [`fu-qwen-model-watch-20260728-180502-1-20260930-162006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/fu-qwen-model-watch-20260728-180502-1-20260930-162006.md) — ---

### doin (6)
- [`accountant-budget-conversation-20260930`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/accountant-budget-conversation-20260930.md) — ---
- [`ebfb-petname-path-only-sweep-gauntlet-fix-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-petname-path-only-sweep-gauntlet-fix-4.md) — Gauntlet stage: FIX round 4 — endojs/endo-but-for-bots PR #1390
- [`ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #774
- [`endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-5.md) — Gauntlet stage: FIX round 5 — endojs/endo-but-for-bots PR #1380
- [`fix-endo-but-for-bots-macos-daemon-teardown-flake`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/fix-endo-but-for-bots-macos-daemon-teardown-flake.md) — Flaky test (22.x, macos-15) CI leg: daemon teardown race unrelated to the PRs...
- [`ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1394

### tada (10116)
- [`reset-credit-watch-20260930-195052`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/reset-credit-watch-20260930-195052.md) — Cost
- [`design-accountant-budget-request-intake`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/design-accountant-budget-request-intake.md) — Cost
- [`endojs-endo-but-for-bots-pr1340-review-85c8bc95`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/endojs-endo-but-for-bots-pr1340-review-85c8bc95.md) — Cost
- [`build-ci-minion-town-actions-runner`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/build-ci-minion-town-actions-runner.md) — Cost
- [`ebfb-sturdyref-layer2-ses-20260930-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/ebfb-sturdyref-layer2-ses-20260930-gauntlet.md) — gauntlet ebfb-sturdyref-layer2-ses-20260930-gauntlet — HALTED
- … and 10111 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`make-panel-stage-survive-supervisor-session-exit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/make-panel-stage-survive-supervisor-session-exit.md) — _normal_ · Make panel execution survive supervising agent-session exit
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
- [`open-signup-gate-flip-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source.md) — _normal_ · Build: SES import attributes — Phase 2 (module-source static with capture)
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`ebfb-llm-xs-daemon-bundle-reconcile`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-xs-daemon-bundle-reconcile.md) — _normal_ · ---
- [`build-readableblob-range-attenuation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-readableblob-range-attenuation.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`ironhorse-iterator-scenario-parity-maintainer-decision`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-iterator-scenario-parity-maintainer-decision.md) — _high_ · resolve the remaining acceptance scope for IronHorse iterator scenario parity
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr909-fix-ts-make-daemon`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-fix-ts-make-daemon.md) — _normal_ · Fix: endo make / endo archive TypeScript support is broken (endojs/endo-but-f...
- [`build-usage-scrape-ingest`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-usage-scrape-ingest.md) — _normal_ · ---
- [`drive-mystic-rollout-20260723`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/drive-mystic-rollout-20260723.md) — _low_ · ---
- [`kimi-k3-canary-20260723-c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kimi-k3-canary-20260723-c.md) — _low_ · ---
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`evaluate-reauth-escalation-default-after-oauth-relay-20260927`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/evaluate-reauth-escalation-default-after-oauth-relay-20260927.md) — _low_ · Evaluate default reauth escalation once the browser OAuth relay lands
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper.md) — _normal_ · Build: SES import attributes — Phase 3 (compartment-mapper plumbing)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`build-claude-usage-dashboard-scraper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-claude-usage-dashboard-scraper.md) — _normal_ · ---

### awaiting maintainer decision (answer at the linked question)
- [`endo-cli-no-autostart-exit-codes-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-cli-no-autostart-exit-codes-build.md) - [Design OQ1/OQ3: should the CLI default to no-autostart under a service manager, and are the proposed exit codes acceptable?](https://github.com/endojs/endo-but-for-bots/pull/1383)
- [`ironhorse-test262-ratchet-round3-floor-resolution-20260928`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-test262-ratchet-round3-floor-resolution-20260928.md) - [Reconcile the historical floor with current verdict/resource policy, or restore all 901 genuinely under unchanged pins and policy?](https://github.com/kriscendobot/garden/issues/51#issuecomment-5877917421)
- [`minion-town-pr87-production-gate-resume-20260922`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-pr87-production-gate-resume-20260922.md) - [PR #87 production-reality gate: which backend is the production provider (CLI/Agent-SDK; re-run failed SDK track first?), proceed before endo#1015 lands or gate on it, and what counts as production evidence + are credentials provided?](https://github.com/kriscendobot/minion.town/pull/87#issuecomment-5770203120)
- [`endo-daemon-orphan-safe-stop-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-daemon-orphan-safe-stop-build.md) - [Design OQ2: should run-daemon run the manager in-process, or keep the child process and forward signals?](https://github.com/endojs/endo-but-for-bots/pull/1383)
- [`ironhorse-computron-benchmark-baseline-build-after-approval`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-computron-benchmark-baseline-build-after-approval.md) - [Will the maintainer lift the Ironhorse pause, approve design PR #1283 (or direct an early build), and answer its six open questions (or direct the recommended defaults)?](https://github.com/endojs/endo-but-for-bots/pull/1283)

### deferred (top by priority; foreman auto-promotes when idle)
- [`endojs-endo-but-for-bots-pr1349-gauntlet-20260930-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1349-gauntlet-20260930-panel-3.md) — _normal_ · Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1349
- [`endojs-endo-but-for-bots-pr1389-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1389-gauntlet-fix-3.md) — _normal_ · Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1389
- [`fix-subscription-model-deploy-gate-regression`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-subscription-model-deploy-gate-regression.md) — _normal_ · Fix deploy-gate regression from subscription-based-budget-model
- [`kriscendobot-garden-pr75-review-6b5f570b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr75-review-6b5f570b-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #75 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-minion.town-pr85-review-9f17a419-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr85-review-9f17a419-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #85 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr90-d6a72a2f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr90-d6a72a2f-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #90 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr135-review-e4d01640-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr135-review-e4d01640-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #135 (primary: kriscendobot-mini...
- [`endojs-endo-but-for-bots-pr695-5e067785-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr695-5e067785-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #695 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr1357-review-a8630960-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1357-review-a8630960-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1357 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1340-review-85c8bc95-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1340-review-85c8bc95-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1340 (primary: endojs-endo-but-...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`ebfb-platform-fs-pet-name-path-only`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-platform-fs-pet-name-path-only.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1390` · ---
- [`endo-minion-town-federation-release-gate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-minion-town-federation-release-gate.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1124` · Gate: reviewed and deployable federation release
- [`verify-ironhorse-press-first-engagement-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ironhorse-press-first-engagement-20260929.md) — awaiting `ironhorse-test262-press-20260929-173306` · Verify the first live Ironhorse foreman-press engagement (successor of activa...
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1019` · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`build-exo-sheets-service`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-sheets-service.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`ironhorse-fuzz-triage-differential_source-efffacee3e2a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-triage-differential_source-efffacee3e2a.md) — awaiting `https://github.com/kriscendobot/garden/issues/91` · Triage 7 Ironhorse fuzz finding(s) for target differential_source

## Watch set
kriscendobot-minion.town kriscendobot-cosgov kriscendobot-ocapn kriscendobot-oros-ckm-data-readiness kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot

## Hosts
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 1 monks
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 4 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 3 monks
