# Garden bulletin

_As of 2026-10-02T21:58:27Z_

## Latest

Two PRs closed out: [endojs/endo-but-for-bots#1402](https://github.com/endojs/endo-but-for-bots/pull/1402) was conducted (merged), and the [minion.town#140](https://github.com/kriscendobot/minion.town/pull/140) Endo-cancel gauntlet hit its review-budget ceiling after 6 fix rounds — CI green, left for human merge review. A new gauntlet opened for [endojs/endo-but-for-bots#1416](https://github.com/endojs/endo-but-for-bots/pull/1416) (clean + panel round 1 both done, fix round 1 now queued), and PR #1412 got a rerun/restage.

The bigger story is operational: the leader host (endolin-garden-ece02cb4) is **25 commits behind origin/main2 and has been stalled for ~2 days**, which means it's not honoring any directive newer than its deployed SHA — worth investigating why `deploy-garden.sh` hasn't landed anything. Rolling deploy is also holding on endolin2 because every follower is offline/drained, so there's no canary. Separately, `oros-studio-garden` has been unreachable for ~16 hours (heartbeat and sysop both stale) — looks like it needs a person at the physical machine (Docker Desktop/sleep/VM). Several build/gauntlet jobs halted outright on failed clean or fix stages (confined-application-makers phase 2, endo-claude-sandbox-bwrap, endo-claude-backends-1357, ebfb-petname-path-only-sweep-4, ebfb-sturdyref-layer3 and layer6) and are queued for maintainer attention rather than auto-retrying.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#1282](https://github.com/endojs/endo-but-for-bots/pull/1282) — chore(ironhorse): demolish the XS-computron-parity myth (waiting 5d)
- [endojs/endo-but-for-bots#1281](https://github.com/endojs/endo-but-for-bots/pull/1281) — fix(ses): silence lockdown intrinsics report for the WHATWG URL family (waiting 15d)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 20d)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 29d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 31d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 31d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 31d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 31d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 32d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 34d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Screened by proxy (minion.town)

(delegation not armed)

## Messages to the maintainer

- `ebfb-guest-no-identifiers-locators-gauntlet-halted` — from gauntlet:ebfb-guest-no-identifiers-locators-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-guest-no-identifiers-locators-gauntlet-halted.md)

> Gauntlet ebfb-guest-no-identifiers-locators-gauntlet HALTED: stage 'ebfb-guest-no-identifiers-locators-gauntlet-fix-5' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #82 (first seen 2026-10-02T05:41:06Z, latest 2026-10-02T21:05:02Z).
> The SAME condition (`rolling-deploy-host-offline-oros-studio-garden-ce242c49`) has now been observed 82 times; this is ONE
> coalesced notice that updates in place, not 82 messages. Latest detail:
>
> Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 57386s (offline threshold 1800s; sampled_at_epoch=1790917716).
> The authority is budget/live/<pool>/oros-studio-garden-ce242c49, refreshed periodically; fleet/health/oros-studio-garden-ce242c49 is
> not a heartbeat and was intentionally ignored. Rolling deploy will SKIP this peer:
> no release token, deploy budget, failed-canary count, or halt. Restore the host and
> its heartbeat to rejoin automatically. If hosts/oros-studio-garden-ce242c49 was archived, unarchive it as a
> separate operator decision; this watchdog never reverses decommissioning. (leader=endolin-garden-ece02cb4)

- `watchdog-rolling-deploy-no-canary-endolin-garden-ece02cb4` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-no-canary-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #320 (first seen 2026-09-30T23:36:06Z, latest 2026-10-02T21:05:09Z).
> The SAME condition (`rolling-deploy-no-canary-endolin-garden-ece02cb4`) has now been observed 320 times; this is ONE
> coalesced notice that updates in place, not 320 messages. Latest detail:
>
> Rolling deploy is HOLDING the leader: every configured follower is OFFLINE or
> operator-drained, so there is no canary to validate c2a524676504. The leader will
> not advance unvalidated. Restore any offline host until budget/live heartbeats resume,
> or lift an operator drain. An archived host additionally needs a separate operator
> unarchive; this roll never reverses archival. (leader=endolin-garden-ece02cb4, offline=1)

- `doomed-improve-receipt-primary-quota-cooldown-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-improve-receipt-primary-quota-cooldown-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/improve-receipt-primary-quota-cooldown; it stays HELD until a human promotes it
> (promote-plan.sh improve-receipt-primary-quota-cooldown) or removes it, so nothing is lost.
> Original job base: improve-receipt-primary-quota-cooldown
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> scripts/jobs/receipt-watcher.sh
> scripts/jobs/receipt-watcher.sh:97-101 treats GitHub primary-quota stderr as a generic transient and logs a 300s cooldown, though the 2026-10-02T19:45:23Z warning was followed by a 3599s primary-quota latch.
> Detect primary quota before the generic transient path, request `api_primary_quota_secs`, and log the actual full quota cooldown; add a regression test for the adopted `gh_api_retry` latch.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_fork_watch_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_fork_watch_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_fork_watch_journal` has CLEARED (first seen 2026-10-02T17:41:09Z, cleared 2026-10-02T18:05:30Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_fork_watch_journal` cleared on endolin-garden-ece02cb4.

- `watchdog-root-repo-deploy-stalled-endolin-garden2-5bcdff64` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-endolin-garden2-5bcdff64.md)

> root repo /home/kris/garden2 deploy has been STALLED for ~1d: deployed sha c63c16cad579f313f26afa1cb752c67cc97f5b6e is 16 commit(s) behind origin/main2 (697976e718f354af3b121874c52a6cdbc8d6c87c) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=endolin-garden2-5bcdff64)

- `build-confined-application-makers-p1-20261002-gauntlet-halted` — from gauntlet:build-confined-application-makers-p1-20261002-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-confined-application-makers-p1-20261002-gauntlet-halted.md)

> Gauntlet build-confined-application-makers-p1-20261002-gauntlet HALTED: stage 'build-confined-application-makers-p1-20261002-gauntlet-clean' (clean) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `build-confined-application-makers-orch-20261002-halted` — from orchestrator:build-confined-application-makers-orch-20261002-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-confined-application-makers-orch-20261002-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: build-confined-application-makers-orch-20261002
> orchestration-status: halted
> child: build-confined-application-makers-p2-20261002
> failure-kind: doomed
> children-completed: 1
> children-total: 5
> halt-parked-remainder: build-confined-application-makers-p3-20261002 build-confined-application-makers-p4-20261002 build-confined-application-makers-p5-20261002
>
> Orchestration build-confined-application-makers-orch-20261002 HALTED: child build-confined-application-makers-p2-20261002 doomed and held in plan (serial, on-child-failure=halt). 1/5 done before halt; parked remainder: build-confined-application-makers-p3-20261002 build-confined-application-makers-p4-20261002 build-confined-application-makers-p5-20261002

- `watchdog-container-hardening-pending-recreate-endolin-garden2-5bcdff64` — from watchdog:self-heal, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-container-hardening-pending-recreate-endolin-garden2-5bcdff64.md)

> Container hardening is PENDING on endolin-garden2-5bcdff64: 2 launcher-posture check(s) fail (caps/sudo/block devices/mount).
>
> This is the expected state until the container is recreated with the hardened launcher,
> a maintainer step: context/operations/harden-container.md. The garden-container-hardening
> unit stays clean meanwhile (exit 3), so it does not fail rolling-deploy canaries. After the
> first all-pass run, any failure is treated as a regression and fails the unit.

- `ebfb-petname-path-only-sweep-4-gauntlet-halted` — from gauntlet:ebfb-petname-path-only-sweep-4-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-petname-path-only-sweep-4-gauntlet-halted.md)

> Gauntlet ebfb-petname-path-only-sweep-4-gauntlet HALTED: stage 'ebfb-petname-path-only-sweep-4-gauntlet-fix-6' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `build-endo-claude-sandbox-bwrap-slice-gauntlet-halted` — from gauntlet:build-endo-claude-sandbox-bwrap-slice-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-endo-claude-sandbox-bwrap-slice-gauntlet-halted.md)

> Gauntlet build-endo-claude-sandbox-bwrap-slice-gauntlet HALTED: stage 'build-endo-claude-sandbox-bwrap-slice-gauntlet-fix-5' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `watchdog-budget-level-monk-endolin-garden2-5bcdff64-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden2-5bcdff64-2.md)

> budget-level changed endolin-garden2-5bcdff64 monk workers 1 -> 2 (target 2): subscription claude-endolin2 spend=109961313 cap=121000000 pace-bias=0.179294 window-start=2026-09-26T03:00Z(calendar) deadline=2026-10-03T03:00Z(calendar) [planned reset 2026-10-03T03:00:00Z not before calendar deadline; ignored] ceiling=4 target=2

- `ebfb-petname-path-only-sweep-3-gauntlet-review-budget-reached` — from gauntlet:ebfb-petname-path-only-sweep-3-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-petname-path-only-sweep-3-gauntlet-review-budget-reached.md)

> INFO: Gauntlet ebfb-petname-path-only-sweep-3-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_leader_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_leader_journal.md)

> Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/leader/journal: packs 1006 >= 1000; size=255460352B packs=1006 gc.log=0; automatic remedy=deferred-deadline.

- `msg-oros-health-watch-20261002-210506-89c43e4520b0` — from gardener:oros-health-watch-20261002-210506, reply_to `oros-health-watch-20261002-210506` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-oros-health-watch-20261002-210506-89c43e4520b0.md)

> oros-studio-garden-ce242c49 appears UNREACHABLE (oros-health-watch 2026-10-02T21:26Z): heartbeat last refreshed 05:15Z (~16h), last sysop-log 05:35Z (~16h, sysop not ticking), fleet/health last at 03:13Z (roll_status deferred, sha e036bb8e), worker-derotate marker present; checkups 080511/112006/142006 all unclaimed in todo. No sysop ops sent (nothing would ack). Needs a person at the machine: Docker Desktop / Mac sleep / VM.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_approval_reconciler_verify` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_approval_reconciler_verify.md)

> Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/approval-reconciler/verify: packs 1006 >= 1000; size=328429568B packs=1006 gc.log=0; automatic remedy=deferred-deadline.

- `watchdog-journal-contention-watch-overrun` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-watch-overrun.md)

> WATCHDOG notice — occurrence #8 (first seen 2026-10-02T17:51:26Z, latest 2026-10-02T21:55:34Z).
> The SAME condition (`journal-contention-watch-overrun`) has now been observed 8 times; this is ONE
> coalesced notice that updates in place, not 8 messages. Latest detail:
>
> Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 79 of 1050 clone(s) on consecutive ticks.

- `watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4.md)

> root repo /home/kris/garden deploy has been STALLED for ~2d / 25 commits behind (leader commits-fuse 25): deployed sha 878c5d5299f047cc0c4619529e9a323b4c2d40df is 25 commit(s) behind origin/main2 (c2a524676504e54816e304546700114e85c88d11) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. This host is the LEADER: it runs every singleton producer (foreman, scheduler, watchers), so while it is stale it is NOT honoring any directive newer than its deployed sha — a PROJECT PAUSE among them. This is the shape that let a stale leader run ~60 IronHorse fuzz jobs a week after the 09-09 pause (designs/project-pause-enforcement.md). DEPLOY IT. (host=endolin-garden-ece02cb4)

- `watchdog-comment-provenance-gap-endolin-garden-ece02cb4` — from watchdog:comment-provenance, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-provenance-gap-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #12 (first seen 2026-10-01T21:44:07Z, latest 2026-10-02T21:41:03Z).
> The SAME condition (`comment-provenance-gap-endolin-garden-ece02cb4`) has now been observed 12 times; this is ONE
> coalesced notice that updates in place, not 12 messages. Latest detail:
>
> comment-provenance INSTRUMENTATION GAP on host endolin-garden-ece02cb4: a fleet `gh` comment was posted by an LLM-driven caller, but NEITHER GARDEN_JOB_MODEL NOR GARDEN_WORKER_KIND resolved — so the footer named only the host and garden commit (no model/harness/provider). This is the PR #1125 defect. The comment STILL posted (fail-open); nothing is broken. FIX: find the code path posting the comment and export the job facts (GARDEN_JOB_MODEL + GARDEN_WORKER_KIND) before its `gh` call, OR set GARDEN_NO_LLM=1 if it is a deterministic (no-LLM) post.

- `ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-halted` — from gauntlet:ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-halted.md)

> Gauntlet ebfb-sturdyref-layer3-pass-style-20260930-gauntlet HALTED: stage 'ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-6' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal` has CLEARED (first seen 2026-10-01T23:09:20Z, cleared 2026-10-02T18:35:34Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal` cleared on endolin-garden-ece02cb4.

- `build-confined-application-makers-orch-20261002-child-build-confined-application-makers-p2-20261002-failed` — from orchestrator:build-confined-application-makers-orch-20261002-child-build-confined-application-makers-p2-20261002-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-confined-application-makers-orch-20261002-child-build-confined-application-makers-p2-20261002-failed.md)

> orchestration-event: orchestration-child-failure
> orchestration: build-confined-application-makers-orch-20261002
> orchestration-status: running
> child: build-confined-application-makers-p2-20261002
> failure-kind: doomed
> order: serial
> on-child-failure: halt
> detail: doomed and held in plan
>
> Orchestration build-confined-application-makers-orch-20261002 observed child build-confined-application-makers-p2-20261002: doomed and held in plan.

- `stale-panel-head-endojs-endo-but-for-bots-pr1391-faefd8e5-00882036` — from gardener:ebfb-1391-post-panel-5-verdict, reply_to `ebfb-1391-post-panel-5-verdict` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/stale-panel-head-endojs-endo-but-for-bots-pr1391-faefd8e5-00882036.md)

> Stale panel coverage for completed job `ebfb-1391-post-panel-5-verdict`: [https://github.com/endojs/endo-but-for-bots/pull/1391](https://github.com/endojs/endo-but-for-bots/pull/1391) moved from panel-reviewed head `faefd8e514806520dd8f070e95133ce5ea7c03ef` to presented head `008820366e6d44acb7a19cae585a8cae2eccfe81`.
>
> Disposition: **review required**. The earlier panel does not cover the current head; every commit delta is conservatively review-relevant. A PR metadata-only edit would leave the head unchanged and would not trigger this disposition.
>
> No gauntlet was staged. Route the current head through the existing panel stage only after an explicit maintainer `run the gauntlet` request, or make a maintainer review decision with the stale coverage stated explicitly.

- `ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-halted` — from gauntlet:ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-halted.md)

> Gauntlet ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet HALTED: stage 'ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-6' (fix) failed 2 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `watchdog-blind-comment-watcher-kriscendobot-test262` — from watchdog:comment-watcher/kriscendobot-test262, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-blind-comment-watcher-kriscendobot-test262.md)

> ANOMALY: comment-watcher/kriscendobot-test262 self-test FAILED on kriscendobot/test262 — the comment source path could not fetch a known-existing comment, so the watcher is likely silently BLIND (the 2026-06-24 jq-outage signature). Check jq/gh on endolin-garden-ece02cb4 and the comment-source handler. This is a POSITIVE proof the source path is broken, NOT a report that the repo is quiet.

- `endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-review-budget-reached` — from gauntlet:endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-review-budget-reached.md)

> INFO: Gauntlet endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached` — from gauntlet:endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached.md)

> INFO: Gauntlet endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_receipt_watcher_journal_kriscendobot_proposal_compartments` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_receipt_watcher_journal_kriscendobot_proposal_compartments.md)

> Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/receipt-watcher/journal-kriscendobot-proposal-compartments: packs 1000 >= 1000; size=603786240B packs=1000 gc.log=0; automatic remedy=deferred-deadline.

- `build-endo-claude-broker-catalog-pruning-gauntlet-review-budget-reached` — from gauntlet:build-endo-claude-broker-catalog-pruning-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-endo-claude-broker-catalog-pruning-gauntlet-review-budget-reached.md)

> INFO: Gauntlet build-endo-claude-broker-catalog-pruning-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `build-endo-claude-backends-1357-open-pr-gauntlet-halted` — from gauntlet:build-endo-claude-backends-1357-open-pr-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-endo-claude-backends-1357-open-pr-gauntlet-halted.md)

> Gauntlet build-endo-claude-backends-1357-open-pr-gauntlet HALTED: stage 'build-endo-claude-backends-1357-open-pr-gauntlet-clean' (clean) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `watchdog-container-hardening-pending-recreate-endolin-garden-ece02cb4` — from watchdog:self-heal, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-container-hardening-pending-recreate-endolin-garden-ece02cb4.md)

> Container hardening is PENDING on endolin-garden-ece02cb4: 2 launcher-posture check(s) fail (caps/sudo/block devices/mount).
>
> This is the expected state until the container is recreated with the hardened launcher,
> a maintainer step: context/operations/harden-container.md. The garden-container-hardening
> unit stays clean meanwhile (exit 3), so it does not fail rolling-deploy canaries. After the
> first all-pass run, any failure is treated as a regression and fails the unit.

- `watchdog-blind-comment-watcher-kriscendobot-vattr97` — from watchdog:comment-watcher/kriscendobot-vattr97, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-blind-comment-watcher-kriscendobot-vattr97.md)

> ANOMALY: comment-watcher/kriscendobot-vattr97 self-test FAILED on kriscendobot/vattr97 — the comment source path could not fetch a known-existing comment, so the watcher is likely silently BLIND (the 2026-06-24 jq-outage signature). Check jq/gh on endolin-garden-ece02cb4 and the comment-source handler. This is a POSITIVE proof the source path is broken, NOT a report that the repo is quiet.


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 269.5M | $1939.65 _(notional, rate-card)_ | 105% of 256.0M (backoff) |
| Codex | 20.4M _(fleet aggregate)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 38% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 148242932 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 5.797447s/45s (/home/kris/garden/.garden-state/regenerate-topics-counts/journal); 8 open notice(s); checker healthy

## Board
### todo (29)
- [`endojs-endo-but-for-bots-pr1404-investigate-20261002`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1404-investigate-20261002.md) — Confirm whether the macOS @endo/daemon failure on endojs/endo-but-for-bots#14...
- [`revive-hermit-lane-qwen3.8-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/revive-hermit-lane-qwen3.8-20261001.md) — Revive the local hermit (on-box Ollama) lane, upgraded to qwen3.8
- [`endojs-endo-but-for-bots-pr1416-conduct-20261002`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1416-conduct-20261002.md) — Conduct (merge) endojs/endo-but-for-bots PR #1416
- [`oros-health-checkup-20261002-045016`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-045016.md) — ---
- [`book-copyedit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/book-copyedit.md) — Copy-edit pass on the garden book
- [`oros-health-checkup-20261002-112006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-112006.md) — ---
- [`oros-health-checkup-20261002-080511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-080511.md) — ---
- [`endojs-endo-but-for-bots-pr1416-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1416-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1416
- [`oros-health-checkup-20261002-142006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-142006.md) — ---
- [`endojs-endo-but-for-bots-pr1340-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1340-gauntlet-panel-4.md) — Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1340
- [`build-ci-minion-town-actions-runner-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-ci-minion-town-actions-runner-gauntlet-panel-4.md) — Gauntlet stage: PANEL round 4 — kriscendobot/minion.town PR #145
- [`claude-on-minion-town-completion-press-20261002-212012`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/claude-on-minion-town-completion-press-20261002-212012.md) — Press: are the Claude-on-minion.town arc's jobs running to completion?
- [`build-endo-claude-pinned-cli-bump-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-endo-claude-pinned-cli-bump-gauntlet-panel-6.md) — Gauntlet stage: PANEL round 6 — endojs/endo-but-for-bots PR #1406
- [`ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1393
- [`oros-health-watch-20261002-085005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-watch-20261002-085005.md) — ---
- [`ebfb-774-pr-body-refresh-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-774-pr-body-refresh-20261001.md) — Update the PR #774 description (endojs/endo-but-for-bots)
- [`kriscendobot-minion.town-pr85-101f9480`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/kriscendobot-minion.town-pr85-101f9480.md) — attention directive on kriscendobot/minion.town PR #85
- [`daily-progress-summary-20261002-070505`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/daily-progress-summary-20261002-070505.md) — Daily midnight Pacific progress summary
- [`build-endo-guest-scoped-daemon-bootstrap-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-endo-guest-scoped-daemon-bootstrap-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1407
- [`endojs-endo-but-for-bots-pr1403-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1403-gauntlet-panel-4.md) — Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1403
- [`endojs-endo-but-for-bots-pr1348-8333ce11`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1348-8333ce11.md) — attention directive on endojs/endo-but-for-bots PR #1348
- [`accountant-budget-conversation-20260930-resume`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/accountant-budget-conversation-20260930-resume.md) — Deliberate overrun decomposition for accountant-budget-conversation-20260930-...
- [`kriscendobot-minion.town-pr147-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/kriscendobot-minion.town-pr147-gauntlet-clean.md) — Gauntlet stage: CLEAN — kriscendobot/minion.town PR #147
- [`endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002-viability.md) — Gauntlet stage: PRE-SPEND VIABILITY - endojs/endo-but-for-bots PR #1379
- [`ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1397
- [`ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-6-pr-write`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-6-pr-write.md) — PR-write handoff for endojs/endo-but-for-bots#1392 (gauntlet fix round 6)
- [`claude-on-minion-town-press-20261002-112006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/claude-on-minion-town-press-20261002-112006.md) — Press the Claude-on-minion.town arc forward
- [`endojs-endo-but-for-bots-pr1412-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1412-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1412
- [`ebfb-petname-path-only-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1390

### doin (1)
- [`endojs-endo-but-for-bots-pr1407-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1407-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1407

### tada (10475)
- [`endojs-endo-but-for-bots-pr1416-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/02/endojs-endo-but-for-bots-pr1416-gauntlet-panel-1.md) — Cost
- [`minion-town-pr140-endo-cancel-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/02/minion-town-pr140-endo-cancel-gauntlet.md) — gauntlet minion-town-pr140-endo-cancel-gauntlet — review budget reached
- [`endojs-endo-but-for-bots-pr1412-rerun-restage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/02/endojs-endo-but-for-bots-pr1412-rerun-restage.md) — Cost
- [`endojs-endo-but-for-bots-pr1402-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/02/endojs-endo-but-for-bots-pr1402-conduct.md) — Cost
- [`minion-town-pr140-endo-cancel-gauntlet-fix-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/02/minion-town-pr140-endo-cancel-gauntlet-fix-6.md) — Cost
- … and 10470 more

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
- [`improve-receipt-primary-quota-cooldown`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-receipt-primary-quota-cooldown.md) — _normal_ · ---
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
- [`build-confined-application-makers-p2-20261002`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-confined-application-makers-p2-20261002.md) — _normal_ · Phase 2: daemon capture for node-modules-with-map and node-modules-scan layou...
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
- [`retire-gardener-clone-alias-verify-deploy-reaper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/retire-gardener-clone-alias-verify-deploy-reaper.md) — _normal_ · ---
- [`ebfb-guest-designation-consumers-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-guest-designation-consumers-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1410
- [`ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-fix-2.md) — _normal_ · Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #774
- [`ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-5.md) — _normal_ · Gauntlet stage: FIX round 5 — endojs/endo-but-for-bots PR #1391
- [`endojs-endo-but-for-bots-pr1394-20260930-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1394-20260930-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1394
- [`ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1398
- [`endojs-endo-but-for-bots-pr1340-review-85c8bc95-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1340-review-85c8bc95-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1340 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1357-review-a8630960-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1357-review-a8630960-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1357 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1371-3ab5ee33-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1371-3ab5ee33-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1371 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1371-review-cd454ee3-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1371-review-cd454ee3-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1371 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1402-review-141e965e-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1402-review-141e965e-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1402 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr695-5e067785-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr695-5e067785-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #695 (primary: endojs-endo-but-f...
- [`kriscendobot-garden-pr75-review-6b5f570b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr75-review-6b5f570b-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #75 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-minion.town-pr135-review-e4d01640-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr135-review-e4d01640-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #135 (primary: kriscendobot-mini...
- [`kriscendobot-minion.town-pr140-review-8f6d6ac9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr140-review-8f6d6ac9-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #140 (primary: kriscendobot-mini...
- [`kriscendobot-minion.town-pr85-review-9f17a419-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr85-review-9f17a419-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #85 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr90-d6a72a2f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr90-d6a72a2f-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #90 (primary: kriscendobot-minio...
- [`endojs-endo-but-for-bots-pr1277-review-7a7abb72-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1277-review-7a7abb72-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1277 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1348-review-3fce8521-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1348-review-3fce8521-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1348 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1340-review-620de24d-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1340-review-620de24d-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1340 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1343-review-5933a851-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1343-review-5933a851-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1343 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1116-review-d33d67ff-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1116-review-d33d67ff-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1116 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1340-review-c8f6e4bb-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1340-review-c8f6e4bb-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1340 (primary: endojs-endo-but-...
- [`kriscendobot-minion.town-pr146-review-64a01f1e-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr146-review-64a01f1e-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #146 (primary: kriscendobot-mini...
- [`kriscendobot-minion.town-pr91-review-857b06ab-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr91-review-857b06ab-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #91 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr85-review-f6a41dd9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr85-review-f6a41dd9-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #85 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr85-101f9480-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr85-101f9480-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #85 (primary: kriscendobot-minio...
- [`endojs-endo-but-for-bots-pr1416-review-37d3281c-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1416-review-37d3281c-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1416 (primary: endojs-endo-but-...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`ebfb-platform-fs-pet-name-path-only`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-platform-fs-pet-name-path-only.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1390` · ---
- [`endo-minion-town-federation-release-gate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-minion-town-federation-release-gate.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1124` · Gate: reviewed and deployable federation release
- [`verify-ironhorse-press-first-engagement-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ironhorse-press-first-engagement-20260929.md) — awaiting `ironhorse-test262-press-20260929-173306` · Verify the first live Ironhorse foreman-press engagement (successor of activa...
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1019` · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`book-illustrations-integrate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/book-illustrations-integrate.md) — awaiting `book-codex-illustrations` · Garden book: integrate the Codex-generated illustrations and publish
- [`book-build-js-retool`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/book-build-js-retool.md) — awaiting `book-illustrations-integrate` · Retool the garden-book generator in portable JavaScript
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`book-codex-illustrations`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/book-codex-illustrations.md) — awaiting `garden-book-revision-orch` · Garden book: generate illustrations and background art (Codex)
- [`build-exo-sheets-service`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-sheets-service.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`book-title-audience-pass`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/book-title-audience-pass.md) — awaiting `garden-book-revision-orch` · Garden book: a sharper title, and a pass for the actual audience
- [`ironhorse-fuzz-triage-differential_source-efffacee3e2a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-triage-differential_source-efffacee3e2a.md) — awaiting `https://github.com/kriscendobot/garden/issues/91` · Triage 7 Ironhorse fuzz finding(s) for target differential_source

## Watch set
kriscendobot-minion.town kriscendobot-garden-book kriscendobot-cosgov kriscendobot-ocapn kriscendobot-oros-ckm-data-readiness kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot

## Hosts
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 2 monks
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 1 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 3 monks
