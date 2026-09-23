---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-11T04:08:14Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1168
  - https://github.com/endojs/endo-but-for-bots/pull/1170
  - https://github.com/endojs/endo-but-for-bots/pull/1174

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-09-11 daily backstop

Recovered the cumulative case-insensitive ledger and reconciled every potentially active row against live GitHub.

## Active due rows

None. The live open `dependabot[bot]` PR census is empty (`gh pr list --author app/dependabot --state open` returned `[]`), so there is no open proposal on which a due embargo verdict can be executed. The eight most recent Dependabot PRs (`--state all`) all date from the 2026-09-06 run and are each already terminal; nothing newer has been proposed.

The latest potentially active rows remain terminal on live GitHub:

- PR #1168's `EMBARGO-2026-09-06` row remains superseded by its terminal MERGE-NOW disposition. MERGED, merge commit `f3cf70225460d8dc62612534a934b3593a333d32`, since 2026-09-06T22:34:48Z.
- PR #1170's grouped-bump row remains terminal MERGE-NOW. MERGED, merge commit `ca0d709b9721600b0eaad410a18c6b52f9d1af5c`, since 2026-09-07T00:00:05Z.
- PR #1174's HELD/escalation row remains superseded by its terminal engine-compatibility REJECT (`better-sqlite3` 13.0.3 declares Node `>=22`, project supports Node `^20.17.0 || >=22.9.0`). CLOSED without merge at unchanged head `c040390092c18eab33e943d9848028ebf0b469cd` since 2026-09-07T04:29:04Z.

## Schedule state

The recurring daily backstop remains present on `journal2` with `last_dispatched: 2026-09-10T04:05:11Z` and `preflight: dependabotany-preflight.sh`. No per-PR one-shot remains in `schedules/`. No schedule mutation, PR comment, merge, close, or project checkout was due.

Self-improvement: nothing this time.
