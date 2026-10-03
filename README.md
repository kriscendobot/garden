# Garden bulletin

_As of 2026-10-03T06:01:56Z_

## Latest

Six panel/fix rounds closed out on [endojs/endo-but-for-bots#1393](https://github.com/endojs/endo-but-for-bots/pull/1393)'s sturdyref layer-3 slice (ebfb-sturdyref-layer3-pass-style), and the "act local CI screening" design work moved from research to doc-writing and got orchestrated as a split. Otherwise the board is churning normally across the sturdyref/guest-designation gauntlet stack, the garden-book illustration/build pipeline, and minion.town PR #145/#147/#85, with nothing new needing attention beyond the standing watchdog noise (clone-size guards, a stale oros-studio host, uncalibrated codex-endolin budget pool) and the accountant's pending proposal to carve out a 15M-token garden-book budget arc awaiting approval.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#1282](https://github.com/endojs/endo-but-for-bots/pull/1282) — chore(ironhorse): demolish the XS-computron-parity myth (waiting 6d)
- [endojs/endo-but-for-bots#1281](https://github.com/endojs/endo-but-for-bots/pull/1281) — fix(ses): silence lockdown intrinsics report for the WHATWG URL family (waiting 15d)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 21d)
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

- `msg-garden-book-supervisor-20261003-6b3b2c0fa68f` — from gardener:garden-book-supervisor-20261003, reply_to `garden-book-supervisor-20261003` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-garden-book-supervisor-20261003-6b3b2c0fa68f.md)

> This supervision pass is complete: all current text PRs are merged, the verified published edition is https://5f7jjhj4sbxaxdbej5t7oxgarnzhmb7wq45ds3nxqnq4wtthotsq.ocap.site/, and its URL is recorded on main at dba6dd6. Remaining illustration integration and JavaScript retool supervision is durably assigned to garden-book-supervisor-20261003-followup.

- `watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #20 (first seen 2026-10-02T05:41:06Z, latest 2026-10-03T05:08:03Z).
> The SAME condition (`rolling-deploy-host-offline-oros-studio-garden-ce242c49`) has now been observed 20 times; this is ONE
> coalesced notice that updates in place, not 20 messages. Latest detail:
>
> Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 86367s (offline threshold 1800s; sampled_at_epoch=1790917716).
> The authority is budget/live/<pool>/oros-studio-garden-ce242c49, refreshed periodically; fleet/health/oros-studio-garden-ce242c49 is
> not a heartbeat and was intentionally ignored. Rolling deploy will SKIP this peer:
> no release token, deploy budget, failed-canary count, or halt. Restore the host and
> its heartbeat to rejoin automatically. If hosts/oros-studio-garden-ce242c49 was archived, unarchive it as a
> separate operator decision; this watchdog never reverses decommissioning. (leader=endolin-garden-ece02cb4)

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
> token-budget: 100000
> ---
> <!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-10-03T04:56:45Z cleared=none -->
>
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> scripts/jobs/receipt-watcher.sh
> scripts/jobs/receipt-watcher.sh:97-101 treats GitHub primary-quota stderr as a generic transient and logs a 300s cooldown, though the 2026-10-02T19:45:23Z warning was followed by a 3599s primary-quota latch.
> Detect primary quota before the generic transient path, request `api_primary_quota_secs`, and log the actual full quota cooldown; add a regression test for the adopted `gh_api_retry` latch.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-2.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-09T20:50:15Z, latest 2026-10-03T05:05:38Z).
> The SAME condition (`budget-level-cleric-endolin-garden-ece02cb4-2`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 cleric workers 1 -> 2 (target 2): shared codex subscription demand active=2 queue=16 quota=ok fleet-envelope=2 target=2

- `msg-garden-book-supervisor-20261003-b45e79a447aa` — from gardener:garden-book-supervisor-20261003, reply_to `garden-book-supervisor-20261003` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-garden-book-supervisor-20261003-b45e79a447aa.md)

> garden-book text work is merged and published. [kriscendobot/garden-book#1](https://github.com/kriscendobot/garden-book/issues/1) through [kriscendobot/garden-book#3](https://github.com/kriscendobot/garden-book/issues/3) are now on main; the book is titled “Better Code and Gardens,” retains the five-part design, and corrects the stale journal-landing note. Published edition: https://5f7jjhj4sbxaxdbej5t7oxgarnzhmb7wq45ds3nxqnq4wtthotsq.ocap.site/

- `watchdog-container-hardening-pending-recreate-endolin-garden2-5bcdff64` — from watchdog:self-heal, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-container-hardening-pending-recreate-endolin-garden2-5bcdff64.md)

> Container hardening is PENDING on endolin-garden2-5bcdff64: 2 launcher-posture check(s) fail (caps/sudo/block devices/mount).
>
> This is the expected state until the container is recreated with the hardened launcher,
> a maintainer step: context/operations/harden-container.md. The garden-container-hardening
> unit stays clean meanwhile (exit 3), so it does not fail rolling-deploy canaries. After the
> first all-pass run, any failure is treated as a regression and fails the unit.

- `watchdog-journal-push-contention-_home_kris_garden__garden_state_reaper_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-push-contention-_home_kris_garden__garden_state_reaper_journal.md)

> Journal push contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reaper/journal: attempts p95=5.000000 max=5.000000 (cap 50), classes cas=6 server-reject=2 definite-fail=0.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_triager_pace_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_triager_pace_journal.md)

> Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/triager-pace/journal: packs 1005 >= 1000; size=281860096B packs=1005 gc.log=0; automatic remedy=deferred-deadline.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify_kriscendobot_ocapn` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify_kriscendobot_ocapn.md)

> Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-ocapn: packs 1000 >= 1000; size=341008384B packs=1000 gc.log=0; automatic remedy=deferred-deadline.

- `watchdog-preflight-gather-fail-kriscendobot-minion.town` — from watchdog:pr-feedback-preflight, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-preflight-gather-fail-kriscendobot-minion.town.md)

> pr-feedback-preflight could not gather evidence for [kriscendobot/minion.town#146](https://github.com/kriscendobot/minion.town/issues/146) (cid=5399204347) and failed open.
> This is a tool/transport failure, not a no-evidence finding — real feedback may
> have been processed WITHOUT the peer-resolution recheck. Reason:
> evidence gathering failed: could not fetch pull [kriscendobot/minion.town#146](https://github.com/kriscendobot/minion.town/issues/146)
> --- captured stderr ---
> gh: API rate limit exceeded for user ID 279080640. If you reach out to GitHub Support for help, please include the request ID AEF8:305E37:42A151:4A4E27:6AC09649 and timestamp 2026-10-03 05:44:42 UTC. For more on scraping GitHub and how it may affect your rights, please review our Terms of Service (https://docs.github.com/en/site-policy/github-terms/github-terms-of-service) (HTTP 403)

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-0` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-0.md)

> budget-level changed endolin-garden2-5bcdff64 cleric workers 1 -> 0 (target 0): shared codex subscription demand active=2 queue=16 quota=ok fleet-envelope=2 target=0

- `watchdog-journal-contention-watch-overrun` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-watch-overrun.md)

> RECOVERED — the watchdog condition `journal-contention-watch-overrun` has CLEARED (first seen 2026-10-03T05:02:31Z, cleared 2026-10-03T05:37:16Z).
> It was observed 3 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-contention-watch-overrun` cleared on endolin-garden-ece02cb4.

- `20261003T055048Z-1f7489` — from gardener:accountant-reslice-20261003, reply_to `accountant-reslice-20261003` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261003T055048Z-1f7489.md)

> **Accountant: a `garden-book` budget arc (re: your 10-03 "give the garden book some budget; propose a sliver to fit it in")**
>
> Nothing is applied yet — I'll wait for your OK before I write anything.
>
> **Where the book stands on the budget today.** The book has no arc. Its jobs run unarced, so the foreman charges them to the 25M `unallocated` reserve on this week's slate (the one you approved 10-02). That works, but it is invisible: the book silently competes with every other genuinely-unarced bit of in-flight work for the same 25M, and nothing bounds or ranks it.
>
> **Remaining book spend, estimated.** Grounding figure: the `garden-book-supervisor` orchestrator tick on 10-03 metered ~1.05M tokens (1,044,752 cached reads + 7K output, $0.86). The Claude-side work still ahead:
> - `book-illustrations-integrate` (web-designer) — integrate the art into chapters/build.py/styles.css
> - `book-build-js-retool` (builder) — the build retool
> - `garden-book-supervisor-20261003-after-art` (orchestrator, 3h handler) — supervises to completion across several ticks and drives the discretionary gauntlets + merges
> - 3 PR review-retros (pr1/pr2/pr3), light
> - 1–2 discretionary gauntlets on the art / integration / build PRs, plus the conduct/merges
>
> That lands around **~30M meter-tokens** remaining on the Claude side. `book-codex-illustrations` is the exception — it runs on the Codex/OpenAI pool, which this week's slate counts as zero, so it does not draw on the Claude arcs at all.
>
> **Proposal — carve `garden-book` out of the reserve, don't trim a ranked arc.**
>
> | | arc | this change |
> | ---: | --- | --- |
> | rank 7 (new) | `garden-book` | **15M**, carved from the reserve |
> | rank 8 | `endo-backlog` | 9.5M, unchanged (shifts 7→8) |
> | rank 9 | `unallocated` | 25M → **10M** |
>
> Total stays **500M**. Every ranked arc above keeps its exact slice (142.5/95/71.25/95/38/23.75M); only the reserve shrinks.
>
> **Why this shape:**
> - **Source = the reserve, because the book already draws on it.** This just *names and bounds* that draw. It adds no new budget and trims no ranked arc, so it cannot slow minion.town, the git remote, the UI, background Endo, or the moonshots.
> - **Rank 7, above `endo-backlog`.** You explicitly want the book funded; the off-mandate endo-backlog sliver is lower-want than that, so the book should win the draw ahead of it.
> - **A sliver, paced on purpose.** ~30M is the full remaining estimate; 15M funds roughly half this week, and the rest rolls into next week's apportionment. If the supervisor needs more sooner, it files a `budget/request` and I re-slice mid-week. 10M of genuine reserve stays for other unarced spillover (deploys, retros, stray in-flight).
>
> **How book jobs get tagged.** The producer (you via the liaison, and the supervisor) stamps `--arc garden-book` on the `garden-book-supervisor` orchestration (promoted children inherit it) and on new book jobs; the already-posted `book-illustrations-integrate`, `book-build-js-retool`, and `book-codex-illustrations` get the arc added by re-posting them with `--arc garden-book`. That re-stamp is the producer's action — I own only the allocation layer, so I'll land the arc and mandate line, and the book jobs move onto it as they're (re)posted.
>
> **To approve:** reply "approve" for 15M-from-reserve at rank 7 as above, or tell me a different slice size (e.g. 20M), rank, or source (the endo-backlog sliver, or a proportional trim instead of the reserve). Then I apply it in one `set-apportionment.sh` commit with `authorized_by: kriskowal` and confirm the resulting table.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify_kriscendobot_finbot` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify_kriscendobot_finbot.md)

> Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-finbot: packs 1002 >= 1000; size=344669184B packs=1002 gc.log=0; automatic remedy=deferred-deadline.

- `watchdog-deadline-nudge-push-rejected-endolin-garden-ece02cb4` — from watchdog:deadline-nudge, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-deadline-nudge-push-rejected-endolin-garden-ece02cb4.md)

> RECOVERED — the watchdog condition `deadline-nudge-push-rejected:endolin-garden-ece02cb4` has CLEARED (first seen 2026-10-03T05:05:23Z, cleared 2026-10-03T05:08:20Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> deadline-nudge on endolin-garden-ece02cb4 pushed to journal2 again; the push rejection has cleared.

- `doomed-garden-upkeep-watchers-provenance-20261003-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-garden-upkeep-watchers-provenance-20261003-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/garden-upkeep-watchers-provenance-20261003; it stays HELD until a human promotes it
> (promote-plan.sh garden-upkeep-watchers-provenance-20261003) or removes it, so nothing is lost.
> Original job base: garden-upkeep-watchers-provenance-20261003
>
> --- original job body ---
> ---
> role: fixer
> requires: host=endolin-garden-ece02cb4
> handler-timeout: 7200
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> # Garden upkeep on the leader: blind comment watchers, provenance gap, bloated repo-watcher clone
>
> Maintainer (kriskowal, muster 2026-10-03) approved this disposition.
>
> 1. comment-watcher self-tests FAIL on kriscendobot/test262 and kriscendobot/vattr97 (the
>    comment source path cannot fetch a known-existing comment, so the watchers are blind).
>    Diagnose and fix in scripts/jobs (main2); verify the self-test passes on the leader.
> 2. watchdog comment-provenance-gap-endolin-garden-ece02cb4 has fired 14 times since
>    2026-10-01T21:44Z. Find the cause and fix it, or explain why it is benign and quiet it.
> 3. /home/kris/garden/.garden-state/repo-watcher/journal has 1001 packs (>= 1000 guard).
>    gc it (or re-clone it) safely while the repo-watcher is idle, and fix whatever lets it
>    accumulate packs if that is the root cause.
> Land fixes directly on main2 per garden convention. Report what you changed.

- `watchdog-journal-contention-storm-clone-oversized` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-storm-clone-oversized.md)

> Journal contention storm on endolin-garden2-5bcdff64: 7 clones hit clone-oversized in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/issue-inbox/verify: awaiting a healthy post-rebuild fetch; size=47377408B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/dependabot-watcher/verify: awaiting a healthy post-rebuild fetch; size=48050176B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/ci-watcher/retire: awaiting a healthy post-rebuild fetch; size=47344640B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/ci-watcher/verify: awaiting a healthy post-rebuild fetch; size=48037888B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/fireworkers/1/journal: awaiting a healthy post-rebuild fetch; size=48944128B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/comment-watcher/verify: awaiting a healthy post-rebuild fetch; size=48939008B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/approval-reconciler/verify: awaiting a healthy post-rebuild fetch; size=48019456B packs=1 gc.log=0; automatic remedy=none.

- `watchdog-budget-pool-refuse-codex-endolin` — from watchdog:claim/1, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-pool-refuse-codex-endolin.md)

> WATCHDOG notice — occurrence #9 (first seen 2026-09-28T08:08:44Z, latest 2026-10-03T05:17:21Z).
> The SAME condition (`budget-pool-refuse-codex-endolin`) has now been observed 9 times; this is ONE
> coalesced notice that updates in place, not 9 messages. Latest detail:
>
> claim gate is FAIL-CLOSED on endolin-garden-ece02cb4: budget pool codex-endolin cap is UNCALIBRATED (provenance placeholder); promote a calibrated cap to admit: set-budget-pool.sh codex-endolin <weekly-token-cap> <calibrated-from>. No job will be claimed on this host until a calibrated cap is set.

- `ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-review-budget-reached` — from gauntlet:ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-review-budget-reached.md)

> INFO: Gauntlet ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify_kriscendobot_endo_but_for_bots` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_ci_watcher_verify_kriscendobot_endo_but_for_bots.md)

> Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/ci-watcher/verify-kriscendobot-endo-but-for-bots: packs 1004 >= 1000; size=344269824B packs=1004 gc.log=0; automatic remedy=deferred-deadline.

- `watchdog-container-hardening-pending-recreate-endolin-garden-ece02cb4` — from watchdog:self-heal, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-container-hardening-pending-recreate-endolin-garden-ece02cb4.md)

> Container hardening is PENDING on endolin-garden-ece02cb4: 2 launcher-posture check(s) fail (caps/sudo/block devices/mount).
>
> This is the expected state until the container is recreated with the hardened launcher,
> a maintainer step: context/operations/harden-container.md. The garden-container-hardening
> unit stays clean meanwhile (exit 3), so it does not fail rolling-deploy canaries. After the
> first all-pass run, any failure is treated as a regression and fails the unit.


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 28.6M | $190.82 _(notional, rate-card)_ | 11% of 256.0M (ok) |
| Codex | 1.4M _(+25.7M cached)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 38% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 70817700 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 4.171776s/45s (/home/kris/garden/.garden-state/library-source-drift-scan/journal); 5 open notice(s); checker healthy

## Board
### todo (20)
- [`claude-on-minion-town-press-20261003-023507`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/claude-on-minion-town-press-20261003-023507.md) — Press the Claude-on-minion.town arc forward
- [`build-endo-guest-scoped-daemon-bootstrap-gauntlet-fix-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-endo-guest-scoped-daemon-bootstrap-gauntlet-fix-4.md) — Gauntlet stage: FIX round 4 — endojs/endo-but-for-bots PR #1407
- [`oros-health-checkup-20261002-045016`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-045016.md) — ---
- [`oros-health-checkup-20261002-112006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-112006.md) — ---
- [`design-act-local-ci-screening-doc`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/design-act-local-ci-screening-doc.md) — Design: act local CI screening (write the doc from the findings)
- [`oros-health-checkup-20261002-080511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-080511.md) — ---
- [`build-confined-application-makers-p2-makefromtree-20261003`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-confined-application-makers-p2-makefromtree-20261003.md) — Phase 2c: EndoHost.makeFromTree layout/entry API and draft PR
- [`oros-health-checkup-20261002-142006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-142006.md) — ---
- [`endojs-endo-but-for-bots-pr1391-gauntlet-20261003-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1391-gauntlet-20261003-viability.md) — Gauntlet stage: PRE-SPEND VIABILITY - endojs/endo-but-for-bots PR #1391
- [`oros-health-checkup-20261003-040508`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261003-040508.md) — ---
- [`build-endo-claude-pinned-cli-bump-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-endo-claude-pinned-cli-bump-gauntlet-panel-6.md) — Gauntlet stage: PANEL round 6 — endojs/endo-but-for-bots PR #1406
- [`ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1393
- [`minion-town-claude-cli-provider-conduct-20261003`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/minion-town-claude-cli-provider-conduct-20261003.md) — Land and deploy the minion.town Claude CLI provider PR
- [`endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1379
- [`build-confined-application-makers-p1-20261002-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-confined-application-makers-p1-20261002-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1417
- [`ebfb-petname-path-only-gauntlet-fix-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-gauntlet-fix-4.md) — Gauntlet stage: FIX round 4 — endojs/endo-but-for-bots PR #1390
- [`kriscendobot-minion.town-pr147-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/kriscendobot-minion.town-pr147-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — kriscendobot/minion.town PR #147
- [`claude-on-minion-town-press-20261002-112006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/claude-on-minion-town-press-20261002-112006.md) — Press the Claude-on-minion.town arc forward
- [`kriscendobot-minion.town-pr85-gauntlet-20261003-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/kriscendobot-minion.town-pr85-gauntlet-20261003-clean.md) — Gauntlet stage: CLEAN — kriscendobot/minion.town PR #85
- [`claude-on-minion-town-press-20261003-053508`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/claude-on-minion-town-press-20261003-053508.md) — Press the Claude-on-minion.town arc forward

### doin (10)
- [`endojs-endo-but-for-bots-pr1412-gauntlet-fix-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1412-gauntlet-fix-4.md) — Gauntlet stage: FIX round 4 — endojs/endo-but-for-bots PR #1412
- [`build-endo-claude-sandbox-bwrap-slice-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/build-endo-claude-sandbox-bwrap-slice-gauntlet-panel-6.md) — Gauntlet stage: PANEL round 6 — endojs/endo-but-for-bots PR #1408
- [`accountant-reslice-20261003`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/accountant-reslice-20261003.md) — Re-slice: propose a garden-book arc sliver (week of 2026-10-03T03:00Z)
- [`ebfb-daemon-test-flakes-20261003`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-daemon-test-flakes-20261003.md) — Fix the flaky @endo/daemon test suite on endojs/endo-but-for-bots (llm)
- [`fu-endojs-endo-but-for-bots-pr1348-shell-command-grammar-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/fu-endojs-endo-but-for-bots-pr1348-shell-command-grammar-2.md) — ---
- [`endojs-endo-but-for-bots-pr1403-gauntlet-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1403-gauntlet-fix-5.md) — Gauntlet stage: FIX round 5 — endojs/endo-but-for-bots PR #1403
- [`ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1397
- [`ebfb-guest-no-identifiers-locators-gauntlet-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-guest-no-identifiers-locators-gauntlet-fix-5.md) — Gauntlet stage: FIX round 5 — endojs/endo-but-for-bots PR #1404
- [`book-codex-illustrations`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/book-codex-illustrations.md) — Garden book: generate illustrations and background art (Codex)
- [`build-ci-minion-town-actions-runner-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/build-ci-minion-town-actions-runner-gauntlet-panel-4.md) — Gauntlet stage: PANEL round 4 — kriscendobot/minion.town PR #145

### tada (10546)
- [`ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/03/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-6.md) — Cost
- [`design-act-local-ci-screening-research`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/03/design-act-local-ci-screening-research.md) — Completion report: design-act-local-ci-screening-research
- [`build-confined-application-makers-p2-mount-20261003`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/03/build-confined-application-makers-p2-mount-20261003.md) — Cost
- [`ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/03/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-fix-1.md) — Cost
- [`kriscendobot-minion.town-pr146-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/03/kriscendobot-minion.town-pr146-conduct.md) — Cost
- … and 10541 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`revive-hermit-lane-qwen3.8-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/revive-hermit-lane-qwen3.8-20261001.md) — _normal_ · Revive the local hermit (on-box Ollama) lane, upgraded to qwen3.8
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`make-panel-stage-survive-supervisor-session-exit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/make-panel-stage-survive-supervisor-session-exit.md) — _normal_ · Make panel execution survive supervising agent-session exit
- [`endojs-endo-but-for-bots-pr1416-conduct-20261002`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1416-conduct-20261002.md) — _normal_ · Conduct (merge) endojs/endo-but-for-bots PR #1416
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
- [`open-signup-gate-flip-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source.md) — _normal_ · Build: SES import attributes — Phase 2 (module-source static with capture)
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`improve-receipt-primary-quota-cooldown`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-receipt-primary-quota-cooldown.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1416-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1416-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1416
- [`ebfb-llm-xs-daemon-bundle-reconcile`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-xs-daemon-bundle-reconcile.md) — _normal_ · ---
- [`build-readableblob-range-attenuation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-readableblob-range-attenuation.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`ironhorse-iterator-scenario-parity-maintainer-decision`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-iterator-scenario-parity-maintainer-decision.md) — _high_ · resolve the remaining acceptance scope for IronHorse iterator scenario parity
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr909-fix-ts-make-daemon`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-fix-ts-make-daemon.md) — _normal_ · Fix: endo make / endo archive TypeScript support is broken (endojs/endo-but-f...
- [`endojs-endo-but-for-bots-pr1348-review-4984e562`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1348-review-4984e562.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #1348
- [`build-usage-scrape-ingest`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-usage-scrape-ingest.md) — _normal_ · ---
- [`drive-mystic-rollout-20260723`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/drive-mystic-rollout-20260723.md) — _low_ · ---
- [`kimi-k3-canary-20260723-c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kimi-k3-canary-20260723-c.md) — _low_ · ---
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`evaluate-reauth-escalation-default-after-oauth-relay-20260927`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/evaluate-reauth-escalation-default-after-oauth-relay-20260927.md) — _low_ · Evaluate default reauth escalation once the browser OAuth relay lands
- [`build-confined-application-makers-p2-20261002`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-confined-application-makers-p2-20261002.md) — _normal_ · Phase 2: daemon capture for node-modules-with-map and node-modules-scan layou...
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`endojs-endo-but-for-bots-pr1340-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1340-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1340
- [`endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper.md) — _normal_ · Build: SES import attributes — Phase 3 (compartment-mapper plumbing)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`build-claude-usage-dashboard-scraper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-claude-usage-dashboard-scraper.md) — _normal_ · ---

### awaiting maintainer decision (answer at the linked question)
- [`endo-cli-no-autostart-exit-codes-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-cli-no-autostart-exit-codes-build.md) - [Design OQ1/OQ3: should the CLI default to no-autostart under a service manager, and are the proposed exit codes acceptable?](https://github.com/endojs/endo-but-for-bots/pull/1383)
- [`ironhorse-test262-ratchet-round3-floor-resolution-20260928`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-test262-ratchet-round3-floor-resolution-20260928.md) - [Reconcile the historical floor with current verdict/resource policy, or restore all 901 genuinely under unchanged pins and policy?](https://github.com/kriscendobot/garden/issues/51#issuecomment-5877917421)
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
- [`kriscendobot-garden-book-pr1-review-6536e219-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-book-pr1-review-6536e219-retro.md) — _low_ · Retrospective on kriscendobot/garden-book PR #1 (primary: kriscendobot-garden...
- [`kriscendobot-garden-book-pr2-review-8541ef36-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-book-pr2-review-8541ef36-retro.md) — _low_ · Retrospective on kriscendobot/garden-book PR #2 (primary: kriscendobot-garden...
- [`kriscendobot-garden-book-pr3-review-dcb68a02-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-book-pr3-review-dcb68a02-retro.md) — _low_ · Retrospective on kriscendobot/garden-book PR #3 (primary: kriscendobot-garden...
- [`endojs-endo-but-for-bots-pr1348-review-4984e562-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1348-review-4984e562-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1348 (primary: endojs-endo-but-...
- [`kriscendobot-minion.town-pr146-review-338999f3-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr146-review-338999f3-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #146 (primary: kriscendobot-mini...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`ebfb-platform-fs-pet-name-path-only`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-platform-fs-pet-name-path-only.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1390` · ---
- [`endo-minion-town-federation-release-gate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-minion-town-federation-release-gate.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1124` · Gate: reviewed and deployable federation release
- [`verify-ironhorse-press-first-engagement-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ironhorse-press-first-engagement-20260929.md) — awaiting `ironhorse-test262-press-20260929-173306` · Verify the first live Ironhorse foreman-press engagement (successor of activa...
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`kriscendobot-minion.town-pr85-retcon-20261003`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr85-retcon-20261003.md) — awaiting `kriscendobot-minion.town-pr85-gauntlet-20261003` · retcon kriscendobot/minion.town PR #85
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1019` · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`garden-book-supervisor-20261003-after-art`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-book-supervisor-20261003-after-art.md) — awaiting `book-codex-illustrations` · Supervise the garden book to completion (kriscendobot/garden-book), after the...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`book-illustrations-integrate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/book-illustrations-integrate.md) — awaiting `book-codex-illustrations` · Garden book: integrate the Codex-generated illustrations and publish
- [`book-build-js-retool`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/book-build-js-retool.md) — awaiting `book-illustrations-integrate` · Retool the garden-book generator in portable JavaScript
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`build-exo-sheets-service`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-sheets-service.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`ironhorse-fuzz-triage-differential_source-efffacee3e2a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-triage-differential_source-efffacee3e2a.md) — awaiting `https://github.com/kriscendobot/garden/issues/91` · Triage 7 Ironhorse fuzz finding(s) for target differential_source

## Watch set
kriscendobot-minion.town kriscendobot-garden-book kriscendobot-cosgov kriscendobot-ocapn kriscendobot-oros-ckm-data-readiness kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot

## Hosts
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 4 monks
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 4 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 3 monks
