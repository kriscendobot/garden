# Garden bulletin

_As of 2026-10-01T05:47:08Z_

## Latest

One guest-capability job moved from the board into progress: `ebfb-guest-no-identifiers-locators` (removing guests' ability to produce or consume formula identifiers and locators) is now claimed and being worked. Elsewhere, the gauntlet machinery finished a review round on [endojs/endo-but-for-bots#1402](https://github.com/endojs/endo-but-for-bots/pull/1402) and spun a `conduct` job to carry it to merge. The PR-1390 petname-path-only line continues grinding through serial fix rounds (sweeps 3 and 4 both active), and the sturdyref layer stack (#1391–#1398) keeps progressing through fix/panel/clean stages in parallel. Two gauntlets stalled out this cycle and need human attention: the sturdyref layer1 shim build on [endojs/endo-but-for-bots#774](https://github.com/endojs/endo-but-for-bots/pull/774) halted after a doom-parked fix round with an unclear failure cause, and the petname-path-only sweep on #1390 hit its 6-round review budget without converging, leaving it CI-green but awaiting a human merge call. Background noise is otherwise routine: a follower host (oros-studio) briefly went heartbeat-stale and self-recovered, the rolling deploy held for lack of a canary during that gap, and a comment-provenance instrumentation gap was logged (cosmetic, non-blocking).

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

> WATCHDOG notice — occurrence #56 (first seen 2026-10-01T01:32:11Z, latest 2026-10-01T05:38:06Z).
> The SAME condition (`rolling-deploy-host-offline-oros-studio-garden-ce242c49`) has now been observed 56 times; this is ONE
> coalesced notice that updates in place, not 56 messages. Latest detail:
>
> Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 1851s (offline threshold 1800s; sampled_at_epoch=1790831230).
> The authority is budget/live/<pool>/oros-studio-garden-ce242c49, refreshed periodically; fleet/health/oros-studio-garden-ce242c49 is
> not a heartbeat and was intentionally ignored. Rolling deploy will SKIP this peer:
> no release token, deploy budget, failed-canary count, or halt. Restore the host and
> its heartbeat to rejoin automatically. If hosts/oros-studio-garden-ce242c49 was archived, unarchive it as a
> separate operator decision; this watchdog never reverses decommissioning. (leader=endolin-garden-ece02cb4)

- `watchdog-rolling-deploy-no-canary-endolin-garden-ece02cb4` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-no-canary-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #25 (first seen 2026-09-30T23:36:06Z, latest 2026-10-01T04:44:12Z).
> The SAME condition (`rolling-deploy-no-canary-endolin-garden-ece02cb4`) has now been observed 25 times; this is ONE
> coalesced notice that updates in place, not 25 messages. Latest detail:
>
> Rolling deploy is HOLDING the leader: every configured follower is OFFLINE or
> operator-drained, so there is no canary to validate c5416eb373bc. The leader will
> not advance unvalidated. Restore any offline host until budget/live heartbeats resume,
> or lift an operator drain. An archived host additionally needs a separate operator
> unarchive; this roll never reverses archival. (leader=endolin-garden-ece02cb4, offline=1)

- `msg-accountant-budget-conversation-20260930-5c94e3563d64` — from gardener:accountant-budget-conversation-20260930, reply_to `accountant-budget-conversation-20260930` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-accountant-budget-conversation-20260930-5c94e3563d64.md)

> Accountant: I got no reply within ~20 min, so the budget conversation is parked as the go-ahead plan `accountant-budget-conversation-20260930-resume`, which carries the full proposal. When you are ready, reply to the opening message or say "go ahead" on that plan, and the accountant will pick the conversation up. Nothing has been applied. Until then, the 2026-09-26 mandate and the current foreman behavior stand.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_leader_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_leader_journal.md)

> Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/leader/journal: packs 1000 >= 1000; size=267677696B packs=1000 gc.log=0; automatic remedy=deferred-deadline.

- `watchdog-worker-derotate-oros-studio-garden-ce242c49` — from watchdog:worker-derotate, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-worker-derotate-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `worker-derotate-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-10-01T01:50:11Z, cleared 2026-10-01T04:20:24Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> heartbeat resumed for oros-studio-garden-ce242c49 (heartbeat fresh (511s old; sampled_at_epoch=1790827893)); it is PRESENT again and its config/worker-leveling caps are restored to 4 0 (monk cleric), so budget-level will apportion it workers again. (leader=endolin-garden-ece02cb4)

- `watchdog-journal-contention-watch-overrun` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-watch-overrun.md)

> RECOVERED — the watchdog condition `journal-contention-watch-overrun` has CLEARED (first seen 2026-10-01T04:12:22Z, cleared 2026-10-01T05:18:18Z).
> It was observed 3 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-contention-watch-overrun` cleared on endolin-garden-ece02cb4.

- `watchdog-comment-provenance-gap-endolin-garden-ece02cb4` — from watchdog:comment-provenance, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-provenance-gap-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #3 (first seen 2026-09-30T22:38:06Z, latest 2026-10-01T04:32:04Z).
> The SAME condition (`comment-provenance-gap-endolin-garden-ece02cb4`) has now been observed 3 times; this is ONE
> coalesced notice that updates in place, not 3 messages. Latest detail:
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

- `ebfb-petname-path-only-sweep-gauntlet-review-budget-reached` — from gauntlet:ebfb-petname-path-only-sweep-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-petname-path-only-sweep-gauntlet-review-budget-reached.md)

> INFO: Gauntlet ebfb-petname-path-only-sweep-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached` — from gauntlet:endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached.md)

> INFO: Gauntlet endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-preflight-gather-fail-endojs-endo-but-for-bots` — from watchdog:pr-feedback-preflight, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-preflight-gather-fail-endojs-endo-but-for-bots.md)

> pr-feedback-preflight could not gather evidence for [endojs/endo-but-for-bots#1371](https://github.com/endojs/endo-but-for-bots/issues/1371) (cid=5925033783) and failed open.
> This is a tool/transport failure, not a no-evidence finding — real feedback may
> have been processed WITHOUT the peer-resolution recheck. Reason:
> evidence gathering failed: could not resolve feedback target id 5925033783 on [endojs/endo-but-for-bots#1371](https://github.com/endojs/endo-but-for-bots/issues/1371) (not a review, an inline comment, or a PR conversation comment)
> --- captured stderr ---
> gh: Not Found (HTTP 404)
> gh: API rate limit exceeded for user ID 279080640. If you reach out to GitHub Support for help, please include the request ID C6DA:2C55B:8EB6D7:A0CAFD:6ABDF255 and timestamp 2026-10-01 05:40:37 UTC. For more on scraping GitHub and how it may affect your rights, please review our Terms of Service (https://docs.github.com/en/site-policy/github-terms/github-terms-of-service) (HTTP 403)
> gh: API rate limit exceeded for user ID 279080640. If you reach out to GitHub Support for help, please include the request ID C6E4:249C8F:970F55:A92E30:6ABDF255 and timestamp 2026-10-01 05:40:37 UTC. For more on scraping GitHub and how it may affect your rights, please review our Terms of Service (https://docs.github.com/en/site-policy/github-terms/github-terms-of-service) (HTTP 403)

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.

- `msg-fu-qwen-model-watch-20260728-180502-1-20260930-162006-c2728cdbeb52` — from gardener:fu-qwen-model-watch-20260728-180502-1-20260930-162006, reply_to `fu-qwen-model-watch-20260728-180502-1-20260930-162006` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-fu-qwen-model-watch-20260728-180502-1-20260930-162006-c2728cdbeb52.md)

> qwen model watch (weekly schedule `fu-qwen-model-watch-20260728-180502-1`), probe 2026-10-01:
>
> - `ollama.com/library/qwen3.7` → still **404**: the literal trigger did not fire.
> - Upstream seems to have **skipped 3.7**: `ollama.com/library/qwen3.8` → **200**, updated ~6 days ago (tags `27b`, `27b-mlx`, `latest`; "substantial gains across coding, … long-horizon agentic tasks"). So a 3.7 probe may never flip.
> - Context: the local-qwen hermit lane was retired 2026-09-13 (`retire-local-qwen-hermit-lane`), so "reassess the local lane" now means "is qwen3.8 reason enough to revive it (or to trial `qwen3.8:cloud` on the friar/ollama-cloud arm, which is currently `qwen3.5:cloud`)?"
>
> Decisions for you: (a) post a reassessment job for qwen3.8, (b) point the watch at qwen3.9, or (c) drop the schedule (`set-schedule.sh`) since the lane is retired. I have not changed the schedule.

- `watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-10-01T05:20:02Z, cleared 2026-10-01T05:38:11Z).
> It was observed 6 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> canary oros-studio-garden-ce242c49 is no longer stuck (release c5416eb373bc4a90cf18dd2563c24044e1ae52a5, deployed e036bb8e0650b66a4ae00dc1516c4c8df39901ca).

- `ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-halted` — from gauntlet:ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-halted.md)

> Gauntlet ebfb-sturdyref-layer1-shim-build-20260930-gauntlet HALTED: stage 'ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-fix-2' (fix) failed 1 times and was doom-parked with doom_signature=requeue-exhausted. It was NOT retried because the record does not prove the underlying handler failure was transient (failure_classification=unknown); repeating an unknown failure would waste the stage budget.


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 86.2M | $672.25 _(notional, rate-card)_ | 34% of 256.0M (ok) |
| Codex | 18.2M _(fleet aggregate)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 38% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 136114020 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 5.124805s/45s (/home/kris/garden/.garden-state/inbox-list/journal); 1 open notice(s); checker healthy

## Board
### todo (20)
- [`endojs-endo-but-for-bots-pr1340-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1340-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1340
- [`book-copyedit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/book-copyedit.md) — Copy-edit pass on the garden book
- [`endojs-endo-but-for-bots-pr1371-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1371-conduct.md) — Finalize (curate -> merge) endojs/endo-but-for-bots PR #1371
- [`ebfb-petname-path-only-pr1390-body-overlap-note`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-pr1390-body-overlap-note.md) — Edit the PR body of endojs/endo-but-for-bots#1390 (panel must-fix 5, integrator)
- [`endojs-endo-but-for-bots-pr1401-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1401-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1401
- [`conduct-endojs-endo-but-for-bots-pr1402-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/conduct-endojs-endo-but-for-bots-pr1402-20261001.md) — Merge endojs/endo-but-for-bots PR #1402
- [`kriscendobot-minion.town-pr140-review-8f6d6ac9`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/kriscendobot-minion.town-pr140-review-8f6d6ac9.md) — Review directive on kriscendobot/minion.town PR #140
- [`build-endo-claude-backends-1357`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-endo-claude-backends-1357.md) — Build phase 2 of endo-claude-inference-backends: Claude core and two backends
- [`endojs-endo-but-for-bots-pr1402-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1402-conduct.md) — Finalize (curate -> merge) endojs/endo-but-for-bots PR #1402
- [`ebfb-petname-path-only-sweep-3-gauntlet-fix-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-sweep-3-gauntlet-fix-4.md) — Gauntlet stage: FIX round 4 — endojs/endo-but-for-bots PR #1390
- [`ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1398
- [`ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4.md) — Gauntlet stage: FIX round 4 — endojs/endo-but-for-bots PR #1391
- [`ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1393
- [`endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-6.md) — Gauntlet stage: FIX round 6 — endojs/endo-but-for-bots PR #1380
- [`ebfb-774-pr-body-refresh-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-774-pr-body-refresh-20261001.md) — Update the PR #774 description (endojs/endo-but-for-bots)
- [`endojs-endo-but-for-bots-pr1402-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1402-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1402
- [`ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-undraft`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-undraft.md) — Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1394
- [`build-ci-minion-town-actions-runner-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-ci-minion-town-actions-runner-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — kriscendobot/minion.town PR #145
- [`ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1397
- [`ebfb-petname-path-only-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1390

### doin (5)
- [`ebfb-petname-path-only-sweep-4-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-petname-path-only-sweep-4-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1390
- [`ebfb-guest-no-identifiers-locators`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-guest-no-identifiers-locators.md) — Remove guests' ability to produce or consume formula identifiers and locators
- [`ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1396
- [`endojs-endo-but-for-bots-pr1390-gauntlet-20261001-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1390-gauntlet-20261001-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1390
- [`ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-4.md) — Gauntlet stage: FIX round 4 — endojs/endo-but-for-bots PR #1392

### tada (10209)
- [`endojs-endo-but-for-bots-pr1402-review-141e965e`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/endojs-endo-but-for-bots-pr1402-review-141e965e.md) — Cost
- [`endojs-endo-but-for-bots-pr1371-3ab5ee33`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/endojs-endo-but-for-bots-pr1371-3ab5ee33.md) — Cost
- [`ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-2.md) — Fix round 2 for endojs/endo-but-for-bots#1396: all six must-fix items applied...
- [`kriscendobot-minion.town-pr140-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/kriscendobot-minion.town-pr140-conduct.md) — Cost
- [`improve-triager-test-git-shim-resolution`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/improve-triager-test-git-shim-resolution.md) — Cost
- … and 10204 more

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
- [`ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-fix-2.md) — _normal_ · Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #774
- [`evaluate-reauth-escalation-default-after-oauth-relay-20260927`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/evaluate-reauth-escalation-default-after-oauth-relay-20260927.md) — _low_ · Evaluate default reauth escalation once the browser OAuth relay lands
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper.md) — _normal_ · Build: SES import attributes — Phase 3 (compartment-mapper plumbing)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`accountant-budget-conversation-20260930-resume`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/accountant-budget-conversation-20260930-resume.md) — _normal_ · ---
- [`build-claude-usage-dashboard-scraper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-claude-usage-dashboard-scraper.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1394-20260930-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1394-20260930-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1394

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

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`ebfb-platform-fs-pet-name-path-only`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-platform-fs-pet-name-path-only.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1390` · ---
- [`endo-minion-town-federation-release-gate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-minion-town-federation-release-gate.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1124` · Gate: reviewed and deployable federation release
- [`verify-ironhorse-press-first-engagement-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ironhorse-press-first-engagement-20260929.md) — awaiting `ironhorse-test262-press-20260929-173306` · Verify the first live Ironhorse foreman-press engagement (successor of activa...
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`build-endo-claude-pinned-cli-bump`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-claude-pinned-cli-bump.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1371` · Build: bump @endo/claude PINNED_CLI_VERSION to the deployed claude CLI
- [`build-endo-guest-scoped-daemon-bootstrap`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-guest-scoped-daemon-bootstrap.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1371` · Build: guest-scoped daemon bootstrap for the confined-turn harness
- [`build-endo-claude-sandbox-bwrap-slice`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-claude-sandbox-bwrap-slice.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1371` · Build: kernel bwrap sandbox slice around claudePath (@endo/claude-sandbox)
- [`build-endo-claude-broker-catalog-pruning`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-claude-broker-catalog-pruning.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1371` · Build: prune the confined tool catalog at the guest broker
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
