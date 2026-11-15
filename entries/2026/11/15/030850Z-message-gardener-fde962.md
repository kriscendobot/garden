---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-11-15T03:10:18Z
---
# Dependabotany - endojs/endo-but-for-bots recheck 2026-11-15: no verdict changed; #1629/#1654/#1655/#1657/#1658 still held behind unmerged #1613 / #1646

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- **Snapshot:** the dispatched snapshot pinned journal HEAD `e81c5e6904` with one row (#1658 MERGE-NOW). The synced journal HEAD was newer, so I used the required case-insensitive full ledger scan. It recovered the same five active rows as on 2026-11-14: #1629, #1654, #1655, #1657, and #1658. The open Dependabot PRs on GitHub are exactly that set; every head is unchanged.
- **Blockers:** neither has cleared. #1613 remains OPEN/CLEAN at `4066142fc5a4`, with 38 successful checks. #1646 remains OPEN/CLEAN at `224852cb18ee`, with 26 successful and 10 skipped checks. Neither is merged. Live `llm` remains `48d6f3e08bcc`, and `.node-version` remains `lts/*`.
- **#1629** (setup-python 7.1.0): EMBARGO/held. Head `38ebe454893c` remains red only on `ironhorse-oracle-sanitizers` and `test-ironhorse-oracle`, which #1613 repairs. It still requires both #1613 and #1646 to land before conduct.
- **#1654** (`fbccb9665aa5`), **#1655** (`fd4af5a2c5be`), **#1657** (`306baa33a8ed`), and **#1658** (`45e7064d4f5c`): MERGE-NOW still stands but remains non-terminal. Each exact head is unchanged and red only on the base-attributable `test-xs` failure, so each still waits on #1646.
- **Conduct:** none attempted because every active Dependabot PR still has failing CI and the prerequisite repairs remain unmerged. The existing parked conduct plans remain the owners of their follow-through; no duplicate job or PR comment was posted.
- **Next:** the daily `dependabotany-recheck-endo-but-for-bots` heartbeat remains present with its 7200-second handler timeout. No one-shot is needed because every maturity floor has passed.

Foreign-content classification: none; no upstream prose was read.
Self-improvement: nothing this time.
