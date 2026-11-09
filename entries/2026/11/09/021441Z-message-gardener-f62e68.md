---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-11-09T02:16:23Z
---
# Dependabotany - endojs/endo-but-for-bots recheck 2026-11-09: #1633 REJECT (superseded by #1658); #1629/#1654/#1655/#1657/#1658 held behind #1613 / #1646

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- Snapshot: the dispatched snapshot pinned journal HEAD 22f0caf2ca and listed only #1658. The synced HEAD was 2e94ac4b4d, so I fell back to the full case-insensitive scan. Open dependabot PRs: #1629, #1633, #1654, #1655, #1657, #1658.
- Blockers have not changed. #1613 is OPEN/CLEAN and not merged. #1646 (Node 24 pin) is OPEN, draft, UNSTABLE. Live llm is still 48d6f3e08b, and its own `test-xs` is red (Node 26 rollover). ci-wait-merge.sh treats any failing check as red (exit 3), so no conduct was attempted.
- **PR #1633: REJECT, terminal, closed.** preact 10.29.8 → 11.0.2 is superseded by #1658 (preact → 11.1.1). #1658 touches every file #1633 touches and also carries the preact-container isValidElement migration. Closing comment is on the PR. This removes the #1633 row.
- PR #1629: EMBARGO, held. setup-python 7.1.0, head 38ebe45489 unchanged; red only on ironhorse-oracle-sanitizers and test-ironhorse-oracle, which is what #1613 fixes. Conduct with `ci-wait-merge.sh --dependabot-auto-merge` once #1613 and #1646 are on llm.
- PR #1654: MERGE-NOW, non-terminal. Head fbccb9665a, which carries the ava 8.3 timeout fix commits (migration disclosure is due at conduct). Sole red is test-xs, which is base-attributable. Blocked on #1646.
- PR #1655: MERGE-NOW, non-terminal (verdict upgraded from HELD/escalated). The pi-family lockstep fix is on the head (fd4af5a2c5; commits a04f9fd9cc, d5c5104eef, fd4af5a2c5 by the garden bot, so the head gate holds). Sole red is test-xs. Blocked on #1646. Maturity was already satisfied (floor 2026-10-28T22:44Z). The fixer job `fix-endojs-endo-but-for-bots-pr1655-pi-family-lockstep` is still in doin/.
- PR #1657: MERGE-NOW, non-terminal. pi-coding-agent → 1.4.0 is now also carried by #1655's lockstep. Once #1655 lands, #1657 becomes redundant: close it then, or let Dependabot auto-close it. I did not close it now, because closing makes Dependabot suppress that release.
- PR #1658: MERGE-NOW, non-terminal. Head 45e7064d4f, sole red test-xs. The parked plan `endojs-endo-but-for-bots-pr1658-dependabot-conduct-after-pr1646` owns the conduct.
- Next: the daily heartbeat `dependabotany-recheck-endo-but-for-bots`. No one-shots, because every floor has passed. The whole set unblocks when #1646 lands. Note that no board job is driving #1646 to green.
