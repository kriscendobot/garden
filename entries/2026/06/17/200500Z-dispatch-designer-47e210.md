---
ts: 2026-06-17T20:05:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: designer
dispatch_root: /home/kris/dispatches/designer--47e210
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/435#issuecomment-4729159389
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/17/195947Z-result-researcher-fe4754.md
---

# dispatch: designer — DESIGN.md for delayed freezable TypedArray emulation per erights

User directive (kriskowal via garden, 2026-06-17T19:50Z) relaying erights' ask on PR #435 (2026-06-17T10:55Z):

> @kriscendobot , please start a new PR to do the delayed freezable TypedArray emulation.

Researcher `fe4754` produced a thorough scope analysis at `journal/entries/2026/06/17/195947Z-result-researcher-fe4754.md` — read it verbatim before starting.

## Researcher's findings

- **TC39 proposal**: `tc39/proposal-immutable-arraybuffer` at Stage 2.7. The freezable-TypedArray behavior is a consequence of immutable backing buffers, not a separate proposal.
- **"Delayed" semantics**: SEQUENCING (after PR #435 merges), NOT runtime lazy. The runtime semantics are standard constructor-time-determined-by-backing-buffer.
- **Builder depends on PR #435 merging first**; designer can run independently NOW.
- **Reference experiment**: `experiment/no-spackle-immutable-arraybuffer-417` branch carries a prototype.
- **Per-TypedArray-flavor coverage** needed for 11 concrete constructors (Int8/16/32, Uint8/16/32, Uint8Clamped, Float32/64, BigInt64, BigUint64).

## 3 open questions to surface in the design doc

1. Confirm "delayed" reading is sequencing, not runtime lazy.
2. DESIGN.md placement: extend existing `packages/immutable-arraybuffer/DESIGN.md` vs sibling file (e.g., `DESIGN-freezable-typedarray.md`)?
3. `[Symbol.toStringTag]` decision on the freezable-TypedArray side parallel to PR #435's purposeful-violation retirement?

## State at dispatch time

- **Master**: `4a04d078b`.
- **PR #435** still OPEN (CHANGES_REQUESTED awaiting erights re-review on head `b1eceee2b`).

## Task

In your `project/` worktree at `4a04d078b`:

1. Read the researcher's full `result` entry (`journal/entries/2026/06/17/195947Z-result-researcher-fe4754.md`).
2. Read `packages/immutable-arraybuffer/DESIGN.md`, `README.md`, `src/lib.js`, the TC39 proposal text (linked in researcher entry).
3. Inspect the `experiment/no-spackle-immutable-arraybuffer-417` branch for the prototype shape.
4. Draft a design doc covering:
   - **Problem statement**: why freezable TypedArrays, what the emulation provides.
   - **API surface**: per-TypedArray-flavor pseudo-constructors, what they do at construction time from an immutable buffer.
   - **Semantics**: mutator behavior (throw vs silent), indexed-assignment behavior, `isFrozen` semantics, `.buffer` access.
   - **Implementation outline**: `freezable-typedarray-lib.js`, integration with shim, permits.js extension.
   - **Test plan**: per-flavor matrix.
   - **Scope statement**: depends on PR #435 merging; sibling vs extended DESIGN.md placement (default: sibling, but flag for maintainer).
   - **Open questions section**: name the 3 above explicitly.
   - **Out of scope**: anything that's a future PR.
5. Open a fresh DRAFT design PR per the standard design-pr-creation-flow:
   - Branch name: `design/immutable-arraybuffer-freezable-typedarray-emulation` (per researcher recommendation).
   - Base: `master`.
   - Title: `design(immutable-arraybuffer): freezable TypedArray emulation (followup to #435)`.
   - PR body summarizes the design + names the 3 open questions explicitly + tags @kriskowal and @erights.

## Authorizations

- Push to a new branch `design/immutable-arraybuffer-freezable-typedarray-emulation`.
- Open the new DRAFT PR.
- Top-level comment on the new PR.

## Out of scope

- Do NOT touch PR #435 (it's mid-review).
- Do NOT touch upstream endojs/endo.
- Do NOT implement (builder's role).

## Deliverable

A `result` entry under `journal/entries/2026/06/17/` naming:

- New PR number + URL + head SHA + branch.
- Design doc summary (sections + key decisions).
- The 3 open questions named.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: solicitor` for design panel after the maintainer responds to open questions, OR `next: liaison` if maintainer should respond before design panel runs.

End your turn with a concise summary back to the orchestrator.
