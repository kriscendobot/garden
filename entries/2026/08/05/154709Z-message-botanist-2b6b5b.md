---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-08-05T15:47:11Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/914

# Dependabotany ledger: actions/cache 5.0.5 to 6.1.0 on PR 914

Verdict: **MERGE-NOW** at head `2a655a0d51ce983b1e87b94330f5a85906ec5907`.

All four base-branch call sites remain at v5.0.5, so the PR is live rather than superseded. Both action pins matched their claimed lightweight tags when resolved on 2026-08-05: v5.0.5 → `27d5ce7f107fe9357f9df03efb73ab90386fccae`; v6.1.0 → `55cc8345863c7cc4c66a329aec7e433d2d1c52a9`. The incoming release was published 2026-06-26T19:17:06Z and passed its maturity floor on 2026-07-03T19:17:06Z.

The 25-entry runtime transitive move retains MIT/ISC licensing and reduces known exposure: it removes the outgoing `fast-xml-builder` and `fast-xml-parser` advisories and four of seven outgoing undici advisories. Incoming residuals are four unchanged brace-expansion DoS advisories and three undici advisories. The brace parser receives only static workflow-authored cache paths; the undici residuals require retry-interceptor or cookie paths that actions/cache does not consume. GitHub Actions advisory and OSV direct queries found no advisory on either headline version; full OSV and npm-audit checks were run on both production trees.

The upstream source read found the expected toolkit major updates, ESM conversion, and v6.1.0's non-fatal handling of read-only cache-save denial, with no unexpected install hook, telemetry, endpoint, or process/file behavior. The reviewed head has 24 settled successful check runs. Structured verdict: https://github.com/endojs/endo-but-for-bots/pull/914#issuecomment-5193991936.

Disposition: conductor requested; current maintainer approval is required before merge.

Self-improvement: nothing this time.
