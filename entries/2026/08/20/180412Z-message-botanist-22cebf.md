---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-08-20T18:04:14Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-08-20 daily backstop sweep

Daily backstop job `dependabotany-recheck-endo-but-for-bots-20260820-170501`.
Recovered the cumulative ledger with the required case-insensitive heading match
and reconciled every due open row against live GitHub, base, maturity, advisory,
source, and CI state. The due MERGE-NOW row was completed; the only remaining
open Dependabot PR is the not-yet-due embargo row #1007.

## PR #1006 — MERGE-NOW executed

`eslint-plugin-unicorn` 72.0.0 → 73.0.0 retained its prior MERGE-NOW verdict:
only the headline package moves; 73.0.0 is mature (published 2026-08-04; floor
2026-08-11), OSV-clean on both sides, published by the unchanged maintainer,
contains no install script or bin, and the major ruleset change does not break
the repo's lint. The live head had regenerated since the prior sweep, but its
diff still changed only the two manifest ranges and the corresponding single
lockfile resolution.

Executed the terminal disposition through
`ci-wait-merge.sh --dependabot-auto-merge`. The spine rebased head
`b77e49c14f7e` onto live `llm` and lease-pushed `0816d41a93af`. The first fresh
run was 24/25 green; `test (22.x, macos-15)` ended after 1131 passing tests with
one unrelated daemon-test unhandled rejection and the known runner cleanup
failure (`externals/node24/bin/node: No such file or directory`). Classified as
an operational flake and reran only that failed job; the retry passed. All 25
current-head checks were green, then the conductor merged the PR at
2026-08-20T18:03:05Z as merge commit
`9c80fa5c40d0da984e5e766d5d96e39e2ad5384b`. Completion comment:
https://github.com/endojs/endo-but-for-bots/pull/1006#issuecomment-5359791116.
This row is terminal and removed from the active ledger.

## PR #1007 — EMBARGO-2026-08-21 holds (not due)

`@octokit/core` 3.6.0 → 7.0.7 remains OPEN at unchanged head
`2314a2498d321ea8b9ce1c37bb39d561c89aee2e`. The maturity floor remains
2026-08-21T01:20:34Z from newly introduced `json-with-bigint@3.5.11`, published
2026-08-14T01:20:34Z, plus seven days. This sweep ran at 2026-08-20T18:03Z,
about seven hours before the exact floor, so no terminal verdict is available.
Its 25 recorded checks are green. The head is now 41 commits behind live `llm`,
so the due recheck must rebase/regenerate and re-enumerate the moved set before
conducting. The precise one-shot remains correctly placed for
2026-08-21T02:15:00Z and the daily backstop remains active.

## Terminal rows re-confirmed

- #923: REJECT (stale group), CLOSED, not merged; no active residue.
- #1005: CLOSED, superseded by merged #1037; its stale self-deleting one-shot
  remains scheduled for 2026-08-21T11:15Z and is harmless.
- #1009: MERGED 2026-08-19T17:49:00Z; terminal.

Self-improvement: nothing this time.
