# Garden bulletin

[Current priorities and maintainer review docket](PRIORITIES.md)

_As of 2026-11-18T00:41:57Z_

## Latest

Oros (`oros-studio-garden-ce242c49`) is still operator-held. The rolling deploy moved it to 18fc7b17375, the canary failed again, and it stays drained. Two fixes need someone at the machine. The Claude OAuth session has expired, so someone has to run `/login` as the garden user. And `garden-secret-broker.service` fails after each deploy. The rolling-deploy canary-failed condition did clear this morning (08:14Z), but a stack of canary-probe jobs for Oros is still queued in todo. Leader deploys also remain blocked behind that canary.

Three PRs on the Ironhorse CI push and the Endo queue need attention. The orchestration `ironhorse-ci-failures-20261116` lost two children: the oracle-fix step (get the oracle-lane fix [endo-but-for-bots#1613](https://github.com/endojs/endo-but-for-bots/pull/1613) ready) and the test-legs step were both doomed and held in plan. Step 3, the Ironhorse-specific lanes, is running. Two gauntlets stopped on their own. [endo-but-for-bots#1504](https://github.com/endojs/endo-but-for-bots/pull/1504) halted after fix round 1 and can resume with `--add-rounds`. [endo-but-for-bots#1588](https://github.com/endojs/endo-but-for-bots/pull/1588) used all 7 panel and fix rounds without converging, so it needs a human merge or review decision or more rounds. In the 08:00-11:45Z window, [endo-but-for-bots#1660](https://github.com/endojs/endo-but-for-bots/pull/1660) was not merged because it now conflicts with `llm`. A weave is running, with a shepherd alongside it. Foreman M3 is still waiting on you to decide and merge [endo-but-for-bots#1646](https://github.com/endojs/endo-but-for-bots/pull/1646), the Node 24 pin that several parked weaves and conducts are waiting on.

Routine noise: the journal lock-contention storm cleared this morning, and one Oros lock-contention notice is still open. The minion.town pause keeps refusing jobs (the foreman, mentor, and dependabot watcher each hit the policy refusal as a failure). Several split-eligible jobs, including the daily progress summaries and the Phase 8 fetch-plugin build, are parked in plan after exhausting their retries.

Open questions for you:
- The host disk on `endolin-garden-ece02cb4` was nearly full, and briefly hit 0 during a job.
- The minion.town production DNS repoint from 11-10 needs an answer on whether it was deliberate.

## Maintainer review docket

194 open · [ordered priorities and review docket](https://github.com/kriscendobot/garden/blob/journal2/PRIORITIES.md)
## Screened by proxy (minion.town)

Delegation: **active**

(no screening activity in the last 24 h)

## Messages to the maintainer

- `doomed-daily-progress-summary-20261107-013512-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-daily-progress-summary-20261107-013512-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/daily-progress-summary-20261107-013512; it stays HELD until a human promotes it
> (promote-plan.sh daily-progress-summary-20261107-013512) or removes it, so nothing is lost.
> Original job base: daily-progress-summary-20261107-013512
>
> --- original job body ---
> Scheduled dispatch context (computed by the scheduler at fire time):
>
> - window_start: 2026-11-05T08:00:00Z (UTC, inclusive)
> - window_end: 2026-11-06T08:00:00Z (UTC, exclusive)
> - pacific_date: 2026-11-05 (the Pacific day this periodical covers)
> - output: journal/periodicals/2026/11/05.md
>
> ---
>
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Daily midnight Pacific progress summary
>
> Act as the [journalist](../../roles/journalist/AGENT.md) with purpose
> `daily-progress-summary` (see that role's § Daily progress summaries). Write one
> daily progress-summary periodical covering the prior 24 hours across every project,
> then commit it to `journal2`.
>
> 1. **Window.** If the scheduler prepended a "Scheduled dispatch context" block
>    above (it does under the anchored `daily-at-00:00-America/Los_Angeles`
>    cadence), use its `window_start`, `window_end`, `pacific_date`, and `output`
>    verbatim. Otherwise fall back to the Pacific day that most recently closed:
>    window `[<pacific_date> 00:00, next-day 00:00)` in America/Los_Angeles, and
>    `output = journal/periodicals/<YYYY>/<MM>/<DD>.md` keyed by that `pacific_date`.
> 2. **Read.** Every entry under `journal/entries/<YYYY>/<MM>/<DD>/` whose `ts:` is
>    in `[window_start, window_end)` (a UTC window can straddle two day-directories;
>    scan both and filter by `ts:`), plus the board transitions in the window
>    (`jobs/{todo,doin,tada}` moves from `git -C journal log --since=... --until=...`).
>    Scope is intentionally everything: dispatches, results, ticks, messages, and
>    worktree-lifecycle entries alike.
> 3. **Write.** One abstract-first periodical at `output`, partitioned by project
>    (the `project:` slug; one section per project with any entry, plus a garden-meta
>    section for untagged entries) and, within each, by activity kind. Do not skip a
>    project for having only a couple of entries. Cite sources by relative path;
>    paraphrase, do not copy. House style applies (no em-dashes in prose, no Latin
>    shorthand, relative paths). Commit and push the one file with the usual CAS; if
>    the file already exists for that Pacific date, overwrite it (the periodical is a
>    function of the window, so a re-run is idempotent).
>
> Deliverable: the periodical file committed to `journal2`, or (empty window) a
> one-line periodical saying nothing moved. No board writes, no upstream actions.
>
> ---
> Translated from v1 `schedule/garden/20260513T070000Z--5a93f9.md`
> (recurrence `daily-at-00:00-America/Los_Angeles`, dispatch `journalist` /
> `daily-progress-summary`, window "prior 24 hours", scope all projects).
> The v1 trigger/short-id/fired machinery is dropped: v2 schedules are recurring
> specs keyed by cadence, not pre-computed per-fire event files. The v1 periodicals
> output tree is archived under `legacy/v1/periodicals/`. The v1 original is
> retained on `journal-v1` and `origin/journal`.
>
> The cadence is the anchored, DST-aware `daily-at-00:00-America/Los_Angeles` (which
> the scheduler learned on main2 commit 85a1cd8e6): due-ness is decided against the
> most recent Pacific-midnight anchor at-or-before now and `last_dispatched` is
> stamped to that anchor, so the fire never drifts off local midnight and a 23h/25h
> DST day is spanned correctly. It was flipped from the earlier fixed-interval
> `daily` (which drifted, firing at each actual dispatch time rather than at local
> midnight) once the anchored scheduler landed on the leader host; do not revert it
> to `daily` while any leader host still runs a pre-anchor scheduler, or that
> scheduler would treat the token as its weekly default.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_unblock_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_unblock_journal.md)

> WATCHDOG notice — occurrence #11 (first seen 2026-11-07T02:46:16Z, latest 2026-11-16T08:57:13Z).
> The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_unblock_journal`) has now been observed 11 times; this is ONE
> coalesced notice that updates in place, not 11 messages. Latest detail:
>
> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.019070s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `ironhorse-ci-failures-20261116-child-ironhorse-ci-2-test-legs-20261116-failed` — from orchestrator:ironhorse-ci-failures-20261116-child-ironhorse-ci-2-test-legs-20261116-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ci-failures-20261116-child-ironhorse-ci-2-test-legs-20261116-failed.md)

> orchestration-event: orchestration-child-failure
> orchestration: ironhorse-ci-failures-20261116
> orchestration-status: running
> child: ironhorse-ci-2-test-legs-20261116
> failure-kind: doomed
> order: serial
> on-child-failure: continue
> detail: doomed and held in plan
>
> Orchestration ironhorse-ci-failures-20261116 observed child ironhorse-ci-2-test-legs-20261116: doomed and held in plan.

- `watchdog-journal-contention-storm-lock-contention` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-storm-lock-contention.md)

> WATCHDOG notice — occurrence #60 (first seen 2026-11-13T05:48:51Z, latest 2026-11-18T00:34:05Z).
> The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 60 times; this is ONE
> coalesced notice that updates in place, not 60 messages. Latest detail:
>
> Journal contention storm on endolin-garden-ece02cb4: 7 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
> - Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.034998s, giveups=3, steals=0 (max 3/window), wait floor=60s.
> - Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=0.018609s, giveups=1, steals=0 (max 3/window), wait floor=60s.
> - Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.037286s, giveups=1, steals=0 (max 3/window), wait floor=60s.
> - Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/screening/journal: p95=0.023158s, giveups=1, steals=0 (max 3/window), wait floor=60s.
> - Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.015688s, giveups=1, steals=0 (max 3/window), wait floor=60s.
> - Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reaper/journal: p95=0.037679s, giveups=1, steals=0 (max 3/window), wait floor=60s.
> - Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.029100s, giveups=3, steals=0 (max 3/window), wait floor=60s.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-2.md)

> WATCHDOG notice — occurrence #16 (first seen 2026-09-09T20:50:15Z, latest 2026-11-17T14:05:21Z).
> The SAME condition (`budget-level-cleric-endolin-garden-ece02cb4-2`) has now been observed 16 times; this is ONE
> coalesced notice that updates in place, not 16 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 cleric workers 1 -> 2 (target 2): shared codex subscription demand active=1 queue=1 quota=ok fleet-envelope=4 target=2

- `ironhorse-ci-failures-20261116-terminal-complete-with-failures` — from orchestrator:ironhorse-ci-failures-20261116-terminal-complete-with-failures, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ci-failures-20261116-terminal-complete-with-failures.md)

> orchestration-event: orchestration-terminal
> orchestration: ironhorse-ci-failures-20261116
> orchestration-status: complete-with-failures
> order: serial
> children-total: 4
> children-failed: 4
> failed-children: ironhorse-ci-1-oracle-fix-20261116 ironhorse-ci-2-test-legs-20261116 ironhorse-ci-3-ironhorse-lanes-20261116 ironhorse-ci-4-remaining-20261116
> recovered-children: 
>
> Orchestration ironhorse-ci-failures-20261116 complete WITH FAILURES (serial): 4/4 failed: ironhorse-ci-1-oracle-fix-20261116 ironhorse-ci-2-test-legs-20261116 ironhorse-ci-3-ironhorse-lanes-20261116 ironhorse-ci-4-remaining-20261116

- `liaison-followup-ebf85c34f5bc` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/liaison-followup-ebf85c34f5bc.md)

> Report minion-town-docs-tower-report-20261016: two items need your call.
> 1. The live probe left one anonymous guest on production minion.town. The API has no delete route and the guest's identifier was never recorded, so the garden can't clean it up. Decide whether to leave it or remove it by hand.
> 2. The source note `/home/kris/garden/note-from-tower.md` was not on the host that ran the job, so the report was not checked against it. If you want that check, re-run the job on the host that holds the note.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_follow_up_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_follow_up_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_home_kris_garden__garden_state_follow_up_journal` has CLEARED (first seen 2026-11-17T08:43:50Z, cleared 2026-11-17T22:38:52Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_home_kris_garden__garden_state_follow_up_journal` cleared on endolin-garden-ece02cb4.

- `watchdog-project-pause-active-minion-town` — from watchdog:claim/1, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-project-pause-active-minion-town.md)

> WATCHDOG notice — occurrence #105905 (first seen 2026-11-10T19:35:37Z, latest 2026-11-17T23:50:28Z).
> The SAME condition (`project-pause-active-minion-town`) has now been observed 105905 times; this is ONE
> coalesced notice that updates in place, not 105905 messages. Latest detail:
>
> PROJECT PAUSE enforced on endolin-garden-ece02cb4: refused a claimable todo job 'scholar-ingest-fudco-gist-20261105' on the board because project 'minion-town' is PAUSED (paused by kriskowal, liaison session, 2026-11-10: 'Please pause development on minion.town.').
> This means work for a PAUSED project reached a chokepoint — most likely a host running
> a garden OLDER than the pause directive is still producing it (the 2026-09-16/17
> IronHorse-fuzz-storm shape). The chokepoints refuse it, but the fact that it was
> attempted is worth seeing: check whether a host is stale and needs to deploy.
> Paused scope: all minion.town development: builds, designs, fixes, presses, gauntlets, deploys, and jobs posted by the screener or CI watcher
> To LIFT the pause (the only authorized way to run this work again), delete the journal
> record: scripts/jobs/pause-project.sh minion-town off — and update roles/COMMON.md § Project
> scope to match. This notice is COALESCED per project: one entry, a rising count, not
> one message per refused job.

- `liaison-followup-f32528813528` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/liaison-followup-f32528813528.md)

> Report scholar-ingest-yavashark-ironhorse-20261030: the scholar ingest of yavashark found cost tiers, sampling, and CPU pinning in its test infrastructure. Should the garden post an Iron Horse test-infra job to adopt them? It is your call, and no job has been posted.

- `ironhorse-ci-failures-20261116-child-ironhorse-ci-1-oracle-fix-20261116-failed` — from orchestrator:ironhorse-ci-failures-20261116-child-ironhorse-ci-1-oracle-fix-20261116-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ci-failures-20261116-child-ironhorse-ci-1-oracle-fix-20261116-failed.md)

> orchestration-event: orchestration-child-failure
> orchestration: ironhorse-ci-failures-20261116
> orchestration-status: running
> child: ironhorse-ci-1-oracle-fix-20261116
> failure-kind: doomed
> order: serial
> on-child-failure: continue
> detail: doomed and held in plan
>
> Orchestration ironhorse-ci-failures-20261116 observed child ironhorse-ci-1-oracle-fix-20261116: doomed and held in plan.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal.md)

> WATCHDOG notice — occurrence #5 (first seen 2026-11-13T04:44:14Z, latest 2026-11-17T18:48:59Z).
> The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal`) has now been observed 5 times; this is ONE
> coalesced notice that updates in place, not 5 messages. Latest detail:
>
> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.019907s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `watchdog-comment-ack-latency-endojs-endo-but-for-bots` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-ack-latency-endojs-endo-but-for-bots.md)

> RECOVERED — the watchdog condition `comment-ack-latency-endojs-endo-but-for-bots` has CLEARED (first seen 2026-11-16T08:33:55Z, cleared 2026-11-16T08:39:11Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Comment acknowledgment condition cleared.

- `ironhorse-ci-failures-round2-20261117-child-ironhorse-ci2-flake-reruns-20261117-failed` — from orchestrator:ironhorse-ci-failures-round2-20261117-child-ironhorse-ci2-flake-reruns-20261117-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ci-failures-round2-20261117-child-ironhorse-ci2-flake-reruns-20261117-failed.md)

> orchestration-event: orchestration-child-recovered
> orchestration: ironhorse-ci-failures-round2-20261117
> orchestration-status: complete-with-failures
> child: ironhorse-ci2-flake-reruns-20261117
> recovered: true
>
> RECOVERED — orchestration ironhorse-ci-failures-round2-20261117 finished reporting child ironhorse-ci2-flake-reruns-20261117 as failed; it has since reached a clean tada (no gated-failure declaration). The completion record now reads 'recovered after transient failure'.

- `endojs-endo-but-for-bots-pr1591-gauntlet-halted` — from gauntlet:endojs-endo-but-for-bots-pr1591-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-pr1591-gauntlet-halted.md)

> COALESCED message — occurrence #2 (first seen 2026-11-16T23:35:20Z, latest 2026-11-17T01:14:27Z).
> The SAME message (episode key `endojs-endo-but-for-bots-pr1591-gauntlet-halted`) has now been sent 2 times; this is
> ONE entry that updates in place, not 2 messages. Latest detail:
>
> Gauntlet endojs-endo-but-for-bots-pr1591-gauntlet HALTED: stage 'endojs-endo-but-for-bots-pr1591-gauntlet-panel-1' (panel) failed 3 times; its stage retry budget is exhausted (max_stage_retries=2). Last failure: reaper doom_signature=requeue-exhausted with failure_classification=transient
>
> Unaddressed must-fix: unknown · list unavailable (panel report has no structured must-fix list) · rounds spent: 1/6
> Severity: this list is every request-changes seat bullet. The panel blocks only on real defects (wrong behavior, security or authority errors, data loss, broken contracts, failing or missing tests for changed behavior, comments false enough to invite an unsafe change); comment or JSDoc wording, identifier spelling or style, commit-history tidiness, PR-description completeness, and test-style items are should-fix and never block (skills/panel/SKILL.md § Finding severity).
>
> To resume: scripts/jobs/gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1591-gauntlet panel --iteration 1 --add-rounds 2
> --add-rounds 2 grants 2 more panel/fix round(s): max_iterations 6 -> 8 (N is yours to choose).

- `watchdog-journal-contention-storm-fetch-slow` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-storm-fetch-slow.md)

> RECOVERED — the watchdog condition `journal-contention-storm-fetch-slow` has CLEARED (first seen 2026-11-13T22:23:28Z, cleared 2026-11-16T16:37:39Z).
> It was observed 4 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-contention-storm-fetch-slow` cleared on endolin-garden-ece02cb4.

- `watchdog-journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal` has CLEARED (first seen 2026-11-13T12:42:09Z, cleared 2026-11-17T16:38:20Z).
> It was observed 5 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal` cleared on oros-studio-garden-ce242c49.

- `liaison-followup-56d47a214d15` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/liaison-followup-56d47a214d15.md)

> Report mt-beta-settings-simplify (minion.town settings simplification) needs three things from you.
>
> 1. **Run `deploy-accounts-store.sh` before merging.** The new index has to be active first. Until it is, Log out stays hidden and account deletion answers 503 without deleting anything. This needs your hands because it deploys to the accounts store.
>
> 2. **Veto check.** The report lists four choices that are yours to veto:
>    - the no-bond hint;
>    - removing Copy guest URL and Forget this browser;
>    - removing mail before the chat clip exists;
>    - leaving daemon state on disk while garbage collection is off.
>
>    Tell me if you object to any of them. If you don't, they stand.
>
> 3. **Invitation count.** This waits on #199 adding a per-holder count. I'm not acting on it yet, since the dependency hasn't landed. Tell me if you want it tracked on a schedule instead.

- `followup-gate-ironhorse-ci2-1346-1299-20261117` — from followup-gate:ironhorse-ci2-1346-1299-20261117, reply_to `ironhorse-ci2-1346-1299-20261117` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/followup-gate-ironhorse-ci2-1346-1299-20261117.md)

> Job "ironhorse-ci2-1346-1299-20261117" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.
>
> ## Follow-ups
> - **Oracle lanes:** `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` are still red on both PRs. Both fail only on stage3-math 054/055, so they're waiting on #1613 as expected. I left them alone.
> - **New reds outside ironhorse:** these pushes triggered a full CI run, and several non-ironhorse checks now fail on both PRs: `cover`/`test` (22.x, 24.x ubuntu), `test-xs` (hardened262), `sandbox-drivers` (bwrap `ulimit -u` and process-group cleanup), and `zizmor`. The old runs only ran the ironhorse lanes. I didn't change anything outside `rust/engine`, so these look like drift in the old base (Node 26, zizmor floating tags, the known bwrap failures). I haven't confirmed that by running them on the base itself. Clearing them likely means weaving onto current `llm` once the base improves; that is a separate decision.

- `endojs-endo-but-for-bots-pr1588-gauntlet-review-budget-reached` — from gauntlet:endojs-endo-but-for-bots-pr1588-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-pr1588-gauntlet-review-budget-reached.md)

> COALESCED message — occurrence #2 (first seen 2026-11-14T15:03:04Z, latest 2026-11-15T14:50:15Z).
> The SAME message (episode key `endojs-endo-but-for-bots-pr1588-gauntlet-review-budget-reached`) has now been sent 2 times; this is
> ONE entry that updates in place, not 2 messages. Latest detail:
>
> Gauntlet endojs-endo-but-for-bots-pr1588-gauntlet REVIEW-BUDGET-REACHED: Applied 7 panel/fix round(s); fix round 7 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=7, so the PR is left improved for a human merge/review decision. To grant more rounds: scripts/jobs/gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1588-gauntlet panel --add-rounds N
>
> Unaddressed must-fix: unknown · list unavailable (panel report has no structured must-fix list) · rounds spent: 7/7 · cost so far: $27.85
> Severity: this list is every request-changes seat bullet. The panel blocks only on real defects (wrong behavior, security or authority errors, data loss, broken contracts, failing or missing tests for changed behavior, comments false enough to invite an unsafe change); comment or JSDoc wording, identifier spelling or style, commit-history tidiness, PR-description completeness, and test-style items are should-fix and never block (skills/panel/SKILL.md § Finding severity).
>
> To add budget and resume: scripts/jobs/gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1588-gauntlet panel --add-rounds 2
> --add-rounds 2 grants 2 more panel/fix round(s): max_iterations 7 -> 9 (N is yours to choose).

- `ironhorse-ci-failures-round2-20261117-child-ironhorse-ci2-1621-drift-20261117-failed` — from orchestrator:ironhorse-ci-failures-round2-20261117-child-ironhorse-ci2-1621-drift-20261117-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ci-failures-round2-20261117-child-ironhorse-ci2-1621-drift-20261117-failed.md)

> orchestration-event: orchestration-child-failure
> orchestration: ironhorse-ci-failures-round2-20261117
> orchestration-status: running
> child: ironhorse-ci2-1621-drift-20261117
> failure-kind: doomed
> order: parallel
> on-child-failure: continue
> detail: doomed and held in plan
>
> Orchestration ironhorse-ci-failures-round2-20261117 observed child ironhorse-ci2-1621-drift-20261117: doomed and held in plan.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_fork_watch_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_fork_watch_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_home_kris_garden__garden_state_fork_watch_journal` has CLEARED (first seen 2026-11-13T04:44:08Z, cleared 2026-11-13T10:43:55Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_home_kris_garden__garden_state_fork_watch_journal` cleared on endolin-garden-ece02cb4.

- `doomed-daily-progress-summary-20261107-080513-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-daily-progress-summary-20261107-080513-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/daily-progress-summary-20261107-080513; it stays HELD until a human promotes it
> (promote-plan.sh daily-progress-summary-20261107-080513) or removes it, so nothing is lost.
> Original job base: daily-progress-summary-20261107-080513
>
> --- original job body ---
> Scheduled dispatch context (computed by the scheduler at fire time):
>
> - window_start: 2026-11-06T08:00:00Z (UTC, inclusive)
> - window_end: 2026-11-07T08:00:00Z (UTC, exclusive)
> - pacific_date: 2026-11-06 (the Pacific day this periodical covers)
> - output: journal/periodicals/2026/11/06.md
>
> ---
>
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> # Daily midnight Pacific progress summary
>
> Act as the [journalist](../../roles/journalist/AGENT.md) with purpose
> `daily-progress-summary` (see that role's § Daily progress summaries). Write one
> daily progress-summary periodical covering the prior 24 hours across every project,
> then commit it to `journal2`.
>
> 1. **Window.** If the scheduler prepended a "Scheduled dispatch context" block
>    above (it does under the anchored `daily-at-00:00-America/Los_Angeles`
>    cadence), use its `window_start`, `window_end`, `pacific_date`, and `output`
>    verbatim. Otherwise fall back to the Pacific day that most recently closed:
>    window `[<pacific_date> 00:00, next-day 00:00)` in America/Los_Angeles, and
>    `output = journal/periodicals/<YYYY>/<MM>/<DD>.md` keyed by that `pacific_date`.
> 2. **Read.** Every entry under `journal/entries/<YYYY>/<MM>/<DD>/` whose `ts:` is
>    in `[window_start, window_end)` (a UTC window can straddle two day-directories;
>    scan both and filter by `ts:`), plus the board transitions in the window
>    (`jobs/{todo,doin,tada}` moves from `git -C journal log --since=... --until=...`).
>    Scope is intentionally everything: dispatches, results, ticks, messages, and
>    worktree-lifecycle entries alike.
> 3. **Write.** One abstract-first periodical at `output`, partitioned by project
>    (the `project:` slug; one section per project with any entry, plus a garden-meta
>    section for untagged entries) and, within each, by activity kind. Do not skip a
>    project for having only a couple of entries. Cite sources by relative path;
>    paraphrase, do not copy. House style applies (no em-dashes in prose, no Latin
>    shorthand, relative paths). Commit and push the one file with the usual CAS; if
>    the file already exists for that Pacific date, overwrite it (the periodical is a
>    function of the window, so a re-run is idempotent).
>
> Deliverable: the periodical file committed to `journal2`, or (empty window) a
> one-line periodical saying nothing moved. No board writes, no upstream actions.
>
> ---
> Translated from v1 `schedule/garden/20260513T070000Z--5a93f9.md`
> (recurrence `daily-at-00:00-America/Los_Angeles`, dispatch `journalist` /
> `daily-progress-summary`, window "prior 24 hours", scope all projects).
> The v1 trigger/short-id/fired machinery is dropped: v2 schedules are recurring
> specs keyed by cadence, not pre-computed per-fire event files. The v1 periodicals
> output tree is archived under `legacy/v1/periodicals/`. The v1 original is
> retained on `journal-v1` and `origin/journal`.
>
> The cadence is the anchored, DST-aware `daily-at-00:00-America/Los_Angeles` (which
> the scheduler learned on main2 commit 85a1cd8e6): due-ness is decided against the
> most recent Pacific-midnight anchor at-or-before now and `last_dispatched` is
> stamped to that anchor, so the fire never drifts off local midnight and a 23h/25h
> DST day is spanned correctly. It was flipped from the earlier fixed-interval
> `daily` (which drifted, firing at each actual dispatch time rather than at local
> midnight) once the anchored scheduler landed on the leader host; do not revert it
> to `daily` while any leader host still runs a pre-anchor scheduler, or that
> scheduler would treat the token as its weekly default.

- `ironhorse-ci2-refresh-1298-1534-20261117-split-child-ironhorse-ci2-1534-verify-20261117-failed` — from orchestrator:ironhorse-ci2-refresh-1298-1534-20261117-split-child-ironhorse-ci2-1534-verify-20261117-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ci2-refresh-1298-1534-20261117-split-child-ironhorse-ci2-1534-verify-20261117-failed.md)

> orchestration-event: orchestration-child-failure
> orchestration: ironhorse-ci2-refresh-1298-1534-20261117-split
> orchestration-status: running
> child: ironhorse-ci2-1534-verify-20261117
> failure-kind: doomed
> order: parallel
> on-child-failure: continue
> detail: doomed and held in plan
>
> Orchestration ironhorse-ci2-refresh-1298-1534-20261117-split observed child ironhorse-ci2-1534-verify-20261117: doomed and held in plan.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-1.md)

> WATCHDOG notice — occurrence #12 (first seen 2026-09-09T21:05:16Z, latest 2026-11-17T14:35:24Z).
> The SAME condition (`budget-level-cleric-endolin-garden-ece02cb4-1`) has now been observed 12 times; this is ONE
> coalesced notice that updates in place, not 12 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 cleric workers 2 -> 1 (target 1): shared codex subscription demand active=1 queue=1 quota=backoff fleet-envelope=4 target=1

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-2.md)

> budget-level changed endolin-garden-ece02cb4 monk workers 3 -> 2 (target 2): subscription claude-endolin1 spend=76109214 cap=271000000 pace-bias=0 window-start=2026-11-14T04:00Z(calendar) deadline=2026-11-21T04:00Z(calendar) ceiling=4 backoff=0.5575(ramp) target=2

- `doomed-dependabotany-recheck-endo-but-for-bots-20261117-030511-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-dependabotany-recheck-endo-but-for-bots-20261117-030511-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/dependabotany-recheck-endo-but-for-bots-20261117-030511; it stays HELD until a human promotes it
> (promote-plan.sh dependabotany-recheck-endo-but-for-bots-20261117-030511) or removes it, so nothing is lost.
> Original job base: dependabotany-recheck-endo-but-for-bots-20261117-030511
>
> --- original job body ---
> ---
> handler-timeout: 7200
> ---
>
> Dependabotany active-row snapshot (v2):
>
> - Journal HEAD: `f1a33a5584adb886f3090c0caa45effa55508f8d`
> - Project: `endo-but-for-bots`
> - Repository: `endojs/endo-but-for-bots`
> - Rows: 6
>
> This normalized snapshot is authoritative only when your synced journal HEAD
> is exactly the commit above. If it matches, consume these rows directly and do
> not reconstruct the unindexed prose ledger. If the snapshot is unavailable,
> malformed, or HEAD has changed, fail open to the role's case-insensitive full scan.
>
> ```tsv
> disposition	pr	source
> MERGE-NOW	1655	entries/2026/11/16/030838Z-message-gardener-ec5225.md
> MERGE-NOW	1657	entries/2026/11/16/030838Z-message-gardener-ec5225.md
> MERGE-NOW	1658	entries/2026/11/16/030838Z-message-gardener-ec5225.md
> MERGE-NOW	1663	entries/2026/11/16/030838Z-message-gardener-ec5225.md
> MERGE-NOW	1664	entries/2026/11/16/030838Z-message-gardener-ec5225.md
> MERGE-NOW	1665	entries/2026/11/16/030838Z-message-gardener-ec5225.md
> ```
>
> ---
>
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> Wear roles/botanist/AGENT.md and re-evaluate every open PR in the endo-but-for-bots dependabotany ledger whose maturity date has arrived or whose recorded blocker has cleared. Recover the ledger with: grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -il '^# *dependabotany'. Execute the now-due verdict for each PR: MERGE-NOW through ci-wait-merge.sh --dependabot-auto-merge, REJECT closes, EMBARGO re-defers. Current row: #1629 (setup-python 7.1.0) is held on [endojs/endo-but-for-bots#1613](https://github.com/endojs/endo-but-for-bots/issues/1613) and #1646.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_proxy_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_proxy_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_home_kris_garden__garden_state_proxy_journal` has CLEARED (first seen 2026-11-14T06:49:46Z, cleared 2026-11-17T16:43:53Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_home_kris_garden__garden_state_proxy_journal` cleared on endolin-garden-ece02cb4.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_regenerate_sections_index_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_regenerate_sections_index_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_home_kris_garden__garden_state_regenerate_sections_index_journal` has CLEARED (first seen 2026-11-14T00:39:53Z, cleared 2026-11-16T00:46:36Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_home_kris_garden__garden_state_regenerate_sections_index_journal` cleared on endolin-garden-ece02cb4.

- `doomed-build-daemon-agent-tools-phase-8-fetch-plugin-20261106-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-build-daemon-agent-tools-phase-8-fetch-plugin-20261106-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/build-daemon-agent-tools-phase-8-fetch-plugin-20261106; it stays HELD until a human promotes it
> (promote-plan.sh build-daemon-agent-tools-phase-8-fetch-plugin-20261106) or removes it, so nothing is lost.
> Original job base: build-daemon-agent-tools-phase-8-fetch-plugin-20261106
>
> --- original job body ---
> ---
> posted_at: 2026-11-06T02:15:48Z
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> role: builder
> tier: mentor
> arc: daemon-agent-tools
> ---
> Repo: endojs/endo-but-for-bots @ llm. Build Phase 8 of the daemon agent tools design (find it under designs/ via `grep -ril 'agent tools' designs/`). Maintainer decision on Open Question 4 (kriskowal, liaison muster 2026-11-06): the HTTP client is provided by the `@endo/fetch` plugin, NOT a new daemon `provideHttpClient` formula. Record the resolution in the design's open-questions section and tick the Phase 2c checkbox only if [endojs/endo-but-for-bots#1497](https://github.com/endojs/endo-but-for-bots/issues/1497) has merged (it was open on 2026-11-06; check first). Open a DRAFT PR on an in-repo endojs branch per the usual builder flow.

- `ironhorse-ci-failures-round2-20261117-terminal-complete-with-failures` — from orchestrator:ironhorse-ci-failures-round2-20261117-terminal-complete-with-failures, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ci-failures-round2-20261117-terminal-complete-with-failures.md)

> orchestration-event: orchestration-terminal
> orchestration: ironhorse-ci-failures-round2-20261117
> orchestration-status: complete-with-failures
> order: parallel
> children-total: 5
> children-failed: 3
> failed-children: ironhorse-ci2-1621-drift-20261117 ironhorse-ci2-1359-20261117 ironhorse-ci2-flake-reruns-20261117
> recovered-children: ironhorse-ci2-refresh-1298-1534-20261117
>
> Orchestration ironhorse-ci-failures-round2-20261117 complete WITH FAILURES (parallel): 3/5 failed: ironhorse-ci2-1621-drift-20261117 ironhorse-ci2-1359-20261117 ironhorse-ci2-flake-reruns-20261117
> Recovered after a transient failure reading (superseded by a clean tada): ironhorse-ci2-refresh-1298-1534-20261117

- `msg-oros-health-watch-20261111-205010-04ba7ec6ee39` — from gardener:oros-health-watch-20261111-205010, reply_to `oros-health-watch-20261111-205010` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-oros-health-watch-20261111-205010-04ba7ec6ee39.md)

> Oros (oros-studio-garden-ce242c49) is still operator-held. The roll moved it to 18fc7b17375 and failed the canary again; retries ran out at 19:29Z and it stays drained. There are two blockers, and both need someone at the machine:
> (1) The Claude OAuth session has expired. Fix: run claude, then /login, as the garden user.
> (2) garden-secret-broker.service fails after deploy. It failed the same way on 11-07 through 11-10. Check it with: journalctl --user -u garden-secret-broker -n 80
> I lifted nothing and reset nothing; the drain is roll-owned. Full record: projects/garden/host-health/oros-studio-garden-ce242c49.md

- `watchdog-comment-watcher-stuck-cooldown-host` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-watcher-stuck-cooldown-host.md)

> RECOVERED — the watchdog condition `comment-watcher-stuck-cooldown-host` has CLEARED (first seen 2026-11-13T06:01:28Z, cleared 2026-11-17T09:47:25Z).
> It was observed 24 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Comment acknowledgment condition cleared.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-4` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-4.md)

> WATCHDOG notice — occurrence #3 (first seen 2026-09-21T21:35:30Z, latest 2026-11-17T05:50:21Z).
> The SAME condition (`budget-level-cleric-endolin-garden-ece02cb4-4`) has now been observed 3 times; this is ONE
> coalesced notice that updates in place, not 3 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 cleric workers 3 -> 4 (target 4): shared codex subscription demand active=3 queue=7 quota=ok fleet-envelope=4 target=4

- `doomed-improve-dependabot-paused-post-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-improve-dependabot-paused-post-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/improve-dependabot-paused-post; it stays HELD until a human promotes it
> (promote-plan.sh improve-dependabot-paused-post) or removes it, so nothing is lost.
> Original job base: improve-dependabot-paused-post
>
> --- original job body ---
> ---
> posted_at: 2026-11-16T10:21:07Z
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> scripts/jobs/dependabot-watcher.sh
> scripts/jobs/dependabot-watcher.sh:1056 discards post-job’s rc=78, then lines 1059-1071 misclassify the deliberate pause refusal as a lost post every tick. Preserve and recognize GARDEN_PAUSED_RC, suppress the retry warning, and skip the paused PR until its pause is lifted; the same false warning recurred from 09:28:28Z through 10:19:55Z.

- `ironhorse-ci-failures-20261116-child-ironhorse-ci-4-remaining-20261116-failed` — from orchestrator:ironhorse-ci-failures-20261116-child-ironhorse-ci-4-remaining-20261116-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ci-failures-20261116-child-ironhorse-ci-4-remaining-20261116-failed.md)

> orchestration-event: orchestration-child-recovered
> orchestration: ironhorse-ci-failures-20261116
> orchestration-status: complete-with-failures
> child: ironhorse-ci-4-remaining-20261116
> recovered: true
>
> RECOVERED — orchestration ironhorse-ci-failures-20261116 finished reporting child ironhorse-ci-4-remaining-20261116 as failed; it has since reached a clean tada (no gated-failure declaration). The completion record now reads 'recovered after transient failure'.

- `doomed-build-oros-secrets-bwrap-handoff-20261106-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-build-oros-secrets-bwrap-handoff-20261106-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/build-oros-secrets-bwrap-handoff-20261106; it stays HELD until a human promotes it
> (promote-plan.sh build-oros-secrets-bwrap-handoff-20261106) or removes it, so nothing is lost.
> Original job base: build-oros-secrets-bwrap-handoff-20261106
>
> --- original job body ---
> ---
> posted_at: 2026-11-06T05:16:31Z
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> role: builder
> tier: mentor
> ---
> Maintainer directive (kriskowal, liaison session 2026-11-06): write the Oros Studio hand-off for the provider-secrets release, so the operator of `oros-studio-garden-ce242c49` (a Mac) can make that host capable of running the new bubblewrap sandbox before it deploys.
>
> Background. `1e1968c0781` (file-based provider key management) wraps each secret-bearing harness launch in `scripts/secrets/run-sandboxed.sh`, which exits 75 with "bubblewrap unavailable; refusing a secret-bearing harness" when `bwrap` is missing. On 2026-11-05 the leader deployed it without the container rebuild that `context/operations/secrets.md` § One-time compatibility migration requires, and the endolin fleet completed nothing for about 17 hours. Oros has not deployed it (its canary is held at 2c082b9acbc), so Oros is safe until it does. Do not let it deploy first.
>
> Deliverable: `context/operations/oros-secrets-handoff.md` on `main2` (pushed directly per the garden's no-PR convention), covering:
> 1. Why bubblewrap is Linux-only and how the garden container on a Mac (Docker Desktop or other Linux VM) acquires it: the `./garden build` image gains `bubblewrap`; state the exact Dockerfile and launcher change this requires, and confirm it is already in `main2`.
> 2. What the container must permit for bwrap to work inside it (unprivileged user namespaces, seccomp/AppArmor profile, `--cap-add`, `/proc` visibility), with a copy-paste smoke test such as `bwrap --ro-bind / / --unshare-all true` and the exact success/failure outputs. Check how `run-sandboxed.sh` invokes bwrap and list every capability it needs.
> 3. The ordered operator procedure for Oros: drain, `./garden build`, `./garden reset`, `./garden create`, the six-variable import (`scripts/secrets/import-environment.sh`, `scripts/secrets/status.sh`), verification that a harness job completes, then lift the drain. Note that placing keys is the operator's act; no agent handles values.
> 4. How to hold the Oros deploy until the operator confirms (name the existing mechanism, for example the `upgrade-ready` fact or a hold), and how the leader's rolling deploy should treat an Oros that cannot run bwrap.
> 5. A rollback if bwrap cannot be made to work on the Mac.
> Also report whether the deploy gate or canary should check `command -v bwrap` before advancing, and file that as a follow-up recommendation in your completion report rather than implementing it.

- `watchdog-self-heal-garden-foreman` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-self-heal-garden-foreman.md)

> WATCHDOG notice — occurrence #26 (first seen 2026-11-14T04:26:12Z, latest 2026-11-18T00:00:56Z).
> The SAME condition (`self-heal-garden-foreman`) has now been observed 26 times; this is ONE
> coalesced notice that updates in place, not 26 messages. Latest detail:
>
> self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: 7afed44518eaa6372dce2807f1b7a08905dfe395 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 7afed44518eaa6372dce2807f1b7a08905dfe395). Diagnosis: The foreman exited 78 because `post-job.sh` refused a job, not because the foreman crashed. The foreman proposed the next step `shepherd-endojs-endo-but-for-bots-pr1542-20261118`. The `minion-town` pause record (`pauses/minion-town.md`) has `match: minion\.town`, and it matched that job, so `post-job.sh` returned `GARDEN_PAUSED_RC=78`. At `scripts/jobs/foreman.sh:738` any non-zero post result other than the completed-collision and tempfail cases is fatal, so the foreman exits 78. That repeats every tick, and each tick the handler most likely proposes the same step again. The pause itself is working as intended. The bug is that the foreman has no handling for a paused-project refusal.
>
> JOB self-heal-fix-garden-foreman-paused-project-post-refusal
> In `scripts/jobs/foreman.sh`, in the post-job

- `doomed-ironhorse-ci2-1621-drift-20261117-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-ci2-1621-drift-20261117-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/ironhorse-ci2-1621-drift-20261117; it stays HELD until a human promotes it
> (promote-plan.sh ironhorse-ci2-1621-drift-20261117) or removes it, so nothing is lost.
> Original job base: ironhorse-ci2-1621-drift-20261117
>
> --- original job body ---
> ---
> role: fixer
> tier: mentor
> posted_at: 2026-11-17T05:31:59Z
> ---
> <!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-17T05:34:28Z cleared=none -->
>
> ---
> role: fixer
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> # Ironhorse CI: #1621 Node 26 and zizmor drift
>
> Repo endojs/endo-but-for-bots. Maintainer ask (kriskowal, liaison session 2026-11-16/17): clear the remaining CI reds on kriscendobot ironhorse PRs, per the report in the completed job ironhorse-ci-4-remaining-20261116 (journal tada/2026/11/16). The first attempt at this work exited plainly twice without a report, so: work in small steps, push as you go, and write a report (per PR: before/after check state, cause, commit pushed) even if you finish only part. Run CI-equivalent checks locally before pushing. Push only to kriscendobot-authored heads. Do not merge; nothing merges until the ratchet improves the base. The two oracle lanes (test-ironhorse-oracle, ironhorse-oracle-sanitizers: stage3-math 054/055, ubuntu-26.04 glibc) stay red until #1613 reaches the base; leave them alone. Do not weave unless the task below says so.
>
> Task: #1621 is red on test-xs (Node 26 ThrowTypeError intrinsic-metadata baseline drift) and zizmor (create-pull-request v8 pin-comment drift), beyond the oracle lanes. Cherry-pick d7af7dc927 and cc8c641deb onto the #1621 head, exactly as was done on #1614 (commit 613eedb3ed). Verify test-xs and zizmor go green.

- `watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #7 (first seen 2026-11-12T22:56:07Z, latest 2026-11-16T11:47:09Z).
> The SAME condition (`rolling-deploy-canary-failed-oros-studio-garden-ce242c49`) has now been observed 7 times; this is ONE
> coalesced notice that updates in place, not 7 messages. Latest detail:
>
> Rolling deploy HALTED on a failed canary.
> canary host: oros-studio-garden-ce242c49
> target sha:  0dda301cbeb484d69447f7c60214788924464f8c
> failing signal: 1 failed unit(s) (first: garden-secret-broker.service)
> This canary was RETRIED 3 time(s) automatically and kept
> failing, so the roll has stopped retrying and now needs YOU. This is a persistent,
> confirmed regression, not a transient blip — treat it as higher severity than a
> first-tick halt.
> The roll released no further followers and the LEADER did NOT advance itself — a
> broken tip that fails a canary never reaches the leader. The canary was left DRAINED
> (benign roll-induced drain op) pending your decision; auto-rollback is deliberately not
> performed (designs/follower-self-deploy.md § Failure handling). Investigate the target
> on oros-studio-garden-ce242c49, then lift its drain and re-trigger, or hold the tip. (leader=endolin-garden-ece02cb4)

- `ironhorse-ci-failures-20261116-child-ironhorse-ci-3-ironhorse-lanes-20261116-failed` — from orchestrator:ironhorse-ci-failures-20261116-child-ironhorse-ci-3-ironhorse-lanes-20261116-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ci-failures-20261116-child-ironhorse-ci-3-ironhorse-lanes-20261116-failed.md)

> orchestration-event: orchestration-child-failure
> orchestration: ironhorse-ci-failures-20261116
> orchestration-status: running
> child: ironhorse-ci-3-ironhorse-lanes-20261116
> failure-kind: doomed
> order: serial
> on-child-failure: continue
> detail: doomed and held in plan
>
> Orchestration ironhorse-ci-failures-20261116 observed child ironhorse-ci-3-ironhorse-lanes-20261116: doomed and held in plan.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_reducer_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_reducer_journal.md)

> WATCHDOG notice — occurrence #14 (first seen 2026-11-06T02:46:39Z, latest 2026-11-17T22:44:06Z).
> The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_reducer_journal`) has now been observed 14 times; this is ONE
> coalesced notice that updates in place, not 14 messages. Latest detail:
>
> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.037286s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `watchdog-journal-push-contention-_home_kris_garden__garden_state_producer_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-push-contention-_home_kris_garden__garden_state_producer_journal.md)

> RECOVERED — the watchdog condition `journal-push-contention-_home_kris_garden__garden_state_producer_journal` has CLEARED (first seen 2026-11-16T07:42:33Z, cleared 2026-11-16T12:22:27Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-push-contention-_home_kris_garden__garden_state_producer_journal` cleared on endolin-garden-ece02cb4.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-3` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-3.md)

> WATCHDOG notice — occurrence #6 (first seen 2026-09-17T00:05:19Z, latest 2026-11-17T11:05:24Z).
> The SAME condition (`budget-level-cleric-endolin-garden-ece02cb4-3`) has now been observed 6 times; this is ONE
> coalesced notice that updates in place, not 6 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 cleric workers 4 -> 3 (target 1): shared codex subscription demand active=2 queue=1 quota=backoff fleet-envelope=4 target=1

- `msg-minion-town-arc-press-20261108-082012-76df4c8f6ed9` — from gardener:minion-town-arc-press-20261108-082012, reply_to `minion-town-arc-press-20261108-082012` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-arc-press-20261108-082012-76df4c8f6ed9.md)

> minion.town arc supervisor (issue [kriscendobot/garden#58](https://github.com/kriscendobot/garden/issues/58)) is blocked on one garden-ops decision.
>
> The leader endolin-garden-ece02cb4 still runs f2788117645. The EROFS fix (3c7f9ce045e, now main2 21585bda2b3) cannot reach it because the rolling deploy rolls the follower oros-studio-garden-ce242c49 first as a canary, and oros has stopped claiming any job: canary probes for f278/3c7f/21585 all failed (last 04:11Z today), and 14 oros-health-checkup jobs sit unclaimed in todo. Until the leader deploys, every monk job that needs a project checkout dies EROFS, so all minion.town PR work is parked ([kriscendobot/minion.town#246](https://github.com/kriscendobot/minion.town/issues/246) weave+conduct; panels for [kriscendobot/minion.town#237](https://github.com/kriscendobot/minion.town/issues/237), [kriscendobot/minion.town#252](https://github.com/kriscendobot/minion.town/issues/252), [kriscendobot/minion.town#248](https://github.com/kriscendobot/minion.town/issues/248); the [kriscendobot/minion.town#248](https://github.com/kriscendobot/minion.town/issues/248) follow-up; the waitlist browser check; and [kriscendobot/minion.town#254](https://github.com/kriscendobot/minion.town/issues/254), which needs more gauntlet rounds).
>
> Question: do you want to (a) revive oros, or (b) authorize deploying the leader to main2 past the dead canary (deploy-garden.sh on the leader, or the deploy-on-upgrade override)? I will re-arm the parked minion.town jobs as soon as the leader runs 3c7f9ce or later.

- `watchdog-journal-lock-contention-_Users_dom_garden__garden_state_regenerate_sections_index_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_Users_dom_garden__garden_state_regenerate_sections_index_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_Users_dom_garden__garden_state_regenerate_sections_index_journal` has CLEARED (first seen 2026-11-14T00:43:02Z, cleared 2026-11-16T06:41:36Z).
> It was observed 3 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_Users_dom_garden__garden_state_regenerate_sections_index_journal` cleared on oros-studio-garden-ce242c49.

- `foreman-milestone-M3` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/foreman-milestone-M3.md)

> COALESCED message — occurrence #25 (first seen 2026-11-14T04:34:56Z, latest 2026-11-17T03:51:51Z).
> The SAME message (episode key `foreman-milestone-M3`) has now been sent 25 times; this is
> ONE entry that updates in place, not 25 messages. Latest detail:
>
> M3’s minion-town git-remote path is blocked on maintainer review of [endojs/endo-but-for-bots#1557](https://github.com/endojs/endo-but-for-bots/issues/1557); its next implementation slices are already represented by open PRs. Decide whether to approve that capability-URL foundation (and the stalled #1595/#1589 review outcomes) before more work is posted.

- `liaison-followup-8749de239f39` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/liaison-followup-8749de239f39.md)

> Report ironhorse-ci2-1346-1299-20261117: ironhorse PRs #1346 and #1299 on endojs/endo-but-for-bots.
>
> - **Oracle lanes:** `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` fail only on stage3-math 054/055. That is the known ubuntu-26.04 glibc issue, and it waits on #1613. No action is needed.
> - **Other reds:** the latest pushes triggered a full CI run. It shows new failures on both PRs outside ironhorse: `cover`/`test` (22.x, 24.x ubuntu), `test-xs` (hardened262), `sandbox-drivers` (bwrap), and `zizmor`. The worker did not touch anything outside `rust/engine`. It suspects drift in the old base (Node 26, zizmor floating tags, known bwrap failures) but did not confirm that by running the checks on the base itself.
> - **Decision for you:** should the garden weave both PRs onto current `llm` to clear these? The worker flagged this as a separate decision. It would change the merge base on two in-flight PRs, and the weave could itself introduce conflicts. I have not posted a weave job. Tell me to weave them, or to wait until #1613 lands and the base improves.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_screening_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_screening_journal.md)

> WATCHDOG notice — occurrence #5 (first seen 2026-11-13T20:39:29Z, latest 2026-11-17T22:44:12Z).
> The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_screening_journal`) has now been observed 5 times; this is ONE
> coalesced notice that updates in place, not 5 messages. Latest detail:
>
> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/screening/journal: p95=0.024496s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `doomed-dependabotany-recheck-endo-but-for-bots-20261107-013512-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-dependabotany-recheck-endo-but-for-bots-20261107-013512-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/dependabotany-recheck-endo-but-for-bots-20261107-013512; it stays HELD until a human promotes it
> (promote-plan.sh dependabotany-recheck-endo-but-for-bots-20261107-013512) or removes it, so nothing is lost.
> Original job base: dependabotany-recheck-endo-but-for-bots-20261107-013512
>
> --- original job body ---
> ---
> handler-timeout: 7200
> ---
>
> Dependabotany active-row snapshot (v1):
>
> - Journal HEAD: `82d9fde9072bb03ff8b25e26834135cf01d69a22`
> - Project: `endo-but-for-bots`
> - Repository: `endojs/endo-but-for-bots`
> - Rows: 1
>
> This normalized snapshot is authoritative only when your synced journal HEAD
> is exactly the commit above. If it matches, consume these rows directly and do
> not reconstruct the unindexed prose ledger. If the snapshot is unavailable,
> malformed, or HEAD has changed, fail open to the role's case-insensitive full scan.
>
> ```tsv
> maturity_date	pr	source
> 2026-11-06	1629	entries/2026/11/05/081237Z-message-gardener-6ade4e.md
> ```
>
> ---
>
> ---
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> Wear roles/botanist/AGENT.md and re-evaluate every open PR in the endo-but-for-bots dependabotany ledger whose maturity date has arrived or whose recorded blocker has cleared. Recover the ledger with: grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -il '^# *dependabotany'. Execute the now-due verdict for each PR: MERGE-NOW through ci-wait-merge.sh --dependabot-auto-merge, REJECT closes, EMBARGO re-defers. Current row: #1629 (setup-python 7.1.0) is held on [endojs/endo-but-for-bots#1613](https://github.com/endojs/endo-but-for-bots/issues/1613) and #1646.

- `ironhorse-ratchet-halted-ironhorse-test262-press-20261113-225326` — from ironhorse-test262-ratchet, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ratchet-halted-ironhorse-test262-press-20261113-225326.md)

> Ironhorse ratchet halted: multiple open ratchet PRs; one crank at a time
> Tracker: [https://github.com/kriscendobot/garden/issues/51](https://github.com/kriscendobot/garden/issues/51)
> Inspect ratchets/ironhorse-test262-ratchet/state.json and
> context/operations/ironhorse-ratchet.md. Explicitly resume only after resolution.

- `doomed-endojs-endo-but-for-bots-pr1591-gauntlet-panel-1-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-endojs-endo-but-for-bots-pr1591-gauntlet-panel-1-requeue-exhausted.md)

> GAUNTLET stage PARKED in jobs/plan/ after its first non-productive failure on endolin-garden-ece02cb4.
> The reaper spent no generic retry and applied no ordinary split; gauntlet endojs-endo-but-for-bots-pr1591-gauntlet exclusively owns retry through max_stage_retries.
> The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr1591-gauntlet-panel-1; it stays HELD until a human promotes it
> (promote-plan.sh endojs-endo-but-for-bots-pr1591-gauntlet-panel-1) or removes it, so nothing is lost.
> Original job base: endojs-endo-but-for-bots-pr1591-gauntlet-panel-1
>
> --- original job body ---
> ---
> role: gardener
> handler-budget-role: panel
> handler-timeout: 10800
> gauntlet: endojs-endo-but-for-bots-pr1591-gauntlet
> gauntlet_stage: panel
> gauntlet_iteration: 1
> pr: [https://github.com/endojs/endo-but-for-bots/pull/1591](https://github.com/endojs/endo-but-for-bots/pull/1591)
> ---
>
> # Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1591
>
> You are ONE stage of a staged gauntlet (endojs-endo-but-for-bots-pr1591-gauntlet). Run the deterministic read-only
> style pre-pass against the pinned base/head. Only if it passes, run EXACTLY ONE
> panel round and post the verdict. Then STOP — do NOT fix, do NOT un-draft, do not
> loop.
>
> Garden script names below are repo-relative. Resolve them against THIS claiming
> worker's `$GARDEN_ROOT` (known by `scripts/jobs/common.sh`), never against the
> posting host's garden root.
>
> 1. Before dispatching any juror, retain the PR's immutable baseRefOid and
>    headRefOid (both full 40-hex commit IDs), along with its head owner and branch.
>    Get an ISOLATED project checkout of that head:
>    `scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr1591-gauntlet-panel-1 <pr-head-owner>/<repo-name> <pr-head-branch>`.
>    Resolve all four retained fields with `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1591 --json baseRefOid,headRefOid,headRepositoryOwner,headRefName`;
>    do not pass the base repo when the PR head belongs to a fork.
>    Fetch the retained objects if necessary, check out the retained head object ID
>    detached, and verify git rev-parse HEAD equals it. A missing/malformed object ID
>    or head mismatch is a sensor failure: do not run probes or panel; emit
>    panel=panel-error.
> 2. Run the deterministic probes read-only against that exact pinned pair with
>    `scripts/jobs/gardening/pre-push-gates.sh --no-auto-fix --probes-only \
>      --base-ref <base-object-id> <worktree>`.
>    Capture combined stdout/stderr byte-for-byte. On non-zero, do NOT
>    run panel.sh and do NOT post a PR review. Put the exact captured output between
>    these lines in the completion report, then emit panel=prepass-failed:
>
>    <!-- gauntlet-style-prepass-output-begin -->
>    <exact combined stdout/stderr, unchanged>
>    <!-- gauntlet-style-prepass-output-end -->
>
>    This is a deterministic finding, not a panel verdict. The driver routes that
>    exact block to fix-1 and only spends juror seats after the probes pass.
> 3. Only after the probes exit 0, run the panel in SINGLE-ROUND mode against that
>    same worktree and retained base object ID:
>    `GARDEN_PANEL_SINGLE_ROUND=1 \
>      scripts/jobs/gardening/panel.sh <worktree> 1591 <base-object-id>`
>    It fans the seats, aggregates, preflights the PR author against the authenticated
>    login, and posts its own formal review. A must-fix result normally requests
>    changes; on a self-authored PR it posts the same aggregate as a comment review,
>    retaining the `Must-fix before merge` heading. It does NOT fix or un-draft.
>    Only after the review post succeeds does it print the existing stage-result
>    marker followed by a terminal line whose last token is `pass` or `must-fix`.
>    Copy that marker into your completion report; do not post the aggregate yourself.
> 4. If panel.sh exits NON-ZERO it did NOT return a posted review verdict. A seat error, a
>    decider error, or a supervisor interruption is an INFRASTRUCTURE (sensor)
>    failure, not a pass/must-fix decision. Do NOT report `orchestration-failed:
>    true` (that halts the whole gauntlet on one transient blip). Complete NORMALLY
>    and emit the `panel=panel-error` marker: the driver then re-posts this panel
>    round under its bounded stage-retry budget, exactly as it retries a doomed
>    transient stage. A genuine pass/must-fix verdict (panel.sh exit 0) always uses
>    its own marker below — never panel-error.
>
> Put EXACTLY ONE of these marker lines on its own line immediately BEFORE the
> completion signal; the completion signal itself stays the very last line:
>   <!-- gauntlet-stage-result: panel=pass -->         (panel.sh exit 0, disposition pass)
>   <!-- gauntlet-stage-result: panel=must-fix -->     (panel.sh exit 0, disposition must-fix)
>   <!-- gauntlet-stage-result: panel=prepass-failed --> (read-only deterministic probes failed; no juror dispatched)
>   <!-- gauntlet-stage-result: panel=panel-error -->  (panel.sh non-zero: seat/decider error or interruption — a sensor failure, retried)

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-3` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-3.md)

> budget-level changed endolin-garden-ece02cb4 monk workers 4 -> 3 (target 3): subscription claude-endolin1 spend=23878888 cap=271000000 pace-bias=0 window-start=2026-11-14T04:00Z(calendar) deadline=2026-11-21T04:00Z(calendar) ceiling=4 backoff=0.5136(ramp) target=3

- `endojs-endo-but-for-bots-pr1504-gauntlet-20261114-halted` — from gauntlet:endojs-endo-but-for-bots-pr1504-gauntlet-20261114-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-pr1504-gauntlet-20261114-halted.md)

> Gauntlet endojs-endo-but-for-bots-pr1504-gauntlet-20261114 HALTED: stage 'endojs-endo-but-for-bots-pr1504-gauntlet-20261114-fix-1' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.
>
> Unaddressed must-fix: unknown · list unavailable (panel report has no structured must-fix list) · rounds spent: 1/8 · cost so far: $4.77
> Severity: this list is every request-changes seat bullet. The panel blocks only on real defects (wrong behavior, security or authority errors, data loss, broken contracts, failing or missing tests for changed behavior, comments false enough to invite an unsafe change); comment or JSDoc wording, identifier spelling or style, commit-history tidiness, PR-description completeness, and test-style items are should-fix and never block (skills/panel/SKILL.md § Finding severity).
>
> To resume: scripts/jobs/gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1504-gauntlet-20261114 panel --iteration 1 --add-rounds 2
> --add-rounds 2 grants 2 more panel/fix round(s): max_iterations 8 -> 10 (N is yours to choose).

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal.md)

> WATCHDOG notice — occurrence #15 (first seen 2026-11-07T04:46:32Z, latest 2026-11-17T14:48:45Z).
> The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal`) has now been observed 15 times; this is ONE
> coalesced notice that updates in place, not 15 messages. Latest detail:
>
> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.016710s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `ironhorse-ci2-refresh-1298-1534-20261117-split-terminal-complete-with-failures` — from orchestrator:ironhorse-ci2-refresh-1298-1534-20261117-split-terminal-complete-with-failures, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ci2-refresh-1298-1534-20261117-split-terminal-complete-with-failures.md)

> orchestration-event: orchestration-terminal
> orchestration: ironhorse-ci2-refresh-1298-1534-20261117-split
> orchestration-status: complete-with-failures
> order: parallel
> children-total: 2
> children-failed: 1
> failed-children: ironhorse-ci2-1534-verify-20261117
> recovered-children: 
>
> Orchestration ironhorse-ci2-refresh-1298-1534-20261117-split complete WITH FAILURES (parallel): 1/2 failed: ironhorse-ci2-1534-verify-20261117

- `msg-reset-credit-watch-20261109-170519-6a0254967ba8` — from gardener:reset-credit-watch-20261109-170519, reply_to `reset-credit-watch-20261109-170519` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-reset-credit-watch-20261109-170519-6a0254967ba8.md)

> Reset-credit watch 2026-11-09: no action this week. No live credits are left: the codex 11-06 credit has expired (codex rolled to 0% about 11-04T22:05Z; if that was the credit, it was used in time). Status: claude-endolin1 is at 12% (about 5%/day, roughly 33% by its 11-14T04:00Z reset), no credits. claude-oros is at 26%, resets 11-10T11:00Z, credits unknown. codex-endolin was at 24% on 11-05 (the meter anchor is stale), resets about 11-11T18:05Z, no credits. claude-endolin2 is retired. If you're granted new credits, tell the liaison and I'll plan around them.

- `watchdog-self-heal-garden-mentor` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-self-heal-garden-mentor.md)

> WATCHDOG notice — occurrence #4 (first seen 2026-09-25T20:50:35Z, latest 2026-11-16T09:51:58Z).
> The SAME condition (`self-heal-garden-mentor`) has now been observed 4 times; this is ONE
> coalesced notice that updates in place, not 4 messages. Latest detail:
>
> self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: e2e14d2c83bb00f31fb768358ca466435b13a5f2 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p e2e14d2c83bb00f31fb768358ca466435b13a5f2). Diagnosis: The failure is a code defect, not a transient one. I didn't read the surrounding code beyond the lines around the `die` call.
>
> `mentor.sh` ran its improve handler. The handler tried to post `improve-dependabot-post-outbox`, which belongs to the paused project `minion-town`. `post-job.sh` refused with rc=78. `mentor.sh` then called `die` ("improve handler failed; leaving markers so the next tick retries"). The markers never advance, so every tick hits the same refusal and fails again. Systemd restarts the unit and the loop repeats. The pause is deliberate, so the mentor should skip these jobs instead of failing.
>
> JOB self-heal-fix-garden-mentor-paused-project-post-rc78
> `scripts/jobs/mentor.sh` fails in a loop. The improve handler tries to post `improve-dependabot-post-outbox`, which belongs

- `doomed-ironhorse-ci2-1359-20261117-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-ironhorse-ci2-1359-20261117-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/ironhorse-ci2-1359-20261117; it stays HELD until a human promotes it
> (promote-plan.sh ironhorse-ci2-1359-20261117) or removes it, so nothing is lost.
> Original job base: ironhorse-ci2-1359-20261117
>
> --- original job body ---
> ---
> role: fixer
> tier: mentor
> posted_at: 2026-11-17T05:31:59Z
> ---
> <!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-17T05:34:38Z cleared=none -->
>
> ---
> role: fixer
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> # Ironhorse CI: #1359 cover, zizmor, test-xs
>
> Repo endojs/endo-but-for-bots. Maintainer ask (kriskowal, liaison session 2026-11-16/17): clear the remaining CI reds on kriscendobot ironhorse PRs, per the report in the completed job ironhorse-ci-4-remaining-20261116 (journal tada/2026/11/16). The first attempt at this work exited plainly twice without a report, so: work in small steps, push as you go, and write a report (per PR: before/after check state, cause, commit pushed) even if you finish only part. Run CI-equivalent checks locally before pushing. Push only to kriscendobot-authored heads. Do not merge; nothing merges until the ratchet improves the base. The two oracle lanes (test-ironhorse-oracle, ironhorse-oracle-sanitizers: stage3-math 054/055, ubuntu-26.04 glibc) stay red until #1613 reaches the base; leave them alone. Do not weave unless the task below says so.
>
> Task: #1359 is red on cover 22.x/24.x (bwrap timeout flake: port the #1566 fix), zizmor (pin-comment drift), and test-xs (RegExpPrototype intrinsic-metadata on the ironhorse lanes, possibly a real baseline shift from this PR's RegExp accessor change). Decide which, fix the first two, and for test-xs update the baseline only if the shift is genuinely this PR's intended change; otherwise say what it is. Mind that the ratchet delegation applies: do not weave or merge.

- `watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_library_link_check_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_library_link_check_journal.md)

> RECOVERED — the watchdog condition `journal-fetch-slow-_Users_dom_garden__garden_state_library_link_check_journal` has CLEARED (first seen 2026-11-14T15:29:00Z, cleared 2026-11-14T21:24:19Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-fetch-slow-_Users_dom_garden__garden_state_library_link_check_journal` cleared on oros-studio-garden-ce242c49.

- `doomed-reset-credit-watch-20261116-170511-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-reset-credit-watch-20261116-170511-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/reset-credit-watch-20261116-170511; it stays HELD until a human promotes it
> (promote-plan.sh reset-credit-watch-20261116-170511) or removes it, so nothing is lost.
> Original job base: reset-credit-watch-20261116-170511
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> **Role: accountant.** Weekly **reset-credit watch**: keep an eye on the garden's manual quota-reset credits, work out how best to use them, and send the maintainer **one recommendation in the maintainer inbox** (`message-user.sh <your-base>`).
>
> Standing maintainer direction (kriskowal, 2026-09-30): "We should plan to use these resets mid-week before they expire."
>
> **Inputs (read first):**
> - `journal2:projects/garden/reset-credits.md` is the credit inventory, expiries and use log. It is the source of truth for what credits exist; only the maintainer creates credits.
> - The latest dashboard checkpoints (`budget/manual-checkpoints/*.jsonl`), the live meter (`budget/live/*`), reset events (`budget/reset-events/*.jsonl`) and the true-cap estimates (`fit-quota-calibration.sh --dry-run`).
> - Natural boundaries:
>   - Claude endolin subscriptions reset Friday 20:00 America/Los_Angeles.
>   - codex-endolin resets on a rolling 7 days from its last reset.
>
> **Policy:** the target is to spend a subscription to **90%, never 100%**, then reset. The last 10% is maintainer discretion. A credit is worth the most when it is used **mid-week**, once the subscription reaches about 90% well before its natural reset, and **before the credit expires**. A credit used just before a natural reset is mostly wasted. A credit that expires unused is fully wasted.
>
> **Each week:**
> 1. Reconcile the inventory against this week's evidence (any maintainer messages, reset events).
>    - If a credit looks used or expired, update `reset-credits.md` with `scripts/jobs/land-journal-edit.sh projects/garden/reset-credits.md`.
>    - Never invent credits.
> 2. For each subscription with a live credit, estimate from current pace when it will cross 90% and how that compares with its natural reset and the credit's expiry.
> 3. **Recommend** a concrete plan: which credit, which subscription, and a target day and time window, for example "burn claude-endolin2 to 90% by Wed, reset Wed evening PT; the credit expires Oct 22".
>    - Say whether the fleet should **accelerate** first (a near planned deadline via `append-reset-event.sh --type expected-next-scheduled`, plus worker counts) to reach 90% in time.
>    - Say whether a credit is at risk of expiring unused.
>    - Include a one-line status for every subscription (current %, pace, natural reset, credits and expiries).
> 4. **Send the recommendation** with `message-user.sh`, one concise message. **Do not actuate:** do not change budget pools, backoff fraction, worker counts or reset events yourself. The maintainer decides, and the liaison executes.
> 5. Complete the job, noting whether the recommendation needs a timely decision (for example a credit expiring within 10 days).
>
> Keep it short: one screen. If nothing is actionable (no live credits, or none near expiry), send a one-line "no action this week" status and finish.

- `watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_fleet_health_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_fleet_health_journal.md)

> RECOVERED — the watchdog condition `journal-fetch-slow-_Users_dom_garden__garden_state_fleet_health_journal` has CLEARED (first seen 2026-11-16T08:22:57Z, cleared 2026-11-16T14:17:13Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-fetch-slow-_Users_dom_garden__garden_state_fleet_health_journal` cleared on oros-studio-garden-ce242c49.

- `ironhorse-ci-failures-round2-20261117-child-ironhorse-ci2-refresh-1298-1534-20261117-failed` — from orchestrator:ironhorse-ci-failures-round2-20261117-child-ironhorse-ci2-refresh-1298-1534-20261117-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ci-failures-round2-20261117-child-ironhorse-ci2-refresh-1298-1534-20261117-failed.md)

> orchestration-event: orchestration-child-recovered
> orchestration: ironhorse-ci-failures-round2-20261117
> orchestration-status: running
> child: ironhorse-ci2-refresh-1298-1534-20261117
> recovered: true
>
> RECOVERED — orchestration ironhorse-ci-failures-round2-20261117 had reported child ironhorse-ci2-refresh-1298-1534-20261117 as failed; it has since reached a clean tada (no gated-failure declaration). The earlier failure reading was transient and is superseded.

- `watchdog-journal-push-contention-_home_kris_garden__garden_state_gardener_scaler_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-push-contention-_home_kris_garden__garden_state_gardener_scaler_journal.md)

> RECOVERED — the watchdog condition `journal-push-contention-_home_kris_garden__garden_state_gardener_scaler_journal` has CLEARED (first seen 2026-11-12T22:23:42Z, cleared 2026-11-13T04:18:42Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-push-contention-_home_kris_garden__garden_state_gardener_scaler_journal` cleared on endolin-garden-ece02cb4.

- `doomed-issue-status-pass-go-live-20261117-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-issue-status-pass-go-live-20261117-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/issue-status-pass-go-live-20261117; it stays HELD until a human promotes it
> (promote-plan.sh issue-status-pass-go-live-20261117) or removes it, so nothing is lost.
> Original job base: issue-status-pass-go-live-20261117
>
> --- original job body ---
> ---
> tier: minion
> model-burned: mentor
> fallback-tier: 
> dispatch: automatic
> ---
> # Go live with the issue status pass (third observation window)
>
> Role: builder. Garden repo, direct to main2. Successor of
> `issue-status-pass-go-live-20261116`, which checked the leader on 2026-11-16 at
> 06:06 UTC and found its recorded deployed SHA was still
> `c2a2b3c899aa9770491212d2a60107f64404f38d` (marker mtime
> 2026-11-12T21:15:39Z), so fix `66ab9cc2018` was not yet deployed. The host's
> upgrade-ready record named `c4766a84510b81a84541434d3ffba17b10e8d4ce`, 10
> commits ahead, at 2026-11-16T06:02:01Z.
>
> 1. Confirm the leader's deployed root contains `66ab9cc2018`
>    (`git -C <worktree> merge-base --is-ancestor 66ab9cc2018 <deployed HEAD>`;
>    find the deployed HEAD without running git in the garden root, using
>    `$GARDEN_ROOT/.garden-state/deploy/deployed-sha`). Only logs AFTER that deploy
>    count; if it has been under a day, re-defer with `set-schedule-once.sh`.
> 2. Compare `journalctl --user -u garden-issue-status` "DRY RUN would post" lines
>    (post-deploy, at least a day) against the `kriscendobot/garden` issue threads.
>    Every would-post must be a maintainer arrival (issue, or comment whose first
>    line begins `@kriscendobot `) with no bot comment for 20+ min (5+ under a deep
>    queue). Nothing answered in time may appear.
> 3. If they match: delete `Environment=GARDEN_ISSUE_STATUS_DRY_RUN=1` from
>    `scripts/systemd/garden-issue-status.service`, flip the script default
>    (`: "${GARDEN_ISSUE_STATUS_DRY_RUN:=0}"`), update the unit/script/design/
>    context/operations/systemd-units.md wording, run
>    `scripts/jobs/test/issue-status-pass-test.sh`, commit, and push. If not, fix
>    and restart the observation window.
>
> Trigger: [https://github.com/kriscendobot/garden/issues/128](https://github.com/kriscendobot/garden/issues/128)

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_deadline_nudge_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_deadline_nudge_journal.md)

> WATCHDOG notice — occurrence #6 (first seen 2026-11-14T02:44:48Z, latest 2026-11-17T15:28:44Z).
> The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_deadline_nudge_journal`) has now been observed 6 times; this is ONE
> coalesced notice that updates in place, not 6 messages. Latest detail:
>
> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=0.019916s, giveups=2, steals=0 (max 3/window), wait floor=60s.

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-1.md)

> budget-level changed endolin-garden-ece02cb4 monk workers 2 -> 1 (target 1): subscription claude-endolin1 spend=145816116 cap=271000000 pace-bias=0 window-start=2026-11-14T04:00Z(calendar) deadline=2026-11-21T04:00Z(calendar) ceiling=4 backoff=0.6453(ramp) target=1

- `watchdog-minion-town-screening-tick-failed-endolin-garden-ece02cb4` — from watchdog:self-heal, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-minion-town-screening-tick-failed-endolin-garden-ece02cb4.md)

> RECOVERED — the watchdog condition `minion-town-screening-tick-failed-endolin-garden-ece02cb4` has CLEARED (first seen 2026-11-13T05:53:04Z, cleared 2026-11-17T08:29:17Z).
> It was observed 12 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> minion.town screening on endolin-garden-ece02cb4 completed after a 12-tick failure streak.

- `watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_regenerate_topics_counts_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_regenerate_topics_counts_journal.md)

> RECOVERED — the watchdog condition `journal-fetch-slow-_Users_dom_garden__garden_state_regenerate_topics_counts_journal` has CLEARED (first seen 2026-11-13T18:27:29Z, cleared 2026-11-14T00:17:50Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-fetch-slow-_Users_dom_garden__garden_state_regenerate_topics_counts_journal` cleared on oros-studio-garden-ce242c49.

- `watchdog-journal-lock-contention-_Users_dom_garden__garden_state_fork_watch_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_Users_dom_garden__garden_state_fork_watch_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_Users_dom_garden__garden_state_fork_watch_journal` has CLEARED (first seen 2026-11-14T06:43:38Z, cleared 2026-11-14T12:49:05Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_Users_dom_garden__garden_state_fork_watch_journal` cleared on oros-studio-garden-ce242c49.

- `watchdog-journal-lock-contention-_Users_dom_garden__garden_state_repo_watcher_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_Users_dom_garden__garden_state_repo_watcher_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_Users_dom_garden__garden_state_repo_watcher_journal` has CLEARED (first seen 2026-11-14T12:44:26Z, cleared 2026-11-17T20:38:25Z).
> It was observed 4 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_Users_dom_garden__garden_state_repo_watcher_journal` cleared on oros-studio-garden-ce242c49.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_reaper_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_reaper_journal.md)

> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reaper/journal: p95=0.025805s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `ironhorse-ci-failures-round2-20261117-child-ironhorse-ci2-1359-20261117-failed` — from orchestrator:ironhorse-ci-failures-round2-20261117-child-ironhorse-ci2-1359-20261117-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ci-failures-round2-20261117-child-ironhorse-ci2-1359-20261117-failed.md)

> orchestration-event: orchestration-child-failure
> orchestration: ironhorse-ci-failures-round2-20261117
> orchestration-status: running
> child: ironhorse-ci2-1359-20261117
> failure-kind: doomed
> order: parallel
> on-child-failure: continue
> detail: doomed and held in plan
>
> Orchestration ironhorse-ci-failures-round2-20261117 observed child ironhorse-ci2-1359-20261117: doomed and held in plan.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_foreman_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_foreman_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_home_kris_garden__garden_state_foreman_journal` has CLEARED (first seen 2026-11-14T09:14:51Z, cleared 2026-11-17T16:43:43Z).
> It was observed 4 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_home_kris_garden__garden_state_foreman_journal` cleared on endolin-garden-ece02cb4.

- `msg-minion-town-arc-press-20261110-163511-75a23ad64b38` — from gardener:minion-town-arc-press-20261110-163511, reply_to `minion-town-arc-press-20261110-163511` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-arc-press-20261110-163511-75a23ad64b38.md)

> minion.town production went dark at about 13:14Z today (2026-11-10), and the cause is DNS, not the app. Is this repoint yours?
>
> What I found:
> - The authoritative Route53 answer (awsdns, TTL 60) for both `minion.town` and `ocap.site` is now `34.225.237.208`, an Amazon address that looks like us-east-1. The documented production host is EC2 `i-0380cd68b90020fad`, EIP `13.56.17.18`, in us-west-1.
> - `npm.`, `ci.`, `github-idp.` and `siwe-idp.minion.town` no longer resolve at all, so the zone seems to have been rewritten down to its apex records.
> - The new address runs Caddy and serves a static "Minion Town" page that says "There are no accounts here". Every app route (`/mcp`, `/api/guest`, `/soon`, the clips on `*.ocap.site`) answers 404.
> - The real host is healthy. Pinned to `13.56.17.18`, `/mcp` answers 401 and `/soon` answers 200.
> - Effects: the prod probe has been red since 14:52Z ([https://github.com/kriscendobot/minion.town/issues/256](https://github.com/kriscendobot/minion.town/issues/256)), and the garden's MCP watchdog has reported the connection lost since 13:14Z.
>
> This garden host has no AWS credentials, and no journal record or repo commit explains the change, so I have not touched DNS.
>
> The question: if you made this change on purpose (a rebuild or a new direction), say so and I will re-baseline the arc and the probe. If you didn't, it is a possible zone compromise. Restoring the A records for the apex and the subdomains to `13.56.17.18` needs you or a credentialed host, and the Route53 change history should be checked.

- `watchdog-journal-fetch-slow-_home_kris_garden__garden_state_cursors_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_home_kris_garden__garden_state_cursors_journal.md)

> RECOVERED — the watchdog condition `journal-fetch-slow-_home_kris_garden__garden_state_cursors_journal` has CLEARED (first seen 2026-11-14T11:30:07Z, cleared 2026-11-14T11:34:48Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-fetch-slow-_home_kris_garden__garden_state_cursors_journal` cleared on endolin-garden-ece02cb4.

- `20261116T172527Z-fcf009` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261116T172527Z-fcf009.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: reset-credit-watch-20261116-170511
> - question (msgid msg-reset-credit-watch-20261116-170511-67f84f092a4c.md)
> - tentative answer: Proxy/tentative (the maintainer may revise): Agreed with the watch's conclusion. This is a status report, not a gating decision, so I'm treating it as informational.
>
> - Take no action this week. Don't reset, accelerate, or place any marker. No live credits exist, and none is at expiry risk.
> - The projections look fine as they stand:
>   - claude-endolin1 is expected to reach about 90% before its natural reset on Fri 11-20.
>   - codex-endolin is expected to reach about 88% before its natural reset on Wed 11-18.
> - Neither account is projected to exhaust its quota. If claude-endolin1 gets close to its ceiling early, route the overflow to Codex or other pools as usual. Don't raise the Claude pool cap.
> - Keep claude-oros's credits as "unknown, treated as none." Re-run the watch next week. If the maintainer reports newly granted credits, plan them mid-week.
> - No reply is needed from the maintainer.

- `msg-improve-byte-capacity-guard-f6ab3d56da32` — from gardener:improve-byte-capacity-guard, reply_to `improve-byte-capacity-guard` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-improve-byte-capacity-guard-f6ab3d56da32.md)

> FYI from improve-byte-capacity-guard: host endolin-garden-ece02cb4's /home/kris/garden filesystem (/dev/nvme0n1p2, ~3.6 TiB) is at ~176-500 MiB free right now and briefly hit 0 during this job (a Claude tmp write failed with ENOSPC; tests can't use /dev/shm, which is noexec). The new root-repo-guard byte detector (main2 a6b75fe4c08, 5 GiB floor) will page on this once deployed, but the space needs reclaiming by hand now: du -xsh under .garden-state, scratch/, worktrees/.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_scheduler_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_scheduler_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_home_kris_garden__garden_state_scheduler_journal` has CLEARED (first seen 2026-11-14T02:49:43Z, cleared 2026-11-14T08:45:02Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_home_kris_garden__garden_state_scheduler_journal` cleared on endolin-garden-ece02cb4.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal.md)

> WATCHDOG notice — occurrence #14 (first seen 2026-11-06T04:41:40Z, latest 2026-11-17T12:58:35Z).
> The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal`) has now been observed 14 times; this is ONE
> coalesced notice that updates in place, not 14 messages. Latest detail:
>
> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.015604s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_self_deploy_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_self_deploy_journal.md)

> RECOVERED — the watchdog condition `journal-fetch-slow-_Users_dom_garden__garden_state_self_deploy_journal` has CLEARED (first seen 2026-11-13T22:18:28Z, cleared 2026-11-14T04:08:11Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-fetch-slow-_Users_dom_garden__garden_state_self_deploy_journal` cleared on oros-studio-garden-ce242c49.

- `watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_state_clone_keeper_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_state_clone_keeper_journal.md)

> RECOVERED — the watchdog condition `journal-fetch-slow-_Users_dom_garden__garden_state_state_clone_keeper_journal` has CLEARED (first seen 2026-11-14T12:24:42Z, cleared 2026-11-14T13:23:46Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-fetch-slow-_Users_dom_garden__garden_state_state_clone_keeper_journal` cleared on oros-studio-garden-ce242c49.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_gauntlet_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_gauntlet_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_home_kris_garden__garden_state_gauntlet_journal` has CLEARED (first seen 2026-11-14T08:45:15Z, cleared 2026-11-14T14:45:06Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_home_kris_garden__garden_state_gauntlet_journal` cleared on endolin-garden-ece02cb4.

- `watchdog-container-hardening-pending-recreate-oros-studio-garden-ce242c49` — from watchdog:self-heal, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-container-hardening-pending-recreate-oros-studio-garden-ce242c49.md)

> Container hardening is PENDING on oros-studio-garden-ce242c49: 2 launcher-posture check(s) fail (caps/sudo/block devices/mount).
>
> This is the expected state until the container is recreated with the hardened launcher,
> a maintainer step: context/operations/harden-container.md. The garden-container-hardening
> unit stays clean meanwhile (exit 3), so it does not fail rolling-deploy canaries. After the
> first all-pass run, any failure is treated as a regression and fails the unit.

- `watchdog-journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal` has CLEARED (first seen 2026-11-13T01:21:58Z, cleared 2026-11-16T16:42:22Z).
> It was observed 6 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal` cleared on oros-studio-garden-ce242c49.


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 188.9M | $706.34 _(notional, rate-card)_ | 70% of 271.0M (backoff) |
| Codex | 433.8M _(fleet aggregate)_ | n/a _(ChatGPT pro plan — no per-token $; plan-metered)_ | 93% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 153417982 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 5.461442s/45s (/home/kris/garden/.garden-state/worktree-sweeper/journal); 16 open notice(s); checker healthy

## Board
### todo (9)
- [`endojs-endo-but-for-bots-pr1673-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1673-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1673
- [`accountant-weekly-20261114-170509`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/accountant-weekly-20261114-170509.md) — Weekly arc apportionment
- [`endojs-endo-but-for-bots-pr1670-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1670-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1670
- [`scholar-ingest-fudco-gist-20261105`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/scholar-ingest-fudco-gist-20261105.md) — Ingest the FUDCo gist and report on it
- [`scholar-ingest-nanoseedlm-20261013`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/scholar-ingest-nanoseedlm-20261013.md) — Ingest "NanoSeedLM: LLM inference using pseudo-random numbers" and report on ...
- [`endojs-endo-but-for-bots-pr1674-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1674-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1674
- [`scholar-ingest-edera-product-20261105`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/scholar-ingest-edera-product-20261105.md) — Ingest the Edera product page and report on it
- [`ironhorse-test262-press-20261113-225326`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ironhorse-test262-press-20261113-225326.md) — ---
- [`endojs-endo-but-for-bots-pr1675-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1675-gauntlet-viability.md) — Gauntlet stage: PRE-SPEND VIABILITY - endojs/endo-but-for-bots PR #1675

### doin (0)
(none)

### tada (17227)
- [`endojs-endo-but-for-bots-pr1670-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/11/18/endojs-endo-but-for-bots-pr1670-gauntlet-panel-3.md) — Cost
- [`build-endopi-skills-lal-wiring`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/11/18/build-endopi-skills-lal-wiring.md) — build-endopi-skills-lal-wiring: delta 5 is on #1643
- [`build-endopi-skills-markdown-format`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/11/18/build-endopi-skills-markdown-format.md) — Cost
- [`endojs-endo-but-for-bots-pr1673-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/11/18/endojs-endo-but-for-bots-pr1673-gauntlet-fix-2.md) — Cost
- [`endojs-endo-but-for-bots-pr1674-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/11/18/endojs-endo-but-for-bots-pr1674-gauntlet-clean.md) — Cost
- … and 17222 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`review-docket-consolidate-20261008`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/review-docket-consolidate-20261008.md) — _normal_ · ---
- [`revive-hermit-lane-qwen3.8-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/revive-hermit-lane-qwen3.8-20261001.md) — _normal_ · Revive the local hermit (on-box Ollama) lane, upgraded to qwen3.8
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`minion-town-arc-press-20261107-140511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261107-140511.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`accountant-weekly-20261107-170510`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/accountant-weekly-20261107-170510.md) — _normal_ · Weekly arc apportionment
- [`design-minion-town-gutter-name-prefix-order-20261107`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-minion-town-gutter-name-prefix-order-20261107.md) — _normal_ · ---
- [`moddable-10-0-0-ironhorse-compiler-safety-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-compiler-safety-port.md) — _normal_ · Port Moddable 10.0.0 compiler safety corrections to IronHorse
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`make-panel-stage-survive-supervisor-session-exit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/make-panel-stage-survive-supervisor-session-exit.md) — _normal_ · Make panel execution survive supervising agent-session exit
- [`improve-candidate-gate-empty-diagnostic-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-candidate-gate-empty-diagnostic-r2.md) — _normal_ · ---
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`minion-town-arc-press-20261107-013512`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261107-013512.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`oros-health-watch-20261107-140511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261107-140511.md) — _normal_ · ---
- [`oros-health-watch-20261106-020511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261106-020511.md) — _normal_ · ---
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
- [`daily-progress-summary-20261107-013512`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daily-progress-summary-20261107-013512.md) — _normal_ · Daily midnight Pacific progress summary
- [`shepherd-endojs-endo-but-for-bots-pr1661`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/shepherd-endojs-endo-but-for-bots-pr1661.md) — _normal_ · ---
- [`deadmail-issue-comment-6659790262`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deadmail-issue-comment-6659790262.md) — _normal_ · Issue follow-up — fold a late comment into the issue work
- [`open-signup-gate-flip-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`endojs-endo-but-for-bots-pr1660-weave-20261116`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1660-weave-20261116.md) — _normal_ · Weave endojs/endo-but-for-bots PR #1660 after its base moved
- [`build-daemon-git-remotes-phase-six-interactive-provisioning-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-daemon-git-remotes-phase-six-interactive-provisioning-r2.md) — _normal_ · ---
- [`kriscendobot-minion.town-pr228-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr228-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — kriscendobot/minion.town PR #228
- [`design-daemon-git-remotes-extended-transports-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-daemon-git-remotes-extended-transports-r2.md) — _normal_ · ---
- [`ironhorse-ci-1-oracle-fix-20261116`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-ci-1-oracle-fix-20261116.md) — _normal_ · Ironhorse CI step 1: get the oracle-lane fix #1613 ready
- [`fix-endojs-endo-but-for-bots-pr1621-drop-regexp-hunk-20261106`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-endojs-endo-but-for-bots-pr1621-drop-regexp-hunk-20261106.md) — _normal_ · ---
- [`screen-minion-town-pr253-9c79d18-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/screen-minion-town-pr253-9c79d18-conduct.md) — _normal_ · Screened delegated merge: kriscendobot/minion.town#253 at 9c79d1807388884a67b...
- [`endojs-endo-but-for-bots-pr1595-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1595-gauntlet-panel-6.md) — _normal_ · Gauntlet stage: PANEL round 6 — endojs/endo-but-for-bots PR #1595
- [`moddable-10-0-0-ironhorse-callability-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-callability-port.md) — _normal_ · Port revoked-Proxy callability and constructability to IronHorse
- [`oros-health-watch-20261109-060512`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261109-060512.md) — _normal_ · ---
- [`weave-endojs-endo-but-for-bots-pr1538`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-endojs-endo-but-for-bots-pr1538.md) — _normal_ · ---
- [`minion-town-arc-press-20261107-043512`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261107-043512.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`fix-endojs-endo-but-for-bots-pr1594`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-endojs-endo-but-for-bots-pr1594.md) — _normal_ · ---
- [`ironhorse-ci2-1534-verify-20261117`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-ci2-1534-verify-20261117.md) — _normal_ · Ironhorse #1534: confirm final CI state after the llm refresh
- [`oros-health-watch-20261107-075009`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261107-075009.md) — _normal_ · ---
- [`ironhorse-ci-3-ironhorse-lanes-20261116`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-ci-3-ironhorse-lanes-20261116.md) — _normal_ · Ironhorse CI step 3: ironhorse-specific failures
- [`endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source.md) — _normal_ · Build: SES import attributes — Phase 2 (module-source static with capture)
- [`oros-health-watch-20261107-043512`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261107-043512.md) — _normal_ · ---
- [`improve-screening-cooldown-log-spam-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-screening-cooldown-log-spam-r2.md) — _normal_ · ---
- [`daemon-git-capability-phase-five-contract-tests-build-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-git-capability-phase-five-contract-tests-build-r2.md) — _normal_ · ---
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`design-minion-town-ocap-site-crawler-leak-rotation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-minion-town-ocap-site-crawler-leak-rotation.md) — _normal_ · Design: detect a crawler on an ocap.site page as a link-leak signal, and rotate
- [`kriscendobot-minion-town-pr183-open-findings-fix-20261015`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr183-open-findings-fix-20261015.md) — _normal_ · Fix the structural findings left open on kriscendobot/minion.town#183
- [`endojs-endo-but-for-bots-pr1498-gauntlet-undraft`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1498-gauntlet-undraft.md) — _normal_ · Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1498
- [`kriscendobot-minion-town-pr237-screen-304dd248-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr237-screen-304dd248-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — kriscendobot/minion.town PR #237
- [`reset-credit-watch-20261116-170511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/reset-credit-watch-20261116-170511.md) — _normal_ · ---
- [`endopi-extension-package-guest-provider-kinds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endopi-extension-package-guest-provider-kinds.md) — _normal_ · ---
- [`minion-town-remote-guest-cli-live-proof`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-remote-guest-cli-live-proof.md) — _normal_ · ---
- [`minion-town-arc-press-20261105-200509`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261105-200509.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`dependabotany-recheck-endo-but-for-bots-20261107-013512`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/dependabotany-recheck-endo-but-for-bots-20261107-013512.md) — _normal_ · ---
- [`kriscendobot-minion.town-pr199-weave-20261103`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr199-weave-20261103.md) — _normal_ · Weave kriscendobot/minion.town#199 onto current main
- [`improve-dependabot-paused-post`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-dependabot-paused-post.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1669-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1669-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1669
- [`kriscendobot-minion-town-pr252-screen-528d4a1f-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr252-screen-528d4a1f-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — kriscendobot/minion.town PR #252
- [`improve-screening-cas-failure-handling`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-screening-cas-failure-handling.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1653-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1653-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1653
- [`endojs-endo-but-for-bots-pr1666-dependabot`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1666-dependabot.md) — _normal_ · botanist (auto: dependabot PR) on endojs/endo-but-for-bots PR #1666
- [`deploy-minion-town-waitlist-soon-page-20261107`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-minion-town-waitlist-soon-page-20261107.md) — _normal_ · ---
- [`claude-on-minion-town-completion-press-20261107-retry`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-completion-press-20261107-retry.md) — _normal_ · Completion press: Claude-on-minion.town arc
- [`issue-status-pass-go-live-20261117`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/issue-status-pass-go-live-20261117.md) — _normal_ · Go live with the issue status pass (third observation window)
- [`build-daemon-git-remotes-transport-timing-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-daemon-git-remotes-transport-timing-r2.md) — _normal_ · ---
- [`shepherd-endojs-endo-but-for-bots-pr1594`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/shepherd-endojs-endo-but-for-bots-pr1594.md) — _normal_ · ---
- [`build-minion-town-retire-resident-role-20261105`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-retire-resident-role-20261105.md) — _normal_ · ---
- [`oros-health-watch-20261108-113509`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261108-113509.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1416-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1416-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1416
- [`daily-progress-summary-20261107-080513`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daily-progress-summary-20261107-080513.md) — _normal_ · Daily midnight Pacific progress summary
- [`weave-endojs-endo-but-for-bots-pr1560`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-endojs-endo-but-for-bots-pr1560.md) — _normal_ · ---
- [`oros-health-watch-20261108-235013`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261108-235013.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1430-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1430-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1430
- [`endojs-endo-but-for-bots-pr1504-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1504-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1504
- [`oros-health-watch-20261108-203533`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261108-203533.md) — _normal_ · ---
- [`fixer-endojs-endo-but-for-bots-pr1595`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fixer-endojs-endo-but-for-bots-pr1595.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1594-gauntlet-r2-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1594-gauntlet-r2-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1594
- [`ebfb-llm-xs-daemon-bundle-reconcile`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-xs-daemon-bundle-reconcile.md) — _normal_ · ---
- [`improve-suppress-routine-retry-progress`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-suppress-routine-retry-progress.md) — _normal_ · ---
- [`build-readableblob-range-attenuation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-readableblob-range-attenuation.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`design-daemon-git-remotes-ssh-transport-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-daemon-git-remotes-ssh-transport-r2.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1660-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1660-shepherd.md) — _normal_ · shepherd directive on endojs/endo-but-for-bots PR #1660
- [`endojs-endo-but-for-bots-pr1433-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1433-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1433
- [`endojs-endo-but-for-bots-pr1652-gauntlet-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1652-gauntlet-fix-5.md) — _normal_ · Gauntlet stage: FIX round 5 — endojs/endo-but-for-bots PR #1652
- [`ironhorse-iterator-scenario-parity-maintainer-decision`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-iterator-scenario-parity-maintainer-decision.md) — _high_ · resolve the remaining acceptance scope for IronHorse iterator scenario parity
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`minion-town-arc-press-20261107-075009`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261107-075009.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`improve-decision-ledger-contention-spool-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-decision-ledger-contention-spool-r2.md) — _normal_ · ---
- [`ironhorse-ci2-1359-20261117`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-ci2-1359-20261117.md) — _normal_ · Ironhorse CI: #1359 cover, zizmor, test-xs
- [`cutover-budget-road`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/cutover-budget-road.md) — _normal_ · Cut over to the budget road
- [`claude-on-minion-town-completion-press-20261107-013512`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-completion-press-20261107-013512.md) — _normal_ · Completion press: Claude-on-minion.town arc
- [`design-daemon-git-remotes-server-half-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-daemon-git-remotes-server-half-r2.md) — _normal_ · ---
- [`minion-town-arc-press-20261105-230510`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261105-230510.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`minion-town-arc-press-20261107-105011`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261107-105011.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`endojs-endo-but-for-bots-pr546-gauntlet-20261007-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr546-gauntlet-20261007-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #546
- [`minion-town-arc-press-20261106-020511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261106-020511.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`kriscendobot-minion.town-pr248-gauntlet-panel-7`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr248-gauntlet-panel-7.md) — _normal_ · Gauntlet stage: PANEL round 7 — kriscendobot/minion.town PR #248
- [`weave-endojs-endo-but-for-bots-pr1481-onto-pr1478-20261102`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-endojs-endo-but-for-bots-pr1481-onto-pr1478-20261102.md) — _normal_ · ---
- [`improve-issue-status-source-budget-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-issue-status-source-budget-r2.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1560-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1560-shepherd.md) — _normal_ · shepherd (auto: approved but CI needs work) on endojs/endo-but-for-bots PR #1560
- [`endojs-endo-but-for-bots-pr1486-gauntlet-undraft`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1486-gauntlet-undraft.md) — _normal_ · Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1486
- [`shepherd-endojs-endo-but-for-bots-pr1596-20261117`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/shepherd-endojs-endo-but-for-bots-pr1596-20261117.md) — _normal_ · ---
- [`oros-health-watch-20261107-105011`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261107-105011.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr909-fix-ts-make-daemon`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-fix-ts-make-daemon.md) — _normal_ · Fix: endo make / endo archive TypeScript support is broken (endojs/endo-but-f...
- [`improve-gardener-handler-rc76-collision-expanded-window`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-gardener-handler-rc76-collision-expanded-window.md) — _normal_ · Land the gardener fix for spooled review-docket notices failing finished jobs
- [`ironhorse-1298-repin-fuzz-locks-20261117`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-1298-repin-fuzz-locks-20261117.md) — _normal_ · Ironhorse #1298: re-pin byte-pinned fuzz locks after the llm merge (F040 re-f...
- [`dependabotany-recheck-endo-but-for-bots-20261117-030511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/dependabotany-recheck-endo-but-for-bots-20261117-030511.md) — _normal_ · ---
- [`ironhorse-ci2-1621-drift-20261117`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-ci2-1621-drift-20261117.md) — _normal_ · Ironhorse CI: #1621 Node 26 and zizmor drift
- [`minion-town-arc-press-20261105-165012`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261105-165012.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`ironhorse-xs10-proxy-callable-flags`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-xs10-proxy-callable-flags.md) — _normal_ · IronHorse: Proxy [[Call]]/[[Construct]] flags survive revocation (XS 10.0.0 #...
- [`improve-transient-retry-correlation-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-transient-retry-correlation-r2.md) — _normal_ · ---
- [`build-daemon-agent-tools-phase-8-fetch-plugin-20261106`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-daemon-agent-tools-phase-8-fetch-plugin-20261106.md) — _normal_ · ---
- [`improve-gauntlet-notices-to-pr-20261106`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-gauntlet-notices-to-pr-20261106.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1529-gauntlet-undraft`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1529-gauntlet-undraft.md) — _normal_ · Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1529
- [`endojs-endo-but-for-bots-pr1348-review-4984e562`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1348-review-4984e562.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #1348
- [`moddable-10-0-0-ironhorse-oracle-validation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-oracle-validation.md) — _normal_ · Move the IronHorse oracle to Moddable 10.0.0 and validate the port campaign
- [`oros-health-watch-20261110-102016`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261110-102016.md) — _normal_ · ---
- [`oros-health-watch-20261105-135010`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261105-135010.md) — _normal_ · ---
- [`build-usage-scrape-ingest`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-usage-scrape-ingest.md) — _normal_ · ---
- [`ironhorse-xs-oracle-bump-10-0-0`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-xs-oracle-bump-10-0-0.md) — _normal_ · IronHorse: bump the XS oracle to Moddable 10.0.0 and mirror the compiler deltas
- [`claude-on-minion-town-completion-press-20261107-075009`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-completion-press-20261107-075009.md) — _normal_ · Completion press: Claude-on-minion.town arc
- [`improve-muster-autoarchive-watchdog-20261106`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-muster-autoarchive-watchdog-20261106.md) — _normal_ · ---
- [`improve-byte-pressure-clone-recovery`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-byte-pressure-clone-recovery.md) — _normal_ · ---
- [`claude-on-minion-town-completion-press-20261107-140511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-completion-press-20261107-140511.md) — _normal_ · Completion press: Claude-on-minion.town arc
- [`oros-health-watch-20261105-230510`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261105-230510.md) — _normal_ · ---
- [`endo-but-for-bots-pi-family-1x-upgrade`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-but-for-bots-pi-family-1x-upgrade.md) — _normal_ · endo-but-for-bots: upgrade the pi family (@earendil-works/*) to 1.x together
- [`design-endo-naturally-sort-ordered-directory-20261106`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-endo-naturally-sort-ordered-directory-20261106.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1560-conduct-20261117`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1560-conduct-20261117.md) — _normal_ · Finalize endojs/endo-but-for-bots PR #1560
- [`ironhorse-ci-2-test-legs-20261116`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-ci-2-test-legs-20261116.md) — _normal_ · Ironhorse CI step 2: macOS and ubuntu test-leg failures
- [`endojs-endo-but-for-bots-pr1560-review-a5e99160`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1560-review-a5e99160.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #1560
- [`drive-mystic-rollout-20260723`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/drive-mystic-rollout-20260723.md) — _low_ · ---
- [`kimi-k3-canary-20260723-c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kimi-k3-canary-20260723-c.md) — _low_ · ---
- [`claude-on-minion-town-completion-press-20261105-133510`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-completion-press-20261105-133510.md) — _normal_ · Completion press: Claude-on-minion.town arc
- [`fix-endojs-endo-but-for-bots-pr1560`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-endojs-endo-but-for-bots-pr1560.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1591-gauntlet-20261117-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1591-gauntlet-20261117-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1591
- [`claude-on-minion-town-completion-press-20261106-020511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-completion-press-20261106-020511.md) — _normal_ · Completion press: Claude-on-minion.town arc
- [`fix-endojs-endo-but-for-bots-pr1591`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-endojs-endo-but-for-bots-pr1591.md) — _normal_ · ---
- [`shepherd-endojs-endo-but-for-bots-pr1592`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/shepherd-endojs-endo-but-for-bots-pr1592.md) — _normal_ · ---
- [`improve-transient-retry-budget-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-transient-retry-budget-r2.md) — _normal_ · ---
- [`moddable-10-0-0-ironhorse-typedarray-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-typedarray-port.md) — _normal_ · Port Moddable 10.0.0 TypedArray corrections to IronHorse
- [`moddable-10-0-0-ironhorse-immutable-arraybuffer-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-immutable-arraybuffer-port.md) — _normal_ · Implement immutable ArrayBuffer and close the Moddable 10.0.0 validation camp...
- [`endojs-endo-but-for-bots-pr1538-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1538-gauntlet-panel-6.md) — _normal_ · Gauntlet stage: PANEL round 6 — endojs/endo-but-for-bots PR #1538
- [`kriscendobot-minion.town-pr248-review-edbd57fa`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr248-review-edbd57fa.md) — _normal_ · Review directive on kriscendobot/minion.town PR #248
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`endojs-endo-but-for-bots-pr1645-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1645-conduct.md) — _normal_ · Finalize (curate -> merge) endojs/endo-but-for-bots PR #1645
- [`screen-minion-town-pr246-93329d9-conduct-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/screen-minion-town-pr246-93329d9-conduct-r2.md) — _normal_ · Screened delegated merge: kriscendobot/minion.town#246 at 93329d9faf0564a5791...
- [`improve-minion-town-arc-press-breaker`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-minion-town-arc-press-breaker.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1591-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1591-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1591
- [`kriscendobot-minion-town-pr148-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr148-gauntlet-viability.md) — _normal_ · Gauntlet stage: PRE-SPEND VIABILITY - kriscendobot/minion.town PR #148
- [`build-oros-secrets-bwrap-handoff-20261106`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-oros-secrets-bwrap-handoff-20261106.md) — _normal_ · ---
- [`mirror-endo-3372`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/mirror-endo-3372.md) — _normal_ · Mirror endojs/endo#3372 onto endojs/endo-but-for-bots
- [`endojs-endo-but-for-bots-pr1658-dependabot`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1658-dependabot.md) — _normal_ · botanist (auto: dependabot PR) on endojs/endo-but-for-bots PR #1658
- [`evaluate-reauth-escalation-default-after-oauth-relay-20260927`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/evaluate-reauth-escalation-default-after-oauth-relay-20260927.md) — _low_ · Evaluate default reauth escalation once the browser OAuth relay lands
- [`ironhorse-immutable-arraybuffer`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-immutable-arraybuffer.md) — _normal_ · IronHorse: implement Immutable ArrayBuffer and enable it in the oracle
- [`build-confined-application-makers-p2-20261002`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-confined-application-makers-p2-20261002.md) — _normal_ · Phase 2: daemon capture for node-modules-with-map and node-modules-scan layou...
- [`improve-claude-completion-finalizer`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-claude-completion-finalizer.md) — _normal_ · ---
- [`improve-gh-api-admission-fail-closed`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-gh-api-admission-fail-closed.md) — _normal_ · ---
- [`improve-issue-status-source-trust-filter-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-issue-status-source-trust-filter-r2.md) — _normal_ · ---
- [`claude-on-minion-town-completion-press-20261105-195009`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-completion-press-20261105-195009.md) — _normal_ · Completion press: Claude-on-minion.town arc
- [`endojs-endo-but-for-bots-pr1656-dependabot`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1656-dependabot.md) — _normal_ · botanist (auto: dependabot PR) on endojs/endo-but-for-bots PR #1656
- [`minion-town-arc-press-20261105-135010`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261105-135010.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`endojs-endo-but-for-bots-pr1560-review-d3f67ace`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1560-review-d3f67ace.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #1560
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`endojs-endo-but-for-bots-pr1636-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1636-shepherd.md) — _normal_ · shepherd (auto: approved but CI needs work) on endojs/endo-but-for-bots PR #1636
- [`oros-health-watch-20261108-143510`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261108-143510.md) — _normal_ · ---
- [`shepherd-endojs-endo-but-for-bots-pr1594-20261117`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/shepherd-endojs-endo-but-for-bots-pr1594-20261117.md) — _normal_ · ---
- [`minion-town-mcp-guide-remaining-slices-20261104`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-mcp-guide-remaining-slices-20261104.md) — _normal_ · Finish the MCP guide's remaining slices (kriscendobot/minion.town#235)
- [`fix-endojs-endo-but-for-bots-pr1560-20261117`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-endojs-endo-but-for-bots-pr1560-20261117.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1340-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1340-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1340
- [`endojs-endo-but-for-bots-pr1641-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1641-conduct.md) — _normal_ · Finalize (curate -> merge) endojs/endo-but-for-bots PR #1641
- [`endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper.md) — _normal_ · Build: SES import attributes — Phase 3 (compartment-mapper plumbing)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`oros-health-checkup-20261013-133505`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-checkup-20261013-133505.md) — _normal_ · Deliberate overrun decomposition for oros-health-checkup-20261013-133505
- [`oros-health-watch-20261105-165012`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261105-165012.md) — _normal_ · ---
- [`improve-production-acceptance-deferred-probe`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-production-acceptance-deferred-probe.md) — _normal_ · ---
- [`moddable-10-0-0-ironhorse-builtins-order-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-builtins-order-port.md) — _normal_ · Port three Moddable 10.0.0 built-in ordering corrections to IronHorse
- [`fix-endojs-endo-but-for-bots-pr1591-anchor-sweep-regression-evidence`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-endojs-endo-but-for-bots-pr1591-anchor-sweep-regression-evidence.md) — _normal_ · ---
- [`claude-on-minion-town-press-20261010-133536`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-press-20261010-133536.md) — _normal_ · Press the Claude-on-minion.town arc forward
- [`fix-endojs-endo-but-for-bots-pr1655-pi-family-lockstep`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-endojs-endo-but-for-bots-pr1655-pi-family-lockstep.md) — _normal_ · fixer: lockstep @earendil-works/pi-* family bump for endojs/endo-but-for-bots...
- [`oros-health-watch-20261105-200509`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261105-200509.md) — _normal_ · ---
- [`build-claude-usage-dashboard-scraper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-claude-usage-dashboard-scraper.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1379-gauntlet-20261007-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1379-gauntlet-20261007-fix-5.md) — _normal_ · Gauntlet stage: FIX round 5 — endojs/endo-but-for-bots PR #1379
- [`heal-minion-town-cfafabe`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/heal-minion-town-cfafabe.md) — _normal_ · Heal minion.town production after merge cfafabea5a93f0d270980d4b468841c0565b3a3a

### awaiting maintainer decision (answer at the linked question)
- [`minion-town-claude-cli-production-canary-after-connection-20261004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-claude-cli-production-canary-after-connection-20261004.md) - [Connect the real Claude subscription through the stable account page and reply connected; no setup token may be sent through the journal.](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-claude-cli-production-canary-20261004-224cae8c9188.md)
- [`endo-cli-no-autostart-exit-codes-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-cli-no-autostart-exit-codes-build.md) - [Design OQ1/OQ3: should the CLI default to no-autostart under a service manager, and are the proposed exit codes acceptable?](https://github.com/endojs/endo-but-for-bots/pull/1383)
- [`build-ironhorse-in-crank-safepoint-collection`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-ironhorse-in-crank-safepoint-collection.md) - [Agree to amend ironhorse-quiescent-gc to admit a native-depth-zero dispatch safepoint collection inside a crank (design #1622, open question 1), or wait for ropes?](https://github.com/endojs/endo-but-for-bots/pull/1622)
- [`api-key-agents-canary-and-retirement`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/api-key-agents-canary-and-retirement.md) - [After phases 1-5 land behind apiKeyGuestAgents: may the bot run the production canary (phase 6) with the minion/claude-api-canary-key, and what are the answers to the parent design's open questions (Agent SDK retention as @endo/claude vs renamed plugin; legacy migration window; bulk delegated-subtree provider attachment; garden inference sourcing; deprecation interval before deleting @endo/agent-mcp-stdio and CLI exports)? These gate migration (phase 7) and retirement steps 5-9.](https://github.com/endojs/endo-but-for-bots/pull/1543#pullrequestreview-5761476590)
- [`resolve-endo-pr1349-depcheck-ci-20261028`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resolve-endo-pr1349-depcheck-ci-20261028.md) - [Should endojs/endo-but-for-bots#1349 accept the known dependency-check failure for ferry purposes, or should endojs/endo-but-for-bots#1582 land into the frozen base first?](https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6479686667)
- [`endojs-endo-but-for-bots-pr1477-location-reshape`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1477-location-reshape.md) - [Now that OCapN designator = peer key (not swissnum/network), should the in-memory OcapnLocation still be reshaped to {network, peer, at:[{transport,address}]} (value/swiss-num on sturdyref only), and in #1477 or a follow-up?](https://github.com/endojs/endo-but-for-bots/pull/1477#discussion_r4344979384)
- [`minion-town-public-browser-caddy-gate-smoke-after-mfa-20261006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-public-browser-caddy-gate-smoke-after-mfa-20261006.md) - [When can you promptly relay the one-time GitHub SMS code for kriscendobot so the final public-browser gate smoke can run?](https://github.com/kriscendobot/garden/issues/89#issuecomment-6019568536)
- [`build-claude-api-agent-workbench-20261027`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-claude-api-agent-workbench-20261027.md) - [The workbench design moved to minion.town (#238), but phases W1-W5 change Endo packages. Should each be proposed in Endo as a design that does not name minion.town before it is built, or is the minion.town design enough for the Endo pull requests that build them? (Open question 7; the design's other open questions and #1543 also still gate this build.)](https://github.com/kriscendobot/minion.town/pull/238)
- [`endo-daemon-orphan-safe-stop-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-daemon-orphan-safe-stop-build.md) - [Design OQ2: should run-daemon run the manager in-process, or keep the child process and forward signals?](https://github.com/endojs/endo-but-for-bots/pull/1383)
- [`endo-but-for-bots-ocapn-noise-session-id-r2-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-but-for-bots-ocapn-noise-session-id-r2-build.md) - [Q2 of designs/ocapn-noise-cryptographic-review.md: for R2, bind np sessionId to the Noise handshake hash, or persist handoff replay state per stable sessionId?](https://github.com/endojs/endo-but-for-bots/pull/1475)
- [`ironhorse-computron-benchmark-baseline-build-after-approval`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-computron-benchmark-baseline-build-after-approval.md) - [Will the maintainer lift the Ironhorse pause, approve design PR #1283 (or direct an early build), and answer its six open questions (or direct the recommended defaults)?](https://github.com/endojs/endo-but-for-bots/pull/1283)
- [`minion-town-claude-kriscendobot-canary-after-connect-20261006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-claude-kriscendobot-canary-after-connect-20261006.md) - [Connect kriscendobot Claude subscription at minion.town/account/claude (GitHub login+MFA, claude setup-token) and reply "connected"](https://github.com/kriscendobot/garden/issues/89#issuecomment-6009162863)
- [`build-endor-tui-phase-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endor-tui-phase-2.md) - [endor-tui Phase 2: minimal Rust CapTP client over the existing socket (recommended) or a manager-side adapter serving the bus-verb table?](https://github.com/endojs/endo-but-for-bots/pull/1526)

### deferred (top by priority; foreman auto-promotes when idle)
(none)

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`ebfb-platform-fs-pet-name-path-only`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-platform-fs-pet-name-path-only.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1390` · ---
- [`endojs-endo-but-for-bots-pr1664-dependabot-after-pr1659`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1664-dependabot-after-pr1659.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1659` · botanist recheck: endojs/endo-but-for-bots PR #1664 after #1659
- [`endo-minion-town-federation-release-gate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-minion-town-federation-release-gate.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1124` · Gate: reviewed and deployable federation release
- [`endojs-endo-but-for-bots-pr1347-weave-after-pr1585`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1347-weave-after-pr1585.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1585` · ---
- [`endojs-endo-but-for-bots-pr1602-weave-after-pr1585`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1602-weave-after-pr1585.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1585` · ---
- [`shepherd-endojs-endo-but-for-bots-pr1594-after-base-fixes-20261115`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/shepherd-endojs-endo-but-for-bots-pr1594-after-base-fixes-20261115.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1646` · Finish shepherding endojs/endo-but-for-bots PR #1594 after its base-wide fixe...
- [`conduct-endojs-endo-but-for-bots-pr1575-endolin`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/conduct-endojs-endo-but-for-bots-pr1575-endolin.md) — awaiting `weave-endojs-endo-but-for-bots-pr1575-onto-llm-after-pr1573` · Conduct endojs/endo-but-for-bots PR #1575
- [`claude-api-p3-minion-ui`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-api-p3-minion-ui.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1575` · Phase 3: minion.town provider endpoint, UI step, and Providers page
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`verify-minion-town-recovery-outcome-production-20261107g`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-minion-town-recovery-outcome-production-20261107g.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/254` · ---
- [`regauntlet-ebfb-pr1425-after-zizmor-fix-20261006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/regauntlet-ebfb-pr1425-after-zizmor-fix-20261006.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1427` · ---
- [`weave-endojs-endo-but-for-bots-pr667-after-pr1646`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-endojs-endo-but-for-bots-pr667-after-pr1646.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1646` · Weave endojs/endo-but-for-bots PR #667 after the Node pin lands
- [`weave-endojs-endo-but-for-bots-pr1504-after-pr1646`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-endojs-endo-but-for-bots-pr1504-after-pr1646.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1646` · Weave endojs/endo-but-for-bots PR #1504 after the Node pin lands
- [`minion-town-ocapn-canary-live-run-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-ocapn-canary-live-run-2.md) — awaiting `endo-minion-town-federation-live-acceptance` · Live run of the minion.town OCapN guest canary (resumes minion-town-ocapn-can...
- [`endojs-endo-but-for-bots-pr1665-dependabot-after-pr1659`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1665-dependabot-after-pr1659.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1659` · botanist recheck: endojs/endo-but-for-bots PR #1665 after #1659
- [`build-confined-fetch-timer-endowment`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-confined-fetch-timer-endowment.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1588` · ---
- [`reweave-endojs-endo-but-for-bots-daemon-mount-stack-after-pr1659-20261114`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/reweave-endojs-endo-but-for-bots-daemon-mount-stack-after-pr1659-20261114.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1659` · Reweave the daemon mount-import stack after the shared zizmor fix lands
- [`endo-mvs-semver-convergence`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-mvs-semver-convergence.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1596` · Converge the Rust npm resolver and the daemon semver copy on exo-npm's MVS rule
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1019` · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`build-minion-town-tool-removal-landing-20261104`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-tool-removal-landing-20261104.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/239` · Land the MCP tool removal after #239 deploys (kriscendobot/minion.town)
- [`kriscendobot-minion-town-node-observed-interpreter`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-node-observed-interpreter.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/171` · minion.town: observe the root-owned Node interpreter in the harness layout probe
- [`minion-town-guide-accept-link-after-240-20261104`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-guide-accept-link-after-240-20261104.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/240` · Point agents at the /accept invitation link once #240 lands (kriscendobot/min...
- [`build-endopi-extension-package-manifest`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endopi-extension-package-manifest.md) — awaiting `endojs-endo-but-for-bots-pr1674-gauntlet` · Build: the design in endojs/endo-but-for-bots#1674
- [`ebfb-parcel-layer2-build-20261024`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-parcel-layer2-build-20261024.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/774` · Build: Parcel layer 2 (SES %InitialParcel% / %SharedParcel%), endojs/endo-but...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`endojs-endo-but-for-bots-pr1636-post1659-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1636-post1659-shepherd.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1659` · Resume shepherding endojs/endo-but-for-bots PR #1636 after PR #1659 resolves
- [`verify-minion-town-remove-open-in-new-tab-prod-20261104`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-minion-town-remove-open-in-new-tab-prod-20261104.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/246` · ---
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`shepherd-endojs-endo-but-for-bots-pr1594-ci-followup-20261115`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/shepherd-endojs-endo-but-for-bots-pr1594-ci-followup-20261115.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1646` · Drive endojs/endo-but-for-bots PR endojs/endo-but-for-bots#1594 CI green afte...
- [`weave-api-key-p2-acceptance-after-pr1575`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-api-key-p2-acceptance-after-pr1575.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1575` · Weave the phase 2 gap PR onto llm after #1575 merges
- [`endo-fs-subview-mount-rename`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-fs-subview-mount-rename.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1586` · ---
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`migrate-coupons-onto-exo-dynamodb`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-coupons-onto-exo-dynamodb.md) — awaiting `build-recursive-dynamodb-capabilities` · ---
- [`endojs-endo-but-for-bots-pr1658-dependabot-conduct-after-pr1646`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1658-dependabot-conduct-after-pr1646.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1646` · Conduct endojs/endo-but-for-bots PR #1658 (preact 10.29.8 -> 11.1.1) after th...
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`weave-endojs-endo-but-for-bots-pr1596-after-pr1659`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-endojs-endo-but-for-bots-pr1596-after-pr1659.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1659` · Weave endojs/endo-but-for-bots PR #1596 after the zizmor pin-comment fix lands
- [`build-exo-sheets-service`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-sheets-service.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`conduct-endojs-endo-but-for-bots-pr1573-after-pr1646`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/conduct-endojs-endo-but-for-bots-pr1573-after-pr1646.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1646` · Conduct endojs/endo-but-for-bots PR #1573 after the Node pin lands
- [`endojs-endo-but-for-bots-pr1501-weave-after-pr1585`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1501-weave-after-pr1585.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1585` · ---
- [`build-minion-town-guest-coupons-phase1-rest`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-guest-coupons-phase1-rest.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/199` · Build the rest of guest-coupons phase 1 on kriscendobot/minion.town
- [`endojs-endo-but-for-bots-pr1501-weave-after-pr1613`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1501-weave-after-pr1613.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1613` · ---
- [`endojs-endo-but-for-bots-pr1663-dependabot-after-pr1659`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1663-dependabot-after-pr1659.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1659` · botanist recheck: endojs/endo-but-for-bots PR #1663 after #1659
- [`ironhorse-fuzz-triage-differential_source-efffacee3e2a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-triage-differential_source-efffacee3e2a.md) — awaiting `https://github.com/kriscendobot/garden/issues/91` · Triage 7 Ironhorse fuzz finding(s) for target differential_source
- [`minion-town-ui-gutter-mint`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-ui-gutter-mint.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/142` · Gutter: the + button mints a real clip (minion-town-ui increment)
- [`weave-endojs-endo-but-for-bots-pr1575-onto-llm-after-pr1573`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-endojs-endo-but-for-bots-pr1575-onto-llm-after-pr1573.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1573` · Weave endojs/endo-but-for-bots PR #1575 onto llm after its parent #1573 merges

## Watch set
kriscendobot-minion.town kriscendobot-garden-book kriscendobot-cosgov kriscendobot-ocapn kriscendobot-oros-ckm-data-readiness kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 1 monks
- [.archived-endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-endolin-garden2-5bcdff64): 1 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 4 monks
