---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-09-02T04:07:08Z
---
# Dependabotany ledger: endojs/endo-but-for-bots — 2026-09-02 daily backstop

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

Recovered the cumulative ledger with the required case-insensitive heading match
and reconciled every due row against live GitHub, base, registry maturity,
advisory, source-review, and head-bound CI state.

## Active due rows

None. The live open `dependabot[bot]` PR census is empty. Every historical
embargo/escalation row is terminal, so there is no open proposal to conduct,
close, embargo, shepherd, or re-review.

## PR #923 — terminal REJECT re-confirmed

PR #923 remains CLOSED without merge since 2026-08-10T21:25:33Z at unchanged
head `d2635dcead1f15a4e3909a0559c0b01f9bc04b76`, with its existing structured
REJECT verdict. GitHub still reports the head `CONFLICTING/DIRTY`; the live
comparison is now 943 commits behind `llm` and 2 ahead. Live `llm` specifies
`@earendil-works/pi-agent-core` and `@earendil-works/pi-ai` at `^0.84.2`, while
the unchanged reviewed head proposes `^0.82.1`. Reopening or conducting would
still partially revert the base, so the terminal stale-group rejection remains
correct independently of every other gate.

The prior full source review remains bound to the unchanged head. Its freshest
moved release, `ws@8.21.2`, remains published at
2026-08-03T20:37:45.880Z with unchanged registry integrity, is not deprecated,
and is well past the 2026-08-10T20:37:45.880Z maturity floor. A fresh OSV query
returns no advisory for `ws@8.21.2`; `dompurify@3.4.8` still returns exactly the
same four residual advisories already dispositioned as unreachable on the
consumed Monaco path (`GHSA-55q2-fjhq-7xh7`, `GHSA-c2j3-45gr-mqc4`,
`GHSA-cmwh-pvxp-8882`, `GHSA-vxr8-fq34-vvx9`). The unchanged head still has
24/24 completed-success check runs. None of these satisfied legs revives a
closed, stale, reverting proposal.

## Schedule state

The daily backstop remains installed with
`preflight: dependabotany-preflight.sh`. The PR #923 one-shot self-deleted when
it fired; no precise-recheck residue or schedule mutation is needed. No PR
comment or conductor action was warranted.

Self-improvement: nothing this time.
