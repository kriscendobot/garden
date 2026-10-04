# Garden bulletin

_As of 2026-10-04T04:17:57Z_

## Latest

Little movement since the last bulletin: one deploy canary round-trip passed cleanly on endolin-garden2-5bcdff64, and the oros health-watch job completed, confirming what the inbox already flags — the oros Mac/VM host remains unreachable (heartbeat and last sysop op both ~46 hours stale, still derotated and running an old build versus main2). No PRs advanced or merged in this window. The maintainer queue is otherwise unchanged: several gauntlets (including [endojs/endo-but-for-bots#1391](https://github.com/endojs/endo-but-for-bots/pull/1391)-adjacent sturdyref-layer work, the confined-application-makers builds, and others) sit at their 6-round review-budget ceiling awaiting a human merge call, the garden-book budget re-slice still needs a direct "approve" from kriskowal, and [kriscendobot/minion.town#148](https://github.com/kriscendobot/minion.town/pull/148) has drifted past its last-reviewed panel head and needs an explicit re-review decision.

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

- `stale-panel-head-kriscendobot-minion.town-pr148-dea0146c-7c08ffa9` — from gardener:claude-on-minion-town-press-20261004-033506, reply_to `claude-on-minion-town-press-20261004-033506` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/stale-panel-head-kriscendobot-minion.town-pr148-dea0146c-7c08ffa9.md)

> COALESCED message — occurrence #2 (first seen 2026-10-04T00:22:11Z, latest 2026-10-04T03:37:42Z).
> The SAME message (episode key `stale-panel-head-kriscendobot-minion.town-pr148-dea0146c-7c08ffa9`) has now been sent 2 times; this is
> ONE entry that updates in place, not 2 messages. Latest detail:
>
> Stale panel coverage for completed job `claude-on-minion-town-press-20261004-033506`: [https://github.com/kriscendobot/minion.town/pull/148](https://github.com/kriscendobot/minion.town/pull/148) moved from panel-reviewed head `dea0146cefdcfa28d7dba2e40c760dc79821a5fc` to presented head `7c08ffa909ef4c31ce63b1df7348d9018c2d39e9`.
>
> Disposition: **review required**. The earlier panel does not cover the current head; every commit delta is conservatively review-relevant. A PR metadata-only edit would leave the head unchanged and would not trigger this disposition.
>
> No gauntlet was staged. Route the current head through the existing panel stage only after an explicit maintainer `run the gauntlet` request, or make a maintainer review decision with the stale coverage stated explicitly.

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

- `minion-town-claude-cli-production-20261003-halted` — from orchestrator:minion-town-claude-cli-production-20261003-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/minion-town-claude-cli-production-20261003-halted.md)

> orchestration-event: orchestration-terminal
> orchestration: minion-town-claude-cli-production-20261003
> orchestration-status: halted
> child: minion-town-claude-cli-provider-conduct-20261003
> failure-kind: gated-outcome-unsatisfied
> children-completed: 1
> children-total: 3
> halt-parked-remainder: minion-town-claude-cli-production-canary-20261003
>
> Orchestration minion-town-claude-cli-production-20261003 HALTED: child minion-town-claude-cli-provider-conduct-20261003 completed but declared its gated outcome unsatisfied (serial, on-child-failure=halt). 1/3 done before halt; parked remainder: minion-town-claude-cli-production-canary-20261003

- `msg-accountant-reslice-20261003-resume2-192d988f6e62` — from gardener:accountant-reslice-20261003-resume2, reply_to `accountant-reslice-20261003-resume2` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-accountant-reslice-20261003-resume2-192d988f6e62.md)

> Garden-book re-slice (proposal 20261003T055048Z-1f7489): a proxy/tentative "approve as proposed" arrived (20261003T062952Z-2761a3), but I have NOT applied it. Budget slices are the maintainer's call, and the apportionment records authorized_by: kriskowal, so a proxy answer cannot stand in.
>
> kriskowal: reply "approve" (or give edits: size, rank, or source) to carve a 15M `garden-book` arc at rank 7 from the 25M reserve, leaving the reserve at 10M with the total unchanged at 500M. Until then the carried-forward slate stays in force, and the book keeps drawing on the reserve. Accountant job accountant-reslice-20261003-resume2 will pick up your reply.

- `ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-review-budget-reached` — from gauntlet:ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-review-budget-reached.md)

> INFO: Gauntlet ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-container-hardening-pending-recreate-endolin-garden2-5bcdff64` — from watchdog:self-heal, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-container-hardening-pending-recreate-endolin-garden2-5bcdff64.md)

> Container hardening is PENDING on endolin-garden2-5bcdff64: 2 launcher-posture check(s) fail (caps/sudo/block devices/mount).
>
> This is the expected state until the container is recreated with the hardened launcher,
> a maintainer step: context/operations/harden-container.md. The garden-container-hardening
> unit stays clean meanwhile (exit 3), so it does not fail rolling-deploy canaries. After the
> first all-pass run, any failure is treated as a regression and fails the unit.

- `watchdog-self-heal-garden-ci-watcher-kriscendobot-minion-town` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-self-heal-garden-ci-watcher-kriscendobot-minion-town.md)

> self-heal: garden-ci-watcher@kriscendobot-minion.town exited rc=1 with no scoped fix. Capture: f27836451585cf2c1d2ea0261ce84e38fcbe8bd9 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p f27836451585cf2c1d2ea0261ce84e38fcbe8bd9). Diagnosis: Failed to authenticate: OAuth session expired and could not be refreshed

- `build-endo-claude-sandbox-bwrap-slice-gauntlet-review-budget-reached` — from gauntlet:build-endo-claude-sandbox-bwrap-slice-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-endo-claude-sandbox-bwrap-slice-gauntlet-review-budget-reached.md)

> INFO: Gauntlet build-endo-claude-sandbox-bwrap-slice-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `20261003T065941Z-848d3d` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261003T065941Z-848d3d.md)

> awaiting maintainer — beyond proxy authority: gardener accountant-reslice-20261003-resume2, msgid msg-accountant-reslice-20261003-resume2-035809b21719.md — Budget/resource allocation authorization (committing a 15M-unit garden-book slice) is an authority grant reserved to the maintainer, not a progress/direction question a proxy may answer.

- `msg-accountant-reslice-20261003-resume2-035809b21719` — from gardener:accountant-reslice-20261003-resume2, reply_to `accountant-reslice-20261003-resume2` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-accountant-reslice-20261003-resume2-035809b21719.md)

> The garden-book re-slice proposal is still awaiting your direct decision. Kriskowal, please reply “approve” to authorize the staged 15M garden-book slice (leaving 10M unallocated), explicitly confirm the earlier proxy approval, or give edits.

- `build-endo-claude-pinned-cli-bump-gauntlet-review-budget-reached` — from gauntlet:build-endo-claude-pinned-cli-bump-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-endo-claude-pinned-cli-bump-gauntlet-review-budget-reached.md)

> INFO: Gauntlet build-endo-claude-pinned-cli-bump-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-worker-agent-bin-monk-endolin-garden-ece02cb4` — from watchdog:monk/2, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-worker-agent-bin-monk-endolin-garden-ece02cb4.md)

> RECOVERED — the watchdog condition `worker-agent-bin-monk-endolin-garden-ece02cb4` has CLEARED (first seen 2026-10-03T12:39:42Z, cleared 2026-10-04T04:11:15Z).
> It was observed 8 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> monk workers on endolin-garden-ece02cb4 have a CHANGED credential (re-login validated) (/usr/local/bin/claude); the pool has UN-parked and is claiming normally. Closing the self-disqualification episode.

- `watchdog-comment-provenance-gap-endolin-garden-ece02cb4` — from watchdog:comment-provenance, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-provenance-gap-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #10 (first seen 2026-10-03T06:41:10Z, latest 2026-10-03T12:38:09Z).
> The SAME condition (`comment-provenance-gap-endolin-garden-ece02cb4`) has now been observed 10 times; this is ONE
> coalesced notice that updates in place, not 10 messages. Latest detail:
>
> comment-provenance INSTRUMENTATION GAP on host endolin-garden-ece02cb4: a fleet `gh` comment was posted by an LLM-driven caller, but NEITHER GARDEN_JOB_MODEL NOR GARDEN_WORKER_KIND resolved — so the footer named only the host and garden commit (no model/harness/provider). This is the PR #1125 defect. The comment STILL posted (fail-open); nothing is broken. FIX: find the code path posting the comment and export the job facts (GARDEN_JOB_MODEL + GARDEN_WORKER_KIND) before its `gh` call, OR set GARDEN_NO_LLM=1 if it is a deterministic (no-LLM) post.

- `endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002-halted` — from gauntlet:endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002-halted.md)

> Gauntlet endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002 HALTED: stage 'endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002-fix-1' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-review-budget-reached` — from gauntlet:ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-review-budget-reached.md)

> INFO: Gauntlet ebfb-sturdyref-layer3-pass-style-20260930-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-self-heal-garden-comment-watcher-endojs-endo-but-for-bots` — from watchdog:self-heal-claude, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-self-heal-garden-comment-watcher-endojs-endo-but-for-bots.md)

> self-heal: garden-comment-watcher@endojs-endo-but-for-bots exited rc=1 with no scoped fix. Capture: c45c612b15f22dbc443b0a7849c8a2fa8cf3e6a7 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p c45c612b15f22dbc443b0a7849c8a2fa8cf3e6a7). Diagnosis: Failed to authenticate: OAuth session expired and could not be refreshed

- `ebfb-guest-no-identifiers-locators-gauntlet-review-budget-reached` — from gauntlet:ebfb-guest-no-identifiers-locators-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-guest-no-identifiers-locators-gauntlet-review-budget-reached.md)

> INFO: Gauntlet ebfb-guest-no-identifiers-locators-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-blind-comment-watcher-kriscendobot-ocapn` — from watchdog:comment-watcher/kriscendobot-ocapn, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-blind-comment-watcher-kriscendobot-ocapn.md)

> ANOMALY: comment-watcher/kriscendobot-ocapn self-test FAILED on kriscendobot/ocapn — the comment source path could not fetch a known-existing comment, so the watcher is likely silently BLIND (the 2026-06-24 jq-outage signature). Check jq/gh on endolin-garden-ece02cb4 and the comment-source handler. This is a POSITIVE proof the source path is broken, NOT a report that the repo is quiet.

- `msg-oros-health-watch-20261004-040505-6ce09fb7ad5c` — from gardener:oros-health-watch-20261004-040505, reply_to `oros-health-watch-20261004-040505` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/msg-oros-health-watch-20261004-040505-6ce09fb7ad5c.md)

> Oros is unreachable: heartbeat last sampled 2026-10-02T05:08:36Z and sysop last applied an op 2026-10-02T05:38:58Z (both about 46 hours stale). The 2026-10-04T01:50:05Z pinned checkup remains unclaimed; oros is derotated and still deployed at e036bb8e versus main2 350d6bc1. I queued one benign reset-failed op (20261004T040710Z-ec703a), but it is unacked behind earlier unacked ops. A person needs to check the Mac/VM/Docker Desktop and wake or restart the machine/runtime.

- `build-confined-application-makers-p1-20261002-gauntlet-review-budget-reached` — from gauntlet:build-confined-application-makers-p1-20261002-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-confined-application-makers-p1-20261002-gauntlet-review-budget-reached.md)

> INFO: Gauntlet build-confined-application-makers-p1-20261002-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `20261003T065951Z-31100f` — from proxy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/20261003T065951Z-31100f.md)

> awaiting maintainer — beyond proxy authority: gardener accountant-reslice-20261003-resume2, msgid msg-accountant-reslice-20261003-resume2-192d988f6e62.md — Budget-slice apportionment is explicitly maintainer-authority: it carves reserve funds and records `authorized_by: kriskowal`, which a proxy answer cannot satisfy even tentatively.

- `build-confined-application-makers-p2-makefromtree-20261003-gauntlet-review-budget-reached` — from gauntlet:build-confined-application-makers-p2-makefromtree-20261003-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-confined-application-makers-p2-makefromtree-20261003-gauntlet-review-budget-reached.md)

> INFO: Gauntlet build-confined-application-makers-p2-makefromtree-20261003-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `ebfb-petname-path-only-gauntlet-review-budget-reached` — from gauntlet:ebfb-petname-path-only-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-petname-path-only-gauntlet-review-budget-reached.md)

> INFO: Gauntlet ebfb-petname-path-only-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `build-endo-guest-scoped-daemon-bootstrap-gauntlet-review-budget-reached` — from gauntlet:build-endo-guest-scoped-daemon-bootstrap-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-endo-guest-scoped-daemon-bootstrap-gauntlet-review-budget-reached.md)

> INFO: Gauntlet build-endo-guest-scoped-daemon-bootstrap-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-review-budget-reached` — from gauntlet:ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-review-budget-reached.md)

> INFO: Gauntlet ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `ebfb-sturdyref-layer4-marshal-20260930-gauntlet-review-budget-reached` — from gauntlet:ebfb-sturdyref-layer4-marshal-20260930-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-review-budget-reached.md)

> INFO: Gauntlet ebfb-sturdyref-layer4-marshal-20260930-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `build-ci-minion-town-actions-runner-gauntlet-review-budget-reached` — from gauntlet:build-ci-minion-town-actions-runner-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/build-ci-minion-town-actions-runner-gauntlet-review-budget-reached.md)

> INFO: Gauntlet build-ci-minion-town-actions-runner-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

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
| Claude | 87.8M | $597.78 _(notional, rate-card)_ | 34% of 256.0M (ok) |
| Codex | 5.7M _(+132.1M cached)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 9% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 44710904 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 8.962032s/45s (/home/kris/garden/.garden-state/state-clone-keeper/journal); 2 open notice(s); checker healthy

## Board
### todo (12)
- [`oros-health-checkup-20261004-015005`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261004-015005.md) — ---
- [`oros-health-checkup-20261002-045016`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-045016.md) — ---
- [`oros-health-checkup-20261002-112006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-112006.md) — ---
- [`oros-health-checkup-20261003-070602`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261003-070602.md) — ---
- [`oros-health-checkup-20261003-163507`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261003-163507.md) — ---
- [`oros-health-checkup-20261002-080511`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-080511.md) — ---
- [`oros-health-checkup-20261003-193507`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261003-193507.md) — ---
- [`oros-health-checkup-20261003-132007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261003-132007.md) — ---
- [`oros-health-checkup-20261003-223509`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261003-223509.md) — ---
- [`oros-health-checkup-20261002-142006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261002-142006.md) — ---
- [`oros-health-checkup-20261003-040508`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261003-040508.md) — ---
- [`oros-health-checkup-20261003-102007`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/oros-health-checkup-20261003-102007.md) — ---

### doin (0)
(none)

### tada (10759)
- [`canary-probe-endolin-garden2-5bcdff64-350d6bc198c8`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/04/canary-probe-endolin-garden2-5bcdff64-350d6bc198c8.md) — rolling-deploy canary probe — round trip OK
- [`oros-health-watch-20261004-040505`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/04/oros-health-watch-20261004-040505.md) — Cost
- [`improve-comment-latency-quota-warning-coalesce`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/04/improve-comment-latency-quota-warning-coalesce.md) — Cost
- [`claude-on-minion-town-completion-press-20261004-035006`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/04/claude-on-minion-town-completion-press-20261004-035006.md) — Cost
- [`claude-on-minion-town-press-20261004-033506`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/04/claude-on-minion-town-press-20261004-033506.md) — Panel-head freshness
- … and 10754 more

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
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
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
