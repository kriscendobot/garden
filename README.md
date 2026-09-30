# Garden bulletin

_As of 2026-09-30T04:19:25Z_

## Latest

Endo-but-for-bots #1124 (federation gauntlet) came back HALTED, which also gates the parked `endo-minion-town-federation-release-gate` job — worth a look. The #1355 gauntlet advanced into a pre-spend viability check, and minion.town's npm-registry PR #134 finished its post-merge reconcile. Book chapters 5 and 8 landed (ch3 bounced back to todo). Otherwise the board mostly churned on routine budget-level rebalancing and canary probes; nothing else material moved into tada this cycle.

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

- `watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #61 (first seen 2026-09-29T21:17:11Z, latest 2026-09-30T04:11:02Z).
> The SAME condition (`rolling-deploy-host-offline-oros-studio-garden-ce242c49`) has now been observed 61 times; this is ONE
> coalesced notice that updates in place, not 61 messages. Latest detail:
>
> Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 9135s (offline threshold 1800s; sampled_at_epoch=1790732327).
> The authority is budget/live/<pool>/oros-studio-garden-ce242c49, refreshed periodically; fleet/health/oros-studio-garden-ce242c49 is
> not a heartbeat and was intentionally ignored. Rolling deploy will SKIP this peer:
> no release token, deploy budget, failed-canary count, or halt. Restore the host and
> its heartbeat to rejoin automatically. If hosts/oros-studio-garden-ce242c49 was archived, unarchive it as a
> separate operator decision; this watchdog never reverses decommissioning. (leader=endolin-garden-ece02cb4)

- `msg-ironhorse-test262-ratchet-round3-20260928-0d0c921abeb6` — from gardener:ironhorse-test262-ratchet-round3-20260928, reply_to `ironhorse-test262-ratchet-round3-20260928` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ironhorse-test262-ratchet-round3-20260928-0d0c921abeb6.md)

> Decision needed for round 3: the completed current-llm sweep has 906 lost paths against the historical floor BEFORE my changes: 443 engine-limit aborts, 397 shared-positive-test-failure, 66 other. Several hundred historical covered cases were false positives under the old classifier; I will not mark them covered or weaken the current classifier. May the draft record an explicitly reconciled current-llm floor (36,599 covered) and defend zero loss against that, retaining all 906 historical dispositions for follow-up? Otherwise this round's literal superseding-floor acceptance cannot be honestly met in one constants-descriptor crank. The proposed fix already has 5 red-before/green-after dual-run tests and repairs Math/Number/TypedArray numeric constant attributes; full Rust gates and an after sweep are next.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-2.md)

> WATCHDOG notice — occurrence #6 (first seen 2026-09-09T20:50:15Z, latest 2026-09-27T16:12:25Z).
> The SAME condition (`budget-level-cleric-endolin-garden-ece02cb4-2`) has now been observed 6 times; this is ONE
> coalesced notice that updates in place, not 6 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 cleric workers 3 -> 2 (target 2): shared codex subscription demand active=1 queue=2 quota=ok fleet-envelope=5 target=2

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

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-2.md)

> WATCHDOG notice — occurrence #3 (first seen 2026-09-17T00:05:35Z, latest 2026-09-27T12:35:28Z).
> The SAME condition (`budget-level-cleric-endolin-garden2-5bcdff64-2`) has now been observed 3 times; this is ONE
> coalesced notice that updates in place, not 3 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 cleric workers 1 -> 2 (target 2): shared codex subscription demand active=2 queue=6 quota=ok fleet-envelope=5 target=2

- `watchdog-root-repo-deploy-stalled-oros-studio-garden-ce242c49` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-oros-studio-garden-ce242c49.md)

> root repo /Users/dom/garden deploy has been STALLED for ~1d: deployed sha e036bb8e0650b66a4ae00dc1516c4c8df39901ca is 38 commit(s) behind origin/main2 (e17a717171db2d710312422b1825ac2813019307) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=oros-studio-garden-ce242c49)

- `watchdog-budget-level-monk-endolin-garden2-5bcdff64-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden2-5bcdff64-2.md)

> WATCHDOG notice — occurrence #18 (first seen 2026-09-12T03:20:21Z, latest 2026-09-30T01:20:19Z).
> The SAME condition (`budget-level-monk-endolin-garden2-5bcdff64-2`) has now been observed 18 times; this is ONE
> coalesced notice that updates in place, not 18 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 monk workers 1 -> 2 (target 2): subscription claude-endolin2 spend=60700822 cap=64000000 pace-bias=0.204405 window-start=2026-09-26T03:00Z(calendar) deadline=2026-09-30T03:00Z(planned) ceiling=4 target=2

- `watchdog-budget-zone-endolin-garden-ece02cb4-backoff` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden-ece02cb4-backoff.md)

> subscription codex-endolin changed zone ok -> backoff at spend=41944294 of cap=100.

- `watchdog-budget-zone-endolin-garden2-5bcdff64-backoff` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden2-5bcdff64-backoff.md)

> subscription codex-endolin changed zone ok -> backoff at spend=11420683 of cap=100.

- `20260929T162945Z-aef3a3` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260929T162945Z-aef3a3.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: activate-ironhorse-ratchet-autopilot-20260929-r4
> - question (msgid msg-activate-ironhorse-ratchet-autopilot-20260929-r4-6c7e0f95aff8.md)
> - tentative answer: Proxy/tentative: Thanks for the update — no gating decision needed here, this reads as a status report. The plan sounds right: let r4 end now so the leader's single monk frees up for deploy-garden.sh, and let the one-time schedule (activate-ironhorse-ratchet-autopilot-20260929-r5, firing 17:15Z) pick up verifying the deployed gates, seeding the first press, and reporting on [kriscendobot/garden#51](https://github.com/kriscendobot/garden/issues/51). Good call building in the self-reschedule if the leader still hasn't deployed by then rather than blocking. Retiring the legacy ironhorse-ratchet schedule in favor of this one is fine to proceed with. No action needed from me — proceed as planned; the maintainer can revise if they see this differently.

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

- `watchdog-worker-derotate-oros-studio-garden-ce242c49` — from watchdog:worker-derotate, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-worker-derotate-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-29T22:20:09Z, latest 2026-09-30T02:35:11Z).
> The SAME condition (`worker-derotate-oros-studio-garden-ce242c49`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 3377s (offline threshold 1800s; sampled_at_epoch=1790732327).
> worker-derotate zeroed its config/worker-leveling caps (were 4 0 monk cleric) so budget-level stops reserving fleet slots for it; the exact prior caps are recorded in journal worker-derotate/oros-studio-garden-ce242c49. When its budget/live heartbeat is fresh again the caps are restored automatically and this notice closes. To keep it out regardless, set its row by hand (any value other than 0 0 relinquishes the marker; delete the marker to keep 0 0). (leader=endolin-garden-ece02cb4)

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-0` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-0.md)

> WATCHDOG notice — occurrence #4 (first seen 2026-09-13T14:20:13Z, latest 2026-09-29T01:20:18Z).
> The SAME condition (`budget-level-cleric-endolin-garden2-5bcdff64-0`) has now been observed 4 times; this is ONE
> coalesced notice that updates in place, not 4 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 cleric workers 1 -> 0 (target 0): shared codex subscription demand active=0 queue=1 quota=ok fleet-envelope=1 target=0

- `watchdog-budget-level-monk-endolin-garden2-5bcdff64-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden2-5bcdff64-1.md)

> WATCHDOG notice — occurrence #15 (first seen 2026-09-26T03:06:05Z, latest 2026-09-30T02:20:20Z).
> The SAME condition (`budget-level-monk-endolin-garden2-5bcdff64-1`) has now been observed 15 times; this is ONE
> coalesced notice that updates in place, not 15 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 monk workers 2 -> 1 (target 1): subscription claude-endolin2 spend=61953641 cap=64000000 pace-bias=0.159611 window-start=2026-09-26T03:00Z(calendar) deadline=2026-09-30T03:00Z(planned) ceiling=4 target=1

- `watchdog-journal-contention-watch-overrun` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-watch-overrun.md)

> Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 51 of 638 clone(s) on consecutive ticks.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-4` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-4.md)

> budget-level changed endolin-garden-ece02cb4 cleric workers 3 -> 4 (target 4): shared codex subscription demand active=2 queue=3 quota=ok fleet-envelope=5 target=4

- `watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-endolin-garden-ece02cb4.md)

> root repo /home/kris/garden deploy has been STALLED for ~0d / 25 commits behind (leader commits-fuse 25): deployed sha e036bb8e0650b66a4ae00dc1516c4c8df39901ca is 25 commit(s) behind origin/main2 (9bf25f4362f9638313fdd55875bd218b11557d47) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. This host is the LEADER: it runs every singleton producer (foreman, scheduler, watchers), so while it is stale it is NOT honoring any directive newer than its deployed sha — a PROJECT PAUSE among them. This is the shape that let a stale leader run ~60 IronHorse fuzz jobs a week after the 09-09 pause (designs/project-pause-enforcement.md). DEPLOY IT. (host=endolin-garden-ece02cb4)

- `watchdog-comment-provenance-gap-endolin-garden-ece02cb4` — from watchdog:comment-provenance, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-provenance-gap-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #9 (first seen 2026-09-29T00:26:19Z, latest 2026-09-30T04:11:08Z).
> The SAME condition (`comment-provenance-gap-endolin-garden-ece02cb4`) has now been observed 9 times; this is ONE
> coalesced notice that updates in place, not 9 messages. Latest detail:
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

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-3` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-3.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-12T03:35:10Z, latest 2026-09-28T08:11:20Z).
> The SAME condition (`budget-level-monk-endolin-garden-ece02cb4-3`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 monk workers 2 -> 3 (target 3): subscription claude-endolin1 spend=42821049 cap=143000000 pace-bias=0.020559 ceiling=4 target=3

- `watchdog-budget-level-monk-oros-studio-garden-ce242c49-4` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-oros-studio-garden-ce242c49-4.md)

> budget-level changed oros-studio-garden-ce242c49 monk workers 3 -> 4 (target 4): subscription claude-oros spend=842330 cap=73000000 pace-bias=1.000000 window-start=2026-09-23T06:59Z(calendar) deadline=2026-09-30T06:59Z(calendar) ceiling=4 target=4

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

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.

- `doomed-retire-gardener-worker-kind-alias-env-fallback-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-retire-gardener-worker-kind-alias-env-fallback-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/retire-gardener-worker-kind-alias-env-fallback; it stays HELD until a human promotes it
> (promote-plan.sh retire-gardener-worker-kind-alias-env-fallback) or removes it, so nothing is lost.
> Original job base: retire-gardener-worker-kind-alias-env-fallback
>
> --- original job body ---
> ---
> tier: mentor
> token-budget: 100000
> ---
> <!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-29T20:19:07Z cleared=none -->
>
> ---
> tier: mentor
> fallback-tier: minion
> token-budget: 100000
> dispatch: automatic
> ---
> Child 1/2 of orchestration `retire-gardener-worker-kind-alias-split` (split of
> `retire-gardener-worker-kind-alias` after a 2400s deadline overrun).
>
> Context: the bulk of the legacy `gardener` worker-kind retirement already landed on
> `main2` in commit `02513cd130f` ("refactor(jobs): retire gardener worker kind":
> common.sh registry/decoder, handlers/gardener-claude.sh + set-gardeners.sh +
> migrate-host-to-monk.sh deleted, reputation-reduce dual projection dropped,
> install-units RETIRED_UNITS prunes `garden-gardener@.service`, compat/cutover tests
> removed). `journal/hosts/*` no longer carry a `gardeners:` line. DO NOT redo that work.
>
> Scope of THIS child: remove the residual legacy env alias `GARDEN_GARDENER_CLONE`
> and stale `gardener-claude.sh` references, keeping `GARDEN_WORKER_CLONE` only.
>
> - Fallback readers: `claim-job.sh:~188`, `complete-job.sh:~39`, `gardener.sh:~74-78`
>   (stop exporting `GARDEN_GARDENER_CLONE`), `usage-meter.sh` (~130/503/523),
>   `usage-append.sh:11` (reads ONLY the legacy var — switch it to
>   `GARDEN_WORKER_CLONE`, and check `GARDEN_GARDENER_ID` vs the spine's id var).
> - Library scripts that read ONLY the legacy var (switch to `GARDEN_WORKER_CLONE`, or
>   the break is silent): `regenerate-topics-counts.sh`, `regenerate-sections-index.sh`,
>   `library-slug-prefix-check.sh`, `library-link-check.sh` (help text too); comment in
>   `auction.sh:~123`.
> - Stale comments naming `gardener-claude.sh` → `monk-claude.sh`: `common.sh`
>   (~3840, ~8867, ~9061), `gardener.sh` (~532, ~1241), `ensure-project-worktree.sh`
>   (~23, ~35), `handlers/cleric-codex.sh` (~202).
> - Tests under `scripts/jobs/test/` that set `GARDEN_GARDENER_CLONE` (grep; e.g.
>   run-test.sh, model-routing, qwen-mentor-trial, fetch-timeout, flat-provider-censor,
>   gardener-claude-tier-serving, host-requirements-gating, live-budget-admission,
>   deadline-nudge, gardener-worktree, auction-reputation, kimi-*, canary-probe-claim-
>   priority): retarget to `GARDEN_WORKER_CLONE`. Optionally rename
>   `gardener-claude-tier-serving-test.sh` → `monk-claude-...` if its name refers to the
>   deleted handler.
> - Final `grep -rn GARDEN_GARDENER_CLONE scripts` must be empty (except a deliberate
>   regression assertion, if you add one).
>
> Run the regression sweep (scaler/deploy/reaper/handler/health/worker-spine/
> auction-reputation suites plus every test you touched) and report which needed
> updating vs already passed. Land directly on `main2`.
>
> Orchestrated failure contract: if you finish but cannot achieve the outcome, end your
> report with `<<<GARDEN-ORCHESTRATION-FAILED>>>` then `<<<GARDEN-JOB-COMPLETE>>>`.

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
| Claude | 190.6M | $1254.75 _(notional, rate-card)_ | 74% of 256.0M (ok) |
| Codex | 16.4M _(fleet aggregate)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 66% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 66405023 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 4.893726s/45s (/home/kris/garden/.garden-state/receipt-watcher/journal-kriscendobot-vattr97); 1 open notice(s); checker healthy

## Board
### todo (28)
- [`endojs-endo-but-for-bots-pr1349-gauntlet-20260930-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1349-gauntlet-20260930-panel-3.md) — Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1349
- [`book-ch3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/book-ch3.md) — Garden book, chapter 3: Using the garden
- [`conduct-kriscendobot-minion-town-pr135-approved-20260930`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/conduct-kriscendobot-minion-town-pr135-approved-20260930.md) — Conduct kriscendobot/minion.town#135 (APPROVED by kriskowal)
- [`book-ch2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/book-ch2.md) — Garden book, chapter 2: Architecture and operation
- [`book-ch7`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/book-ch7.md) — Garden book, chapter 7: Procedures and workflows
- [`endojs-endo-but-for-bots-pr695-6b37106d`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr695-6b37106d.md) — attention directive on endojs/endo-but-for-bots PR #695
- [`fix-subscription-used-percent-per-subscription`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/fix-subscription-used-percent-per-subscription.md) — ---
- [`design-accountant-role-budget-apportionment`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/design-accountant-role-budget-apportionment.md) — Design: carve an accountant role out of budgeting responsibilities scattered ...
- [`endojs-endo-but-for-bots-pr695-5e067785`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr695-5e067785.md) — attention directive on endojs/endo-but-for-bots PR #695
- [`book-ch6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/book-ch6.md) — Garden book, chapter 6: Skills reference (exacting detail)
- [`fu-minion-town-containment-gateway-endo-sock-1-20260930-015006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/fu-minion-town-containment-gateway-endo-sock-1-20260930-015006.md) — Deliberate overrun decomposition for fu-minion-town-containment-gateway-endo-...
- [`endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1380
- [`minion-town-clip-gutter-default-landing`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/minion-town-clip-gutter-default-landing.md) — build: make the clip gutter the real minion.town landing (kriscendobot/minion...
- [`claude-on-minion-town-press-20260930-033506`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/claude-on-minion-town-press-20260930-033506.md) — Press the Claude-on-minion.town arc forward
- [`book-ch4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/book-ch4.md) — Garden book, chapter 4: Creating your own instance
- [`issue-kriscendobot-garden-117`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/issue-kriscendobot-garden-117.md) — Issue from dckc on kriscendobot/garden #117
- [`endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1379
- [`improve-comment-watcher-expected-classify-status`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/improve-comment-watcher-expected-classify-status.md) — ---
- [`kriscendobot-garden-pr75-conduct-20260930`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/kriscendobot-garden-pr75-conduct-20260930.md) — Conduct kriscendobot/garden PR #75
- [`kriscendobot-minion.town-pr91-0aac718f`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/kriscendobot-minion.town-pr91-0aac718f.md) — attention directive on kriscendobot/minion.town PR #91
- [`endojs-endo-but-for-bots-pr1357-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1357-gauntlet-panel-4.md) — Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1357
- [`fix-subscription-model-deploy-gate-regression`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/fix-subscription-model-deploy-gate-regression.md) — Fix deploy-gate regression from subscription-based-budget-model
- [`endojs-endo-but-for-bots-pr1355-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1355-gauntlet-viability.md) — Gauntlet stage: PRE-SPEND VIABILITY - endojs/endo-but-for-bots PR #1355
- [`design-minion-town-guest-coupons`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/design-minion-town-guest-coupons.md) — Design: guest-account coupons carried by invitations (minion.town growth gove...
- [`endojs-endo-but-for-bots-pr1116-review-replies-f7b82cb`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1116-review-replies-f7b82cb.md) — Post review replies on endojs/endo-but-for-bots#1116 (handoff from oros-studi...
- [`endojs-endo-but-for-bots-pr1343-review-0d84baf9`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1343-review-0d84baf9.md) — Review directive on endojs/endo-but-for-bots PR #1343
- [`endojs-endo-but-for-bots-pr1383-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1383-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1383
- [`book-ch1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/book-ch1.md) — Garden book, chapter 1: Philosophy, history, and metamorphosis

### doin (6)
- [`research-endo-progress-report-ocap-site-20260930`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/research-endo-progress-report-ocap-site-20260930.md) — Roll up an Endo progress report and publish it as an HTML ocap.site clip
- [`npm-minion-town-arc-supervisor-20260930`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/npm-minion-town-arc-supervisor-20260930.md) — Supervise the npm.minion.town dev-registry arc to a validated deploy (mentat)
- [`design-minion-town-clip-lifecycle-capabilities`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/design-minion-town-clip-lifecycle-capabilities.md) — Design: clip lifecycle authority as capabilities (kriscendobot/minion.town)
- [`endojs-endo-but-for-bots-pr1116-review-70b9d56c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1116-review-70b9d56c.md) — Review directive on endojs/endo-but-for-bots PR #1116
- [`kriscendobot-garden-pr75-review-6b5f570b`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/kriscendobot-garden-pr75-review-6b5f570b.md) — Review directive on kriscendobot/garden PR #75
- [`endo-daemon-idempotent-start-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endo-daemon-idempotent-start-build.md) — Endo daemon: idempotent start + early single-instance lock (phase 1)

### tada (9840)
- [`canary-probe-endolin-garden2-5bcdff64-2a5c1991779c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/canary-probe-endolin-garden2-5bcdff64-2a5c1991779c.md) — rolling-deploy canary probe — round trip OK
- [`book-ch8`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/book-ch8.md) — Cost
- [`minion-town-npm-registry-pr134-postmerge-reconcile`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/minion-town-npm-registry-pr134-postmerge-reconcile.md) — Cost
- [`endojs-endo-but-for-bots-pr1124-gauntlet-20260930`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/endojs-endo-but-for-bots-pr1124-gauntlet-20260930.md) — gauntlet endojs-endo-but-for-bots-pr1124-gauntlet-20260930 — HALTED
- [`book-ch5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/book-ch5.md) — book-ch5 completion report
- … and 9835 more

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
- [`endo-cli-no-autostart-exit-codes-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-cli-no-autostart-exit-codes-build.md) - [Design OQ1/OQ3: should the CLI default to no-autostart under a service manager, and are the proposed exit codes acceptable?](https://github.com/endojs/endo-but-for-bots/pull/1383)
- [`ironhorse-test262-ratchet-round3-floor-resolution-20260928`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-test262-ratchet-round3-floor-resolution-20260928.md) - [Reconcile the historical floor with current verdict/resource policy, or restore all 901 genuinely under unchanged pins and policy?](https://github.com/kriscendobot/garden/issues/51#issuecomment-5877917421)
- [`minion-town-pr87-production-gate-resume-20260922`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-pr87-production-gate-resume-20260922.md) - [PR #87 production-reality gate: which backend is the production provider (CLI/Agent-SDK; re-run failed SDK track first?), proceed before endo#1015 lands or gate on it, and what counts as production evidence + are credentials provided?](https://github.com/kriscendobot/minion.town/pull/87#issuecomment-5770203120)
- [`endo-daemon-orphan-safe-stop-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-daemon-orphan-safe-stop-build.md) - [Design OQ2: should run-daemon run the manager in-process, or keep the child process and forward signals?](https://github.com/endojs/endo-but-for-bots/pull/1383)
- [`ironhorse-computron-benchmark-baseline-build-after-approval`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-computron-benchmark-baseline-build-after-approval.md) - [Will the maintainer lift the Ironhorse pause, approve design PR #1283 (or direct an early build), and answer its six open questions (or direct the recommended defaults)?](https://github.com/endojs/endo-but-for-bots/pull/1283)

### deferred (top by priority; foreman auto-promotes when idle)
- [`retire-gardener-worker-kind-alias-env-fallback`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/retire-gardener-worker-kind-alias-env-fallback.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1116-review-70b9d56c-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1116-review-70b9d56c-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1116 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1343-review-0d84baf9-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1343-review-0d84baf9-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1343 (primary: endojs-endo-but-...
- [`kriscendobot-garden-pr75-review-6b5f570b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr75-review-6b5f570b-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #75 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-minion.town-pr85-review-9f17a419-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr85-review-9f17a419-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #85 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr90-d6a72a2f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr90-d6a72a2f-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #90 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr135-review-e4d01640-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr135-review-e4d01640-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #135 (primary: kriscendobot-mini...
- [`endojs-endo-but-for-bots-pr695-5e067785-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr695-5e067785-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #695 (primary: endojs-endo-but-f...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`endo-minion-town-federation-release-gate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-minion-town-federation-release-gate.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1124` · Gate: reviewed and deployable federation release
- [`verify-ironhorse-press-first-engagement-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ironhorse-press-first-engagement-20260929.md) — awaiting `ironhorse-test262-press-20260929-173306` · Verify the first live Ironhorse foreman-press engagement (successor of activa...
- [`garden-book-assemble-publish`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-book-assemble-publish.md) — awaiting `garden-book-orch` · Assemble and publish the garden book
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
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 1 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 4 monks
