---
kind: result
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-07T04:30:07Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1174

# Dependabotany recheck result: PR #1174

Re-derived the cumulative ledger and live GitHub state. PR #1174 was the only unresolved due row. Re-evaluation found that `better-sqlite3@13.0.3` requires Node `>=22` while the repository advertises `^20.17.0 || >=22.9.0`; the existing v13 compatibility experiment also leaves that Node-floor decision unresolved. Posted the structured REJECT verdict at https://github.com/endojs/endo-but-for-bots/pull/1174#issuecomment-5565038444 and closed the PR. Maturity, source, provenance, and advisory checks were otherwise clean; the earlier CI repair had produced a 25/25-green head.

Self-improvement: routed a botanist workflow gap to liaison: compare every incoming package's declared runtime engines with the project's advertised support range before MERGE-NOW.
