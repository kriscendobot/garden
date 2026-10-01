# Garden bulletin

_As of 2026-10-01T02:40:09Z_

## Latest

SturdyRef layers 1–8 continue grinding through the fix/panel gauntlet in parallel on [endojs/endo-but-for-bots#774](https://github.com/endojs/endo-but-for-bots/pull/774), [#1392](https://github.com/endojs/endo-but-for-bots/pull/1392), [#1393](https://github.com/endojs/endo-but-for-bots/pull/1393), [#1394](https://github.com/endojs/endo-but-for-bots/pull/1394), [#1396](https://github.com/endojs/endo-but-for-bots/pull/1396), and [#1398](https://github.com/endojs/endo-but-for-bots/pull/1398), but two siblings stalled out: layer 2 ([#1391](https://github.com/endojs/endo-but-for-bots/issues/1391)) halted on a fix-round failure (its one red CI leg looks like an unrelated daemon-teardown flake that needs a credentialed rerun) and layer 7 (the Ironhorse panic-live-handle-reseat gauntlet) also halted on a declined fix. The petname-path-only sweep for [#1390](https://github.com/endojs/endo-but-for-bots/pull/1390) hit its 6-round review budget without converging and is parked for a human merge call, as is the Ironhorse panic-host-call PR; a separate petname-path gauntlet (`ebfb-petname-path-only-sweep-gauntlet`) also exhausted its budget and left follow-up asks (tests, a trimmed PR body) for the maintainer. The `retire-gardener-worker-kind-alias-env-fallback` cleanup landed its main diff, but its verification child timed out and was parked for maintainer promotion. On the ops side, host `oros-studio-garden-ce242c49` has been offline for over an hour, holding the leader's rolling deploy without a canary and draining its worker caps; budget watchers show claude-endolin2 approaching its weekly cap with a hold-vs-reset decision needed by Thursday, and the garden book was republished with two new chapters.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#1282](https://github.com/endojs/endo-but-for-bots/pull/1282) — chore(ironhorse): demolish the XS-computron-parity myth (waiting 4d)
- [endojs/endo-but-for-bots#1281](https://github.com/endojs/endo-but-for-bots/pull/1281) — fix(ses): silence lockdown intrinsics report for the WHATWG URL family (waiting 13d)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 19d)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 27d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 29d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 29d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 29d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 29d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 30d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 32d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Screened by proxy (minion.town)

(delegation not armed)

## Messages to the maintainer

- `watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #42 (first seen 2026-09-30T20:47:15Z, latest 2026-10-01T02:35:01Z).
> The SAME condition (`rolling-deploy-host-offline-oros-studio-garden-ce242c49`) has now been observed 42 times; this is ONE
> coalesced notice that updates in place, not 42 messages. Latest detail:
>
> Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 5590s (offline threshold 1800s; sampled_at_epoch=1790816511).
> The authority is budget/live/<pool>/oros-studio-garden-ce242c49, refreshed periodically; fleet/health/oros-studio-garden-ce242c49 is
> not a heartbeat and was intentionally ignored. Rolling deploy will SKIP this peer:
> no release token, deploy budget, failed-canary count, or halt. Restore the host and
> its heartbeat to rejoin automatically. If hosts/oros-studio-garden-ce242c49 was archived, unarchive it as a
> separate operator decision; this watchdog never reverses decommissioning. (leader=endolin-garden-ece02cb4)

- `watchdog-rolling-deploy-no-canary-endolin-garden-ece02cb4` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-no-canary-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #40 (first seen 2026-09-30T23:36:06Z, latest 2026-10-01T02:38:02Z).
> The SAME condition (`rolling-deploy-no-canary-endolin-garden-ece02cb4`) has now been observed 40 times; this is ONE
> coalesced notice that updates in place, not 40 messages. Latest detail:
>
> Rolling deploy is HOLDING the leader: every configured follower is OFFLINE or
> operator-drained, so there is no canary to validate 750d7c713e99. The leader will
> not advance unvalidated. Restore any offline host until budget/live heartbeats resume,
> or lift an operator drain. An archived host additionally needs a separate operator
> unarchive; this roll never reverses archival. (leader=endolin-garden-ece02cb4, offline=1)

- `msg-book-revise-content-a727eb9546d8` — from gardener:book-revise-content, reply_to `book-revise-content` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-book-revise-content-a727eb9546d8.md)

> Garden book revised and republished: https://dajt26qwtcxayo7bbm5sfokdhosqznrmwm7uahtuyxofbggo5nza.ocap.site/
>
> Title: "The Garden That Tends Code" (subtitle: An agent fleet through its metamorphoses: how it is organized, operated, and paid for, and how it remembers what it has learned).
> New: ch9 (the library: layout, scholar ingestion, library-lookup, researcher, and the context-economy argument) and ch10 (inference tiers reference: tiers, models, worker kinds, role floors, fallback).
> Prior edition kept in build/README.md: https://qxx6onyv2lkrchlytrmh2dos4xndfz5erojrkwfplor65h2ipgrq.ocap.site/

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_maintainer_approval_verify` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_maintainer_approval_verify.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_maintainer_approval_verify` has CLEARED (first seen 2026-10-01T01:28:05Z, cleared 2026-10-01T01:32:36Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_maintainer_approval_verify` cleared on endolin-garden-ece02cb4.

- `endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-halted` — from gauntlet:endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-halted.md)

> Gauntlet endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet HALTED: stage 'endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-6' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `stale-panel-head-endojs-endo-but-for-bots-pr1357-50917af1-1ff1c08e` — from gardener:claude-on-minion-town-press-20260930-215010, reply_to `claude-on-minion-town-press-20260930-215010` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/stale-panel-head-endojs-endo-but-for-bots-pr1357-50917af1-1ff1c08e.md)

> COALESCED message — occurrence #2 (first seen 2026-09-30T20:44:30Z, latest 2026-09-30T21:53:21Z).
> The SAME message (episode key `stale-panel-head-endojs-endo-but-for-bots-pr1357-50917af1-1ff1c08e`) has now been sent 2 times; this is
> ONE entry that updates in place, not 2 messages. Latest detail:
>
> Stale panel coverage for completed job `claude-on-minion-town-press-20260930-215010`: [https://github.com/endojs/endo-but-for-bots/pull/1357](https://github.com/endojs/endo-but-for-bots/pull/1357) moved from panel-reviewed head `50917af1a439419d6ccc5b91ceb11acb0c5bff59` to presented head `1ff1c08e71ecec6717004bb2c7060c360163c1e8`.
>
> Disposition: **review required**. The earlier panel does not cover the current head; every commit delta is conservatively review-relevant. A PR metadata-only edit would leave the head unchanged and would not trigger this disposition.
>
> No gauntlet was staged. Route the current head through the existing panel stage only after an explicit maintainer `run the gauntlet` request, or make a maintainer review decision with the stale coverage stated explicitly.

- `msg-accountant-budget-conversation-20260930-5c94e3563d64` — from gardener:accountant-budget-conversation-20260930, reply_to `accountant-budget-conversation-20260930` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-accountant-budget-conversation-20260930-5c94e3563d64.md)

> Accountant: I got no reply within ~20 min, so the budget conversation is parked as the go-ahead plan `accountant-budget-conversation-20260930-resume`, which carries the full proposal. When you are ready, reply to the opening message or say "go ahead" on that plan, and the accountant will pick the conversation up. Nothing has been applied. Until then, the 2026-09-26 mandate and the current foreman behavior stand.

- `ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-halted` — from gauntlet:ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-halted.md)

> Gauntlet ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet HALTED: stage 'ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean' (clean) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `watchdog-journal-push-contention-_home_kris_garden__garden_state_reaper_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-push-contention-_home_kris_garden__garden_state_reaper_journal.md)

> Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reaper/journal: attempts p95=3.000000 max=3.000000 (cap 50), classes cas=2 server-reject=0 definite-fail=0.

- `gauntlet-followups-ebfb-petname-path-only-sweep-gauntlet-fix-4` — from gardener:ebfb-petname-path-only-sweep-gauntlet-fix-4, reply_to `ebfb-petname-path-only-sweep-gauntlet-fix-4` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/gauntlet-followups-ebfb-petname-path-only-sweep-gauntlet-fix-4.md)

> Gauntlet stage "ebfb-petname-path-only-sweep-gauntlet-fix-4" ("ebfb-petname-path-only-sweep-gauntlet", stage "fix") completed and reported additional follow-ups that require maintainer disposition. The deterministic gauntlet driver owns only the next-panel transition; this escalation was forwarded before the child completed.
>
> ## Follow-ups
> - **corner-prober:** a refusal test for `lal/tool-dispatch.js`, and making the `search-tools.test.js` stub strict.
> - **fast-checker:** property tests for `namePathFrom` and `toPetNamePath`.
> - **scribe:** a summary comment covering commits `ab42d2de95` and `09350117e6`.
> - **PR-body probe:** trim the body from 343 words to under 300.

- `doomed-retire-gardener-clone-alias-verify-deploy-reaper-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-retire-gardener-clone-alias-verify-deploy-reaper-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/retire-gardener-clone-alias-verify-deploy-reaper; it stays HELD until a human promotes it
> (promote-plan.sh retire-gardener-clone-alias-verify-deploy-reaper) or removes it, so nothing is lost.
> Original job base: retire-gardener-clone-alias-verify-deploy-reaper
>
> --- original job body ---
> ---
> tier: mentor
> token-budget: 60000
> ---
> <!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-30T22:16:07Z cleared=none -->
>
> ---
> tier: mentor
> fallback-tier: minion
> token-budget: 60000
> dispatch: automatic
> ---
> Context: parent `retire-gardener-worker-kind-alias-env-fallback` LANDED its full diff on main2 as 70b6d1e3d42 ("refactor(jobs): retire the GARDEN_GARDENER_CLONE env alias"); `grep -rn GARDEN_GARDENER_CLONE scripts` is empty. DO NOT redo it. Remaining work is regression verification only.
>
> Method: run each suite with a SCRUBBED env (`env -i HOME=$HOME PATH=$PATH TMPDIR=$TMPDIR GARDEN_TEST=1 bash scripts/jobs/test/<t>-test.sh`), because a live worker exports GARDEN_WORKER_CLONE etc. that leak into direct runs. Compare against the pre-change tree 70b6d1e3d42^ (extract with `git archive -o $TMPDIR/b.tar 70b6d1e3d42^ scripts && tar -xf $TMPDIR/b.tar -C $TMPDIR/base`) and diff the FAIL lines. Already verified identical-to-baseline (pre-existing failures, NOT regressions): host-requirements-gating, kimi-credit-exhaustion-routing, auction-reputation, live-budget-admission, model-routing. Already passing: canary-probe-claim-priority, qwen-mentor-trial, monk-claude-tier-serving, scaler-desired-count, library-link-check, library-slug-prefix-check, regenerate-sections-index, regenerate-topics-counts. Any NEW failure attributable to 70b6d1e3d42: fix it and land on main2. Report which suites needed updating vs already passed.
>
> Suites for THIS child: deploy-garden, reaper-requeue-cap, reaper-live-handler-guard, reaper-doom-park, deadline-nudge (~10 min), fetch-timeout (>15 min; use a long timeout, foreground).

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_pages_watcher_verify` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_pages_watcher_verify.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_pages_watcher_verify` has CLEARED (first seen 2026-09-30T21:02:27Z, cleared 2026-09-30T22:02:39Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_pages_watcher_verify` cleared on endolin-garden-ece02cb4.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_triager_pace_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_triager_pace_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_triager_pace_journal` has CLEARED (first seen 2026-10-01T01:22:45Z, cleared 2026-10-01T01:27:54Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_triager_pace_journal` cleared on endolin-garden-ece02cb4.

- `watchdog-comment-ack-blind-endojs-endo-but-for-bots` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-ack-blind-endojs-endo-but-for-bots.md)

> WATCHDOG notice — occurrence #83 (first seen 2026-09-30T04:37:42Z, latest 2026-10-01T02:38:53Z).
> The SAME condition (`comment-ack-blind-endojs-endo-but-for-bots`) has now been observed 83 times; this is ONE
> coalesced notice that updates in place, not 83 messages. Latest detail:
>
> Comment acknowledgment blind anomaly for endojs/endo-but-for-bots:
> [https://github.com/endojs/endo-but-for-bots/pull/1340](https://github.com/endojs/endo-but-for-bots/pull/1340)#discussion_r4149165593 (age=21129s; heartbeat=full-poll)

- `retire-gardener-worker-kind-alias-split-resume-terminal-complete` — from orchestrator:retire-gardener-worker-kind-alias-split-resume-terminal-complete, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/retire-gardener-worker-kind-alias-split-resume-terminal-complete.md)

> orchestration-event: orchestration-terminal
> orchestration: retire-gardener-worker-kind-alias-split-resume
> orchestration-status: complete
> order: serial
> children-total: 1
> children-failed: 0
> failed-children: 
> recovered-children: 
>
> Orchestration retire-gardener-worker-kind-alias-split-resume complete (serial): all 1 children reached tada without a machine-readable failure declaration.

- `stale-panel-head-endojs-endo-but-for-bots-pr1390-b915238a-5762b151` — from gardener:fu-ebfb-petname-path-only-sweep-gauntlet-fix-4-4, reply_to `fu-ebfb-petname-path-only-sweep-gauntlet-fix-4-4` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/stale-panel-head-endojs-endo-but-for-bots-pr1390-b915238a-5762b151.md)

> Stale panel coverage for completed job `fu-ebfb-petname-path-only-sweep-gauntlet-fix-4-4`: [https://github.com/endojs/endo-but-for-bots/pull/1390](https://github.com/endojs/endo-but-for-bots/pull/1390) moved from panel-reviewed head `b915238ab3ed9b1a6d47ff599d216681050aa969` to presented head `5762b151c24963b0d2edb95e63c1a31f26323c7a`.
>
> Disposition: **review required**. The earlier panel does not cover the current head; every commit delta is conservatively review-relevant. A PR metadata-only edit would leave the head unchanged and would not trigger this disposition.
>
> No gauntlet was staged. Route the current head through the existing panel stage only after an explicit maintainer `run the gauntlet` request, or make a maintainer review decision with the stale coverage stated explicitly.

- `watchdog-worker-derotate-oros-studio-garden-ce242c49` — from watchdog:worker-derotate, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-worker-derotate-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #4 (first seen 2026-09-30T22:20:16Z, latest 2026-10-01T01:50:15Z).
> The SAME condition (`worker-derotate-oros-studio-garden-ce242c49`) has now been observed 4 times; this is ONE
> coalesced notice that updates in place, not 4 messages. Latest detail:
>
> Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 2892s (offline threshold 1800s; sampled_at_epoch=1790816511).
> worker-derotate zeroed its config/worker-leveling caps (were 4 0 monk cleric) so budget-level stops reserving fleet slots for it; the exact prior caps are recorded in journal worker-derotate/oros-studio-garden-ce242c49. When its budget/live heartbeat is fresh again the caps are restored automatically and this notice closes. To keep it out regardless, set its row by hand (any value other than 0 0 relinquishes the marker; delete the marker to keep 0 0). (leader=endolin-garden-ece02cb4)

- `ebfb-sturdyref-layer2-ses-20260930-gauntlet-halted` — from gauntlet:ebfb-sturdyref-layer2-ses-20260930-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer2-ses-20260930-gauntlet-halted.md)

> Gauntlet ebfb-sturdyref-layer2-ses-20260930-gauntlet HALTED: stage 'ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `watchdog-comment-watcher-stuck-cooldown-host` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-watcher-stuck-cooldown-host.md)

> RECOVERED — the watchdog condition `comment-watcher-stuck-cooldown-host` has CLEARED (first seen 2026-09-30T20:38:38Z, cleared 2026-10-01T00:43:26Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Comment acknowledgment condition cleared.

- `watchdog-journal-contention-watch-overrun` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-watch-overrun.md)

> RECOVERED — the watchdog condition `journal-contention-watch-overrun` has CLEARED (first seen 2026-09-30T20:43:07Z, cleared 2026-10-01T02:12:58Z).
> It was observed 10 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-contention-watch-overrun` cleared on endolin-garden-ece02cb4.

- `retire-gardener-worker-kind-alias-env-fallback-split-terminal-complete-with-failures` — from orchestrator:retire-gardener-worker-kind-alias-env-fallback-split-terminal-complete-with-failures, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/retire-gardener-worker-kind-alias-env-fallback-split-terminal-complete-with-failures.md)

> orchestration-event: orchestration-terminal
> orchestration: retire-gardener-worker-kind-alias-env-fallback-split
> orchestration-status: complete-with-failures
> order: parallel
> children-total: 2
> children-failed: 1
> failed-children: retire-gardener-clone-alias-verify-deploy-reaper
> recovered-children: 
>
> Orchestration retire-gardener-worker-kind-alias-env-fallback-split complete WITH FAILURES (parallel): 1/2 failed: retire-gardener-clone-alias-verify-deploy-reaper

- `watchdog-comment-provenance-gap-endolin-garden-ece02cb4` — from watchdog:comment-provenance, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-provenance-gap-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-30T22:38:06Z, latest 2026-10-01T02:32:05Z).
> The SAME condition (`comment-provenance-gap-endolin-garden-ece02cb4`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> comment-provenance INSTRUMENTATION GAP on host endolin-garden-ece02cb4: a fleet `gh` comment was posted by an LLM-driven caller, but NEITHER GARDEN_JOB_MODEL NOR GARDEN_WORKER_KIND resolved — so the footer named only the host and garden commit (no model/harness/provider). This is the PR #1125 defect. The comment STILL posted (fail-open); nothing is broken. FIX: find the code path posting the comment and export the job facts (GARDEN_JOB_MODEL + GARDEN_WORKER_KIND) before its `gh` call, OR set GARDEN_NO_LLM=1 if it is a deterministic (no-LLM) post.

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

- `ebfb-petname-path-only-sweep-gauntlet-review-budget-reached` — from gauntlet:ebfb-petname-path-only-sweep-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-petname-path-only-sweep-gauntlet-review-budget-reached.md)

> INFO: Gauntlet ebfb-petname-path-only-sweep-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-3` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-3.md)

> budget-level changed endolin-garden-ece02cb4 monk workers 4 -> 3 (target 3): subscription claude-endolin1 spend=42738671 cap=256000000 pace-bias=0 window-start=2026-09-30T19:40Z(observed) deadline=2026-10-03T03:00Z(calendar) ceiling=4 target=3

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal` has CLEARED (first seen 2026-09-30T21:12:45Z, cleared 2026-09-30T22:06:51Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal` cleared on endolin-garden-ece02cb4.

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

- `watchdog-budget-level-monk-preflight` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-preflight.md)

> RECOVERED — the watchdog condition `budget-level-monk-preflight` has CLEARED (first seen 2026-09-30T22:50:06Z, cleared 2026-09-30T23:05:25Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> budget-level: fleet monk allocation recovered on endolin-garden-ece02cb4; eligible calibrated, physically-backed pools are allocatable and leveling has resumed.

- `gauntlet-followups-endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-5` — from gardener:endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-5, reply_to `endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-5` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/gauntlet-followups-endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-5.md)

> Gauntlet stage "endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-5" ("endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet", stage "fix") completed and reported additional follow-ups that require maintainer disposition. The deterministic gauntlet driver owns only the next-panel transition; this escalation was forwarded before the child completed.
>
> ## Follow-ups
>
> - **Should-fix items not done:**
>   - no hasher test across suspend and resume past the size limit;
>   - no test for a crank that stages no outbound frames;
>   - no `proptest` round-trip test for the CAS store;
>   - no statement context in the SQLite params-parse error.
> - **Local build setup:** to build, I initialized the `c/moddable` submodule in the project checkout.

- `endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached` — from gauntlet:endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached.md)

> INFO: Gauntlet endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-journal-contention-storm-clone-oversized` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-storm-clone-oversized.md)

> RECOVERED — the watchdog condition `journal-contention-storm-clone-oversized` has CLEARED (first seen 2026-09-30T21:27:55Z, cleared 2026-09-30T22:43:25Z).
> It was observed 3 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-contention-storm-clone-oversized` cleared on endolin-garden-ece02cb4.

- `retire-gardener-worker-kind-alias-env-fallback-split-child-retire-gardener-clone-alias-verify-deploy-reaper-failed` — from orchestrator:retire-gardener-worker-kind-alias-env-fallback-split-child-retire-gardener-clone-alias-verify-deploy-reaper-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/retire-gardener-worker-kind-alias-env-fallback-split-child-retire-gardener-clone-alias-verify-deploy-reaper-failed.md)

> orchestration-event: orchestration-child-timeout
> orchestration: retire-gardener-worker-kind-alias-env-fallback-split
> orchestration-status: running
> child: retire-gardener-clone-alias-verify-deploy-reaper
> failure-kind: handler-timeout
> order: parallel
> on-child-failure: continue
> detail: stalled in flight for 2412s on host endolin-garden-ece02cb4 (handler-timeout=2400s, multiplier=1)
>
> Orchestration retire-gardener-worker-kind-alias-env-fallback-split observed child retire-gardener-clone-alias-verify-deploy-reaper: stalled in flight for 2412s on host endolin-garden-ece02cb4 (handler-timeout=2400s, multiplier=1).

- `watchdog-budget-zone-oros-studio-garden-ce242c49-backoff` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-oros-studio-garden-ce242c49-backoff.md)

> subscription claude-oros changed zone ok -> backoff at spend=6052865/73000000.

- `20260930T213136Z-f17504` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260930T213136Z-f17504.md)

> awaiting maintainer — beyond proxy authority: gardener accountant-budget-conversation-20260930, msgid msg-accountant-budget-conversation-20260930-4b156353d3b7.md — This bundles a maintainer-set mandate re-affirmation/rank-change and a "retire" (close) decision on live upstream PRs — authority grants and outward-facing/irreversible actions reserved to the maintainer, not proxyable budget mechanics.

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.

- `watchdog-budget-zone-oros-studio-garden-ce242c49-ok` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-oros-studio-garden-ce242c49-ok.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-30T09:10:16Z, latest 2026-10-01T00:02:39Z).
> The SAME condition (`budget-zone-oros-studio-garden-ce242c49-ok`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> subscription claude-oros changed zone backoff -> ok at spend=7804008/73000000.

- `watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-09-30T21:23:02Z, cleared 2026-10-01T01:32:16Z).
> It was observed 5 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> canary oros-studio-garden-ce242c49 is no longer stuck (release 2916e65ffb94dab419bae7eb7749236a63efb61b, deployed e036bb8e0650b66a4ae00dc1516c4c8df39901ca).

- `stale-panel-head-endojs-endo-but-for-bots-pr1357-50917af1-3a9c6be6` — from gardener:claude-on-minion-town-press-20261001-005035, reply_to `claude-on-minion-town-press-20261001-005035` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/stale-panel-head-endojs-endo-but-for-bots-pr1357-50917af1-3a9c6be6.md)

> COALESCED message — occurrence #2 (first seen 2026-09-30T22:43:17Z, latest 2026-10-01T01:57:18Z).
> The SAME message (episode key `stale-panel-head-endojs-endo-but-for-bots-pr1357-50917af1-3a9c6be6`) has now been sent 2 times; this is
> ONE entry that updates in place, not 2 messages. Latest detail:
>
> Stale panel coverage for completed job `claude-on-minion-town-press-20261001-005035`: [https://github.com/endojs/endo-but-for-bots/pull/1357](https://github.com/endojs/endo-but-for-bots/pull/1357) moved from panel-reviewed head `50917af1a439419d6ccc5b91ceb11acb0c5bff59` to presented head `3a9c6be6030fad904d5e559efc1cc3627c1e9197`.
>
> Disposition: **review required**. The earlier panel does not cover the current head; every commit delta is conservatively review-relevant. A PR metadata-only edit would leave the head unchanged and would not trigger this disposition.
>
> No gauntlet was staged. Route the current head through the existing panel stage only after an explicit maintainer `run the gauntlet` request, or make a maintainer review decision with the stale coverage stated explicitly.

- `watchdog-blind-comment-watcher-kriscendobot-vattr97` — from watchdog:comment-watcher/kriscendobot-vattr97, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-blind-comment-watcher-kriscendobot-vattr97.md)

> ANOMALY: comment-watcher/kriscendobot-vattr97 self-test FAILED on kriscendobot/vattr97 — the comment source path could not fetch a known-existing comment, so the watcher is likely silently BLIND (the 2026-06-24 jq-outage signature). Check jq/gh on endolin-garden-ece02cb4 and the comment-source handler. This is a POSITIVE proof the source path is broken, NOT a report that the repo is quiet.


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 57.5M | $451.35 _(notional, rate-card)_ | 22% of 256.0M (ok) |
| Codex | 17.9M _(fleet aggregate)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 38% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 135984333 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 5.124805s/45s (/home/kris/garden/.garden-state/inbox-list/journal); 1 open notice(s); checker healthy

## Board
### todo (14)
- [`endojs-endo-but-for-bots-pr1340-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1340-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1340
- [`ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1398
- [`improve-scheduler-tempfail-preflight`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/improve-scheduler-tempfail-preflight.md) — ---
- [`build-ci-minion-town-actions-runner-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-ci-minion-town-actions-runner-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — kriscendobot/minion.town PR #145
- [`book-copyedit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/book-copyedit.md) — Copy-edit pass on the garden book
- [`endojs-endo-but-for-bots-pr1357-weave-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1357-weave-20261001.md) — Weave endojs/endo-but-for-bots#1357 onto current llm
- [`claude-on-minion-town-completion-press-20261001-023505`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/claude-on-minion-town-completion-press-20261001-023505.md) — Press: are the Claude-on-minion.town arc's jobs running to completion?
- [`ebfb-petname-path-only-sweep-3-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-sweep-3-gauntlet-panel-4.md) — Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1390
- [`dependabotany-recheck-endo-but-for-bots-20261001-015023`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/dependabotany-recheck-endo-but-for-bots-20261001-015023.md) — ---
- [`ebfb-petname-path-only-sweep-4-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-sweep-4-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1390
- [`ebfb-774-pr-body-refresh-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-774-pr-body-refresh-20261001.md) — Update the PR #774 description (endojs/endo-but-for-bots)
- [`endojs-endo-but-for-bots-pr1402-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1402-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1402
- [`ebfb-petname-path-only-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1390
- [`fu-qwen-model-watch-20260728-180502-1-20260930-162006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/fu-qwen-model-watch-20260728-180502-1-20260930-162006.md) — ---

### doin (6)
- [`ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1394
- [`ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1392
- [`ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1393
- [`ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1396
- [`ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #774
- [`endojs-endo-but-for-bots-pr1394-20260930-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1394-20260930-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1394

### tada (10176)
- [`endojs-endo-but-for-bots-pr1340-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/endojs-endo-but-for-bots-pr1340-gauntlet-panel-1.md) — Panel round 1 for endojs/endo-but-for-bots#1340 (design: agent makers for con...
- [`build-ci-minion-town-actions-runner-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/build-ci-minion-town-actions-runner-gauntlet-panel-2.md) — Cost
- [`endojs-endo-but-for-bots-pr695-gauntlet-20260930`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/endojs-endo-but-for-bots-pr695-gauntlet-20260930.md) — gauntlet endojs-endo-but-for-bots-pr695-gauntlet-20260930 - not viable
- [`endojs-endo-but-for-bots-pr695-gauntlet-20260930-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/endojs-endo-but-for-bots-pr695-gauntlet-20260930-viability.md) — Cost
- [`ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-1.md) — Cost
- … and 10171 more

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
- [`retire-gardener-clone-alias-verify-deploy-reaper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/retire-gardener-clone-alias-verify-deploy-reaper.md) — _normal_ · ---
- [`evaluate-reauth-escalation-default-after-oauth-relay-20260927`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/evaluate-reauth-escalation-default-after-oauth-relay-20260927.md) — _low_ · Evaluate default reauth escalation once the browser OAuth relay lands
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper.md) — _normal_ · Build: SES import attributes — Phase 3 (compartment-mapper plumbing)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`accountant-budget-conversation-20260930-resume`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/accountant-budget-conversation-20260930-resume.md) — _normal_ · ---
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
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 3 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 3 monks
