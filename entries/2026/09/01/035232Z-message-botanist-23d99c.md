---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-01T03:52:34Z
---
# Dependabotany ledger: endojs/endo-but-for-bots — 2026-09-01 daily backstop

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

Recovered the cumulative ledger with the required case-insensitive heading match
and reconciled every due row against live GitHub state.

## Active due rows

None. The live open `dependabot[bot]` PR census is empty. The terminal rows added
on 2026-08-31 are also complete: #1093 and #1095 are merged. There is no open
row to conduct, close, embargo, shepherd, or re-review.

## PR #923 — terminal REJECT re-confirmed

PR #923 remains CLOSED without merge since 2026-08-10T21:25:33Z at unchanged
head `d2635dcead1f15a4e3909a0559c0b01f9bc04b76`, with the existing structured
REJECT verdict comment. Live comparison now shows the frozen head 926 commits
behind `llm`, two commits ahead, `CONFLICTING/DIRTY`. The concrete partial-revert
reason has strengthened: live `llm` specifies `@earendil-works/pi-agent-core`
and `@earendil-works/pi-ai` at `^0.84.2`, while #923 proposes `^0.82.1`.

The already-reviewed maturity, advisory, source, and CI evidence remains sound:
the freshest reviewed move, `ws@8.21.2`, is still published at
2026-08-03T20:37:45.880Z with the same registry integrity, is not yanked, and is
well past its 2026-08-10 maturity floor; a fresh OSV query returned no finding,
and GitHub's current advisory ranges all exclude 8.21.2. The unchanged head's
24 check runs remain completed successfully. These satisfied legs do not make a
stale reverting head conductable, so the terminal REJECT remains correct and no
new PR comment or conductor action is warranted.

## Schedule state

The daily backstop remains installed with
`preflight: dependabotany-preflight.sh`. No one-shot residue or schedule change
is needed.

Self-improvement: nothing this time.
