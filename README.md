# Garden bulletin

_As of 2026-11-14T06:18:45Z_

## Latest

Nothing resolved at the file level this cycle, so this is a snapshot of what needs a maintainer rather than a list of moves. Several chokepoints are stalling the fleet.

- **Oros is still held.** [oros-studio-garden-ce242c49] has stayed drained after repeated canary failures (the roll to 18fc7b17375 failed). Both blockers need someone at the machine: an expired Claude OAuth session, and `garden-secret-broker` failing after deploy. The failed canary has stopped the leader from deploying. The leader still runs f2788117645, so the EROFS fix cannot reach it. That parks the minion.town project-checkout jobs, though the project is also paused.
- **minion.town is paused.** The pause from 2026-11-10 keeps tripping chokepoints. The watchdog notice for it is at roughly 21k occurrences. `garden-foreman` (rc=78) and `garden-mentor` (rc=1) both treat the pause refusal as a crash, which fires self-heal. A self-heal fix job is already named for the foreman.
- **Possible DNS problem for minion.town.** A 2026-11-10 message reports the apex and `ocap.site` now resolve to `34.225.237.208` instead of the documented `13.56.17.18`. It asks whether the repoint was intentional. If it wasn't, it could be a zone compromise. That message is still unanswered.
- **Disk space on the leader.** `/home/kris/garden` was at roughly 176–500 MiB free and briefly hit 0. It needs manual reclaiming under `.garden-state`, `scratch/` and `worktrees/`.
- **Decision still needed on M3.** The foreman milestone is blocked at [endojs/endo-but-for-bots#1589](https://github.com/endojs/endo-but-for-bots/issues/1589). The question is whether its Fae/Lal workspace catalogs may proceed or must use code mode.
- **Other open decisions.** Two minion.town reports are waiting on you. One asks about the leftover anonymous guest on production and running `deploy-accounts-store.sh` before merging. The other covers a possible Iron Horse test-infra job drawn from yavashark.
- **Housekeeping.** Journal-contention notices are mostly recovering. Several daily-summary and build jobs were reaper-parked after their retries ran out. They stay held until promoted.

In flight: shepherd and weave jobs on [endo-but-for-bots#1588](https://github.com/endojs/endo-but-for-bots/pull/1588) and shepherd on [endo-but-for-bots#1590](https://github.com/endojs/endo-but-for-bots/pull/1590). Four oros canary probes sit unclaimed in `todo`.

## Maintainer review docket

191 open · [ordered priorities and review docket](https://github.com/kriscendobot/garden/blob/journal2/PRIORITIES.md)
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

> WATCHDOG notice — occurrence #9 (first seen 2026-11-07T02:46:16Z, latest 2026-11-13T22:44:35Z).
> The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_unblock_journal`) has now been observed 9 times; this is ONE
> coalesced notice that updates in place, not 9 messages. Latest detail:
>
> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.019039s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `watchdog-journal-contention-storm-lock-contention` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-storm-lock-contention.md)

> RECOVERED — the watchdog condition `journal-contention-storm-lock-contention` has CLEARED (first seen 2026-11-13T05:48:51Z, cleared 2026-11-14T06:04:49Z).
> It was observed 12 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-contention-storm-lock-contention` cleared on endolin-garden-ece02cb4.

- `liaison-followup-ebf85c34f5bc` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/liaison-followup-ebf85c34f5bc.md)

> Report minion-town-docs-tower-report-20261016: two items need your call.
> 1. The live probe left one anonymous guest on production minion.town. The API has no delete route and the guest's identifier was never recorded, so the garden can't clean it up. Decide whether to leave it or remove it by hand.
> 2. The source note `/home/kris/garden/note-from-tower.md` was not on the host that ran the job, so the report was not checked against it. If you want that check, re-run the job on the host that holds the note.

- `watchdog-project-pause-active-minion-town` — from watchdog:claim/1, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-project-pause-active-minion-town.md)

> WATCHDOG notice — occurrence #21331 (first seen 2026-11-10T19:35:37Z, latest 2026-11-14T05:36:23Z).
> The SAME condition (`project-pause-active-minion-town`) has now been observed 21331 times; this is ONE
> coalesced notice that updates in place, not 21331 messages. Latest detail:
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

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal` has CLEARED (first seen 2026-11-13T04:44:14Z, cleared 2026-11-14T02:39:43Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_home_kris_garden__garden_state_review_docket_journal` cleared on endolin-garden-ece02cb4.

- `watchdog-journal-contention-storm-fetch-slow` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-storm-fetch-slow.md)

> RECOVERED — the watchdog condition `journal-contention-storm-fetch-slow` has CLEARED (first seen 2026-11-13T22:23:28Z, cleared 2026-11-14T00:17:57Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-contention-storm-fetch-slow` cleared on oros-studio-garden-ce242c49.

- `watchdog-journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-11-13T12:42:09Z, latest 2026-11-14T05:38:15Z).
> The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/sysop/journal: p95=0.052683s, giveups=1, steals=0 (max 3/window), wait floor=60s.

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

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_regenerate_sections_index_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_regenerate_sections_index_journal.md)

> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/regenerate-sections-index/journal: p95=0.030763s, giveups=1, steals=0 (max 3/window), wait floor=60s.

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

- `msg-oros-health-watch-20261111-205010-04ba7ec6ee39` — from gardener:oros-health-watch-20261111-205010, reply_to `oros-health-watch-20261111-205010` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-oros-health-watch-20261111-205010-04ba7ec6ee39.md)

> Oros (oros-studio-garden-ce242c49) is still operator-held. The roll moved it to 18fc7b17375 and failed the canary again; retries ran out at 19:29Z and it stays drained. There are two blockers, and both need someone at the machine:
> (1) The Claude OAuth session has expired. Fix: run claude, then /login, as the garden user.
> (2) garden-secret-broker.service fails after deploy. It failed the same way on 11-07 through 11-10. Check it with: journalctl --user -u garden-secret-broker -n 80
> I lifted nothing and reset nothing; the drain is roll-owned. Full record: projects/garden/host-health/oros-studio-garden-ce242c49.md

- `watchdog-comment-watcher-stuck-cooldown-host` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-watcher-stuck-cooldown-host.md)

> RECOVERED — the watchdog condition `comment-watcher-stuck-cooldown-host` has CLEARED (first seen 2026-11-13T06:01:28Z, cleared 2026-11-13T06:44:51Z).
> It was observed 8 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Comment acknowledgment condition cleared.

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

> WATCHDOG notice — occurrence #2 (first seen 2026-11-14T04:26:12Z, latest 2026-11-14T05:51:54Z).
> The SAME condition (`self-heal-garden-foreman`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> self-heal: garden-foreman exited rc=78 with no scoped fix. Capture: bf7f100d25f8f297bacaba2d13b3e39379f9c141 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p bf7f100d25f8f297bacaba2d13b3e39379f9c141). Diagnosis: Exit 78 is `GARDEN_PAUSED_RC`, a refusal and not a crash. The foreman proposed the next milestone step `weave-endojs-endo-but-for-bots-pr1565`. `post-job.sh` refused it because the body matched the pause record's regex `minion\.town`, from the minion-town pause of 2026-11-10 (`journal/pauses/minion-town.md`). The foreman only special-cases the completed-collision and transient return codes (`scripts/jobs/foreman.sh:712-740`). Any other nonzero code, including this deliberate pause refusal, goes through `exit "$post_rc"`, which fails the unit. This is the same pause that blocked the deferred promotion of `…minion.town-pr199-review…-retro` earlier in the tick. systemd restarts the foreman, it proposes the same step, and it fails again.
>
> JOB self-heal-fix-garden-foreman-paused-rc78-soft-s

- `watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-canary-failed-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-11-12T22:56:07Z, cleared 2026-11-14T03:53:07Z).
> It was observed 3 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> retrying canary oros-studio-garden-ce242c49 (attempt 1/3); clearing prior page.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_reducer_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_reducer_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_home_kris_garden__garden_state_reducer_journal` has CLEARED (first seen 2026-11-06T02:46:39Z, cleared 2026-11-13T16:44:17Z).
> It was observed 10 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_home_kris_garden__garden_state_reducer_journal` cleared on endolin-garden-ece02cb4.

- `msg-minion-town-arc-press-20261108-082012-76df4c8f6ed9` — from gardener:minion-town-arc-press-20261108-082012, reply_to `minion-town-arc-press-20261108-082012` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-arc-press-20261108-082012-76df4c8f6ed9.md)

> minion.town arc supervisor (issue [kriscendobot/garden#58](https://github.com/kriscendobot/garden/issues/58)) is blocked on one garden-ops decision.
>
> The leader endolin-garden-ece02cb4 still runs f2788117645. The EROFS fix (3c7f9ce045e, now main2 21585bda2b3) cannot reach it because the rolling deploy rolls the follower oros-studio-garden-ce242c49 first as a canary, and oros has stopped claiming any job: canary probes for f278/3c7f/21585 all failed (last 04:11Z today), and 14 oros-health-checkup jobs sit unclaimed in todo. Until the leader deploys, every monk job that needs a project checkout dies EROFS, so all minion.town PR work is parked ([kriscendobot/minion.town#246](https://github.com/kriscendobot/minion.town/issues/246) weave+conduct; panels for [kriscendobot/minion.town#237](https://github.com/kriscendobot/minion.town/issues/237), [kriscendobot/minion.town#252](https://github.com/kriscendobot/minion.town/issues/252), [kriscendobot/minion.town#248](https://github.com/kriscendobot/minion.town/issues/248); the [kriscendobot/minion.town#248](https://github.com/kriscendobot/minion.town/issues/248) follow-up; the waitlist browser check; and [kriscendobot/minion.town#254](https://github.com/kriscendobot/minion.town/issues/254), which needs more gauntlet rounds).
>
> Question: do you want to (a) revive oros, or (b) authorize deploying the leader to main2 past the dead canary (deploy-garden.sh on the leader, or the deploy-on-upgrade override)? I will re-arm the parked minion.town jobs as soon as the leader runs 3c7f9ce or later.

- `watchdog-journal-lock-contention-_Users_dom_garden__garden_state_regenerate_sections_index_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_Users_dom_garden__garden_state_regenerate_sections_index_journal.md)

> Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-sections-index/journal: p95=0.023981s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `foreman-milestone-M3` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/foreman-milestone-M3.md)

> COALESCED message — occurrence #7 (first seen 2026-11-14T04:34:56Z, latest 2026-11-14T05:47:03Z).
> The SAME message (episode key `foreman-milestone-M3`) has now been sent 7 times; this is
> ONE entry that updates in place, not 7 messages. Latest detail:
>
> M3’s daemon-agent-tools critical path is blocked at [endojs/endo-but-for-bots#1589](https://github.com/endojs/endo-but-for-bots/issues/1589): decide whether its new Fae/Lal workspace catalogs may proceed or must instead use code mode, as the panel requires.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_screening_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_screening_journal.md)

> RECOVERED — the watchdog condition `journal-lock-contention-_home_kris_garden__garden_state_screening_journal` has CLEARED (first seen 2026-11-13T20:39:29Z, cleared 2026-11-14T02:39:24Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-lock-contention-_home_kris_garden__garden_state_screening_journal` cleared on endolin-garden-ece02cb4.

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

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal.md)

> WATCHDOG notice — occurrence #11 (first seen 2026-11-07T04:46:32Z, latest 2026-11-14T02:49:48Z).
> The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_worktree_sweeper_journal`) has now been observed 11 times; this is ONE
> coalesced notice that updates in place, not 11 messages. Latest detail:
>
> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.027809s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `msg-reset-credit-watch-20261109-170519-6a0254967ba8` — from gardener:reset-credit-watch-20261109-170519, reply_to `reset-credit-watch-20261109-170519` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-reset-credit-watch-20261109-170519-6a0254967ba8.md)

> Reset-credit watch 2026-11-09: no action this week. No live credits are left: the codex 11-06 credit has expired (codex rolled to 0% about 11-04T22:05Z; if that was the credit, it was used in time). Status: claude-endolin1 is at 12% (about 5%/day, roughly 33% by its 11-14T04:00Z reset), no credits. claude-oros is at 26%, resets 11-10T11:00Z, credits unknown. codex-endolin was at 24% on 11-05 (the meter anchor is stale), resets about 11-11T18:05Z, no credits. claude-endolin2 is retired. If you're granted new credits, tell the liaison and I'll plan around them.

- `watchdog-self-heal-garden-mentor` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-self-heal-garden-mentor.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-25T20:50:35Z, latest 2026-11-14T04:51:53Z).
> The SAME condition (`self-heal-garden-mentor`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: 240eefebd0b262d7083d812ffe39dc67002c07f6 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p 240eefebd0b262d7083d812ffe39dc67002c07f6). Diagnosis: I've found the cause and am writing it up now.
>
> **Diagnosis:** `garden-mentor` exited 1 because the mentor's improve handler tried to post `improve-foreman-paused-plan-and-pipeline`. `post-job.sh` refused it with rc=78, because the job belongs to the paused project `minion-town` (journal record `pauses/minion-town.md`, per the recent "minion.town project pause" commit). `mentor.sh` (around line 407) treats any non-transient handler failure as fatal. It leaves the input markers unadvanced, so every tick reproduces the same refusal, dies, and fires self-heal. Nothing is wrong with the digest or the provider. This is a pause refusal handled as a crash.
>
> Restarting the service won't clear it, and the refusal will recur every tick until the pause is lifted (`pause-project.sh minion-town off`) o

- `watchdog-journal-push-contention-_home_kris_garden__garden_state_gardener_scaler_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-push-contention-_home_kris_garden__garden_state_gardener_scaler_journal.md)

> RECOVERED — the watchdog condition `journal-push-contention-_home_kris_garden__garden_state_gardener_scaler_journal` has CLEARED (first seen 2026-11-12T22:23:42Z, cleared 2026-11-13T04:18:42Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-push-contention-_home_kris_garden__garden_state_gardener_scaler_journal` cleared on endolin-garden-ece02cb4.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_deadline_nudge_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_deadline_nudge_journal.md)

> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=0.020721s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `watchdog-minion-town-screening-tick-failed-endolin-garden-ece02cb4` — from watchdog:self-heal, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-minion-town-screening-tick-failed-endolin-garden-ece02cb4.md)

> RECOVERED — the watchdog condition `minion-town-screening-tick-failed-endolin-garden-ece02cb4` has CLEARED (first seen 2026-11-13T05:53:04Z, cleared 2026-11-13T06:44:30Z).
> It was observed 10 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> minion.town screening on endolin-garden-ece02cb4 completed after a 12-tick failure streak.

- `watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_regenerate_topics_counts_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_regenerate_topics_counts_journal.md)

> RECOVERED — the watchdog condition `journal-fetch-slow-_Users_dom_garden__garden_state_regenerate_topics_counts_journal` has CLEARED (first seen 2026-11-13T18:27:29Z, cleared 2026-11-14T00:17:50Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-fetch-slow-_Users_dom_garden__garden_state_regenerate_topics_counts_journal` cleared on oros-studio-garden-ce242c49.

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

- `msg-improve-byte-capacity-guard-f6ab3d56da32` — from gardener:improve-byte-capacity-guard, reply_to `improve-byte-capacity-guard` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-improve-byte-capacity-guard-f6ab3d56da32.md)

> FYI from improve-byte-capacity-guard: host endolin-garden-ece02cb4's /home/kris/garden filesystem (/dev/nvme0n1p2, ~3.6 TiB) is at ~176-500 MiB free right now and briefly hit 0 during this job (a Claude tmp write failed with ENOSPC; tests can't use /dev/shm, which is noexec). The new root-repo-guard byte detector (main2 a6b75fe4c08, 5 GiB floor) will page on this once deployed, but the space needs reclaiming by hand now: du -xsh under .garden-state, scratch/, worktrees/.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_scheduler_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_scheduler_journal.md)

> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/scheduler/journal: p95=0.026151s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `watchdog-journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal.md)

> WATCHDOG notice — occurrence #10 (first seen 2026-11-06T04:41:40Z, latest 2026-11-14T00:54:28Z).
> The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_bulletin_journal`) has now been observed 10 times; this is ONE
> coalesced notice that updates in place, not 10 messages. Latest detail:
>
> Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.039660s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_self_deploy_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_Users_dom_garden__garden_state_self_deploy_journal.md)

> RECOVERED — the watchdog condition `journal-fetch-slow-_Users_dom_garden__garden_state_self_deploy_journal` has CLEARED (first seen 2026-11-13T22:18:28Z, cleared 2026-11-14T04:08:11Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-fetch-slow-_Users_dom_garden__garden_state_self_deploy_journal` cleared on oros-studio-garden-ce242c49.

- `watchdog-journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal.md)

> WATCHDOG notice — occurrence #3 (first seen 2026-11-13T01:21:58Z, latest 2026-11-14T05:03:16Z).
> The SAME condition (`journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal`) has now been observed 3 times; this is ONE
> coalesced notice that updates in place, not 3 messages. Latest detail:
>
> Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.047624s, giveups=1, steals=0 (max 3/window), wait floor=60s.


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 10.8M | $45.81 _(notional, rate-card)_ | 4% of 271.0M (ok) |
| Codex | 381.5M _(fleet aggregate)_ | n/a _(ChatGPT pro plan — no per-token $; plan-metered)_ | 29% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 150539022 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 7.264620s/45s (/home/kris/garden/.garden-state/dependabotany-preflight/journal); 13 open notice(s); checker healthy

## Board
### todo (6)
- [`canary-probe-oros-studio-garden-ce242c49-66ab9cc20185-r1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/canary-probe-oros-studio-garden-ce242c49-66ab9cc20185-r1.md) — rolling-deploy canary probe for oros-studio-garden-ce242c49 @ 66ab9cc20185
- [`canary-probe-oros-studio-garden-ce242c49-66ab9cc20185-r3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/canary-probe-oros-studio-garden-ce242c49-66ab9cc20185-r3.md) — rolling-deploy canary probe for oros-studio-garden-ce242c49 @ 66ab9cc20185
- [`scholar-ingest-fudco-gist-20261105`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/scholar-ingest-fudco-gist-20261105.md) — Ingest the FUDCo gist and report on it
- [`scholar-ingest-nanoseedlm-20261013`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/scholar-ingest-nanoseedlm-20261013.md) — Ingest "NanoSeedLM: LLM inference using pseudo-random numbers" and report on ...
- [`scholar-ingest-edera-product-20261105`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/scholar-ingest-edera-product-20261105.md) — Ingest the Edera product page and report on it
- [`canary-probe-oros-studio-garden-ce242c49-66ab9cc20185-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/canary-probe-oros-studio-garden-ce242c49-66ab9cc20185-r2.md) — rolling-deploy canary probe for oros-studio-garden-ce242c49 @ 66ab9cc20185

### doin (4)
- [`shepherd-endojs-endo-but-for-bots-pr1588`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/shepherd-endojs-endo-but-for-bots-pr1588.md) — ---
- [`endojs-endo-but-for-bots-pr1588-shepherd`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1588-shepherd.md) — ---
- [`endojs-endo-but-for-bots-pr1588-weave`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1588-weave.md) — ---
- [`shepherd-endojs-endo-but-for-bots-pr1590`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/shepherd-endojs-endo-but-for-bots-pr1590.md) — ---

### tada (17060)
- [`improve-foreman-paused-project-admission`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/11/14/improve-foreman-paused-project-admission.md) — Cost
- [`improve-mentor-paused-project-posting`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/11/14/improve-mentor-paused-project-posting.md) — Completion report: improve-mentor-paused-project-posting
- [`shepherd-endojs-endo-but-for-bots-pr1501`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/11/14/shepherd-endojs-endo-but-for-bots-pr1501.md) — Cost
- [`build-daemon-rename-to-manager`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/11/14/build-daemon-rename-to-manager.md) — Report: build-daemon-rename-to-manager. No new PR opened, because one already...
- [`issue-status-pass-go-live`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/11/14/issue-status-pass-go-live.md) — Cost
- … and 17055 more

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
- [`deadmail-issue-comment-6659790262`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deadmail-issue-comment-6659790262.md) — _normal_ · Issue follow-up — fold a late comment into the issue work
- [`open-signup-gate-flip-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`build-daemon-git-remotes-phase-six-interactive-provisioning-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-daemon-git-remotes-phase-six-interactive-provisioning-r2.md) — _normal_ · ---
- [`kriscendobot-minion.town-pr228-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr228-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — kriscendobot/minion.town PR #228
- [`design-daemon-git-remotes-extended-transports-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-daemon-git-remotes-extended-transports-r2.md) — _normal_ · ---
- [`fix-endojs-endo-but-for-bots-pr1621-drop-regexp-hunk-20261106`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fix-endojs-endo-but-for-bots-pr1621-drop-regexp-hunk-20261106.md) — _normal_ · ---
- [`screen-minion-town-pr253-9c79d18-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/screen-minion-town-pr253-9c79d18-conduct.md) — _normal_ · Screened delegated merge: kriscendobot/minion.town#253 at 9c79d1807388884a67b...
- [`endojs-endo-but-for-bots-pr1595-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1595-gauntlet-panel-6.md) — _normal_ · Gauntlet stage: PANEL round 6 — endojs/endo-but-for-bots PR #1595
- [`moddable-10-0-0-ironhorse-callability-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-callability-port.md) — _normal_ · Port revoked-Proxy callability and constructability to IronHorse
- [`oros-health-watch-20261109-060512`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261109-060512.md) — _normal_ · ---
- [`weave-endojs-endo-but-for-bots-pr1538`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-endojs-endo-but-for-bots-pr1538.md) — _normal_ · ---
- [`minion-town-arc-press-20261107-043512`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261107-043512.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`oros-health-watch-20261107-075009`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261107-075009.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source.md) — _normal_ · Build: SES import attributes — Phase 2 (module-source static with capture)
- [`oros-health-watch-20261107-043512`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261107-043512.md) — _normal_ · ---
- [`improve-screening-cooldown-log-spam-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-screening-cooldown-log-spam-r2.md) — _normal_ · ---
- [`daemon-git-capability-phase-five-contract-tests-build-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-git-capability-phase-five-contract-tests-build-r2.md) — _normal_ · ---
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`design-minion-town-ocap-site-crawler-leak-rotation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-minion-town-ocap-site-crawler-leak-rotation.md) — _normal_ · Design: detect a crawler on an ocap.site page as a link-leak signal, and rotate
- [`kriscendobot-minion-town-pr183-open-findings-fix-20261015`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr183-open-findings-fix-20261015.md) — _normal_ · Fix the structural findings left open on kriscendobot/minion.town#183
- [`endojs-endo-but-for-bots-pr1498-gauntlet-undraft`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1498-gauntlet-undraft.md) — _normal_ · Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1498
- [`kriscendobot-minion-town-pr237-screen-304dd248-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr237-screen-304dd248-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — kriscendobot/minion.town PR #237
- [`endopi-extension-package-guest-provider-kinds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endopi-extension-package-guest-provider-kinds.md) — _normal_ · ---
- [`minion-town-remote-guest-cli-live-proof`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-remote-guest-cli-live-proof.md) — _normal_ · ---
- [`minion-town-arc-press-20261105-200509`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261105-200509.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`dependabotany-recheck-endo-but-for-bots-20261107-013512`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/dependabotany-recheck-endo-but-for-bots-20261107-013512.md) — _normal_ · ---
- [`kriscendobot-minion.town-pr199-weave-20261103`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr199-weave-20261103.md) — _normal_ · Weave kriscendobot/minion.town#199 onto current main
- [`kriscendobot-minion-town-pr252-screen-528d4a1f-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr252-screen-528d4a1f-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — kriscendobot/minion.town PR #252
- [`improve-screening-cas-failure-handling`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-screening-cas-failure-handling.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1653-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1653-gauntlet-panel-1.md) — _normal_ · Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1653
- [`deploy-minion-town-waitlist-soon-page-20261107`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-minion-town-waitlist-soon-page-20261107.md) — _normal_ · ---
- [`claude-on-minion-town-completion-press-20261107-retry`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-completion-press-20261107-retry.md) — _normal_ · Completion press: Claude-on-minion.town arc
- [`build-daemon-git-remotes-transport-timing-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-daemon-git-remotes-transport-timing-r2.md) — _normal_ · ---
- [`build-minion-town-retire-resident-role-20261105`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-retire-resident-role-20261105.md) — _normal_ · ---
- [`oros-health-watch-20261108-113509`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261108-113509.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1416-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1416-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1416
- [`daily-progress-summary-20261107-080513`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daily-progress-summary-20261107-080513.md) — _normal_ · Daily midnight Pacific progress summary
- [`oros-health-watch-20261108-235013`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261108-235013.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1430-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1430-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1430
- [`endojs-endo-but-for-bots-pr1504-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1504-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1504
- [`oros-health-watch-20261108-203533`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261108-203533.md) — _normal_ · ---
- [`fixer-endojs-endo-but-for-bots-pr1595`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fixer-endojs-endo-but-for-bots-pr1595.md) — _normal_ · ---
- [`ebfb-llm-xs-daemon-bundle-reconcile`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-xs-daemon-bundle-reconcile.md) — _normal_ · ---
- [`improve-suppress-routine-retry-progress`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-suppress-routine-retry-progress.md) — _normal_ · ---
- [`build-readableblob-range-attenuation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-readableblob-range-attenuation.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`design-daemon-git-remotes-ssh-transport-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-daemon-git-remotes-ssh-transport-r2.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1433-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1433-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1433
- [`endojs-endo-but-for-bots-pr1652-gauntlet-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1652-gauntlet-fix-5.md) — _normal_ · Gauntlet stage: FIX round 5 — endojs/endo-but-for-bots PR #1652
- [`ironhorse-iterator-scenario-parity-maintainer-decision`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-iterator-scenario-parity-maintainer-decision.md) — _high_ · resolve the remaining acceptance scope for IronHorse iterator scenario parity
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`minion-town-arc-press-20261107-075009`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261107-075009.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`improve-decision-ledger-contention-spool-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-decision-ledger-contention-spool-r2.md) — _normal_ · ---
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
- [`endojs-endo-but-for-bots-pr1486-gauntlet-undraft`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1486-gauntlet-undraft.md) — _normal_ · Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1486
- [`oros-health-watch-20261107-105011`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261107-105011.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr909-fix-ts-make-daemon`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-fix-ts-make-daemon.md) — _normal_ · Fix: endo make / endo archive TypeScript support is broken (endojs/endo-but-f...
- [`improve-gardener-handler-rc76-collision-expanded-window`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-gardener-handler-rc76-collision-expanded-window.md) — _normal_ · Land the gardener fix for spooled review-docket notices failing finished jobs
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
- [`drive-mystic-rollout-20260723`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/drive-mystic-rollout-20260723.md) — _low_ · ---
- [`kimi-k3-canary-20260723-c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kimi-k3-canary-20260723-c.md) — _low_ · ---
- [`claude-on-minion-town-completion-press-20261105-133510`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-completion-press-20261105-133510.md) — _normal_ · Completion press: Claude-on-minion.town arc
- [`claude-on-minion-town-completion-press-20261106-020511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-completion-press-20261106-020511.md) — _normal_ · Completion press: Claude-on-minion.town arc
- [`improve-transient-retry-budget-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-transient-retry-budget-r2.md) — _normal_ · ---
- [`moddable-10-0-0-ironhorse-typedarray-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-typedarray-port.md) — _normal_ · Port Moddable 10.0.0 TypedArray corrections to IronHorse
- [`moddable-10-0-0-ironhorse-immutable-arraybuffer-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-immutable-arraybuffer-port.md) — _normal_ · Implement immutable ArrayBuffer and close the Moddable 10.0.0 validation camp...
- [`endojs-endo-but-for-bots-pr1538-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1538-gauntlet-panel-6.md) — _normal_ · Gauntlet stage: PANEL round 6 — endojs/endo-but-for-bots PR #1538
- [`kriscendobot-minion.town-pr248-review-edbd57fa`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr248-review-edbd57fa.md) — _normal_ · Review directive on kriscendobot/minion.town PR #248
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`screen-minion-town-pr246-93329d9-conduct-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/screen-minion-town-pr246-93329d9-conduct-r2.md) — _normal_ · Screened delegated merge: kriscendobot/minion.town#246 at 93329d9faf0564a5791...
- [`improve-minion-town-arc-press-breaker`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-minion-town-arc-press-breaker.md) — _normal_ · ---
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
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`oros-health-watch-20261108-143510`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261108-143510.md) — _normal_ · ---
- [`minion-town-mcp-guide-remaining-slices-20261104`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-mcp-guide-remaining-slices-20261104.md) — _normal_ · Finish the MCP guide's remaining slices (kriscendobot/minion.town#235)
- [`endojs-endo-but-for-bots-pr1340-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1340-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1340
- [`endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper.md) — _normal_ · Build: SES import attributes — Phase 3 (compartment-mapper plumbing)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`oros-health-checkup-20261013-133505`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-checkup-20261013-133505.md) — _normal_ · Deliberate overrun decomposition for oros-health-checkup-20261013-133505
- [`oros-health-watch-20261105-165012`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261105-165012.md) — _normal_ · ---
- [`improve-production-acceptance-deferred-probe`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-production-acceptance-deferred-probe.md) — _normal_ · ---
- [`moddable-10-0-0-ironhorse-builtins-order-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-builtins-order-port.md) — _normal_ · Port three Moddable 10.0.0 built-in ordering corrections to IronHorse
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
- [`ironhorse-test262-press-20261113-225326`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-test262-press-20261113-225326.md) — _normal_ · ---
- [`kriscendobot-minion.town-pr199-review-4460eb00-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr199-review-4460eb00-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #199 (primary: kriscendobot-mini...
- [`endojs-endo-but-for-bots-pr1575-review-938c3acf-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1575-review-938c3acf-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1575 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1543-review-ed16aaac-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1543-review-ed16aaac-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1543 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1573-review-cc1b8fb6-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1573-review-cc1b8fb6-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1573 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1574-review-f45dd5bb-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1574-review-f45dd5bb-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1574 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1647-review-693a492c-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1647-review-693a492c-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1647 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1335-review-a060f580-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1335-review-a060f580-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1335 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1652-review-358defcf-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1652-review-358defcf-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1652 (primary: endojs-endo-but-...
- [`kriscendobot-minion.town-pr247-review-213830b3-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr247-review-213830b3-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #247 (primary: kriscendobot-mini...
- [`kriscendobot-minion.town-pr248-review-edbd57fa-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr248-review-edbd57fa-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #248 (primary: kriscendobot-mini...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`ebfb-platform-fs-pet-name-path-only`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-platform-fs-pet-name-path-only.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1390` · ---
- [`endo-minion-town-federation-release-gate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-minion-town-federation-release-gate.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1124` · Gate: reviewed and deployable federation release
- [`endojs-endo-but-for-bots-pr1347-weave-after-pr1585`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1347-weave-after-pr1585.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1585` · ---
- [`endojs-endo-but-for-bots-pr1602-weave-after-pr1585`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1602-weave-after-pr1585.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1585` · ---
- [`conduct-endojs-endo-but-for-bots-pr1575-endolin`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/conduct-endojs-endo-but-for-bots-pr1575-endolin.md) — awaiting `weave-endojs-endo-but-for-bots-pr1575-onto-llm-after-pr1573` · Conduct endojs/endo-but-for-bots PR #1575
- [`claude-api-p3-minion-ui`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-api-p3-minion-ui.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1575` · Phase 3: minion.town provider endpoint, UI step, and Providers page
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`verify-minion-town-recovery-outcome-production-20261107g`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-minion-town-recovery-outcome-production-20261107g.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/254` · ---
- [`regauntlet-ebfb-pr1425-after-zizmor-fix-20261006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/regauntlet-ebfb-pr1425-after-zizmor-fix-20261006.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1427` · ---
- [`fu-daemon-git-agent-tool-adapters-docs`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fu-daemon-git-agent-tool-adapters-docs.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1641` · ---
- [`minion-town-ocapn-canary-live-run-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-ocapn-canary-live-run-2.md) — awaiting `endo-minion-town-federation-live-acceptance` · Live run of the minion.town OCapN guest canary (resumes minion-town-ocapn-can...
- [`build-confined-fetch-timer-endowment`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-confined-fetch-timer-endowment.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1588` · ---
- [`endo-mvs-semver-convergence`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-mvs-semver-convergence.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1596` · Converge the Rust npm resolver and the daemon semver copy on exo-npm's MVS rule
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1019` · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`build-minion-town-tool-removal-landing-20261104`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-tool-removal-landing-20261104.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/239` · Land the MCP tool removal after #239 deploys (kriscendobot/minion.town)
- [`kriscendobot-minion-town-node-observed-interpreter`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-node-observed-interpreter.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/171` · minion.town: observe the root-owned Node interpreter in the harness layout probe
- [`minion-town-guide-accept-link-after-240-20261104`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-guide-accept-link-after-240-20261104.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/240` · Point agents at the /accept invitation link once #240 lands (kriscendobot/min...
- [`ebfb-parcel-layer2-build-20261024`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-parcel-layer2-build-20261024.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/774` · Build: Parcel layer 2 (SES %InitialParcel% / %SharedParcel%), endojs/endo-but...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`verify-minion-town-remove-open-in-new-tab-prod-20261104`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-minion-town-remove-open-in-new-tab-prod-20261104.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/246` · ---
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`weave-api-key-p2-acceptance-after-pr1575`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-api-key-p2-acceptance-after-pr1575.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1575` · Weave the phase 2 gap PR onto llm after #1575 merges
- [`endo-fs-subview-mount-rename`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-fs-subview-mount-rename.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1586` · ---
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`migrate-coupons-onto-exo-dynamodb`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-coupons-onto-exo-dynamodb.md) — awaiting `build-recursive-dynamodb-capabilities` · ---
- [`endojs-endo-but-for-bots-pr1658-dependabot-conduct-after-pr1646`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1658-dependabot-conduct-after-pr1646.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1646` · Conduct endojs/endo-but-for-bots PR #1658 (preact 10.29.8 -> 11.1.1) after th...
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`build-exo-sheets-service`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-sheets-service.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`conduct-endojs-endo-but-for-bots-pr1573-after-pr1646`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/conduct-endojs-endo-but-for-bots-pr1573-after-pr1646.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1646` · Conduct endojs/endo-but-for-bots PR #1573 after the Node pin lands
- [`endojs-endo-but-for-bots-pr1501-weave-after-pr1585`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1501-weave-after-pr1585.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1585` · ---
- [`build-minion-town-guest-coupons-phase1-rest`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-guest-coupons-phase1-rest.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/199` · Build the rest of guest-coupons phase 1 on kriscendobot/minion.town
- [`endojs-endo-but-for-bots-pr1501-weave-after-pr1613`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1501-weave-after-pr1613.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1613` · ---
- [`ironhorse-fuzz-triage-differential_source-efffacee3e2a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-triage-differential_source-efffacee3e2a.md) — awaiting `https://github.com/kriscendobot/garden/issues/91` · Triage 7 Ironhorse fuzz finding(s) for target differential_source
- [`minion-town-ui-gutter-mint`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-ui-gutter-mint.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/142` · Gutter: the + button mints a real clip (minion-town-ui increment)
- [`weave-endojs-endo-but-for-bots-pr1575-onto-llm-after-pr1573`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-endojs-endo-but-for-bots-pr1575-onto-llm-after-pr1573.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1573` · Weave endojs/endo-but-for-bots PR #1575 onto llm after its parent #1573 merges

## Watch set
kriscendobot-minion.town kriscendobot-garden-book kriscendobot-cosgov kriscendobot-ocapn kriscendobot-oros-ckm-data-readiness kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 4 monks
- [.archived-endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-endolin-garden2-5bcdff64): 1 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 4 monks
