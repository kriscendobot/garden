# Garden bulletin

_As of 2026-09-30T19:24:19Z_

## Latest

The sturdyref-layer gauntlet stack kept grinding: layers 1, 4, 5, and 6 posted fresh panel rounds ([endojs-endo-but-for-bots#774](https://github.com/endojs/endo-but-for-bots/pull/774), [#1393](https://github.com/endojs/endo-but-for-bots/pull/1393), [#1394](https://github.com/endojs/endo-but-for-bots/pull/1394), [#1396](https://github.com/endojs/endo-but-for-bots/pull/1396)), layer 3 reached panel round 3 ([#1392](https://github.com/endojs/endo-but-for-bots/pull/1392)), and layers 7 and 8 both moved to CLEAN ([#1397](https://github.com/endojs/endo-but-for-bots/pull/1397), [#1398](https://github.com/endojs/endo-but-for-bots/pull/1398)) — a follow-up job is queued to rebase #1397/#1398 onto the restacked frozen bases. Layer 2 ([#1391](https://github.com/endojs/endo-but-for-bots/pull/1391)), by contrast, HALTED after its fourth fix round was explicitly declined, and needs a look before it can continue. The petname-path-only sweep ([#1390](https://github.com/endojs/endo-but-for-bots/pull/1390)) is mid-fix-loop (rounds 1 and 2 in progress, round 3 queued).

Elsewhere, a fresh Endo progress report (June 24–Sept 30) is published, and the reaper parked two more split-eligible jobs needing a human decision: the fleet-wide deploy-gate regression fix and the gardener-worker-kind alias cleanup. Claude spend is essentially at its weekly cap (99% of 256.0M tokens).

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#1282](https://github.com/endojs/endo-but-for-bots/pull/1282) — chore(ironhorse): demolish the XS-computron-parity myth (waiting 3d)
- [endojs/endo-but-for-bots#1281](https://github.com/endojs/endo-but-for-bots/pull/1281) — fix(ses): silence lockdown intrinsics report for the WHATWG URL family (waiting 12d)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 18d)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 27d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 28d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 28d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 30d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 28d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 28d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 32d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Screened by proxy (minion.town)

(delegation not armed)

## Messages to the maintainer

- `watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-host-offline-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-09-30T17:38:07Z, cleared 2026-09-30T17:56:10Z).
> It was observed 6 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> heartbeat resumed for oros-studio-garden-ce242c49; it is PRESENT again and will automatically rejoin the canary rotation while its hosts/oros-studio-garden-ce242c49 record remains active. Archived records are not unarchived automatically.

- `msg-ironhorse-test262-ratchet-round3-20260928-0d0c921abeb6` — from gardener:ironhorse-test262-ratchet-round3-20260928, reply_to `ironhorse-test262-ratchet-round3-20260928` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ironhorse-test262-ratchet-round3-20260928-0d0c921abeb6.md)

> Decision needed for round 3: the completed current-llm sweep has 906 lost paths against the historical floor BEFORE my changes: 443 engine-limit aborts, 397 shared-positive-test-failure, 66 other. Several hundred historical covered cases were false positives under the old classifier; I will not mark them covered or weaken the current classifier. May the draft record an explicitly reconciled current-llm floor (36,599 covered) and defend zero loss against that, retaining all 906 historical dispositions for follow-up? Otherwise this round's literal superseding-floor acceptance cannot be honestly met in one constants-descriptor crank. The proposed fix already has 5 red-before/green-after dual-run tests and repairs Math/Number/TypedArray numeric constant attributes; full Rust gates and an after sweep are next.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_issue_inbox_verify` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_issue_inbox_verify.md)

> RECOVERED — the watchdog condition `journal-clone-oversized-_home_kris_garden__garden_state_issue_inbox_verify` has CLEARED (first seen 2026-09-30T17:22:15Z, cleared 2026-09-30T18:47:20Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-clone-oversized-_home_kris_garden__garden_state_issue_inbox_verify` cleared on endolin-garden-ece02cb4.

- `doomed-fix-subscription-model-deploy-gate-regression-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-fix-subscription-model-deploy-gate-regression-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/fix-subscription-model-deploy-gate-regression; it stays HELD until a human promotes it
> (promote-plan.sh fix-subscription-model-deploy-gate-regression) or removes it, so nothing is lost.
> Original job base: fix-subscription-model-deploy-gate-regression
>
> --- original job body ---
> ---
> role: fixer
> tier: mentor
> token-budget: 100000
> ---
> <!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-09-29T23:09:05Z cleared=none -->
>
> ---
> role: fixer
> tier: mentor
> token-budget: 100000
> ---
> <!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-09-29T14:34:21Z cleared=none -->
>
> ---
> role: fixer
> tier: mentor
> fallback-tier: minion
> dispatch: automatic
> ---
> # Fix deploy-gate regression from subscription-based-budget-model
>
> This is blocking deploys FLEET-WIDE. garden2's deploy attempt on 2026-09-20
> (candidate `6c7e49cab6`) and the leader's deploy attempt just now on
> 2026-09-21 (candidate `7070fc7e9c`) both rejected on the SAME three suites:
> `signal-kill-classifier-test.sh`, `retry-narrowing-test.sh`,
> `provider-cooldown-test.sh`. This has been silently stalling the fleet's
> deploy pipeline for at least two days.
>
> ## Strong lead: this is fallout from `subscription-based-budget-model`
>
> `provider-cooldown-test.sh` subtest 9 fails with:
>
> ```
> unrecognized inference source unknown:anthropic:envelopehost:gardener;
> treat it as depleted and ask the maintainer for a token count and target
> spend date before enabling it
> ```
>
> That is the EXACT "ask before an unknown token source" refusal gate added
> by `subscription-based-budget-model` (job tada report:
> `jobs/tada/2026/09/20/subscription-based-budget-model.md` if still flat, or
> search sharded — grep for "real code gates refusing unknown token sources").
> That gate is correctly firing — the test's own fixture uses a placeholder
> pool name (`envelopehost`) that was never one of the four real registered
> subscriptions (`claude-endolin1`, `claude-endolin2`, `claude-oros`,
> `codex-endolin`) and was never updated when the gate landed. **The gate's
> behavior is not the bug — the stale test fixture is.**
>
> The other two failing suites (`signal-kill-classifier-test.sh`,
> `retry-narrowing-test.sh`) both exercise `doin`/claim/retry/reap mechanics —
> plausibly hitting the SAME new admission-gate code path from a different
> angle, since that job's own report says it added gates in `claim-job.sh`
> and "provider handlers" too, not just the budget layer. Trace this
> precisely rather than assuming; don't just patch the one confirmed case and
> hope the other two are unrelated coincidences on the same day.
>
> ## Full diagnostic logs (already captured, don't re-run to reproduce first — read these)
>
> - `.garden-state/deploy/candidate-gate-diagnostics/7070fc7e9c786255915e5f93cdc10455ec785d5b/02-scripts_jobs_test_signal-kill-classifier-test.sh.log`
> - `.garden-state/deploy/candidate-gate-diagnostics/7070fc7e9c786255915e5f93cdc10455ec785d5b/04-scripts_jobs_test_retry-narrowing-test.sh.log`
> - `.garden-state/deploy/candidate-gate-diagnostics/7070fc7e9c786255915e5f93cdc10455ec785d5b/09-scripts_jobs_test_provider-cooldown-test.sh.log`
>
> (host-local on `endolin-garden-ece02cb4`, this host; if claimed elsewhere,
> re-run the three suites locally against `main2` tip to reproduce — they
> should fail identically, this is not a flake, it's failed reproducibly
> across two different candidates two days apart.)
>
> signal-kill-classifier-test.sh specifics worth noting: "handler sentinel
> empty/absent", "job not left in doin (doin=n tada=n)", "no reap-now hint on
> the doin claim", "doom-cycle counter NOT stamped on the requeued hinted
> job" — 5/17 subtests fail. retry-narrowing-test.sh: "plain retry was
> claimable before not-before", `awk: cannot open "jobs/doin/plain.md"`,
> "retry policy decision ledger rows are missing or malformed" — 4/16
> subtests fail.
>
> ## Fix
>
> For the confirmed case: update `provider-cooldown-test.sh`'s fixture to use
> a real subscription id (or a test-harness-recognized synthetic-but-allowed
> marker, if one exists/should exist for hermetic tests specifically — check
> whether the new admission gate has or needs a test-mode escape hatch
> distinct from silently exempting real unknown-source traffic, which must
> stay refused). Do NOT weaken the actual refusal gate's production behavior
> to make the test pass — the gate protecting against silently-enabled
> unknown token sources is exactly what the maintainer asked for; fix the
> test's stale fixture, not the gate.
>
> For the other two suites: trace to the actual root cause (likely the same
> admission-gate change reached through `claim-job.sh`, per the above) and
> fix precisely — again, fix test fixtures/harness setup that predates the
> new gate, don't weaken the gate itself, unless you find a GENUINE bug in
> the gate's own logic (not just a stale fixture), in which case fix that
> and say so explicitly in your report.
>
> ## Verify and report
>
> Full local test suite green, not just these three. Confirm which of the
> two "unconfirmed" suites actually share the root cause with the confirmed
> one, and which (if any) turn out to be unrelated — say so plainly either
> way, don't just assume. This unblocks deploys on EVERY host once it lands
> and rolls out — say that explicitly in your completion report so its
> priority is clear to whoever reads it next.

- `stale-panel-head-endojs-endo-but-for-bots-pr1357-50917af1-1ff1c08e` — from gardener:claude-on-minion-town-press-20260930-185007, reply_to `claude-on-minion-town-press-20260930-185007` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/stale-panel-head-endojs-endo-but-for-bots-pr1357-50917af1-1ff1c08e.md)

> COALESCED message — occurrence #2 (first seen 2026-09-30T17:40:13Z, latest 2026-09-30T19:19:57Z).
> The SAME message (episode key `stale-panel-head-endojs-endo-but-for-bots-pr1357-50917af1-1ff1c08e`) has now been sent 2 times; this is
> ONE entry that updates in place, not 2 messages. Latest detail:
>
> Stale panel coverage for completed job `claude-on-minion-town-press-20260930-185007`: [https://github.com/endojs/endo-but-for-bots/pull/1357](https://github.com/endojs/endo-but-for-bots/pull/1357) moved from panel-reviewed head `50917af1a439419d6ccc5b91ceb11acb0c5bff59` to presented head `1ff1c08e71ecec6717004bb2c7060c360163c1e8`.
>
> Disposition: **review required**. The earlier panel does not cover the current head; every commit delta is conservatively review-relevant. A PR metadata-only edit would leave the head unchanged and would not trigger this disposition.
>
> No gauntlet was staged. Route the current head through the existing panel stage only after an explicit maintainer `run the gauntlet` request, or make a maintainer review decision with the stale coverage stated explicitly.

- `20260929T131950Z-276daa` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260929T131950Z-276daa.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: activate-ironhorse-ratchet-autopilot-20260929-r4
> - question (msgid msg-activate-ironhorse-ratchet-autopilot-20260929-r4-8e94bede58af.md)
> - tentative answer: Proxy/tentative (maintainer may revise): diagnosis and fix look right — go ahead and let the roll proceed on 25123fdae03, no need to wait for me on that part. Deferring the arc-budget press seed until after the leader deploys is the right call given no cap reply yet on [kriscendobot/garden#51](https://github.com/kriscendobot/garden/issues/51). On oros-studio-garden-ce242c49: I can't act on a genuinely offline host from here, so leave it flagged for the maintainer's own follow-up — don't block the roll on it (correct that it should keep skipping that host). Continue as planned.

- `watchdog-budget-pool-refuse-claude-endolin1` — from watchdog:claim/2, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-pool-refuse-claude-endolin1.md)

> WATCHDOG notice — occurrence #4603 (first seen 2026-09-30T11:07:45Z, latest 2026-09-30T19:08:31Z).
> The SAME condition (`budget-pool-refuse-claude-endolin1`) has now been observed 4603 times; this is ONE
> coalesced notice that updates in place, not 4603 messages. Latest detail:
>
> claim gate is FAIL-CLOSED on endolin-garden-ece02cb4: budget pool claude-endolin1 cap is UNCALIBRATED (provenance placeholder); promote a calibrated cap to admit: set-budget-pool.sh claude-endolin1 <weekly-token-cap> <calibrated-from>. No job will be claimed on this host until a calibrated cap is set.

- `msg-research-endo-progress-report-ocap-site-20260930-d0a41eec57ad` — from gardener:research-endo-progress-report-ocap-site-20260930, reply_to `research-endo-progress-report-ocap-site-20260930` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-research-endo-progress-report-ocap-site-20260930-d0a41eec57ad.md)

> Endo progress report (2026-06-24 to 2026-09-30) is published: https://hllk2wmfocuoijaliiapckuth4f3qxqlvo5vjwzywazvawvrqaiq.ocap.site/
>
> It covers product capability, not garden throughput: 471 merged ebfb PRs (412 code, 59 design-only); how the llm roadmap moved (M3 is still the first incomplete milestone, 40 rows changed status, 38 new designs); what shipped in six themes (agent substrate: mounts/git/tools/code mode; daemon OCapN-Noise and iroh; guest invite/accept, MCP and @endo/claude; endor npm-via-CAS; IronHorse, with test262 going from 4,740 to 37,285 of 51,976; chat/UX); and callouts. Note: only 6 of the 471 merges targeted master (the last on 07-13). In practice implementations land on llm under the package-availability rule, so the report separates shipped from proposed by PR content, not by base branch.

- `watchdog-comment-ack-blind-endojs-endo-but-for-bots` — from watchdog:comment-latency-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-ack-blind-endojs-endo-but-for-bots.md)

> WATCHDOG notice — occurrence #51 (first seen 2026-09-30T04:37:42Z, latest 2026-09-30T19:22:42Z).
> The SAME condition (`comment-ack-blind-endojs-endo-but-for-bots`) has now been observed 51 times; this is ONE
> coalesced notice that updates in place, not 51 messages. Latest detail:
>
> Comment acknowledgment blind anomaly for endojs/endo-but-for-bots:
> [https://github.com/endojs/endo-but-for-bots/pull/1386](https://github.com/endojs/endo-but-for-bots/pull/1386)#issuecomment-5913442822 (age=17182s; heartbeat=full-poll)

- `watchdog-budget-zone-endolin-garden2-5bcdff64-backoff` — from watchdog:gardener-scaler, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-zone-endolin-garden2-5bcdff64-backoff.md)

> subscription claude-endolin2 changed zone ok -> backoff at spend=104614664/121000000.

- `20260929T162945Z-aef3a3` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260929T162945Z-aef3a3.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: activate-ironhorse-ratchet-autopilot-20260929-r4
> - question (msgid msg-activate-ironhorse-ratchet-autopilot-20260929-r4-6c7e0f95aff8.md)
> - tentative answer: Proxy/tentative: Thanks for the update — no gating decision needed here, this reads as a status report. The plan sounds right: let r4 end now so the leader's single monk frees up for deploy-garden.sh, and let the one-time schedule (activate-ironhorse-ratchet-autopilot-20260929-r5, firing 17:15Z) pick up verifying the deployed gates, seeding the first press, and reporting on [kriscendobot/garden#51](https://github.com/kriscendobot/garden/issues/51). Good call building in the self-reschedule if the leader still hasn't deployed by then rather than blocking. Retiring the legacy ironhorse-ratchet schedule in favor of this one is fine to proceed with. No action needed from me — proceed as planned; the maintainer can revise if they see this differently.

- `ebfb-sturdyref-layer2-ses-20260930-gauntlet-halted` — from gauntlet:ebfb-sturdyref-layer2-ses-20260930-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer2-ses-20260930-gauntlet-halted.md)

> Gauntlet ebfb-sturdyref-layer2-ses-20260930-gauntlet HALTED: stage 'ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `watchdog-journal-contention-watch-overrun` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-watch-overrun.md)

> RECOVERED — the watchdog condition `journal-contention-watch-overrun` has CLEARED (first seen 2026-09-30T17:42:50Z, cleared 2026-09-30T19:17:57Z).
> It was observed 5 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-contention-watch-overrun` cleared on endolin-garden-ece02cb4.

- `watchdog-comment-provenance-gap-endolin-garden-ece02cb4` — from watchdog:comment-provenance, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-provenance-gap-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #23 (first seen 2026-09-29T00:26:19Z, latest 2026-09-30T19:08:04Z).
> The SAME condition (`comment-provenance-gap-endolin-garden-ece02cb4`) has now been observed 23 times; this is ONE
> coalesced notice that updates in place, not 23 messages. Latest detail:
>
> comment-provenance INSTRUMENTATION GAP on host endolin-garden-ece02cb4: a fleet `gh` comment was posted by an LLM-driven caller, but NEITHER GARDEN_JOB_MODEL NOR GARDEN_WORKER_KIND resolved — so the footer named only the host and garden commit (no model/harness/provider). This is the PR #1125 defect. The comment STILL posted (fail-open); nothing is broken. FIX: find the code path posting the comment and export the job facts (GARDEN_JOB_MODEL + GARDEN_WORKER_KIND) before its `gh` call, OR set GARDEN_NO_LLM=1 if it is a deterministic (no-LLM) post.

- `20260928T175544Z-3d14da` — from deploy-garden, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T175544Z-3d14da.md)

> kind: error
>
> # Deploy candidate test gate rejected main2
>
> candidate: `39d0c5ef0aca4f55612eb774f13fb5907ec3a769`
> failing suites: scripts/jobs/test/triager-pacing-test.sh(rc=1; diagnostic=/home/kris/garden/.garden-state/deploy/candidate-gate-diagnostics/39d0c5ef0aca4f55612eb774f13fb5907ec3a769/attempt2-01-scripts_jobs_test_triager-pacing-test.sh.log)
>
> Each executed failing suite above names its bounded stdout/stderr diagnostic. Diagnostics
> are host-local on `endolin-garden-ece02cb4` and retain at most
> `16384` bytes of output per suite.
>
> The deployed tree was left in place. Set `GARDEN_DEPLOY_TEST_OVERRIDE=1` only
> for a deliberate emergency deploy after assessing this failure.

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

- `20260901T210951Z-6f6a42` — from gardener:probe-opencode-anthropic, reply_to `probe-opencode-anthropic` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260901T210951Z-6f6a42.md)

> The opencode-anthropic probe is blocked from its paid canary on this host: opencode 1.18.25 is not installed and neither ANTHROPIC_API_KEY nor stored opencode credentials are present. I can implement and verify the refused-key and killed-run paths locally, but real non-censored Anthropic USD cost requires a credential. Please provision an Anthropic API key into the worker environment if available; otherwise I will report that criterion as an observed gap.

- `watchdog-self-heal-garden-mentor` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-self-heal-garden-mentor.md)

> WATCHDOG notice — occurrence #6 (first seen 2026-09-25T20:50:35Z, latest 2026-09-26T00:50:38Z).
> The SAME condition (`self-heal-garden-mentor`) has now been observed 6 times; this is ONE
> coalesced notice that updates in place, not 6 messages. Latest detail:
>
> self-heal: garden-mentor exited rc=1 with no scoped fix. Capture: a60755470134df0e33803cdb0450d853923e87b8 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p a60755470134df0e33803cdb0450d853923e87b8). Diagnosis: This is the entire log — every configured provider was exhausted at the moment mentor ticked: `openai` (codex-endolin subscription at high water), `local` (no ollama unit running on either :11435 or :11434), and `anthropic` (Claude quota at high-water mark). This is a transient/environmental resource-exhaustion condition, not a code defect — the "FATAL" is the correct, deliberate behavior: it leaves markers so the next tick retries once quota/capacity frees up. There's nothing to fix in code; the fleet is simply between providers at this moment (consistent with prior known quota-throttle episodes).
>
> No JOB block — this is transient provider exhaustion (all three configured inference providers were simultaneously unavailable), not a code defect. Mentor's own fallback logic already han

- `20260929T083913Z-b50775` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260929T083913Z-b50775.md)

> proxy answered a gating question (tentative — review and override):
> - gardener: build-ironhorse-foreman-woken-press
> - question (msgid msg-build-ironhorse-foreman-woken-press-8b3b965cce7b.md)
> - tentative answer: Proxy/tentative (maintainer may revise). Go with your proposed 6-hour press interval — it matches the cadence other review-arc presses already run on, and lands with the arc disabled from promotion, so there's no live-quota risk yet.
>
> For the rolling per-arc budget: given the fleet's recent history of quota self-throttles and outages (weekly-limit exhaustion, budget-pool misconfig), start conservative rather than generous — propose a rolling window equal to 4x the press interval (24h) rather than per-press, so a slow arc can't burn its whole allotment in one engagement: **~750K tokens rolling per 24h window per arc**, refilled continuously (not a hard reset at midnight). Treat the first 2-3 engagements as calibration: log actual consumption per engagement once you seed it, and if real usage lands well under/over 750K/24h, adjust before wider rollout — don't hold the mechanism gated on getting this number exactly right the first time.
>
> Land the mechanism now with promotion disabled as you planned; seed the first engagement only after this window/budget pair is in place, then watch actual spend for a cycle or two before flipping promotion on.

- `msg-ironhorse-test262-ratchet-round3-20260928-a4a854a44c5f` — from gardener:ironhorse-test262-ratchet-round3-20260928, reply_to `ironhorse-test262-ratchet-round3-20260928` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-ironhorse-test262-ratchet-round3-20260928-a4a854a44c5f.md)

> The round-3 branch-point sweep at llm 47f6965d88 is nearly complete. Current runner semantics explicitly demote positive tests where both engines abort; the September 4 floor included those as covered. Already 397 historical covered paths are now shared-positive-test-failure, independently of engine regressions. The current runner also exposes thousands of failures formerly called wrong-throw skips. I am fixing actual floor regressions first (Object.getOwnPropertyDescriptor misses lazy intrinsic accessors), preserving the stricter classifier. A literal zero-lost comparison to the historical floor may require an explicitly documented policy reconciliation; I will report exact lost paths and reasons rather than relabeling failures as covered.

- `watchdog-budget-level-monk-preflight` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-preflight.md)

> fleet monk allocation frozen: claude-endolin1 uncalibrated provenance 'placeholder'. No monk count may rise; only a calibrated host already over its own high-water mark may step down toward the floor.

- `20260928T174815Z-192b50` — from foreman, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260928T174815Z-192b50.md)

> M2’s next unblocked step is advancing the CI-green draft `endojs/endo-but-for-bots#1349` for `hardened-text-codecs-shim`. Decide whether to authorize `run the gauntlet #1349`; the manual gauntlet trigger is required before fleet work can proceed.

- `endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached` — from gauntlet:endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached.md)

> INFO: Gauntlet endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-journal-contention-storm-clone-oversized` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-storm-clone-oversized.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-30T17:08:04Z, latest 2026-09-30T19:08:14Z).
> The SAME condition (`journal-contention-storm-clone-oversized`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> Journal contention storm on endolin-garden2-5bcdff64: 7 clones hit clone-oversized in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/issue-inbox/verify: awaiting a healthy post-rebuild fetch; size=47377408B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/dependabot-watcher/verify: awaiting a healthy post-rebuild fetch; size=48050176B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/ci-watcher/retire: awaiting a healthy post-rebuild fetch; size=47344640B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/ci-watcher/verify: awaiting a healthy post-rebuild fetch; size=48037888B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/fireworkers/1/journal: awaiting a healthy post-rebuild fetch; size=48944128B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/comment-watcher/verify: awaiting a healthy post-rebuild fetch; size=48939008B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/approval-reconciler/verify: awaiting a healthy post-rebuild fetch; size=48019456B packs=1 gc.log=0; automatic remedy=none.

- `20260810T233049Z-59e2c4` — from gardener:fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1, reply_to `fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20260810T233049Z-59e2c4.md)

> The ocap.site implementation, DNS records, certificates, deployment, and live/browser validation are complete. One owner-gated design prerequisite remains: Route53 reports the ocap.site zone as NOT_SIGNING and public DNS has no DS record. The approved design requires DNSSEC before publication. Please confirm whether you want the fleet to create the Route53 KSK/signing configuration; publishing the resulting DS record at the registrar still requires your registrar authority. I have not improvised that owner-side change.

- `doomed-retire-gardener-worker-kind-alias-env-fallback-requeue-exhausted` — from reaper:endolin-garden-ece02cb4, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/doomed-retire-gardener-worker-kind-alias-env-fallback-requeue-exhausted.md)

> SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
> The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
> The work is preserved at jobs/plan/retire-gardener-worker-kind-alias-env-fallback; it stays HELD until a human promotes it
> (promote-plan.sh retire-gardener-worker-kind-alias-env-fallback) or removes it, so nothing is lost.
> Original job base: retire-gardener-worker-kind-alias-env-fallback
>
> --- original job body ---
> ---
> tier: mentor
> token-budget: 100000
> ---
> <!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-29T20:19:07Z cleared=none -->
>
> ---
> tier: mentor
> fallback-tier: minion
> token-budget: 100000
> dispatch: automatic
> ---
> Child 1/2 of orchestration `retire-gardener-worker-kind-alias-split` (split of
> `retire-gardener-worker-kind-alias` after a 2400s deadline overrun).
>
> Context: the bulk of the legacy `gardener` worker-kind retirement already landed on
> `main2` in commit `02513cd130f` ("refactor(jobs): retire gardener worker kind":
> common.sh registry/decoder, handlers/gardener-claude.sh + set-gardeners.sh +
> migrate-host-to-monk.sh deleted, reputation-reduce dual projection dropped,
> install-units RETIRED_UNITS prunes `garden-gardener@.service`, compat/cutover tests
> removed). `journal/hosts/*` no longer carry a `gardeners:` line. DO NOT redo that work.
>
> Scope of THIS child: remove the residual legacy env alias `GARDEN_GARDENER_CLONE`
> and stale `gardener-claude.sh` references, keeping `GARDEN_WORKER_CLONE` only.
>
> - Fallback readers: `claim-job.sh:~188`, `complete-job.sh:~39`, `gardener.sh:~74-78`
>   (stop exporting `GARDEN_GARDENER_CLONE`), `usage-meter.sh` (~130/503/523),
>   `usage-append.sh:11` (reads ONLY the legacy var — switch it to
>   `GARDEN_WORKER_CLONE`, and check `GARDEN_GARDENER_ID` vs the spine's id var).
> - Library scripts that read ONLY the legacy var (switch to `GARDEN_WORKER_CLONE`, or
>   the break is silent): `regenerate-topics-counts.sh`, `regenerate-sections-index.sh`,
>   `library-slug-prefix-check.sh`, `library-link-check.sh` (help text too); comment in
>   `auction.sh:~123`.
> - Stale comments naming `gardener-claude.sh` → `monk-claude.sh`: `common.sh`
>   (~3840, ~8867, ~9061), `gardener.sh` (~532, ~1241), `ensure-project-worktree.sh`
>   (~23, ~35), `handlers/cleric-codex.sh` (~202).
> - Tests under `scripts/jobs/test/` that set `GARDEN_GARDENER_CLONE` (grep; e.g.
>   run-test.sh, model-routing, qwen-mentor-trial, fetch-timeout, flat-provider-censor,
>   gardener-claude-tier-serving, host-requirements-gating, live-budget-admission,
>   deadline-nudge, gardener-worktree, auction-reputation, kimi-*, canary-probe-claim-
>   priority): retarget to `GARDEN_WORKER_CLONE`. Optionally rename
>   `gardener-claude-tier-serving-test.sh` → `monk-claude-...` if its name refers to the
>   deleted handler.
> - Final `grep -rn GARDEN_GARDENER_CLONE scripts` must be empty (except a deliberate
>   regression assertion, if you add one).
>
> Run the regression sweep (scaler/deploy/reaper/handler/health/worker-spine/
> auction-reputation suites plus every test you touched) and report which needed
> updating vs already passed. Land directly on `main2`.
>
> Orchestrated failure contract: if you finish but cannot achieve the outcome, end your
> report with `<<<GARDEN-ORCHESTRATION-FAILED>>>` then `<<<GARDEN-JOB-COMPLETE>>>`.

- `watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-09-30T14:41:02Z, cleared 2026-09-30T17:38:12Z).
> It was observed 54 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> canary oros-studio-garden-ce242c49 is no longer stuck (release 64dde114ce6ab3fd8a4a336900fdcafdf5a5ae07, deployed e036bb8e0650b66a4ae00dc1516c4c8df39901ca).


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 254.6M | $1589.68 _(notional, rate-card)_ | 99% of 256.0M (ok) |
| Codex | 17.6M _(fleet aggregate)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 38% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 66593064 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 4.833768s/45s (/home/kris/garden/.garden-state/state-clone-keeper/journal); 0 open notice(s); checker healthy

## Board
### todo (17)
- [`ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1398
- [`ebfb-petname-path-only-sweep-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-sweep-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1390
- [`ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #774
- [`endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-panel-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-panel-5.md) — Gauntlet stage: PANEL round 5 — endojs/endo-but-for-bots PR #1380
- [`ebfb-sturdyref-layer4-marshal-20260930-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1393
- [`build-ci-minion-town-actions-runner`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-ci-minion-town-actions-runner.md) — ---
- [`retire-gardener-worker-kind-alias-env-fallback`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/retire-gardener-worker-kind-alias-env-fallback.md) — ---
- [`ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4-prwrite`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4-prwrite.md) — PR write handoff for #1391 (gauntlet fix round 4)
- [`ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1394
- [`ebfb-petname-path-only-sweep-4-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-sweep-4-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1390
- [`endojs-endo-but-for-bots-pr1397-1398-sturdyref-rebase-bases`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1397-1398-sturdyref-rebase-bases.md) — Move #1397/#1398 PR bases onto the restacked frozen bases, confirm #1398 lint
- [`ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1392
- [`ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1396
- [`endojs-endo-but-for-bots-pr695-gauntlet-20260930-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr695-gauntlet-20260930-viability.md) — Gauntlet stage: PRE-SPEND VIABILITY - endojs/endo-but-for-bots PR #695
- [`ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1397
- [`endojs-endo-but-for-bots-pr1394-20260930-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1394-20260930-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1394
- [`fu-qwen-model-watch-20260728-180502-1-20260930-162006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/fu-qwen-model-watch-20260728-180502-1-20260930-162006.md) — ---

### doin (2)
- [`ebfb-petname-path-only-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-petname-path-only-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1390
- [`ebfb-petname-path-only-sweep-3-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/ebfb-petname-path-only-sweep-3-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1390

### tada (10098)
- [`claude-on-minion-town-press-20260930-185007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/claude-on-minion-town-press-20260930-185007.md) — Panel-head freshness
- [`ebfb-sturdyref-layer2-ses-20260930-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/ebfb-sturdyref-layer2-ses-20260930-gauntlet.md) — gauntlet ebfb-sturdyref-layer2-ses-20260930-gauntlet — HALTED
- [`endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-4.md) — Cost
- [`ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4.md) — Cost
- [`ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/09/30/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-clean.md) — Cost
- … and 10093 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`make-panel-stage-survive-supervisor-session-exit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/make-panel-stage-survive-supervisor-session-exit.md) — _normal_ · Make panel execution survive supervising agent-session exit
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
- [`build-accountant-arc-apportionment`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-accountant-arc-apportionment.md) — _normal_ · Build: accountant arc apportionment (garden main2)
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
- [`kriscendobot-garden-pr75-review-6b5f570b-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-garden-pr75-review-6b5f570b-retro.md) — _low_ · Retrospective on kriscendobot/garden PR #75 (primary: kriscendobot-garden-pr7...
- [`kriscendobot-minion.town-pr85-review-9f17a419-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr85-review-9f17a419-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #85 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr90-d6a72a2f-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr90-d6a72a2f-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #90 (primary: kriscendobot-minio...
- [`kriscendobot-minion.town-pr135-review-e4d01640-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr135-review-e4d01640-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #135 (primary: kriscendobot-mini...
- [`endojs-endo-but-for-bots-pr695-5e067785-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr695-5e067785-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #695 (primary: endojs-endo-but-f...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
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
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 4 monks
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 3 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 2 monks
