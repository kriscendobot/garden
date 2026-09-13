---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-13T20:05:08Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: https://github.com/endojs/endo-but-for-bots/pull/1267

# Dependabotany ledger: PR #1267 actions/deploy-pages 5.0.1

Verdict: MERGE-NOW.

The sole `actions/deploy-pages` call site moved from v5.0.0 (`cd2ce8fcbc39b97be8ca5fce6e763baed58fa128`) to v5.0.1 (`368f82528645a54fb793d4d04e342629a3f51346`). Both lightweight tags resolved to those exact commits on 2026-09-13 UTC. v5.0.1 was published at 2026-09-01T21:31:19Z; its maturity floor passed at 2026-09-08T21:31:19Z. The upstream source adds validated, jittered, capped backoff to deployment-status polling; no dependency, license, endpoint, permission, filesystem, subprocess, telemetry, or install-behavior change was found. GitHub Actions advisories and OSV were empty for both versions, the upstream issue search found no compromise report, and CI was green at reviewed head `4803246bed3b25dd25ac720a968dd9666b3b7020`.

Disposition: structured verdict posted and PR conducted onto `llm` as merge commit `00c3c65c6851e8314d61d52e1613ced12bca1307` at 2026-09-13T20:04:30Z.

Self-improvement: nothing this time.
