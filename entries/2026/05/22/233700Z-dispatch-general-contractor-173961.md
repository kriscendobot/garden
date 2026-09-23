---
ts: 2026-05-22T23:37:00Z
kind: dispatch
role: fixer
project: endo-but-for-bots
to: fixer
host: endolinbot
slot: 1
prs:
  - repo: endojs/endo-but-for-bots
    pr: 322
    role: target
refs:
  - entries/2026/05/22/233559Z-result-solicitor-8b1fc0.md
---

# Dispatch: fixer 173961 — address 3 must-fix + 8 summary-fix on #322 (flatpak design)

Solicitor-8b1fc0 verdict: 3 must-fix-loop, 8 summary-fix. Three must-fix:
1. The finish-args table cites whereEndoLog/whereEndoConfig — those names don't exist; public surface is whereEndoState/whereEndoCache/whereEndoEphemeralState.
2. 16 cross-references to familiar-release.md 404 from llm (sibling design on unmerged design/familiar-release branch).
3. PR-body Open Questions not surfaced inside doc.

Address bundle in design markdown. After return, solicitor re-runs.

Report to result-fixer-173961.md.
