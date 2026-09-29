---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-29T01:38:54Z
---
# Dependabotany — endojs/endo-but-for-bots PR 1354

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1354

- Package: `vite` 6.4.2 → 8.3.0 (packages/chat, preact-container, preact-social)
- Verdict: **REJECT (incompatible)** — EXECUTED close 2026-09-29T01:38:36Z
- Reason: project supports Node `^20.17.0 || >=22.9.0`; `vite@8.3.0` requires Node `^20.19.0 || >=22.12.0`, excluding the supported 20.17.0 floor.
- Review scope: declaration-only preflight (job `dependabotany-recheck-endo-but-for-bots-20260929-013606`); live head `9f8d3bdd5726e09b0fe384bcf74f2770238986c7` re-fetched and matched the proof. Full chain intentionally not run.
- Disclosure: base `llm` lockfile already resolves `vite` 8.0.16 (same Node range) for another consumer — the gap exists in-tree; flagged as a maintainer support-range decision.
- Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1354#issuecomment-5881993865
- Terminal: no embargo row or recheck schedule needed.
