---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-27T03:08:08Z
---
# Dependabotany ledger: endojs/endo-but-for-bots - 2026-08-27 daily backstop, active set remains drained

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

Recovered the cumulative ledger with the required case-insensitive heading match
and reconciled its active set against live GitHub, base, registry maturity,
advisory, and head-bound CI state.

## Active rows

None.

The live open `dependabot[bot]` PR census is empty. There is therefore no due
open row to conduct, close, embargo, or shepherd, and no source proposal to
re-read. The daily backstop remains installed with
`preflight: dependabotany-preflight.sh`; no schedule mutation is needed.

## PR #923 - terminal re-confirmation

PR #923 remains CLOSED without merge since 2026-08-10T21:25:33Z at unchanged
head `d2635dcead1f15a4e3909a0559c0b01f9bc04b76`, under its existing REJECT
stale-group verdict. Live `llm` is now 644 commits ahead of the head's merge
base, while the head remains only 2 commits ahead and GitHub reports it
CONFLICTING. The base has advanced the two previously cited agentry pins to
`@earendil-works/pi-agent-core` and `@earendil-works/pi-ai` `^0.84.2`, beyond
the PR's `^0.82.1`, so reopening or conducting would still be a partial revert.

The terminal record's evidence remains internally consistent: all 24 check runs
on the exact head are successful; `ws@8.21.2` remains published at
2026-08-03T20:37:45.880Z and OSV/GitHub report no advisory for it; and
`dompurify@3.4.8` still has the same four known advisories already dispositioned
as unreachable on the consumed Monaco path. These facts do not revive a closed,
stale proposal. No PR comment or conductor action was taken, and no one-shot
schedule residue exists.

Self-improvement: nothing this time.
