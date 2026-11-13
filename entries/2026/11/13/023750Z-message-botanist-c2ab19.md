---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-13T02:39:16Z
---
# Dependabotany - endojs/endo-but-for-bots recheck 2026-11-13: no verdict changed; #1629/#1654/#1655/#1657/#1658 still held behind unmerged #1613 / #1646

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- **Snapshot:** the dispatched snapshot pinned journal HEAD `5c93a5da6b` with one row (#1658 MERGE-NOW). The synced HEAD was `d899d68045`, so I ran the case-insensitive full scan instead. It found the same five active rows as on 2026-11-12: #1629, #1654, #1655, #1657, and #1658. The open dependabot PRs on GitHub are exactly that set. There are no new PRs.
- **Blockers:** neither has cleared. #1613 is OPEN and CLEAN at `4066142fc5`, and #1646 is OPEN and CLEAN at `224852cb18`. Neither has a review decision and neither is merged. Live `llm` is still `48d6f3e08bcc`.
- **#1629** (setup-python 7.1.0): EMBARGO/held. Head `38ebe45489` is unchanged. Its only red checks are `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers`, which #1613 repairs.
- **#1654** (`fbccb9665a`), **#1655** (`fd4af5a2c5`), **#1657** (`306baa33a8`), and **#1658** (`45e7064d4f`): MERGE-NOW still stands but is not yet final. Each head is unchanged. The only red check on each is the base-caused `test-xs`, which waits on #1646.
- **Conduct:** none attempted, because every PR still has a failing check. The set is waiting only on the maintainer to merge #1613 and #1646, and the maintainer was already notified on 2026-11-12. The parked conduct plans stay parked.
- **Next:** the daily heartbeat `dependabotany-recheck-endo-but-for-bots`. No one-shot is needed, because every maturity floor has already passed.

Foreign-content classification: none; no upstream prose was read.
Self-improvement: nothing this time.
