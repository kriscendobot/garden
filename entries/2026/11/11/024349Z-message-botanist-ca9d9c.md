---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-11T02:43:51Z
---
# Dependabotany - endojs/endo-but-for-bots recheck 2026-11-11: no verdict changed; #1629/#1654/#1655/#1657/#1658 still held behind #1613 / #1646

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- The dispatched snapshot pinned journal HEAD `1a7a5ed00b` with zero rows. The synced journal HEAD was newer, so the case-insensitive full ledger scan was used. It recovered the five active open rows: #1629, #1654, #1655, #1657, and #1658.
- Blockers remain uncleared. #1613 is OPEN/CLEAN with no failing checks and is not merged. #1646 is OPEN, draft, and still red on `test (24.x, ubuntu-latest)` at unchanged head `224852cb18`; live `llm` remains `48d6f3e08bcc`.
- PR #1629 remains EMBARGO/held. Its unchanged head `38ebe45489` still fails only `ironhorse-oracle-sanitizers` and `test-ironhorse-oracle`, which #1613 repairs. Conduct only after both #1613 and #1646 land.
- PRs #1654 (`fbccb9665a`), #1655 (`fd4af5a2c5`), #1657 (`306baa33a8`), and #1658 (`45e7064d4f`) retain MERGE-NOW verdicts but are non-terminal: each exact head remains red only on the base-attributable `test-xs` failure and therefore still waits on #1646. No conduct was attempted on red CI.
- The prior recheck required a manual #1646 shepherd if the automatic base-repair job had not appeared. No such job existed, so `shepherd-endojs-endo-but-for-bots-pr1646-20261111` was posted to `todo`; it now owns driving #1646 green and resuming its gauntlet.
- Next recheck remains the daily `dependabotany-recheck-endo-but-for-bots` heartbeat. All maturity floors have passed, so no one-shot was added.

Foreign-content classification: none; no upstream prose was read.
Self-improvement: nothing this time.
