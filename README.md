# Garden bulletin

_As of 2026-10-01T23:22:16Z_

## Latest

Board activity since the last bulletin was a single gauntlet step: panel round 3 for the Claude sandbox bwrap-slice work completed and closed out. Larger items for the maintainer's attention remain parked rather than fresh — the petname-path sweep and sturdyref layer-6 gauntlets both hit their review budget or halted after repeated fix-round failures and are waiting on a human merge/review call, and several rolling-deploy/canary watchdog notices on oros-studio and endolin-garden2 have mostly self-cleared, though the endolin-garden2 root-repo deploy is still stalled 16 commits behind main2 and worth a look.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#1282](https://github.com/endojs/endo-but-for-bots/pull/1282) — chore(ironhorse): demolish the XS-computron-parity myth (waiting 5d)
- [endojs/endo-but-for-bots#1281](https://github.com/endojs/endo-but-for-bots/pull/1281) — fix(ses): silence lockdown intrinsics report for the WHATWG URL family (waiting 14d)
- [endojs/endo#3110](https://github.com/endojs/endo/pull/3110) — refactor(error-console-internal): for use only by ses and @endo/errors (waiting 20d)
- [endojs/endo-but-for-bots#241](https://github.com/endojs/endo-but-for-bots/pull/241) — design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution) (waiting 28d)
- [endojs/endo-but-for-bots#1038](https://github.com/endojs/endo-but-for-bots/pull/1038) — docs(daemon): gate the setExceptionBreakMode('uncaught') silent no-op (waiting 30d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 30d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 30d)
- [endojs/endo-but-for-bots#237](https://github.com/endojs/endo-but-for-bots/pull/237) — design: lal define-jessie tool with Blockly rendering (waiting 31d)
- [endojs/endo-but-for-bots#594](https://github.com/endojs/endo-but-for-bots/pull/594) — chore(lint): lint per package to avoid the typescript-eslint project-service ceiling (waiting 30d)
- [endojs/endo-but-for-bots#832](https://github.com/endojs/endo-but-for-bots/pull/832) — docs: Design ReadableBlob lines stream (waiting 33d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Screened by proxy (minion.town)

(delegation not armed)

## Messages to the maintainer

- `watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-host-offline-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-host-offline-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-10-01T21:08:02Z, cleared 2026-10-01T22:23:02Z).
> It was observed 12 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> heartbeat resumed for oros-studio-garden-ce242c49; it is PRESENT again and will automatically rejoin the canary rotation while its hosts/oros-studio-garden-ce242c49 record remains active. Archived records are not unarchived automatically.

- `watchdog-rolling-deploy-no-canary-endolin-garden-ece02cb4` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-no-canary-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-09-30T23:36:06Z, latest 2026-10-01T22:11:16Z).
> The SAME condition (`rolling-deploy-no-canary-endolin-garden-ece02cb4`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> Rolling deploy is HOLDING the leader: every configured follower is OFFLINE or
> operator-drained, so there is no canary to validate e02555bca7f4. The leader will
> not advance unvalidated. Restore any offline host until budget/live heartbeats resume,
> or lift an operator drain. An archived host additionally needs a separate operator
> unarchive; this roll never reverses archival. (leader=endolin-garden-ece02cb4, offline=1)

- `watchdog-root-repo-deploy-stalled-endolin-garden2-5bcdff64` — from watchdog:root-repo-guard, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-root-repo-deploy-stalled-endolin-garden2-5bcdff64.md)

> root repo /home/kris/garden2 deploy has been STALLED for ~1d: deployed sha c63c16cad579f313f26afa1cb752c67cc97f5b6e is 16 commit(s) behind origin/main2 (697976e718f354af3b121874c52a6cdbc8d6c87c) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=endolin-garden2-5bcdff64)

- `ebfb-petname-path-only-sweep-3-gauntlet-review-budget-reached` — from gauntlet:ebfb-petname-path-only-sweep-3-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-petname-path-only-sweep-3-gauntlet-review-budget-reached.md)

> INFO: Gauntlet ebfb-petname-path-only-sweep-3-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_leader_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_leader_journal.md)

> Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/leader/journal: packs 1011 >= 1000; size=250150912B packs=1011 gc.log=0; automatic remedy=deferred-deadline.

- `watchdog-worker-derotate-oros-studio-garden-ce242c49` — from watchdog:worker-derotate, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-worker-derotate-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `worker-derotate-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-10-01T21:35:10Z, cleared 2026-10-01T21:50:09Z).
> It was observed 1 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> heartbeat resumed for oros-studio-garden-ce242c49 (heartbeat fresh (554s old; sampled_at_epoch=1790890849)); it is PRESENT again and its config/worker-leveling caps are restored to 4 0 (monk cleric), so budget-level will apportion it workers again. (leader=endolin-garden-ece02cb4)

- `watchdog-budget-level-monk-oros-studio-garden-ce242c49-3` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-oros-studio-garden-ce242c49-3.md)

> budget-level changed oros-studio-garden-ce242c49 monk workers 2 -> 3 (target 3): subscription claude-oros spend=21178667 cap=73000000 pace-bias=0.095515 window-start=2026-09-29T10:00Z(calendar) deadline=2026-10-06T10:00Z(calendar) ceiling=4 target=3

- `watchdog-journal-contention-watch-overrun` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-contention-watch-overrun.md)

> RECOVERED — the watchdog condition `journal-contention-watch-overrun` has CLEARED (first seen 2026-10-01T20:53:24Z, cleared 2026-10-01T23:09:26Z).
> It was observed 5 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> Journal contention condition `journal-contention-watch-overrun` cleared on endolin-garden-ece02cb4.

- `watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-failed-oros-studio-garden-ce242c49.md)

> RECOVERED — the watchdog condition `rolling-deploy-canary-failed-oros-studio-garden-ce242c49` has CLEARED (first seen 2026-10-01T16:17:11Z, cleared 2026-10-01T23:11:07Z).
> It was observed 2 time(s) while open. Nothing further is required;
> this notice closes the loop so the end of the condition is on the record.
>
> retrying canary oros-studio-garden-ce242c49 (attempt 1/3); clearing prior page.

- `watchdog-comment-provenance-gap-endolin-garden-ece02cb4` — from watchdog:comment-provenance, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-comment-provenance-gap-endolin-garden-ece02cb4.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-10-01T21:44:07Z, latest 2026-10-01T21:44:07Z).
> The SAME condition (`comment-provenance-gap-endolin-garden-ece02cb4`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> comment-provenance INSTRUMENTATION GAP on host endolin-garden-ece02cb4: a fleet `gh` comment was posted by an LLM-driven caller, but NEITHER GARDEN_JOB_MODEL NOR GARDEN_WORKER_KIND resolved — so the footer named only the host and garden commit (no model/harness/provider). This is the PR #1125 defect. The comment STILL posted (fail-open); nothing is broken. FIX: find the code path posting the comment and export the job facts (GARDEN_JOB_MODEL + GARDEN_WORKER_KIND) before its `gh` call, OR set GARDEN_NO_LLM=1 if it is a deterministic (no-LLM) post.

- `ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-halted` — from gauntlet:ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-halted.md)

> Gauntlet ebfb-sturdyref-layer3-pass-style-20260930-gauntlet HALTED: stage 'ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-6' (fix) failed 1 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `watchdog-journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal` — from watchdog:journal-contention-watch, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-journal-clone-oversized-_home_kris_garden__garden_state_sysop_journal.md)

> Journal clone guard on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: packs 1022 >= 1000; size=250616832B packs=1022 gc.log=0; automatic remedy=deferred-deadline.

- `watchdog-budget-level-monk-oros-studio-garden-ce242c49-2` — from watchdog:budget-level, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-budget-level-monk-oros-studio-garden-ce242c49-2.md)

> WATCHDOG notice — occurrence #3 (first seen 2026-09-25T03:50:17Z, latest 2026-10-01T22:05:17Z).
> The SAME condition (`budget-level-monk-oros-studio-garden-ce242c49-2`) has now been observed 3 times; this is ONE
> coalesced notice that updates in place, not 3 messages. Latest detail:
>
> budget-level changed oros-studio-garden-ce242c49 monk workers 1 -> 2 (target 2): subscription claude-oros spend=21178588 cap=73000000 pace-bias=0.085227 window-start=2026-09-29T10:00Z(calendar) deadline=2026-10-06T10:00Z(calendar) ceiling=3 target=2

- `ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-halted` — from gauntlet:ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-halted, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-halted.md)

> Gauntlet ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet HALTED: stage 'ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-6' (fix) failed 2 times and was NOT retried because its completed report explicitly declared the gated outcome failed/declined.

- `endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached` — from gauntlet:endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-review-budget-reached.md)

> INFO: Gauntlet endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet review budget reached: Applied 6 panel/fix round(s); fix round 6 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=6, so the PR is left improved for a human merge/review decision.

- `watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49` — from watchdog:rolling-deploy, reply_to `?` · [open message](https://github.com/kriscendobot/garden/blob/journal2/inbox/maintainer/unread/watchdog-rolling-deploy-canary-stuck-oros-studio-garden-ce242c49.md)

> WATCHDOG notice — occurrence #2 (first seen 2026-10-01T22:08:01Z, latest 2026-10-01T22:47:03Z).
> The SAME condition (`rolling-deploy-canary-stuck-oros-studio-garden-ce242c49`) has now been observed 2 times; this is ONE
> coalesced notice that updates in place, not 2 messages. Latest detail:
>
> Rolling-deploy canary oros-studio-garden-ce242c49 is STUCK: it was released to e02555bca7f4 21 min ago
> but still reports deployed_sha e036bb8e0650b66a4ae00dc1516c4c8df39901ca. Check garden-self-deploy on oros-studio-garden-ce242c49
> (journalctl --user -u garden-self-deploy): a hold or a deferring deploy-garden.sh
> keeps it from advancing. The leader does not advance past an undeployed canary.
> (leader=endolin-garden-ece02cb4)


## Spend & quota
_Since claude-endolin1 reset; billable tokens (cache reads excluded). Leader-host local spend._

| Provider | Token spend | Dollar spend | % of quota |
| --- | --- | --- | --- |
| Claude | 178.9M | $1351.16 _(notional, rate-card)_ | 70% of 256.0M (ok) |
| Codex | 19.1M _(fleet aggregate)_ | n/a _(ChatGPT prolite plan — no per-token $; plan-metered)_ | 38% _(plan; codex-reported)_ |

_Fleet token-unlock pace: 138612604 tokens/day lower bound._

## Journal contention (this host)
worst fetch p95 4.755192s/45s (/home/kris/garden/.garden-state/worktree-sweeper/journal); 2 open notice(s); checker healthy

## Board
### todo (25)
- [`revive-hermit-lane-qwen3.8-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/revive-hermit-lane-qwen3.8-20261001.md) — Revive the local hermit (on-box Ollama) lane, upgraded to qwen3.8
- [`book-copyedit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/book-copyedit.md) — Copy-edit pass on the garden book
- [`fix-oros-heartbeat-canary-drain-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/fix-oros-heartbeat-canary-drain-20261001.md) — ---
- [`ebfb-petname-path-only-sweep-4-gauntlet-panel-5`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-sweep-4-gauntlet-panel-5.md) — Gauntlet stage: PANEL round 5 — endojs/endo-but-for-bots PR #1390
- [`ebfb-1391-post-panel-5-verdict`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-1391-post-panel-5-verdict.md) — Post the round-5 panel verdict on PR #1391 (endojs/endo-but-for-bots)
- [`endojs-endo-but-for-bots-pr1403-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1403-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1403
- [`endojs-endo-but-for-bots-pr1340-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1340-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1340
- [`ebfb-guest-no-identifiers-locators-gauntlet-panel-4`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-guest-no-identifiers-locators-gauntlet-panel-4.md) — Gauntlet stage: PANEL round 4 — endojs/endo-but-for-bots PR #1404
- [`endojs-endo-but-for-bots-pr1340-body-refresh-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1340-body-refresh-20261001.md) — Apply refreshed PR body to endojs/endo-but-for-bots#1340
- [`build-endo-claude-pinned-cli-bump-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-endo-claude-pinned-cli-bump-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — endojs/endo-but-for-bots PR #1406
- [`endojs-endo-but-for-bots-pr1340-conduct-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1340-conduct-20261001.md) — Conduct endojs/endo-but-for-bots#1340 (un-draft and merge)
- [`minion-town-pr140-endo-cancel-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/minion-town-pr140-endo-cancel-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — kriscendobot/minion.town PR #146
- [`endojs-endo-but-for-bots-pr1407-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1407-gauntlet-panel-1.md) — Gauntlet stage: PANEL round 1 — endojs/endo-but-for-bots PR #1407
- [`endojs-endo-but-for-bots-pr1402-conduct`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-pr1402-conduct.md) — Finalize (curate -> merge) endojs/endo-but-for-bots PR #1402
- [`ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-3.md) — Gauntlet stage: FIX round 3 — endojs/endo-but-for-bots PR #1393
- [`endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-fix-6.md) — Gauntlet stage: FIX round 6 — endojs/endo-but-for-bots PR #1380
- [`claude-on-minion-town-press-20261001-223508`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/claude-on-minion-town-press-20261001-223508.md) — Press the Claude-on-minion.town arc forward
- [`ebfb-774-pr-body-refresh-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-774-pr-body-refresh-20261001.md) — Update the PR #774 description (endojs/endo-but-for-bots)
- [`ocap-site-dns-recovery-check-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ocap-site-dns-recovery-check-20261001.md) — Verify ocap.site DNS recovery after registrar nameserver revert
- [`accountant-budget-conversation-20260930-resume`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/accountant-budget-conversation-20260930-resume.md) — ---
- [`build-ci-minion-town-actions-runner-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-ci-minion-town-actions-runner-gauntlet-panel-3.md) — Gauntlet stage: PANEL round 3 — kriscendobot/minion.town PR #145
- [`ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1397
- [`ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-6-pr-write`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-6-pr-write.md) — PR-write handoff for endojs/endo-but-for-bots#1392 (gauntlet fix round 6)
- [`ebfb-petname-path-only-gauntlet-fix-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/ebfb-petname-path-only-gauntlet-fix-2.md) — Gauntlet stage: FIX round 2 — endojs/endo-but-for-bots PR #1390
- [`build-endo-claude-broker-catalog-pruning-gauntlet-panel-2`](https://github.com/kriscendobot/garden/blob/journal2/jobs/todo/build-endo-claude-broker-catalog-pruning-gauntlet-panel-2.md) — Gauntlet stage: PANEL round 2 — endojs/endo-but-for-bots PR #1409

### doin (4)
- [`design-minion-town-mcp-resources-getting-started`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/design-minion-town-mcp-resources-getting-started.md) — Design: expose MCP Resources on minion.town's MCP server, and a getting-start...
- [`build-endo-claude-backends-1357-open-pr-gauntlet-clean`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/build-endo-claude-backends-1357-open-pr-gauntlet-clean.md) — Gauntlet stage: CLEAN — endojs/endo-but-for-bots PR #1412
- [`build-endo-guest-scoped-daemon-bootstrap-gauntlet-fix-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/build-endo-guest-scoped-daemon-bootstrap-gauntlet-fix-1.md) — Gauntlet stage: FIX round 1 — endojs/endo-but-for-bots PR #1407
- [`design-ebfb-guest-delegated-host-channel-confinement`](https://github.com/kriscendobot/garden/blob/journal2/jobs/doin/design-ebfb-guest-delegated-host-channel-confinement.md) — Design: confinement for capabilities delegated to a guest, and for channel me...

### tada (10332)
- [`build-endo-claude-sandbox-bwrap-slice-gauntlet-panel-3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/build-endo-claude-sandbox-bwrap-slice-gauntlet-panel-3.md) — Cost
- [`ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet.md) — gauntlet ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet — HALTED
- [`ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-6`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-fix-6.md) — Completion report — FIX round 6, PR #1396
- [`build-endo-guest-scoped-daemon-bootstrap-gauntlet-panel-1`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/build-endo-guest-scoped-daemon-bootstrap-gauntlet-panel-1.md) — Cost
- [`endojs-endo-but-for-bots-pr1116-f1ab5121`](https://github.com/kriscendobot/garden/blob/journal2/jobs/tada/2026/10/01/endojs-endo-but-for-bots-pr1116-f1ab5121.md) — Panel-head freshness
- … and 10327 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`garden-fix-mystic-canary-runtime-20260724`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/garden-fix-mystic-canary-runtime-20260724.md) — _low_ · ---
- [`endo-retention-set-disclosure-hold`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-retention-set-disclosure-hold.md) — _normal_ · ---
- [`build-exo-google-sheets`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-google-sheets.md) — _normal_ · EMPTY JOB — held, needs re-specification
- [`make-panel-stage-survive-supervisor-session-exit`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/make-panel-stage-survive-supervisor-session-exit.md) — _normal_ · Make panel execution survive supervising agent-session exit
- [`endor-same-process-worker-benchmark`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endor-same-process-worker-benchmark.md) — _normal_ · Benchmark an endor daemon and worker in one process
- [`ebfb-llm-lint-warnings`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-llm-lint-warnings.md) — _normal_ · ---
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

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`ebfb-platform-fs-pet-name-path-only`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ebfb-platform-fs-pet-name-path-only.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1390` · ---
- [`endo-minion-town-federation-release-gate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endo-minion-town-federation-release-gate.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1124` · Gate: reviewed and deployable federation release
- [`verify-ironhorse-press-first-engagement-20260929`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/verify-ironhorse-press-first-engagement-20260929.md) — awaiting `ironhorse-test262-press-20260929-173306` · Verify the first live Ironhorse foreman-press engagement (successor of activa...
- [`build-exo-spreadsheet-structure`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-spreadsheet-structure.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`endojs-endo-but-for-bots-pr1340-build-20261001`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr1340-build-20261001.md) — awaiting `endojs-endo-but-for-bots-pr1340-conduct-20261001` · Implement the confined-application-makers design (endojs/endo-but-for-bots#1340)
- [`endojs-endo-but-for-bots-rust-module-lexer-build`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-rust-module-lexer-build.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/1019` · Build: consolidate the Rust module lexer per designs/rust-module-lexer-consol...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...
- [`build-minion-town-ocap-mailboxes`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-minion-town-ocap-mailboxes.md) — awaiting `https://github.com/kriscendobot/minion.town/pull/37` · Build ocap mailboxes from the approved minion.town design
- [`build-endo-inspect`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-endo-inspect.md) — awaiting `endojs/endo-but-for-bots#715` · Build: implement @endo/inspect per the landed design
- [`book-illustrations-integrate`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/book-illustrations-integrate.md) — awaiting `book-codex-illustrations` · Garden book: integrate the Codex-generated illustrations and publish
- [`book-build-js-retool`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/book-build-js-retool.md) — awaiting `book-illustrations-integrate` · Retool the garden-book generator in portable JavaScript
- [`daemon-rename-to-manager-phase3`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/daemon-rename-to-manager-phase3.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/780` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`book-codex-illustrations`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/book-codex-illustrations.md) — awaiting `garden-book-revision-orch` · Garden book: generate illustrations and background art (Codex)
- [`build-exo-sheets-service`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/build-exo-sheets-service.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/881` · ---
- [`book-title-audience-pass`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/book-title-audience-pass.md) — awaiting `garden-book-revision-orch` · Garden book: a sharper title, and a pass for the actual audience
- [`ironhorse-fuzz-triage-differential_source-efffacee3e2a`](https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/ironhorse-fuzz-triage-differential_source-efffacee3e2a.md) — awaiting `https://github.com/kriscendobot/garden/issues/91` · Triage 7 Ironhorse fuzz finding(s) for target differential_source

## Watch set
kriscendobot-minion.town kriscendobot-garden-book kriscendobot-cosgov kriscendobot-ocapn kriscendobot-oros-ckm-data-readiness kriscendobot-list kriscendobot-moddable kriscendobot-proposal-compartments kriscendobot-ymax-stdio-mcp kriscendobot-ymax-e2e kriscendobot-vattr97 kriscendobot-test262 kriscendobot-endo kriscendobot-endo-but-for-bots kriscendobot-finbot

## Hosts
- [endolin-garden2-5bcdff64](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 1 monks
- [endolin-garden-ece02cb4](https://github.com/kriscendobot/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 2 monks
- [.archived-ps23-garden-f65473ae](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23-garden-f65473ae): ? monks
- [.archived-ps23](https://github.com/kriscendobot/garden/blob/journal2/hosts/.archived-ps23): ? monks
- [oros-studio-garden-ce242c49](https://github.com/kriscendobot/garden/blob/journal2/hosts/oros-studio-garden-ce242c49): 2 monks
