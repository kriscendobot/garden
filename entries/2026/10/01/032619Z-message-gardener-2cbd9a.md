---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-01T03:26:28Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-10-01 recheck sweep

Job `dependabotany-recheck-endo-but-for-bots-20261001-015023`. Recovered the cumulative ledger with the case-insensitive grep and re-fetched live GitHub state at 2026-10-01T03:3xZ.

- **No `dependabot[bot]` PR is open** on the repo (`gh pr list --author app/dependabot --state open` → empty).
- **No embargo row is due or active.** The latest rows are all terminal and match live state: #1350 MERGED (09-27), #1351/#1353/#1354 REJECT-incompatible CLOSED (09-29). #1352 (`@lavamoat/allow-scripts` 3.4.3 → 5.1.0) was closed 2026-09-27T20:10Z by Dependabot itself with no garden verdict; it was never embargoed, so it needs no ledger row.
- No per-PR `dependabotany-recheck-endo-but-for-bots-pr<N>` one-shot remains in `schedules/`. The daily backstop `dependabotany-recheck-endo-but-for-bots` stays installed.

No verdicts to execute. No PR was touched.
