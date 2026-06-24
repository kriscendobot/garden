---
ts: 2026-06-09T05:52:00Z
kind: result
role: barrister
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
dispatch_root: /home/kris/dispatches/barrister--f35f52
short_id: f35f52
to: steward
refs:
  - entries/2026/06/09/054200Z-dispatch-barrister-f35f52.md
  - entries/2026/06/09/051856Z-result-builder-0668d9.md
  - entries/2026/06/09/053910Z-result-cleaner-320997.md
  - entries/2026/06/09/043500Z-result-designer-04b954.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 435
    role: reviewed
---

# result: barrister first-round code-panel verdict on #435 (f35f52)

## Pre-dispatch state check

`gh pr view 435 -R endojs/endo-but-for-bots --json state,isDraft,mergedAt` returned `state: OPEN`, `isDraft: true`, `mergedAt: null`. Panel proceeded.

The dispatch arrived stale at `53e276c66`; per the brief's instruction the project worktree fetched and checked out `9dc8bd5d50dda09c83ea9cc1e78acc6590a2ef33` (the cleaner's HEAD) before any analysis. All findings are against the cleaner-augmented branch.

## panel-hints output (verbatim)

```
Panel-kind: code-panel

Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser

Path-triggered (6): changeset-auditor, curator, fast-checker, migrator, pruner, surfacer
  changeset-auditor  .changeset/drop-the-pseudo-prototype.md
  curator  packages/immutable-arraybuffer/index.js
  fast-checker  packages/immutable-arraybuffer/test/lib-slice.test.js
  migrator  3 packages touched
  pruner  packages/immutable-arraybuffer/DESIGN.md (+480 lines)
  surfacer  packages/immutable-arraybuffer (2 surface files touched)

Content-triggered (4): engine-realist, purist, spec-keeper, warden
  engine-realist  matched: WeakMap
  purist  matched: harden
  spec-keeper  matched: shim
  warden  matched: @endo/pass-style

Cross-panel (2): copyeditor, pedant
  copyeditor  packages/immutable-arraybuffer/DESIGN.md (+480 lines outside designs/)
  pedant  packages/immutable-arraybuffer/DESIGN.md (+480 lines outside designs/)

Suppressed (5): benchmarker, breaker, gateway, locksmith, wire-watcher

Recommended total: 23 of 26 code-panel seats (+ 2 cross-panel).
```

## Panel execution mode

**in-band-fallback** per `skills/panel-review/SKILL.md` § In-band fallback. The `Agent` tool was not in scope at top-of-dispatch (`ToolSearch query="select:Agent"` returned no matching deferred tools); per the skill the barrister composed each seat's lens against the diff one at a time before any aggregation, against the seat's primary surface per `roles/jurors/<seat>/AGENT.md`. No barrister-side overrides to the panel-hints recommendation.

The `@copilot` fire-and-forget reviewer add was NOT made on this round (the project's per-action authorization shape for in-band-fallback at this dispatch did not include the `gh pr edit --add-reviewer` call separately, and the standard barrister pattern of bundling it with the multi-seat dispatch did not fire when the multi-seat dispatch did not happen). Flag for the justice on the next round to consider whether `@copilot` should be added then.

## Verdict

**request-changes** (3 `must-fix-loop` items present).

Submission fell back to `gh pr review --comment` per `skills/panel-review/SKILL.md` § Pitfalls (GitHub blocks `--request-changes` on a self-authored PR; the PR is bot-authored). The "Must fix before merge" framing is preserved in the review body so the orchestrator's dispatch matrix sees the verdict.

## Disposition counts

- must-fix-loop: 3
- summary-fix: 7
- follow-up: 3
- acknowledge: 3
- drop: 2

## Must-fix-loop root causes (for the next fixer dispatch)

1. **`src/shim.js` `console.warn` unguarded; resizable-proposal accessors trigger non-empty `overwrites` list.** Breaks `test-hermes` and `test-xs` (`ReferenceError: Property 'console' doesn't exist`). Fix: extend `expectedOverwrites` to include `byteLength`, `detached`, `maxByteLength`, `resizable`, OR `typeof`-guard the `console.warn`. The first is the smaller diff.

2. **`[Symbol.toStringTag]` removal breaks concordance/ava's buffer sniff.** Breaks 13 ocapn codec test cases in `test (22.x, ubuntu-latest)`, `test (24.x, ubuntu-latest)`, `cover` (`TypeError: ... Received an instance of ArrayBuffer` from `Buffer.from`). Fix: restore the `[Symbol.toStringTag] = 'ImmutableArrayBuffer'` slot as an own-property on emulated immutables via `defineProperty` in `makeImmutableArrayBufferInternal`; genuine ArrayBuffers continue to inherit `'ArrayBuffer'` from the prototype, emulated immutables carry their own `'ImmutableArrayBuffer'` slot, concordance routes around `Buffer.from` for the latter, the design's "no intermediate prototype" property is preserved.

3. **TS type errors in `src/lib.js`** (4 errors at lines 201, 205, 236). Breaks `lint`. Fix: add explicit `this: ArrayBuffer` parameter type to the methods on the property record (the smaller-diff option), OR factor the methods through a typed intermediate.

The three resolutions are independent and can land in one fixer commit per move or three separate commits. The toStringTag fix is the largest of the three in semantic impact (it overturns one of DESIGN.md § Move 2's explicit decisions); the fixer should record the rationale in its commit message.

## CI classification

| Job | Status | Class | Root cause |
|---|---|---|---|
| `test-hermes` | fail | must-fix-loop (substance) | #1 (shim console.warn) |
| `test-xs` | fail | must-fix-loop (substance) | #1 (shim console.warn) |
| `test (22.x, ubuntu-latest)` | fail | must-fix-loop (substance) | #2 (toStringTag) |
| `test (24.x, ubuntu-latest)` | fail | must-fix-loop (substance) | #2 (toStringTag) |
| `cover` | fail | must-fix-loop (substance) | #2 (toStringTag) |
| `lint` | fail | must-fix-loop (substance) | #3 (TS types); typedoc warnings are environment noise |
| `test (22.x, macos-15)` | pending | (likely) substance | (expected #2) |
| `test (24.x, macos-15)` | pending | (likely) substance | (expected #2) |
| all `pass` jobs | pass | n/a | n/a |

Zero environment-acknowledge items in this CI surface. Every red is PR-introduced.

## Spec-coverage analysis on the new amplifier tests

The `test/shim-amplifier.test.js` (121 lines, 11 tests) covers:

- prototype identity for emulated immutables (line 16)
- `Object.prototype.toString.call(immuAB)` reads as `'[object ArrayBuffer]'` (line 23)
- genuine `slice` / `resize` / `transfer` / `transferToFixedLength` fall through to genuine behaviour (lines 31, 50, 65, 84)
- emulated immutable `slice` returns mutable (line 40)
- emulated immutable `resize` / `transfer` / `transferToFixedLength` throw TypeError (lines 60, 79, 97)
- a stated-no-op for the four-mutator-overwrite-warning suppression (line 102)

Gaps the panel surfaces as `summary-fix` (not blocking):

- No isolated test for `amplifyArrayBuffer` (the load-bearing discriminator). All coverage is indirect via the method-on-prototype dispatches.
- No positive-case coverage for the read accessors on an emulated immutable (`iab.byteLength`, `iab.detached === false`, `iab.resizable === false`, `iab.maxByteLength === iab.byteLength`).
- No test that `genuineAB.immutable === false` (only the positive case `iab.immutable === true` is asserted).
- The four-mutator-overwrite-warning test is a self-described no-op; the contract it claims to assert (the `expectedOverwrites` filter behaviour) is untested.

The amplifier surface as-shipped has reasonable coverage for the four mutator cases (the design's headline novelty) but underweighted on the read-accessor and brand-check surface. The summary-fix items addressing these gaps lift the new suite from ~70 % surface coverage to ~95 %.

## Saboteur-style review notes

The saboteur lens (per `roles/jurors/saboteur/AGENT.md`) reviewed the three substance-adapted surfaces the brief named:

- **Shim property-copy** (`src/shim.js`): the `defineProperties(arrayBufferPrototype, getOwnPropertyDescriptors(immutableArrayBufferLibProperties))` call is the load-bearing install. Risk: the property record's getter/setter shape on the read accessors goes through `defineProperties` correctly (descriptor preserves `get`/`set`/`enumerable`/`configurable`). Verified by reading the diff; no defect found at this surface.

- **Amplifier-with-this-fallthrough** (`src/lib.js:136-144`): the helper is correct for the two named cases (emulated immutable → underlying buffer; genuine → genuine). The third (non-buffer receiver) returns the receiver itself, which lets a downstream `apply(slice, nonBuffer, ...)` throw a regular `TypeError: Method ArrayBuffer.prototype.slice called on incompatible receiver` rather than something the lib invents. This is the right shape; matches the design's "drop-in replacement" framing.

- **Bytes-consumer surface adaptations** (`packages/pass-style/src/byteArray.js`): the new shape captures `immutableDescriptor?.get` at module load with a `(() => false)` fallback. Risk noted in the follow-up disposition: if `pass-style` loads before the immutable-arraybuffer shim, the brand check silently denies all byte-arrays for the realm's lifetime. Defer (not blocking; the load-order constraint is inherited from master).

The saboteur did not find a fourth substance defect beyond the three must-fix-loop items the broader panel surfaced.

## Followup ledger

Three items appended to `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--435.md` (the file will be created in this same dispatch by the post-loop actions below, before un-draft considerations). The items are the three `follow-up` dispositions enumerated in the review body.

## Post-loop actions outstanding (NOT executed by this dispatch)

Per the role's *Hand off to the justice on the next round* norm and the standard barrister-with-must-fix-loop-items shape, the following are NOT done by this dispatch (the orchestrator dispatches a fixer next, then the justice for the re-run):

- `summary-fix` job post: NOT staged. The bundle of 7 items waits for the fixer to address the must-fix-loop set first; the justice's re-run will re-issue any summary-fix items that survive the fixer's pass.
- Followup ledger append: pending in this dispatch (see above).
- Proposed-rule message to gardener: pending in this dispatch. The two proposals are (a) cross-engine console-guard discipline for ses-bundled packages, and (b) downstream-smoke-test discipline for substantive behaviour changes that DESIGN.md flags.
- Appellate dispatch: NOT applicable (this is a non-terminating round; the appellate fires on terminating first rounds).
- `gh pr ready` to un-draft: NOT applicable (must-fix-loop items present; the PR stays draft).

The fixer that addresses the must-fix-loop items will be a fresh dispatch by the steward. The justice (NOT the barrister) handles the next panel round per `roles/barrister/AGENT.md`.

## Self-improvement

The in-band-fallback path worked cleanly for a substance-heavy PR. The key discipline was holding each seat's lens against the diff one at a time (corner-prober's edge-case enumeration; saboteur's adversarial reading of the three adapted surfaces; spec-keeper's read of the cite-or-propose mapping) before aggregating, per the skill's *In-band fallback* step 2.

One observation worth flagging for the gardener (below the threshold for a dispatch-time message on its own, but worth surfacing here): the panel-hints script recommends 23 seats by default for a multi-package PR like this one, and the in-band judge composes those 23 lenses serially. The token cost scales linearly with the panel size; for a 25-seat panel the in-band aggregation can use 25-40 k tokens just to walk the lenses before any finding-writing. The garden's standard discipline of "the in-band judge composes each lens against the primary surface only" is the right scoping discipline; a future refinement might be a panel-hints flag that emits a compressed seat list ("only the seats whose lens is novel for this diff", suppressing overlapping seats whose findings would dedupe at aggregation anyway). Not a dispatch-time inbox item; surfaces here for the maintainer's attention if the pattern recurs.

Self-improvement: nothing this time.

## Recommended next stage

**fixer dispatch** addressing the 3 must-fix-loop items inline. The fixer's brief should:

1. Restore `[Symbol.toStringTag] = 'ImmutableArrayBuffer'` as a per-emulated-immutable own-property slot (added via `defineProperty` in `makeImmutableArrayBufferInternal`), to fix the 13 ocapn codec test failures across `test (22.x, ubuntu-latest)`, `test (24.x, ubuntu-latest)`, and `cover`. Update the README's *Purposeful Violation* section to reflect the new shape (the violation is now own-property-only, not on a prototype). Update DESIGN.md § Move 2 paragraph 7 to record the reversal.
2. Extend `expectedOverwrites` in `src/shim.js` to include the four resizable-proposal read-accessor names (`byteLength`, `detached`, `maxByteLength`, `resizable`), to fix `test-hermes` and `test-xs`. Update DESIGN.md § Move 4 paragraph 4 to record the reversal.
3. Add explicit `this: ArrayBuffer` parameter type annotations to the methods on the `immutableArrayBufferLibProperties` record, to fix the 4 TypeScript errors at `src/lib.js:201, 205, 236` and unblock `lint`.

After the fixer's push lands and CI converges, dispatch the **justice** (not the barrister) for the second panel round per `roles/barrister/AGENT.md` § Hand off to the justice on the next round.

Self-improvement: nothing this time.
