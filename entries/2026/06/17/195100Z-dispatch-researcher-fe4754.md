---
ts: 2026-06-17T19:51:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--fe4754
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/435#issuecomment-4729159389
  - https://github.com/endojs/endo-but-for-bots/pull/435
---

# dispatch: researcher — scope "delayed freezable TypedArray emulation" for new PR

User directive (kriskowal via garden, 2026-06-17T19:50Z) relaying erights' ask on PR #435 (2026-06-17T10:55Z):

> @kriscendobot , please start a new PR to do the delayed freezable TypedArray emulation.

This is a fresh feature request distinct from PR #435 (immutable-arraybuffer drop-the-pseudo-prototype). Per the researcher precedence rule in CLAUDE.md, this dispatch precedes the designer/builder dispatch that opens the new PR.

## State at dispatch time

- **PR #435** at head `b1eceee2b` (post fixer eba5aa). All 29 of erights' initial review-comment asks plus 7 nudge follow-ups are addressed.
- **Master tip**: `4a04d078b` (current).

## Task

In your `project/` worktree at `4a04d078b`:

1. **Library and project references**:
   - Read `packages/immutable-arraybuffer/README.md` and `DESIGN.md` to understand the "Move 3 / Move 4" architecture and what's already in place.
   - Read `packages/immutable-arraybuffer/src/lib.js` (the polyfill / shim source).
   - Read TC39 proposal `freezable-typed-arrays` (search the GitHub: https://github.com/tc39/proposal-freezable-typed-arrays or similar). Note current stage status (the immutable-arraybuffer proposal is at stage 3; freezable TypedArrays is part of the same proposal at stage 3 per erights' earlier comments).
   - Look at upstream endojs/endo for any related work (search for `freezable`, `freezableTypedArray`, `TypedArrayShim`, etc.).
   - Look at how the current shim handles TypedArrays (if at all).

2. **Define "delayed" semantics**: erights said "delayed freezable TypedArray emulation". Hypothesis: TypedArrays expose mutator methods on their `.prototype` (e.g., `Int8Array.prototype.set`, `.fill`, `.sort`, `.copyWithin`, `.reverse`). A "freezable" emulation would either:
   - At construction time, take an immutable view: cheap but eager.
   - Or "delayed": expose a method (e.g., `.freeze()` or `.toImmutable()`) that materializes the immutable view lazily.
   - Confirm which semantics erights wants by reading any earlier related comments on #435 or in adjacent threads.

3. **Identify scope** for the new PR:
   - **Branch name**: probably `build/freezable-typedarray-emulation` or similar.
   - **Base branch**: master or llm (likely master since immutable-arraybuffer is on master).
   - **Files to touch**: `packages/immutable-arraybuffer/src/lib.js` (likely), `DESIGN.md`, `README.md`, plus tests + changeset.
   - **Tests needed**: per-TypedArray-flavor coverage (Int8, Uint8, Int16, Uint16, Int32, Uint32, BigInt64, BigUint64, Float32, Float64) for the freeze/lazy-immutability path.

4. **Identify the role chain** to open the new PR:
   - `designer` → produce a design doc + spec.
   - `builder` → implement against the design.
   - `cleaner` → gauntlet hygiene.
   - `barrister/justice` → panel review.
   - `conductor` → merge.

5. Produce a `## Library and project references` section in the result entry that the next dispatcher (the orchestrator dispatching the designer) will inline into that designer's brief.

## Authorizations

- Read-only on the project.
- Write to the journal (`result` entry).

## Out of scope

- Do NOT open the new PR yet (that's the builder's job after the designer's spec).
- Do NOT modify any existing PR.

## Deliverable

A `result` entry under `journal/entries/2026/06/17/` naming:

- The TC39 proposal status + relevant artifacts found.
- Hypothesis (with citations) of what "delayed freezable TypedArray emulation" means.
- Recommended scope for the new PR (files, tests, semantics).
- Recommended next role: `designer` (to produce a design doc and surface open questions to the maintainer).
- A `Self-improvement: ...` line.
- A `## Library and project references` section the next designer dispatch should inline.

End your turn with a concise summary back to the orchestrator.
