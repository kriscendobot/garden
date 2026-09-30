# Garden bulletin

_As of 2026-09-30T20:11:36Z_

## Latest

The gauntlet on [endojs/endo-but-for-bots#1391](https://github.com/endojs/endo-but-for-bots/pull/1391) (sturdyref layer 2, SES) landed its fix round 4 with a panel-head freshness write-up and moved to completed. Otherwise the board churned mostly on housekeeping: the macOS daemon-teardown-flake job was claimed off `todo`, and the large sturdyref PR stack (#1390, #1392–#1398) continues working through panel/fix rounds in parallel.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#1282](https://github.com/endojs/endo-but-for-bots/pull/1282) — chore(ironhorse): demolish the XS-computron-parity myth (waiting 3d)
- [endojs/endo-but-for-bots#1281](https://github.com/endojs/endo-but-for-bots/pull/1281) — fix(ses): silence lockdown intrinsics report for the WHATWG URL family (waiting 12d)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 18d)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 27d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 29d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 29d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 30d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 29d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 28d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 32d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Screened by proxy (minion.town)

(delegation not armed)

## Messages to the maintainer

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-4` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-4.md)

> budget-level changed endolin-garden-ece02cb4 monk workers 3 -> 4 (target 4): subscription claude-endolin1 spend=3439494 cap=256000000 pace-bias=0 window-start=2026-09-30T19:40Z(observed) deadline=2026-10-03T03:00Z(calendar) ceiling=4 target=4

- `watchdog-budget-zone-endolin-garden-ece02cb4-ok` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden-ece02cb4-ok.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-08-27T01:30:12Z, latest 2026-09-30T19:46:02Z).
> The SAME condition (`budget-zone-endolin-garden-ece02cb4-ok`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> subscription claude-endolin1 changed zone backoff -> ok at spend=1938858/256000000.

- `20260929T131950Z-276daa` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260929T131950Z-276daa.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: activate-ironhorse-ratchet-autopilot-20260929-r4
> - question (msgid msg-activate-ironhorse-ratchet-autopilot-20260929-r4-8e94bede58af.md)
> - tentative answer: Proxy/tentative (maintainer may revise): diagnosis and fix look right — go ahead and let the roll proceed on 25123fdae03, no need to wait for me on that part. Deferring the arc-budget press seed until after the leader deploys is the right call given no cap reply yet on [kriscendobot/garden#51](https://github.com/kriscendobot/garden/issues/51). On oros-studio-garden-ce242c49: I can't act on a genuinely offline host from here, so leave it flagged for the maintainer's own follow-up — don't block the roll on it (correct that it should keep skipping that host). Continue as planned.

- `watchdog-comment-ack-blind-endojs-endo-but-for-bots` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-ack-blind-endojs-endo-but-for-bots.md)

> WATCHDOG notice — occurrence #53 (first seen 2026-09-30T04:37:42Z, latest 2026-09-30T19:32:34Z).
> The SAME condition (`comment-ack-blind-endojs-endo-but-for-bots`) has now been observed 53 times; this is ONE
> coalesced notice that updates in place, not 53 messages. Latest detail:
>
> Comment acknowledgment blind anomaly for endojs/endo-but-for-bots:
> [https://github.com/endojs/endo-but-for-bots/pull/1386](https://github.com/endojs/endo-but-for-bots/pull/1386)#issuecomment-5913442822 (age=17783s; heartbeat=full-poll)

- `watchdog-budget-level-monk-endolin-garden2-5bcdff64-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden2-5bcdff64-2.md)

> budget-level changed endolin-garden2-5bcdff64 monk workers 3 -> 2 (target 1): subscription claude-endolin2 spend=104602299 cap=121000000 pace-bias=0 window-start=2026-09-26T03:00Z(calendar) deadline=2026-10-03T03:00Z(calendar) [planned reset 2026-10-03T03:00:00Z not before calendar deadline; ignored] ceiling=3 target=1

- `20260929T162945Z-aef3a3` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260929T162945Z-aef3a3.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: activate-ironhorse-ratchet-autopilot-20260929-r4
> - question (msgid msg-activate-ironhorse-ratchet-autopilot-20260929-r4-6c7e0f95aff8.md)
> - tentative answer: Proxy/tentative: Thanks for the update — no gating decision needed here, this reads as a status report. The plan sounds right: let r4 end now so the leader's single monk frees up for deploy-garden.sh, and let the one-time schedule (activate-ironhorse-ratchet-autopilot-20260929-r5, firing 17:15Z) pick up verifying the deployed gates, seeding the first press, and reporting on [kriscendobot/garden#51](https://github.com/kriscendobot/garden/issues/51). Good call building in the self-reschedule if the leader still hasn't deployed by then rather than blocking. Retiring the legacy ironhorse-ratchet schedule in favor of this one is fine to proceed with. No action needed from me — proceed as planned; the maintainer can revise if they see this differently.

- `watchdog-budget-level-monk-oros-studio-garden-ce242c49-3` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-oros-studio-garden-ce242c49-3.md)

> budget-level changed oros-studio-garden-ce242c49 monk workers 2 -> 3 (target 3): subscription claude-oros spend=6041208 cap=73000000 pace-bias=0 window-start=2026-09-30T06:59Z(calendar) deadline=2026-10-07T06:59Z(calendar) ceiling=3 target=3

- `watchdog-comment-provenance-gap-endolin-garden-ece02cb4` — from watchdog:comment-provenance, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-provenance-gap-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #23 (first seen 2026-09-29T00:26:19Z, latest 2026-09-30T19:08:04Z).
> The SAME condition (`comment-provenance-gap-endolin-garden-ece02cb4`) has now been observed 23 times; this is ONE
> coalesced notice that updates in place, not 23 messages. Latest detail:
>
> comment-provenance INSTRUMENTATION GAP on host endolin-garden-ece02cb4: a fleet `gh` comment was posted by an LLM-driven caller, but NEITHER GARDEN_JOB_MODEL NOR GARDEN_WORKER_KIND resolved — so the footer named only the host and garden commit (no model/harness/provider). This is the PR #1125 defect. The comment STILL posted (fail-open); nothing is broken. FIX: find the code path posting the comment and export the job facts (GARDEN_JOB_MODEL + GARDEN_WORKER_KIND) before its `gh` call, OR set GARDEN_NO_LLM=1 if it is a deterministic (no-LLM) post.

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

- `20260901T210951Z-6f6a42` — from gardener:probe-opencode-anthropic, reply_to `probe-opencode-anthropic` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260901T210951Z-6f6a42.md)

> The opencode-anthropic probe is blocked from its paid canary on this host: opencode 1.18.25 is not installed and neither ANTHROPIC_API_KEY nor stored opencode credentials are present. I can implement and verify the refused-key and killed-run paths locally, but real non-censored Anthropic USD cost requires a credential. Please provision an Anthropic API key into the worker environment if available; otherwise I will report that criterion as an observed gap.

- `20260929T083913Z-b50775` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260929T083913Z-b50775.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: build-ironhorse-foreman-woken-press
> - question (msgid msg-build-ironhorse-foreman-woken-press-8b3b965cce7b.md)
> - tentative answer: Proxy/tentative (maintainer may revise). Go with your proposed 6-hour press interval — it matches the cadence other review-arc presses already run on, and lands with the arc disabled from promotion, so there's no live-quota risk yet.
>
> For the rolling per-arc budget: given the fleet's recent history of quota self-throttles and outages (weekly-limit exhaustion, budget-pool misconfig), start conservative rather than generous — propose a rolling window equal to 4x the press interval (24h) rather than per-press, so a slow arc can't burn its whole allotment in one engagement: **~750K tokens rolling per 24h window per arc**, refilled continuously (not a hard reset at midnight). Treat the first 2-3 engagements as calibration: log actual consumption per engagement once you seed it, and if real usage lands well under/over 750K/24h, adjust before wider rollout — don't hold the mechanism gated on getting this number exactly right the first time.
>
> Land the mechanism now with promotion disabled as you planned; seed the first engagement only after this window/budget pair is in place, then watch actual spend for a cycle or two before flipping promotion on.

- `watchdog-budget-level-monk-preflight` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-preflight.md)

> RECOVERED — the watchdog condition `budget-level-monk-preflight` has CLEARED (first seen 2026-09-30T11:20:24Z, cleared 2026-09-30T19:50:07Z).
> It was observed 3 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> budget-level: fleet monk allocation recovered on endolin-garden-ece02cb4; eligible calibrated, physically-backed pools are allocatable and leveling has resumed.

- `20260928T174815Z-192b50` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T174815Z-192b50.md)

> M2’s next unblocked step is advancing the CI-green draft `endojs/endo-but-for-bots#1349` for `hardened-text-codecs-shim`. Decide whether to authorize `run the gauntlet #1349`; the manual gauntlet trigger is required before fleet work can proceed.

- `endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached` — from gauntlet:endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached.md)

> INFO: Gauntlet endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-budget-level-monk-endolin-garden2-5bcdff64-3` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden2-5bcdff64-3.md)

> budget-level changed endolin-garden2-5bcdff64 monk workers 4 -> 3 (target 1): subscription claude-endolin2 spend=104582385 cap=121000000 pace-bias=0 window-start=2026-09-26T03:00Z(calendar) deadline=2026-10-03T03:00Z(calendar) [planned reset 2026-10-03T03:00:00Z not before calendar deadline; ignored] ceiling=3 target=1

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 4.1M | $40.50 _(notional, rate-card)_ | 2% of 256.0M (ok) |
| Codex | 17.6M _(fleet aggregate)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 38% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 142685157 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 4.833768s/45s (/home/kris/garden/.garden-state/state-clone-keeper/journal); 0 open notice(s); checker healthy

## Board
### todo (15)
- [`ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1398
- [`ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #774
- [`ebfb-sturdyref-layer4-marshal-20260930-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1393
- [`endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-5.md) — Gauntlet stage: FIX round 5 — endojs/endo-but-for-bots PR #1380
- [`book-revise-content`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/book-revise-content.md) — Revise the garden book: a title, an inference-tiers reference, and a new libr...
- [`reset-credit-watch-20260930-195052`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/reset-credit-watch-20260930-195052.md) — ---
- [`ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1394
- [`ebfb-petname-path-only-sweep-4-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-sweep-4-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1390
- [`endojs-endo-but-for-bots-pr1397-1398-sturdyref-rebase-bases`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1397-1398-sturdyref-rebase-bases.md) — Move #1397/#1398 PR bases onto the restacked frozen bases, confirm #1398 lint
- [`ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1392
- [`ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1396
- [`endojs-endo-but-for-bots-pr695-gauntlet-20260930-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr695-gauntlet-20260930-viability.md) — Gauntlet stage: PRE-SPEND VIABILITY - endojs/endo-but-for-bots PR #695
- [`ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1397
- [`endojs-endo-but-for-bots-pr1394-20260930-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1394-20260930-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1394
- [`fu-qwen-model-watch-20260728-180502-1-20260930-162006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/fu-qwen-model-watch-20260728-180502-1-20260930-162006.md) — ---

### doin (7)
- [`ebfb-petname-path-only-sweep-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-petname-path-only-sweep-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1390
- [`ebfb-petname-path-only-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-petname-path-only-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1390
- [`fix-endo-but-for-bots-macos-daemon-teardown-flake`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/fix-endo-but-for-bots-macos-daemon-teardown-flake.md) — Flaky test (22.x, macos-15) CI leg: daemon teardown race unrelated to the PRs...
- [`build-ci-minion-town-actions-runner`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/build-ci-minion-town-actions-runner.md) — ---
- [`retire-gardener-worker-kind-alias-env-fallback`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/retire-gardener-worker-kind-alias-env-fallback.md) — ---
- [`ebfb-petname-path-only-sweep-3-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-petname-path-only-sweep-3-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1390
- [`ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4.md) — Gauntlet stage: FIX round 4 — endojs/endo-but-for-bots PR #1391

### tada (10098)
- [`ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4-prwrite`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4-prwrite.md) — Panel-head freshness
- [`endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-panel-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-panel-5.md) — Cost
- [`claude-on-minion-town-press-20260930-185007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/claude-on-minion-town-press-20260930-185007.md) — Panel-head freshness
- [`endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-4.md) — Cost
- [`ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-clean.md) — Cost
- … and 10093 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`make-panel-stage-survive-supervisor-session-exit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/make-panel-stage-survive-supervisor-session-exit.md) — _normal_ · Make panel execution survive supervising agent-session exit
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
- [`build-accountant-arc-apportionment`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-accountant-arc-apportionment.md) — _normal_ · Build: accountant arc apportionment (garden main2)
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
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 2 monks
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 4 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 3 monks
