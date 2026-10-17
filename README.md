# Garden bulletin

_As of 2026-10-17T01:07:46Z_

## Latest

Gauntlet work on minion.town moved most. [minion.town#190](https://github.com/kriscendobot/minion.town/pull/190) and [minion.town#194](https://github.com/kriscendobot/minion.town/pull/194) both completed their gauntlets and were un-drafted. [minion.town#193](https://github.com/kriscendobot/minion.town/pull/193) merged, and its deploy succeeded with the watchdog ok. Screening continued on [#184](https://github.com/kriscendobot/minion.town/pull/184), [#188](https://github.com/kriscendobot/minion.town/pull/188) and [#195](https://github.com/kriscendobot/minion.town/pull/195). A second screened-merge job for #184 is queued, and [#192](https://github.com/kriscendobot/minion.town/pull/192) is in fix round 7.

**Needs a decision: [minion.town#184](https://github.com/kriscendobot/minion.town/pull/184) hit its review budget.** It used all 16 panel/fix rounds with CI green but still has 19 unaddressed must-fix items. The latest round raised a new set from the breaker seat, centered on `provision-ci-runner.sh`. One item is that the seed check accepts secrets that the Lambda's `tokenFromSecret` rejects. The message gives the `--add-rounds N` resume command if you want to grant more rounds.

On endo-but-for-bots:
- [#1485](https://github.com/endojs/endo-but-for-bots/pull/1485) finished its clean stage and is queued for panel round 1.
- [#1486](https://github.com/endojs/endo-but-for-bots/pull/1486) finished panel round 1 and is queued for un-draft.
- [#1482](https://github.com/endojs/endo-but-for-bots/pull/1482) finished fix round 1 and is queued for panel round 2.
- [#1481](https://github.com/endojs/endo-but-for-bots/pull/1481) is queued for panel round 2.
- [#1476](https://github.com/endojs/endo-but-for-bots/pull/1476) is queued for panel round 3.
- [#1478](https://github.com/endojs/endo-but-for-bots/pull/1478) is in fix round 3.
- The build of the [ocapn-noise cryptographic review design](https://github.com/endojs/endo-but-for-bots/pull/1475) is in progress.
- The parcel-stack restack orchestration completed, with all 3 children done and none failed.

Also notable:
- A CI-read permission gap is blocking the delegated merge of [minion.town#188](https://github.com/kriscendobot/minion.town/pull/188). The bot token gets a 403 on `statusCheckRollup`, so it needs checks:read, statuses:read and actions:read.
- A docs-tower report job left one anonymous guest on production minion.town. There is no delete route, so you can leave it or remove it by hand. The source note was also missing on the host that ran the job, so the report wasn't checked against it.
- The minion.town OCapN canary live run is pinned to `endolin-garden-ece02cb4` and parked until you say go ahead. The canary now adopts guests from durable locators, so `guests.json` there should hold the two guest locators.
- A journal lock-contention storm is ongoing on the leader host, now on its 17th occurrence. The latest tick hit 6 clones, led by the producer journal with 6 giveups. Several contention notices on the oros-studio host have cleared.
- The budget watchdog throttled monks on both the leader host and oros-studio as claude-endolin1 and claude-oros spend approached their caps.

## Maintainer review docket

146 open · [ordered priorities and review docket](https://github.com/kriscendobot/garden/blob/journal2/PRIORITIES.md)
## Screened by proxy (minion.town)

Delegation: **active**

- 2026-10-16T23:58:28Z [#195](https://github.com/kriscendobot/minion.town/pull/195) `2800358ef0c` screened
- 2026-10-16T23:45:04Z [#184](https://github.com/kriscendobot/minion.town/pull/184) `63f7edb8a24` screened
- 2026-10-16T22:54:25Z [#188](https://github.com/kriscendobot/minion.town/pull/188) `943b833678b` screened
- 2026-10-16T22:32:14Z [#188](https://github.com/kriscendobot/minion.town/pull/188) `b4455441267` screened
- 2026-10-16T18:48:25Z [#193](https://github.com/kriscendobot/minion.town/pull/193) merged `51ad067684b`; deploy [success](https://github.com/kriscendobot/minion.town/actions/runs/38950151588), watchdog ok — validated
- 2026-10-16T18:18:39Z [#193](https://github.com/kriscendobot/minion.town/pull/193) `2b88eaacaf8` screened

## Messages to the maintainer

- `watchdog-journal-contention-storm-lock-contention` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-storm-lock-contention.md)

> WATCHDOG notice — occurrence #17 (first seen 2026-10-16T17:37:14Z, latest 2026-10-17T00:52:37Z).
> The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 17 times; this is ONE
> coalesced notice that updates in place, not 17 messages. Latest detail:
>
> Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
> - Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.014765s, giveups=1, steals=0 (max 3/window), wait floor=60s.
> - Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: p95=2.460805s, giveups=6, steals=0 (max 3/window), wait floor=60s.
> - Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=0.015315s, giveups=1, steals=0 (max 3/window), wait floor=60s.
> - Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.017127s, giveups=1, steals=0 (max 3/window), wait floor=60s.
> - Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/screening/journal: p95=0.013429s, giveups=2, steals=0 (max 3/window), wait floor=60s.
> - Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.013222s, giveups=2, steals=0 (max 3/window), wait floor=60s.

- `liaison-followup-ebf85c34f5bc` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/liaison-followup-ebf85c34f5bc.md)

> Report minion-town-docs-tower-report-20261016: two items need your call.
> 1. The live probe left one anonymous guest on production minion.town. The API has no delete route and the guest's identifier was never recorded, so the garden can't clean it up. Decide whether to leave it or remove it by hand.
> 2. The source note `/home/kris/garden/note-from-tower.md` was not on the host that ran the job, so the report was not checked against it. If you want that check, re-run the job on the host that holds the note.

- `kriscendobot-minion.town-pr184-gauntlet-review-budget-reached` — from gauntlet:kriscendobot-minion.town-pr184-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/kriscendobot-minion.town-pr184-gauntlet-review-budget-reached.md)

> Gauntlet kriscendobot-minion.town-pr184-gauntlet REVIEW-BUDGET-REACHED: Applied 16 panel/fix round(s); fix round 16 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=16, so the PR is left improved for a human merge/review decision. To grant more rounds: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr184-gauntlet panel --add-rounds N
>
> **Unaddressed must-fix: 19** · verdict: moving target · rounds spent: 16/16 · cost so far: $34.02
> Trend: r1 raised 20; r2 n/a; r3 raised 20; r4 raised 20 (fixed 20, carried 0); r5 n/a; r6 n/a; r7 raised 20; r8 n/a; r9 n/a; r10 n/a; r11 raised 20; r12 n/a; r13 n/a; r14 n/a; r15 n/a; r16 raised 19
> Classes: 0 persistent, 19 new in last round, 0 addressed-then-reintroduced
> ```text
> [new, since r16] breaker: should-fix: the seed check accepts secrets that tokenFromSecret rejects, which breaks the invariant the seed ch...
> [new, since r16] breaker: (deploy/aws/ci-runner/provision-ci-runner.sh:75) The comment at deploy/aws/ci-runner/provision-ci-runner.sh:75-76 says a seed "cannot replace a working secret with ...
> [new, since r16] breaker: I checked with jq 1.7 and node. jq -e exits 0 on all of these, but JSON.parse rejects each one:
> [new, since r16] breaker: {"token":"a"}{"token":"b"} (two JSON texts in one stream)
> [new, since r16] breaker: {"token":"ab","x":nan}
> [new, since r16] breaker: How it fails: a rotation via --seed-token-stdin (or the probe variant) with stdin holding two concatenated objects ...
> [new, since r16] breaker: Fix: validate with the same parser the Lambda uses. Either run node -e importing lambda/github.mjs's tokenFromSe...
> [new, since r16] breaker: proposed-rule: when a provisioning-time check guards a run-time invariant, run the run-time parser or validator, not...
> [new, since r16] breaker: comment-only (mitigated): "resource policy admits only its EventBridge rule" (DEPLOYMENT.md § Credentials).
> [new, since r16] breaker: (provision-ci-runner.sh:182) Attack: plant a stray statement with any Sid. The reconcile loop at provision-ci-runner.sh:182-190 removes every Si...
> [new, since r16] breaker: The host role's policy (:203-204) names only $FUNCTION_ARN, so the CI host can't reach the probe credential. The ...
> [new, since r16] breaker: The window between remove and add only denies access; it never grants it.
> … and 7 more
> ```
> Severity: this list is every request-changes seat bullet. The panel blocks only on real defects (wrong behavior, security or authority errors, data loss, broken contracts, failing or missing tests for changed behavior, comments false enough to invite an unsafe change); comment or JSDoc wording, identifier spelling or style, commit-history tidiness, PR-description completeness, and test-style items are should-fix and never block (skills/panel/SKILL.md § Finding severity).
>
> To add budget and resume: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr184-gauntlet panel --add-rounds 2
> --add-rounds 2 grants 2 more panel/fix round(s): max_iterations 16 -> 18 (N is yours to choose).

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal.md)

> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.017692s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `msg-claude-on-minion-town-press-20261016-170509-a7e94a0e73df` — from gardener:claude-on-minion-town-press-20261016-170509, reply_to `claude-on-minion-town-press-20261016-170509` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-claude-on-minion-town-press-20261016-170509-a7e94a0e73df.md)

> Done: minion-town-ocapn-canary-live-run is repinned to requires: host=endolin-garden-ece02cb4 and stays parked until you say go ahead. One heads-up before you provision: as of [kriscendobot/minion.town#193](https://github.com/kriscendobot/minion.town/issues/193) commit 32bab449 the canary adopts each guest from a durable endo:// locator (GET /account/guest-locator), not an invitation, so ~/.garden-state/ocapn-canary/guests.json should hold the two guest locators. No reply needed.

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-2.md)

> WATCHDOG notice — occurrence #3 (first seen 2026-09-12T03:20:10Z, latest 2026-10-16T23:50:27Z).
> The SAME condition (`budget-level-monk-endolin-garden-ece02cb4-2`) has now been observed 3 times; this is ONE
> coalesced notice that updates in place, not 3 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 monk workers 3 -> 2 (target 2): subscription claude-endolin1 spend=387760710 cap=430000000 pace-bias=0.470263 window-start=2026-10-10T03:00Z(calendar) deadline=2026-10-17T03:00Z(calendar) ceiling=4 backoff=0.9906(ramp) target=2

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_proxy_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_proxy_journal.md)

> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.014765s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_leader_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_leader_journal.md)

> RECOVERED — the watchdog condition `journal-fetch-slow-_Users_dom_garden__garden_state_leader_journal` has CLEARED (first seen 2026-10-16T22:05:57Z, cleared 2026-10-16T22:13:39Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-fetch-slow-_Users_dom_garden__garden_state_leader_journal` cleared on oros-studio-garden-ce242c49.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_reducer_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_reducer_journal.md)

> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.015554s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `watchdog-journal-lock-contention-_Users_dom_garden__garden_state_unblock_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_Users_dom_garden__garden_state_unblock_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_Users_dom_garden__garden_state_unblock_journal` has CLEARED (first seen 2026-10-16T18:44:04Z, cleared 2026-10-17T00:44:22Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_Users_dom_garden__garden_state_unblock_journal` cleared on oros-studio-garden-ce242c49.

- `watchdog-journal-lock-contention-_Users_dom_garden__garden_state_regenerate_sections_index_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_Users_dom_garden__garden_state_regenerate_sections_index_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_Users_dom_garden__garden_state_regenerate_sections_index_journal` has CLEARED (first seen 2026-10-16T18:43:50Z, cleared 2026-10-17T00:43:34Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_Users_dom_garden__garden_state_regenerate_sections_index_journal` cleared on oros-studio-garden-ce242c49.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_screening_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_screening_journal.md)

> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/screening/journal: p95=0.013684s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-3` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-3.md)

> budget-level changed endolin-garden-ece02cb4 monk workers 4 -> 3 (target 3): subscription claude-endolin1 spend=364726837 cap=430000000 pace-bias=0.656134 window-start=2026-10-10T03:00Z(calendar) deadline=2026-10-17T03:00Z(calendar) ceiling=4 backoff=0.9839(ramp) target=3

- `followup-gate-minion-town-docs-tower-report-20261016` — from followup-gate:minion-town-docs-tower-report-20261016, reply_to `minion-town-docs-tower-report-20261016` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/followup-gate-minion-town-docs-tower-report-20261016.md)

> Job "minion-town-docs-tower-report-20261016" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.
>
> ## Follow-ups
> - My live probe left one anonymous guest on production. The API has no route to delete it. Its identifier was never recorded.
> - The source note was not on this host. If the maintainer wants the report itself checked against these pages, re-run on the host that holds `/home/kris/garden/note-from-tower.md`.

- `watchdog-budget-level-monk-oros-studio-garden-ce242c49-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-oros-studio-garden-ce242c49-1.md)

> budget-level changed oros-studio-garden-ce242c49 monk workers 2 -> 1 (target 1): subscription claude-oros spend=113392322 cap=180000000 pace-bias=0 window-start=2026-10-13T10:00Z(calendar) deadline=2026-10-20T10:00Z(calendar) ceiling=4 backoff=0.7555(ramp) target=1

- `endojs-endo-but-for-bots-parcel-stack-restack-20261015-r5527149922-resume-resume-resume-resume-resume-resume-terminal-complete` — from orchestrator:endojs-endo-but-for-bots-parcel-stack-restack-20261015-r5527149922-resume-resume-resume-resume-resume-resume-terminal-complete, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-parcel-stack-restack-20261015-r5527149922-resume-resume-resume-resume-resume-resume-terminal-complete.md)

> orchestration-event: orchestration-terminal
> orchestration: endojs-endo-but-for-bots-parcel-stack-restack-20261015-r5527149922-resume-resume-resume-resume-resume-resume
> orchestration-status: complete
> order: serial
> children-total: 3
> children-failed: 0
> failed-children: 
> recovered-children: 
>
> Orchestration endojs-endo-but-for-bots-parcel-stack-restack-20261015-r5527149922-resume-resume-resume-resume-resume-resume complete (serial): all 3 children reached tada without a machine-readable failure declaration.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_deadline_nudge_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_deadline_nudge_journal.md)

> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=0.015195s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-1.md)

> budget-level changed endolin-garden-ece02cb4 monk workers 2 -> 1 (target 1): subscription claude-endolin1 spend=360342341 cap=271000000 pace-bias=0 window-start=2026-10-10T03:00Z(calendar) deadline=2026-10-17T03:00Z(calendar) ceiling=4 backoff=0.9809(ramp) target=1

- `watchdog-ci-read-forbidden-oros-studio-garden-ce242c49-kriscendobot` — from watchdog:ci-wait-merge, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-ci-read-forbidden-oros-studio-garden-ce242c49-kriscendobot.md)

> ci-wait-merge on oros-studio-garden-ce242c49 cannot read CI for [kriscendobot/minion.town#188](https://github.com/kriscendobot/minion.town/issues/188): the GitHub token is forbidden (HTTP 403) from statusCheckRollup, and delegated merges do not accept the Actions-only fallback. This is a token permission gap, not pending CI. Grant the bot token checks:read and statuses:read (and actions:read) on 'kriscendobot', then rerun the stage.

- `watchdog-journal-lock-contention-_Users_dom_garden__garden_state_repo_watcher_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_Users_dom_garden__garden_state_repo_watcher_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_Users_dom_garden__garden_state_repo_watcher_journal` has CLEARED (first seen 2026-10-16T18:43:57Z, cleared 2026-10-17T00:48:26Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_Users_dom_garden__garden_state_repo_watcher_journal` cleared on oros-studio-garden-ce242c49.


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 398.0M | $1861.43 _(notional, rate-card)_ | 93% of 430.0M (ok) |
| Codex | 35.2M _(fleet aggregate)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 54% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 94132740 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 5.890382s/45s (/home/kris/garden/.garden-state/screening-control/journal); 11 open notice(s); checker healthy

## Board
### todo (7)
- [`endojs-endo-but-for-bots-pr1476-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1476-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1476
- [`endojs-endo-but-for-bots-pr1485-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1485-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1485
- [`kriscendobot-garden-book-pr16-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/kriscendobot-garden-book-pr16-gauntlet-clean.md) — Gauntlet stage: CLEAN — kriscendobot/garden-book PR #16
- [`endojs-endo-but-for-bots-pr1486-gauntlet-undraft`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1486-gauntlet-undraft.md) — Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1486
- [`endojs-endo-but-for-bots-pr1482-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1482-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1482
- [`screen-minion-town-pr184-63f7edb-conduct-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/screen-minion-town-pr184-63f7edb-conduct-r2.md) — Screened delegated merge: kriscendobot/minion.town#184 at 63f7edb8a24567762ea...
- [`endojs-endo-but-for-bots-pr1481-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1481-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1481

### doin (3)
- [`endojs-endo-but-for-bots-pr1478-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1478-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1478
- [`kriscendobot-minion.town-pr192-gauntlet-fix-7`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/kriscendobot-minion.town-pr192-gauntlet-fix-7.md) — Gauntlet stage: FIX round 7 — kriscendobot/minion.town PR #192
- [`endo-but-for-bots-ocapn-noise-cryptographic-review-design-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endo-but-for-bots-ocapn-noise-cryptographic-review-design-build.md) — Build: the design in endojs/endo-but-for-bots#1475

### tada (13443)
- [`kriscendobot-minion.town-pr190-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/17/kriscendobot-minion.town-pr190-gauntlet.md) — gauntlet kriscendobot-minion.town-pr190-gauntlet — complete
- [`kriscendobot-minion.town-pr194-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/17/kriscendobot-minion.town-pr194-gauntlet.md) — gauntlet kriscendobot-minion.town-pr194-gauntlet — complete
- [`kriscendobot-minion.town-pr190-gauntlet-undraft`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/17/kriscendobot-minion.town-pr190-gauntlet-undraft.md) — Gauntlet UNDRAFT: kriscendobot/minion.town PR #190 ("feat(shell): persist cli...
- [`kriscendobot-minion.town-pr194-gauntlet-undraft`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/17/kriscendobot-minion.town-pr194-gauntlet-undraft.md) — Gauntlet un-draft: kriscendobot/minion.town PR #194
- [`kriscendobot-garden-book-pr16-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/17/kriscendobot-garden-book-pr16-gauntlet-viability.md) — Cost
- … and 13438 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`review-docket-consolidate-20261008`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/review-docket-consolidate-20261008.md) — _normal_ · ---
- [`revive-hermit-lane-qwen3.8-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/revive-hermit-lane-qwen3.8-20261001.md) — _normal_ · Revive the local hermit (on-box Ollama) lane, upgraded to qwen3.8
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`moddable-10-0-0-ironhorse-compiler-safety-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-compiler-safety-port.md) — _normal_ · Port Moddable 10.0.0 compiler safety corrections to IronHorse
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`make-panel-stage-survive-supervisor-session-exit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/make-panel-stage-survive-supervisor-session-exit.md) — _normal_ · Make panel execution survive supervising agent-session exit
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
- [`open-signup-gate-flip-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`garden-book-illuminations-finish-after-quota-refresh-20261016`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-book-illuminations-finish-after-quota-refresh-20261016.md) — _high_ · Finish garden-book illumination gauntlet, merge, and immutable republication ...
- [`moddable-10-0-0-ironhorse-callability-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-callability-port.md) — _normal_ · Port revoked-Proxy callability and constructability to IronHorse
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source.md) — _normal_ · Build: SES import attributes — Phase 2 (module-source static with capture)
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`design-minion-town-ocap-site-crawler-leak-rotation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-minion-town-ocap-site-crawler-leak-rotation.md) — _normal_ · Design: detect a crawler on an ocap.site page as a link-leak signal, and rotate
- [`kriscendobot-minion-town-pr183-open-findings-fix-20261015`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr183-open-findings-fix-20261015.md) — _normal_ · Fix the structural findings left open on kriscendobot/minion.town#183
- [`endojs-endo-but-for-bots-pr1416-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1416-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1416
- [`endojs-endo-but-for-bots-pr1430-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1430-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1430
- [`ebfb-llm-xs-daemon-bundle-reconcile`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-xs-daemon-bundle-reconcile.md) — _normal_ · ---
- [`build-readableblob-range-attenuation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-readableblob-range-attenuation.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`endojs-endo-but-for-bots-pr1433-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1433-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1433
- [`ironhorse-iterator-scenario-parity-maintainer-decision`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-iterator-scenario-parity-maintainer-decision.md) — _high_ · resolve the remaining acceptance scope for IronHorse iterator scenario parity
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr909-fix-ts-make-daemon`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-fix-ts-make-daemon.md) — _normal_ · Fix: endo make / endo archive TypeScript support is broken (endojs/endo-but-f...
- [`ironhorse-xs10-proxy-callable-flags`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-xs10-proxy-callable-flags.md) — _normal_ · IronHorse: Proxy [[Call]]/[[Construct]] flags survive revocation (XS 10.0.0 #...
- [`endojs-endo-but-for-bots-pr1348-review-4984e562`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1348-review-4984e562.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #1348
- [`moddable-10-0-0-ironhorse-oracle-validation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-oracle-validation.md) — _normal_ · Move the IronHorse oracle to Moddable 10.0.0 and validate the port campaign
- [`build-usage-scrape-ingest`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-usage-scrape-ingest.md) — _normal_ · ---
- [`ironhorse-xs-oracle-bump-10-0-0`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-xs-oracle-bump-10-0-0.md) — _normal_ · IronHorse: bump the XS oracle to Moddable 10.0.0 and mirror the compiler deltas
- [`drive-mystic-rollout-20260723`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/drive-mystic-rollout-20260723.md) — _low_ · ---
- [`kimi-k3-canary-20260723-c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kimi-k3-canary-20260723-c.md) — _low_ · ---
- [`moddable-10-0-0-ironhorse-typedarray-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-typedarray-port.md) — _normal_ · Port Moddable 10.0.0 TypedArray corrections to IronHorse
- [`moddable-10-0-0-ironhorse-immutable-arraybuffer-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-immutable-arraybuffer-port.md) — _normal_ · Implement immutable ArrayBuffer and close the Moddable 10.0.0 validation camp...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`kriscendobot-minion-town-pr148-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr148-gauntlet-viability.md) — _normal_ · Gauntlet stage: PRE-SPEND VIABILITY - kriscendobot/minion.town PR #148
- [`mirror-endo-3372`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/mirror-endo-3372.md) — _normal_ · Mirror endojs/endo#3372 onto endojs/endo-but-for-bots
- [`evaluate-reauth-escalation-default-after-oauth-relay-20260927`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/evaluate-reauth-escalation-default-after-oauth-relay-20260927.md) — _low_ · Evaluate default reauth escalation once the browser OAuth relay lands
- [`ironhorse-immutable-arraybuffer`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-immutable-arraybuffer.md) — _normal_ · IronHorse: implement Immutable ArrayBuffer and enable it in the oracle
- [`build-confined-application-makers-p2-20261002`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-confined-application-makers-p2-20261002.md) — _normal_ · Phase 2: daemon capture for node-modules-with-map and node-modules-scan layou...
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`endojs-endo-but-for-bots-pr1340-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1340-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1340
- [`endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper.md) — _normal_ · Build: SES import attributes — Phase 3 (compartment-mapper plumbing)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`oros-health-checkup-20261013-133505`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-checkup-20261013-133505.md) — _normal_ · Deliberate overrun decomposition for oros-health-checkup-20261013-133505
- [`moddable-10-0-0-ironhorse-builtins-order-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-builtins-order-port.md) — _normal_ · Port three Moddable 10.0.0 built-in ordering corrections to IronHorse
- [`claude-on-minion-town-press-20261010-133536`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-press-20261010-133536.md) — _normal_ · Press the Claude-on-minion.town arc forward
- [`build-claude-usage-dashboard-scraper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-claude-usage-dashboard-scraper.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1379-gauntlet-20261007-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1379-gauntlet-20261007-fix-5.md) — _normal_ · Gauntlet stage: FIX round 5 — endojs/endo-but-for-bots PR #1379

### awaiting maintainer decision (answer at the linked question)
- [`minion-town-claude-cli-production-canary-after-connection-20261004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-claude-cli-production-canary-after-connection-20261004.md) - [Connect the real Claude subscription through the stable account page and reply connected; no setup token may be sent through the journal.](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-claude-cli-production-canary-20261004-224cae8c9188.md)
- [`endo-cli-no-autostart-exit-codes-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-cli-no-autostart-exit-codes-build.md) - [Design OQ1/OQ3: should the CLI default to no-autostart under a service manager, and are the proposed exit codes acceptable?](https://github.com/endojs/endo-but-for-bots/pull/1383)
- [`ironhorse-test262-ratchet-round3-floor-resolution-20260928`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-test262-ratchet-round3-floor-resolution-20260928.md) - [Reconcile the historical floor with current verdict/resource policy, or restore all 901 genuinely under unchanged pins and policy?](https://github.com/kriscendobot/garden/issues/51#issuecomment-5877917421)
- [`minion-town-public-browser-caddy-gate-smoke-after-mfa-20261006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-public-browser-caddy-gate-smoke-after-mfa-20261006.md) - [When can you promptly relay the one-time GitHub SMS code for kriscendobot so the final public-browser gate smoke can run?](https://github.com/kriscendobot/garden/issues/89#issuecomment-6019568536)
- [`endo-daemon-orphan-safe-stop-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-daemon-orphan-safe-stop-build.md) - [Design OQ2: should run-daemon run the manager in-process, or keep the child process and forward signals?](https://github.com/endojs/endo-but-for-bots/pull/1383)
- [`ironhorse-computron-benchmark-baseline-build-after-approval`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-computron-benchmark-baseline-build-after-approval.md) - [Will the maintainer lift the Ironhorse pause, approve design PR #1283 (or direct an early build), and answer its six open questions (or direct the recommended defaults)?](https://github.com/endojs/endo-but-for-bots/pull/1283)
- [`minion-town-claude-kriscendobot-canary-after-connect-20261006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-claude-kriscendobot-canary-after-connect-20261006.md) - [Connect kriscendobot Claude subscription at minion.town/account/claude (GitHub login+MFA, claude setup-token) and reply "connected"](https://github.com/kriscendobot/garden/issues/89#issuecomment-6009162863)

### deferred (top by priority; foreman auto-promotes when idle)
(none)

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`ebfb-platform-fs-pet-name-path-only`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-platform-fs-pet-name-path-only.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1390` · ---
- [`endo-minion-town-federation-release-gate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-minion-town-federation-release-gate.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1124` · Gate: reviewed and deployable federation release
- [`verify-ironhorse-press-first-engagement-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ironhorse-press-first-engagement-20260929.md) — awaiting `ironhorse-test262-press-20260929-173306` · Verify the first live Ironhorse foreman-press engagement (successor of activa...
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`regauntlet-ebfb-pr1425-after-zizmor-fix-20261006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/regauntlet-ebfb-pr1425-after-zizmor-fix-20261006.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1427` · ---
- [`minion-town-ocapn-canary-live-run-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-ocapn-canary-live-run-2.md) — awaiting `endo-minion-town-federation-live-acceptance` · Live run of the minion.town OCapN guest canary (resumes minion-town-ocapn-can...
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1019` · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`kriscendobot-minion-town-node-observed-interpreter`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-node-observed-interpreter.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/171` · minion.town: observe the root-owned Node interpreter in the harness layout probe
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`minion-town-ui-iframe-live-frame-header-pr-landing-notice`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-ui-iframe-live-frame-header-pr-landing-notice.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/194` · Iframe: header PR #194 resolved — post the live-frame build only if it merged
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`build-exo-sheets-service`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-sheets-service.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`ironhorse-fuzz-triage-differential_source-efffacee3e2a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-triage-differential_source-efffacee3e2a.md) — awaiting `https://github.com/kriscendobot/garden/issues/91` · Triage 7 Ironhorse fuzz finding(s) for target differential_source
- [`minion-town-ui-gutter-mint`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-ui-gutter-mint.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/142` · Gutter: the + button mints a real clip (minion-town-ui increment)

## Watch set
kriscendobot-minion.town kriscendobot-garden-book kriscendobot-cosgov kriscendobot-ocapn kriscendobot-oros-ckm-data-readiness kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 2 monks
- [.archived-endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-endolin-garden2-5bcdff64): 1 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 1 monks
