---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-08-21T17:08:59Z
---
# Dependabotany ledger: endojs/endo-but-for-bots - 2026-08-21 daily backstop, active set empty

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

## Active rows

None.

The cumulative case-insensitive ledger recovery was reconciled against live
GitHub state at 2026-08-21T17:05Z. `gh pr list --author app/dependabot --state
open` returned no rows, so there was no due open Dependabot PR to re-evaluate or
conduct.

The schedule's explicitly named PR #923 remains terminal: CLOSED without merge
at 2026-08-10T21:25:33Z, head
`d2635dcead1f15a4e3909a0559c0b01f9bc04b76`. Its existing structured REJECT
(stale group, base moved past it) verdict is at
https://github.com/endojs/endo-but-for-bots/pull/923#issuecomment-5246221502.
The later ledger rows are also terminal: PR #1007 merged at
2026-08-21T02:53:52Z as
`122fc2644b429ca80debc18871ec9f236bcbb149`, and PR #1005 remains CLOSED as
superseded by merged PR #1037.

No PR comment, close, rebase, or conductor action was needed. The daily
heartbeat remains present but idle-gated. Its preflight had failed to recognize
the compact `## Active rows` / `None.` drain declaration and therefore kept
redispatching against historical `EMBARGO-*` dates. Garden commit
`1c3dd9b85eeec87ca0b71381eb5f8a340e08e3b7` adds conservative recognition of
that structured form plus a hermetic regression case (15/15 checks passed) and
is pushed to `main2`.

Self-improvement: scripts/jobs/dependabotany-preflight.sh and its regression
test now recognize a structured empty active-row set, preventing repeated idle
backstop dispatches after the ledger drains.
