---
ts: 2026-06-15T20:47:33Z
kind: result
role: groom
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: f63ece
prs:
  - repo: endojs/endo-but-for-bots
    pr: 444
    role: new
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/444
  - entries/2026/06/02/184646Z-result-groom-cb5fcd.md
  - entries/2026/06/02/184400Z-message-groom-4c3a95.md
---

# result: groom — M2 closure on llm + bulletin maintainer-attention regen (PR #444)

PR #444 DRAFT, base `llm`, head `groom/m2-and-bulletin-regen`.

## M2 verification result

Verified 2026-06-15 against `endojs/endo-but-for-bots@llm` at HEAD
`704c6f3da`:

- turborepo in place: `turbo.json` covers `build`/`lint`/`test`;
  `package.json` declares `turbo: ^2.9.10`.
- Cycle detector CI gate enforces MAX_EDGES=0 via
  `.github/workflows/depcheck.yml`.
- All five cut packages exist under `packages/`: `ses-test`,
  `hex-test`, `harden-test`, `eventual-send-test`, plus the
  `@endo/zip` devDep cleanup.
- Tarjan SCC over `packages/*/package.json`'s
  `dependencies + devDependencies` returns 0 SCCs with > 1 node and
  0 self-loops, on a 477-edge graph.
- M2's other six rows are all Complete or Implemented.

**Verdict:** M2 (Project Hygiene) is fully complete on `llm`. The
upstream-ferry mirror PR #235 against master is M2-orthogonal.

## README edit (one substantive commit)

`docs(designs): M2 (Project Hygiene) → Complete on llm`
(commit `450445906`). Touches:

- Summary table row for `break-dev-dependency-cycles`: In Progress
  → **Complete** (on `llm`), Updated 2026-05-18 → 2026-06-15.
- M2 milestone-table row: status flipped; cuts named.
- M2 "Estimated duration" trailer replaced by a Status: Complete
  line.
- Per-Design Estimates row for `break-dev-dependency-cycles`:
  strikethrough + completion marker.
- Summary by Milestone M2 row: 1 → 0 items remaining; effort
  estimate → Complete.
- Gantt chart M2 band: tagged `:done` with 2026-06-15 end date.
- Cumulative-duration table M2 row: target date 2026-06-15.
- Totals recount: 39 → 40 Complete/Implemented; 18 → 17 In Progress.
- Total-remaining cell: 56 → 55 across milestones.
- New `Progress as of 2026-06-15 (targeted post-event M2 closure)`
  paragraph at the head of the trailing progress block.
- Last-updated prefix updated with the M2 closure summary.

One file changed: 34 insertions, 14 deletions.

## Bulletin maintainer-attention proposal

The PR body carries the verbatim replacement content proposed for
`journal/README.md` § Awaits maintainer review. Per the dispatch
contract, the journal-side commit awaits maintainer disposition; the
proposal is offered through the PR for maintainer review first.

Headline structure:
- Gateway substrate (M3): 12 open DRAFT PRs in the gateway-package
  stack (PRs #343, #388-#397, #409, #410, #412, #413, #420).
- Chat / UX (M9) PRs awaiting review: #405, #432, #440, #442, #403.
- Recently merged PRs that closed prior bulletin items: 11 PRs
  (#400, #376, #418, #131, #408, #423, #433, #439, #404, #106, #441).
- Design-gap roster (M5): three named gaps awaiting maintainer-
  authorized designer dispatches.
- Open questions awaiting maintainer disposition: 5 + 7 + 6 + 6 =
  24 questions across four designer dispatches.
- Endo strategy workstreams A/B/C from 2026-06-11 (carried forward).
- kriskowal/agoric-sdk#5 CI blocker (carried forward).
- Two cross-fork drafts still parked (carried forward).

## Next-available MCP-product tasks

(Per dispatch prompt — restated in the PR body for maintainer
convenience.)

1. **P0** — Gateway implementation stack (M3): 14 open PRs
   (#343, #388-#397, #409, #410, #412, #413, #420). #413 is the
   canonical P0 gap (HTTP listener wire-up).
2. **P1** — MCP JSON-RPC termination (M6, design merged as PR #376):
   gated on gateway phases 2/7/8.
3. **P2** — AWS hosting (M5): PR #356 stacked sibling of #343.
4. **P3** — Stripe billing (M5): `gateway-stripe-adapter` design gap.
5. **P4** — OAuth bonding + key recovery (M5): two design gaps.

## Open questions surfaced for maintainer

The bulletin regen surfaces (does not author) the four prior
open-question batches:

- **groom #400** (5 questions, M5 design-gap M-bins +
  endopi-provider rise + endo-gateway retirement + M6 exit
  criterion):
  [`entries/2026/06/02/184400Z-message-groom-4c3a95.md`](../../../../entries/2026/06/02/184400Z-message-groom-4c3a95.md).
- **chat-inventory-create-menu wizard** (7 questions, in the design
  file itself, revised 2026-06-08).
- **daemon-move-transfer-negotiation** (6 questions, in PR #432
  design body).
- **chat-value-modal-formula-view** (6 questions, folded into
  PR #439 which has now merged).

No new groom-side open questions this pass. The M2 closure is a
single-row reconciliation backed by a verified cycle-graph fact;
the bulletin regen reads as a survey rather than a recommendation.

## Liaison disposition

PR #444 awaits maintainer review. The journal-side bulletin commit
is deferred pending the maintainer's disposition on the proposed
content. Dispatch root tear-down on return per the orchestrator's
contract.

Self-improvement: the prior groom's `Verify upstream PR #N status
before naming it in a bulletin row` discipline carried through cleanly
this pass (every PR named in the bulletin proposal was re-polled at
draft time, surfacing #413's not-merged state and PR #226's CLOSED
disposition before they entered the proposal text). Worth a one-line
addition to `skills/groom-open-questions/SKILL.md` § Inputs that
"named PRs in the proposal text must be re-polled within the same
dispatch", since the groom's targeted-mode procedure (steps 1, 2, 3,
10, 11, 12) does not explicitly call this out.
