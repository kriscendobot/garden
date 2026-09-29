---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-29T01:38:58Z
---
# Dependabotany — endojs/endo-but-for-bots PR 1351

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1351

- Package: `@changesets/cli` 2.31.0 → 3.0.3 (root devDependency)
- Verdict: **REJECT (incompatible)** — EXECUTED close 2026-09-29T01:38:37Z
- Reason: project supports Node `^20.17.0 || >=22.9.0`; `@changesets/cli@3.0.3` requires Node `^22.11 || ^24 || >=26`, excluding all of Node 20. 3.0.3 is npm `latest`; no newer release restores Node 20.
- Review scope: declaration-only preflight (job `dependabotany-recheck-endo-but-for-bots-20260929-013606`); live head `7e3953bde63c90ae7899625e1a8605f84ccc7616` re-fetched and matched the proof. Full chain intentionally not run.
- Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1351#issuecomment-5881993703
- Terminal: no embargo row or recheck schedule needed.
