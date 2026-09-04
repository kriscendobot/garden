---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-04T03:54:15Z
---
# Dependabotany ledger: endojs/endo-but-for-bots — 2026-09-04 daily backstop

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

Recovered the cumulative ledger with the required case-insensitive heading match
(`grep -rl '^project: endo-but-for-bots$' | xargs grep -il '^# *dependabotany'`)
and reconciled every historical row against live GitHub, base, and schedule
state.

## Active due rows

None. The live open `dependabot[bot]` PR census
(`gh pr list --author app/dependabot --state open`) is empty. Every historical
embargo/escalation row is terminal (the 2026-08-31 rows #1093/#1095 merged; no
other row remains open), so there is no open proposal to conduct, close,
embargo, shepherd, or re-review.

## PR #923 — terminal REJECT re-confirmed

PR #923 remains CLOSED without merge since 2026-08-10T21:25:33Z at unchanged
head `d2635dcead1f15a4e3909a0559c0b01f9bc04b76`, carrying its existing
structured REJECT (stale all-minor-patch group that partially reverts the base).
Live comparison against `llm` has drifted further to `ahead=2 behind=1000`, so
the frozen head is now 1000 commits behind live — a stale, reverting proposal
that cannot be conducted whatever its merits. The prior full source/maturity/
advisory/CI review remains bound to the unchanged head and unchanged in every
leg (freshest moved release `ws@8.21.2`, published 2026-08-03T20:37:45.880Z,
past its 2026-08-10 floor, no OSV finding; the `dompurify` residuals already
dispositioned unreachable on the consumed Monaco path). None of those satisfied
legs revives a closed, 1000-behind, reverting head. No new PR comment or
conductor action warranted; a future maintainer may reopen if the group is
regenerated against live `llm`.

## Schedule state

The daily backstop `dependabotany-recheck-endo-but-for-bots` remains installed
with `preflight: dependabotany-preflight.sh`. No `schedules/once/` residue for
#923 (its one-shot self-deleted when it fired). No schedule mutation needed.

Self-improvement: nothing this time.
