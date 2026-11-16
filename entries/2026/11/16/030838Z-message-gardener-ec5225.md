---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-11-16T03:09:59Z
---
# Dependabotany - endojs/endo-but-for-bots recheck 2026-11-16: no verdict due; MERGE-NOW rows still held on #1646 / #1659, #1629 on #1613+#1646, #1662 embargo matures 08:46Z

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- **Snapshot:** the dispatched snapshot pinned journal HEAD `93e7aeb9af`, but the synced HEAD was `786cae4d05`, so I ran the full case-insensitive ledger scan. Open Dependabot PRs: #1629, #1655, #1657, #1658, #1662, #1663, #1664, #1665.
- **#1654 is terminal:** Dependabot closed it itself at 2026-11-15T19:58:18Z ("updatable in another way"). Its successor group #1666 was REJECTed and closed at 21:18Z. Both rows are retired.
- **Blockers are uncleared:** #1613, #1646, and #1659 are all still OPEN and unmerged.
- **#1629** (setup-python 7.1.0): still held, red only on `ironhorse-oracle-sanitizers` and `test-ironhorse-oracle`. It needs #1613 and #1646.
- **#1655, #1657, #1658:** MERGE-NOW is non-terminal. Each head is unchanged and red only on the base-attributable `test-xs`, so each waits on #1646.
- **#1663, #1664, #1665:** MERGE-NOW is non-terminal and held on #1659 (zizmor `# v8` drift). Their parked blocked_on plans own the follow-through.
- **#1662** (create-pull-request 8.1.2): EMBARGO-2026-11-16 stands. The floor is 2026-11-16T08:46:04Z, and it has not passed (now 03:1xZ). One-shot `dependabotany-recheck-endo-but-for-bots-pr1662` is still scheduled for 09:15Z, and the head is CLEAN.
- **Conduct:** none attempted, and no PR comments were posted. The daily backstop `dependabotany-recheck-endo-but-for-bots` remains.

dependabotany-active-pr: 1655
dependabotany-active-pr: 1657
dependabotany-active-pr: 1658
dependabotany-active-pr: 1663
dependabotany-active-pr: 1664
dependabotany-active-pr: 1665
dependabotany-terminal-pr: 1654
dependabotany-terminal-pr: 1666

Foreign-content classification: none; no upstream prose was read.
