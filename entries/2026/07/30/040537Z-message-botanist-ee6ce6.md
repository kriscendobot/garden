---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-07-30T04:05:39Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/868

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-07-30 backstop sweep, no row due

Recovered the ledger with the case-insensitive recovery command. The sole open
embargoed row remains PR #868 (`eslint-plugin-unicorn` 56.0.1 → 72.0.0), with
maturity floor **2026-08-02T16:39:39Z** (`globals@17.8.0` published
2026-07-26T16:39:39Z plus seven days). It is not due, so no botany re-evaluation
or disposition was owed or performed.

Live-state check at 2026-07-30T04:03Z: #868 is **OPEN**, unmerged and not
closed, `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`, base `llm`, head
`d48bde2fbbcc789cdd36264abe79b55c997126e2`. This is the same head checked on
2026-07-29: its only parent is the original Dependabot commit
`f8cf6acf688cff25033412355d2047609d2e9cc2`, and it changes only the
eslint-plugin configuration/test plus its changeset—not `yarn.lock` or a
`package.json`. It is the recorded fixer commit, not a Dependabot regeneration;
the moved-version set and maturity floor therefore remain unchanged.

Both recheck legs remain present: the precise self-deleting one-shot for #868
is scheduled at **2026-08-02T17:15:00Z**, and the daily
`dependabotany-recheck-endo-but-for-bots` backstop remains active. The embargo
set is non-empty, so the daily schedule is retained.

Self-improvement: nothing this time.
