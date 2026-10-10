# Garden bulletin

[Current priorities and maintainer review docket](PRIORITIES.md)

_As of 2026-10-10T10:24:40Z_

## Latest

Gauntlet traffic centered on minion.town. The [minion.town#174](https://github.com/kriscendobot/minion.town/pull/174) gauntlet spent all 6 panel/fix rounds without converging and now waits on a human decision. A seventh panel round is queued if you grant more budget (`--add-rounds`). Its panel-reviewed head is stale against the presented head, so the earlier panel does not cover current code. [minion.town#171](https://github.com/kriscendobot/minion.town/pull/171) also hit its 2-round review budget. [minion.town#166](https://github.com/kriscendobot/minion.town/pull/166) has the same stale-head notice, and its panel round 3 is queued. The [minion.town#93](https://github.com/kriscendobot/minion.town/pull/93) clean stage and a minion.town arc press completed. The [endo-but-for-bots#1403](https://github.com/endojs/endo-but-for-bots/pull/1403) gauntlet moved on to panel round 4.

Several things need attention:
- **Moddable 10.0.0 Ironhorse port-plan:** the whole decomposition halted on handler timeouts (2400s budget). The audit, inventory, and synthesis children each overran, and the failed attempts left nothing completed. The [endo-but-for-bots#179](https://github.com/endojs/endo-but-for-bots/pull/179) weave also overran its handler budget twice.
- **minion.town deploys:** the screener is still paused. The [minion.town#169](https://github.com/kriscendobot/minion.town/pull/169) deploy failure was a GitHub Actions billing block, not a code break, so production is unchanged. You choose between resuming delegation by hand, moving CD onto the self-hosted runner, or waiting for the reset.
- **Hosts:** the leader cannot validate a deploy. `endolin-garden2` has been offline for about 6.6 hours. `oros-studio` is back but its canary is stuck on an older SHA (192 notices). The rolling deploy is therefore holding the leader. `oros-studio` also still needs the temporary sysop drop-in removed once it deploys `96a2b4c6141`.
- **Other halted orchestrations:** the review-docket consolidate job is parked after being doomed. The oauth-bonds build and the Jev triage trial both declared unsatisfied outcomes. The Jev trial is blocked on a missing `TYPESAFE_API_KEY`.
- **DNSSEC:** the ocap.site DS record is still unpublished, and the 60-day transfer window has now opened.

## Maintainer review docket

125 open · [ordered priorities and review docket](https://github.com/kriscendobot/garden/blob/journal2/PRIORITIES.md)
## Screened by proxy (minion.town)

Delegation: **active**

- 2026-10-09T11:02:09Z [#122](https://github.com/kriscendobot/minion.town/pull/122) merged `c9a073cc044`; deploy [success](https://github.com/kriscendobot/minion.town/actions/runs/37921255681), watchdog ok — validated

## Messages to the maintainer

- `watchdog-journal-fetch-slow-_home_kris_garden2__garden_state_leader_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_home_kris_garden2__garden_state_leader_journal.md)

> RECOVERED — the watchdog condition `journal-fetch-slow-_home_kris_garden2__garden_state_leader_journal` has CLEARED (first seen 2026-10-09T02:59:25Z, cleared 2026-10-09T03:54:05Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-fetch-slow-_home_kris_garden2__garden_state_leader_journal` cleared on endolin-garden2-5bcdff64.

- `msg-ocap-site-dnssec-followup-20261008-df1e9ee7a916` — from gardener:ocap-site-dnssec-followup-20261008, reply_to `ocap-site-dnssec-followup-20261008` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ocap-site-dnssec-followup-20261008-df1e9ee7a916.md)

> ocap.site DNSSEC / transfer follow-up (2026-10-08 01:22Z)
>
> - Transfer eligibility: still UNTRANSFERABLE per `route53domains check-domain-transferability` ("registered recently... wait 60 days").
> - RDAP: registered 2026-08-10T19:55:35Z at Key-Systems LLC, status active. The 60-day window ends ~2026-10-09T19:55Z, so transfer into Route53 Domains should become possible from Friday 2026-10-09 evening UTC (registrar-side locks permitting). It will need a fresh auth code from Key-Systems plus your contact details; I did not attempt it.
> - DNSSEC: Route53 zone Z048672026UQWLGHNEQE0 still SIGNING, but the DS record is STILL UNPUBLISHED at the registrar: RDAP shows delegationSigned=false and there is no DS for ocap.site in the .site zone. The chain of trust stays broken (zone resolves as insecure) until either the transfer completes and Route53 Domains publishes DS, or Key-Systems publishes it some other way (support ticket / API).
>
> Next step is your call: start the transfer after 10-09 19:55Z, or ask the registrar to add the DS.

- `watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-host-offline-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-10-08T20:53:04Z, cleared 2026-10-10T06:38:02Z).
> It was observed 1836 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> heartbeat resumed for oros-studio-garden-ce242c49; it is PRESENT again and will automatically rejoin the canary rotation while its hosts/oros-studio-garden-ce242c49 record remains active. Archived records are not unarchived automatically.

- `watchdog-rolling-deploy-no-canary-endolin-garden-ece02cb4` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-no-canary-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #6 (first seen 2026-09-30T23:36:06Z, latest 2026-10-10T04:14:02Z).
> The SAME condition (`rolling-deploy-no-canary-endolin-garden-ece02cb4`) has now been observed 6 times; this is ONE
> coalesced notice that updates in place, not 6 messages. Latest detail:
>
> Rolling deploy is HOLDING the leader: every configured follower is OFFLINE or
> operator-drained, so there is no canary to validate de3e1c46ce2e. The leader will
> not advance unvalidated. Restore any offline host until budget/live heartbeats resume,
> or lift an operator drain. An archived host additionally needs a separate operator
> unarchive; this roll never reverses archival. (leader=endolin-garden-ece02cb4, offline=2)

- `msg-heal-minion-town-39867df-44e244494ac6` — from gardener:heal-minion-town-39867df, reply_to `heal-minion-town-39867df` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-heal-minion-town-39867df-44e244494ac6.md)

> heal-minion-town-39867df: [kriscendobot/minion.town#169](https://github.com/kriscendobot/minion.town/issues/169) did NOT break minion.town production; no heal PR opened.
> The deploy.yml failure (https://github.com/kriscendobot/minion.town/actions/runs/37868510874) is the kriscendobot Actions billing block (since 2026-10-08 07:59Z, expected to clear ~10-30): the job got no runner, ran zero steps, and failed in 4s. A --failed rerun (job 113641657561) failed the same way. CI's test job for the same SHA passed on the self-hosted ci.minion.town runner, but deploy.yml always runs on GitHub-hosted runners (skills/minion-town-ci-runner-switch § Notes). Production still serves the [kriscendobot/minion.town#143](https://github.com/kriscendobot/minion.town/issues/143) deploy (https://minion.town/ returns 200). [kriscendobot/minion.town#169](https://github.com/kriscendobot/minion.town/issues/169) is simply undeployed. A revert PR's merge would be billing-refused in exactly the same way, so it would only throw away valid work.
> Consequence: the screener paused the delegation, and it auto-resumes only after a green main deploy, so it stays paused until the billing reset or until you act. Your options: (a) resume the delegation by hand and accept undeployed merges until the reset; (b) authorize moving CD onto the ci.minion.town runner (puts the prod deploy role on that host, which is your call per the skill); (c) wait for the reset. I also recommend a garden follow-up: have the screener treat a deploy run with no runner and zero steps as "billing-deferred" rather than a merge failure, so each merge during a block doesn't post another heal job. Say so and I'll post it.

- `watchdog-handler-budget-overrun-moddable-10-0-0-ironhorse-port-plan-20261009` — from watchdog:monk/4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-handler-budget-overrun-moddable-10-0-0-ironhorse-port-plan-20261009.md)

> gardener job 'moddable-10-0-0-ironhorse-port-plan-20261009' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2404s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-resume-halted` — from orchestrator:moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-resume-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-resume-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-resume
> orchestration-status: halted
> child: moddable-10-0-0-ironhorse-port-plan-synthesis-20261009
> failure-kind: handler-timeout
> children-completed: 0
> children-total: 1
> halt-parked-remainder: 
>
> Orchestration moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-resume HALTED: child moddable-10-0-0-ironhorse-port-plan-synthesis-20261009 stalled in flight for 2612s on host endolin-garden-ece02cb4 (handler-timeout=2400s, multiplier=1) (serial, on-child-failure=halt). 0/1 done before halt; parked remainder: none

- `watchdog-journal-contention-storm-lock-contention` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-storm-lock-contention.md)

> RECOVERED — the watchdog condition `journal-contention-storm-lock-contention` has CLEARED (first seen 2026-10-10T07:21:03Z, cleared 2026-10-10T08:46:09Z).
> It was observed 6 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-contention-storm-lock-contention` cleared on oros-studio-garden-ce242c49.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-2.md)

> budget-level changed endolin-garden-ece02cb4 cleric workers 1 -> 2 (target 2): shared codex subscription demand active=1 queue=9 quota=ok fleet-envelope=4 target=2

- `msg-trial-jev-triage-foreman-classification-af360d7b85fb` — from gardener:trial-jev-triage-foreman-classification, reply_to `trial-jev-triage-foreman-classification` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-trial-jev-triage-foreman-classification-af360d7b85fb.md)

> The Jev triage/foreman trial is blocked because TYPESAFE_API_KEY is absent from the job environment. Please provision the maintainer-owned key for a re-run; per the trial specification I have not searched for or configured a credential.

- `watchdog-budget-level-monk-oros-studio-garden-ce242c49-5` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-oros-studio-garden-ce242c49-5.md)

> budget-level changed oros-studio-garden-ce242c49 monk workers 4 -> 5 (target 6): subscription claude-oros spend=11356596 cap=180000000 pace-bias=0.436502 window-start=2026-10-06T10:00Z(calendar) deadline=2026-10-13T10:00Z(calendar) ceiling=6 backoff=0.6967(ramp) target=6

- `watchdog-budget-zone-endolin-garden-ece02cb4-ok` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden-ece02cb4-ok.md)

> subscription claude-endolin1 changed zone backoff -> ok at spend=87772/271000000.

- `watchdog-handler-budget-overrun-endojs-endo-but-for-bots-pr179-weave-20261010` — from watchdog:monk/2, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-handler-budget-overrun-endojs-endo-but-for-bots-pr179-weave-20261010.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-10-10T06:44:24Z, latest 2026-10-10T08:39:03Z).
> The SAME condition (`handler-budget-overrun-endojs-endo-but-for-bots-pr179-weave-20261010`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> gardener job 'endojs-endo-but-for-bots-pr179-weave-20261010' DETERMINISTICALLY overran its handler budget (rc=124, term-at-wall, elapsed=2408s, handler-budget=2400s, kill-grace=60s). It does not fit in a single claim-scoped handler. An ordinary job is re-posted for deliberate orchestration decomposition immediately; a gauntlet stage is handed directly to its driver's max_stage_retries policy. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.

- `watchdog-journal-fetch-slow-_home_kris_garden2__garden_state_cursors_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_home_kris_garden2__garden_state_cursors_journal.md)

> RECOVERED — the watchdog condition `journal-fetch-slow-_home_kris_garden2__garden_state_cursors_journal` has CLEARED (first seen 2026-10-09T03:04:14Z, cleared 2026-10-09T03:07:59Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-fetch-slow-_home_kris_garden2__garden_state_cursors_journal` cleared on endolin-garden2-5bcdff64.

- `watchdog-journal-fetch-slow-_home_kris_garden2__garden_state_maintainer_approval_verify` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_home_kris_garden2__garden_state_maintainer_approval_verify.md)

> RECOVERED — the watchdog condition `journal-fetch-slow-_home_kris_garden2__garden_state_maintainer_approval_verify` has CLEARED (first seen 2026-10-09T03:09:15Z, cleared 2026-10-09T03:59:20Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-fetch-slow-_home_kris_garden2__garden_state_maintainer_approval_verify` cleared on endolin-garden2-5bcdff64.

- `stale-panel-head-kriscendobot-minion.town-pr174-f7dfa808-3e088a18` — from gardener:minion-town-arc-press-20261009-142016, reply_to `minion-town-arc-press-20261009-142016` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/stale-panel-head-kriscendobot-minion.town-pr174-f7dfa808-3e088a18.md)

> Stale panel coverage for completed job `minion-town-arc-press-20261009-142016`: [https://github.com/kriscendobot/minion.town/pull/174](https://github.com/kriscendobot/minion.town/pull/174) moved from panel-reviewed head `f7dfa8088039c61689a162d51d5601942d967e11` to presented head `3e088a1837ef793d0a345a1e498f939482df8e6e`.
>
> Disposition: **review required**. The earlier panel does not cover the current head; every commit delta is conservatively review-relevant. A PR metadata-only edit would leave the head unchanged and would not trigger this disposition.
>
> No gauntlet was staged. Route the current head through the existing panel stage only after an explicit maintainer `run the gauntlet` request, or make a maintainer review decision with the stale coverage stated explicitly.

- `followup-gate-improve-design-build-dispatch` — from followup-gate:improve-design-build-dispatch, reply_to `improve-design-build-dispatch` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/followup-gate-improve-design-build-dispatch.md)

> Job "improve-design-build-dispatch" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.
>
> ## Follow-ups
> - `design-minion-town-oauth-bonds` is still in `doin`. A requeue will only pass on its own once this change is deployed to that host. Its build is still owned by `orch-minion-town-oauth-bonds`.
> - This is separate from the existing `DESIGN-BUILD-RECHECK` path in `handlers/follow-up-claude.sh`. That path waits for a cross-referenced build PR to appear and never posts the builder job.

- `stale-panel-head-kriscendobot-minion.town-pr166-4353d0bf-1f84e580` — from gardener:claude-on-minion-town-completion-press-20261009-182008, reply_to `claude-on-minion-town-completion-press-20261009-182008` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/stale-panel-head-kriscendobot-minion.town-pr166-4353d0bf-1f84e580.md)

> Stale panel coverage for completed job `claude-on-minion-town-completion-press-20261009-182008`: [https://github.com/kriscendobot/minion.town/pull/166](https://github.com/kriscendobot/minion.town/pull/166) moved from panel-reviewed head `4353d0bf0d0f0e1774b565d251743e7e69ce9332` to presented head `1f84e580ef0e973d1aaef69dd2731a9893855741`.
>
> Disposition: **review required**. The earlier panel does not cover the current head; every commit delta is conservatively review-relevant. A PR metadata-only edit would leave the head unchanged and would not trigger this disposition.
>
> No gauntlet was staged. Route the current head through the existing panel stage only after an explicit maintainer `run the gauntlet` request, or make a maintainer review decision with the stale coverage stated explicitly.

- `watchdog-comment-ack-latency-endojs-endo-but-for-bots` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-ack-latency-endojs-endo-but-for-bots.md)

> RECOVERED — the watchdog condition `comment-ack-latency-endojs-endo-but-for-bots` has CLEARED (first seen 2026-10-09T01:42:46Z, cleared 2026-10-09T01:47:09Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Comment acknowledgment condition cleared.

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-2.md)

> budget-level changed endolin-garden2-5bcdff64 cleric workers 1 -> 2 (target 2): shared codex subscription demand active=1 queue=9 quota=ok fleet-envelope=4 target=2

- `watchdog-journal-contention-storm-fetch-slow` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-storm-fetch-slow.md)

> RECOVERED — the watchdog condition `journal-contention-storm-fetch-slow` has CLEARED (first seen 2026-10-10T03:52:48Z, cleared 2026-10-10T06:27:40Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-contention-storm-fetch-slow` cleared on endolin-garden-ece02cb4.

- `watchdog-rolling-deploy-canary-failed-endolin-garden-ece02cb4` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-failed-endolin-garden-ece02cb4.md)

> RECOVERED — the watchdog condition `rolling-deploy-canary-failed-endolin-garden-ece02cb4` has CLEARED (first seen 2026-10-09T03:53:09Z, cleared 2026-10-09T05:53:08Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> retrying canary endolin-garden-ece02cb4 (attempt 1/3); clearing prior page.

- `msg-minion-town-ci-runner-redeploy-verify-50aa690-d2a7e84df68d` — from gardener:minion-town-ci-runner-redeploy-verify-50aa690, reply_to `minion-town-ci-runner-redeploy-verify-50aa690` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-ci-runner-redeploy-verify-50aa690-d2a7e84df68d.md)

> ci.minion.town validation succeeded at kriscendobot/minion.town main 50aa690f87bab73cadc83eaeb39806b60913f054. Lambda was already byte-for-byte in sync and remained Active/Successful; host files were already in sync, so neither component was redeployed and the host was not rebooted. Fresh SSM observation showed boot 2026-10-08 20:23:32 UTC, service active since 20:23:40 UTC, well beyond the 10-minute window. Selftest: https://github.com/kriscendobot/minion.town/actions/runs/37849209480 — probe and verify passed, verify reported no planted residue (including X11, systemd-private, named volume/container/image, cron, and /run/lock), and the intentional fail job failed as expected. Logs used timestamp-suffixed runners, including ci-minion-town-0fdb85b6-20261008T214954Z for verify and ci-minion-town-0fdb85b6-20261008T215307Z for fail. CI_RUNS_ON is unset, selecting self-hosted. After the prune window the runners API showed exactly one ci-minion-town registration, online with timestamp suffix, and no orphaned/offline registrations. Open operator items: none.

- `watchdog-budget-zone-endolin-garden-ece02cb4-backoff` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden-ece02cb4-backoff.md)

> subscription claude-endolin1 changed zone ok -> backoff at spend=278190174/271000000.

- `moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-resume-child-moddable-10-0-0-ironhorse-port-plan-synthesis-20261009-failed` — from orchestrator:moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-resume-child-moddable-10-0-0-ironhorse-port-plan-synthesis-20261009-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-resume-child-moddable-10-0-0-ironhorse-port-plan-synthesis-20261009-failed.md)

> orchestration-event: orchestration-child-timeout
> orchestration: moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-resume
> orchestration-status: running
> child: moddable-10-0-0-ironhorse-port-plan-synthesis-20261009
> failure-kind: handler-timeout
> order: serial
> on-child-failure: halt
> detail: stalled in flight for 2612s on host endolin-garden-ece02cb4 (handler-timeout=2400s, multiplier=1)
>
> Orchestration moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-resume observed child moddable-10-0-0-ironhorse-port-plan-synthesis-20261009: stalled in flight for 2612s on host endolin-garden-ece02cb4 (handler-timeout=2400s, multiplier=1).

- `msg-oros-health-watch-20261010-010508-6c8230a9616c` — from gardener:oros-health-watch-20261010-010508, reply_to `oros-health-watch-20261010-010508` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-oros-health-watch-20261010-010508-6c8230a9616c.md)

> oros-health-watch: oros-studio-garden-ce242c49 looks UNREACHABLE since ~02:50Z 2026-10-10. Last journal activity: budget heartbeat 02:49Z (last tada 02:30Z); nothing since (~55 min). A benign op=reset-failed (msg 20261010T031501Z-d7a081, sent 03:15Z) is still unacked at 03:43Z, so the sysop is not ticking either. The rolling-deploy host-offline watchdog keeps re-firing too. Before it went quiet it was healthy: deployed fad05c57 (= main2), roll_status deployed, 1 failed unit (garden-manual-deploy.service), not derotated. The oros-health-checkup schedule is snoozed until 2026-10-12, so no checkup ran this cycle. Needs a person at the machine: check the Mac is awake, Docker Desktop, and the VM/container.

- `watchdog-comment-ack-latency-kriscendobot-garden` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-ack-latency-kriscendobot-garden.md)

> RECOVERED — the watchdog condition `comment-ack-latency-kriscendobot-garden` has CLEARED (first seen 2026-10-09T03:57:24Z, cleared 2026-10-09T04:02:13Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Comment acknowledgment condition cleared.

- `watchdog-budget-zone-endolin-garden2-5bcdff64-backoff` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden2-5bcdff64-backoff.md)

> subscription claude-endolin2 changed zone ok -> backoff at spend=207858888/168000000.

- `watchdog-journal-fetch-slow-_home_kris_garden2__garden_state_bulletin_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_home_kris_garden2__garden_state_bulletin_journal.md)

> RECOVERED — the watchdog condition `journal-fetch-slow-_home_kris_garden2__garden_state_bulletin_journal` has CLEARED (first seen 2026-10-09T05:59:29Z, cleared 2026-10-09T07:38:14Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-fetch-slow-_home_kris_garden2__garden_state_bulletin_journal` cleared on endolin-garden2-5bcdff64.

- `watchdog-journal-worktree-stale-endolin-garden-ece02cb4` — from watchdog:journal-worktree-keeper, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-worktree-stale-endolin-garden-ece02cb4.md)

> journal worktree /home/kris/garden/journal has been STALE for ~2h (8998s since it last reconciled to origin/journal2; threshold 7200s). The keeper cannot self-resolve it: this tick could not reconcile — diverged; self-heal did not reach origin tip this tick (behind=139). Agents landing in journal/ are reading a LAGGED board and must route around it by hand. Investigate: check this host's connectivity to the journal remote, then 'git -C /home/kris/garden/journal status' and the journal-worktree-keeper log. This is one alert per staleness episode — it will NOT re-page, and clears automatically once the worktree reconciles. (host=endolin-garden-ece02cb4)

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-1.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-10-06T09:36:04Z, latest 2026-10-09T05:35:27Z).
> The SAME condition (`budget-level-cleric-endolin-garden-ece02cb4-1`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> budget-level changed endolin-garden-ece02cb4 cleric workers 2 -> 1 (target 1): shared codex subscription demand active=2 queue=9 quota=backoff fleet-envelope=4 target=1

- `watchdog-budget-level-monk-endolin-garden-ece02cb4-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-endolin-garden-ece02cb4-2.md)

> budget-level changed endolin-garden-ece02cb4 monk workers 1 -> 2 (target 4): subscription claude-endolin1 spend=1445685 cap=271000000 pace-bias=0 window-start=2026-10-10T03:00Z(calendar) deadline=2026-10-17T03:00Z(calendar) ceiling=4 backoff=0.5010(ramp) target=4

- `orch-jev-triage-foreman-child-trial-jev-triage-foreman-classification-failed` — from orchestrator:orch-jev-triage-foreman-child-trial-jev-triage-foreman-classification-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/orch-jev-triage-foreman-child-trial-jev-triage-foreman-classification-failed.md)

> orchestration-event: orchestration-child-failure
> orchestration: orch-jev-triage-foreman
> orchestration-status: running
> child: trial-jev-triage-foreman-classification
> failure-kind: gated-outcome-unsatisfied
> order: serial
> on-child-failure: halt
> detail: completed but declared its gated outcome unsatisfied
>
> Orchestration orch-jev-triage-foreman observed child trial-jev-triage-foreman-classification: completed but declared its gated outcome unsatisfied.

- `msg-fix-sysop-ack-timeout-1a94daae1257` — from gardener:fix-sysop-ack-timeout, reply_to `fix-sysop-ack-timeout` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-fix-sysop-ack-timeout-1a94daae1257.md)

> fix-sysop-ack-timeout landed on main2 as 96a2b4c6141 (the sysop spools and marks seen right after apply, writes records in one batch per tick, bounds restore's steps; budget-level skips re-sending a duplicate unacked set-workers). Remaining manual step, which can't be done from endolin: once oros-studio-garden-ce242c49 has deployed 96a2b4c6141, remove the temporary drop-in there:
>   rm ~/.config/systemd/user/garden-sysop.service.d/zz-liaison-temp-timeout.conf && systemctl --user daemon-reload
> The sysop vocabulary has no op that can remove it remotely.

- `review-docket-20261008-child-review-docket-consolidate-20261008-failed` — from orchestrator:review-docket-20261008-child-review-docket-consolidate-20261008-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/review-docket-20261008-child-review-docket-consolidate-20261008-failed.md)

> orchestration-event: orchestration-child-failure
> orchestration: review-docket-20261008
> orchestration-status: running
> child: review-docket-consolidate-20261008
> failure-kind: doomed
> order: serial
> on-child-failure: halt
> detail: doomed and held in plan
>
> Orchestration review-docket-20261008 observed child review-docket-consolidate-20261008: doomed and held in plan.

- `watchdog-worker-derotate-oros-studio-garden-ce242c49` — from watchdog:worker-derotate, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-worker-derotate-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `worker-derotate-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-10-09T00:20:13Z, cleared 2026-10-09T21:20:12Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> heartbeat resumed for oros-studio-garden-ce242c49 (heartbeat fresh (458s old; sampled_at_epoch=1791580347)); it is PRESENT again and its config/worker-leveling caps are restored to 8 0 (monk cleric), so budget-level will apportion it workers again. (leader=endolin-garden2-5bcdff64)

- `watchdog-comment-watcher-stuck-cooldown-host` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-watcher-stuck-cooldown-host.md)

> RECOVERED — the watchdog condition `comment-watcher-stuck-cooldown-host` has CLEARED (first seen 2026-10-09T18:02:55Z, cleared 2026-10-10T02:08:17Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Comment acknowledgment condition cleared.

- `20261009T111207Z-dff0cb` — from triager:kriscendobot-minion.town, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261009T111207Z-dff0cb.md)

> kind: error
>
> # triage circuit-breaker OPENED for `kriscendobot-minion.town`
>
> The triage handler (`/home/kris/garden2/scripts/jobs/handlers/triager-claude.sh`) FAILED 5 consecutive times on the SAME change
> and hit the threshold (`GARDEN_TRIAGE_FAIL_THRESHOLD=5`).
>
> - Repo slug: `kriscendobot-minion.town`  (watched ref `main`)
> - Failing range: `c5a0ae6367460b8f038d7c873289493126115f9d` → `c9a073cc04434094112d64a18ce8ae8006763a14`
>
> Because the transition is deterministic (same old→new SHAs, same diff), retrying
> cannot help — it only crash-loops the `garden-triager@kriscendobot-minion.town` unit and fills the
> journal. The breaker is now OPEN: this sha will NOT be re-triaged until a NEW
> change appears on `kriscendobot-minion.town:main`, which clears the breaker automatically.
>
> Investigate the handler failure (reproduce by hand:
> `/home/kris/garden2/scripts/jobs/handlers/triager-claude.sh kriscendobot-minion.town c5a0ae6367460b8f038d7c873289493126115f9d c9a073cc04434094112d64a18ce8ae8006763a14 <bare>`), or, if this repo should not be watched
> at all, remove it from the watch set. Note: under CLAUDE.md § Monitoring safety
> constraint only `endojs/endo-but-for-bots` is currently authorized for watching —
> worth confirming `kriscendobot-minion.town` belongs in the set.

- `orch-minion-town-oauth-bonds-halted` — from orchestrator:orch-minion-town-oauth-bonds-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/orch-minion-town-oauth-bonds-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: orch-minion-town-oauth-bonds
> orchestration-status: halted
> child: build-minion-town-oauth-bonds
> failure-kind: gated-outcome-unsatisfied
> children-completed: 1
> children-total: 2
> halt-parked-remainder: 
>
> Orchestration orch-minion-town-oauth-bonds HALTED: child build-minion-town-oauth-bonds completed but declared its gated outcome unsatisfied (serial, on-child-failure=halt). 1/2 done before halt; parked remainder: none

- `watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-canary-failed-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-10-09T07:56:09Z, cleared 2026-10-10T10:02:08Z).
> It was observed 3 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> retrying canary oros-studio-garden-ce242c49 (attempt 1/3); clearing prior page.

- `followup-gate-review-improve-design-bespoke-mechanism-over-existing-path` — from followup-gate:review-improve-design-bespoke-mechanism-over-existing-path, reply_to `review-improve-design-bespoke-mechanism-over-existing-path` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/followup-gate-review-improve-design-bespoke-mechanism-over-existing-path.md)

> Job "review-improve-design-bespoke-mechanism-over-existing-path" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.
>
> ## Follow-ups
> - Neither check has run on a live panel yet; the first code PR that adds a socket or formula type will be the first real exercise.

- `orch-minion-town-oauth-bonds-child-build-minion-town-oauth-bonds-failed` — from orchestrator:orch-minion-town-oauth-bonds-child-build-minion-town-oauth-bonds-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/orch-minion-town-oauth-bonds-child-build-minion-town-oauth-bonds-failed.md)

> orchestration-event: orchestration-child-failure
> orchestration: orch-minion-town-oauth-bonds
> orchestration-status: running
> child: build-minion-town-oauth-bonds
> failure-kind: gated-outcome-unsatisfied
> order: serial
> on-child-failure: halt
> detail: completed but declared its gated outcome unsatisfied
>
> Orchestration orch-minion-town-oauth-bonds observed child build-minion-town-oauth-bonds: completed but declared its gated outcome unsatisfied.

- `watchdog-namespace-clone-packs-oros-studio-garden-ce242c49` — from watchdog:self-heal, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-namespace-clone-packs-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `namespace-clone-packs-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-10-10T02:43:50Z, cleared 2026-10-10T04:41:19Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Per-namespace journal clones on oros-studio-garden-ce242c49 are back under the 50-pack threshold.

- `kriscendobot-minion.town-pr174-gauntlet-review-budget-reached` — from gauntlet:kriscendobot-minion.town-pr174-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/kriscendobot-minion.town-pr174-gauntlet-review-budget-reached.md)

> Gauntlet kriscendobot-minion.town-pr174-gauntlet REVIEW-BUDGET-REACHED: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision. To grant more rounds: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr174-gauntlet panel --add-rounds N
>
> Unaddressed must-fix: unknown · list unavailable (panel report has no structured must-fix list) · rounds spent: 6/6 · cost so far: $12.30
>
> To add budget and resume: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr174-gauntlet panel --add-rounds 2
> --add-rounds 2 grants 2 more panel/fix round(s): max_iterations 6 -> 8 (N is yours to choose).

- `watchdog-rolling-deploy-host-offline-endolin-garden2-5bcdff64` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-host-offline-endolin-garden2-5bcdff64.md)

> WATCHDOG notice — occurrence #123 (first seen 2026-10-10T04:05:32Z, latest 2026-10-10T10:11:02Z).
> The SAME condition (`rolling-deploy-host-offline-endolin-garden2-5bcdff64`) has now been observed 123 times; this is ONE
> coalesced notice that updates in place, not 123 messages. Latest detail:
>
> Host endolin-garden2-5bcdff64 is OFFLINE: heartbeat stale by 23865s (offline threshold 1800s; sampled_at_epoch=1791603197).
> The authority is budget/live/<pool>/endolin-garden2-5bcdff64, refreshed periodically; fleet/health/endolin-garden2-5bcdff64 is
> not a heartbeat and was intentionally ignored. Rolling deploy will SKIP this peer:
> no release token, deploy budget, failed-canary count, or halt. Restore the host and
> its heartbeat to rejoin automatically. If hosts/endolin-garden2-5bcdff64 was archived, unarchive it as a
> separate operator decision; this watchdog never reverses decommissioning. (leader=endolin-garden-ece02cb4)

- `minion-town-ci-runner-unblock-20261008-terminal-complete` — from orchestrator:minion-town-ci-runner-unblock-20261008-terminal-complete, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/minion-town-ci-runner-unblock-20261008-terminal-complete.md)

> orchestration-event: orchestration-terminal
> orchestration: minion-town-ci-runner-unblock-20261008
> orchestration-status: complete
> order: serial
> children-total: 3
> children-failed: 0
> failed-children: 
> recovered-children: 
>
> Orchestration minion-town-ci-runner-unblock-20261008 complete (serial): all 3 children reached tada without a machine-readable failure declaration.

- `msg-scholar-ingest-source-awesome-ocap-petnames-remainder-1380ef14b3c4` — from scholar:scholar-ingest-source-awesome-ocap-petnames-remainder, reply_to `scholar-ingest-source-awesome-ocap-petnames-remainder` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-scholar-ingest-source-awesome-ocap-petnames-remainder-1380ef14b3c4.md)

> Finished the PetNames reference walk: ingested the 2022 Spritely paper, Tyler Close's 2005 browser paper, Bill Frantz's 2000 reply, and the recovered Walnut section as five library sections. The DCF demo and Endo 2.0.0–2.3.0 changelog add no petname behavior beyond the existing Endo source corpus; the two linked issues are unanswered discussion stubs rather than authoritative sources. Jev remained unavailable because `TYPESAFE_API_KEY` is absent, and every ingested source records that caveat. Full result: `entries/2026/10/08/204736Z-result-scholar-626da7.md`.

- `minion-town-ci-runner-redeploy-50aa690-split-terminal-complete` — from orchestrator:minion-town-ci-runner-redeploy-50aa690-split-terminal-complete, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/minion-town-ci-runner-redeploy-50aa690-split-terminal-complete.md)

> orchestration-event: orchestration-terminal
> orchestration: minion-town-ci-runner-redeploy-50aa690-split
> orchestration-status: complete
> order: serial
> children-total: 3
> children-failed: 0
> failed-children: 
> recovered-children: 
>
> Orchestration minion-town-ci-runner-redeploy-50aa690-split complete (serial): all 3 children reached tada without a machine-readable failure declaration.

- `watchdog-journal-fetch-slow-_home_kris_garden__garden_state_bulletin_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_home_kris_garden__garden_state_bulletin_journal.md)

> Journal fetch anomaly on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=1.563916s max=32.990503s; hard guard=31.500000s (70% of 45s cap); remedy=applied.

- `watchdog-journal-fetch-slow-_home_kris_garden2__garden_state_monks_1_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-fetch-slow-_home_kris_garden2__garden_state_monks_1_journal.md)

> RECOVERED — the watchdog condition `journal-fetch-slow-_home_kris_garden2__garden_state_monks_1_journal` has CLEARED (first seen 2026-10-09T02:59:30Z, cleared 2026-10-09T07:09:14Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-fetch-slow-_home_kris_garden2__garden_state_monks_1_journal` cleared on endolin-garden2-5bcdff64.

- `watchdog-budget-level-monk-oros-studio-garden-ce242c49-4` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-oros-studio-garden-ce242c49-4.md)

> WATCHDOG notice — occurrence #4 (first seen 2026-10-08T17:50:19Z, latest 2026-10-08T21:50:28Z).
> The SAME condition (`budget-level-monk-oros-studio-garden-ce242c49-4`) has now been observed 4 times; this is ONE
> coalesced notice that updates in place, not 4 messages. Latest detail:
>
> budget-level changed oros-studio-garden-ce242c49 monk workers 3 -> 4 (target 4): subscription claude-oros spend=3558506 cap=180000000 pace-bias=0.423764 window-start=2026-10-06T10:00Z(calendar) deadline=2026-10-13T10:00Z(calendar) ceiling=4 backoff=0.6781(ramp) target=4

- `moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-halted` — from orchestrator:moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: moddable-10-0-0-ironhorse-port-plan-20261009-split-resume
> orchestration-status: halted
> child: moddable-10-0-0-ironhorse-audit-20261009
> failure-kind: handler-timeout
> children-completed: 0
> children-total: 2
> halt-parked-remainder: moddable-10-0-0-ironhorse-port-plan-synthesis-20261009
>
> Orchestration moddable-10-0-0-ironhorse-port-plan-20261009-split-resume HALTED: child moddable-10-0-0-ironhorse-audit-20261009 stalled in flight for 2583s on host oros-studio-garden-ce242c49 (handler-timeout=2400s, multiplier=1) (serial, on-child-failure=halt). 0/2 done before halt; parked remainder: moddable-10-0-0-ironhorse-port-plan-synthesis-20261009

- `doomed-review-docket-consolidate-20261008-requeue-exhausted` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-review-docket-consolidate-20261008-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden2-5bcdff64.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/review-docket-consolidate-20261008; it stays HELD until a human promotes it
> (promote-plan.sh review-docket-consolidate-20261008) or removes it, so nothing is lost.
> Original job base: review-docket-consolidate-20261008
>
> --- original job body ---
> ---
> role: fixer
> tier: mentor
> arc: garden-upkeep
> ---
> <!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-08T05:21:39Z cleared=none -->
>
> ---
> role: fixer
> tier: mentor
> fallback-tier: minion
> arc: garden-upkeep
> dispatch: automatic
> ---
> **Role: fixer.** Child 3/3 of orchestration `review-docket-20261008`: **migrate everything onto the review docket and tell the maintainer.** Wait until child 2's build is DEPLOYED on the leader: check the leader's `fleet/deployed/<leader>` sha contains it. If it isn't deployed yet, exit for retry without changing anything.
>
> **Maintainer directive (kriskowal, liaison session 2026-10-08), verbatim:**
> > I think we instead need a more sophisticated system for surfacing the review inbox. I think this means having automation that either intercepts review requests or a dedicated inbox to which review requests get dispatched, such that receiving a review automatically drops the review from the review board, and also that each additional review request triggers recreation of a summary document of all review requests prioritized according to the garden's priorities and milestones, such that reviews unblock the foreman. We can reuse the priorities designated for the accountant. It may be that this shared document between this "secretary" (or more thematic role name) and the accountant should be more prominent, at the root of the journal. Please post a job to organize this effort and consolidate the existing review requests accordingly. Send the maintainer a message with the resulting review priorities document URL. This should replace all prior review priorities documents in the journal. Prior documents should be consolidated and archived. We can create a document priorities archive indexed by date, for future reference.
>
> **Why now:** at 2026-10-08T03:50Z the proxy's PR-comment auto-clear (`scripts/jobs/proxy.sh` § 1c; directive kriskowal 2026-07-11) archived 49 maintainer messages in journal commit `b3c8be85227`, including **26 `review-request-*` messages** a muster had just produced, and minion.town#169's request. A review request is not a dismissable PR notice. Today a request lives as one inbox message among hundreds, and nothing reorders it as priorities change or retires it when the review happens.
>
> **Existing artifacts to supersede and consolidate:**
> - journal `projects/garden/review-priorities.md` (hand-curated; last edit 2026-10-06)
> - journal `pr-review-sequence.md` (journal root)
> - journal `reports/maintainer-priorities-2026-09-28.md`
> - the accountant's priorities: `config/apportionment` and `config/foreman-mandate` (arcs, ranks, milestones; designs/accountant-arc-apportionment.md). **Reuse these as the ordering source.** Don't invent a second priority scheme.
> - the `review-request-*` messages (in `inbox/maintainer/read/` since `b3c8be85227`)
> - `stale-panel-head-*` and `*-review-budget-reached` notices
> - the readiness audit (`scripts/jobs/design-pr-gauntlet-coverage-audit.sh`)
>
> **Steps:**
> 1. **Consolidate the existing review requests** into the docket through its intake. This includes every `review-request-*` that `b3c8be85227` (and later auto-clears) moved to `inbox/maintainer/read/`, plus live `stale-panel-head-*` and `*-review-budget-reached` items, and minion.town#169's request.
>    - Re-verify each PR's live state first. Don't docket a PR that merged, closed, or already has the maintainer's review on its current head.
>    - Make sure each entry ends up in exactly one place: archive any maintainer-inbox copy that the docket now owns.
> 2. **Fold in** `projects/garden/review-priorities.md`, `pr-review-sequence.md` and `reports/maintainer-priorities-2026-09-28.md`: carry forward any still-live ordering intent or notes.
>    - Then **archive** each into the date-indexed priorities archive (dated by its last edit), and replace the original path with a one-line pointer to the new root document, or remove it per the design.
> 3. Regenerate the root priorities/docket document and check that its ordering follows `config/apportionment`/`config/foreman-mandate` and what each item unblocks.
> 4. **Send ONE maintainer message** (`send-msg.sh maintainer`, key `review-docket-live`) with the **full GitHub URL** of the root document on journal2 (`https://github.com/kriscendobot/garden/blob/journal2/<path>`). Include counts per arc, the top 5 reviews and what each unblocks, and the archive index URL.

- `watchdog-provider-quota` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-provider-quota.md)

> provider weekly limit reached: the API is refusing calls fleet-wide (resets 3am (UTC) — the responder could NOT diagnose garden-triager@kriscendobot-minion).
> limit_type: weekly
> This is an ACCOUNT LIMIT, not a garden defect: no code fix applies, and the fleet
> resumes on its own once the window resets (see skills/restore/SKILL.md for the
> post-outage restore). Every unit that trips the limit folds into THIS one notice
> rather than filing its own. Latest observation (originally keyed 'provider-quota', host endolin-garden2-5bcdff64):
> provider quota exceeded while running garden-triager@kriscendobot-minion.town. Observed: You've hit your weekly limit · resets 3am (UTC) — the responder could NOT diagnose garden-triager@kriscendobot-minion.town (rc=1); its capture is blob 4421fe70430212905f5469a14f22e0d832992939 (git -C /home/kris/garden2/.garden-state/self-heal/journal cat-file -p 4421fe70430212905f5469a14f22e0d832992939).

- `moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-child-moddable-10-0-0-ironhorse-audit-20261009-failed` — from orchestrator:moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-child-moddable-10-0-0-ironhorse-audit-20261009-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/moddable-10-0-0-ironhorse-port-plan-20261009-split-resume-child-moddable-10-0-0-ironhorse-audit-20261009-failed.md)

> orchestration-event: orchestration-child-timeout
> orchestration: moddable-10-0-0-ironhorse-port-plan-20261009-split-resume
> orchestration-status: running
> child: moddable-10-0-0-ironhorse-audit-20261009
> failure-kind: handler-timeout
> order: serial
> on-child-failure: halt
> detail: stalled in flight for 2583s on host oros-studio-garden-ce242c49 (handler-timeout=2400s, multiplier=1)
>
> Orchestration moddable-10-0-0-ironhorse-port-plan-20261009-split-resume observed child moddable-10-0-0-ironhorse-audit-20261009: stalled in flight for 2583s on host oros-studio-garden-ce242c49 (handler-timeout=2400s, multiplier=1).

- `review-docket-20261008-halted` — from orchestrator:review-docket-20261008-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/review-docket-20261008-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: review-docket-20261008
> orchestration-status: halted
> child: review-docket-consolidate-20261008
> failure-kind: doomed
> children-completed: 2
> children-total: 3
> halt-parked-remainder: 
>
> Orchestration review-docket-20261008 HALTED: child review-docket-consolidate-20261008 doomed and held in plan (serial, on-child-failure=halt). 2/3 done before halt; parked remainder: none

- `orch-jev-triage-foreman-halted` — from orchestrator:orch-jev-triage-foreman-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/orch-jev-triage-foreman-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: orch-jev-triage-foreman
> orchestration-status: halted
> child: trial-jev-triage-foreman-classification
> failure-kind: gated-outcome-unsatisfied
> children-completed: 1
> children-total: 3
> halt-parked-remainder: integrate-jev-triage-foreman
>
> Orchestration orch-jev-triage-foreman HALTED: child trial-jev-triage-foreman-classification completed but declared its gated outcome unsatisfied (serial, on-child-failure=halt). 1/3 done before halt; parked remainder: integrate-jev-triage-foreman

- `gauntlet-mustfix-summary-orch-terminal-complete` — from orchestrator:gauntlet-mustfix-summary-orch-terminal-complete, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/gauntlet-mustfix-summary-orch-terminal-complete.md)

> orchestration-event: orchestration-terminal
> orchestration: gauntlet-mustfix-summary-orch
> orchestration-status: complete
> order: serial
> children-total: 3
> children-failed: 0
> failed-children: 
> recovered-children: 
>
> Orchestration gauntlet-mustfix-summary-orch complete (serial): all 3 children reached tada without a machine-readable failure declaration.

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-1.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-10-06T07:50:51Z, latest 2026-10-09T06:20:24Z).
> The SAME condition (`budget-level-cleric-endolin-garden2-5bcdff64-1`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> budget-level changed endolin-garden2-5bcdff64 cleric workers 2 -> 1 (target 1): shared codex subscription demand active=1 queue=7 quota=backoff fleet-envelope=4 target=1

- `stale-panel-head-endojs-endo-but-for-bots-pr1403-6be2a3cb-7cc7cc3f` — from gardener:claude-on-minion-town-press-20261008-203525, reply_to `claude-on-minion-town-press-20261008-203525` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/stale-panel-head-endojs-endo-but-for-bots-pr1403-6be2a3cb-7cc7cc3f.md)

> COALESCED message — occurrence #2 (first seen 2026-10-08T03:35:42Z, latest 2026-10-09T01:21:25Z).
> The SAME message (episode key `stale-panel-head-endojs-endo-but-for-bots-pr1403-6be2a3cb-7cc7cc3f`) has now been sent 2 times; this is
> ONE entry that updates in place, not 2 messages. Latest detail:
>
> Stale panel coverage for completed job `claude-on-minion-town-press-20261008-203525`: [https://github.com/endojs/endo-but-for-bots/pull/1403](https://github.com/endojs/endo-but-for-bots/pull/1403) moved from panel-reviewed head `6be2a3cbdb78cf3512c01bc74fc2c6c83ba190ea` to presented head `7cc7cc3fe7b6eb17c37326c2ed4d0f754b52c7b0`.
>
> Disposition: **review required**. The earlier panel does not cover the current head; every commit delta is conservatively review-relevant. A PR metadata-only edit would leave the head unchanged and would not trigger this disposition.
>
> No gauntlet was staged. Route the current head through the existing panel stage only after an explicit maintainer `run the gauntlet` request, or make a maintainer review decision with the stale coverage stated explicitly.

- `watchdog-budget-zone-endolin-garden2-5bcdff64-ok` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden2-5bcdff64-ok.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-01T18:30:59Z, latest 2026-10-10T03:03:04Z).
> The SAME condition (`budget-zone-endolin-garden2-5bcdff64-ok`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> subscription claude-endolin2 changed zone backoff -> ok at spend=221200/168000000.

- `followup-gate-review-improve-builder-pr-gauntlet-bypass` — from followup-gate:review-improve-builder-pr-gauntlet-bypass, reply_to `review-improve-builder-pr-gauntlet-bypass` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/followup-gate-review-improve-builder-pr-gauntlet-bypass.md)

> Job "review-improve-builder-pr-gauntlet-bypass" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.
>
> ## Follow-ups
> - The dated re-stage handles one re-review per day per PR. A second held-draft finish on the same day would silently skip the next re-stage until the following day.
> - The local `journal/` checkout was stale: it didn't have the #148 miss record. The producer clone did.

- `minion-town-pr-screening-paused-39867df` — from proxy:screen, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/minion-town-pr-screening-paused-39867df.md)

> minion.town screening PAUSED: merge 39867df7874 of [https://github.com/kriscendobot/minion.town/pull/169](https://github.com/kriscendobot/minion.town/pull/169) broke production (deploy.yml failure). Run: https://github.com/kriscendobot/minion.town/actions/runs/37868510874
> Heal job heal-minion-town-39867df posted; the delegation resumes by itself once a later main deploy succeeds and the watchdog is ok.
> Operations: context/operations/minion-town-screening.md

- `kriscendobot-minion.town-pr171-gauntlet-20261010-review-budget-reached` — from gauntlet:kriscendobot-minion.town-pr171-gauntlet-20261010-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/kriscendobot-minion.town-pr171-gauntlet-20261010-review-budget-reached.md)

> Gauntlet kriscendobot-minion.town-pr171-gauntlet-20261010 REVIEW-BUDGET-REACHED: Applied 2 panel/fix round(s); fix round 2 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=2, so the PR is left improved for a human merge/review decision. To grant more rounds: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr171-gauntlet-20261010 panel --add-rounds N
>
> Unaddressed must-fix: unknown · list unavailable (panel report has no structured must-fix list) · rounds spent: 2/2 · cost so far: $6.06
>
> To add budget and resume: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr171-gauntlet-20261010 panel --add-rounds 2
> --add-rounds 2 grants 2 more panel/fix round(s): max_iterations 2 -> 4 (N is yours to choose).

- `doomed-design-minion-town-ocap-site-crawler-leak-rotation-requeue-exhausted` — from reaper:endolin-garden2-5bcdff64, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-design-minion-town-ocap-site-crawler-leak-rotation-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden2-5bcdff64.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/design-minion-town-ocap-site-crawler-leak-rotation; it stays HELD until a human promotes it
> (promote-plan.sh design-minion-town-ocap-site-crawler-leak-rotation) or removes it, so nothing is lost.
> Original job base: design-minion-town-ocap-site-crawler-leak-rotation
>
> --- original job body ---
> ---
> role: designer
> arc: minion-town-ui
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> # Design: detect a crawler on an ocap.site page as a link-leak signal, and rotate
>
> Repo: https://github.com/kriscendobot/minion.town. Budget: the `minion-town-ui` arc.
>
> ## Maintainer's idea (2026-10-08)
>
> A clip is served at `<hash>.ocap.site` and the URL is a bearer capability. If a crawler bot
> fetches a clip page, that is evidence the link reached the open internet (pasted somewhere
> public, indexed, scraped). That should be detected and the clip's link **rotated
> automatically**. There is not yet a mechanism for rotating a formula identifier; a sibling
> design job on `endojs/endo-but-for-bots`, `design-endo-formula-identifier-indirection`,
> designs that layer. This design must not assume it exists; it must state the interface it
> needs from it and what to do until it lands.
>
> Read first: `designs/ocap-site-clip-isolation.md`, `designs/clip-formula-id-origin-and-content-gc.md`,
> the gateway request path, and the live edge (Caddy) configuration and logs.
>
> ## Sift: direction versus speculation
>
> Open the design with a short section that separates (a) what is established direction from
> (b) what is speculation or unknown. In particular:
>
> - **Direction:** a crawler hit is a leak signal; leak response is automatic rotation of the
>   link; detection must be deterministic code, not an LLM.
> - **Speculation to treat as a question, with evidence before any claim:** that a crawler can
>   be told reliably from a legitimate visitor at all. A user-agent string is forgeable and many
>   scrapers send browser UAs; link previews (chat apps, mail scanners, unfurlers) fetch URLs
>   for legitimate recipients and would cause false rotations; a malicious actor can trigger
>   rotation on purpose (a denial of service on a clip owner). Measure what real traffic to
>   the live edge looks like before proposing thresholds. Do not invent a crawler
>   taxonomy from memory.
>
> ## What the design must settle
>
> 1. **Signals**, ranked by reliability and cost: declared bot user agents against published
>    lists, `robots.txt` fetches (a clip origin's own `robots.txt` as a tripwire), reverse-DNS
>    verified search-engine ranges, request-shape heuristics, first-fetch-from-unexpected
>    geography, honeypot paths. Say which are cheap, which false-positive on link unfurlers,
>    and which an attacker can spoof.
> 2. **Where it lives:** at the Caddy edge, in the gateway, or from log analysis after the fact;
>    what is logged, retention, and privacy (no raw IP retention beyond what the decision
>    needs).
> 3. **Response ladder**, not a single trigger: observe, alert the clip owner, rotate. Define
>    thresholds, a grace window for known unfurlers, per-clip rate limits so a hostile actor
>    cannot force churn, and the owner's ability to pin a clip as public so it is never rotated.
> 4. **Rotation semantics for a user:** what the old link does after rotation (gone, or a
>    tombstone page that says it was rotated), how the owner learns the new link, and what
>    happens to anything that embedded the old link.
> 5. **Dependency on formula-identifier rotation:** state the minimal interface required
>    (`rotate(clip) -> newLocator`, old locator revoked) and a degraded mode for before it
>    exists (for example, republish the clip under a fresh content hash and retire the old
>    origin) with its costs.
> 6. **Acceptance and production check:** tests an automatic production canary can run,
>    including a synthetic crawler hitting a canary clip and the rotation being observed.
>
> Include mermaid flows (no ASCII art) and an `## Ownership map` (edge, gateway, daemon, owner).
> Open the design as a DRAFT PR on `kriscendobot/minion.town`. Under the maintainer's
> 2026-10-07 standing order (journal `entries/2026/10/07/203746Z-message-gardener-a253b1.md`),
> the arc supervisors carry it; do not wait on the maintainer. Genuine forks go in the
> design's `## Open questions`.

- `moddable-10-0-0-xs-source-inventory-20261009-split-terminal-complete` — from orchestrator:moddable-10-0-0-xs-source-inventory-20261009-split-terminal-complete, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/moddable-10-0-0-xs-source-inventory-20261009-split-terminal-complete.md)

> orchestration-event: orchestration-terminal
> orchestration: moddable-10-0-0-xs-source-inventory-20261009-split
> orchestration-status: complete
> order: parallel
> children-total: 3
> children-failed: 0
> failed-children: 
> recovered-children: 
>
> Orchestration moddable-10-0-0-xs-source-inventory-20261009-split complete (parallel): all 3 children reached tada without a machine-readable failure declaration.

- `msg-claude-on-minion-town-completion-press-20261010-002011-f4ef0ba1d489` — from gardener:claude-on-minion-town-completion-press-20261010-002011, reply_to `claude-on-minion-town-completion-press-20261010-002011` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-claude-on-minion-town-completion-press-20261010-002011-f4ef0ba1d489.md)

> claude-on-minion-town-completion-press-20261009-182008 has sat in jobs/doin since its claim at 2026-10-09T18:46:51Z (~5.6h, far past the 2400s default) with no completion; the arc press claude-on-minion-town-press-20261009-185008 has also gone unclaimed in todo for ~5.5h. No arc dooms. Effect: the arc's own oversight is stalling, not its deliverables. I have not touched either job; the reaper owns the requeue.

- `watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #192 (first seen 2026-10-09T06:59:03Z, latest 2026-10-10T10:23:02Z).
> The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 192 times; this is ONE
> coalesced notice that updates in place, not 192 messages. Latest detail:
>
> Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to 61a16d250ef1 20 min ago
> but still reports deployed_sha 44bfcbe6dbf478b6e65b4efdb120f7e8606b1b32. Check garden-self-deploy on oros-studio-garden-ce242c49
> (journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
> keeps it from advancing. The leader does not advance past an undeployed canary.
> (leader=endolin-garden-ece02cb4)

- `moddable-10-0-0-ironhorse-port-plan-20261009-split-child-moddable-10-0-0-xs-source-inventory-20261009-failed` — from orchestrator:moddable-10-0-0-ironhorse-port-plan-20261009-split-child-moddable-10-0-0-xs-source-inventory-20261009-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/moddable-10-0-0-ironhorse-port-plan-20261009-split-child-moddable-10-0-0-xs-source-inventory-20261009-failed.md)

> orchestration-event: orchestration-child-timeout
> orchestration: moddable-10-0-0-ironhorse-port-plan-20261009-split
> orchestration-status: running
> child: moddable-10-0-0-xs-source-inventory-20261009
> failure-kind: handler-timeout
> order: serial
> on-child-failure: halt
> detail: stalled in flight for 2536s on host oros-studio-garden-ce242c49 (handler-timeout=2400s, multiplier=1)
>
> Orchestration moddable-10-0-0-ironhorse-port-plan-20261009-split observed child moddable-10-0-0-xs-source-inventory-20261009: stalled in flight for 2536s on host oros-studio-garden-ce242c49 (handler-timeout=2400s, multiplier=1).

- `moddable-10-0-0-ironhorse-port-plan-20261009-split-halted` — from orchestrator:moddable-10-0-0-ironhorse-port-plan-20261009-split-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/moddable-10-0-0-ironhorse-port-plan-20261009-split-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: moddable-10-0-0-ironhorse-port-plan-20261009-split
> orchestration-status: halted
> child: moddable-10-0-0-xs-source-inventory-20261009
> failure-kind: handler-timeout
> children-completed: 0
> children-total: 3
> halt-parked-remainder: moddable-10-0-0-ironhorse-audit-20261009 moddable-10-0-0-ironhorse-port-plan-synthesis-20261009
>
> Orchestration moddable-10-0-0-ironhorse-port-plan-20261009-split HALTED: child moddable-10-0-0-xs-source-inventory-20261009 stalled in flight for 2536s on host oros-studio-garden-ce242c49 (handler-timeout=2400s, multiplier=1) (serial, on-child-failure=halt). 0/3 done before halt; parked remainder: moddable-10-0-0-ironhorse-audit-20261009 moddable-10-0-0-ironhorse-port-plan-synthesis-20261009

- `watchdog-journal-push-contention-_home_kris_garden2__garden_state_reaper_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-push-contention-_home_kris_garden2__garden_state_reaper_journal.md)

> RECOVERED — the watchdog condition `journal-push-contention-_home_kris_garden2__garden_state_reaper_journal` has CLEARED (first seen 2026-10-09T05:59:34Z, cleared 2026-10-09T06:48:17Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-push-contention-_home_kris_garden2__garden_state_reaper_journal` cleared on endolin-garden2-5bcdff64.


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 49.6M | $222.24 _(notional, rate-card)_ | 18% of 271.0M (ok) |
| Codex | 510.6k _(+15.0M cached)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 73% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 100848717 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 11.375537s/45s (/home/kris/garden/.garden-state/dependabotany-preflight/journal); 7 open notice(s); checker healthy

## Board
### todo (8)
- [`endojs-endo-but-for-bots-pr1427-gauntlet-undraft`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1427-gauntlet-undraft.md) — Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1427
- [`endojs-endo-but-for-bots-pr1435-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1435-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1435
- [`kriscendobot-minion.town-pr174-gauntlet-panel-7`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/kriscendobot-minion.town-pr174-gauntlet-panel-7.md) — Gauntlet stage: PANEL round 7 — kriscendobot/minion.town PR #174
- [`oros-health-watch-20261010-102009`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-watch-20261010-102009.md) — ---
- [`minion-town-arc-press-20261010-062006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/minion-town-arc-press-20261010-062006.md) — Supervise the minion.town arc: carry its pull requests through review
- [`endojs-endo-but-for-bots-pr1355-gauntlet-20261007-undraft`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1355-gauntlet-20261007-undraft.md) — Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1355
- [`endojs-endo-but-for-bots-pr1381-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1381-gauntlet-plan-20261007.md) — ---
- [`kriscendobot-minion.town-pr166-gauntlet-20261010-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/kriscendobot-minion.town-pr166-gauntlet-20261010-panel-3.md) — Gauntlet stage: PANEL round 3 — kriscendobot/minion.town PR #166

### doin (3)
- [`kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — kriscendobot/minion.town PR #171
- [`endojs-endo-but-for-bots-pr1403-gauntlet-20261007-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1403-gauntlet-20261007-panel-4.md) — Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1403
- [`kriscendobot-minion-town-pr94-screen-6098638b-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/kriscendobot-minion-town-pr94-screen-6098638b-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — kriscendobot/minion.town PR #94

### tada (12129)
- [`kriscendobot-minion.town-pr93-gauntlet-20261010-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/10/kriscendobot-minion.town-pr93-gauntlet-20261010-clean.md) — Cost
- [`claude-on-minion-town-press-20261010-102009`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/10/claude-on-minion-town-press-20261010-102009.md) — Panel-head freshness
- [`endojs-endo-but-for-bots-pr1403-gauntlet-20261007-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/10/endojs-endo-but-for-bots-pr1403-gauntlet-20261007-fix-3.md) — Cost
- [`kriscendobot-minion.town-pr174-gauntlet-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/10/kriscendobot-minion.town-pr174-gauntlet-fix-5.md) — Cost
- [`kriscendobot-minion.town-pr174-gauntlet-fix-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/10/kriscendobot-minion.town-pr174-gauntlet-fix-6.md) — Cost
- … and 12124 more

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
- [`kriscendobot-minion.town-pr94-gauntlet-20261008-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr94-gauntlet-20261008-fix-2.md) — _normal_ · Gauntlet stage: FIX round 2 — kriscendobot/minion.town PR #94
- [`moddable-10-0-0-ironhorse-callability-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-callability-port.md) — _normal_ · Port revoked-Proxy callability and constructability to IronHorse
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source.md) — _normal_ · Build: SES import attributes — Phase 2 (module-source static with capture)
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`design-minion-town-ocap-site-crawler-leak-rotation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-minion-town-ocap-site-crawler-leak-rotation.md) — _normal_ · Design: detect a crawler on an ocap.site page as a link-leak signal, and rotate
- [`endojs-endo-but-for-bots-pr1416-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1416-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1416
- [`weave-minion-town-pr93-20261009`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-minion-town-pr93-20261009.md) — _normal_ · weave kriscendobot/minion.town #93
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
- [`evaluate-reauth-escalation-default-after-oauth-relay-20260927`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/evaluate-reauth-escalation-default-after-oauth-relay-20260927.md) — _low_ · Evaluate default reauth escalation once the browser OAuth relay lands
- [`ironhorse-immutable-arraybuffer`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-immutable-arraybuffer.md) — _normal_ · IronHorse: implement Immutable ArrayBuffer and enable it in the oracle
- [`build-confined-application-makers-p2-20261002`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-confined-application-makers-p2-20261002.md) — _normal_ · Phase 2: daemon capture for node-modules-with-map and node-modules-scan layou...
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`endojs-endo-but-for-bots-pr1340-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1340-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1340
- [`endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper.md) — _normal_ · Build: SES import attributes — Phase 3 (compartment-mapper plumbing)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`moddable-10-0-0-ironhorse-builtins-order-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-builtins-order-port.md) — _normal_ · Port three Moddable 10.0.0 built-in ordering corrections to IronHorse
- [`kriscendobot-minion.town-pr130-gauntlet-20261007-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr130-gauntlet-20261007-viability.md) — _normal_ · Gauntlet stage: PRE-SPEND VIABILITY - kriscendobot/minion.town PR #130
- [`build-claude-usage-dashboard-scraper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-claude-usage-dashboard-scraper.md) — _normal_ · ---
- [`kriscendobot-minion-town-pr153-screen-0f485240-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr153-screen-0f485240-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — kriscendobot/minion.town PR #153
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
- [`endojs-endo-but-for-bots-pr249-address-review-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr249-address-review-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr266-address-review-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr266-address-review-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr283-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr283-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr289-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr289-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr305-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr305-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr306-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr306-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr311-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr311-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr318-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr318-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr319-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr319-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr320-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr320-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr321-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr321-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr322-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr322-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr324-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr324-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr344-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr344-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr346-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr346-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr348-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr348-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr350-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr350-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr353-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr353-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr356-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr356-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr357-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr357-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr359-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr359-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr360-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr360-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr389-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr389-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr508-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr508-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr546-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr546-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr554-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr554-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr555-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr555-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr599-address-review-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr599-address-review-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr762-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr762-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr764-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr764-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr779-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr779-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr825-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr825-gauntlet-plan-20261007.md) — _normal_ · ---
- [`kriscendobot-endo-pr2-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-endo-pr2-gauntlet-plan-20261007.md) — _normal_ · ---
- [`kriscendobot-finbot-pr7-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-finbot-pr7-gauntlet-plan-20261007.md) — _normal_ · ---
- [`kriscendobot-minion.town-pr37-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr37-gauntlet-plan-20261007.md) — _normal_ · ---
- [`kriscendobot-vattr97-pr1-gauntlet-plan-20261007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-vattr97-pr1-gauntlet-plan-20261007.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1349-review-a794b43f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1349-review-a794b43f-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1349 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1381-review-a6b93d7a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1381-review-a6b93d7a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1381 (primary: endojs-endo-but-...
- [`endojs-endo-but-for-bots-pr1389-review-a7ef9c88-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1389-review-a7ef9c88-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #1389 (primary: endojs-endo-but-...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`ebfb-platform-fs-pet-name-path-only`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-platform-fs-pet-name-path-only.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1390` · ---
- [`endo-minion-town-federation-release-gate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-minion-town-federation-release-gate.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1124` · Gate: reviewed and deployable federation release
- [`verify-ironhorse-press-first-engagement-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ironhorse-press-first-engagement-20260929.md) — awaiting `ironhorse-test262-press-20260929-173306` · Verify the first live Ironhorse foreman-press engagement (successor of activa...
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`regauntlet-ebfb-pr1425-after-zizmor-fix-20261006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/regauntlet-ebfb-pr1425-after-zizmor-fix-20261006.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1427` · ---
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1019` · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`book-hyperlink-references-after-copyedit-20261004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/book-hyperlink-references-after-copyedit-20261004.md) — awaiting `https://github.com/kriscendobot/garden-book/pull/8` · Follow-up: make every reference in Better Code and Gardens an actual hyperlink
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`build-exo-sheets-service`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-sheets-service.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`ironhorse-fuzz-triage-differential_source-efffacee3e2a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-triage-differential_source-efffacee3e2a.md) — awaiting `https://github.com/kriscendobot/garden/issues/91` · Triage 7 Ironhorse fuzz finding(s) for target differential_source

## Watch set
kriscendobot-minion.town kriscendobot-garden-book kriscendobot-cosgov kriscendobot-ocapn kriscendobot-oros-ckm-data-readiness kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot

## Hosts
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 1 monks
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 2 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 7 monks
