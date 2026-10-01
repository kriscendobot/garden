# Garden bulletin

_As of 2026-10-01T18:40:33Z_

## Latest

Gauntlet machinery moved several endo-but-for-bots PRs forward — [#1403](https://github.com/endojs/endo-but-for-bots/pull/1403), #1390, #1391, #1392, #1393, #1396, #1397, #1398, #1404, #1407, and #1410 all progressed through panel/fix/clean stages — but two stalled on genuine review disagreement rather than mechanical failure: [#1390](https://github.com/endojs/endo-but-for-bots/pull/1390) (petname-path-only sweep) and the IronHorse panic host-call PR each hit the 6-round review budget without converging, so both are sitting ready for a human merge call. Two gauntlets halted outright and need attention: layer5 CAPTP wire work on PR #1391/#1396 returned an unexpected "handed-off" result from the undraft stage, and layer1 shim build on [#774](https://github.com/endojs/endo-but-for-bots/pull/774) doom-parked after a fix round failed in a way the system can't classify as transient.

Separately, the Claude-backends inference build (`build-endo-claude-backends-1357`) stalled for two hours and halted its orchestration — phase 1 opened a clean, CI-green draft at [#1403](https://github.com/endojs/endo-but-for-bots/pull/1403) but never got an automatic gauntlet (cause unclear, possibly a probe-exemption misfire), so it's sat unreviewed since early morning while phase 2 waited on it. On infrastructure: a rolling-deploy canary on oros-studio-garden-ce242c49 failed three straight retries and is now parked in a drained, held state awaiting a decision, and that same host also went heartbeat-offline for an extended stretch (now recovered). The accountant's budget conversation and the minion.town MCP widening decision (principal/scoping questions) both remain parked awaiting your go-ahead, alongside the usual pile of design PRs — [#1282](https://github.com/endojs/endo-but-for-bots/pull/1282), [#1281](https://github.com/endojs/endo-but-for-bots/pull/1281), and others — waiting on review.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#1282](https://github.com/endojs/endo-but-for-bots/pull/1282) — chore(ironhorse): demolish the XS-computron-parity myth (waiting 4d)
- [endojs/endo-but-for-bots#1281](https://github.com/endojs/endo-but-for-bots/pull/1281) — fix(ses): silence lockdown intrinsics report for the WHATWG URL family (waiting 13d)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 19d)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 28d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 29d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 29d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 29d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 29d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 30d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 33d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Screened by proxy (minion.town)

(delegation not armed)

## Messages to the maintainer

- `watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #81 (first seen 2026-10-01T01:32:11Z, latest 2026-10-01T18:38:05Z).
> The SAME condition (`rolling-deploy-host-offline-oros-studio-garden-ce242c49`) has now been observed 81 times; this is ONE
> coalesced notice that updates in place, not 81 messages. Latest detail:
>
> Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 1852s (offline threshold 1800s; sampled_at_epoch=1790878032).
> The authority is budget/live/<pool>/oros-studio-garden-ce242c49, refreshed periodically; fleet/health/oros-studio-garden-ce242c49 is
> not a heartbeat and was intentionally ignored. Rolling deploy will SKIP this peer:
> no release token, deploy budget, failed-canary count, or halt. Restore the host and
> its heartbeat to rejoin automatically. If hosts/oros-studio-garden-ce242c49 was archived, unarchive it as a
> separate operator decision; this watchdog never reverses decommissioning. (leader=endolin-garden-ece02cb4)

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_foreman_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_foreman_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_foreman_journal` has CLEARED (first seen 2026-10-01T17:28:40Z, cleared 2026-10-01T17:33:27Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_foreman_journal` cleared on endolin-garden-ece02cb4.

- `watchdog-rolling-deploy-no-canary-endolin-garden-ece02cb4` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-no-canary-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #56 (first seen 2026-09-30T23:36:06Z, latest 2026-10-01T16:05:07Z).
> The SAME condition (`rolling-deploy-no-canary-endolin-garden-ece02cb4`) has now been observed 56 times; this is ONE
> coalesced notice that updates in place, not 56 messages. Latest detail:
>
> Rolling deploy is HOLDING the leader: every configured follower is OFFLINE or
> operator-drained, so there is no canary to validate 697976e718f3. The leader will
> not advance unvalidated. Restore any offline host until budget/live heartbeats resume,
> or lift an operator drain. An archived host additionally needs a separate operator
> unarchive; this roll never reverses archival. (leader=endolin-garden-ece02cb4, offline=1)

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_fork_watch_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_fork_watch_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_fork_watch_journal` has CLEARED (first seen 2026-10-01T06:53:30Z, cleared 2026-10-01T07:02:56Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_fork_watch_journal` cleared on endolin-garden-ece02cb4.

- `msg-accountant-budget-conversation-20260930-5c94e3563d64` — from gardener:accountant-budget-conversation-20260930, reply_to `accountant-budget-conversation-20260930` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-accountant-budget-conversation-20260930-5c94e3563d64.md)

> Accountant: I got no reply within ~20 min, so the budget conversation is parked as the go-ahead plan `accountant-budget-conversation-20260930-resume`, which carries the full proposal. When you are ready, reply to the opening message or say "go ahead" on that plan, and the accountant will pick the conversation up. Nothing has been applied. Until then, the 2026-09-26 mandate and the current foreman behavior stand.

- `gauntlet-followups-ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-5` — from gardener:ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-5, reply_to `ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-5` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/gauntlet-followups-ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-5.md)

> Gauntlet stage "ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-5" ("ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet", stage "fix") completed and reported additional follow-ups that require maintainer disposition. The deterministic gauntlet driver owns only the next-panel transition; this escalation was forwarded before the child completed.
>
> ## Follow-ups
>
> `ci-wait-merge.sh` reads every check entry on the commit rather than the latest result for each check name. Any cancelled run left on the same commit therefore makes CI read red even when all live checks pass. This is worth fixing in the garden.

- `build-endo-claude-sandbox-bwrap-slice-gauntlet-halted` — from gauntlet:build-endo-claude-sandbox-bwrap-slice-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-endo-claude-sandbox-bwrap-slice-gauntlet-halted.md)

> Gauntlet build-endo-claude-sandbox-bwrap-slice-gauntlet HALTED: stage 'build-endo-claude-sandbox-bwrap-slice-gauntlet-fix-2' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `msg-claude-on-minion-town-completion-press-20261001-083506-6f8b8cdde366` — from gardener:claude-on-minion-town-completion-press-20261001-083506, reply_to `claude-on-minion-town-completion-press-20261001-083506` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-claude-on-minion-town-completion-press-20261001-083506-6f8b8cdde366.md)

> Arc [kriscendobot/garden#89](https://github.com/kriscendobot/garden/issues/89) completion press, 09:20Z tick, one finding.
>
> **build-endo-inference-seam-1357** completed at 05:23Z and opened draft [endojs/endo-but-for-bots#1403](https://github.com/endojs/endo-but-for-bots/issues/1403) (`@endo/inference`, phase 1 of `designs/endo-claude-inference-backends.md`). Every builder completion should stage a gauntlet automatically. This one didn't: there is no `build-endo-inference-seam-1357-gauntlet` in jobs/gauntlet, gauntlet-archived, todo or plan. [endojs/endo-but-for-bots#1403](https://github.com/endojs/endo-but-for-bots/issues/1403) is now CI-green, CLEAN and still draft, with no review path. The 07:05Z arc press also saw that it had no gauntlet job. I couldn't find the cause: the auto-gauntlet-handoff.sh output went to a temporary capture file that has since been deleted. The PR's author, state and draft status all qualify. My best guess is the probe exemption, a grep for "probe" in the job file. The job body cites the [endojs/endo-but-for-bots#1369](https://github.com/endojs/endo-but-for-bots/issues/1369) prototype, and the PR body says "after the probe".
>
> What it blocks: phase 2, `build-endo-claude-backends-1357`, is the serial child 2/2 of `build-endo-inference-1357-orch` and stacks on [endojs/endo-but-for-bots#1403](https://github.com/endojs/endo-but-for-bots/issues/1403). It has been waiting in todo since 05:25Z, unclaimed for about 4h. That isn't idle workers: the leader's 3 monks are all busy, garden2 is operator-drained and oros is roll-drained.
>
> Suggested action, your decision: run the gauntlet on [endojs/endo-but-for-bots#1403](https://github.com/endojs/endo-but-for-bots/issues/1403). I have not posted it. Otherwise the arc is nominal: 0 doomed, 0 absent, 0 policy-refusal, 0 requeue cycles over 1.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_triager_pace_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_triager_pace_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_triager_pace_journal` has CLEARED (first seen 2026-10-01T17:03:54Z, cleared 2026-10-01T17:54:14Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_triager_pace_journal` cleared on endolin-garden-ece02cb4.

- `watchdog-comment-ack-blind-endojs-endo-but-for-bots` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-ack-blind-endojs-endo-but-for-bots.md)

> RECOVERED — the watchdog condition `comment-ack-blind-endojs-endo-but-for-bots` has CLEARED (first seen 2026-10-01T07:38:08Z, cleared 2026-10-01T13:43:20Z).
> It was observed 35 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Comment acknowledgment condition cleared.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_leader_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_leader_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_leader_journal` has CLEARED (first seen 2026-10-01T05:23:19Z, cleared 2026-10-01T06:43:54Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_leader_journal` cleared on endolin-garden-ece02cb4.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_repo_watcher_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_repo_watcher_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_repo_watcher_journal` has CLEARED (first seen 2026-10-01T06:44:01Z, cleared 2026-10-01T07:08:48Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_repo_watcher_journal` cleared on endolin-garden-ece02cb4.

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-2.md)

> budget-level changed endolin-garden-ece02cb4 monk workers 3 -> 2 (target 2): subscription claude-endolin1 spend=130432427 cap=256000000 pace-bias=0 window-start=2026-09-30T19:40Z(observed) deadline=2026-10-03T03:00Z(calendar) ceiling=4 target=2

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_comment_watcher_verify` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_comment_watcher_verify.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_comment_watcher_verify` has CLEARED (first seen 2026-10-01T12:39:00Z, cleared 2026-10-01T13:43:35Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_comment_watcher_verify` cleared on endolin-garden-ece02cb4.

- `watchdog-worker-derotate-oros-studio-garden-ce242c49` — from watchdog:worker-derotate, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-worker-derotate-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `worker-derotate-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-10-01T01:50:11Z, cleared 2026-10-01T15:35:11Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> heartbeat resumed for oros-studio-garden-ce242c49 (heartbeat fresh (369s old; sampled_at_epoch=1790868536)); it is PRESENT again and its config/worker-leveling caps are restored to 4 0 (monk cleric), so budget-level will apportion it workers again. (leader=endolin-garden-ece02cb4)

- `watchdog-comment-watcher-stuck-cooldown-host` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-watcher-stuck-cooldown-host.md)

> RECOVERED — the watchdog condition `comment-watcher-stuck-cooldown-host` has CLEARED (first seen 2026-10-01T13:43:25Z, cleared 2026-10-01T13:48:23Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Comment acknowledgment condition cleared.

- `watchdog-journal-contention-watch-overrun` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-watch-overrun.md)

> WATCHDOG notice — occurrence #22 (first seen 2026-10-01T04:12:22Z, latest 2026-10-01T18:34:12Z).
> The SAME condition (`journal-contention-watch-overrun`) has now been observed 22 times; this is ONE
> coalesced notice that updates in place, not 22 messages. Latest detail:
>
> Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 89 of 900 clone(s) on consecutive ticks.

- `watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #3 (first seen 2026-10-01T06:26:07Z, latest 2026-10-01T16:17:11Z).
> The SAME condition (`rolling-deploy-canary-failed-oros-studio-garden-ce242c49`) has now been observed 3 times; this is ONE
> coalesced notice that updates in place, not 3 messages. Latest detail:
>
> Rolling deploy HALTED on a failed canary.
> canary host: oros-studio-garden-ce242c49
> target sha:  697976e718f354af3b121874c52a6cdbc8d6c87c
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

- `watchdog-comment-provenance-gap-endolin-garden-ece02cb4` — from watchdog:comment-provenance, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-provenance-gap-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #8 (first seen 2026-09-30T22:38:06Z, latest 2026-10-01T17:41:06Z).
> The SAME condition (`comment-provenance-gap-endolin-garden-ece02cb4`) has now been observed 8 times; this is ONE
> coalesced notice that updates in place, not 8 messages. Latest detail:
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

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal` has CLEARED (first seen 2026-10-01T09:53:44Z, cleared 2026-10-01T10:23:20Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal` cleared on endolin-garden-ece02cb4.

- `endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached` — from gauntlet:endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached.md)

> INFO: Gauntlet endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-halted` — from gauntlet:ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-halted.md)

> Gauntlet ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet HALTED: undraft stage reported unexpected result 'handed-off'

- `watchdog-preflight-gather-fail-endojs-endo-but-for-bots` — from watchdog:pr-feedback-preflight, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-preflight-gather-fail-endojs-endo-but-for-bots.md)

> pr-feedback-preflight could not gather evidence for [endojs/endo-but-for-bots#1371](https://github.com/endojs/endo-but-for-bots/issues/1371) (cid=5925033783) and failed open.
> This is a tool/transport failure, not a no-evidence finding — real feedback may
> have been processed WITHOUT the peer-resolution recheck. Reason:
> evidence gathering failed: could not resolve feedback target id 5925033783 on [endojs/endo-but-for-bots#1371](https://github.com/endojs/endo-but-for-bots/issues/1371) (not a review, an inline comment, or a PR conversation comment)
> --- captured stderr ---
> gh: Not Found (HTTP 404)
> gh: API rate limit exceeded for user ID 279080640. If you reach out to GitHub Support for help, please include the request ID C6DA:2C55B:8EB6D7:A0CAFD:6ABDF255 and timestamp 2026-10-01 05:40:37 UTC. For more on scraping GitHub and how it may affect your rights, please review our Terms of Service (https://docs.github.com/en/site-policy/github-terms/github-terms-of-service) (HTTP 403)
> gh: API rate limit exceeded for user ID 279080640. If you reach out to GitHub Support for help, please include the request ID C6E4:249C8F:970F55:A92E30:6ABDF255 and timestamp 2026-10-01 05:40:37 UTC. For more on scraping GitHub and how it may affect your rights, please review our Terms of Service (https://docs.github.com/en/site-policy/github-terms/github-terms-of-service) (HTTP 403)

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_rolling_deploy_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_rolling_deploy_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_rolling_deploy_journal` has CLEARED (first seen 2026-10-01T16:28:54Z, cleared 2026-10-01T17:08:27Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_rolling_deploy_journal` cleared on endolin-garden-ece02cb4.

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.

- `build-endo-inference-1357-orch-halted` — from orchestrator:build-endo-inference-1357-orch-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-endo-inference-1357-orch-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: build-endo-inference-1357-orch
> orchestration-status: halted
> child: build-endo-claude-backends-1357
> failure-kind: handler-timeout
> children-completed: 1
> children-total: 2
> halt-parked-remainder: 
>
> Orchestration build-endo-inference-1357-orch HALTED: child build-endo-claude-backends-1357 stalled in flight for 7210s on host oros-studio-garden-ce242c49 (handler-timeout=7200s, multiplier=1) (serial, on-child-failure=halt). 1/2 done before halt; parked remainder: none

- `msg-fu-qwen-model-watch-20260728-180502-1-20260930-162006-c2728cdbeb52` — from gardener:fu-qwen-model-watch-20260728-180502-1-20260930-162006, reply_to `fu-qwen-model-watch-20260728-180502-1-20260930-162006` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-fu-qwen-model-watch-20260728-180502-1-20260930-162006-c2728cdbeb52.md)

> qwen model watch (weekly schedule `fu-qwen-model-watch-20260728-180502-1`), probe 2026-10-01:
>
> - `ollama.com/library/qwen3.7` → still **404**: the literal trigger did not fire.
> - Upstream seems to have **skipped 3.7**: `ollama.com/library/qwen3.8` → **200**, updated ~6 days ago (tags `27b`, `27b-mlx`, `latest`; "substantial gains across coding, … long-horizon agentic tasks"). So a 3.7 probe may never flip.
> - Context: the local-qwen hermit lane was retired 2026-09-13 (`retire-local-qwen-hermit-lane`), so "reassess the local lane" now means "is qwen3.8 reason enough to revive it (or to trial `qwen3.8:cloud` on the friar/ollama-cloud arm, which is currently `qwen3.5:cloud`)?"
>
> Decisions for you: (a) post a reassessment job for qwen3.8, (b) point the watch at qwen3.9, or (c) drop the schedule (`set-schedule.sh`) since the lane is retired. I have not changed the schedule.

- `watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-10-01T05:20:02Z, cleared 2026-10-01T17:08:16Z).
> It was observed 147 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> canary oros-studio-garden-ce242c49 is no longer stuck (release 697976e718f354af3b121874c52a6cdbc8d6c87c, deployed e036bb8e0650b66a4ae00dc1516c4c8df39901ca).

- `build-endo-inference-1357-orch-child-build-endo-claude-backends-1357-failed` — from orchestrator:build-endo-inference-1357-orch-child-build-endo-claude-backends-1357-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-endo-inference-1357-orch-child-build-endo-claude-backends-1357-failed.md)

> orchestration-event: orchestration-child-timeout
> orchestration: build-endo-inference-1357-orch
> orchestration-status: running
> child: build-endo-claude-backends-1357
> failure-kind: handler-timeout
> order: serial
> on-child-failure: halt
> detail: stalled in flight for 7210s on host oros-studio-garden-ce242c49 (handler-timeout=7200s, multiplier=1)
>
> Orchestration build-endo-inference-1357-orch observed child build-endo-claude-backends-1357: stalled in flight for 7210s on host oros-studio-garden-ce242c49 (handler-timeout=7200s, multiplier=1).

- `build-endo-guest-scoped-daemon-bootstrap-gauntlet-halted` — from gauntlet:build-endo-guest-scoped-daemon-bootstrap-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-endo-guest-scoped-daemon-bootstrap-gauntlet-halted.md)

> Gauntlet build-endo-guest-scoped-daemon-bootstrap-gauntlet HALTED: stage 'build-endo-guest-scoped-daemon-bootstrap-gauntlet-clean' (clean) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-halted` — from gauntlet:ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-halted.md)

> Gauntlet ebfb-sturdyref-layer1-shim-build-20260930-gauntlet HALTED: stage 'ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-fix-2' (fix) failed 1 times and was doom-parked with doom_signature=requeue-exhausted. It was NOT retried because the record does not prove the underlying handler failure was transient (failure_classification=unknown); repeating an unknown failure would waste the stage budget.


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 156.0M | $1181.57 _(notional, rate-card)_ | 61% of 256.0M (ok) |
| Codex | 18.8M _(fleet aggregate)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 38% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 136750285 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 10.091951s/45s (/home/kris/garden/.garden-state/state-clone-keeper/journal); 1 open notice(s); checker healthy

## Board
### todo (16)
- [`endojs-endo-but-for-bots-pr1403-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1403-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1403
- [`book-copyedit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/book-copyedit.md) — Copy-edit pass on the garden book
- [`ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-panel-6.md) — Gauntlet stage: PANEL round 6 — endojs/endo-but-for-bots PR #1392
- [`ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-6.md) — Gauntlet stage: FIX round 6 — endojs/endo-but-for-bots PR #1396
- [`ebfb-1391-post-panel-5-verdict`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-1391-post-panel-5-verdict.md) — Post the round-5 panel verdict on PR #1391 (endojs/endo-but-for-bots)
- [`build-endo-claude-pinned-cli-bump-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-endo-claude-pinned-cli-bump-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1406
- [`minion-town-pr140-endo-cancel-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/minion-town-pr140-endo-cancel-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — kriscendobot/minion.town PR #146
- [`ebfb-petname-path-only-sweep-4-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-sweep-4-gauntlet-panel-4.md) — Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1390
- [`endojs-endo-but-for-bots-pr1402-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1402-conduct.md) — Finalize (curate -> merge) endojs/endo-but-for-bots PR #1402
- [`ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1393
- [`endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-6.md) — Gauntlet stage: FIX round 6 — endojs/endo-but-for-bots PR #1380
- [`ebfb-774-pr-body-refresh-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-774-pr-body-refresh-20261001.md) — Update the PR #774 description (endojs/endo-but-for-bots)
- [`build-ci-minion-town-actions-runner-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-ci-minion-town-actions-runner-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — kriscendobot/minion.town PR #145
- [`ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1397
- [`ebfb-petname-path-only-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1390
- [`build-endo-claude-broker-catalog-pruning-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-endo-claude-broker-catalog-pruning-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1409

### doin (8)
- [`endojs-endo-but-for-bots-pr1340-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1340-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1340
- [`ebfb-guest-designation-consumers-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-guest-designation-consumers-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1410
- [`ebfb-petname-path-only-sweep-3-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-petname-path-only-sweep-3-gauntlet-panel-6.md) — Gauntlet stage: PANEL round 6 — endojs/endo-but-for-bots PR #1390
- [`ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-5.md) — Gauntlet stage: FIX round 5 — endojs/endo-but-for-bots PR #1391
- [`ebfb-guest-no-identifiers-locators-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-guest-no-identifiers-locators-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1404
- [`endojs-endo-but-for-bots-pr1407-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1407-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1407
- [`build-endo-claude-backends-1357`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/build-endo-claude-backends-1357.md) — Build phase 2 of endo-claude-inference-backends: Claude core and two backends
- [`ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1398

### tada (10299)
- [`endojs-endo-but-for-bots-pr1403-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/endojs-endo-but-for-bots-pr1403-gauntlet-panel-1.md) — Cost
- [`ebfb-1398-pr-body-refresh-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/ebfb-1398-pr-body-refresh-20261001.md) — Cost
- [`ebfb-guest-no-identifiers-locators-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/ebfb-guest-no-identifiers-locators-gauntlet-panel-3.md) — Cost
- [`ebfb-petname-path-only-sweep-3-gauntlet-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/ebfb-petname-path-only-sweep-3-gauntlet-fix-5.md) — Fix round 5 for endojs/endo-but-for-bots PR #1390: all four must-fix items ar...
- [`endojs-endo-but-for-bots-pr1403-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/endojs-endo-but-for-bots-pr1403-gauntlet-clean.md) — Cost
- … and 10294 more

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
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 2 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 3 monks
