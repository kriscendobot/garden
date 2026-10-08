# Garden bulletin

[Current priorities and maintainer review docket](PRIORITIES.md)

_As of 2026-10-08T22:00:36Z_

## Latest

The ci.minion.town runner redeploy orchestration finished cleanly at minion.town `main` `50aa690`. All three of its children completed. The verify child found the Lambda and the host files already in sync, so it redeployed nothing, and its self-test passed with no leftover residue and a single online runner registration.

Two gauntlet stages were claimed: CLEAN on [endo-but-for-bots#1433](https://github.com/endojs/endo-but-for-bots/pull/1433) and PANEL round 1 on [endo-but-for-bots#79](https://github.com/endojs/endo-but-for-bots/pull/79). The oros-studio host dropped out of the canary rotation for about an hour and has recovered on its own.

Three orchestrations have halted and need you:

- **`review-docket-20261008`:** its consolidation child failed both tries, and the reaper is holding it in plan. Promote it or split it.
- **`orch-minion-town-oauth-bonds`:** the build child reported that it did not meet its required outcome.
- **`orch-jev-triage-foreman`:** the trial is blocked because `TYPESAFE_API_KEY` is not provisioned. The scholar's PetNames ingest also ran without Jev for the same reason.

Other decisions in the inbox:

- **ocap.site:** the domain can be transferred from about 2026-10-09 19:55Z. DNSSEC is still broken because the registrar has not published the DS record. You can start the transfer then, or ask the registrar to add the DS record.
- **ERTP:** whether to build Phase 1 of the ERTP credits now, or keep ERTP deferred and treat the minion.town primary phase as complete apart from the charge.
- **[endo-but-for-bots#1403](https://github.com/endojs/endo-but-for-bots/pull/1403):** the panel review does not cover the current head.

## Maintainer review docket

115 open · [ordered priorities and review docket](https://github.com/kriscendobot/garden/blob/journal2/PRIORITIES.md)
## Screened by proxy (minion.town)

Delegation: **active**

- 2026-10-08T07:59:27Z [#169](https://github.com/kriscendobot/minion.town/pull/169) `2ab54e5252a` screened
- 2026-10-08T07:59:27Z [#122](https://github.com/kriscendobot/minion.town/pull/122) `30df78718a4` screened
- 2026-10-08T04:05:39Z [#143](https://github.com/kriscendobot/minion.town/pull/143) merged `76bb27628e9`; deploy [success](https://github.com/kriscendobot/minion.town/actions/runs/37725824969), watchdog ok — validated
- 2026-10-08T04:00:07Z [#143](https://github.com/kriscendobot/minion.town/pull/143) `e0b95d10de8` screened
- 2026-10-08T03:50:52Z [#143](https://github.com/kriscendobot/minion.town/pull/143) `43a1387084e` screened

## Messages to the maintainer

- `msg-ocap-site-dnssec-followup-20261008-df1e9ee7a916` — from gardener:ocap-site-dnssec-followup-20261008, reply_to `ocap-site-dnssec-followup-20261008` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ocap-site-dnssec-followup-20261008-df1e9ee7a916.md)

> ocap.site DNSSEC / transfer follow-up (2026-10-08 01:22Z)
>
> - Transfer eligibility: still UNTRANSFERABLE per `route53domains check-domain-transferability` ("registered recently... wait 60 days").
> - RDAP: registered 2026-08-10T19:55:35Z at Key-Systems LLC, status active. The 60-day window ends ~2026-10-09T19:55Z, so transfer into Route53 Domains should become possible from Friday 2026-10-09 evening UTC (registrar-side locks permitting). It will need a fresh auth code from Key-Systems plus your contact details; I did not attempt it.
> - DNSSEC: Route53 zone Z048672026UQWLGHNEQE0 still SIGNING, but the DS record is STILL UNPUBLISHED at the registrar: RDAP shows delegationSigned=false and there is no DS for ocap.site in the .site zone. The chain of trust stays broken (zone resolves as insecure) until either the transfer completes and Route53 Domains publishes DS, or Key-Systems publishes it some other way (support ticket / API).
>
> Next step is your call: start the transfer after 10-09 19:55Z, or ask the registrar to add the DS.

- `watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-host-offline-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-10-08T20:53:04Z, cleared 2026-10-08T21:47:05Z).
> It was observed 4 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> heartbeat resumed for oros-studio-garden-ce242c49; it is PRESENT again and will automatically rejoin the canary rotation while its hosts/oros-studio-garden-ce242c49 record remains active. Archived records are not unarchived automatically.

- `msg-trial-jev-triage-foreman-classification-af360d7b85fb` — from gardener:trial-jev-triage-foreman-classification, reply_to `trial-jev-triage-foreman-classification` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-trial-jev-triage-foreman-classification-af360d7b85fb.md)

> The Jev triage/foreman trial is blocked because TYPESAFE_API_KEY is absent from the job environment. Please provision the maintainer-owned key for a re-run; per the trial specification I have not searched for or configured a credential.

- `msg-minion-town-arc-press-20261008-002014-648b2208af99` — from gardener:minion-town-arc-press-20261008-002014, reply_to `minion-town-arc-press-20261008-002014` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-arc-press-20261008-002014-648b2208af99.md)

> minion.town arc ([kriscendobot/garden#58](https://github.com/kriscendobot/garden/issues/58)): one decision is needed. The only unchecked primary-phase box is the publish capability's charge to an ERTP account for Minion Town Credits. The publish half is live; the charge still goes through a `0n` stub. `designs/ertp-credits.md` § 7–8 puts the Phase 1 toy (ERTP mechanics with tests, no daemon needed) in a private, non-exported layer of `@endo/gateway` in endojs/endo-but-for-bots, which you review. The July plan deferred all of ERTP. Should I post the Phase 1 build now (an endo-but-for-bots PR for your review, followed by a minion.town wiring PR that replaces the `0n` stub), or keep ERTP deferred and treat the primary phase as complete apart from the charge?

- `followup-gate-improve-design-build-dispatch` — from followup-gate:improve-design-build-dispatch, reply_to `improve-design-build-dispatch` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/followup-gate-improve-design-build-dispatch.md)

> Job "improve-design-build-dispatch" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.
>
> ## Follow-ups
> - `design-minion-town-oauth-bonds` is still in `doin`. A requeue will only pass on its own once this change is deployed to that host. Its build is still owned by `orch-minion-town-oauth-bonds`.
> - This is separate from the existing `DESIGN-BUILD-RECHECK` path in `handlers/follow-up-claude.sh`. That path waits for a cross-referenced build PR to appear and never posts the builder job.

- `msg-minion-town-ci-runner-redeploy-verify-50aa690-d2a7e84df68d` — from gardener:minion-town-ci-runner-redeploy-verify-50aa690, reply_to `minion-town-ci-runner-redeploy-verify-50aa690` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-ci-runner-redeploy-verify-50aa690-d2a7e84df68d.md)

> ci.minion.town validation succeeded at kriscendobot/minion.town main 50aa690f87bab73cadc83eaeb39806b60913f054. Lambda was already byte-for-byte in sync and remained Active/Successful; host files were already in sync, so neither component was redeployed and the host was not rebooted. Fresh SSM observation showed boot 2026-10-08 20:23:32 UTC, service active since 20:23:40 UTC, well beyond the 10-minute window. Selftest: https://github.com/kriscendobot/minion.town/actions/runs/37849209480 — probe and verify passed, verify reported no planted residue (including X11, systemd-private, named volume/container/image, cron, and /run/lock), and the intentional fail job failed as expected. Logs used timestamp-suffixed runners, including ci-minion-town-0fdb85b6-20261008T214954Z for verify and ci-minion-town-0fdb85b6-20261008T215307Z for fail. CI_RUNS_ON is unset, selecting self-hosted. After the prune window the runners API showed exactly one ci-minion-town registration, online with timestamp suffix, and no orphaned/offline registrations. Open operator items: none.

- `watchdog-budget-level-cleric-endolin-garden-ece02cb4-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden-ece02cb4-1.md)

> budget-level changed endolin-garden-ece02cb4 cleric workers 2 -> 1 (target 1): shared codex subscription demand active=4 queue=1 quota=ok fleet-envelope=4 target=1

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

- `msg-ebfb-sturdyref-stack-panel-summary-20261004-e7be3fe398d1` — from gardener:ebfb-sturdyref-stack-panel-summary-20261004, reply_to `ebfb-sturdyref-stack-panel-summary-20261004` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ebfb-sturdyref-stack-panel-summary-20261004-e7be3fe398d1.md)

> SturdyRef stack, layers 3/4/6/7 (endojs/endo-but-for-bots [endojs/endo-but-for-bots#1392](https://github.com/endojs/endo-but-for-bots/issues/1392) → [endojs/endo-but-for-bots#1393](https://github.com/endojs/endo-but-for-bots/issues/1393) → [[endojs/endo-but-for-bots#1394](https://github.com/endojs/endo-but-for-bots/issues/1394) L5] → [endojs/endo-but-for-bots#1396](https://github.com/endojs/endo-but-for-bots/issues/1396) → [endojs/endo-but-for-bots#1397](https://github.com/endojs/endo-but-for-bots/issues/1397)): open panel objections, for a merge decision.
>
> All four PRs are drafts with CI green (33 checks, 0 failing). Each stopped at the 6-round budget. Panel coverage of the latest head: none of the four heads was re-paneled after its last fix push. The unreviewed changes are small and low-risk: [endojs/endo-but-for-bots#1392](https://github.com/endojs/endo-but-for-bots/issues/1392) has 4 commits (re-entrancy guard, dead membrane branch removed, spaces-util render case, wording); [endojs/endo-but-for-bots#1393](https://github.com/endojs/endo-but-for-bots/issues/1393) has about 70 non-test lines (SR type param on Passable, CapTP refuses to export a SturdyRef); [endojs/endo-but-for-bots#1396](https://github.com/endojs/endo-but-for-bots/issues/1396) adds an 8-line JSDoc re-export; [endojs/endo-but-for-bots#1397](https://github.com/endojs/endo-but-for-bots/issues/1397) is docs only.
>
> Stack hygiene comes before any merge. Layers 1 and 2 ([endojs/endo-but-for-bots#774](https://github.com/endojs/endo-but-for-bots/issues/774), [endojs/endo-but-for-bots#1391](https://github.com/endojs/endo-but-for-bots/issues/1391)) are still drafts underneath, and the frozen bases have drifted. [endojs/endo-but-for-bots#1392](https://github.com/endojs/endo-but-for-bots/issues/1392) sits on a stale snapshot of [endojs/endo-but-for-bots#1391](https://github.com/endojs/endo-but-for-bots/issues/1391) (8 commits ahead, 2 rewritten). [endojs/endo-but-for-bots#1393](https://github.com/endojs/endo-but-for-bots/issues/1393) and [endojs/endo-but-for-bots#1394](https://github.com/endojs/endo-but-for-bots/issues/1394) each sit 22 commits behind their predecessor's head. [endojs/endo-but-for-bots#1397](https://github.com/endojs/endo-but-for-bots/issues/1397)'s base is 25 commits behind [endojs/endo-but-for-bots#1396](https://github.com/endojs/endo-but-for-bots/issues/1396) with 6 rewritten. Each layer needs a weave once the one below it lands.
>
> [endojs/endo-but-for-bots#1392](https://github.com/endojs/endo-but-for-bots/issues/1392) L3 pass-style: merge as is.
> - Follow-up: no XS run of the brand check (the deferral is disclosed; this is repo-wide test:xs work).
> - Follow-up: first-wins trust of a correctly shaped fake SturdyRef global installed before the shim. The shape checks bound it; it belongs to load-order/lockdown work.
> - Follow-up (optional small fix): one line in the pass-style changeset warning TS users that adding 'sturdyRef' to PassStyle breaks exhaustive switches.
> - Taste: property tests; the Proxy-global throw changes only the error message; rank-less type is spelled two ways (marshal/patterns).
>
> [endojs/endo-but-for-bots#1393](https://github.com/endojs/endo-but-for-bots/issues/1393) L4 marshal: merge after a retcon.
> - Must-fix (mechanical): about 26 rework commits need regrouping (integrator). Do it together with the weave onto the landed [endojs/endo-but-for-bots#1392](https://github.com/endojs/endo-but-for-bots/issues/1392), and drop the "Layer 4 of 9"/garden-arc text from the body at the same time.
> - Follow-up: stricter $/& slot-index parsing (predates this PR, not exploitable today); XS run; spaces-util render tests.
> - Taste: Pattern excludes SturdyRef only at the top level of the type (runtime rejects it at any depth).
>
> [endojs/endo-but-for-bots#1396](https://github.com/endojs/endo-but-for-bots/issues/1396) L6 captp construct: merge as is, after [endojs/endo-but-for-bots#1394](https://github.com/endojs/endo-but-for-bots/issues/1394).
> - Follow-up (cheap, optional before merge): CTP_DROP still accepts 'l-0' (inert today; one line).
> - Follow-up: the locator is a bare Far with a hand-written argument check, where the house idiom is an exo with an interface guard; required fields can be read through the prototype chain (data is local, not peer-controlled); isByteArray uses instanceof.
> - Taste: SturdyRefData names different shapes in captp and ocapn; extra tests; body length.
>
> [endojs/endo-but-for-bots#1397](https://github.com/endojs/endo-but-for-bots/issues/1397) L7 ocapn enliven: merge as is.
> - The only must-fix from the last round (NonceLocator doc claiming "printable ASCII") was fixed in the docs-only head commit.
> - Follow-up: mint-time byte aliasing (makeSturdyRef keeps the caller's array; predates this PR); string secrets enliven at home but can't cross the wire for non-ASCII (predates this PR); lookupSecretBytes thaw path is unverified on XS (disclosed); add a comment on the narrow RangeError catch.
> - Taste: async wrapper, naming, bare Error.
>
> Which layers can land first: [endojs/endo-but-for-bots#1392](https://github.com/endojs/endo-but-for-bots/issues/1392) lands first, as soon as [endojs/endo-but-for-bots#774](https://github.com/endojs/endo-but-for-bots/issues/774) and [endojs/endo-but-for-bots#1391](https://github.com/endojs/endo-but-for-bots/issues/1391) land. [endojs/endo-but-for-bots#1393](https://github.com/endojs/endo-but-for-bots/issues/1393) follows after the retcon and weave. [endojs/endo-but-for-bots#1396](https://github.com/endojs/endo-but-for-bots/issues/1396) and [endojs/endo-but-for-bots#1397](https://github.com/endojs/endo-but-for-bots/issues/1397) have no code blockers, but they wait on [endojs/endo-but-for-bots#1394](https://github.com/endojs/endo-but-for-bots/issues/1394) (L5, already un-drafted). No layer needs a redesign, and none needs another full panel; a scoped re-panel of only the post-panel deltas would be optional. No PR was touched and no gauntlet was staged.

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

- `watchdog-budget-level-monk-oros-studio-garden-ce242c49-4` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-oros-studio-garden-ce242c49-4.md)

> WATCHDOG notice — occurrence #4 (first seen 2026-10-08T17:50:19Z, latest 2026-10-08T21:50:28Z).
> The SAME condition (`budget-level-monk-oros-studio-garden-ce242c49-4`) has now been observed 4 times; this is ONE
> coalesced notice that updates in place, not 4 messages. Latest detail:
>
> budget-level changed oros-studio-garden-ce242c49 monk workers 3 -> 4 (target 4): subscription claude-oros spend=3558506 cap=180000000 pace-bias=0.423764 window-start=2026-10-06T10:00Z(calendar) deadline=2026-10-13T10:00Z(calendar) ceiling=4 backoff=0.6781(ramp) target=4

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

- `watchdog-budget-level-cleric-endolin-garden2-5bcdff64-1` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-cleric-endolin-garden2-5bcdff64-1.md)

> budget-level changed endolin-garden2-5bcdff64 cleric workers 2 -> 1 (target 1): shared codex subscription demand active=2 queue=1 quota=backoff fleet-envelope=4 target=1

- `stale-panel-head-endojs-endo-but-for-bots-pr1403-6be2a3cb-7cc7cc3f` — from gardener:claude-on-minion-town-press-20261008-023508, reply_to `claude-on-minion-town-press-20261008-023508` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/stale-panel-head-endojs-endo-but-for-bots-pr1403-6be2a3cb-7cc7cc3f.md)

> Stale panel coverage for completed job `claude-on-minion-town-press-20261008-023508`: [https://github.com/endojs/endo-but-for-bots/pull/1403](https://github.com/endojs/endo-but-for-bots/pull/1403) moved from panel-reviewed head `6be2a3cbdb78cf3512c01bc74fc2c6c83ba190ea` to presented head `7cc7cc3fe7b6eb17c37326c2ed4d0f754b52c7b0`.
>
> Disposition: **review required**. The earlier panel does not cover the current head; every commit delta is conservatively review-relevant. A PR metadata-only edit would leave the head unchanged and would not trigger this disposition.
>
> No gauntlet was staged. Route the current head through the existing panel stage only after an explicit maintainer `run the gauntlet` request, or make a maintainer review decision with the stale coverage stated explicitly.

- `followup-gate-review-improve-builder-pr-gauntlet-bypass` — from followup-gate:review-improve-builder-pr-gauntlet-bypass, reply_to `review-improve-builder-pr-gauntlet-bypass` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/followup-gate-review-improve-builder-pr-gauntlet-bypass.md)

> Job "review-improve-builder-pr-gauntlet-bypass" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.
>
> ## Follow-ups
> - The dated re-stage handles one re-review per day per PR. A second held-draft finish on the same day would silently skip the next re-stage until the following day.
> - The local `journal/` checkout was stale: it didn't have the #148 miss record. The producer clone did.

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


## Spend & quota
_Since claude-endolin2 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 178.1M | $1256.42 _(notional, rate-card)_ | 106% of 168.0M (backoff) |
| Codex | 18.3M _(fleet aggregate)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 62% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 126292453 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 6.018907s/45s (/home/kris/garden2/.garden-state/transcripts/journal); 4 open notice(s); checker healthy

## Board
### todo (7)
- [`oros-health-watch-20261008-203525`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-watch-20261008-203525.md) — ---
- [`kriscendobot-minion.town-pr173-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/kriscendobot-minion.town-pr173-gauntlet-clean.md) — Gauntlet stage: CLEAN — kriscendobot/minion.town PR #173
- [`endojs-endo-but-for-bots-pr1379-post-panel-r5-verdict`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1379-post-panel-r5-verdict.md) — Post the gauntlet panel round-5 verdict on endojs/endo-but-for-bots#1379
- [`endojs-endo-but-for-bots-pr1434-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1434-gauntlet-viability.md) — Gauntlet stage: PRE-SPEND VIABILITY - endojs/endo-but-for-bots PR #1434
- [`kriscendobot-minion-town-pr94-screen-269fdc5d-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/kriscendobot-minion-town-pr94-screen-269fdc5d-gauntlet-viability.md) — Gauntlet stage: PRE-SPEND VIABILITY - kriscendobot/minion.town PR #94
- [`claude-on-minion-town-press-20261008-203525`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/claude-on-minion-town-press-20261008-203525.md) — Press the Claude-on-minion.town arc forward
- [`endojs-endo-but-for-bots-pr1379-gauntlet-20261007-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1379-gauntlet-20261007-fix-5.md) — Gauntlet stage: FIX round 5 — endojs/endo-but-for-bots PR #1379

### doin (3)
- [`endojs-endo-but-for-bots-pr79-gauntlet-20261007-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr79-gauntlet-20261007-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #79
- [`minion-town-billing-parked-prs-resume-20261008`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/minion-town-billing-parked-prs-resume-20261008.md) — Unpark the minion.town PRs blocked by Actions billing, onto ci.minion.town
- [`endojs-endo-but-for-bots-pr1433-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/endojs-endo-but-for-bots-pr1433-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1433

### tada (11858)
- [`minion-town-ci-runner-redeploy-50aa690-split`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/08/minion-town-ci-runner-redeploy-50aa690-split.md) — orchestration minion-town-ci-runner-redeploy-50aa690-split — complete
- [`minion-town-ci-runner-redeploy-verify-50aa690`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/08/minion-town-ci-runner-redeploy-verify-50aa690.md) — Cost
- [`minion-town-ci-runner-host-sync-50aa690`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/08/minion-town-ci-runner-host-sync-50aa690.md) — Cost
- [`kriscendobot-minion.town-pr173-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/08/kriscendobot-minion.town-pr173-gauntlet-viability.md) — Cost
- [`minion-town-ci-runner-lambda-sync-50aa690`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/08/minion-town-ci-runner-lambda-sync-50aa690.md) — Cost
- … and 11853 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`review-docket-consolidate-20261008`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/review-docket-consolidate-20261008.md) — _normal_ · ---
- [`revive-hermit-lane-qwen3.8-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/revive-hermit-lane-qwen3.8-20261001.md) — _normal_ · Revive the local hermit (on-box Ollama) lane, upgraded to qwen3.8
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`make-panel-stage-survive-supervisor-session-exit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/make-panel-stage-survive-supervisor-session-exit.md) — _normal_ · Make panel execution survive supervising agent-session exit
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
- [`open-signup-gate-flip-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`kriscendobot-minion.town-pr94-gauntlet-20261008-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr94-gauntlet-20261008-fix-2.md) — _normal_ · Gauntlet stage: FIX round 2 — kriscendobot/minion.town PR #94
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source.md) — _normal_ · Build: SES import attributes — Phase 2 (module-source static with capture)
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`design-minion-town-ocap-site-crawler-leak-rotation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-minion-town-ocap-site-crawler-leak-rotation.md) — _normal_ · Design: detect a crawler on an ocap.site page as a link-leak signal, and rotate
- [`endojs-endo-but-for-bots-pr1416-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1416-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1416
- [`endojs-endo-but-for-bots-pr1430-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1430-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1430
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
- [`kriscendobot-minion-town-pr148-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr148-gauntlet-viability.md) — _normal_ · Gauntlet stage: PRE-SPEND VIABILITY - kriscendobot/minion.town PR #148
- [`evaluate-reauth-escalation-default-after-oauth-relay-20260927`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/evaluate-reauth-escalation-default-after-oauth-relay-20260927.md) — _low_ · Evaluate default reauth escalation once the browser OAuth relay lands
- [`build-confined-application-makers-p2-20261002`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-confined-application-makers-p2-20261002.md) — _normal_ · Phase 2: daemon capture for node-modules-with-map and node-modules-scan layou...
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`endojs-endo-but-for-bots-pr1340-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1340-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1340
- [`endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper.md) — _normal_ · Build: SES import attributes — Phase 3 (compartment-mapper plumbing)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`build-claude-usage-dashboard-scraper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-claude-usage-dashboard-scraper.md) — _normal_ · ---

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
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 1 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 4 monks
