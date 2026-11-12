---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-12T02:38:48Z
---
# Dependabotany - endojs/endo-but-for-bots recheck 2026-11-12: no verdict changed; #1629/#1654/#1655/#1657/#1658 still held; both blockers #1613 / #1646 now green and await maintainer merge

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- Snapshot: the dispatched snapshot pinned journal HEAD `80f054f767` with zero rows. The synced HEAD was `4a6e2117c1`, so I used the case-insensitive full scan instead. It found the same five active rows: #1629, #1654, #1655, #1657, and #1658. Open dependabot PRs match that set. There are no new PRs.
- Blockers changed state but have not cleared. #1646 (`.node-version` pin to 24) is no longer draft and is CLEAN at unchanged head `224852cb18`. The 2026-11-11 shepherd and gauntlet runs turned it green and un-drafted it. It has no review decision and is not merged. #1613 (XS oracle lanes on Ubuntu 24.04) is OPEN and CLEAN at `4066142fc5`, with no review decision. It is not merged either. Live `llm` is still `48d6f3e08bcc`.
- PR #1629 (setup-python 7.1.0): EMBARGO/held. Head `38ebe45489` is unchanged and red only on `ironhorse-oracle-sanitizers` and `test-ironhorse-oracle`, which #1613 repairs. Conduct with `ci-wait-merge.sh --dependabot-auto-merge` only after #1613 and #1646 land on llm.
- PRs #1654 (`fbccb9665a`), #1655 (`fd4af5a2c5`), #1657 (`306baa33a8`), and #1658 (`45e7064d4f`): MERGE-NOW still stands but is non-terminal. Each head's only red check is the base-attributable `test-xs`, and all four wait on #1646. The parked plans `endojs-endo-but-for-bots-pr1658-dependabot-conduct-after-pr1646` and `conduct-endojs-endo-but-for-bots-pr1573-after-pr1646` remain parked.
- No conduct was attempted, because every PR still has a failing check. The whole set is now gated only on the maintainer merging #1613 and #1646. Garden automation has nothing left to do on either PR. I sent the maintainer a one-time notice.
- Next: the daily heartbeat `dependabotany-recheck-endo-but-for-bots`. Every maturity floor has passed, so no one-shot was added.

Foreign-content classification: none; no upstream prose was read.
Self-improvement: nothing this time.
