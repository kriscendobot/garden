# Garden bulletin

_As of 2026-11-06T02:14:42Z_

## Latest

Since the last bulletin, the board mostly turned over its own housekeeping. Twelve parked jobs were withdrawn: the daemon-git-remotes designs and builds (SSH transport, server half, extended transports, phase-six provisioning, transport timing, phase-five contract tests) and the `improve-*` fixes (candidate-gate diagnostic, decision-ledger spool, issue-status budget and trust filter, screening cooldown log spam, transient-retry budget and correlation). Most were re-posted as `-r2` variants. Two muster orchestrations covering them completed, and `-r2` follow-ups are now running. In flight are `design-daemon-git-remotes-ssh-transport-r2`, `improve-candidate-gate-empty-diagnostic-r2`, `improve-gauntlet-notices-to-pr-20261106`, `improve-muster-autoarchive-watchdog-20261106`, and the minion.town arc press. That looks like the maintainer inbox being worked down, which matches the many foreman "rejected (duplicate)" notices.

**Deploy:**
- The rolling-deploy canary on oros is still stuck, with the watchdog at its 489th notice. Oros was released to `dd3e6bc6edf` about 13 hours ago but still reports `2c082b9`.
- The deploy gate rejected the earlier candidate `024425a` on a failing `signal-kill-classifier` test.
- Oros needs someone to read `journalctl --user -u garden-self-deploy`.

**Failures and halts:**
- Four oros health-watch jobs are parked after retries were exhausted on the leader.
- Three orchestrations halted on handler timeouts or unsatisfied gates: `claude-api-build-20261027` (1 of 8 done), `improve-enforce-handler-wall-bound-split` and `orchestrate-build-minion-town-ordered-gutter-20261104`.
- Gauntlets for [minion.town#243](https://github.com/kriscendobot/minion.town/pull/243) and [endo-but-for-bots#1652](https://github.com/endojs/endo-but-for-bots/pull/1652) halted.

**Needs your decision:**
- The Claude-on-minion.town course correction in [endo-but-for-bots#1543](https://github.com/endojs/endo-but-for-bots/issues/1543) gates new arc builds.
- Whether to build a nonce-safe RESUME for ocapn-noise phase four, given [endo-but-for-bots#1487](https://github.com/endojs/endo-but-for-bots/issues/1487).
- Deciding which of the duplicate ironhorse RegExp fixes should land: [#1619](https://github.com/endojs/endo-but-for-bots/issues/1619) or [#1621](https://github.com/endojs/endo-but-for-bots/issues/1621).
- Running `deploy-accounts-store.sh` before merging the settings simplification.

## Maintainer review docket

188 open · [ordered priorities and review docket](https://github.com/kriscendobot/garden/blob/journal2/PRIORITIES.md)
## Screened by proxy (minion.town)

Delegation: **active**

- 2026-11-05T11:53:56Z [#252](https://github.com/kriscendobot/minion.town/pull/252) `755d017997d` screened
- 2026-11-05T11:53:56Z [#250](https://github.com/kriscendobot/minion.town/pull/250) `8060116d7e7` screened
- 2026-11-05T11:53:56Z [#246](https://github.com/kriscendobot/minion.town/pull/246) `93329d9faf0` screened
- 2026-11-05T11:53:56Z [#237](https://github.com/kriscendobot/minion.town/pull/237) `4e2911dff11` screened

## Messages to the maintainer

- `msg-oros-health-watch-20261029-005026-f2a7896d797e` — from gardener:oros-health-watch-20261029-005026, reply_to `oros-health-watch-20261029-005026` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-oros-health-watch-20261029-005026-f2a7896d797e.md)

> oros health watch: oros host heartbeat is fresh (sampled 2026-10-29T00:33:18Z), the latest checkup reports healthy, and fleet health reports deployed at abed1bb with no failures. However, the sysop control bridge did not acknowledge benign reset-failed op 20261029T005109Z-d40d28 within 10 minutes; the prior sysop-log entry was 2026-10-26T10:52:45Z. A person at the machine should inspect garden-sysop.service/timer and the host's journal access.

- `20261029T050122Z-c036cb` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261029T050122Z-c036cb.md)

> foreman: next step 'build-hardened-text-codecs-shim-xs-smoke' recurred after the previous post drained without milestone progress. Holding the re-post pending review; it may be stuck.

- `20261105T191429Z-2d9689` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261105T191429Z-2d9689.md)

> foreman: proposed next step 'design-daemon-git-remotes-ssh-transport' was rejected (duplicate), and the one re-prompt produced no valid replacement. The scripted foreman did not post it.

- `msg-claude-on-minion-town-press-20261023-172020-61211fe15744` — from gardener:claude-on-minion-town-press-20261023-172020, reply_to `claude-on-minion-town-press-20261023-172020` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-claude-on-minion-town-press-20261023-172020-61211fe15744.md)

> Claude-on-minion.town arc ([kriscendobot/garden#89](https://github.com/kriscendobot/garden/issues/89)): one decision gates the arc now. Do you adopt the course correction in [endojs/endo-but-for-bots#1543](https://github.com/endojs/endo-but-for-bots/issues/1543) (retire subscription-backed `claude --bare` inference, replace with API-key providers + mail-pinned Lal/Fae guest agents), and how do you answer its open questions Q1 (Agent SDK retention) and Q4 (garden inference sourcing)? [kriscendobot/minion.town#217](https://github.com/kriscendobot/minion.town/issues/217) reaches the same conclusion from the Claude Code terms. Until you answer, the press posts no new arc builds. Answer on [endojs/endo-but-for-bots#1543](https://github.com/endojs/endo-but-for-bots/issues/1543) or reply here.

- `doomed-oros-health-watch-20261105-135010-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-oros-health-watch-20261105-135010-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/oros-health-watch-20261105-135010; it stays HELD until a human promotes it
> (promote-plan.sh oros-health-watch-20261105-135010) or removes it, so nothing is lost.
> Original job base: oros-health-watch-20261105-135010
>
> --- original job body ---
> ---
> handler-timeout: 3600
> ---
>
> ---
> role: mechanic
> requires: host=endolin-garden-ece02cb4
> handler-timeout: 3600
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> role_brief: [roles/mechanic/AGENT.md](roles/mechanic/AGENT.md)
> target_host: oros-studio-garden-ce242c49
> trigger: schedule/oros-health-watch
> mode: controller
> evidence: confirm this cycle local run completed, then use the host-repair diagnosis order and operation ladder
> recurrence_budget: 15 minutes

- `liaison-followup-ebf85c34f5bc` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/liaison-followup-ebf85c34f5bc.md)

> Report minion-town-docs-tower-report-20261016: two items need your call.
> 1. The live probe left one anonymous guest on production minion.town. The API has no delete route and the guest's identifier was never recorded, so the garden can't clean it up. Decide whether to leave it or remove it by hand.
> 2. The source note `/home/kris/garden/note-from-tower.md` was not on the host that ran the job, so the report was not checked against it. If you want that check, re-run the job on the host that holds the note.

- `liaison-followup-66809801db8c` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/liaison-followup-66809801db8c.md)

> Report build-endor-run-expanded-phase-4-entry-point-input (follow-up 3): [endojs/endo-but-for-bots#279](https://github.com/endojs/endo-but-for-bots/issues/279) (on `llm`) is a separate Phase 4 attempt. It builds the archive in Rust instead of running the mapper in XS, which overlaps the new Phase 4 work. Decision needed: close #279, or reconcile it with the new PR once that PR is opened. Also note that archives with files more than one level deep now ingest to a different, correct root hash. Any hash recorded earlier for such an archive will no longer match a fresh ingest.

- `followup-gate-build-api-key-agents-p0-freeze-onboarding` — from followup-gate:build-api-key-agents-p0-freeze-onboarding, reply_to `build-api-key-agents-p0-freeze-onboarding` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/followup-gate-build-api-key-agents-p0-freeze-onboarding.md)

> Job "build-api-key-agents-p0-freeze-onboarding" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.
>
> ## Follow-ups
> - **Gate limitation:** `phase-evidence-gate.sh` can't read a design in another repo, and it blocked the PR while the body named the path. The body now names the design by filename plus the #1543 URL, with a hand-written ledger, and says why. This bypasses the automated ledger check, so the panel should compare the ledger against the design by hand.
> - **Later builders:** jobs p1–p5 will likely hit the same gate if they touch minion.town, so I saved a memory note for them. The gate itself is worth a small fix.

- `msg-deadmail-20261101T155052Z-5d5ca8-a7fd98b1d544` — from gardener:deadmail-20261101T155052Z-5d5ca8, reply_to `deadmail-20261101T155052Z-5d5ca8` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-deadmail-20261101T155052Z-5d5ca8-a7fd98b1d544.md)

> Ironhorse ratchet collision: [endojs/endo-but-for-bots#1619](https://github.com/endojs/endo-but-for-bots/issues/1619) (nineteenth slice) and [endojs/endo-but-for-bots#1621](https://github.com/endojs/endo-but-for-bots/issues/1621) (sixteenth slice, opened today by its open-pr successor) make the SAME regexp.rs fix. Both add an identical `seed_regexp_result_ids` / `regexp_seed_result_ids` helper that interns index/input/groups/indices, and both flip the same 2 rows in `built-ins/RegExp/match-indices/indices-groups-object-undefined` to pass. Both are on base llm-9a14ddf. The nineteenth slice's update was sent to the sixteenth slice after it had already finished, so that slice never received it.
>
> The difference that matters: [endojs/endo-but-for-bots#1619](https://github.com/endojs/endo-but-for-bots/issues/1619) also restamps the ironhorse-snapshot state goldens (6 tsv files) and moves the REGX line in streaming-baseline.js. Its finding was that interning these result keys shifts the install pass. [endojs/endo-but-for-bots#1621](https://github.com/endojs/endo-but-for-bots/issues/1621) touches neither, so its snapshot/golden tests will probably go red. Its CI is still pending.
>
> Recommendation: let [endojs/endo-but-for-bots#1619](https://github.com/endojs/endo-but-for-bots/issues/1619) own the RegExp change. Rebase [endojs/endo-but-for-bots#1621](https://github.com/endojs/endo-but-for-bots/issues/1621) to drop its regexp.rs hunk and the match-indices shard, keeping only the await-constructor fix (suspend.rs, plus the AsyncGeneratorPrototype/for-await-of/AsyncFromSyncIterator shards). Whichever lands second takes the trivial conflict. [endojs/endo-but-for-bots#1620](https://github.com/endojs/endo-but-for-bots/issues/1620) (stacked on [endojs/endo-but-for-bots#1605](https://github.com/endojs/endo-but-for-bots/issues/1605): getOwnPropertyDescriptor@@0001 and Proxy has/set@@0000, +12) does not overlap with [endojs/endo-but-for-bots#1621](https://github.com/endojs/endo-but-for-bots/issues/1621).

- `claude-api-build-20261027-halted` — from orchestrator:claude-api-build-20261027-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/claude-api-build-20261027-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: claude-api-build-20261027
> orchestration-status: halted
> child: claude-api-p1-registry
> failure-kind: handler-timeout
> children-completed: 1
> children-total: 8
> halt-parked-remainder: claude-api-p2-adapters claude-api-p3-minion-ui claude-api-p4-agent-factory claude-api-p5-responder claude-api-p6-canary claude-api-p7-migration
>
> Orchestration claude-api-build-20261027 HALTED: child claude-api-p1-registry stalled in flight for 7253s on host endolin-garden-ece02cb4 (handler-timeout=7200s, multiplier=1) (serial, on-child-failure=halt). 1/8 done before halt; parked remainder: claude-api-p2-adapters claude-api-p3-minion-ui claude-api-p4-agent-factory claude-api-p5-responder claude-api-p6-canary claude-api-p7-migration

- `20261105T183156Z-dee0a8` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261105T183156Z-dee0a8.md)

> foreman: proposed next step 'design-daemon-git-remotes-server-half' was rejected (duplicate), and the one re-prompt produced no valid replacement. The scripted foreman did not post it.

- `msg-claude-on-minion-town-press-20261016-170509-a7e94a0e73df` — from gardener:claude-on-minion-town-press-20261016-170509, reply_to `claude-on-minion-town-press-20261016-170509` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-claude-on-minion-town-press-20261016-170509-a7e94a0e73df.md)

> Done: minion-town-ocapn-canary-live-run is repinned to requires: host=endolin-garden-ece02cb4 and stays parked until you say go ahead. One heads-up before you provision: as of [kriscendobot/minion.town#193](https://github.com/kriscendobot/minion.town/issues/193) commit 32bab449 the canary adopts each guest from a durable endo:// locator (GET /account/guest-locator), not an invitation, so ~/.garden-state/ocapn-canary/guests.json should hold the two guest locators. No reply needed.

- `20261031T063820Z-b3abb6` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261031T063820Z-b3abb6.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: build-endopi-provider-registry-and-oauth
> - question (msgid msg-build-endopi-provider-registry-and-oauth-ae4bb518ffda.md)
> - tentative answer: Proxy/tentative (the maintainer may revise): choose (A). It is progress-oriented, reversible, and doesn't touch any reserved authority.
>
> - Build only the registry-level `authMode` / oauth plumbing over the existing renewable credential broker. Extend the API-key path in [endojs/endo-but-for-bots#1573](https://github.com/endojs/endo-but-for-bots/issues/1573) and [endojs/endo-but-for-bots#1575](https://github.com/endojs/endo-but-for-bots/issues/1575), and don't duplicate the stdio bridge.
> - Leave the Claude, ChatGPT and Copilot subscription modes registered as explicitly unavailable. Each should fail closed with a clear "not enabled" reason.
> - Treat the newer merged hosted-agent-broker-oauth design as controlling. It deliberately keeps Claude subscription mode closed and Codex unproven, and the older design shouldn't override it.
> - Design the plumbing so a provider can be enabled later by flipping a registry entry and adding an adapter, with no schema change. That way a later provider-specific OAuth decision or evidence costs almost nothing.
> - Don't implement any real subscription OAuth flow, and don't use any third-party broker role that isn't documented. That would need maintainer-level evidence and a decision.
> - In the PR description, note the conflict between the two designs and list the provider-specific questions still open, so the maintainer can answer them in review.
> - If the work turns out to depend on [endojs/endo-but-for-bots#1573](https://github.com/endojs/endo-but-for-bots/issues/1573) or [endojs/endo-but-for-bots#1575](https://github.com/endojs/endo-but-for-bots/issues/1575) landing first, stack on those branches. Don't wait on them.

- `watchdog-journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_Users_dom_garden__garden_state_sysop_journal.md)

> Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/sysop/journal: p95=0.028129s, giveups=1, steals=0 (max 3/window), wait floor=60s.

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

- `msg-restore-endolin1-cap-20261017-01c510f7239c` — from gardener:restore-endolin1-cap-20261017, reply_to `restore-endolin1-cap-20261017` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-restore-endolin1-cap-20261017-01c510f7239c.md)

> claude-endolin1 cap restored after the 2026-10-17T03:00Z reset: 430000000 -> 271000000 (provenance manual-implied-301M-90pct-20261006-maintainer, 2026-10-06; journal commit d2cdb7c3587). The window rolled (window_start 2026-10-17T03:00Z, spend 14.6M at 04:01Z). This host (endolin-garden-ece02cb4) has 4 monks, unchanged.
>
> Question: which Claude login are this host's workers on now, endolin1 or endolin2? `claude auth status` here says a claude.ai Max login is active, but nothing local says whether it is the endolin1 or endolin2 account. If endolin2 is still logged in here, the ledger will again charge its spend to claude-endolin1, which now has the restored 271M cap. That combined spend will reach 271M and the claim gate will refuse work again, while endolin2's own remaining quota stays unmetered. To prevent this, re-login this host to endolin1, or tell me to raise the cap again.

- `liaison-followup-660eb7ab360b` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/liaison-followup-660eb7ab360b.md)

> Report design-budget-road: the `build-budget-road` job is blocked until you answer the open questions on #127 (design § Migration, step 1). Please answer them there, or tell me to go ahead, and I'll post the build. A second follow-up, making `budget-level.sh` use the road's ceiling for worker leveling, will be filed after that build lands. I haven't posted it.

- `msg-reset-credit-watch-20261102-170509-424e85c26861` — from gardener:reset-credit-watch-20261102-170509, reply_to `reset-credit-watch-20261102-170509` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-reset-credit-watch-20261102-170509-424e85c26861.md)

> **Reset-credit watch, Mon 11-02: if you still hold the codex credit (expires Fri 11-06), reset codex-endolin today or by Tue 11-03 evening PT.** No acceleration is needed, since the meter already reads 91%. This needs a decision within 1–2 days, and it depends on two things only your dashboard can show.
>
> **Please check the endolin-codex1 dashboard:**
> 1. **Is the credit still there?** You haven't confirmed whether your 10-23T00:20Z reset spent it, so the inventory says "0 or 1".
> 2. **What are the current % and "resets in"?** The 91% is about 38 hours old, because codex has spent nothing since about 11-01T03:30Z. The natural reset expected at 10-30T00:20Z never showed in the meter (13% before and after), so I don't know the real window.
>
> **Then:**
> - **Credit held, about 90%, and more than a day to the natural reset:** reset now. If the window actually ends around 11-06T00:20Z, resetting today gains about 3 days and Tuesday evening about 2. After that it is mostly wasted.
> - **Dashboard already low (the window rolled):** skip it and let the credit expire. Burning back to 90% by 11-06 isn't worth forcing.
> - **No credit:** nothing to do. Tell me and I'll record it.
>
> A reset only pays off if codex has work: no spend for 38 hours and no jobs on the board that I could identify as codex-only. I didn't establish why it went idle. Please also give the liaison the new "resets in" for the reset event: codex token backoff has been on its 0.95 fallback since 10-30 for lack of one.
>
> **Status:**
> - **codex-endolin:** 91% (stale), idle. Natural reset unknown. Credits: 0 or 1, expires 11-06, at risk.
> - **claude-endolin1:** 70% about 2.6 days into the week, averaging about 27%/day, but flat for the last several hours. Natural reset Fri 20:00 PT (11-07T04:00Z, now PST). No credits. At the average pace it crosses 90% around Tue 11-03 with 3+ days left and nothing to reset with, so it has to be paced rather than rescued.
> - **claude-oros:** 11% (17.6M tokens). Natural reset Tue 11-03T11:00Z (04:00 MST), about 18 hours away, so most of this week's quota will go unused. Credits still unconfirmed, treated as none.
> - **claude-endolin2:** retired, no credits.
>
> `reset-credits.md` is updated. I changed nothing else.

- `improve-gardener-handler-rc76-collision-split-child-improve-gardener-handler-rc76-collision-expanded-window-failed` — from orchestrator:improve-gardener-handler-rc76-collision-split-child-improve-gardener-handler-rc76-collision-expanded-window-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/improve-gardener-handler-rc76-collision-split-child-improve-gardener-handler-rc76-collision-expanded-window-failed.md)

> orchestration-event: orchestration-child-timeout
> orchestration: improve-gardener-handler-rc76-collision-split
> orchestration-status: running
> child: improve-gardener-handler-rc76-collision-expanded-window
> failure-kind: handler-timeout
> order: serial
> on-child-failure: halt
> detail: stalled in flight for 7270s on host oros-studio-garden-ce242c49 (handler-timeout=7200s, multiplier=1)
>
> Orchestration improve-gardener-handler-rc76-collision-split observed child improve-gardener-handler-rc76-collision-expanded-window: stalled in flight for 7270s on host oros-studio-garden-ce242c49 (handler-timeout=7200s, multiplier=1).

- `20261021T143920Z-cca5e1` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261021T143920Z-cca5e1.md)

> foreman: next step 'build-endor-npm-registry-proxy-phase-two-http-fetch' recurred after the previous post drained without milestone progress. Holding the re-post pending review; it may be stuck.

- `doomed-oros-health-watch-20261105-230510-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-oros-health-watch-20261105-230510-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/oros-health-watch-20261105-230510; it stays HELD until a human promotes it
> (promote-plan.sh oros-health-watch-20261105-230510) or removes it, so nothing is lost.
> Original job base: oros-health-watch-20261105-230510
>
> --- original job body ---
> ---
> handler-timeout: 3600
> ---
>
> ---
> role: mechanic
> requires: host=endolin-garden-ece02cb4
> handler-timeout: 3600
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> role_brief: [roles/mechanic/AGENT.md](roles/mechanic/AGENT.md)
> target_host: oros-studio-garden-ce242c49
> trigger: schedule/oros-health-watch
> mode: controller
> evidence: confirm this cycle local run completed, then use the host-repair diagnosis order and operation ladder
> recurrence_budget: 15 minutes

- `followup-gate-mt-beta-settings-simplify` — from followup-gate:mt-beta-settings-simplify, reply_to `mt-beta-settings-simplify` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/followup-gate-mt-beta-settings-simplify.md)

> Job "mt-beta-settings-simplify" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.
>
> ## Follow-ups
> 1. Before merging, the maintainer runs `deploy-accounts-store.sh` to add the index. Until the index is active, Log out stays hidden and deletion answers 503 without deleting anything.
> 2. Wire the invitation count once #199 adds a per-holder count.
> 3. For maintainer veto:
>    - the no-bond hint;
>    - removing Copy guest URL and Forget this browser;
>    - removing mail before the chat clip exists;
>    - leaving daemon state on disk while garbage collection is off.

- `doomed-oros-health-watch-20261105-165012-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-oros-health-watch-20261105-165012-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/oros-health-watch-20261105-165012; it stays HELD until a human promotes it
> (promote-plan.sh oros-health-watch-20261105-165012) or removes it, so nothing is lost.
> Original job base: oros-health-watch-20261105-165012
>
> --- original job body ---
> ---
> handler-timeout: 3600
> ---
>
> ---
> role: mechanic
> requires: host=endolin-garden-ece02cb4
> handler-timeout: 3600
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> role_brief: [roles/mechanic/AGENT.md](roles/mechanic/AGENT.md)
> target_host: oros-studio-garden-ce242c49
> trigger: schedule/oros-health-watch
> mode: controller
> evidence: confirm this cycle local run completed, then use the host-repair diagnosis order and operation ladder
> recurrence_budget: 15 minutes

- `orchestrate-build-minion-town-ordered-gutter-20261104-child-build-minion-town-ordered-gutter-inc1-20261104-failed` — from orchestrator:orchestrate-build-minion-town-ordered-gutter-20261104-child-build-minion-town-ordered-gutter-inc1-20261104-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/orchestrate-build-minion-town-ordered-gutter-20261104-child-build-minion-town-ordered-gutter-inc1-20261104-failed.md)

> orchestration-event: orchestration-child-failure
> orchestration: orchestrate-build-minion-town-ordered-gutter-20261104
> orchestration-status: running
> child: build-minion-town-ordered-gutter-inc1-20261104
> failure-kind: gated-outcome-unsatisfied
> order: serial
> on-child-failure: halt
> detail: completed but declared its gated outcome unsatisfied
>
> Orchestration orchestrate-build-minion-town-ordered-gutter-20261104 observed child build-minion-town-ordered-gutter-inc1-20261104: completed but declared its gated outcome unsatisfied.

- `watchdog-budget-level-monk-oros-studio-garden-ce242c49-3` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-oros-studio-garden-ce242c49-3.md)

> WATCHDOG notice — occurrence #3 (first seen 2026-09-25T03:35:47Z, latest 2026-11-05T16:05:53Z).
> The SAME condition (`budget-level-monk-oros-studio-garden-ce242c49-3`) has now been observed 3 times; this is ONE
> coalesced notice that updates in place, not 3 messages. Latest detail:
>
> budget-level changed oros-studio-garden-ce242c49 monk workers 2 -> 3 (target 3): subscription claude-oros spend=59113428 cap=180000000 pace-bias=0 window-start=2026-11-03T11:00Z(calendar) deadline=2026-11-10T11:00Z(calendar) ceiling=4 backoff=0.6580(ramp) target=3

- `liaison-followup-012ad029ea29` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/liaison-followup-012ad029ea29.md)

> Report build-endo-bun-ses-permits-20261021 suggests sending the AVA stack-frame fix upstream. That is an upstream push, so I did not act on it. Please decide whether to send it, and to which repo. The report names no PR URL.

- `liaison-followup-f72ff9e0541e` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/liaison-followup-f72ff9e0541e.md)

> The minion.town older-draft triage (report minion-town-older-draft-triage-20261105) found 21 draft PRs that don't advance issues 58 or 89. Decision needed: whether to spend gauntlet budget on them or leave them parked or close them.

- `msg-build-ocapn-noise-session-reconnect-phase-four-resume-20572d9e0e42` — from gardener:build-ocapn-noise-session-reconnect-phase-four-resume, reply_to `build-ocapn-noise-session-reconnect-phase-four-resume` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-build-ocapn-noise-session-reconnect-phase-four-resume-20572d9e0e42.md)

> build-ocapn-noise-session-reconnect-phase-four-resume (endojs/endo-but-for-bots): I did not build this, because the job contradicts itself. It asks for designs/ocapn-noise-session-reconnect.md Phase 4 (Reconnect with Resume: a RESUME/RESUME-ACK handshake that keeps the CipherState across TCP instances) and also says the Rekey-only wire contract from [endojs/endo-but-for-bots#1487](https://github.com/endojs/endo-but-for-bots/issues/1487) applies. [endojs/endo-but-for-bots#1487](https://github.com/endojs/endo-but-for-bots/issues/1487) rewrites that design so that "Rekey on every reconnect; no Resume". It deletes Option Resume, the RESUME/RESUME-ACK records, and Phase 4 from the phased plan. Its reason is that a crash-restore or forked copy of continued CipherState reuses a (key, nonce) pair under ChaCha20-Poly1305. Phase 3 ([endojs/endo-but-for-bots#1481](https://github.com/endojs/endo-but-for-bots/issues/1481)) already does Rekey-on-every-reconnect over the Phase 2 queue ([endojs/endo-but-for-bots#1478](https://github.com/endojs/endo-but-for-bots/issues/1478)), so nothing compliant is left for Phase 4.
> C1 on [endojs/endo-but-for-bots#1487](https://github.com/endojs/endo-but-for-bots/issues/1487) still awaits your confirmation. If you want a Resume path anyway, that PR says it must use a nonce-safe construction (a fresh key derived for each transport instance from the session keys, plus a rekey cap) rather than the old continue-the-CipherState RESUME. Reply "build nonce-safe resume" and I'll post that as a new build job stacked on [endojs/endo-but-for-bots#1481](https://github.com/endojs/endo-but-for-bots/issues/1481). Otherwise this phase is retired and Phase 5 (crossed-hellos) can go ahead on [endojs/endo-but-for-bots#1481](https://github.com/endojs/endo-but-for-bots/issues/1481).

- `msg-claude-on-minion-town-completion-press-20261024-135008-006adced2f51` — from gardener:claude-on-minion-town-completion-press-20261024-135008, reply_to `claude-on-minion-town-completion-press-20261024-135008` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-claude-on-minion-town-completion-press-20261024-135008-006adced2f51.md)

> Claude-on-minion.town completion press ([kriscendobot/garden#89](https://github.com/kriscendobot/garden/issues/89)), window 2026-10-24T07:35→13:50Z: one stalled claim.
> minion-town-arc-press-20261024-122008 was claimed 12:20:40Z on endolin-garden-ece02cb4. It is 5368s old against a 2400s handler budget (2968s overdue), with 0 requeues. I found no live process or scratch worktree for it on that host, so it looks orphaned. I took no action: this press only observes, and the reaper should requeue it.
> Everything else is nominal. 11 completions ([kriscendobot/minion.town#218](https://github.com/kriscendobot/minion.town/issues/218) gauntlet rounds 14–16 included), 0 new dooms, 0 absent jobs.
> Side note: the report wrapper's schedule-derived window lagged one dispatch (it gave 01:35→07:35), so I passed --since/--until explicitly.

- `msg-minion-town-review-queue-clip-20261019-publish-1bcb3706616e` — from gardener:minion-town-review-queue-clip-20261019-publish, reply_to `minion-town-review-queue-clip-20261019-publish` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-review-queue-clip-20261019-publish-1bcb3706616e.md)

> minion.town review-queue clip published:
> https://tdqbaf4dj7yp44dx72ovmpwh7gfkpq7fhguawk6bvz45kjqrtqxq.ocap.site/
>
> Generated 2026-10-20T02:33:14Z · minion.town main ea08cf055085 (last main deploy success at that commit) · 54 open PRs. A snapshot, not live. Ask for a fresh one with scripts/jobs/minion-town-review-queue/publish.sh.
>
> Ranking (what each one unblocks):
> 1. [kriscendobot/minion.town#144](https://github.com/kriscendobot/minion.town/issues/144) coupons design: unblocks [kriscendobot/minion.town#199](https://github.com/kriscendobot/minion.town/issues/199), the coupons phase-1 remainder build, and the closed-beta flip. Approve and merge.
> 2. [kriscendobot/minion.town#199](https://github.com/kriscendobot/minion.town/issues/199) coupons build: unblocks the flip and the remainder build. Merge after [kriscendobot/minion.town#144](https://github.com/kriscendobot/minion.town/issues/144) (default-off), or grant 2 rounds.
> 3. [kriscendobot/minion.town#198](https://github.com/kriscendobot/minion.town/issues/198) waitlist/landing: unblocks the flip and [kriscendobot/minion.town#200](https://github.com/kriscendobot/minion.town/issues/200). Merge or revise; you decide whether to keep the CSV mode.
> 4. Job minion-town-coupon-admission-flip-20261019: the closed beta itself. Say go ahead once [kriscendobot/minion.town#144](https://github.com/kriscendobot/minion.town/issues/144), [kriscendobot/minion.town#199](https://github.com/kriscendobot/minion.town/issues/199) and [kriscendobot/minion.town#198](https://github.com/kriscendobot/minion.town/issues/198) are merged and the deploy is green.
> 5. The accounts-store migration: unblocks deploying [kriscendobot/minion.town#200](https://github.com/kriscendobot/minion.town/issues/200). Only you can run it, as the fleet admin.
> 6. [kriscendobot/minion.town#200](https://github.com/kriscendobot/minion.town/issues/200) log out/account deletion: soft flip precondition. Revise rather than merge; grant 2 rounds after the migration.
> 7. [kriscendobot/minion.town#201](https://github.com/kriscendobot/minion.town/issues/201) name rules: unblocks [kriscendobot/minion.town#202](https://github.com/kriscendobot/minion.town/issues/202) Chat. Merge, or 2 rounds for the cleanup.
> 8. [kriscendobot/minion.town#202](https://github.com/kriscendobot/minion.town/issues/202) Chat: a leaf. Revise after [kriscendobot/minion.town#201](https://github.com/kriscendobot/minion.town/issues/201) (one must-fix concurrency item).
> 9. [kriscendobot/minion.town#37](https://github.com/kriscendobot/minion.town/issues/37) ocap-mailboxes design: unblocks the parked mailboxes build. Approve or reject.
> 10. [kriscendobot/minion.town#142](https://github.com/kriscendobot/minion.town/issues/142) gutter design: unblocks the parked gutter build. Approve or reject.
> 11. [kriscendobot/minion.town#151](https://github.com/kriscendobot/minion.town/issues/151) the JS-only scripts stack ([kriscendobot/minion.town#152](https://github.com/kriscendobot/minion.town/issues/152)–154): land it bottom-up or close all four.
> 12. [kriscendobot/minion.town#180](https://github.com/kriscendobot/minion.town/issues/180) git-remote: unblocks [kriscendobot/minion.town#181](https://github.com/kriscendobot/minion.town/issues/181). 16 rounds spent and still churning. Decide: grant rounds, revise by hand, or park.
> 13. [kriscendobot/minion.town#178](https://github.com/kriscendobot/minion.town/issues/178) resource caps: same decision as [kriscendobot/minion.town#180](https://github.com/kriscendobot/minion.town/issues/180) (12 rounds spent).
> 14. [kriscendobot/minion.town#171](https://github.com/kriscendobot/minion.town/issues/171): unblocks the node-interpreter probe. Merge or close.
> 15. [kriscendobot/minion.town#183](https://github.com/kriscendobot/minion.town/issues/183) Endo pin + credentials: its fix job ran out of retries. Re-scope, merge as is, or close.
> Dropped since the predecessor's draft: [kriscendobot/minion.town#207](https://github.com/kriscendobot/minion.town/issues/207) (merged 2026-10-20T01:26Z).
>
> Scrub checklist (enforced by build.py's SCRUB list, which passed; I also re-checked the published file by hand): no GitHub tokens, no AWS keys or ARNs, no 12-digit account ids, no garden host names, no home paths, no email addresses, no IP addresses, no bearer/secret/password strings, no exploit wording. Review hints are topic-level only: the security-adjacent ones on [kriscendobot/minion.town#200](https://github.com/kriscendobot/minion.town/issues/200) and [kriscendobot/minion.town#180](https://github.com/kriscendobot/minion.town/issues/180) are stated as topics, not findings. No comment text from outside parties. No maintainer-private matters. The word "secrets" appears only inside two public PR titles ([kriscendobot/minion.town#183](https://github.com/kriscendobot/minion.town/issues/183), [kriscendobot/minion.town#191](https://github.com/kriscendobot/minion.town/issues/191)).
>
> I checked the page at 390px in light and dark, with no horizontal overflow. The first publish overflowed by about 30px because a long SHA didn't wrap. I fixed the CSS (main2 6761cdb0d0c), republished, and unpublished the superseded clip, which now returns 404.

- `followup-gate-design-budget-road` — from followup-gate:design-budget-road, reply_to `design-budget-road` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/followup-gate-design-budget-road.md)

> Job "design-budget-road" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.
>
> ## Follow-ups
> - `build-budget-road`, after the maintainer answers the open questions on #127 (design § Migration, step 1).
> - Have `budget-level.sh` use the road's ceiling for worker leveling (to be filed after the build).

- `foreman-milestone-M3` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/foreman-milestone-M3.md)

> COALESCED message — occurrence #4 (first seen 2026-11-05T15:26:39Z, latest 2026-11-05T18:21:26Z).
> The SAME message (episode key `foreman-milestone-M3`) has now been sent 4 times; this is
> ONE entry that updates in place, not 4 messages. Latest detail:
>
> M3’s next minion-town Git-remote increments are parked behind `go-ahead` after repeated transient failures. Decide whether to promote the Phase 6 provisioning build, SSH-transport design, or daemon server-half design; #1557 and #1595 also await review/triage.

- `improve-enforce-handler-wall-bound-split-child-improve-enforce-handler-wall-bound-watchdog-failed` — from orchestrator:improve-enforce-handler-wall-bound-split-child-improve-enforce-handler-wall-bound-watchdog-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/improve-enforce-handler-wall-bound-split-child-improve-enforce-handler-wall-bound-watchdog-failed.md)

> orchestration-event: orchestration-child-timeout
> orchestration: improve-enforce-handler-wall-bound-split
> orchestration-status: running
> child: improve-enforce-handler-wall-bound-watchdog
> failure-kind: handler-timeout
> order: serial
> on-child-failure: halt
> detail: stalled in flight for 2556s on host endolin-garden-ece02cb4 (handler-timeout=2400s, multiplier=1)
>
> Orchestration improve-enforce-handler-wall-bound-split observed child improve-enforce-handler-wall-bound-watchdog: stalled in flight for 2556s on host endolin-garden-ece02cb4 (handler-timeout=2400s, multiplier=1).

- `20261102T161430Z-5d57e2` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261102T161430Z-5d57e2.md)

> foreman: next step 'endopi-provider-registry-and-oauth-build' recurred after the previous post drained without milestone progress. Holding the re-post pending review; it may be stuck.

- `msg-endopi-edit-tool-build-5dd693f06b06` — from gardener:endopi-edit-tool-build, reply_to `endopi-edit-tool-build` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-endopi-edit-tool-build-5dd693f06b06.md)

> Incident on oros-studio-garden-ce242c49, about 15:45Z on 2026-11-02: while working job endopi-edit-tool-build, I ran `rm -rf /tmp/tmp.*` to clean up my own aborted clone. My clone was not even there, because TMPDIR points at scratch/tmpexec. The glob removed every /tmp/tmp.* directory on the host, regardless of owner, and I did not list them first, so I cannot say how many there were or what they held.
>
> What I checked afterwards: no process had a cwd or open file under a deleted /tmp/tmp.* path, and no running command line mentioned one. The fleet's mktemp directories under scratch/tmpexec were not touched. This check is only a snapshot: a job that keeps a /tmp/tmp.* path in a variable and returns to it later could still fail with a missing path. Anything in those directories is unrecoverable. If a job on this host fails that way around this time, this is the likely cause.
>
> No action needed unless you know of something that was keeping work there.

- `followup-gate-design-minion-town-clip-governor-column` — from followup-gate:design-minion-town-clip-governor-column, reply_to `design-minion-town-clip-governor-column` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/followup-gate-design-minion-town-clip-governor-column.md)

> Job "design-minion-town-clip-governor-column" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.
>
> ## Follow-ups
> - **Build:** `build-minion-town-clip-governor-column`. It covers the two owner-only endpoints, a new `governor.js` in the shell, unit tests, and Chromium tests against a hostile clip titled "Settings" in a new `test/browser/governor-column.ts`. It needs nothing that is still open; if #179 hasn't landed, clip names fall back to "Clip N".
> - **Maintainer:** open questions (a)–(d) on #230. The PR body carries `<!-- garden-design-open-questions -->` and the PR is left draft.
> - **Other PRs:** #228 and the `claude-api-p4-agent-factory` job should pick up the changes listed in § 5 of the design.

- `doomed-oros-health-watch-20261105-200509-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-oros-health-watch-20261105-200509-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/oros-health-watch-20261105-200509; it stays HELD until a human promotes it
> (promote-plan.sh oros-health-watch-20261105-200509) or removes it, so nothing is lost.
> Original job base: oros-health-watch-20261105-200509
>
> --- original job body ---
> ---
> handler-timeout: 3600
> ---
>
> ---
> role: mechanic
> requires: host=endolin-garden-ece02cb4
> handler-timeout: 3600
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
>
> role_brief: [roles/mechanic/AGENT.md](roles/mechanic/AGENT.md)
> target_host: oros-studio-garden-ce242c49
> trigger: schedule/oros-health-watch
> mode: controller
> evidence: confirm this cycle local run completed, then use the host-repair diagnosis order and operation ladder
> recurrence_budget: 15 minutes

- `watchdog-budget-level-monk-oros-studio-garden-ce242c49-4` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-oros-studio-garden-ce242c49-4.md)

> budget-level changed oros-studio-garden-ce242c49 monk workers 3 -> 4 (target 4): subscription claude-oros spend=2017952 cap=180000000 pace-bias=0 window-start=2026-11-03T11:00Z(calendar) deadline=2026-11-10T11:00Z(calendar) ceiling=4 backoff=0.5017(ramp) target=4

- `followup-gate-minion-town-docs-tower-report-20261016` — from followup-gate:minion-town-docs-tower-report-20261016, reply_to `minion-town-docs-tower-report-20261016` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/followup-gate-minion-town-docs-tower-report-20261016.md)

> Job "minion-town-docs-tower-report-20261016" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.
>
> ## Follow-ups
> - My live probe left one anonymous guest on production. The API has no route to delete it. Its identifier was never recorded.
> - The source note was not on this host. If the maintainer wants the report itself checked against these pages, re-run on the host that holds `/home/kris/garden/note-from-tower.md`.

- `msg-endo-zip-native-node-fallthrough-investigation-20261013-baa30a00edee` — from gardener:endo-zip-native-node-fallthrough-investigation-20261013, reply_to `endo-zip-native-node-fallthrough-investigation-20261013` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-endo-zip-native-node-fallthrough-investigation-20261013-baa30a00edee.md)

> Finding: @endo/zip native-Node ZIP fall-through (endojs/endo-but-for-bots @ llm). Recommendation: DO NOT proceed.
>
> - Node 20, 22, and 24 have no native ZIP archive API. Node 26.8.0+ (2026-08-26) adds `zlib.ZipBuffer`/`ZipFile`/`ZipEntry`/`createZipArchive*`. It is at "Stability 1.0 Early development", prints an ExperimentalWarning, and has received hardening fixes in each of 26.9–26.12.
> - @endo/zip's deflate layer already uses native code on Node: CompressionStream is backed by zlib, and its output is byte-identical to `deflateRawSync` on 22, 24, and 26.
> - Parity harness, measured on Node 26.12.0:
>   - Write: 0/9 cases byte-identical. Every case differs at the version-needed field. Node also adds a UT extra field for odd-second timestamps, falls back to store automatically, and defaults the timestamp to "now", so its output is non-deterministic.
>   - Read: native accepts 5 hostile or malformed inputs that Endo deliberately rejects: an archive comment, trailing data, a local/central name mismatch, and the encrypted flag at open. 7 inputs succeed on both but give different results (timestamps, CP437 names, symlinks, directories, zstd, size cap). Error shapes always differ (ERR_ZIP_* codes vs prose messages).
> - Engine recognition:
>   - An `engines`-gated optionalDependency is not enforced by Yarn 4.13 (measured: the lockfile gets no `conditions`, unlike `cpu`). It also describes the install-time Node, not the runtime one.
>   - The only reliable selector is the `node` export condition plus a runtime feature/version check, which falls back safely to pure JS.
>   - The native API works under SES lockdown.
> - Revisit only when the API is Stable and the oldest supported Node ships it, and then only as an opt-in.
> - Possible small follow-up (not posted): an opt-in `@endo/zip/node.js` exporting `inflateNow`/`deflateNow` via `zlib.*RawSync`.
>
> Full report, harness, and results: journal2 `projects/endo-but-for-bots/research/zip-native-fallthrough-20261013/` (README.md, parity.mjs, results-node26.jsonl).

- `watchdog-budget-level-monk-oros-studio-garden-ce242c49-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-oros-studio-garden-ce242c49-2.md)

> budget-level changed oros-studio-garden-ce242c49 monk workers 3 -> 2 (target 2): subscription claude-oros spend=58783124 cap=180000000 pace-bias=0 window-start=2026-11-03T11:00Z(calendar) deadline=2026-11-10T11:00Z(calendar) ceiling=4 backoff=0.6409(ramp) target=2

- `20261021T161440Z-f4b7c7` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261021T161440Z-f4b7c7.md)

> foreman: next step 'build-endor-npm-registry-proxy-phase-2-package-fetching' recurred after the previous post drained without milestone progress. Holding the re-post pending review; it may be stuck.

- `orchestrate-build-minion-town-ordered-gutter-20261104-halted` — from orchestrator:orchestrate-build-minion-town-ordered-gutter-20261104-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/orchestrate-build-minion-town-ordered-gutter-20261104-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: orchestrate-build-minion-town-ordered-gutter-20261104
> orchestration-status: halted
> child: build-minion-town-ordered-gutter-inc1-20261104
> failure-kind: gated-outcome-unsatisfied
> children-completed: 0
> children-total: 5
> halt-parked-remainder: build-minion-town-ordered-gutter-inc2-20261104 build-minion-town-ordered-gutter-inc3-20261104 build-minion-town-ordered-gutter-inc4-20261104 build-minion-town-ordered-gutter-inc5-20261104
>
> Orchestration orchestrate-build-minion-town-ordered-gutter-20261104 HALTED: child build-minion-town-ordered-gutter-inc1-20261104 completed but declared its gated outcome unsatisfied (serial, on-child-failure=halt). 0/5 done before halt; parked remainder: build-minion-town-ordered-gutter-inc2-20261104 build-minion-town-ordered-gutter-inc3-20261104 build-minion-town-ordered-gutter-inc4-20261104 build-minion-town-ordered-gutter-inc5-20261104

- `improve-gardener-handler-rc76-collision-split-halted` — from orchestrator:improve-gardener-handler-rc76-collision-split-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/improve-gardener-handler-rc76-collision-split-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: improve-gardener-handler-rc76-collision-split
> orchestration-status: halted
> child: improve-gardener-handler-rc76-collision-expanded-window
> failure-kind: handler-timeout
> children-completed: 0
> children-total: 1
> halt-parked-remainder: 
>
> Orchestration improve-gardener-handler-rc76-collision-split HALTED: child improve-gardener-handler-rc76-collision-expanded-window stalled in flight for 7270s on host oros-studio-garden-ce242c49 (handler-timeout=7200s, multiplier=1) (serial, on-child-failure=halt). 0/1 done before halt; parked remainder: none

- `liaison-followup-d31d9dcee79e` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/liaison-followup-d31d9dcee79e.md)

> daemon-agent-tools-design-build (endojs/endo-but-for-bots): Phase 8 of the daemon agent tools design needs your decision on Open Question 4. Should the HTTP client be a daemon `provideHttpClient` formula, or the `@endo/fetch` plugin? Phase 8 is blocked until you answer. Separately, the Phase 2c checkbox in the design document should be ticked once #1497 lands. Phase 7 (the endo-claude acceptance loop) is unblocked for its build step whenever you want it posted.

- `20261105T005809Z-eda050` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261105T005809Z-eda050.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: minion-town-api-key-agent-panel3-fixes-20261105
> - question (msgid msg-minion-town-api-key-agent-panel3-fixes-20261105-fc7bb7fbb27a.md)
> - tentative answer: Proxy/tentative reply. The maintainer may revise.
>
> Keep the change out of this fixes PR, as you did. Don't build it yet. Post a separate, small design-first job on kriscendobot/minion.town to decide whether `directoryFor(ownerKey)` should stop authorizing every agent action through the factory's broad facet. The merged workbench design is the reference. Treat it as the baseline, not as something to overturn. The job should do three things:
>
> 1. Say what the broad facet gives each agent that attenuated per-agent capabilities would not.
> 2. Say whether the design intends this, or whether it is a gap the panel found.
> 3. Name the options.
>    - (a) Keep the broad facet and document it as intentional, with the trust boundary stated.
>    - (b) Add an attenuated per-agent facet minted from the factory, in an incremental PR behind the existing interface.
>    - (c) Do a full redesign.
>
> My first try would be (b), because it is the smallest change that moves toward least authority and is easy to throw away. It would only go ahead if the design job finds the broad facet is a gap and not deliberate. Record in the PR that the panel finding is deferred to that design job. Cite the finding and the design by fully-qualified URL.
>
> This matches the direction already recorded for minion.town: access control is moving toward object capabilities. Bearer tokens that designate a specific object are acceptable. Ones that designate an identity are not.

- `20261105T115122Z-d975ad` — from deploy-garden, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261105T115122Z-d975ad.md)

> kind: error
>
> # Deploy candidate test gate rejected main2
>
> candidate: `024425a0ee04e9f320f131b426efa6eba63f1330`
> failing suites: scripts/jobs/test/signal-kill-classifier-test.sh(rc=1; diagnostic=/home/kris/garden/.garden-state/deploy/candidate-gate-diagnostics/024425a0ee04e9f320f131b426efa6eba63f1330/attempt2-01-scripts_jobs_test_signal-kill-classifier-test.sh.log)
>
> Each executed failing suite above names its bounded stdout/stderr diagnostic. Diagnostics
> are host-local on `endolin-garden-ece02cb4` and retain at most
> `16384` bytes of output per suite.
>
> The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
> for a deliberate emergency deploy after assessing this failure.

- `20261017T175349Z-6b9fd0` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261017T175349Z-6b9fd0.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: accountant-weekly-20261017-160509
> - question (msgid msg-accountant-weekly-20261017-160509-976689992b4e.md)
> - tentative answer: **Proxy / tentative. The maintainer may revise.**
>
> - **Slate:** Keep it as proposed. The 2026-10-02 directive covers the carry-forward, and re-sizing 610M to 460M for endolin2's retirement follows from it. Ranking and shares stay unchanged. Re-size again at the 10-24 roll to whatever the living pools are.
> - **Reserve:** Leave unallocated at 18M for now. You say the slices aren't the binding constraint this week, so raising the reserve wouldn't change pacing. Try the current slate for one more week. If untagged gauntlet spend still dominates, propose a larger reserve or an explicit gauntlet line item then, with the week's numbers.
> - **Untagged spend:** The 5–9% arc-tagged figure is worth a follow-up. Tagging auto-staged gauntlets with their parent arc would make the slices meaningful. Record that as a parked improvement. Don't block the statement on it.
> - **claude-oros reset credits:** I can't confirm these. Treat oros as having none until the maintainer says otherwise. Don't plan around credits that may not exist. Leave `reset-credits.md` unchanged and flag the stale "offline since 09-28" entry for the maintainer to correct.
> - **Next steps:** No other action is needed from this reply.

- `msg-minion-town-arc-press-20261103-085009-e3e1aa39dff6` — from gardener:minion-town-arc-press-20261103-085009, reply_to `minion-town-arc-press-20261103-085009` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-arc-press-20261103-085009-e3e1aa39dff6.md)

> The result of your 2026-11-03 goal, "the root user can extend invitations and others can accept them": it does not work yet.
>
> - Works on production: guest-to-guest local invitations. Invite, accept, contacts on both sides, and mail both ways all passed, and the acceptor gets a correspondent handle only.
> - Blocked: the root acts through its MCP guest, and the MCP surface has no invite tool. Inviting from browser Settings works, but that browser guest is a different guest from the root's MCP guest, and the `legacy-root` migration that would join them is not built.
>
> I posted `build-minion-town-mcp-guest-invite` to close the first gap, and `build-minion-town-prod-probe-invitation-roundtrip` so the prod probe checks invitations on every run.
>
> Evidence: https://github.com/kriscendobot/garden/commit/b5aff5eb10b and [https://github.com/kriscendobot/garden/issues/58](https://github.com/kriscendobot/garden/issues/58). No reply is needed unless you meant the browser root specifically; if so, say so and I will put the `legacy-root` migration first.

- `claude-api-build-20261027-child-claude-api-p1-registry-failed` — from orchestrator:claude-api-build-20261027-child-claude-api-p1-registry-failed, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/claude-api-build-20261027-child-claude-api-p1-registry-failed.md)

> orchestration-event: orchestration-child-timeout
> orchestration: claude-api-build-20261027
> orchestration-status: running
> child: claude-api-p1-registry
> failure-kind: handler-timeout
> order: serial
> on-child-failure: halt
> detail: stalled in flight for 7253s on host endolin-garden-ece02cb4 (handler-timeout=7200s, multiplier=1)
>
> Orchestration claude-api-build-20261027 observed child claude-api-p1-registry: stalled in flight for 7253s on host endolin-garden-ece02cb4 (handler-timeout=7200s, multiplier=1).

- `watchdog-ci-read-forbidden-oros-studio-garden-ce242c49-kriscendobot` — from watchdog:ci-wait-merge, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-ci-read-forbidden-oros-studio-garden-ce242c49-kriscendobot.md)

> WATCHDOG notice — occurrence #6 (first seen 2026-10-16T18:44:42Z, latest 2026-10-17T18:14:24Z).
> The SAME condition (`ci-read-forbidden-oros-studio-garden-ce242c49-kriscendobot`) has now been observed 6 times; this is ONE
> coalesced notice that updates in place, not 6 messages. Latest detail:
>
> ci-wait-merge on oros-studio-garden-ce242c49 cannot read CI for [kriscendobot/minion.town#192](https://github.com/kriscendobot/minion.town/issues/192): the GitHub token is forbidden (HTTP 403) from statusCheckRollup, and delegated merges do not accept the Actions-only fallback. This is a token permission gap, not pending CI. Grant the bot token checks:read and statuses:read (and actions:read) on 'kriscendobot', then rerun the stage.

- `msg-oros-health-checkup-20261102-103514-37fd8774fafa` — from gardener:oros-health-checkup-20261102-103514, reply_to `oros-health-checkup-20261102-103514` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-oros-health-checkup-20261102-103514-37fd8774fafa.md)

> oros health (11:55Z): the shared garden disk on oros-studio is at 60G free (87%), losing about 1.8G/h since 05:15Z. If that rate holds, it fills in about 33 hours, around 2026-11-03 21:00Z. I can't find the cause from inside the container: what I could measure under the garden mount is small, and removing about 20G of files today did not raise free space. That points to the Mac side (for example snapshots or something outside the garden directory), but this is not confirmed. Please check it from the Mac, for example with `tmutil listlocalsnapshots /` and a size scan of the disk. Your 11-01 notice on this is still unread in the inbox.

- `followup-gate-daemon-agent-tools-design-build` — from followup-gate:daemon-agent-tools-design-build, reply_to `daemon-agent-tools-design-build` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/followup-gate-daemon-agent-tools-design-build.md)

> Job "daemon-agent-tools-design-build" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.
>
> ## Follow-ups
> - Once #1497 lands, tick Phase 2c in the design document. I didn't edit it here so this branch wouldn't conflict with the open design PR.
> - Phase 7 (the endo-claude acceptance loop) is unblocked for its build step.
> - Phase 8 still needs your decision on Open Question 4: a daemon `provideHttpClient` formula or the `@endo/fetch` plugin.

- `watchdog-journal-worktree-fffail-oros-studio-garden-ce242c49` — from watchdog:journal-worktree-keeper, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-worktree-fffail-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-10-09T02:17:23Z, latest 2026-11-03T02:49:11Z).
> The SAME condition (`journal-worktree-fffail-oros-studio-garden-ce242c49`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> journal worktree /Users/dom/garden/journal could not fast-forward to origin/journal2 despite a clean, non-ahead tree; left UNTOUCHED. Inspect 'git -C /Users/dom/garden/journal status'. (host=oros-studio-garden-ce242c49)

- `20261031T162800Z-32f623` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261031T162800Z-32f623.md)

> awaiting maintainer — beyond proxy authority: gardener accountant-weekly-20261031-160509, msgid msg-accountant-weekly-20261031-160509-559ca58540a3.md — Re-slicing the weekly budget slate needs the maintainer's own `authorized_by` attestation (kriskowal). The proxy can't originate that, and the carried-forward slate stays in force until the maintainer replies.

- `improve-enforce-handler-wall-bound-split-halted` — from orchestrator:improve-enforce-handler-wall-bound-split-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/improve-enforce-handler-wall-bound-split-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: improve-enforce-handler-wall-bound-split
> orchestration-status: halted
> child: improve-enforce-handler-wall-bound-watchdog
> failure-kind: handler-timeout
> children-completed: 0
> children-total: 2
> halt-parked-remainder: improve-enforce-handler-wall-bound-regression
>
> Orchestration improve-enforce-handler-wall-bound-split HALTED: child improve-enforce-handler-wall-bound-watchdog stalled in flight for 2556s on host endolin-garden-ece02cb4 (handler-timeout=2400s, multiplier=1) (serial, on-child-failure=halt). 0/2 done before halt; parked remainder: improve-enforce-handler-wall-bound-regression

- `followup-gate-design-recursive-dynamodb-capabilities` — from followup-gate:design-recursive-dynamodb-capabilities, reply_to `design-recursive-dynamodb-capabilities` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/followup-gate-design-recursive-dynamodb-capabilities.md)

> Job "design-recursive-dynamodb-capabilities" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.
>
> ## Follow-ups
>
> - `build-recursive-dynamodb-capabilities`: implement `@endo/exo-dynamodb` on the Endo bot fork.
> - `build-minion-town-recursive-dynamodb-capabilities`: afterward, migrate the coupon ledger and confined issuer in a separate PR.
>
> Self-improvement: reported that the budget-request skill references a missing `request-budget.sh`; also notified the scholar of the missing DynamoDB library index entry.

- `20261105T162157Z-ca0266` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261105T162157Z-ca0266.md)

> foreman: proposed next step 'daemon-git-capability-phase-five-contract-tests-build' was rejected (duplicate), and the one re-prompt produced no valid replacement. The scripted foreman did not post it.

- `msg-minion-town-architecture-overview-20261019-80b9df68a568` — from gardener:minion-town-architecture-overview-20261019, reply_to `minion-town-architecture-overview-20261019` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-architecture-overview-20261019-80b9df68a568.md)

> minion.town architecture overview published (job minion-town-architecture-overview-20261019).
>
> URL: https://2ry66ivxikmvxgr67lmrgvlf44p7osbbgttnzlwsxrfcd3cjgs3q.ocap.site/
> Source: kriscendobot/minion.town main @ dc3240231cf11e7b618af77475353b95c2a9b0ac (2026-10-19), stated on the page with the date.
>
> Files (7): index.html, glossary.html, styles.css, overview.svg, mcp-ocap.svg, clip.svg, deploy.svg. All fetched back with curl (HTTP 200, correct content types) and cmp-identical to the local build. Published with powers = inert pet name `minion-town-architecture-inert` (empty writeText), never sites/@agent. No smoke clip was published, so nothing needed unpublishing.
>
> Sections: guests + Endo daemon, web service + guest API, MCP (OAuth as a thin admission layer over the guest facet), clips/shell/ocap.site framing + isolation, gateway (content + powers planes, GC, git remote), accounts + persistence, CD, probe + canary (marked built-not-live), in review/planned by topic only (closed beta admission, New Clip, Chat), public links, and a one-page glossary (guest, clip, partition, formula, pet name, coupon).
>
> Diagrams: hand-authored SVG (no mermaid, so no mermaid validation was needed); they parse as XML and render in light and in dark (CSS invert filter). Checked in Playwright at 375px: no horizontal scroll, no console errors, no failed requests. No inline script or style; same-origin assets only.
>
> Scrub checklist (grepped the built files, all clean): AWS account ids/long digit runs; ARNs; instance/zone/VPC/SG ids; IPv4 addresses, ports, loopback/localhost; host filesystem paths (/etc, /opt, /var, /srv, /home, ~/, state dirs); Secrets Manager names, SSM/SendCommand, env var and key names, .env/.service/systemd unit names, tokens (eyJ, sk_/pk_, PEM); region and provider resource names (DynamoDB/Cognito/S3); internal or subdomain hostnames (only minion.town and ocap.site appear); vulnerability/exploit wording. I also left out by hand: the anonymous guest credential's lack of rotation/revocation, the live listener topology, and any PR-level security detail. Links go only to public sites: minion.town, ocap.site, github.com/endojs/endo, ocapn.org, modelcontextprotocol.io, publicsuffix.org. The private repo is named in plain text as the source, not linked.
>
> Because a clip is immutable, a refresh will publish under a new hash.

- `20261027T045910Z-521539` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261027T045910Z-521539.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: claude-api-p1-registry
> - question (msgid msg-claude-api-p1-registry-0fd78e5b0e44.md)
> - tentative answer: Proxy/tentative (maintainer may revise): This is a progress/engineering request, so I'm treating it as proxyable. It is a garden-internal infrastructure fix with no authority grant, no outward-facing action, and no agoric-sdk scope.
>
> Direction to try first: add an ABI check to the project-worktree warm-cache path, probably in `scripts/jobs/ensure-project-worktree.sh`.
> 1. After the cache is restored or linked, probe each native module that is present, starting with `better-sqlite3`. Run `node -e "require('better-sqlite3')"` from the worktree, or compare the `process.versions.modules` value recorded at cache-build time with the active one.
> 2. If the probe fails with `NODE_MODULE_VERSION`, or the recorded ABI differs, run `yarn rebuild <module>` in the per-job worktree. Don't touch the shared cache from a job.
> 3. Stamp the warm cache with the Node ABI, for example a `.node-abi` file. On mismatch, either rebuild into the per-job copy or treat the cache as cold for native modules. Prefer the per-job rebuild, since it is cheapest and cannot poison peers.
> 4. Apply the `YARN_NODE_LINKER=node-modules YARN_NM_MODE=classic YARN_ENABLE_SCRIPTS=0` workaround only if the rebuild hits the EMLINK or native-build abort. Note that `YARN_ENABLE_SCRIPTS=0` skips build scripts, so the rebuild step must run explicitly.
>
> Options I considered:
> - Key the cache by ABI. This is cleaner but a bigger change.
> - Always rebuild natives. This is simple but slow.
> - Probe, then rebuild on failure. This is the cheapest correct option, and I'm picking it.
>
> Post this as a normal garden job, for example a fix job against the warm-cache script. Land it direct to `main2` as usual for garden-repo changes. Throw-away iteration is fine.

- `20261024T042224Z-4f5bf8` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261024T042224Z-4f5bf8.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: fu-design-recursive-dynamodb-capabilities-1
> - question (msgid msg-fu-design-recursive-dynamodb-capabilities-1-452cf7ab3ae4.md)
> - tentative answer: Proxy/tentative (the maintainer may revise): This is a progress question, so I'm answering it.
>
> 1. Keep [endojs/endo-but-for-bots#1545](https://github.com/endojs/endo-but-for-bots/issues/1545) as a DRAFT. Treat it as the gap-revealing build the job asked for, and don't take it out of draft. Make no outward-facing moves: no merging, no closing, no un-drafting, and no ferrying upstream.
> 2. Building against [kriscendobot/minion.town#221](https://github.com/kriscendobot/minion.town/issues/221) at commit 7eca8b82 is a reasonable reading of "landed design". The design is still a draft PR, so its shape is provisional. Say so in the [endojs/endo-but-for-bots#1545](https://github.com/endojs/endo-but-for-bots/issues/1545) PR body. Add a short gap report listing where the implementation diverged from, or exposed holes in, the design. If the design changes, [endojs/endo-but-for-bots#1545](https://github.com/endojs/endo-but-for-bots/issues/1545) may need rework, and that's acceptable throw-away cost.
> 3. Don't wait for the maintainer to confirm the spec. Finish the gap report and run the usual local checks. Then post your completion summary, noting that the build is provisional on the draft design. Per the probe convention, no panel, fix-loop or un-draft chain should follow. If the maintainer later wants it parked, they can close or park it.

- `watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #489 (first seen 2026-11-01T06:29:02Z, latest 2026-11-06T01:29:03Z).
> The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 489 times; this is ONE
> coalesced notice that updates in place, not 489 messages. Latest detail:
>
> Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to dd3e6bc6edfd 806 min ago
> but still reports deployed_sha 2c082b9acbc8684ec3a0ff42a398a31ce1978ee1. Check garden-self-deploy on oros-studio-garden-ce242c49
> (journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
> keeps it from advancing. The leader does not advance past an undeployed canary.
> (leader=endolin-garden-ece02cb4)

- `msg-oros-health-watch-20261104-185019-1236f736a3b1` — from gardener:oros-health-watch-20261104-185019, reply_to `oros-health-watch-20261104-185019` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-oros-health-watch-20261104-185019-1236f736a3b1.md)

> oros-health-watch 2026-11-04 22:25Z: INTERVENED (attested op), still stuck. oros-studio-garden-ce242c49 is alive (health fresh, sysop responsive, heartbeat 21:32Z, 20% used) but has been roll-drained since 12:16Z: it is the canary that was released to 7f0c3f7 about 10h ago and still reports deployed 746d220. The leader's roll is HALTED and holding, so three oros-health-checkup jobs (12:35, 15:50, 18:50) sit unclaimed in todo. Sent op=reset-failed and op=unit restart garden-self-deploy.timer (authorized_by=kriskowal); both were acked as applied at 21:57:45Z. 25 minutes later the sha had not moved. I did NOT lift the drain, because it is the leader's deliberate containment of a halted canary. Needs a person: on oros, run journalctl --user -u garden-self-deploy to find the hold or deferral blocking deploy-garden.sh, then either let it deploy 7f0c3f7 or lift the drain. Related: the coalesced watchdog rolling-deploy-canary-stuck-oros (195 notices since 11-01).

- `20261024T040209Z-2a6e36` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261024T040209Z-2a6e36.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: fu-design-recursive-dynamodb-capabilities-1
> - question (msgid msg-fu-design-recursive-dynamodb-capabilities-1-8dd2b123a8c7.md)
> - tentative answer: [proxy/tentative, the maintainer may revise] Wait. Do not implement from another design or branch.
>
> The design is not landed. Its job, `design-recursive-dynamodb-capabilities`, is still parked in `jobs/plan/` with `gate: deferred`. An implementation built without it would have to guess the intended capability shape, and that is likely to be throw-away work.
>
> Suggested path:
> 1. Block or park this implementation job on the design job. Use `blocked_on` or `post-plan.sh --blocked --blocked-on design-recursive-dynamodb-capabilities`, so it is promoted once the design reaches `tada/`.
> 2. Don't promote the design job yourself. Promoting a deferred plan is the maintainer's or liaison's call, and I can't do it from here.
> 3. If you want to make progress meanwhile, a throw-away spike is fine. Keep it to a clearly labeled DRAFT and a short gap report, in the style of [gap-revealing-build](skills/gap-revealing-build/SKILL.md). It must not be presented as the implementation, and it must not invent the design.
>
> If the maintainer would rather have the implementation start from an informal spec, they can say so and the job can be unblocked.

- `watchdog-container-hardening-pending-recreate-oros-studio-garden-ce242c49` — from watchdog:self-heal, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-container-hardening-pending-recreate-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-10-23T06:17:01Z, latest 2026-10-30T18:17:03Z).
> The SAME condition (`container-hardening-pending-recreate-oros-studio-garden-ce242c49`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> Container hardening is PENDING on oros-studio-garden-ce242c49: 2 launcher-posture check(s) fail (caps/sudo/block devices/mount).
>
> This is the expected state until the container is recreated with the hardened launcher,
> a maintainer step: context/operations/harden-container.md. The garden-container-hardening
> unit stays clean meanwhile (exit 3), so it does not fail rolling-deploy canaries. After the
> first all-pass run, any failure is treated as a regression and fails the unit.

- `watchdog-journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-lock-contention-_Users_dom_garden__garden_state_gardener_scaler_journal.md)

> Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.028203s, giveups=1, steals=0 (max 3/window), wait floor=60s.

- `ironhorse-ratchet-halted-ironhorse-test262-press-20261030-031712` — from ironhorse-test262-ratchet, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ironhorse-ratchet-halted-ironhorse-test262-press-20261030-031712.md)

> Ironhorse ratchet halted: wrong base
> Tracker: [https://github.com/kriscendobot/garden/issues/51](https://github.com/kriscendobot/garden/issues/51)
> Inspect ratchets/ironhorse-test262-ratchet/state.json and
> context/operations/ironhorse-ratchet.md. Explicitly resume only after resolution.

- `msg-minion-town-ci-runner-to-hosted-202610-retry2-f1ea05a1d94d` — from gardener:minion-town-ci-runner-to-hosted-202610-retry2, reply_to `minion-town-ci-runner-to-hosted-202610-retry2` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-ci-runner-to-hosted-202610-retry2-f1ea05a1d94d.md)

> minion.town CI is back on GitHub-hosted runners (CI_RUNS_ON="ubuntu-latest"); billing block cleared — probe run passed all 4 jobs on ubuntu-latest: https://github.com/kriscendobot/minion.town/actions/runs/41030164479/attempt/6 (ci.minion.town left up as warm standby; no deploy dispatched — next main push's deploy.yml will be the first hosted CD run).


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 160.6M | $605.76 _(notional, rate-card)_ | 59% of 271.0M (ok) |
| Codex | 356.4M _(fleet aggregate)_ | n/a _(ChatGPT pro plan — no per-token $; plan-metered)_ | 38% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 154914780 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 6.411401s/45s (/home/kris/garden/.garden-state/library-link-check/journal); 10 open notice(s); checker healthy

## Board
### todo (13)
- [`oros-health-checkup-20261105-103515`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261105-103515.md) — ---
- [`scholar-ingest-openai-scaling-git`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/scholar-ingest-openai-scaling-git.md) — ---
- [`oros-health-checkup-20261105-200509`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261105-200509.md) — ---
- [`oros-health-checkup-20261105-230510`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261105-230510.md) — ---
- [`scholar-ingest-meta-harnesses-codefall-ycc-20261029`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/scholar-ingest-meta-harnesses-codefall-ycc-20261029.md) — Ingest two meta-harness repositories: lividlabs/codefall and whyrusleeping/ycc
- [`scholar-ingest-fudco-gist-20261105`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/scholar-ingest-fudco-gist-20261105.md) — Ingest the FUDCo gist and report on it
- [`oros-health-checkup-20261105-165012`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261105-165012.md) — ---
- [`scholar-ingest-yavashark-ironhorse-20261030`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/scholar-ingest-yavashark-ironhorse-20261030.md) — Ingest Sharktheone/yavashark with an eye to Iron Horse
- [`scholar-ingest-nanoseedlm-20261013`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/scholar-ingest-nanoseedlm-20261013.md) — Ingest "NanoSeedLM: LLM inference using pseudo-random numbers" and report on ...
- [`oros-health-checkup-20261106-020511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261106-020511.md) — ---
- [`claude-on-minion-town-completion-press-20261106-020511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/claude-on-minion-town-completion-press-20261106-020511.md) — Completion press: Claude-on-minion.town arc
- [`oros-health-checkup-20261105-135010`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261105-135010.md) — ---
- [`scholar-ingest-edera-product-20261105`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/scholar-ingest-edera-product-20261105.md) — Ingest the Edera product page and report on it

### doin (6)
- [`improve-candidate-gate-empty-diagnostic-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/improve-candidate-gate-empty-diagnostic-r2.md) — ---
- [`oros-health-watch-20261106-020511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/oros-health-watch-20261106-020511.md) — ---
- [`design-daemon-git-remotes-ssh-transport-r2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/design-daemon-git-remotes-ssh-transport-r2.md) — ---
- [`minion-town-arc-press-20261106-020511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/minion-town-arc-press-20261106-020511.md) — Supervise the minion.town arc: carry its pull requests through review
- [`improve-gauntlet-notices-to-pr-20261106`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/improve-gauntlet-notices-to-pr-20261106.md) — ---
- [`improve-muster-autoarchive-watchdog-20261106`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/improve-muster-autoarchive-watchdog-20261106.md) — ---

### tada (16837)
- [`muster-daemon-git-remotes-20261106`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/11/06/muster-daemon-git-remotes-20261106.md) — orchestration muster-daemon-git-remotes-20261106 — complete
- [`muster-improve-fixes-20261106`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/11/06/muster-improve-fixes-20261106.md) — orchestration muster-improve-fixes-20261106 — complete
- [`kriscendobot-minion.town-pr243-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/11/05/kriscendobot-minion.town-pr243-gauntlet.md) — gauntlet kriscendobot-minion.town-pr243-gauntlet — HALTED
- [`endojs-endo-but-for-bots-pr1652-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/11/05/endojs-endo-but-for-bots-pr1652-gauntlet.md) — gauntlet endojs-endo-but-for-bots-pr1652-gauntlet — HALTED
- [`fix-minion-town-screener-proxy-timeout-20261105`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/11/05/fix-minion-town-screener-proxy-timeout-20261105.md) — Cost
- … and 16832 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`review-docket-consolidate-20261008`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/review-docket-consolidate-20261008.md) — _normal_ · ---
- [`revive-hermit-lane-qwen3.8-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/revive-hermit-lane-qwen3.8-20261001.md) — _normal_ · Revive the local hermit (on-box Ollama) lane, upgraded to qwen3.8
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`moddable-10-0-0-ironhorse-compiler-safety-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-compiler-safety-port.md) — _normal_ · Port Moddable 10.0.0 compiler safety corrections to IronHorse
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`make-panel-stage-survive-supervisor-session-exit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/make-panel-stage-survive-supervisor-session-exit.md) — _normal_ · Make panel execution survive supervising agent-session exit
- [`build-minion-town-recovery-outcome-screen-20261105`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-recovery-outcome-screen-20261105.md) — _normal_ · ---
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
- [`deadmail-issue-comment-6659790262`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deadmail-issue-comment-6659790262.md) — _normal_ · Issue follow-up — fold a late comment into the issue work
- [`open-signup-gate-flip-minion-town`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/open-signup-gate-flip-minion-town.md) — _normal_ · Build: open-signup gate flip for minion.town (Phase B — THE consequential cha...
- [`endojs-endo-but-for-bots-pr1595-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1595-gauntlet-panel-6.md) — _normal_ · Gauntlet stage: PANEL round 6 — endojs/endo-but-for-bots PR #1595
- [`moddable-10-0-0-ironhorse-callability-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-callability-port.md) — _normal_ · Port revoked-Proxy callability and constructability to IronHorse
- [`weave-endojs-endo-but-for-bots-pr1538`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-endojs-endo-but-for-bots-pr1538.md) — _normal_ · ---
- [`screen-minion-town-pr250-8060116-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/screen-minion-town-pr250-8060116-conduct.md) — _normal_ · Screened delegated merge: kriscendobot/minion.town#250 at 8060116d7e72d6109aa...
- [`screen-minion-town-pr237-4e2911d-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/screen-minion-town-pr237-4e2911d-conduct.md) — _normal_ · Screened delegated merge: kriscendobot/minion.town#237 at 4e2911dff11e922fda8...
- [`migrate-endo-but-for-bots-master-to-npm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-npm.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase2-module-source.md) — _normal_ · Build: SES import attributes — Phase 2 (module-source static with capture)
- [`assess-evaluator-gaming-followup-20260814`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/assess-evaluator-gaming-followup-20260814.md) — _normal_ · Reassess evaluator gaming with durable panel evidence
- [`design-minion-town-ocap-site-crawler-leak-rotation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/design-minion-town-ocap-site-crawler-leak-rotation.md) — _normal_ · Design: detect a crawler on an ocap.site page as a link-leak signal, and rotate
- [`kriscendobot-minion-town-pr183-open-findings-fix-20261015`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr183-open-findings-fix-20261015.md) — _normal_ · Fix the structural findings left open on kriscendobot/minion.town#183
- [`endojs-endo-but-for-bots-pr1498-gauntlet-undraft`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1498-gauntlet-undraft.md) — _normal_ · Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1498
- [`endopi-extension-package-guest-provider-kinds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endopi-extension-package-guest-provider-kinds.md) — _normal_ · ---
- [`minion-town-remote-guest-cli-live-proof`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-remote-guest-cli-live-proof.md) — _normal_ · ---
- [`minion-town-arc-press-20261105-200509`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261105-200509.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`kriscendobot-minion.town-pr199-weave-20261103`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr199-weave-20261103.md) — _normal_ · Weave kriscendobot/minion.town#199 onto current main
- [`build-minion-town-retire-resident-role-20261105`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-retire-resident-role-20261105.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1416-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1416-gauntlet-panel-2.md) — _normal_ · Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1416
- [`endojs-endo-but-for-bots-pr1430-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1430-gauntlet-clean.md) — _normal_ · Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1430
- [`endojs-endo-but-for-bots-pr1504-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1504-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1504
- [`fixer-endojs-endo-but-for-bots-pr1595`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/fixer-endojs-endo-but-for-bots-pr1595.md) — _normal_ · ---
- [`ebfb-llm-xs-daemon-bundle-reconcile`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-xs-daemon-bundle-reconcile.md) — _normal_ · ---
- [`build-readableblob-range-attenuation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-readableblob-range-attenuation.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`endojs-endo-but-for-bots-pr1433-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1433-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1433
- [`endojs-endo-but-for-bots-pr1652-gauntlet-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1652-gauntlet-fix-5.md) — _normal_ · Gauntlet stage: FIX round 5 — endojs/endo-but-for-bots PR #1652
- [`ironhorse-iterator-scenario-parity-maintainer-decision`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-iterator-scenario-parity-maintainer-decision.md) — _high_ · resolve the remaining acceptance scope for IronHorse iterator scenario parity
- [`migrate-endo-but-for-bots-master-to-pnpm`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/migrate-endo-but-for-bots-master-to-pnpm.md) — _normal_ · ---
- [`cutover-budget-road`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/cutover-budget-road.md) — _normal_ · Cut over to the budget road
- [`minion-town-arc-press-20261105-230510`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261105-230510.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`endojs-endo-but-for-bots-pr546-gauntlet-20261007-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr546-gauntlet-20261007-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #546
- [`screen-minion-town-pr246-93329d9-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/screen-minion-town-pr246-93329d9-conduct.md) — _normal_ · Screened delegated merge: kriscendobot/minion.town#246 at 93329d9faf0564a5791...
- [`endojs-endo-but-for-bots-pr1486-gauntlet-undraft`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1486-gauntlet-undraft.md) — _normal_ · Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1486
- [`endojs-endo-but-for-bots-pr909-fix-ts-make-daemon`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr909-fix-ts-make-daemon.md) — _normal_ · Fix: endo make / endo archive TypeScript support is broken (endojs/endo-but-f...
- [`improve-gardener-handler-rc76-collision-expanded-window`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-gardener-handler-rc76-collision-expanded-window.md) — _normal_ · Land the gardener fix for spooled review-docket notices failing finished jobs
- [`minion-town-arc-press-20261105-165012`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261105-165012.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`ironhorse-xs10-proxy-callable-flags`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-xs10-proxy-callable-flags.md) — _normal_ · IronHorse: Proxy [[Call]]/[[Construct]] flags survive revocation (XS 10.0.0 #...
- [`endojs-endo-but-for-bots-pr1529-gauntlet-undraft`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1529-gauntlet-undraft.md) — _normal_ · Gauntlet stage: UNDRAFT — endojs/endo-but-for-bots PR #1529
- [`endojs-endo-but-for-bots-pr1348-review-4984e562`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1348-review-4984e562.md) — _normal_ · Review directive on endojs/endo-but-for-bots PR #1348
- [`moddable-10-0-0-ironhorse-oracle-validation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-oracle-validation.md) — _normal_ · Move the IronHorse oracle to Moddable 10.0.0 and validate the port campaign
- [`oros-health-watch-20261105-135010`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261105-135010.md) — _normal_ · ---
- [`build-usage-scrape-ingest`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-usage-scrape-ingest.md) — _normal_ · ---
- [`ironhorse-xs-oracle-bump-10-0-0`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-xs-oracle-bump-10-0-0.md) — _normal_ · IronHorse: bump the XS oracle to Moddable 10.0.0 and mirror the compiler deltas
- [`oros-health-watch-20261105-230510`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261105-230510.md) — _normal_ · ---
- [`endo-but-for-bots-pi-family-1x-upgrade`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-but-for-bots-pi-family-1x-upgrade.md) — _normal_ · endo-but-for-bots: upgrade the pi family (@earendil-works/*) to 1.x together
- [`kriscendobot-minion.town-pr243-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr243-gauntlet-fix-1.md) — _normal_ · Gauntlet stage: FIX round 1 — kriscendobot/minion.town PR #243
- [`drive-mystic-rollout-20260723`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/drive-mystic-rollout-20260723.md) — _low_ · ---
- [`kimi-k3-canary-20260723-c`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kimi-k3-canary-20260723-c.md) — _low_ · ---
- [`claude-on-minion-town-completion-press-20261105-133510`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-completion-press-20261105-133510.md) — _normal_ · Completion press: Claude-on-minion.town arc
- [`moddable-10-0-0-ironhorse-typedarray-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-typedarray-port.md) — _normal_ · Port Moddable 10.0.0 TypedArray corrections to IronHorse
- [`moddable-10-0-0-ironhorse-immutable-arraybuffer-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-immutable-arraybuffer-port.md) — _normal_ · Implement immutable ArrayBuffer and close the Moddable 10.0.0 validation camp...
- [`endojs-endo-but-for-bots-pr1538-gauntlet-panel-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1538-gauntlet-panel-6.md) — _normal_ · Gauntlet stage: PANEL round 6 — endojs/endo-but-for-bots PR #1538
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`kriscendobot-minion-town-pr148-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr148-gauntlet-viability.md) — _normal_ · Gauntlet stage: PRE-SPEND VIABILITY - kriscendobot/minion.town PR #148
- [`build-minion-town-waitlist-soon-page-20261105`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-waitlist-soon-page-20261105.md) — _normal_ · ---
- [`mirror-endo-3372`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/mirror-endo-3372.md) — _normal_ · Mirror endojs/endo#3372 onto endojs/endo-but-for-bots
- [`evaluate-reauth-escalation-default-after-oauth-relay-20260927`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/evaluate-reauth-escalation-default-after-oauth-relay-20260927.md) — _low_ · Evaluate default reauth escalation once the browser OAuth relay lands
- [`ironhorse-immutable-arraybuffer`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-immutable-arraybuffer.md) — _normal_ · IronHorse: implement Immutable ArrayBuffer and enable it in the oracle
- [`build-confined-application-makers-p2-20261002`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-confined-application-makers-p2-20261002.md) — _normal_ · Phase 2: daemon capture for node-modules-with-map and node-modules-scan layou...
- [`improve-gh-api-admission-fail-closed`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/improve-gh-api-admission-fail-closed.md) — _normal_ · ---
- [`claude-on-minion-town-completion-press-20261105-195009`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-completion-press-20261105-195009.md) — _normal_ · Completion press: Claude-on-minion.town arc
- [`minion-town-arc-press-20261105-135010`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-arc-press-20261105-135010.md) — _normal_ · Supervise the minion.town arc: carry its pull requests through review
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`minion-town-mcp-guide-remaining-slices-20261104`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-mcp-guide-remaining-slices-20261104.md) — _normal_ · Finish the MCP guide's remaining slices (kriscendobot/minion.town#235)
- [`endojs-endo-but-for-bots-pr1340-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1340-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1340
- [`endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper.md) — _normal_ · Build: SES import attributes — Phase 3 (compartment-mapper plumbing)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`oros-health-checkup-20261013-133505`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-checkup-20261013-133505.md) — _normal_ · Deliberate overrun decomposition for oros-health-checkup-20261013-133505
- [`oros-health-watch-20261105-165012`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261105-165012.md) — _normal_ · ---
- [`moddable-10-0-0-ironhorse-builtins-order-port`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-builtins-order-port.md) — _normal_ · Port three Moddable 10.0.0 built-in ordering corrections to IronHorse
- [`claude-on-minion-town-press-20261010-133536`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-press-20261010-133536.md) — _normal_ · Press the Claude-on-minion.town arc forward
- [`oros-health-watch-20261105-200509`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/oros-health-watch-20261105-200509.md) — _normal_ · ---
- [`build-claude-usage-dashboard-scraper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-claude-usage-dashboard-scraper.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr1379-gauntlet-20261007-fix-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1379-gauntlet-20261007-fix-5.md) — _normal_ · Gauntlet stage: FIX round 5 — endojs/endo-but-for-bots PR #1379
- [`screen-minion-town-pr252-755d017-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/screen-minion-town-pr252-755d017-conduct.md) — _normal_ · Screened delegated merge: kriscendobot/minion.town#252 at 755d017997d34c46348...
- [`heal-minion-town-cfafabe`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/heal-minion-town-cfafabe.md) — _normal_ · Heal minion.town production after merge cfafabea5a93f0d270980d4b468841c0565b3a3a

### awaiting maintainer decision (answer at the linked question)
- [`minion-town-claude-cli-production-canary-after-connection-20261004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-claude-cli-production-canary-after-connection-20261004.md) - [Connect the real Claude subscription through the stable account page and reply connected; no setup token may be sent through the journal.](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-minion-town-claude-cli-production-canary-20261004-224cae8c9188.md)
- [`endo-cli-no-autostart-exit-codes-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-cli-no-autostart-exit-codes-build.md) - [Design OQ1/OQ3: should the CLI default to no-autostart under a service manager, and are the proposed exit codes acceptable?](https://github.com/endojs/endo-but-for-bots/pull/1383)
- [`ironhorse-test262-ratchet-round3-floor-resolution-20260928`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-test262-ratchet-round3-floor-resolution-20260928.md) - [Reconcile the historical floor with current verdict/resource policy, or restore all 901 genuinely under unchanged pins and policy?](https://github.com/kriscendobot/garden/issues/51#issuecomment-5877917421)
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
- [`endo-minion-town-federation-release-gate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-minion-town-federation-release-gate.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1124` · Gate: reviewed and deployable federation release
- [`endojs-endo-but-for-bots-pr1347-weave-after-pr1585`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1347-weave-after-pr1585.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1585` · ---
- [`endojs-endo-but-for-bots-pr1602-weave-after-pr1585`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1602-weave-after-pr1585.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1585` · ---
- [`conduct-endojs-endo-but-for-bots-pr1575-endolin`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/conduct-endojs-endo-but-for-bots-pr1575-endolin.md) — awaiting `weave-endojs-endo-but-for-bots-pr1575-onto-llm-after-pr1573` · Conduct endojs/endo-but-for-bots PR #1575
- [`claude-api-p3-minion-ui`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-api-p3-minion-ui.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1575` · Phase 3: minion.town provider endpoint, UI step, and Providers page
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
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
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`build-exo-sheets-service`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-sheets-service.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`conduct-endojs-endo-but-for-bots-pr1573-after-pr1646`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/conduct-endojs-endo-but-for-bots-pr1573-after-pr1646.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1646` · Conduct endojs/endo-but-for-bots PR #1573 after the Node pin lands
- [`endojs-endo-but-for-bots-pr1501-weave-after-pr1585`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1501-weave-after-pr1585.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1585` · ---
- [`build-minion-town-guest-coupons-phase1-rest`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-guest-coupons-phase1-rest.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/199` · Build the rest of guest-coupons phase 1 on kriscendobot/minion.town
- [`ironhorse-fuzz-triage-differential_source-efffacee3e2a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-triage-differential_source-efffacee3e2a.md) — awaiting `https://github.com/kriscendobot/garden/issues/91` · Triage 7 Ironhorse fuzz finding(s) for target differential_source
- [`minion-town-ui-gutter-mint`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/minion-town-ui-gutter-mint.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/142` · Gutter: the + button mints a real clip (minion-town-ui increment)
- [`weave-endojs-endo-but-for-bots-pr1575-onto-llm-after-pr1573`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/weave-endojs-endo-but-for-bots-pr1575-onto-llm-after-pr1573.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1573` · Weave endojs/endo-but-for-bots PR #1575 onto llm after its parent #1573 merges

## Watch set
kriscendobot-minion.town kriscendobot-garden-book kriscendobot-cosgov kriscendobot-ocapn kriscendobot-oros-ckm-data-readiness kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 3 monks
- [.archived-endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-endolin-garden2-5bcdff64): 1 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 3 monks
