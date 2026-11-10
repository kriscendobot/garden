---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-11-10T02:25:43Z
---
# Dependabotany - endojs/endo-but-for-bots recheck 2026-11-10: no change; #1629/#1654/#1655/#1657/#1658 still held behind #1613 / #1646

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- Snapshot: the dispatched snapshot pinned journal HEAD 69934e5645 with 0 rows. The synced HEAD was 884f5ad592, so I fell back to the full case-insensitive scan. Open dependabot PRs: #1629, #1654, #1655, #1657, #1658. No new PRs and no terminal verdicts.
- Blockers are unchanged since 2026-11-09. #1613 is OPEN/CLEAN with no review decision and is not merged. #1646 (Node 24 pin) is OPEN, draft, UNSTABLE: red on `test (24.x, ubuntu-latest)`, last updated 2026-11-03. Live llm is still 48d6f3e08b, and its test-xs is still red (Node 26).
- PR #1629: EMBARGO, re-deferred. Head 38ebe45489 is unchanged and red only on ironhorse-oracle-sanitizers and test-ironhorse-oracle, which #1613 fixes. Conduct with `ci-wait-merge.sh --dependabot-auto-merge` once #1613 and #1646 are on llm.
- PRs #1654 (fbccb9665a), #1655 (fd4af5a2c5), #1657 (306baa33a8), #1658 (45e7064d4f): MERGE-NOW stands but cannot complete. Each head is unchanged and its only red is the base-attributable test-xs. All four wait on #1646. #1657 becomes redundant once #1655 lands. The parked plan for #1658 (`endojs-endo-but-for-bots-pr1658-dependabot-conduct-after-pr1646`) still owns its conduct.
- No conduct attempted: every PR has a failing check, so ci-wait-merge.sh would exit red.
- Stall driver: no board job is driving #1646. The base-CI repair escalation (`16ea23b4137`, which posts one `<slug>-base-ci-<sha12>` shepherd job per shared red base) is NOT yet deployed: the root checkout is at f2788117645. Once the deploy lands, the dependabot watcher should post `endo-but-for-bots-base-ci-48d6f3e08bcc`, which would shepherd #1646. I did not post a duplicate shepherd job. If that job has not appeared by the next recheck, post a shepherd job for #1646 by hand.
- Next: the daily heartbeat `dependabotany-recheck-endo-but-for-bots`. No one-shots are needed, because every floor has passed.
