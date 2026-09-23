---
ts: 2026-06-03T20:33:36Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--0b44dc
prs:
  - repo: endojs/endo-but-for-bots
    pr: 400
    role: target
refs:
  - entries/2026/06/03/201420Z-dispatch-liaison-0b44dc.md
  - https://github.com/endojs/endo-but-for-bots/pull/400
  - https://github.com/endojs/endo-but-for-bots/pull/400#pullrequestreview-4415515901
  - https://github.com/endojs/endo-but-for-bots/pull/400#issuecomment-4616473434
---

# result: fixer — #400 milestone renumbering per kriskowal review 4415515901

Applied the review's directive to resequence milestones starting at 1
with whole-number increments, no later milestone depending on an
earlier one, and the hosted-Gateway-service north star pulled forward.
The roadmap file `designs/README.md` is the only artifact edited (per
the dispatch's "edit roadmap file only; no design-doc rewrites"
authorization).

## Old → new milestone numbering map

| Old | New | Title | Notes |
|-----|-----|-------|-------|
| M0 | **M1** | Downloadable AI Agent Experience | Complete |
| M½ | **M2** | Project Hygiene | substantially Complete (1 row remaining) |
| M1 | **M3** | Remote Access & Coding Capabilities | the gateway substrate; contains gateway-package implementation stack + endo-gateway-mcp |
| M2 | **M4** | Networking | daemon-agent-network-identity is the keypair side that M5 OAuth bonding builds on |
| M7 | **M5** | Public Hosting & Billing | AWS stack + 3 design gaps (gateway-oauth-bonding, gateway-key-recovery, gateway-stripe-adapter) |
| Milestone B | **M6** | MCP Bridge Hosting | was a cross-cutting cut; now a numbered milestone with P0-P4 slice plan inside |
| M3 | **M7** | Weblets & Integrations | not entrained by gateway north star; defers behind M5/M6 |
| Milestone A | **M8** | Peer App Sharing | was a cross-cutting cut; now a numbered milestone with P0-P3 slice plan inside |
| M4 | **M9** | UX Polish and Agent Tooling | not entrained |
| M5 | **M10** | Capability Confinement & Ecosystem | not entrained |
| M6 | **M11** | Rust Daemon (`endor`) | research-heavy; stays last |

## Dependency DAG note

No later milestone is a dependency of an earlier milestone under the
new ordering:

- **M5** (Public Hosting) depends on M3 `gateway-package` and M4
  `daemon-agent-network-identity`. Both earlier. OK.
- **M6** (MCP Bridge) depends on M3 gateway-package phases 2/7/8 (UDS
  bootstrap, AppsNameHub, ResourceLedger) and on M5
  hosting/billing/identity. Both earlier. OK.
- **M7** (Weblets) prereqs live in M3 (`daemon-mount`,
  `daemon-checkin-checkout`). OK.
- **M8** (Peer App Sharing) depends on M4 (`ocapn-noise-network`
  Complete, `daemon-agent-network-identity`) and M7 (weblets +
  `exo-zip-package`). OK.
- **M10** (Confinement) prereqs live in M3 (`platform-fs`). OK.

No finer-grained bucket split was required to satisfy the invariant;
the existing milestone partitions sequenced cleanly under the new
numbering once the cuts (A, B) became regular milestones and the old
M7 (Public Hosting) was pulled forward. The directive's "finer-grained
buckets" allowance was held in reserve and not exercised in this pass.

## Gateway-entrained vs deferred breakdown

**Entrained by the hosted-Gateway-service north star (pulled forward
to M3-M6):**

- **M3** — gateway-package implementation stack (PRs #343, #388-#397,
  phases 10/11 pending), `endo-gateway`, `endo-gateway-mcp` (the
  design; impl moves to M6), plus strategic-early `endoclaw-timer` and
  `endoclaw-network-fetch`.
- **M4** — `daemon-agent-network-identity` (keypair side of M5 OAuth
  bonding); `ocapn-noise-network` Complete; remaining OCapN rows.
- **M5** — Public Hosting & Billing: AWS deployment stack (PR #356) +
  three design gaps (`gateway-oauth-bonding`, `gateway-key-recovery`,
  `gateway-stripe-adapter`).
- **M6** — MCP Bridge Hosting: MCP `/mcp` adapter, `@endo/agent-tools`
  extraction, end-to-end MCP-client-to-Endo-agent round-trip. The
  north-star deliverable.

**Deferred to later milestones (not entrained):**

- **M7** — Weblets & Integrations: agent-side OAuth (`endoclaw-oauth`
  is distinct from `gateway-oauth-bonding`), weblet hosting, proactive
  messages, notifications, voice. Familiar-experience capabilities.
- **M8** — Peer App Sharing: peer-to-peer, not hosted-gateway.
- **M9** — UX Polish: chat-pending-commands, inventory tooling.
- **M10** — Confinement: process sandboxing, browser automation,
  channel bridges.
- **M11** — Rust Daemon: research-heavy port.

## New head SHA + commit messages

- New head: `956500ad7720119f135e644b80d1c45a08f83516`
- Push: regular append (no force) onto `groom/mcp-bridge-rebucket`
  from prior head `0289d3759`.

Single commit:

```
956500ad7 docs(designs): renumber milestones to integer sequence per maintainer directive
```

The commit message includes the full old → new mapping table, a
dependency-invariant verification block, and a `Refs: pull request
#400 review 4415515901` line.

## Top-level PR comment ID

`4616473434`
(https://github.com/endojs/endo-but-for-bots/pull/400#issuecomment-4616473434)

The comment carries the renumbering map, the dependency-invariant
analysis, the gateway-entrained-vs-deferred breakdown, the
Strategic-Early item adjustment (dropping `endo-gateway-mcp` because
M6 is now its home), the cross-cutting-cuts-to-numbered-milestones
note, the Summary-by-Milestone and Timeline-table updates, and the
judgment-calls section. The comment closes with `cc @kriskowal`.

Review re-requested from kriskowal via the JSON-body shape per the
fixer norm.

## Judgment calls

- **Old M7 (now M5) pulled all the way forward to position 5** —
  directly delivers the hosted-Gateway-service north star. Its
  dependencies on `gateway-package` (M3) and
  `daemon-agent-network-identity` (M4) are already earlier under the
  renumbering, so the invariant holds. The maintainer's
  "prioritizing... hosted Gateway service" directive made this the
  highest-priority deferral candidate.
- **Old M3 (now M7) deferred past M5/M6** — the directive explicitly
  said work not entrained by the gateway north star defers to later
  milestones. M7's weblets/OAuth/proactive-messages content is
  Familiar-experience work, not hosted-gateway work, so deferring it
  past the hosted-Gateway milestones (M5, M6) honored the directive's
  intent. Hesitated briefly because old M3 has been the
  "weblets-and-integrations" home for the project's whole history;
  the renumbering is structurally jarring. Mitigated by the
  parenthetical "(Was Milestone 3 before the 2026-06-03 renumbering
  pass...)" annotation on each new heading.
- **No finer-grained bucket splits** — the directive offered finer
  buckets as a fallback for satisfying the dependency invariant; the
  existing partitions sequenced cleanly under the new numbering, so
  no splits were performed. This kept the diff smaller and avoided
  introducing artificial sub-milestones that the maintainer would
  then need to adjudicate.
- **`endo-gateway-mcp` design row left in M3 with a "design lives
  here; impl moves to M6" framing** — the M3 entry retains the design
  row because the design is what M3 owns (the gateway substrate's
  MCP-termination contract). The implementation work (the `/mcp`
  adapter, `@endo/agent-tools` extraction) is the M6-owned slice. The
  Strategic Early Items table drops `endo-gateway-mcp` because M6 is
  now the MCP-bridge milestone in its own right; the strategic-early
  framing was a workaround for the cut's cross-cutting shape, which
  the renumbering dissolved.
- **Historical Calibration round tables (2026-05-20, 2026-05-14)
  retain pre-renumbering milestone labels** — those tables record
  point-in-time velocity data; the labels are part of the historical
  record and should not be retroactively rewritten. Added a clarifier
  paragraph at the top of the historical Progress-as-of section
  explaining that the older labels are pre-renumbering and pointing
  readers at the 2026-06-03 progress paragraph for the mapping.
- **The Per-Design Estimates table** uses the post-renumbering
  integer milestone column with a one-line legend explaining the
  remap. Added the four `gateway-*` rows (gateway-package,
  gateway-packaging-ci, gateway-aws-deployment, gateway-aws-attuned)
  plus the three gap rows and the `endo-gateway-mcp` row (now in M6
  rather than M3) so the table is complete against the new milestone
  set.
- **The Mermaid Gantt and the Timeline cumulative-target-date table
  re-projected** to sequence M1 through M11 with the new
  dependency-respecting order. Used short per-milestone durations
  (M5 6 weeks, M6 2 weeks, M8 3 weeks) as best estimates pending the
  next calibration round; the cumulative target dates are
  illustrative, not load-bearing.

## Definition of done

- All five concrete asks from the dispatch addressed:
  - [x] Start milestone numbering at 1, integer-increment only.
  - [x] Rename "Milestone 0" → "Milestone 1" and "Milestone half" →
    "Milestone 2" (both complete; preserve completion status).
  - [x] Assign integer numbers to "Milestone A" and "Milestone B" (A → 8, B → 6).
  - [x] Enforce dependency ordering (no later milestone is a
    dependency of an earlier one).
  - [x] Hosted-Gateway-service north star: work NOT entrained defers
    to LATER milestones (M7-M11).
- Single regular-append commit pushed to `groom/mcp-bridge-rebucket`.
- Top-level PR comment posted (ID `4616473434`).
- Review re-requested from kriskowal.
- No design-doc rewrites; only `designs/README.md` was edited.

Self-improvement: nothing this time. The milestone-renumbering case
is genuinely one-off; the project will not face it again unless the
maintainer requests another renumbering pass. The dispatch's
"edit roadmap file only" authorization was sufficient to scope the
work without rewriting downstream design-doc cross-references; that
discipline kept the diff focused and the per-design status fields
untouched.
