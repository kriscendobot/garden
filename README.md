# Garden bulletin

_As of 2026-10-04T05:09:54Z_

## Latest

The illuminated-edition work kept moving: `book-illumination-produce-20261004` completed and its viability check passed, with the supervisor and chapter-illustrations build continuing in `doin`. On the minion.town front, [kriscendobot/minion.town#147](https://github.com/kriscendobot/minion.town/pull/147) got its § 4 app-compatibility check fixed, and a new job is now underway on [kriscendobot/minion.town#148](https://github.com/kriscendobot/minion.town/pull/148) to fix an `ensureDirectory` race.

The maintainer's inbox is fairly full: oros-studio-garden-ce242c49 has been offline for ~46 hours (heartbeats stale, several health-checkups queued unclaimed) and needs a human to check the machine; two container-hardening and a journal-contention-storm notice are informational/expected; and a detailed panel summary on the SturdyRef PR stack ([endojs/endo-but-for-bots#1392](https://github.com/endojs/endo-but-for-bots/issues/1392), [#1393](https://github.com/endojs/endo-but-for-bots/issues/1393), [#1396](https://github.com/endojs/endo-but-for-bots/issues/1396), [#1397](https://github.com/endojs/endo-but-for-bots/issues/1397)) recommends merging #1392, #1396, and #1397 as-is once their stack predecessors land, with #1393 needing a retcon first — no PR was touched pending maintainer sign-off.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#1282](https://github.com/endojs/endo-but-for-bots/pull/1282) — chore(ironhorse): demolish the XS-computron-parity myth (waiting 7d)
- [endojs/endo-but-for-bots#1281](https://github.com/endojs/endo-but-for-bots/pull/1281) — fix(ses): silence lockdown intrinsics report for the WHATWG URL family (waiting 16d)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 22d)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 30d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 32d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 32d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 33d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 32d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 32d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 35d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Screened by proxy (minion.town)

(delegation not armed)

## Messages to the maintainer

- `watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #20 (first seen 2026-10-02T05:41:06Z, latest 2026-10-04T04:41:02Z).
> The SAME condition (`rolling-deploy-host-offline-oros-studio-garden-ce242c49`) has now been observed 20 times; this is ONE
> coalesced notice that updates in place, not 20 messages. Latest detail:
>
> Host oros-studio-garden-ce242c49 is OFFLINE: heartbeat stale by 171146s (offline threshold 1800s; sampled_at_epoch=1790917716).
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

- `watchdog-container-hardening-pending-recreate-endolin-garden2-5bcdff64` — from watchdog:self-heal, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-container-hardening-pending-recreate-endolin-garden2-5bcdff64.md)

> Container hardening is PENDING on endolin-garden2-5bcdff64: 2 launcher-posture check(s) fail (caps/sudo/block devices/mount).
>
> This is the expected state until the container is recreated with the hardened launcher,
> a maintainer step: context/operations/harden-container.md. The garden-container-hardening
> unit stays clean meanwhile (exit 3), so it does not fail rolling-deploy canaries. After the
> first all-pass run, any failure is treated as a regression and fails the unit.

- `watchdog-unclaimable-host-requirements-oros-health-checkup-20261004-045008` — from watchdog:requirements-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-unclaimable-host-requirements-oros-health-checkup-20261004-045008.md)

> Host-requirements gate: job 'oros-health-checkup-20261004-045008' has remained unclaimed for 900s with requires: host=oros-studio-garden-ce242c49. No live host has met these requirements in the dwell window (or no eligible workers are live), so this work is not silently progressing. Provision the capability/worker or revise the job requirement.

- `msg-accountant-reslice-20261004-68981d96012c` — from gardener:accountant-reslice-20261004, reply_to `accountant-reslice-20261004` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-accountant-reslice-20261004-68981d96012c.md)

> Re-slice applied (journal2 235a959c880; authorized_by: kriskowal, "Approve a smaller slice for future editions.", reply to 20261003T055048Z-1f7489).
>
> Week of 2026-10-03T03:00Z, total 555M (planning ceiling 0.9):
> 1. minion-town-mcp-ocapn   158.175M
> 2. minion-town-git-remote  105.45M
> 3. minion-town-ui           79.0875M
> 4. endo-ocapn-background   105.45M
> 5. moonshots                42.18M
> 6. garden-upkeep            26.3625M
> 7. garden-book               5M     (NEW: future editions and upkeep)
> 8. endo-backlog             10.545M
> Reserve: unallocated 22.75M (was 27.75M)
>
> Every other arc is unchanged. From now on, book-* and garden-book-* jobs should be posted with `--arc garden-book`. The book-illumination/equilibrium jobs already on the board are unarced and orchestrated or blocked. I did not re-tag them, because the accountant only writes the allocation layer. No open budget request existed to close (there is no budget/requests/ on the journal). No reply needed.

- `watchdog-comment-provenance-gap-endolin-garden-ece02cb4` — from watchdog:comment-provenance, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-provenance-gap-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #10 (first seen 2026-10-03T06:41:10Z, latest 2026-10-03T12:38:09Z).
> The SAME condition (`comment-provenance-gap-endolin-garden-ece02cb4`) has now been observed 10 times; this is ONE
> coalesced notice that updates in place, not 10 messages. Latest detail:
>
> comment-provenance INSTRUMENTATION GAP on host endolin-garden-ece02cb4: a fleet `gh` comment was posted by an LLM-driven caller, but NEITHER GARDEN_JOB_MODEL NOR GARDEN_WORKER_KIND resolved — so the footer named only the host and garden commit (no model/harness/provider). This is the PR #1125 defect. The comment STILL posted (fail-open); nothing is broken. FIX: find the code path posting the comment and export the job facts (GARDEN_JOB_MODEL + GARDEN_WORKER_KIND) before its `gh` call, OR set GARDEN_NO_LLM=1 if it is a deterministic (no-LLM) post.

- `endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002-halted` — from gauntlet:endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002-halted.md)

> Gauntlet endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002 HALTED: stage 'endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002-fix-1' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

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

- `watchdog-blind-comment-watcher-kriscendobot-ocapn` — from watchdog:comment-watcher/kriscendobot-ocapn, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-blind-comment-watcher-kriscendobot-ocapn.md)

> ANOMALY: comment-watcher/kriscendobot-ocapn self-test FAILED on kriscendobot/ocapn — the comment source path could not fetch a known-existing comment, so the watcher is likely silently BLIND (the 2026-06-24 jq-outage signature). Check jq/gh on endolin-garden-ece02cb4 and the comment-source handler. This is a POSITIVE proof the source path is broken, NOT a report that the repo is quiet.

- `msg-oros-health-watch-20261004-040505-6ce09fb7ad5c` — from gardener:oros-health-watch-20261004-040505, reply_to `oros-health-watch-20261004-040505` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-oros-health-watch-20261004-040505-6ce09fb7ad5c.md)

> Oros is unreachable: heartbeat last sampled 2026-10-02T05:08:36Z and sysop last applied an op 2026-10-02T05:38:58Z (both about 46 hours stale). The 2026-10-04T01:50:05Z pinned checkup remains unclaimed; oros is derotated and still deployed at e036bb8e versus main2 350d6bc1. I queued one benign reset-failed op (20261004T040710Z-ec703a), but it is unacked behind earlier unacked ops. A person needs to check the Mac/VM/Docker Desktop and wake or restart the machine/runtime.

- `watchdog-journal-contention-storm-clone-oversized` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-storm-clone-oversized.md)

> Journal contention storm on endolin-garden2-5bcdff64: 6 clones hit clone-oversized in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/dependabot-watcher/verify: awaiting a healthy post-rebuild fetch; size=48050176B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/ci-watcher/retire: awaiting a healthy post-rebuild fetch; size=47344640B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/ci-watcher/verify: awaiting a healthy post-rebuild fetch; size=48037888B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/fireworkers/1/journal: awaiting a healthy post-rebuild fetch; size=48944128B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/comment-watcher/verify: awaiting a healthy post-rebuild fetch; size=48939008B packs=1 gc.log=0; automatic remedy=none.
> - Journal clone guard on endolin-garden2-5bcdff64 for /home/kris/garden2/.garden-state/approval-reconciler/verify: awaiting a healthy post-rebuild fetch; size=48019456B packs=1 gc.log=0; automatic remedy=none.

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
| Claude | 90.2M | $611.94 _(notional, rate-card)_ | 35% of 256.0M (ok) |
| Codex | 6.2M _(+142.2M cached)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 9% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 44710904 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 6.910494s/45s (/home/kris/garden/.garden-state/self-deploy/journal); 2 open notice(s); checker healthy

## Board
### todo (13)
- [`oros-health-checkup-20261004-015005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261004-015005.md) — ---
- [`oros-health-checkup-20261002-045016`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-045016.md) — ---
- [`oros-health-checkup-20261002-112006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-112006.md) — ---
- [`oros-health-checkup-20261003-070602`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261003-070602.md) — ---
- [`oros-health-checkup-20261003-163507`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261003-163507.md) — ---
- [`oros-health-checkup-20261004-045008`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261004-045008.md) — ---
- [`oros-health-checkup-20261002-080511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-080511.md) — ---
- [`oros-health-checkup-20261003-193507`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261003-193507.md) — ---
- [`oros-health-checkup-20261003-132007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261003-132007.md) — ---
- [`oros-health-checkup-20261003-223509`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261003-223509.md) — ---
- [`oros-health-checkup-20261002-142006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-142006.md) — ---
- [`oros-health-checkup-20261003-040508`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261003-040508.md) — ---
- [`oros-health-checkup-20261003-102007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261003-102007.md) — ---

### doin (3)
- [`garden-book-chapter-illustrations-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/garden-book-chapter-illustrations-build.md) — ---
- [`book-illumination-supervisor-20261004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/book-illumination-supervisor-20261004.md) — Supervise production 1: per-chapter/section illuminated illustrations (krisce...
- [`minion-town-pr148-ensuredirectory-race-fix-20261004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/minion-town-pr148-ensuredirectory-race-fix-20261004.md) — Fix the ensureDirectory race on kriscendobot/minion.town#148 (and require act...

### tada (10778)
- [`book-illumination-produce-20261004-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/04/book-illumination-produce-20261004-gauntlet-viability.md) — Cost
- [`book-illumination-produce-20261004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/04/book-illumination-produce-20261004.md) — Cost
- [`minion-town-pr147-s4-key-fix-20261004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/04/minion-town-pr147-s4-key-fix-20261004.md) — Fixed the § 4 app-compatibility check on kriscendobot/minion.town#147
- [`minion-town-pr148-137-panel-summary-20261004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/04/minion-town-pr148-137-panel-summary-20261004.md) — Cost
- [`minion-town-pr145-panel-summary-20261004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/04/minion-town-pr145-panel-summary-20261004.md) — Panel-head freshness
- … and 10773 more

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
- [`kriscendobot-minion-town-pr148-gauntlet-viability`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion-town-pr148-gauntlet-viability.md) — _normal_ · Gauntlet stage: PRE-SPEND VIABILITY - kriscendobot/minion.town PR #148
- [`evaluate-reauth-escalation-default-after-oauth-relay-20260927`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/evaluate-reauth-escalation-default-after-oauth-relay-20260927.md) — _low_ · Evaluate default reauth escalation once the browser OAuth relay lands
- [`build-confined-application-makers-p2-20261002`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-confined-application-makers-p2-20261002.md) — _normal_ · Phase 2: daemon capture for node-modules-with-map and node-modules-scan layou...
- [`build-endo-daemon-cloudflare-storage`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-daemon-cloudflare-storage.md) — _normal_ · Build: Endo daemon Cloudflare storage platform (phases 1-2 of the design)
- [`endojs-endo-but-for-bots-pr1340-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1340-gauntlet-panel-4.md) — _normal_ · Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1340
- [`endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-ses-import-attributes-phase3-compartment-mapper.md) — _normal_ · Build: SES import attributes — Phase 3 (compartment-mapper plumbing)
- [`deploy-endo-daemon-aws-storage-reference`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/deploy-endo-daemon-aws-storage-reference.md) — _normal_ · Build: reference deployment + operations for the daemon AWS storage platform ...
- [`build-claude-usage-dashboard-scraper`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-claude-usage-dashboard-scraper.md) — _normal_ · ---
- [`claude-on-minion-town-press-20261002-112006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/claude-on-minion-town-press-20261002-112006.md) — _normal_ · Press the Claude-on-minion.town arc forward

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
- [`kriscendobot-minion.town-pr148-review-cde1226a-retro`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/kriscendobot-minion.town-pr148-review-cde1226a-retro.md) — _low_ · Retrospective on kriscendobot/minion.town PR #148 (primary: kriscendobot-mini...

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`ebfb-platform-fs-pet-name-path-only`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-platform-fs-pet-name-path-only.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1390` · ---
- [`endo-minion-town-federation-release-gate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-minion-town-federation-release-gate.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1124` · Gate: reviewed and deployable federation release
- [`verify-ironhorse-press-first-engagement-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ironhorse-press-first-engagement-20260929.md) — awaiting `ironhorse-test262-press-20260929-173306` · Verify the first live Ironhorse foreman-press engagement (successor of activa...
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1019` · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`book-illumination-supervisor-after-produce-20261004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/book-illumination-supervisor-after-produce-20261004.md) — awaiting `book-illumination-produce-20261004` · Continue the illuminated edition after asset production
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`book-hyperlink-references-20261004`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/book-hyperlink-references-20261004.md) — awaiting `book-illumination-and-data-orch-20261004` · Follow-up: make every reference in Better Code and Gardens an actual hyperlin...
- [`build-exo-sheets-service`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-sheets-service.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`ironhorse-fuzz-triage-differential_source-efffacee3e2a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-triage-differential_source-efffacee3e2a.md) — awaiting `https://github.com/kriscendobot/garden/issues/91` · Triage 7 Ironhorse fuzz finding(s) for target differential_source

## Watch set
kriscendobot-minion.town kriscendobot-garden-book kriscendobot-cosgov kriscendobot-ocapn kriscendobot-oros-ckm-data-readiness kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot

## Hosts
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 2 monks
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 3 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 3 monks
