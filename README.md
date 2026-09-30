# Garden bulletin

_As of 2026-09-30T01:03:30Z_

## Latest

Quota pressure dominates the picture right now: Claude spend sits at 122% of the claude-endolin1 cap (backoff), and the leader host (endolin-garden-ece02cb4) is running 25 commits stale on a stalled deliberate deploy — while stale it's not honoring any directive newer than its deployed sha, and a candidate commit (39d0c5ef0aca) was already rejected by the test gate on a `triager-pacing-test.sh` failure, so that needs a look before the next deploy attempt. Milestone M2 remains stuck on manual gauntlet authorization for [endo-but-for-bots#1349](https://github.com/endojs/endo-but-for-bots/pull/1349) (hardened-text codecs smoke check) and a decision on closing #1356 as superseded by upstream [endo#3332](https://github.com/endojs/endo/pull/3332); M3's confined-agent work is similarly blocked pending a call on #1015/#1348 or answering the four open questions on design PR #1340. The IronHorse test262 ratchet (round 3) needs a floor-reconciliation decision — hundreds of historical "covered" paths are now correctly reclassified as failures under a stricter (and more honest) classifier, and the gardener is asking whether to record an explicitly reconciled floor rather than relabel anything. Elsewhere, a serial orchestration (`retire-gardener-worker-kind-alias-split`) halted on a child timeout, and the minion.town MCP rollout is proven live on garden2 but paused pending a decision on a dedicated principal/guest (rather than reusing production's `minion-mcp-test-cc`) and on context-cost scoping for jurors.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#1282](https://github.com/endojs/endo-but-for-bots/pull/1282) — chore(ironhorse): demolish the XS-computron-parity myth (waiting 3d)
- [endojs/endo-but-for-bots#1281](https://github.com/endojs/endo-but-for-bots/pull/1281) — fix(ses): silence lockdown intrinsics report for the WHATWG URL family (waiting 12d)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 18d)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 26d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 28d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 28d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 28d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 28d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 29d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 31d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260928T173257Z-02c8de` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T173257Z-02c8de.md)

> M2’s next advance is draft [endojs/endo-but-for-bots#1349](https://github.com/endojs/endo-but-for-bots/issues/1349); decide whether its remaining llm downstream audit is required, then explicitly authorize `run the gauntlet #1349`.

- `watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-host-offline-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-09-29T21:17:11Z, cleared 2026-09-30T01:02:03Z).
> It was observed 19 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> heartbeat resumed for oros-studio-garden-ce242c49; it is PRESENT again and will automatically rejoin the canary rotation while its hosts/oros-studio-garden-ce242c49 record remains active. Archived records are not unarchived automatically.

- `msg-ironhorse-test262-ratchet-round3-20260928-0d0c921abeb6` — from gardener:ironhorse-test262-ratchet-round3-20260928, reply_to `ironhorse-test262-ratchet-round3-20260928` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ironhorse-test262-ratchet-round3-20260928-0d0c921abeb6.md)

> Decision needed for round 3: the completed current-llm sweep has 906 lost paths against the historical floor BEFORE my changes: 443 engine-limit aborts, 397 shared-positive-test-failure, 66 other. Several hundred historical covered cases were false positives under the old classifier; I will not mark them covered or weaken the current classifier. May the draft record an explicitly reconciled current-llm floor (36,599 covered) and defend zero loss against that, retaining all 906 historical dispositions for follow-up? Otherwise this round's literal superseding-floor acceptance cannot be honestly met in one constants-descriptor crank. The proposed fix already has 5 red-before/green-after dual-run tests and repairs Math/Number/TypedArray numeric constant attributes; full Rust gates and an after sweep are next.

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

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_maintainer_approval_verify` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_maintainer_approval_verify.md)

> Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/maintainer-approval/verify: packs 1001 >= 1000; size=258482176B packs=1001 gc.log=0; automatic remedy=deferred-deadline.

- `20260929T034336Z-473eb2` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260929T034336Z-473eb2.md)

> awaiting maintainer — beyond proxy authority: gardener activate-ironhorse-ratchet-autopilot-20260929-r3, msgid msg-activate-ironhorse-ratchet-autopilot-20260929-r3-35b22755c4d2.md — Requires maintainer action: hands-on-host diagnosis (journalctl on oros-studio) or a sysop `deploy` op, which mandates maintainer attestation (`authorized_by:` on `maintainers/allowlist`) — squarely outside proxy authority.

- `endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-halted` — from gauntlet:endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-halted.md)

> Gauntlet endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet HALTED: stage 'endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-clean' (clean) failed 1 times and was doom-parked with doom_signature=requeue-exhausted. It was NOT retried because the record does not prove the underlying handler failure was transient (failure_classification=unknown); repeating an unknown failure would waste the stage budget.

- `watchdog-budget-zone-endolin-garden-ece02cb4-ok` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden-ece02cb4-ok.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-08-27T01:30:12Z, latest 2026-09-28T06:45:37Z).
> The SAME condition (`budget-zone-endolin-garden-ece02cb4-ok`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> subscription codex-endolin changed zone backoff -> ok at spend=48768757 of cap=100.

- `20260929T131950Z-276daa` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260929T131950Z-276daa.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: activate-ironhorse-ratchet-autopilot-20260929-r4
> - question (msgid msg-activate-ironhorse-ratchet-autopilot-20260929-r4-8e94bede58af.md)
> - tentative answer: Proxy/tentative (maintainer may revise): diagnosis and fix look right — go ahead and let the roll proceed on 25123fdae03, no need to wait for me on that part. Deferring the arc-budget press seed until after the leader deploys is the right call given no cap reply yet on [kriscendobot/garden#51](https://github.com/kriscendobot/garden/issues/51). On oros-studio-garden-ce242c49: I can't act on a genuinely offline host from here, so leave it flagged for the maintainer's own follow-up — don't block the roll on it (correct that it should keep skipping that host). Continue as planned.

- `retire-gardener-worker-kind-alias-split-halted` — from orchestrator:retire-gardener-worker-kind-alias-split-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/retire-gardener-worker-kind-alias-split-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: retire-gardener-worker-kind-alias-split
> orchestration-status: halted
> child: retire-gardener-worker-kind-alias-env-fallback
> failure-kind: handler-timeout
> children-completed: 0
> children-total: 2
> halt-parked-remainder: retire-gardener-worker-kind-alias-verify-docs
>
> Orchestration retire-gardener-worker-kind-alias-split HALTED: child retire-gardener-worker-kind-alias-env-fallback stalled in flight for 2517s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1) (serial, on-child-failure=halt). 0/2 done before halt; parked remainder: retire-gardener-worker-kind-alias-verify-docs

- `20260928T012322Z-a069e5` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T012322Z-a069e5.md)

> M2’s remaining records are draft PRs: reconcile hardened-url-shim via [endojs/endo-but-for-bots#1355](https://github.com/endojs/endo-but-for-bots/issues/1355) and complete the XS smoke coverage via #1349. Please decide whether to run the gauntlet on these drafts; no autonomous work job can advance the manual-review gate.

- `20260928T172319Z-a6992a` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T172319Z-a6992a.md)

> M2 is blocked at draft PR [endojs/endo-but-for-bots#1349](https://github.com/endojs/endo-but-for-bots/issues/1349), the hardened TextEncoder/TextDecoder XS smoke check. Decide whether to run the gauntlet for #1349; no other M2 work remains unblocked.

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-2.md)

> WATCHDOG notice — occurrence #3 (first seen 2026-09-17T00:05:35Z, latest 2026-09-27T12:35:28Z).
> The SAME condition (`budget-level-cleric-endolin-garden2-5bcdff64-2`) has now been observed 3 times; this is ONE
> coalesced notice that updates in place, not 3 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 cleric workers 1 -> 2 (target 2): shared codex subscription demand active=2 queue=6 quota=ok fleet-envelope=5 target=2

- `watchdog-root-repo-deploy-stalled-oros-studio-garden-ce242c49` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-oros-studio-garden-ce242c49.md)

> root repo /Users/dom/garden deploy has been STALLED for ~1d: deployed sha e036bb8e0650b66a4ae00dc1516c4c8df39901ca is 38 commit(s) behind origin/main2 (e17a717171db2d710312422b1825ac2813019307) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=oros-studio-garden-ce242c49)

- `watchdog-budget-level-monk-endolin-garden2-5bcdff64-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden2-5bcdff64-2.md)

> WATCHDOG notice — occurrence #17 (first seen 2026-09-12T03:20:21Z, latest 2026-09-29T22:35:22Z).
> The SAME condition (`budget-level-monk-endolin-garden2-5bcdff64-2`) has now been observed 17 times; this is ONE
> coalesced notice that updates in place, not 17 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 monk workers 1 -> 2 (target 2): subscription claude-endolin2 spend=58631878 cap=64000000 pace-bias=0.193348 window-start=2026-09-26T03:00Z(calendar) deadline=2026-09-30T03:00Z(planned) ceiling=4 target=2

- `watchdog-budget-zone-endolin-garden-ece02cb4-backoff` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden-ece02cb4-backoff.md)

> subscription codex-endolin changed zone ok -> backoff at spend=41944294 of cap=100.

- `watchdog-budget-zone-endolin-garden2-5bcdff64-backoff` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden2-5bcdff64-backoff.md)

> subscription codex-endolin changed zone ok -> backoff at spend=11420683 of cap=100.

- `20260929T162945Z-aef3a3` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260929T162945Z-aef3a3.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: activate-ironhorse-ratchet-autopilot-20260929-r4
> - question (msgid msg-activate-ironhorse-ratchet-autopilot-20260929-r4-6c7e0f95aff8.md)
> - tentative answer: Proxy/tentative: Thanks for the update — no gating decision needed here, this reads as a status report. The plan sounds right: let r4 end now so the leader's single monk frees up for deploy-garden.sh, and let the one-time schedule (activate-ironhorse-ratchet-autopilot-20260929-r5, firing 17:15Z) pick up verifying the deployed gates, seeding the first press, and reporting on [kriscendobot/garden#51](https://github.com/kriscendobot/garden/issues/51). Good call building in the self-reschedule if the leader still hasn't deployed by then rather than blocking. Retiring the legacy ironhorse-ratchet schedule in favor of this one is fine to proceed with. No action needed from me — proceed as planned; the maintainer can revise if they see this differently.

- `20260927T190020Z-7b30f4` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260927T190020Z-7b30f4.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: build-daemon-agent-tools
> - question (msgid msg-build-daemon-agent-tools-ab6ed31c15ed.md)
> - tentative answer: proxy/tentative — go with **Option A**: target a frozen `llm` base (matching how this stack has landed all along — [endojs/endo-but-for-bots#614](https://github.com/endojs/endo-but-for-bots/issues/614), [endojs/endo-but-for-bots#615](https://github.com/endojs/endo-but-for-bots/issues/615), [endojs/endo-but-for-bots#616](https://github.com/endojs/endo-but-for-bots/issues/616), [endojs/endo-but-for-bots#661](https://github.com/endojs/endo-but-for-bots/issues/661), [endojs/endo-but-for-bots#705](https://github.com/endojs/endo-but-for-bots/issues/705), and [endojs/endo-but-for-bots#707](https://github.com/endojs/endo-but-for-bots/issues/707) all live there, not on `master`) and integrate an explicit harness that composes shell+remote without relying on [endojs/endo-but-for-bots#707](https://github.com/endojs/endo-but-for-bots/issues/707)'s ambiguous `inspect`-collision `makeWorkspaceTools`, and without resurrecting the dynamic-discovery approach [endojs/endo-but-for-bots#618](https://github.com/endojs/endo-but-for-bots/issues/618) was closed over for capability-leak reasons — pick names/an explicit registration surface instead. Option B (porting the entire transitive capability stack to `master`) is a much bigger, separate undertaking that doesn't belong inside this one build job's scope; if a `master` port is ever wanted, that should be its own job/design, not folded into "build daemon agent tools." Keep building toward the draft PR on `llm` per your current plan — this is provisional and the maintainer may revise it when they're back.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_leader_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_leader_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_leader_journal` has CLEARED (first seen 2026-09-29T23:55:58Z, cleared 2026-09-30T00:16:06Z).
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

- `20260927T184844Z-fb282f` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260927T184844Z-fb282f.md)

> M2’s remaining design records are substantively complete upstream, while the clean, reviewed documentation PR [endojs/endo-but-for-bots#756](https://github.com/endojs/endo-but-for-bots/issues/756) remains open. Decide whether to merge that PR and reconcile the two M2 design statuses to Complete.

- `watchdog-worker-derotate-oros-studio-garden-ce242c49` — from watchdog:worker-derotate, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-worker-derotate-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `worker-derotate-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-09-29T22:20:09Z, cleared 2026-09-29T23:05:10Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> heartbeat resumed for oros-studio-garden-ce242c49 (heartbeat fresh (782s old; sampled_at_epoch=1790722322)); it is PRESENT again and its config/worker-leveling caps are restored to 4 0 (monk cleric), so budget-level will apportion it workers again. (leader=endolin-garden-ece02cb4)

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-0` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-0.md)

> WATCHDOG notice — occurrence #4 (first seen 2026-09-13T14:20:13Z, latest 2026-09-29T01:20:18Z).
> The SAME condition (`budget-level-cleric-endolin-garden2-5bcdff64-0`) has now been observed 4 times; this is ONE
> coalesced notice that updates in place, not 4 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 cleric workers 1 -> 0 (target 0): shared codex subscription demand active=0 queue=1 quota=ok fleet-envelope=1 target=0

- `watchdog-comment-watcher-stuck-cooldown-host` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-watcher-stuck-cooldown-host.md)

> RECOVERED — the watchdog condition `comment-watcher-stuck-cooldown-host` has CLEARED (first seen 2026-09-29T22:35:40Z, cleared 2026-09-29T22:40:40Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Comment acknowledgment condition cleared.

- `watchdog-budget-level-monk-endolin-garden2-5bcdff64-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden2-5bcdff64-1.md)

> WATCHDOG notice — occurrence #14 (first seen 2026-09-26T03:06:05Z, latest 2026-09-29T23:35:21Z).
> The SAME condition (`budget-level-monk-endolin-garden2-5bcdff64-1`) has now been observed 14 times; this is ONE
> coalesced notice that updates in place, not 14 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 monk workers 2 -> 1 (target 1): subscription claude-endolin2 spend=59963201 cap=64000000 pace-bias=0.148201 window-start=2026-09-26T03:00Z(calendar) deadline=2026-09-30T03:00Z(planned) ceiling=4 target=1

- `watchdog-journal-contention-watch-overrun` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-watch-overrun.md)

> RECOVERED — the watchdog condition `journal-contention-watch-overrun` has CLEARED (first seen 2026-09-29T21:30:46Z, cleared 2026-09-30T00:21:34Z).
> It was observed 4 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-contention-watch-overrun` cleared on endolin-garden-ece02cb4.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-4` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-4.md)

> budget-level changed endolin-garden-ece02cb4 cleric workers 3 -> 4 (target 4): shared codex subscription demand active=2 queue=3 quota=ok fleet-envelope=5 target=4

- `watchdog-journal-push-contention-_home_kris_garden2__garden_state_producer_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-push-contention-_home_kris_garden2__garden_state_producer_journal.md)

> RECOVERED — the watchdog condition `journal-push-contention-_home_kris_garden2__garden_state_producer_journal` has CLEARED (first seen 2026-09-29T15:01:16Z, cleared 2026-09-29T21:02:01Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-push-contention-_home_kris_garden2__garden_state_producer_journal` cleared on endolin-garden2-5bcdff64.

- `watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-canary-failed-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-09-29T06:14:06Z, cleared 2026-09-29T21:14:08Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> retrying canary oros-studio-garden-ce242c49 (attempt 1/3); clearing prior page.

- `watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4.md)

> root repo /home/kris/garden deploy has been STALLED for ~0d / 25 commits behind (leader commits-fuse 25): deployed sha e036bb8e0650b66a4ae00dc1516c4c8df39901ca is 25 commit(s) behind origin/main2 (9bf25f4362f9638313fdd55875bd218b11557d47) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. This host is the LEADER: it runs every singleton producer (foreman, scheduler, watchers), so while it is stale it is NOT honoring any directive newer than its deployed sha — a PROJECT PAUSE among them. This is the shape that let a stale leader run ~60 IronHorse fuzz jobs a week after the 09-09 pause (designs/project-pause-enforcement.md). DEPLOY IT. (host=endolin-garden-ece02cb4)

- `20260928T172814Z-aab24c` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T172814Z-aab24c.md)

> Milestone M2 is blocked on its two green draft PRs: decide whether the hardened-text Phase 3 `llm` audit is required, then authorize gauntlet promotion for #1349 and #1356.

- `watchdog-comment-provenance-gap-endolin-garden-ece02cb4` — from watchdog:comment-provenance, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-provenance-gap-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #8 (first seen 2026-09-29T00:26:19Z, latest 2026-09-29T22:56:03Z).
> The SAME condition (`comment-provenance-gap-endolin-garden-ece02cb4`) has now been observed 8 times; this is ONE
> coalesced notice that updates in place, not 8 messages. Latest detail:
>
> comment-provenance INSTRUMENTATION GAP on host endolin-garden-ece02cb4: a fleet `gh` comment was posted by an LLM-driven caller, but NEITHER GARDEN_JOB_MODEL NOR GARDEN_WORKER_KIND resolved — so the footer named only the host and garden commit (no model/harness/provider). This is the PR #1125 defect. The comment STILL posted (fail-open); nothing is broken. FIX: find the code path posting the comment and export the job facts (GARDEN_JOB_MODEL + GARDEN_WORKER_KIND) before its `gh` call, OR set GARDEN_NO_LLM=1 if it is a deterministic (no-LLM) post.

- `watchdog-journal-push-contention-_home_kris_garden__garden_state_producer_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-push-contention-_home_kris_garden__garden_state_producer_journal.md)

> RECOVERED — the watchdog condition `journal-push-contention-_home_kris_garden__garden_state_producer_journal` has CLEARED (first seen 2026-09-29T14:59:41Z, cleared 2026-09-29T21:01:23Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-push-contention-_home_kris_garden__garden_state_producer_journal` cleared on endolin-garden-ece02cb4.

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

- `watchdog-journal-fetch-slow-_home_kris_garden2__garden_state_monks_1_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_home_kris_garden2__garden_state_monks_1_journal.md)

> Journal fetch anomaly on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/monks/1/journal: p95=34.810447s max=44.144721s; hard guard=31.500000s (70% of 45s cap); remedy=backoff.

- `watchdog-budget-level-monk-oros-studio-garden-ce242c49-4` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-oros-studio-garden-ce242c49-4.md)

> budget-level changed oros-studio-garden-ce242c49 monk workers 3 -> 4 (target 4): subscription claude-oros spend=842330 cap=73000000 pace-bias=1.000000 window-start=2026-09-23T06:59Z(calendar) deadline=2026-09-30T06:59Z(calendar) ceiling=4 target=4

- `watchdog-rolling-deploy-canary-stuck-endolin-garden2-5bcdff64` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-stuck-endolin-garden2-5bcdff64.md)

> Rolling-deploy canary endolin-garden2-5bcdff64 is STUCK: it was released to b3b5fc27e5dd 38 min ago
> but still reports deployed_sha df7a6549e01186822e72bcde51611933d8cae3ed. Check garden-self-deploy on endolin-garden2-5bcdff64
> (journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
> keeps it from advancing. The leader does not advance past an undeployed canary.
> (leader=endolin-garden-ece02cb4)

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

- `retire-gardener-worker-kind-alias-split-child-retire-gardener-worker-kind-alias-env-fallback-failed` — from orchestrator:retire-gardener-worker-kind-alias-split-child-retire-gardener-worker-kind-alias-env-fallback-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/retire-gardener-worker-kind-alias-split-child-retire-gardener-worker-kind-alias-env-fallback-failed.md)

> orchestration-event: orchestration-child-timeout
> orchestration: retire-gardener-worker-kind-alias-split
> orchestration-status: running
> child: retire-gardener-worker-kind-alias-env-fallback
> failure-kind: handler-timeout
> order: serial
> on-child-failure: halt
> detail: stalled in flight for 2517s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1)
>
> Orchestration retire-gardener-worker-kind-alias-split observed child retire-gardener-worker-kind-alias-env-fallback: stalled in flight for 2517s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1).

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

- `watchdog-journal-push-contention-_home_kris_garden__garden_state_bulletin_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-push-contention-_home_kris_garden__garden_state_bulletin_journal.md)

> RECOVERED — the watchdog condition `journal-push-contention-_home_kris_garden__garden_state_bulletin_journal` has CLEARED (first seen 2026-09-29T14:54:42Z, cleared 2026-09-29T21:00:45Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-push-contention-_home_kris_garden__garden_state_bulletin_journal` cleared on endolin-garden-ece02cb4.

- `improve-gh-api-primary-quota-singleflight-split-terminal-complete` — from orchestrator:improve-gh-api-primary-quota-singleflight-split-terminal-complete, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/improve-gh-api-primary-quota-singleflight-split-terminal-complete.md)

> orchestration-event: orchestration-terminal
> orchestration: improve-gh-api-primary-quota-singleflight-split
> orchestration-status: complete
> order: serial
> children-total: 1
> children-failed: 0
> failed-children: 
> recovered-children: 
>
> Orchestration improve-gh-api-primary-quota-singleflight-split complete (serial): all 1 children reached tada without a machine-readable failure declaration.

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.

- `20260928T165826Z-f6e246` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T165826Z-f6e246.md)

> Milestone M2 is blocked on disposition of the two draft PRs: authorize running the gauntlet for [endojs/endo-but-for-bots#1349](https://github.com/endojs/endo-but-for-bots/issues/1349), and close [endojs/endo-but-for-bots#1356](https://github.com/endojs/endo-but-for-bots/issues/1356) as superseded by upstream [endojs/endo#3332](https://github.com/endojs/endo/issues/3332).

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
| Claude | 174.9M | $1157.36 _(notional, rate-card)_ | 122% of 143.0M (backoff) |
| Codex | 15.5M _(fleet aggregate)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 65% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 61867877 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 7.646911s/45s (/home/kris/garden/.garden-state/transcripts/journal); 1 open notice(s); checker healthy

## Board
### todo (5)
- [`improve-deadline-nudge-failure-trace-expanded-window`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/improve-deadline-nudge-failure-trace-expanded-window.md) — improve-deadline-nudge-failure-trace (expanded window)
- [`endojs-endo-but-for-bots-pr1383-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1383-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1383
- [`endojs-endo-but-for-bots-pr1349-gauntlet-restart-20260930`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1349-gauntlet-restart-20260930.md) — ---
- [`endo-daemon-idempotent-start-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endo-daemon-idempotent-start-build.md) — Endo daemon: idempotent start + early single-instance lock (phase 1)
- [`fix-subscription-model-deploy-gate-regression`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/fix-subscription-model-deploy-gate-regression.md) — Fix deploy-gate regression from subscription-based-budget-model

### doin (5)
- [`endojs-endo-but-for-bots-pr1357-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1357-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1357
- [`endojs-endo-but-for-bots-pr1371-live-model-turn`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1371-live-model-turn.md) — Real model turn for endojs/endo-but-for-bots#1371's confined launcher
- [`endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1379
- [`retire-gardener-worker-kind-alias-env-fallback`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/retire-gardener-worker-kind-alias-env-fallback.md) — ---
- [`kriscendobot-minion.town-pr120-75934ef0-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/kriscendobot-minion.town-pr120-75934ef0-retro.md) — Retrospective on kriscendobot/minion.town PR #120 (primary: kriscendobot-mini...

### tada (9803)
- [`claude-on-minion-town-press-20260930-003506`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/claude-on-minion-town-press-20260930-003506.md) — Cost
- [`kriscendobot-minion.town-pr130-review-ba8a9163-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/kriscendobot-minion.town-pr130-review-ba8a9163-retro.md) — Retrospective on minion.town #130 review 5358829715: dismissed as not a revie...
- [`kriscendobot-minion.town-pr139-review-de54e8bb-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/kriscendobot-minion.town-pr139-review-de54e8bb-retro.md) — Cost
- [`endojs-endo-but-for-bots-pr1383-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/endojs-endo-but-for-bots-pr1383-gauntlet-panel-1.md) — Completion report
- [`kriscendobot-minion.town-pr120-review-f4e33453-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/kriscendobot-minion.town-pr120-review-f4e33453-retro.md) — Cost
- … and 9798 more

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
- [`endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1380
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
(none)

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`endo-minion-town-federation-release-gate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-minion-town-federation-release-gate.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1124` · Gate: reviewed and deployable federation release
- [`verify-ironhorse-press-first-engagement-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ironhorse-press-first-engagement-20260929.md) — awaiting `ironhorse-test262-press-20260929-173306` · Verify the first live Ironhorse foreman-press engagement (successor of activa...
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`npm-minion-town-dev-registry-merge-pr1362`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/npm-minion-town-dev-registry-merge-pr1362.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1362` · npm.minion.town dev-registry campaign — merge notice for PR #1362
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1019` · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`npm-minion-town-dev-registry-merge-pr135`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/npm-minion-town-dev-registry-merge-pr135.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/135` · npm.minion.town dev-registry campaign — merge notice for PR #135
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
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
