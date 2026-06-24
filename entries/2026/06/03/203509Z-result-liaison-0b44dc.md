---
ts: 2026-06-03T20:35:09Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/03/201420Z-dispatch-liaison-0b44dc.md
  - entries/2026/06/03/203336Z-result-fixer-0b44dc.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 400
    role: target
---

# result: #400 milestone renumber applied (the dispatch I had missed)

User correction: "This seems to have been missed. Please
dispatch a fixer." The steward had earlier misclassified #400
as "contractor scope" because the contractor opened it; per
`roles/steward/AGENT.md` § Subordinate roles, a maintainer
roadmap-edit directive is steward-dispatchable regardless of
opener. Fixer `0b44dc` closed cleanly.

## Outcome

- **New head**: `956500ad7` (regular append on `0289d3759`).
- **Commit**: `docs(designs): renumber milestones to integer
  sequence per maintainer directive` (single commit, 466+/342-
  on `designs/README.md`).
- **PR comment**: `4616473434` carrying full mapping +
  dependency invariant + entrained/deferred breakdown.
- **Re-requested review** from kriskowal.

## Numbering map

| Old | New | Title |
|---|---|---|
| M0 | M1 | Downloadable AI Agent Experience (Complete) |
| M½ | M2 | Project Hygiene (substantially Complete) |
| M1 | M3 | Remote Access + Coding (gateway substrate) |
| M2 | M4 | Networking |
| M7 | M5 | Public Hosting + Billing (pulled forward; hosted-Gateway home) |
| B   | M6 | MCP Bridge Hosting |
| M3 | M7 | Weblets + Integrations (deferred — un-entrained) |
| A   | M8 | Peer App Sharing |
| M4 | M9 | UX Polish |
| M5 | M10 | Confinement |
| M6 | M11 | Rust Daemon |

## Gateway-entrained vs deferred

- **Entrained (M3-M6)**: gateway-package stack, OCapN
  networking, AWS deployment + 3 design gaps, MCP `/mcp`
  adapter.
- **Deferred (M7-M11)**: weblets, peer app sharing, UX
  polish, confinement, Rust port.

## Dependency DAG invariant

Verified: no later milestone depends on an earlier one. No
finer-grained bucket splits required.

## Self-correction recorded

I had this miss because I treated PR-opener identity as the
ownership signal. The correct signal is the maintainer
directive — anyone in the steward/contractor peer set can
dispatch against an actionable review on a kriscendobot PR.
The steward role explicitly says so.

Apologies. Won't repeat.

## Teardown

`dispatches/fixer--0b44dc` torn down.

## Steward queue post-engagement

- **#400** renumbered at `956500ad7`; review re-requested;
  awaits maintainer reassessment.
- **#417** gamut stage 4 (justice re-panel) in flight as
  `justice--53be75`.
- All other queue items unchanged.
