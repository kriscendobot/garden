# Garden bulletin

_As of 2026-10-02T00:55:38Z_

## Latest

Closed out several gauntlets and conduct jobs overnight: [endojs/endo-but-for-bots#1116](https://github.com/endojs/endo-but-for-bots/pull/1116) was conducted and weave-completed, but the maintainer-visible disposition is "review required" — the panel's last review covered head `7f2207af` while the presented head has moved to `e70a9604`, so a fresh review pass is needed before any further action on that PR. The sandbox-bwrap-slice gauntlet finished its fix round 3 and is now on to panel round 4, and the PR #1414 gauntlet cleared viability and moved into its clean stage.

Two sturdyref-stack gauntlets stalled and need attention: layer3-pass-style (PR #1392) halted after fix round 6 explicitly declared a failed/declined outcome, and layer6-captp-construct halted after its fix stage failed twice for the same reason — both are sitting idle awaiting a human call. Separately, rolling deploy hit a confirmed, repeatedly-retried canary failure on oros-studio-garden-ce242c49 for release `adb5a10fce18` (3 failed retries) and needs investigation before the fleet can advance; the root checkout on endolin-garden2 is also 16 commits behind and has been stalled on deploy for about a day. The accountant's revised budget slate (re-ranking minion.town work to the top, Endo backlog down to a 2% sliver) is parked awaiting your "approve" — a proxy already deferred it as outside its authority.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#1282](https://github.com/endojs/endo-but-for-bots/pull/1282) — chore(ironhorse): demolish the XS-computron-parity myth (waiting 5d)
- [endojs/endo-but-for-bots#1281](https://github.com/endojs/endo-but-for-bots/pull/1281) — fix(ses): silence lockdown intrinsics report for the WHATWG URL family (waiting 14d)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 20d)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 28d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 30d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 30d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 31d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 30d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 30d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 33d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Screened by proxy (minion.town)

(delegation not armed)

## Messages to the maintainer

- `watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-host-offline-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-10-01T21:08:02Z, cleared 2026-10-02T00:35:05Z).
> It was observed 14 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> heartbeat resumed for oros-studio-garden-ce242c49; it is PRESENT again and will automatically rejoin the canary rotation while its hosts/oros-studio-garden-ce242c49 record remains active. Archived records are not unarchived automatically.

- `watchdog-rolling-deploy-no-canary-endolin-garden-ece02cb4` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-no-canary-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #6 (first seen 2026-09-30T23:36:06Z, latest 2026-10-01T23:32:17Z).
> The SAME condition (`rolling-deploy-no-canary-endolin-garden-ece02cb4`) has now been observed 6 times; this is ONE
> coalesced notice that updates in place, not 6 messages. Latest detail:
>
> Rolling deploy is HOLDING the leader: every configured follower is OFFLINE or
> operator-drained, so there is no canary to validate adb5a10fce18. The leader will
> not advance unvalidated. Restore any offline host until budget/live heartbeats resume,
> or lift an operator drain. An archived host additionally needs a separate operator
> unarchive; this roll never reverses archival. (leader=endolin-garden-ece02cb4, offline=1)

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_orch_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_orch_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_orch_journal` has CLEARED (first seen 2026-10-02T00:49:10Z, cleared 2026-10-02T00:54:31Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_orch_journal` cleared on endolin-garden-ece02cb4.

- `msg-accountant-budget-conversation-20260930-resume-636d6d525ffa` — from gardener:accountant-budget-conversation-20260930-resume, reply_to `accountant-budget-conversation-20260930-resume` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-accountant-budget-conversation-20260930-resume-636d6d525ffa.md)

> **Accountant: revised budget slate (re: your 10-01 answers to `msg-accountant-budget-conversation-20260930-4b156353d3b7`)**
>
> I adjusted the mandate's ranking as you asked. Nothing has been applied, and I'll wait for your OK before I write anything.
>
> **Capacity, refreshed from live samples (~23:30Z 10-01; ceiling = 90%)**
> - claude-endolin1: 69% of 256M since the 09-30 19:40Z reset (179M). About **51M** is usable before Sat 10-03 03:00Z (~27h). Pacing is on track, and it resets to ~230M usable on Saturday.
> - claude-endolin2: 86% and in backoff. Nothing is usable before Sat 03:00Z. Its 1 credit (expires 10-22) stays held for mid-week next week.
> - codex-endolin: 69% (paused per your note). ~5M would be usable before the 10-05 16:46Z reset, so I count it as zero unless you unpause it.
> - claude-oros: back on the sampler. The meter shows 21M of 73M since the Tue 09-29 reset, but the sampler reports 67%, so the two disagree. Counting the lower figure, ~17M is usable before **Tue 10-06 10:00Z** (04:00 MDT). Could you give me one dashboard reading for oros so I can settle which figure is right?
>
> **What the fleet spent since the endolin1 reset (ledger, 21M notional, shares only)**
> Endo backlog **42%**, sturdyref+petname 36%, minion.town **10%**, garden upkeep 5%, ironhorse 3%, other 4%. This is close to the inverse of your ranking, so the slate below is a real correction and not a trim.
>
> **Proposed slate (share of the foreman's discretionary budget; applies to the rest of this week and carries forward after the Sat reset)**
> 1. **minion.town over MCP + OCapN, 30%**. Your top priority.
> 2. **minion.town as a capability git remote, 20%**. Includes `kriscendobot/minion.town#86`.
> 3. **minion.town UI (clip gutter, clip iframe, clips on ocap.site), 15%**.
> 4. **Background Endo/OCapN, 20%** (SturdyRef with removal of the formula-id/locator guest API surface, byte arrays, streams, OCapN). Ranked here for security, not as minion.town work. The in-flight sturdyref stack and petname sweep finish inside this slice.
> 5. **Moonshots (endor, ironhorse, thixotrope, slot machine), 8%**. Enough to keep each one moving. No separate endor slice.
> 6. **Garden upkeep, 5%**. Self-heal, watchdog fixes, and deploys. You didn't rank it, but the fleet can't run without it, so I placed it just above the sliver.
> 7. **Endo backlog sliver, 2%**. Only the gauntlets already staged. The 2026-08 weaves stay parked. In-flight work is never cancelled, so this arc will overspend its 2% for about a day while the staged gauntlets drain.
>
> **Proposed adjusted mandate text (replaces the 09-26 list and keeps its framing)**
> > 1. FIRST: minion.town operational over MCP and OCapN.
> > 2. SECOND: minion.town operational as a capability git remote.
> > 3. THIRD: the minion.town UI, especially the clip gutter and the clip iframe, with clips hosted under ocap.site.
> > 4. BACKGROUND (must keep progressing): Endo SturdyRef (security: retire the formula-identifier/locator guest API surface), byte arrays, streams; OCapN progress.
> > 5. TRAILING MOONSHOTS (alive, behind everything above): endor (metering, explorative), ironhorse, thixotrope, slot machine.
> > 6. SLIVER: the off-mandate endo-but-for-bots backlog, staged gauntlets only.
> > This is discretionary guidance for step selection, not a hard gate, and it supersedes no safety or review discipline.
>
> **To approve:** reply "approve" (or give edits). Then I'll apply it in one `set-apportionment.sh` commit with `authorized_by: kriskowal`, and record it at `projects/garden/budget-slate-20261001.md`.
>
> **One question about the arcs:** should the three minion.town slices be separate arcs as listed, or one `minion-town` arc with the ranking written into its summary? Separate arcs enforce the order. One arc is simpler and lets money move between the three as readiness changes. I recommend **separate** arcs.

- `watchdog-root-repo-deploy-stalled-endolin-garden2-5bcdff64` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-endolin-garden2-5bcdff64.md)

> root repo /home/kris/garden2 deploy has been STALLED for ~1d: deployed sha c63c16cad579f313f26afa1cb752c67cc97f5b6e is 16 commit(s) behind origin/main2 (697976e718f354af3b121874c52a6cdbc8d6c87c) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=endolin-garden2-5bcdff64)

- `ebfb-petname-path-only-sweep-3-gauntlet-review-budget-reached` — from gauntlet:ebfb-petname-path-only-sweep-3-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-petname-path-only-sweep-3-gauntlet-review-budget-reached.md)

> INFO: Gauntlet ebfb-petname-path-only-sweep-3-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_leader_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_leader_journal.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_leader_journal` has CLEARED (first seen 2026-10-01T21:18:52Z, cleared 2026-10-02T00:54:25Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_leader_journal` cleared on endolin-garden-ece02cb4.

- `watchdog-worker-derotate-oros-studio-garden-ce242c49` — from watchdog:worker-derotate, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-worker-derotate-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `worker-derotate-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-10-01T21:35:10Z, cleared 2026-10-02T00:05:11Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> heartbeat resumed for oros-studio-garden-ce242c49 (heartbeat fresh (331s old; sampled_at_epoch=1790899175)); it is PRESENT again and its config/worker-leveling caps are restored to 4 0 (monk cleric), so budget-level will apportion it workers again. (leader=endolin-garden-ece02cb4)

- `watchdog-budget-level-monk-oros-studio-garden-ce242c49-3` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-oros-studio-garden-ce242c49-3.md)

> budget-level changed oros-studio-garden-ce242c49 monk workers 2 -> 3 (target 3): subscription claude-oros spend=21178667 cap=73000000 pace-bias=0.095515 window-start=2026-09-29T10:00Z(calendar) deadline=2026-10-06T10:00Z(calendar) ceiling=4 target=3

- `watchdog-journal-contention-watch-overrun` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-watch-overrun.md)

> RECOVERED — the watchdog condition `journal-contention-watch-overrun` has CLEARED (first seen 2026-10-01T20:53:24Z, cleared 2026-10-02T00:54:40Z).
> It was observed 7 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-contention-watch-overrun` cleared on endolin-garden-ece02cb4.

- `watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #3 (first seen 2026-10-01T16:17:11Z, latest 2026-10-02T00:08:06Z).
> The SAME condition (`rolling-deploy-canary-failed-oros-studio-garden-ce242c49`) has now been observed 3 times; this is ONE
> coalesced notice that updates in place, not 3 messages. Latest detail:
>
> Rolling deploy HALTED on a failed canary.
> canary host: oros-studio-garden-ce242c49
> target sha:  adb5a10fce18263ca54de9d09d201a5757165820
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

> WATCHDOG notice — occurrence #3 (first seen 2026-10-01T21:44:07Z, latest 2026-10-01T23:41:08Z).
> The SAME condition (`comment-provenance-gap-endolin-garden-ece02cb4`) has now been observed 3 times; this is ONE
> coalesced notice that updates in place, not 3 messages. Latest detail:
>
> comment-provenance INSTRUMENTATION GAP on host endolin-garden-ece02cb4: a fleet `gh` comment was posted by an LLM-driven caller, but NEITHER GARDEN_JOB_MODEL NOR GARDEN_WORKER_KIND resolved — so the footer named only the host and garden commit (no model/harness/provider). This is the PR #1125 defect. The comment STILL posted (fail-open); nothing is broken. FIX: find the code path posting the comment and export the job facts (GARDEN_JOB_MODEL + GARDEN_WORKER_KIND) before its `gh` call, OR set GARDEN_NO_LLM=1 if it is a deterministic (no-LLM) post.

- `ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-halted` — from gauntlet:ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-halted.md)

> Gauntlet ebfb-sturdyref-layer3-pass-style-20260930-gauntlet HALTED: stage 'ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-6' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal.md)

> Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: packs 1022 >= 1000; size=250616832B packs=1022 gc.log=0; automatic remedy=deferred-deadline.

- `watchdog-budget-level-monk-oros-studio-garden-ce242c49-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-oros-studio-garden-ce242c49-2.md)

> WATCHDOG notice — occurrence #4 (first seen 2026-09-25T03:50:17Z, latest 2026-10-02T00:05:34Z).
> The SAME condition (`budget-level-monk-oros-studio-garden-ce242c49-2`) has now been observed 4 times; this is ONE
> coalesced notice that updates in place, not 4 messages. Latest detail:
>
> budget-level changed oros-studio-garden-ce242c49 monk workers 3 -> 2 (target 2): subscription claude-oros spend=22586371 cap=73000000 pace-bias=0.077098 window-start=2026-09-29T10:00Z(calendar) deadline=2026-10-06T10:00Z(calendar) ceiling=3 target=2

- `ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-halted` — from gauntlet:ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-halted.md)

> Gauntlet ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet HALTED: stage 'ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-6' (fix) failed 2 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `watchdog-blind-comment-watcher-kriscendobot-test262` — from watchdog:comment-watcher/kriscendobot-test262, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-blind-comment-watcher-kriscendobot-test262.md)

> ANOMALY: comment-watcher/kriscendobot-test262 self-test FAILED on kriscendobot/test262 — the comment source path could not fetch a known-existing comment, so the watcher is likely silently BLIND (the 2026-06-24 jq-outage signature). Check jq/gh on endolin-garden-ece02cb4 and the comment-source handler. This is a POSITIVE proof the source path is broken, NOT a report that the repo is quiet.

- `endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached` — from gauntlet:endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached.md)

> INFO: Gauntlet endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-10-01T22:08:01Z, cleared 2026-10-02T00:32:13Z).
> It was observed 9 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> canary oros-studio-garden-ce242c49 is no longer stuck (release adb5a10fce18263ca54de9d09d201a5757165820, deployed e036bb8e0650b66a4ae00dc1516c4c8df39901ca).

- `20261002T002253Z-10855b` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261002T002253Z-10855b.md)

> awaiting maintainer — beyond proxy authority: gardener accountant-budget-conversation-20260930-resume, msgid msg-accountant-budget-conversation-20260930-resume-636d6d525ffa.md — Budget apportionment / mandate-ranking changes require maintainer authorization (`authorized_by: kriskowal` is explicitly named in the accountant's own plan) — this is a resource-allocation policy decision, not a progress/direction question a proxy may approve.

- `build-endo-claude-backends-1357-open-pr-gauntlet-halted` — from gauntlet:build-endo-claude-backends-1357-open-pr-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-endo-claude-backends-1357-open-pr-gauntlet-halted.md)

> Gauntlet build-endo-claude-backends-1357-open-pr-gauntlet HALTED: stage 'build-endo-claude-backends-1357-open-pr-gauntlet-clean' (clean) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `stale-panel-head-endojs-endo-but-for-bots-pr1116-7f2207af-e70a9604` — from gardener:endojs-endo-but-for-bots-pr1116-conduct, reply_to `endojs-endo-but-for-bots-pr1116-conduct` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/stale-panel-head-endojs-endo-but-for-bots-pr1116-7f2207af-e70a9604.md)

> Stale panel coverage for completed job `endojs-endo-but-for-bots-pr1116-conduct`: [https://github.com/endojs/endo-but-for-bots/pull/1116](https://github.com/endojs/endo-but-for-bots/pull/1116) moved from panel-reviewed head `7f2207af` to presented head `e70a96042289cf593d28de07459cad1fb93ff51c`.
>
> Disposition: **review required**. The earlier panel does not cover the current head; every commit delta is conservatively review-relevant. A PR metadata-only edit would leave the head unchanged and would not trigger this disposition.
>
> No gauntlet was staged. Route the current head through the existing panel stage only after an explicit maintainer `run the gauntlet` request, or make a maintainer review decision with the stale coverage stated explicitly.


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 183.4M | $1369.08 _(notional, rate-card)_ | 72% of 256.0M (ok) |
| Codex | 19.3M _(fleet aggregate)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 38% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 138133916 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 4.755192s/45s (/home/kris/garden/.garden-state/worktree-sweeper/journal); 1 open notice(s); checker healthy

## Board
### todo (28)
- [`revive-hermit-lane-qwen3.8-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/revive-hermit-lane-qwen3.8-20261001.md) — Revive the local hermit (on-box Ollama) lane, upgraded to qwen3.8
- [`book-copyedit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/book-copyedit.md) — Copy-edit pass on the garden book
- [`build-endo-claude-sandbox-bwrap-slice-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-endo-claude-sandbox-bwrap-slice-gauntlet-panel-4.md) — Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1408
- [`endojs-endo-but-for-bots-pr1414-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1414-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1414
- [`endojs-endo-but-for-bots-pr1116-review-d33d67ff`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1116-review-d33d67ff.md) — Review directive on endojs/endo-but-for-bots PR #1116
- [`fix-oros-heartbeat-canary-drain-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/fix-oros-heartbeat-canary-drain-20261001.md) — ---
- [`ebfb-petname-path-only-sweep-4-gauntlet-panel-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-sweep-4-gauntlet-panel-5.md) — Gauntlet stage: PANEL round 5 — endojs/endo-but-for-bots PR #1390
- [`ebfb-1391-post-panel-5-verdict`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-1391-post-panel-5-verdict.md) — Post the round-5 panel verdict on PR #1391 (endojs/endo-but-for-bots)
- [`endojs-endo-but-for-bots-pr1403-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1403-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1403
- [`endojs-endo-but-for-bots-pr1340-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1340-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1340
- [`endojs-endo-but-for-bots-pr1340-review-c8f6e4bb`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1340-review-c8f6e4bb.md) — Review directive on endojs/endo-but-for-bots PR #1340
- [`ebfb-guest-no-identifiers-locators-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-guest-no-identifiers-locators-gauntlet-panel-4.md) — Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1404
- [`endojs-endo-but-for-bots-pr1340-body-refresh-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1340-body-refresh-20261001.md) — Apply refreshed PR body to endojs/endo-but-for-bots#1340
- [`build-endo-claude-pinned-cli-bump-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-endo-claude-pinned-cli-bump-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1406
- [`endojs-endo-but-for-bots-pr1340-conduct-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1340-conduct-20261001.md) — Conduct endojs/endo-but-for-bots#1340 (un-draft and merge)
- [`minion-town-pr140-endo-cancel-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/minion-town-pr140-endo-cancel-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — kriscendobot/minion.town PR #146
- [`endojs-endo-but-for-bots-pr1407-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1407-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1407
- [`endojs-endo-but-for-bots-pr1402-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1402-conduct.md) — Finalize (curate -> merge) endojs/endo-but-for-bots PR #1402
- [`ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1393
- [`claude-on-minion-town-press-20261001-223508`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/claude-on-minion-town-press-20261001-223508.md) — Press the Claude-on-minion.town arc forward
- [`ebfb-774-pr-body-refresh-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-774-pr-body-refresh-20261001.md) — Update the PR #774 description (endojs/endo-but-for-bots)
- [`endojs-endo-but-for-bots-pr1348-8333ce11`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1348-8333ce11.md) — attention directive on endojs/endo-but-for-bots PR #1348
- [`ocap-site-dns-recovery-check-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ocap-site-dns-recovery-check-20261001.md) — Verify ocap.site DNS recovery after registrar nameserver revert
- [`accountant-budget-conversation-20260930-resume`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/accountant-budget-conversation-20260930-resume.md) — Deliberate overrun decomposition for accountant-budget-conversation-20260930-...
- [`build-ci-minion-town-actions-runner-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-ci-minion-town-actions-runner-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — kriscendobot/minion.town PR #145
- [`ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1397
- [`ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-6-pr-write`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-6-pr-write.md) — PR-write handoff for endojs/endo-but-for-bots#1392 (gauntlet fix round 6)
- [`ebfb-petname-path-only-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1390

### doin (4)
- [`design-minion-town-mcp-resources-getting-started`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/design-minion-town-mcp-resources-getting-started.md) — Design: expose MCP Resources on minion.town's MCP server, and a getting-start...
- [`build-endo-guest-scoped-daemon-bootstrap-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/build-endo-guest-scoped-daemon-bootstrap-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1407
- [`build-endo-claude-broker-catalog-pruning-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/build-endo-claude-broker-catalog-pruning-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1409
- [`endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-6.md) — Gauntlet stage: FIX round 6 — endojs/endo-but-for-bots PR #1380

### tada (10344)
- [`endojs-endo-but-for-bots-pr1116-conduct-20261002`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/02/endojs-endo-but-for-bots-pr1116-conduct-20261002.md) — Cost
- [`build-endo-claude-sandbox-bwrap-slice-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/02/build-endo-claude-sandbox-bwrap-slice-gauntlet-fix-3.md) — Cost
- [`endojs-endo-but-for-bots-pr1414-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/02/endojs-endo-but-for-bots-pr1414-gauntlet-viability.md) — Cost
- [`endojs-endo-but-for-bots-pr1116-weave-20261002`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/02/endojs-endo-but-for-bots-pr1116-weave-20261002.md) — PR #1116 weave: done (endojs/endo-but-for-bots, design: guest-native invitati...
- [`endojs-endo-but-for-bots-pr1116-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/02/endojs-endo-but-for-bots-pr1116-conduct.md) — Manual gauntlet handoff
- … and 10339 more

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

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`ebfb-platform-fs-pet-name-path-only`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-platform-fs-pet-name-path-only.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1390` · ---
- [`endo-minion-town-federation-release-gate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-minion-town-federation-release-gate.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1124` · Gate: reviewed and deployable federation release
- [`verify-ironhorse-press-first-engagement-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ironhorse-press-first-engagement-20260929.md) — awaiting `ironhorse-test262-press-20260929-173306` · Verify the first live Ironhorse foreman-press engagement (successor of activa...
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`endojs-endo-but-for-bots-pr1340-build-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1340-build-20261001.md) — awaiting `endojs-endo-but-for-bots-pr1340-conduct-20261001` · Implement the confined-application-makers design (endojs/endo-but-for-bots#1340)
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
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 1 monks
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 2 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 2 monks
