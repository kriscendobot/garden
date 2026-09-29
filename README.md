# Garden bulletin

_As of 2026-09-29T10:11:28Z_

## Latest

Two jobs moved from the plan queue back onto the board since the last bulletin: a re-check of the dependabot backlog on endo-but-for-bots, and the resumption of the gauntlet's CLEAN stage for [endojs/endo-but-for-bots#1100](https://github.com/endojs/endo-but-for-bots/pull/1100). The board itself otherwise churns on active gauntlet work — PR #1362 is on its fifth fix round, and a weave (base-pin advance) is underway on [endojs/endo-but-for-bots#1097](https://github.com/endojs/endo-but-for-bots/pull/1097) — while the maintainer inbox has piled up with a long run of M2/M3 milestone gates awaiting a gauntlet-authorization decision, most pointing at [endojs/endo-but-for-bots#1349](https://github.com/endojs/endo-but-for-bots/pull/1349) and #1356, plus a HALTED rolling-deploy canary on oros-studio-garden-ce242c49 and a stale, 25-commits-behind leader deploy that's worth a look.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#1282](https://github.com/endojs/endo-but-for-bots/pull/1282) — chore(ironhorse): demolish the XS-computron-parity myth (waiting 2d)
- [endojs/endo-but-for-bots#1281](https://github.com/endojs/endo-but-for-bots/pull/1281) — fix(ses): silence lockdown intrinsics report for the WHATWG URL family (waiting 11d)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 17d)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 25d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 27d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 27d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 27d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 27d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 28d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 30d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260928T173257Z-02c8de` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T173257Z-02c8de.md)

> M2’s next advance is draft [endojs/endo-but-for-bots#1349](https://github.com/endojs/endo-but-for-bots/issues/1349); decide whether its remaining llm downstream audit is required, then explicitly authorize `run the gauntlet #1349`.

- `watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-host-offline-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-09-29T05:53:06Z, cleared 2026-09-29T09:41:03Z).
> It was observed 9 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> heartbeat resumed for oros-studio-garden-ce242c49; it is PRESENT again and will automatically rejoin the canary rotation while its hosts/oros-studio-garden-ce242c49 record remains active. Archived records are not unarchived automatically.

- `msg-ironhorse-test262-ratchet-round3-20260928-0d0c921abeb6` — from gardener:ironhorse-test262-ratchet-round3-20260928, reply_to `ironhorse-test262-ratchet-round3-20260928` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ironhorse-test262-ratchet-round3-20260928-0d0c921abeb6.md)

> Decision needed for round 3: the completed current-llm sweep has 906 lost paths against the historical floor BEFORE my changes: 443 engine-limit aborts, 397 shared-positive-test-failure, 66 other. Several hundred historical covered cases were false positives under the old classifier; I will not mark them covered or weaken the current classifier. May the draft record an explicitly reconciled current-llm floor (36,599 covered) and defend zero loss against that, retaining all 906 historical dispositions for follow-up? Otherwise this round's literal superseding-floor acceptance cannot be honestly met in one constants-descriptor crank. The proposed fix already has 5 red-before/green-after dual-run tests and repairs Math/Number/TypedArray numeric constant attributes; full Rust gates and an after sweep are next.

- `msg-endojs-endo-but-for-bots-ironhorse-panic-open-questions-mentat-f59de760afce` — from gardener:endojs-endo-but-for-bots-ironhorse-panic-open-questions-mentat, reply_to `endojs-endo-but-for-bots-ironhorse-panic-open-questions-mentat` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-endojs-endo-but-for-bots-ironhorse-panic-open-questions-mentat-f59de760afce.md)

> Self-improvement observation from [endojs/endo-but-for-bots#1370](https://github.com/endojs/endo-but-for-bots/issues/1370): ensure-pr.sh's phase/evidence gate prefers a local base ref over origin/<base>. In this isolated project checkout local llm was 3aa902d0037, while origin/llm and the survey base were 1706e63247f. The stale local comparison pulled unrelated source changes into a design-only PR and demanded an implementation ledger. I reran the unchanged gate through a wrapper that supplies --base origin/llm; it returned phase-evidence-verdict=clear reason=design-only-diff, and ensure-pr opened the requested draft. Recommend resolving the intended remote base before the gate, or passing the freshly verified SHA, rather than preferring an arbitrary local branch. No garden source edits made in this project job.

- `msg-endo-minion-town-federation-release-gate-33860f5fb6ad` — from gardener:endo-minion-town-federation-release-gate, reply_to `endo-minion-town-federation-release-gate` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-endo-minion-town-federation-release-gate-33860f5fb6ad.md)

> Release gate `endo-minion-town-federation-release-gate` is BLOCKED; nothing is reviewed or merged yet. Deployment stays held.
>
> Required-PR matrix (checked 2026-09-23 ~22:00Z):
>
> | # | PR | Needs | Current state |
> |---|---|---|---|
> | 0 | [endojs/endo-but-for-bots#1332](https://github.com/endojs/endo-but-for-bots/issues/1332) (design, draft, base llm-f9cbcfc) | Maintainer answers on authority questions (1)-(3) in [https://github.com/endojs/endo-but-for-bots/pull/1332](https://github.com/endojs/endo-but-for-bots/pull/1332)#issuecomment-5803040971 and the gateway-takeover report [https://github.com/endojs/endo-but-for-bots/pull/1332](https://github.com/endojs/endo-but-for-bots/pull/1332)#issuecomment-5803339422 | draft, no reviews, no maintainer comments |
> | 1 | gateway session-binding + advertised-address fix (job `endo-ocapn-gateway-session-binding-build`, in doin) | Draft PR, then gauntlet, maintainer approval, merge to llm | no PR yet; job still running |
> | 2 | [endojs/endo-but-for-bots#1124](https://github.com/endojs/endo-but-for-bots/issues/1124) (nonce locator, head 96674df196, base llm) | Maintainer review + gauntlet refresh on current llm + merge | open draft; 5 bot panel reviews from 09-03 to 09-05, no maintainer review |
> | 3 | [endojs/endo-but-for-bots#1333](https://github.com/endojs/endo-but-for-bots/issues/1333) (adopt-locator, head 11e726e7b1, frozen base job-federation-nonce-f9cbcfc) | Re-point to llm after [endojs/endo-but-for-bots#1124](https://github.com/endojs/endo-but-for-bots/issues/1124) lands, then gauntlet, approval, merge | open draft, no reviews |
> | 4 | [kriscendobot/minion.town#117](https://github.com/kriscendobot/minion.town/issues/117) (head 79ff6ec2d0, base main-3062124) | Pins moved to merged llm SHAs, review, and a landing that accounts for main auto-deploy | open draft, no reviews |
>
> [endojs/endo-but-for-bots#684](https://github.com/endojs/endo-but-for-bots/issues/684) (WSS), [endojs/endo-but-for-bots#688](https://github.com/endojs/endo-but-for-bots/issues/688), [endojs/endo-but-for-bots#693](https://github.com/endojs/endo-but-for-bots/issues/693) and [endojs/endo-but-for-bots#990](https://github.com/endojs/endo-but-for-bots/issues/990) are NOT required: this release serves only CBOR+Noise over TCP. [endojs/endo-but-for-bots#1329](https://github.com/endojs/endo-but-for-bots/issues/1329) (the registry-startup fix for the [kriscendobot/minion.town#111](https://github.com/kriscendobot/minion.town/issues/111) regression) is merged on llm as f9cbcfc426, so it comes in when the pins move; the release manifest still has to show [kriscendobot/minion.town#111](https://github.com/kriscendobot/minion.town/issues/111)-style evidence (a dry-run against a copy of the state DB).
>
> Manual actions needed, in this order (the gate triggers no gauntlet and un-drafts nothing):
> 1. Answer the authority questions on [endojs/endo-but-for-bots#1332](https://github.com/endojs/endo-but-for-bots/issues/1332). Stage 2 activation depends on them.
> 2. When you're ready, "run the gauntlet [endojs/endo-but-for-bots#1124](https://github.com/endojs/endo-but-for-bots/issues/1124)", then approve and merge it.
> 3. After the gateway-fix PR exists, run its gauntlet and approve/merge it.
> 4. Say "run the gauntlet [endojs/endo-but-for-bots#1333](https://github.com/endojs/endo-but-for-bots/issues/1333)" once it has been re-pointed at llm.
>
> This job is parked on [endojs/endo-but-for-bots#1124](https://github.com/endojs/endo-but-for-bots/issues/1124) (block-job.sh) and resumes automatically when that PR merges or closes. On resume it re-checks merged vs. closed.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-2.md)

> WATCHDOG notice — occurrence #6 (first seen 2026-09-09T20:50:15Z, latest 2026-09-27T16:12:25Z).
> The SAME condition (`budget-level-cleric-endolin-garden-ece02cb4-2`) has now been observed 6 times; this is ONE
> coalesced notice that updates in place, not 6 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 cleric workers 3 -> 2 (target 2): shared codex subscription demand active=1 queue=2 quota=ok fleet-envelope=5 target=2

- `20260928T174334Z-b75912` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T174334Z-b75912.md)

> Milestone M2 is blocked: its remaining work is in clean draft PRs [endojs/endo-but-for-bots#1349](https://github.com/endojs/endo-but-for-bots/issues/1349) and #1356. Decide whether to promote either for the manual gauntlet.

- `20260929T034336Z-473eb2` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260929T034336Z-473eb2.md)

> awaiting maintainer — beyond proxy authority: gardener activate-ironhorse-ratchet-autopilot-20260929-r3, msgid msg-activate-ironhorse-ratchet-autopilot-20260929-r3-35b22755c4d2.md — Requires maintainer action: hands-on-host diagnosis (journalctl on oros-studio) or a sysop `deploy` op, which mandates maintainer attestation (`authorized_by:` on `maintainers/allowlist`) — squarely outside proxy authority.

- `watchdog-budget-zone-endolin-garden-ece02cb4-ok` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden-ece02cb4-ok.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-08-27T01:30:12Z, latest 2026-09-28T06:45:37Z).
> The SAME condition (`budget-zone-endolin-garden-ece02cb4-ok`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> subscription codex-endolin changed zone backoff -> ok at spend=48768757 of cap=100.

- `20260928T012322Z-a069e5` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T012322Z-a069e5.md)

> M2’s remaining records are draft PRs: reconcile hardened-url-shim via [endojs/endo-but-for-bots#1355](https://github.com/endojs/endo-but-for-bots/issues/1355) and complete the XS smoke coverage via #1349. Please decide whether to run the gauntlet on these drafts; no autonomous work job can advance the manual-review gate.

- `watchdog-comment-ack-latency-endojs-endo-but-for-bots` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-ack-latency-endojs-endo-but-for-bots.md)

> RECOVERED — the watchdog condition `comment-ack-latency-endojs-endo-but-for-bots` has CLEARED (first seen 2026-09-29T05:40:04Z, cleared 2026-09-29T05:44:50Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Comment acknowledgment condition cleared.

- `20260928T172319Z-a6992a` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T172319Z-a6992a.md)

> M2 is blocked at draft PR [endojs/endo-but-for-bots#1349](https://github.com/endojs/endo-but-for-bots/issues/1349), the hardened TextEncoder/TextDecoder XS smoke check. Decide whether to run the gauntlet for #1349; no other M2 work remains unblocked.

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-2.md)

> WATCHDOG notice — occurrence #3 (first seen 2026-09-17T00:05:35Z, latest 2026-09-27T12:35:28Z).
> The SAME condition (`budget-level-cleric-endolin-garden2-5bcdff64-2`) has now been observed 3 times; this is ONE
> coalesced notice that updates in place, not 3 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 cleric workers 1 -> 2 (target 2): shared codex subscription demand active=2 queue=6 quota=ok fleet-envelope=5 target=2

- `watchdog-comment-ack-blind-endojs-endo-but-for-bots` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-ack-blind-endojs-endo-but-for-bots.md)

> WATCHDOG notice — occurrence #40 (first seen 2026-09-29T05:44:56Z, latest 2026-09-29T10:10:08Z).
> The SAME condition (`comment-ack-blind-endojs-endo-but-for-bots`) has now been observed 40 times; this is ONE
> coalesced notice that updates in place, not 40 messages. Latest detail:
>
> Comment acknowledgment blind anomaly for endojs/endo-but-for-bots:
> [https://github.com/endojs/endo-but-for-bots/pull/1357](https://github.com/endojs/endo-but-for-bots/pull/1357)#discussion_r4129930579 (age=16971s; heartbeat=full-poll)
> [https://github.com/endojs/endo-but-for-bots/pull/1357](https://github.com/endojs/endo-but-for-bots/pull/1357)#discussion_r4129939009 (age=16882s; heartbeat=full-poll)

- `watchdog-budget-level-monk-endolin-garden2-5bcdff64-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden2-5bcdff64-2.md)

> WATCHDOG notice — occurrence #13 (first seen 2026-09-12T03:20:21Z, latest 2026-09-29T03:20:22Z).
> The SAME condition (`budget-level-monk-endolin-garden2-5bcdff64-2`) has now been observed 13 times; this is ONE
> coalesced notice that updates in place, not 13 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 monk workers 1 -> 2 (target 2): subscription claude-endolin2 spend=37179841 cap=64000000 pace-bias=0.435193 window-start=2026-09-26T03:00Z(calendar) deadline=2026-09-30T03:00Z(planned) ceiling=3 target=2

- `watchdog-budget-zone-endolin-garden-ece02cb4-backoff` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden-ece02cb4-backoff.md)

> subscription codex-endolin changed zone ok -> backoff at spend=41944294 of cap=100.

- `watchdog-comment-ack-latency-kriscendobot-garden` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-ack-latency-kriscendobot-garden.md)

> RECOVERED — the watchdog condition `comment-ack-latency-kriscendobot-garden` has CLEARED (first seen 2026-09-29T05:40:15Z, cleared 2026-09-29T05:45:01Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Comment acknowledgment condition cleared.

- `watchdog-budget-zone-endolin-garden2-5bcdff64-backoff` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden2-5bcdff64-backoff.md)

> subscription codex-endolin changed zone ok -> backoff at spend=11420683 of cap=100.

- `20260927T190020Z-7b30f4` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260927T190020Z-7b30f4.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: build-daemon-agent-tools
> - question (msgid msg-build-daemon-agent-tools-ab6ed31c15ed.md)
> - tentative answer: proxy/tentative — go with **Option A**: target a frozen `llm` base (matching how this stack has landed all along — [endojs/endo-but-for-bots#614](https://github.com/endojs/endo-but-for-bots/issues/614), [endojs/endo-but-for-bots#615](https://github.com/endojs/endo-but-for-bots/issues/615), [endojs/endo-but-for-bots#616](https://github.com/endojs/endo-but-for-bots/issues/616), [endojs/endo-but-for-bots#661](https://github.com/endojs/endo-but-for-bots/issues/661), [endojs/endo-but-for-bots#705](https://github.com/endojs/endo-but-for-bots/issues/705), and [endojs/endo-but-for-bots#707](https://github.com/endojs/endo-but-for-bots/issues/707) all live there, not on `master`) and integrate an explicit harness that composes shell+remote without relying on [endojs/endo-but-for-bots#707](https://github.com/endojs/endo-but-for-bots/issues/707)'s ambiguous `inspect`-collision `makeWorkspaceTools`, and without resurrecting the dynamic-discovery approach [endojs/endo-but-for-bots#618](https://github.com/endojs/endo-but-for-bots/issues/618) was closed over for capability-leak reasons — pick names/an explicit registration surface instead. Option B (porting the entire transitive capability stack to `master`) is a much bigger, separate undertaking that doesn't belong inside this one build job's scope; if a `master` port is ever wanted, that should be its own job/design, not folded into "build daemon agent tools." Keep building toward the draft PR on `llm` per your current plan — this is provisional and the maintainer may revise it when they're back.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_leader_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_leader_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_leader_journal` has CLEARED (first seen 2026-09-29T07:44:23Z, cleared 2026-09-29T07:49:13Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_leader_journal` cleared on endolin-garden-ece02cb4.

- `msg-research-quarterly-completions-report-ocap-site-20260929-1fdf762fc8ee` — from gardener:research-quarterly-completions-report-ocap-site-20260929, reply_to `research-quarterly-completions-report-ocap-site-20260929` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-research-quarterly-completions-report-ocap-site-20260929-1fdf762fc8ee.md)

> Quarterly completions rollup published: https://fbx2igid4iixr7kt2lzo7nx3qlynzsjqbwqmqircue4a3h5axwma.ocap.site/
>
> It covers 9,490 recorded completions from 2026-06-24 through 2026-09-29, with monthly and basename-derived job-kind breakdowns plus selected notable completions. The immutable clip returned serving:true and passed live HTTP and headless-browser checks.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-1.md)

> WATCHDOG notice — occurrence #5 (first seen 2026-09-09T21:05:16Z, latest 2026-09-29T01:35:56Z).
> The SAME condition (`budget-level-cleric-endolin-garden-ece02cb4-1`) has now been observed 5 times; this is ONE
> coalesced notice that updates in place, not 5 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 cleric workers 0 -> 1 (target 1): shared codex subscription demand active=0 queue=2 quota=ok fleet-envelope=1 target=1

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-2.md)

> WATCHDOG notice — occurrence #15 (first seen 2026-09-12T03:20:10Z, latest 2026-09-29T04:35:16Z).
> The SAME condition (`budget-level-monk-endolin-garden-ece02cb4-2`) has now been observed 15 times; this is ONE
> coalesced notice that updates in place, not 15 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 monk workers 1 -> 2 (target 2): subscription claude-endolin1 spend=98399246 cap=143000000 pace-bias=0.204439 window-start=2026-09-26T03:00Z(calendar) deadline=2026-09-30T03:00Z(planned) ceiling=4 target=2

- `stale-panel-head-endojs-endo-but-for-bots-pr1015-971fe22c-10223934` — from gardener:endojs-endo-but-for-bots-pr1015-refresh-for-preliminary-review, reply_to `endojs-endo-but-for-bots-pr1015-refresh-for-preliminary-review` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/stale-panel-head-endojs-endo-but-for-bots-pr1015-971fe22c-10223934.md)

> Stale panel coverage for completed job `endojs-endo-but-for-bots-pr1015-refresh-for-preliminary-review`: [https://github.com/endojs/endo-but-for-bots/pull/1015](https://github.com/endojs/endo-but-for-bots/pull/1015) moved from panel-reviewed head `971fe22c` to presented head `10223934ebc59acae26b1fd96fe1ebf91b42ebb3`.
>
> Disposition: **review required**. The earlier panel does not cover the current head; every commit delta is conservatively review-relevant. A PR metadata-only edit would leave the head unchanged and would not trigger this disposition.
>
> No gauntlet was staged. Route the current head through the existing panel stage only after an explicit maintainer `run the gauntlet` request, or make a maintainer review decision with the stale coverage stated explicitly.

- `20260927T184844Z-fb282f` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260927T184844Z-fb282f.md)

> M2’s remaining design records are substantively complete upstream, while the clean, reviewed documentation PR [endojs/endo-but-for-bots#756](https://github.com/endojs/endo-but-for-bots/issues/756) remains open. Decide whether to merge that PR and reconcile the two M2 design statuses to Complete.

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-0` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-0.md)

> WATCHDOG notice — occurrence #4 (first seen 2026-09-13T14:20:13Z, latest 2026-09-29T01:20:18Z).
> The SAME condition (`budget-level-cleric-endolin-garden2-5bcdff64-0`) has now been observed 4 times; this is ONE
> coalesced notice that updates in place, not 4 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 cleric workers 1 -> 0 (target 0): shared codex subscription demand active=0 queue=1 quota=ok fleet-envelope=1 target=0

- `watchdog-budget-level-monk-endolin-garden2-5bcdff64-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden2-5bcdff64-1.md)

> WATCHDOG notice — occurrence #10 (first seen 2026-09-26T03:06:05Z, latest 2026-09-29T04:20:37Z).
> The SAME condition (`budget-level-monk-endolin-garden2-5bcdff64-1`) has now been observed 10 times; this is ONE
> coalesced notice that updates in place, not 10 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 monk workers 2 -> 1 (target 1): subscription claude-endolin2 spend=44518484 cap=64000000 pace-bias=0.176922 window-start=2026-09-26T03:00Z(calendar) deadline=2026-09-30T03:00Z(planned) ceiling=2 target=1

- `watchdog-journal-contention-watch-overrun` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-watch-overrun.md)

> Journal contention checker on oros-studio-garden-ce242c49 cannot finish a tick inside its 210s budget: deferred 126 of 126 clone(s) on consecutive ticks.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-4` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-4.md)

> budget-level changed endolin-garden-ece02cb4 cleric workers 3 -> 4 (target 4): shared codex subscription demand active=2 queue=3 quota=ok fleet-envelope=5 target=4

- `watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49.md)

> Rolling deploy HALTED on a failed canary.
> canary host: oros-studio-garden-ce242c49
> target sha:  18df481c04b5aca0fec1f93ebdf8a0393b69544f
> failing signal: retries exhausted after re-validation kept failing
> This canary was RETRIED 3 time(s) automatically and kept
> failing, so the roll has stopped retrying and now needs YOU. This is a persistent,
> confirmed regression, not a transient blip — treat it as higher severity than a
> first-tick halt.
> The roll released no further followers and the LEADER did NOT advance itself — a
> broken tip that fails a canary never reaches the leader. The canary was left DRAINED
> (benign roll-induced drain op) pending your decision; auto-rollback is deliberately not
> performed (designs/follower-self-deploy.md § Failure handling). Investigate the target
> on oros-studio-garden-ce242c49, then lift its drain and re-trigger, or hold the tip. (leader=endolin-garden-ece02cb4)

- `watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4.md)

> root repo /home/kris/garden deploy has been STALLED for ~0d / 25 commits behind (leader commits-fuse 25): deployed sha e036bb8e0650b66a4ae00dc1516c4c8df39901ca is 25 commit(s) behind origin/main2 (9bf25f4362f9638313fdd55875bd218b11557d47) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. This host is the LEADER: it runs every singleton producer (foreman, scheduler, watchers), so while it is stale it is NOT honoring any directive newer than its deployed sha — a PROJECT PAUSE among them. This is the shape that let a stale leader run ~60 IronHorse fuzz jobs a week after the 09-09 pause (designs/project-pause-enforcement.md). DEPLOY IT. (host=endolin-garden-ece02cb4)

- `20260928T172814Z-aab24c` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T172814Z-aab24c.md)

> Milestone M2 is blocked on its two green draft PRs: decide whether the hardened-text Phase 3 `llm` audit is required, then authorize gauntlet promotion for #1349 and #1356.

- `watchdog-comment-provenance-gap-endolin-garden-ece02cb4` — from watchdog:comment-provenance, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-provenance-gap-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #5 (first seen 2026-09-29T00:26:19Z, latest 2026-09-29T08:56:07Z).
> The SAME condition (`comment-provenance-gap-endolin-garden-ece02cb4`) has now been observed 5 times; this is ONE
> coalesced notice that updates in place, not 5 messages. Latest detail:
>
> comment-provenance INSTRUMENTATION GAP on host endolin-garden-ece02cb4: a fleet `gh` comment was posted by an LLM-driven caller, but NEITHER GARDEN_JOB_MODEL NOR GARDEN_WORKER_KIND resolved — so the footer named only the host and garden commit (no model/harness/provider). This is the PR #1125 defect. The comment STILL posted (fail-open); nothing is broken. FIX: find the code path posting the comment and export the job facts (GARDEN_JOB_MODEL + GARDEN_WORKER_KIND) before its `gh` call, OR set GARDEN_NO_LLM=1 if it is a deterministic (no-LLM) post.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-3` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-3.md)

> WATCHDOG notice — occurrence #6 (first seen 2026-09-17T00:05:19Z, latest 2026-09-27T16:43:04Z).
> The SAME condition (`budget-level-cleric-endolin-garden-ece02cb4-3`) has now been observed 6 times; this is ONE
> coalesced notice that updates in place, not 6 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 cleric workers 2 -> 3 (target 3): shared codex subscription demand active=2 queue=1 quota=ok fleet-envelope=5 target=3

- `20260928T175544Z-3d14da` — from deploy-garden, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T175544Z-3d14da.md)

> kind: error
>
> # Deploy candidate test gate rejected main2
>
> candidate: `39d0c5ef0aca4f55612eb774f13fb5907ec3a769`
> failing suites: scripts/jobs/test/triager-pacing-test.sh(rc=1; diagnostic=/home/kris/garden/.garden-state/deploy/candidate-gate-diagnostics/39d0c5ef0aca4f55612eb774f13fb5907ec3a769/attempt2-01-scripts_jobs_test_triager-pacing-test.sh.log)
>
> Each executed failing suite above names its bounded stdout/stderr diagnostic. Diagnostics
> are host-local on `endolin-garden-ece02cb4` and retain at most
> `16384` bytes of output per suite.
>
> The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
> for a deliberate emergency deploy after assessing this failure.

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

- `20260928T170259Z-29340b` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T170259Z-29340b.md)

> M2 is blocked on the draft PRs: authorize running the gauntlet for [endojs/endo-but-for-bots#1349](https://github.com/endojs/endo-but-for-bots/issues/1349), and decide whether to close superseded duplicate #1356.

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-3` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-3.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-12T03:35:10Z, latest 2026-09-28T08:11:20Z).
> The SAME condition (`budget-level-monk-endolin-garden-ece02cb4-3`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 monk workers 2 -> 3 (target 3): subscription claude-endolin1 spend=42821049 cap=143000000 pace-bias=0.020559 ceiling=4 target=3

- `watchdog-budget-level-monk-oros-studio-garden-ce242c49-4` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-oros-studio-garden-ce242c49-4.md)

> budget-level changed oros-studio-garden-ce242c49 monk workers 3 -> 4 (target 4): subscription claude-oros spend=842330 cap=73000000 pace-bias=1.000000 window-start=2026-09-23T06:59Z(calendar) deadline=2026-09-30T06:59Z(calendar) ceiling=4 target=4

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_cursors_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_cursors_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_cursors_journal` has CLEARED (first seen 2026-09-29T07:59:23Z, cleared 2026-09-29T08:04:33Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_cursors_journal` cleared on endolin-garden-ece02cb4.

- `msg-build-daemon-docker-selfhost-3f86adab41ee` — from gardener:build-daemon-docker-selfhost, reply_to `build-daemon-docker-selfhost` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-build-daemon-docker-selfhost-3f86adab41ee.md)

> build-daemon-docker-selfhost HALTED, not built (repeat re-spawn). Two reasons:
> 1. Duplicate: endojs/endo-but-for-bots already has OPEN PRs for this design — [endojs/endo-but-for-bots#694](https://github.com/endojs/endo-but-for-bots/issues/694) (Docker image + authenticated remote gateway, base llm-f7932ed, mergeable, gauntlet poisoned/parked since 07-11) and [endojs/endo-but-for-bots#608](https://github.com/endojs/endo-but-for-bots/issues/608) (Docker self-hosting image, base master-eecc683). A third PR would be a duplicate.
> 2. Direction: you closed [endojs/endo-but-for-bots#134](https://github.com/endojs/endo-but-for-bots/issues/134) on 2026-07-09 saying Docker self-hosting is "headed in another direction" (@endo/gateway + @endo/mcp grown organically with AWS).
> The re-spawn source is journal plan/designs/endo-but-for-bots/daemon-docker-selfhost.md, still `status: Not Started` (M3). Decision needed: (a) mark that record Declined/Superseded and close [endojs/endo-but-for-bots#608](https://github.com/endojs/endo-but-for-bots/issues/608) and [endojs/endo-but-for-bots#694](https://github.com/endojs/endo-but-for-bots/issues/694), or (b) pick one of them to carry forward via "run the gauntlet #N". Until (a), expect this build job to keep recurring.

- `20260901T210951Z-6f6a42` — from gardener:probe-opencode-anthropic, reply_to `probe-opencode-anthropic` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260901T210951Z-6f6a42.md)

> The opencode-anthropic probe is blocked from its paid canary on this host: opencode 1.18.25 is not installed and neither ANTHROPIC_API_KEY nor stored opencode credentials are present. I can implement and verify the refused-key and killed-run paths locally, but real non-censored Anthropic USD cost requires a credential. Please provision an Anthropic API key into the worker environment if available; otherwise I will report that criterion as an observed gap.

- `watchdog-self-heal-garden-mentor` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-self-heal-garden-mentor.md)

> WATCHDOG notice — occurrence #6 (first seen 2026-09-25T20:50:35Z, latest 2026-09-26T00:50:38Z).
> The SAME condition (`self-heal-garden-mentor`) has now been observed 6 times; this is ONE
> coalesced notice that updates in place, not 6 messages. Latest detail:
>
> self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: a60755470134df0e33803cdb0450d853923e87b8 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p a60755470134df0e33803cdb0450d853923e87b8). Diagnosis: This is the entire log — every configured provider was exhausted at the moment mentor ticked: `openai` (codex-endolin subscription at high water), `local` (no ollama unit running on either :11435 or :11434), and `anthropic` (Claude quota at high-water mark). This is a transient/environmental resource-exhaustion condition, not a code defect — the "FATAL" is the correct, deliberate behavior: it leaves markers so the next tick retries once quota/capacity frees up. There's nothing to fix in code; the fleet is simply between providers at this moment (consistent with prior known quota-throttle episodes).
>
> No JOB block — this is transient provider exhaustion (all three configured inference providers were simultaneously unavailable), not a code defect. Mentor's own fallback logic already han

- `20260927T181806Z-2fe2da` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260927T181806Z-2fe2da.md)

> Milestone M3’s top-priority `endo-claude` path is blocked: choose between refreshing [endojs/endo-but-for-bots#1015](https://github.com/endojs/endo-but-for-bots/issues/1015) for preliminary review or answering the four open design questions in #1340 first. That choice determines the confined stdio-MCP shape and its next work job.

- `20260929T083913Z-b50775` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260929T083913Z-b50775.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: build-ironhorse-foreman-woken-press
> - question (msgid msg-build-ironhorse-foreman-woken-press-8b3b965cce7b.md)
> - tentative answer: Proxy/tentative (maintainer may revise). Go with your proposed 6-hour press interval — it matches the cadence other review-arc presses already run on, and lands with the arc disabled from promotion, so there's no live-quota risk yet.
>
> For the rolling per-arc budget: given the fleet's recent history of quota self-throttles and outages (weekly-limit exhaustion, budget-pool misconfig), start conservative rather than generous — propose a rolling window equal to 4x the press interval (24h) rather than per-press, so a slow arc can't burn its whole allotment in one engagement: **~750K tokens rolling per 24h window per arc**, refilled continuously (not a hard reset at midnight). Treat the first 2-3 engagements as calibration: log actual consumption per engagement once you seed it, and if real usage lands well under/over 750K/24h, adjust before wider rollout — don't hold the mechanism gated on getting this number exactly right the first time.
>
> Land the mechanism now with promotion disabled as you planned; seed the first engagement only after this window/budget pair is in place, then watch actual spend for a cycle or two before flipping promotion on.

- `msg-ironhorse-test262-ratchet-round3-20260928-a4a854a44c5f` — from gardener:ironhorse-test262-ratchet-round3-20260928, reply_to `ironhorse-test262-ratchet-round3-20260928` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ironhorse-test262-ratchet-round3-20260928-a4a854a44c5f.md)

> The round-3 branch-point sweep at llm 47f6965d88 is nearly complete. Current runner semantics explicitly demote positive tests where both engines abort; the September 4 floor included those as covered. Already 397 historical covered paths are now shared-positive-test-failure, independently of engine regressions. The current runner also exposes thousands of failures formerly called wrong-throw skips. I am fixing actual floor regressions first (Object.getOwnPropertyDescriptor misses lazy intrinsic accessors), preserving the stricter classifier. A literal zero-lost comparison to the historical floor may require an explicitly documented policy reconciliation; I will report exact lost paths and reasons rather than relabeling failures as covered.

- `20260928T174815Z-192b50` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T174815Z-192b50.md)

> M2’s next unblocked step is advancing the CI-green draft `endojs/endo-but-for-bots#1349` for `hardened-text-codecs-shim`. Decide whether to authorize `run the gauntlet #1349`; the manual gauntlet trigger is required before fleet work can proceed.

- `20260927T184412Z-988223` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260927T184412Z-988223.md)

> M3’s next critical path is blocked on approval of the draft `endojs/endo-but-for-bots#1015` confinement core and its production-validation direction; decide whether to promote it and the dependent `#1102` agent-capability design so the next build can proceed.

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-1.md)

> WATCHDOG notice — occurrence #7 (first seen 2026-09-09T20:50:24Z, latest 2026-09-28T17:11:50Z).
> The SAME condition (`budget-level-cleric-endolin-garden2-5bcdff64-1`) has now been observed 7 times; this is ONE
> coalesced notice that updates in place, not 7 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 cleric workers 0 -> 1 (target 1): shared codex subscription demand active=0 queue=0 quota=ok fleet-envelope=5 target=1

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-1.md)

> WATCHDOG notice — occurrence #13 (first seen 2026-09-18T05:51:21Z, latest 2026-09-29T05:05:16Z).
> The SAME condition (`budget-level-monk-endolin-garden-ece02cb4-1`) has now been observed 13 times; this is ONE
> coalesced notice that updates in place, not 13 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 monk workers 2 -> 1 (target 1): subscription claude-endolin1 spend=101346486 cap=143000000 pace-bias=0.166539 window-start=2026-09-26T03:00Z(calendar) deadline=2026-09-30T03:00Z(planned) ceiling=4 target=1

- `watchdog-budget-level-monk-endolin-garden2-5bcdff64-3` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden2-5bcdff64-3.md)

> WATCHDOG notice — occurrence #3 (first seen 2026-09-22T22:21:43Z, latest 2026-09-29T01:05:40Z).
> The SAME condition (`budget-level-monk-endolin-garden2-5bcdff64-3`) has now been observed 3 times; this is ONE
> coalesced notice that updates in place, not 3 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 monk workers 2 -> 3 (target 3): subscription claude-endolin2 spend=28645777 cap=64000000 pace-bias=0.672750 window-start=2026-09-26T03:00Z(calendar) deadline=2026-09-30T03:00Z(planned) ceiling=4 target=3

- `watchdog-budget-zone-endolin-garden2-5bcdff64-ok` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden2-5bcdff64-ok.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-01T18:30:59Z, latest 2026-09-28T06:46:47Z).
> The SAME condition (`budget-zone-endolin-garden2-5bcdff64-ok`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> subscription codex-endolin changed zone backoff -> ok at spend=12227218 of cap=100.

- `20260928T165334Z-24393e` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T165334Z-24393e.md)

> Milestone M2 is blocked: draft [endojs/endo-but-for-bots#1356](https://github.com/endojs/endo-but-for-bots/issues/1356) is superseded by merged upstream work and needs your decision to close it, while #1349 needs an explicit gauntlet authorization and a decision whether its remaining Phase 3 audit is required.

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.

- `npm-minion-town-dev-registry-orch-terminal-complete` — from orchestrator:npm-minion-town-dev-registry-orch-terminal-complete, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/npm-minion-town-dev-registry-orch-terminal-complete.md)

> orchestration-event: orchestration-terminal
> orchestration: npm-minion-town-dev-registry-orch
> orchestration-status: complete
> order: serial
> children-total: 3
> children-failed: 0
> failed-children: 
> recovered-children: 
>
> Orchestration npm-minion-town-dev-registry-orch complete (serial): all 3 children reached tada without a machine-readable failure declaration.

- `20260928T165826Z-f6e246` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T165826Z-f6e246.md)

> Milestone M2 is blocked on disposition of the two draft PRs: authorize running the gauntlet for [endojs/endo-but-for-bots#1349](https://github.com/endojs/endo-but-for-bots/issues/1349), and close [endojs/endo-but-for-bots#1356](https://github.com/endojs/endo-but-for-bots/issues/1356) as superseded by upstream [endojs/endo#3332](https://github.com/endojs/endo/issues/3332).

- `watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-09-29T03:14:02Z, cleared 2026-09-29T06:38:10Z).
> It was observed 47 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> canary oros-studio-garden-ce242c49 is no longer stuck (release 18df481c04b5aca0fec1f93ebdf8a0393b69544f, deployed e036bb8e0650b66a4ae00dc1516c4c8df39901ca).

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-0` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-0.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-28T08:11:48Z, latest 2026-09-29T09:35:26Z).
> The SAME condition (`budget-level-cleric-endolin-garden-ece02cb4-0`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 cleric workers 1 -> 0 (target 0): shared codex subscription demand active=0 queue=1 quota=ok fleet-envelope=0 target=0


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 120.6M | $879.05 _(notional, rate-card)_ | 84% of 143.0M (backoff) |
| Codex | 14.6M _(fleet aggregate)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 38% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 58688604 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 5.408336s/45s (/home/kris/garden/.garden-state/design-pr-gauntlet-audit/journal); 0 open notice(s); checker healthy

## Board
### todo (6)
- [`endojs-endo-but-for-bots-pr1072-retcon-pre-gauntlet-summary-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1072-retcon-pre-gauntlet-summary-20260929.md) — post the pre-gauntlet retcon summary comment on endojs/endo-but-for-bots PR #...
- [`dependabotany-recheck-endo-but-for-bots-20260928-012250`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/dependabotany-recheck-endo-but-for-bots-20260928-012250.md) — ---
- [`canary-probe-endolin-garden2-5bcdff64-9bf25f4362f9-r1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/canary-probe-endolin-garden2-5bcdff64-9bf25f4362f9-r1.md) — rolling-deploy canary probe for endolin-garden2-5bcdff64 @ 9bf25f4362f9
- [`endojs-endo-but-for-bots-pr1018-followups-reply-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1018-followups-reply-20260929.md) — Post the follow-up plan reply on endojs/endo-but-for-bots PR #1018
- [`ebfb-exo-stream-pr1100-gauntlet-20260923-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-exo-stream-pr1100-gauntlet-20260923-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1100
- [`endojs-endo-but-for-bots-pr1072-resume-gauntlet-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1072-resume-gauntlet-20260929.md) — resume PR #1072's halted gauntlet and stage its post-gauntlet retcon

### doin (4)
- [`endojs-endo-but-for-bots-pr1362-gauntlet-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1362-gauntlet-fix-5.md) — Gauntlet stage: FIX round 5 — endojs/endo-but-for-bots PR #1362
- [`endojs-endo-but-for-bots-pr1343-unify-endowments`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1343-unify-endowments.md) — ---
- [`endojs-endo-but-for-bots-ironhorse-panic-classification-lint`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-ironhorse-panic-classification-lint.md) — Classification-discipline lint for Halt matching
- [`endojs-endo-but-for-bots-pr1097-weave-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1097-weave-20260929.md) — Weave endojs/endo-but-for-bots PR #1097 (advance the base pin)

### tada (9626)
- [`build-daemon-docker-selfhost`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/29/build-daemon-docker-selfhost.md) — build-daemon-docker-selfhost: stopped without building
- [`improve-receipt-watcher-startup-stragglers`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/29/improve-receipt-watcher-startup-stragglers.md) — Cost
- [`endojs-endo-but-for-bots-ironhorse-panic-e2e-probe-addendum`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/29/endojs-endo-but-for-bots-ironhorse-panic-e2e-probe-addendum.md) — Cost
- [`build-endo-claude-confined-stdio-mcp-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/29/build-endo-claude-confined-stdio-mcp-20260929.md) — Cost
- [`endojs-endo-but-for-bots-ironhorse-panic-e2e-probe`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/29/endojs-endo-but-for-bots-ironhorse-panic-e2e-probe.md) — Cost
- … and 9621 more

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
- [`endo-sturdyref-enliven-design`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-sturdyref-enliven-design.md) — _normal_ · ---
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
- [`ironhorse-test262-ratchet-round3-floor-resolution-20260928`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-test262-ratchet-round3-floor-resolution-20260928.md) - [Reconcile the historical floor with current verdict/resource policy, or restore all 901 genuinely under unchanged pins and policy?](https://github.com/kriscendobot/garden/issues/51#issuecomment-5877917421)
- [`kriscendobot-minion-town-pr130-conduct-prod-validate-20260928-resume`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr130-conduct-prod-validate-20260928-resume.md) - [Approve https://github.com/kriscendobot/minion.town/pull/130 so the conductor can merge it and finish PR 117 production validation](https://github.com/kriscendobot/minion.town/pull/130)
- [`minion-town-pr87-production-gate-resume-20260922`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-pr87-production-gate-resume-20260922.md) - [PR #87 production-reality gate: which backend is the production provider (CLI/Agent-SDK; re-run failed SDK track first?), proceed before endo#1015 lands or gate on it, and what counts as production evidence + are credentials provided?](https://github.com/kriscendobot/minion.town/pull/87#issuecomment-5770203120)
- [`ironhorse-computron-benchmark-baseline-build-after-approval`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-computron-benchmark-baseline-build-after-approval.md) - [Will the maintainer lift the Ironhorse pause, approve design PR #1283 (or direct an early build), and answer its six open questions (or direct the recommended defaults)?](https://github.com/endojs/endo-but-for-bots/pull/1283)

### deferred (top by priority; foreman auto-promotes when idle)
- [`design-hardened-ses-shim-status-reconciliation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-hardened-ses-shim-status-reconciliation.md) — _normal_ · ---
- [`design-hardened-ses-shims-plan-reconciliation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-hardened-ses-shims-plan-reconciliation.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1015-refresh-for-review-20260919`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1015-refresh-for-review-20260919.md) — _normal_ · Refresh the @endo/claude confinement-core build (endojs/endo-but-for-bots#101...
- [`endojs-endo-but-for-bots-pr1125-23cf90c0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-23cf90c0-retro.md) — _normal_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1125-review-a74698d6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1125-review-a74698d6-retro.md) — _normal_ · Retrospective on endojs/endo-but-for-bots PR #1125 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1226-review-179ff5ab-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1226-review-179ff5ab-retro.md) — _normal_ · Retrospective on endojs/endo-but-for-bots PR #1226 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1286-receipt`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1286-receipt.md) — _normal_ · receipt (auto) — completion receipt for endojs/endo-but-for-bots PR #1286 (me...
- [`endojs-endo-but-for-bots-pr1286-review-cc7d78b9`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1286-review-cc7d78b9.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #1286
- [`endojs-endo-but-for-bots-pr1289-review-f5a08880-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1289-review-f5a08880-retro.md) — _normal_ · Retrospective on endojs/endo-but-for-bots PR #1289 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1293-receipt`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1293-receipt.md) — _normal_ · receipt (auto) — completion receipt for endojs/endo-but-for-bots PR #1293 (cl...
- [`endojs-endo-but-for-bots-pr1301-review-3220af4b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1301-review-3220af4b-retro.md) — _normal_ · Retrospective on endojs/endo-but-for-bots PR #1301 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1305-review-254277ce-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1305-review-254277ce-retro.md) — _normal_ · Retrospective on endojs/endo-but-for-bots PR #1305 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1309-conduct-20260921`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1309-conduct-20260921.md) — _normal_ · Finalize (curate → merge) endojs/endo-but-for-bots PR #1309
- [`endojs-endo-but-for-bots-pr1310-c9dfce07-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1310-c9dfce07-retro.md) — _normal_ · Retrospective on endojs/endo-but-for-bots PR #1310 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1317-dependabot`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1317-dependabot.md) — _normal_ · botanist (auto: dependabot PR) on endojs/endo-but-for-bots PR #1317
- [`endojs-endo-but-for-bots-pr1345-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1345-conduct.md) — _normal_ · Finalize (curate -> merge) endojs/endo-but-for-bots PR #1345
- [`endojs-endo-but-for-bots-pr1349-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1349-gauntlet-viability.md) — _normal_ · Gauntlet stage: PRE-SPEND VIABILITY - endojs/endo-but-for-bots PR #1349
- [`endojs-endo-but-for-bots-pr1351-dependabot`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1351-dependabot.md) — _normal_ · botanist (auto: dependabot PR, INCOMPATIBLE by preflight) on endojs/endo-but-...
- [`endojs-endo-but-for-bots-pr1353-dependabot`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1353-dependabot.md) — _normal_ · botanist (auto: dependabot PR, INCOMPATIBLE by preflight) on endojs/endo-but-...
- [`endojs-endo-but-for-bots-pr1354-dependabot`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1354-dependabot.md) — _normal_ · botanist (auto: dependabot PR, INCOMPATIBLE by preflight) on endojs/endo-but-...
- [`endojs-endo-but-for-bots-pr356-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr356-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #356
- [`endojs-endo-but-for-bots-pr450-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr450-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #450
- [`endojs-endo-but-for-bots-pr982-0b4f9f5d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr982-0b4f9f5d-retro.md) — _normal_ · Retrospective on endojs/endo-but-for-bots PR #982 (primary: endojs-endo-but-f...
- [`fix-endojs-endo-but-for-bots-pr1356-zizmor`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-endojs-endo-but-for-bots-pr1356-zizmor.md) — _normal_ · ---
- [`fix-endojs-endo-but-for-bots-pr610`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-endojs-endo-but-for-bots-pr610.md) — _normal_ · ---
- [`fix-subscription-model-deploy-gate-regression`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-subscription-model-deploy-gate-regression.md) — _normal_ · Fix deploy-gate regression from subscription-based-budget-model
- [`garden-build-follower-self-deploy`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-build-follower-self-deploy.md) — _normal_ · Implement — the design's recommended path
- [`harness-provider-matrix-handoff-20260901`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/harness-provider-matrix-handoff-20260901.md) — _normal_ · Hand-off: harness × inference-provider matrix, and what to probe next
- [`kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T215136Z`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T215136Z.md) — _normal_ · Post-deploy interactive validation and maintainer report for garden PR #81
- [`kriscendobot-minion-town-pr68-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr68-gauntlet-panel-6.md) — _normal_ · Gauntlet stage: PANEL round 6 — kriscendobot/minion.town PR #68
- [`kriscendobot-minion.town-pr81-review-ef599fde-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr81-review-ef599fde-retro.md) — _normal_ · Retrospective on kriscendobot/minion.town PR #81 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr96-review-4b828bd6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr96-review-4b828bd6-retro.md) — _normal_ · Retrospective on kriscendobot/minion.town PR #96 (primary: kriscendobot-minio...
- [`kriscendobot-oros-ckm-data-readiness-pr1-receipt`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-oros-ckm-data-readiness-pr1-receipt.md) — _normal_ · receipt (auto) — completion receipt for kriscendobot/oros-ckm-data-readiness ...
- [`oros-ckm-dependabot-audit-0013418`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-ckm-dependabot-audit-0013418.md) — _normal_ · ---
- [`retire-gardener-worker-kind-alias`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/retire-gardener-worker-kind-alias.md) — _normal_ · ---
- [`review-improve-cross-platform-test-coverage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/review-improve-cross-platform-test-coverage.md) — _normal_ · review-improve-cross-platform-test-coverage
- [`review-improve-pr-description-reviewer-attention`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/review-improve-pr-description-reviewer-attention.md) — _normal_ · review-improve-pr-description-reviewer-attention
- [`run-the-gauntlet-minion-town-pr90`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/run-the-gauntlet-minion-town-pr90.md) — _normal_ · ---
- [`self-heal-fix-garden-issue-inbox-cursor-get-failopen`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/self-heal-fix-garden-issue-inbox-cursor-get-failopen.md) — _normal_ · ---
- [`self-heal-fix-garden-issue-inbox-cursor-get-pipefail`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/self-heal-fix-garden-issue-inbox-cursor-get-pipefail.md) — _normal_ · ---
- [`minion-town-press-20260929-092304`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-press-20260929-092304.md) — _normal_ · Press the minion.town arc forward (foreman-paced, self-re-parking)
- [`endojs-endo-but-for-bots-pr1015-review-c762ae64-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1015-review-c762ae64-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1015 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1072-31cfbab3-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1072-31cfbab3-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1072 (primary: endojs-endo-but-...
- [`kriscendobot-minion.town-pr120-75934ef0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr120-75934ef0-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #120 (primary: kriscendobot-mini...
- [`endojs-endo-but-for-bots-pr1018-e1ff4501-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1018-e1ff4501-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1018 (primary: endojs-endo-but-...
- [`kriscendobot-minion.town-pr120-review-f4e33453-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr120-review-f4e33453-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #120 (primary: kriscendobot-mini...
- [`endojs-endo-but-for-bots-pr1097-review-c2702a77-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1097-review-c2702a77-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1097 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1357-review-b33b9342-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1357-review-b33b9342-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1357 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1102-faed8ca7-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1102-faed8ca7-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1102 (primary: endojs-endo-but-...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`endo-minion-town-federation-release-gate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-minion-town-federation-release-gate.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1124` · Gate: reviewed and deployable federation release
- [`npm-minion-town-dev-registry-postgauntlet-pr1362`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/npm-minion-town-dev-registry-postgauntlet-pr1362.md) — awaiting `endojs-endo-but-for-bots-pr1362-gauntlet` · npm.minion.town dev-registry campaign — post-gauntlet notice for PR #1362
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1019` · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`npm-minion-town-dev-registry-merge-pr135`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/npm-minion-town-dev-registry-merge-pr135.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/135` · npm.minion.town dev-registry campaign — merge notice for PR #135
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`activate-ironhorse-ratchet-autopilot-20260929-r4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/activate-ironhorse-ratchet-autopilot-20260929-r4.md) — awaiting `ironhorse-ratchet-r4-timer-20260929` · Finish activation of the authorized Ironhorse ratchet autopilot (continued, r...
- [`build-exo-sheets-service`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-sheets-service.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`ironhorse-fuzz-triage-differential_source-efffacee3e2a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-triage-differential_source-efffacee3e2a.md) — awaiting `https://github.com/kriscendobot/garden/issues/91` · Triage 7 Ironhorse fuzz finding(s) for target differential_source

## Watch set
kriscendobot-minion.town kriscendobot-cosgov kriscendobot-ocapn kriscendobot-oros-ckm-data-readiness kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot

## Hosts
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 1 monks
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 1 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 4 monks
