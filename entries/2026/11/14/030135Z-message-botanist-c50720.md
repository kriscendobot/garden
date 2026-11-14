---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-14T03:04:07Z
---
# Dependabotany - endojs/endo-but-for-bots recheck 2026-11-14: no verdict changed; #1629/#1654/#1655/#1657/#1658 still held behind unmerged #1613 / #1646

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- **Snapshot:** the dispatched snapshot pinned journal HEAD `f1ac88062a` with one row (#1658 MERGE-NOW). The synced journal HEAD differed, so I used the required case-insensitive full ledger scan. It recovered the same five active rows as on 2026-11-13: #1629, #1654, #1655, #1657, and #1658. The open Dependabot PRs on GitHub are exactly that set; every head is unchanged.
- **Blockers:** neither has cleared. #1613 is OPEN/CLEAN at `4066142fc5`, and #1646 is OPEN/CLEAN at `224852cb18`. Neither is merged. Live `llm` remains `48d6f3e08bcc`.
- **#1629** (setup-python 7.1.0): EMBARGO/held. Head `38ebe45489` remains red only on `ironhorse-oracle-sanitizers` and `test-ironhorse-oracle`, which #1613 repairs.
- **#1654** (`fbccb9665a`), **#1655** (`fd4af5a2c5`), **#1657** (`306baa33a8`), and **#1658** (`45e7064d4f`): MERGE-NOW still stands but is non-terminal. Each exact head remains red only on the base-attributable `test-xs` failure and therefore still waits on #1646.
- **Conduct:** none attempted because every PR still has failing CI and the prerequisites remain unmerged. The parked conduct plans stay parked.
- **Next:** the daily `dependabotany-recheck-endo-but-for-bots` heartbeat remains present. No one-shot is needed because every maturity floor has passed.

Foreign-content classification: none; no upstream prose was read.
Self-improvement: nothing this time.
