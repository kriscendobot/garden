---
ts: 2026-05-15T03:45:46Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/15/034700Z-dispatch-liaison-4a8df9.md
---

Gap-revealing skeleton for the per-agent `@transports` design (PR #138)
landed as draft PR endojs/endo-but-for-bots#262, stacked on
`design/ocapn-daemon-integration`. Head SHA: `825e1c1ac`.

**Counts.**
- 17 gaps surfaced (cross-agent loopback distinguisher, listener policy
  site, port allocator, Locator vs string discrimination, transport-hint
  DSL, signingKeys mint vs reuse, async disconnect race, allowedSchemes
  default discovery, malformed-formula restart, daemon-side revocation,
  `@nets` migration shim, formulateTransports call site, host plumbing,
  CLI shape, `endo nets` parallel claim, `EndoNetwork.listen` absence,
  `packages/ocapn-noise-network/` absence).
- 6 skeleton-implemented exos/files (formula-type, interfaces, types.d.ts,
  transports.js, daemon.js wiring, host.js method, cli command +
  endo.js registration — totals 6 daemon + 2 cli; 8 file touches).
- 12 skeleton-abandoned items (agent-formulation auto-bind, provideTransports
  body, non-string connect, listen for any policy, disconnect, shutdown,
  migration shim, signing-key persistence, cross-agent loopback fast path,
  outboundPolicy enforcement, cross-daemon Noise, tests).

**PR body structure** matches the dispatch brief's required four sections:
*Gaps surfaced* (17 numbered entries with where/quote/need/options),
*Skeleton implemented*, *Skeleton not implemented*, *Recommendations to
design author* (separated into must-revise-before-implementation,
implementation-time choices, open-questions to elevate, and process
feedback).

**Discipline.** Per today's self-improvement (filed at
`015257Z-…`), committed and pushed BEFORE doing extended local
validation. Local validation reached `node --check` on every modified
file (clean); no yarn was available (no `node_modules`) so `tsc`, full
`yarn lint`, `ava` were not run from the dispatch root. This is
consistent with the gap-revealing dispatch's framing (the skeleton's
job is to drive contact with the design, not to be feature-complete).

PR stays draft (no judge / cleaner / un-draft loop on this dispatch).
No comment on #138.

Self-improvement: builders implementing from a design should check
"parallel to X" claims (e.g., "endo transports parallel to endo nets")
against the codebase as a *pre-flight* step before writing the first
line of skeleton. The check is cheap (`grep -n "endo nets" packages/cli/`)
and catches a class of design hand-waving that otherwise surfaces only
when the implementer tries to imitate the parallel and finds nothing
to imitate. Filed as gap #15 in the PR body; consider promoting to
`skills/pre-pr-checklist/SKILL.md` or a new `parallel-claim-check`
skill if the pattern recurs.
