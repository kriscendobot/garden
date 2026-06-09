---
ts: 2026-06-09T04:35:00Z
kind: result
role: designer
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
dispatch_root: /home/kris/dispatches/designer--04b954
short_id: 04b954
to: steward
refs:
  - entries/2026/06/09/041700Z-dispatch-researcher-3ab7bd.md
  - entries/2026/06/09/042500Z-result-researcher-3ab7bd.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: predecessor
---

# result: designer authored packages/immutable-arraybuffer/DESIGN.md for the drop-the-pseudo-prototype redesign (04b954)

## What landed

A single new file at `packages/immutable-arraybuffer/DESIGN.md` (529
lines, one commit, one push) captures erights's redesign per
[PR #430 comment `4655451705`](https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4655451705).

- Branch: `design/immutable-arraybuffer-drop-the-pseudo-prototype` on
  `origin` (`endojs/endo-but-for-bots`).
- Commit: `a4ce95b0c` ("docs(immutable-arraybuffer): DESIGN.md for
  drop-the-pseudo-prototype redesign").
- Base: master at `4a04d078b`.
- No PR opened per dispatch instruction (the builder opens the PR
  with its first commit).

## Structure of the document

The DESIGN.md is organised as five concrete moves (each a diff from
master), a mermaid before/after diagram, a test plan, an
alternatives-considered section that pre-empts the obvious
back-pressure, an open-questions section that calls each of the four
dispatch-named questions, an out-of-scope section, and a references
section. Sections in order:

1. *Problem* (why the intermediate prototype + permits entry +
   two-surface README are artifacts worth removing).
2. *Design* with five moves:
   - Move 1: rename "pony" to "lib" (filenames, identifiers, tests,
     README; the historical CHANGELOG entry stays as historical
     artifact).
   - Move 2: amplifier-with-this-fallthrough extended to ArrayBuffer.
     The lib's `getBuffer` (today `immutable-arraybuffer-pony.js:97-105`)
     renames to `amplifyArrayBuffer` and returns `this` on
     fallthrough. Read accessors and slice straight-delegate; the four
     mutators (`resize`, `transfer`, `transferToFixedLength`,
     `transferToImmutable`) discriminate on WeakMap membership and
     delegate to the captured genuine method on fallthrough.
   - Move 3: pseudo-prototype becomes a property record
     (`immutableArrayBufferLibProperties`). Emulated immutables
     directly inherit from `ArrayBuffer.prototype`. The public
     exports narrow to `isBufferImmutable` only; the two free
     functions (`sliceBufferToImmutable`,
     `optTransferBufferToImmutable`) become internal-only.
   - Move 4: shim copies the lib's property record onto
     `ArrayBuffer.prototype`. Warn-and-overwrite policy preserved
     with an expected-overwrite list filtering the four
     genuine-method overwrites out of the warning.
   - Move 5: delete the `%ImmutableArrayBufferPrototype%` permits
     entry (`packages/ses/src/permits.js:1393-1412`) and the
     throwaway-instance prototype walk
     (`packages/ses/src/get-anonymous-intrinsics.js:170-177`).
3. *Diagram*: mermaid flowchart showing prototype chains before/after.
4. *Test plan*: existing unit tests adapt (import-path rename,
   prototype assertions change to `=== ArrayBuffer.prototype`); new
   tests cover the amplifier-fallthrough behaviour on genuine
   ArrayBuffers and the dropped purposeful-violation
   (`Object.prototype.toString.call(immuAB) === '[object ArrayBuffer]'`).
5. *Alternatives considered*: rename-only, eliminate-the-lib-entirely,
   detect-then-skip shim policy. Each with a one-line rejection
   reason.
6. *Open questions*: the four explicit calls (see below).
7. *Out of scope*: TypedArray-side analog, premise-2, bytes-side
   migration, README purposeful-violation full deletion.
8. *References*: erights's comment, the maintainer's authorization
   comment, PR #417 (six premises), PR #430 (working pattern),
   `packages/module-source/DESIGN.md` (structural precedent),
   `docs/spackle.md` (no-spackle framing).

## Explicit calls on the four dispatch-named open questions

1. **Premise-2 in/out**: OUT. This PR keeps `index.js` and the `.`
   export (narrowed to `isBufferImmutable` only). Premise-2 (the
   `exports`-narrowing from PR #430 commit `a5e31162` plus the bytes
   migration from `2aec9ce92`) is a separate prerequisite/follow-up
   PR.
2. **Shim install policy warn-vs-skip**: WARN-AND-OVERWRITE (master's
   current policy preserved). The PR #430 detect-then-skip is
   appropriate for the freezable-TypedArray side where the proposal
   is at stage 1; for the immutable-ArrayBuffer side, detect-then-skip
   would mean a half-installed shim on platforms that ship
   `sliceToImmutable` natively before proposal stage 4. The expected
   four-method overwrite list (`slice`, `resize`, `transfer`,
   `transferToFixedLength`) filters out of the warning to keep
   cold-start logs clean.
3. **CHANGELOG rewrite scope**: LEAVE AS HISTORICAL. The
   `CHANGELOG.md:18` "sliceToImmutable Hermes ponyfill and shim" entry
   describes what shipped at cycle 201 and is not retroactively
   rewritten.
4. **Companion `packages/ses/DESIGN.md`**: NO. The ses-side changes
   are small enough (one twenty-line permits-entry deletion + one
   eight-line intrinsics-sampling deletion) that Move 5 captures them
   inline. If `packages/ses/` later accumulates DESIGN.md sections
   for other architectural threads, the permits-removal can fold in
   there at that time.

## Builder's recommended starting state

- **Branch**: start from `design/immutable-arraybuffer-drop-the-pseudo-prototype`
  on `origin` (which already carries the DESIGN.md), or check out
  master and merge/cherry-pick the DESIGN.md commit (`a4ce95b0c`)
  forward. Either works; the simpler shape is to use the design
  branch as the implementation branch's base and rename it on first
  push to `build/immutable-arraybuffer-drop-the-pseudo-prototype` (or
  similar). The maintainer's dispatch authorization explicitly said
  "designer and builder run serially, without waiting for a review or
  landing on the design", so the builder is free to take the design
  commit forward without waiting for design review.
- **Implementation order**: do Moves 1+3 together first (the rename
  and the prototype downgrade are tightly coupled; the rename
  touches all the same files the prototype-downgrade touches), then
  Move 2 (the amplifier-fallthrough extensions to the methods), then
  Move 4 (the shim's adapted install), then Move 5 (the ses-side
  permits/intrinsics deletions, which are best in their own commit
  because they cross the package boundary). The CHANGELOG entry for
  the package and the README rewrite of *Move 1* fold into the
  first commit.
- **First DESIGN.md section to implement**: *Move 1* (rename) +
  *Move 3* (pseudo-prototype to property record). These two are the
  structural foundation; the other three moves depend on the
  property record existing.
- **The TypedArray-side analog is explicitly out of scope** per the
  DESIGN.md. The builder should not import any of the experiment
  branch's `freezable-typedarray-pony.js`,
  `immutable-arraybuffer-pony-internal.js`, `internal-heir.js`,
  `amplifyTypedArray`, `virtualTypedArrayBufferGetter`,
  `hiddenTypedArrays`, `makePseudoTypedArrayConstructor`, or
  `makeInternalHeir`. Those are a separate PR.
- **Premise-2 is out of scope** per the DESIGN.md. The builder should
  NOT modify `packages/immutable-arraybuffer/package.json`'s
  `exports` field beyond what *Move 3*'s narrowed-public-exports
  requires, and should NOT touch `packages/bytes/src/to-immutable.js`
  except for the JSDoc terminology rewrite under *Move 1*. If the
  builder finds either change is unavoidable to make tests pass, it
  should surface that as a discovery and let the steward decide
  whether to expand the PR scope.

## Self-improvement

Nothing this time. The dispatch and the researcher's prior result
gave precise pointers (file paths, line numbers, permits entry
locations, the experiment-branch commits to reference). The DESIGN.md
shape (status table + problem + numbered design moves + diagram +
test plan + alternatives + open questions + out of scope + references)
mirrors `packages/module-source/DESIGN.md`, the tree's only existing
in-package DESIGN.md, so no new convention needed to be invented.
The decision to make explicit calls on all four open questions (per
the dispatch instruction) rather than leaving them open for the
maintainer is documented in the open-questions section itself, with
each call's rationale, so a future builder or reviewer can see the
reasoning chain.
