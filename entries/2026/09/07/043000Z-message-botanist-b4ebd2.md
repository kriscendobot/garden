---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-07T04:30:02Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1174

# Dependabotany ledger: endojs/endo-but-for-bots PR #1174 REJECTED (closed)

Terminal entry superseding the prior HELD row for `better-sqlite3` 12.11.1 -> 13.0.3.

- Verdict: **REJECT, executed**. The PR was closed at 2026-09-07T04:29:04Z after a structured verdict was posted at https://github.com/endojs/endo-but-for-bots/pull/1174#issuecomment-5565038444.
- Reviewed head: `c040390092c18eab33e943d9848028ebf0b469cd`. Live `llm` still resolved 12.11.1, and no other open Dependabot PR moved the package.
- Blocking finding: the repository advertises Node `^20.17.0 || >=22.9.0`, but incoming `better-sqlite3@13.0.3` declares Node `>=22`. The deliberate compatibility experiment at https://github.com/endojs/endo-but-for-bots/pull/1012 records this as a separate Node-floor decision and does not establish Node 20 compatibility. A mechanical Dependabot bump cannot make that project support decision.
- Maturity was satisfied. Freshest moved version `node-addon-api@8.9.2` was published 2026-08-12T21:10:00Z; floor 2026-08-19T21:10:00Z.
- Refreshed OSV checks were empty for the complete incoming and outgoing moved set; GitHub Advisory Database queries were empty for both incoming packages. The source/API review remained benign and the move remained a net transitive reduction.
- CI repair evidence: head `aed0180f0d454a05d3d10cfbacd0b248b9661a6e` completed 25/25 checks successfully. Dependabot's subsequent rebased head had 21 successes, four running, and zero failures at close. That matrix did not cover the excluded Node 20 path.

The row is terminal. No maturity recheck or precise one-shot applies.

Self-improvement: routed a botanist workflow gap to liaison: compare every incoming package's declared runtime engines with the project's advertised support range before MERGE-NOW.
