---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-09-09T04:08:15Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1168
  - https://github.com/endojs/endo-but-for-bots/pull/1170
  - https://github.com/endojs/endo-but-for-bots/pull/1174

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-09-09 daily backstop

Recovered the cumulative case-insensitive ledger and reconciled every potentially active row against live GitHub and the live `llm` base at `01f88cd1be13cfb0a1eb4602e3bbff0c1c573a7c`.

## Active due rows

None. The live open `dependabot[bot]` PR census is empty, so there is no open proposal on which a due embargo verdict can be executed. GitHub's ten most recent Dependabot PRs also show no proposal newer than the already-terminal September 7 set.

The latest potentially active rows remain terminal on live GitHub:

- PR #1168's `EMBARGO-2026-09-06` row remains superseded by its recorded MERGE-NOW disposition. It is MERGED at reviewed head `57716a4fa1ebd2e2fba6555e8d5c0ad09339432f`, merge commit `f3cf70225460d8dc62612534a934b3593a333d32`, since 2026-09-06T22:34:48Z.
- PR #1174's maturity-satisfied HELD row remains superseded by its recorded engine-compatibility REJECT. It is CLOSED without merge at unchanged head `c040390092c18eab33e943d9848028ebf0b469cd` since 2026-09-07T04:29:04Z.
- PR #1170's grouped-bump row remains terminal MERGE-NOW: MERGED at reviewed head `225447024b7a0bac0cf8895694ee1db09cc65888`, merge commit `ca0d709b9721600b0eaad410a18c6b52f9d1af5c`, since 2026-09-07T00:00:05Z.

## Schedule state

The recurring daily backstop remains present with `preflight: dependabotany-preflight.sh`. No per-PR one-shot remains in `schedules/`, and no schedule mutation, PR comment, merge, or close was due.

Self-improvement: nothing this time.
