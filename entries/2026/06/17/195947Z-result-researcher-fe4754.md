---
ts: 2026-06-17T19:59:47Z
kind: result
role: researcher
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
dispatch_root: /home/kris/dispatches/researcher--fe4754
short_id: fe4754
to: liaison
refs:
  - entries/2026/06/09/042500Z-result-researcher-3ab7bd.md
  - entries/2026/06/09/044127Z-result-researcher-a8b661.md
  - entries/2026/06/03/204303Z-result-liaison-417-gamut.md
  - projects/endo-but-for-bots/followups/endo-but-for-bots--417.md
  - projects/endo-but-for-bots/followups/endo-but-for-bots--435.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 435
    role: predecessor
---

# result: researcher scope for the "delayed freezable TypedArray emulation" follow-up PR (fe4754)

erights asked on PR #435 (comment 2026-06-17T10:55Z): "@kriscendobot, please start a new PR to do the delayed freezable TypedArray emulation."
This dispatch is read-only scope for that follow-up PR.
Three pieces of context disambiguate the ask:

1. **PR #435 is the drop-the-pseudo-prototype redesign** authored at design commit `a4ce95b0c` on branch `design/immutable-arraybuffer-drop-the-pseudo-prototype` and built on `build/immutable-arraybuffer-drop-the-pseudo-prototype` (head `b1eceee2b` as of 2026-06-17).
   It collapses the immutable-ArrayBuffer pseudo-prototype onto `ArrayBuffer.prototype` via the amplifier-with-this-fallthrough pattern.
   Its DESIGN.md § Out of scope reads: "The TypedArray-side analog (drop `%FreezableTypedArrayPrototype%` similarly). Separate PR, separate design."
2. **The TypedArray-side work already exists as a working prototype** on the experiment branch `experiment/no-spackle-immutable-arraybuffer-417` (origin remote, commits `721c68a3` `2097641c` `cfe99f7e` `e02ec0d0` `1ef6c174` plus four review-response fixups).
   It introduces `freezable-typedarray-pony.js`, `internal-heir.js`, `immutable-arraybuffer-pony-internal.js`, plus `freezable-typedarray-pony.test.js` (4 tests) and `freezable-typedarray-shim.test.js` (8 tests).
3. **"Delayed" is the deliberate adjective for a follow-up** in this context: it names a PR that *follows* PR #435's merge and *delays* the TypedArray emulation to its own design + builder cycle rather than folding it into #435.
   The DESIGN.md § Out of scope and the cycle-201 source-page caveat ("Perhaps follow-on shims might modify `DataView` and `TypedArray` to emulate that as well, but that is hard and beyond the ambition of this ponyfill + shim") both flag this work as a deliberate later-stage move; erights's "delayed" verb confirms that framing.

## Hypothesis of "delayed" semantics

"Delayed freezable TypedArray emulation" is **a sequencing word, not a runtime semantic**.
Erights is asking the garden to start the follow-up PR that picks up the TypedArray-side analog of PR #435 now that the ArrayBuffer-side drop-the-pseudo-prototype is in flight.
The new PR's runtime semantics are the standard freezable-TypedArray semantics from the experiment branch: a `Uint8Array` (or any concrete TypedArray) constructed from an immutable ArrayBuffer is a freezable wrapper whose mutator methods (`copyWithin`, `fill`, `reverse`, `set`, `sort`) throw and whose indexed-assignment is silently swallowed, while read accessors and pure methods (`slice`, `subarray`, `with`, `toReversed`, `toSorted`, `at`, `byteLength`, etc.) delegate to the genuine TypedArray on the underlying immutable buffer.
The discriminator is `amplifyTypedArray`, the brand-check WeakMap (`hiddenTypedArrays`) that maps emulated wrappers to genuine TypedArrays and falls through to `this` on a non-emulated receiver (so the pseudo-constructor doubles as a drop-in replacement for the global TypedArray constructor).

The two alternative readings of "delayed" that the liaison should rule out before designing:

- **Not "delayed at runtime" (lazy `.freeze()` or `.toImmutable()` style).** The proposal and the experiment branch both define freezable-TypedArray-ness as **constructor-time-determined by the backing buffer's immutability**.
  Construction with an immutable ArrayBuffer first-arg routes through the pseudo-constructor's emulated-wrapper branch; construction with a genuine (mutable) ArrayBuffer routes through `construct(OriginalConstructor, args, new.target)`.
  There is no `taView.freeze()` or `taView.toImmutable()` API in the proposal or the experiment, and adding one would be a TC39-spec scope expansion outside the package's remit.
- **Not "delayed install" (the shim's race-to-install / detect-then-skip).** The shim's race-to-install policy is a separate axis already decided by PR #435 (warn-and-overwrite per `DESIGN.md` § Move 4, not detect-then-skip).
  Erights's "delayed" verb is about the *PR's place in the schedule*, not about the shim's install policy.

If the liaison or maintainer wants confirmation of the constructor-time-determined-by-backing-buffer reading, the dispatch prompt for the designer can name it as the working hypothesis and ask the designer to flag any drift in erights's later review.

## TC39 proposal-status anchors

Two TC39 proposals are in scope and the new PR's README / DESIGN.md citations should distinguish them:

- **proposal-immutable-arraybuffer** (`tc39/proposal-immutable-arraybuffer`): the proposal `@endo/immutable-arraybuffer` ponyfills and shims.
  Status (as of 2026-06): **Stage 2.7** (advanced to Stage 2 December 2024; advanced to Stage 2.7 February 2025; Stage 3 was on the May 2025 plenary radar but did not land; champions describe the testing plan as "the most well-tested part of the standard library that we've seen thus far").
  The proposal's own section on TypedArray says a `DataView` or `TypedArray` using an immutable buffer as its backing store *can be frozen and immutable* — exactly the door the freezable-TypedArray emulation walks through.
  The proposal does **not** itself spec a separate "freezable TypedArray" API; the freezable-TypedArray behaviour is the natural consequence of the immutable backing buffer.
- **proposal-limited-arraybuffer** (`tc39/proposal-limited-arraybuffer`): a separate proposal that adds *read-only TypedArray/DataView views onto a read-write ArrayBuffer* and *range-limited views*.
  Status: no clear advance to Stage 1 or beyond in the public record (the proposal repo's HTML metadata dates to February 2022).
  This proposal is **not** the one the freezable-TypedArray emulation reflects; the new PR's DESIGN.md should cite the immutable-ArrayBuffer proposal only and avoid confusion with the limited-ArrayBuffer proposal.

The "delayed freezable TypedArray emulation" PR is therefore a follow-on shim layer **for the existing Stage-2.7 immutable-ArrayBuffer proposal**, not an implementation of a separate TC39 proposal.

## Recommended scope for the new PR

### Branch and base

- **Branch name suggestion**: `design/immutable-arraybuffer-freezable-typedarray-emulation` (for the design PR) and `build/immutable-arraybuffer-freezable-typedarray-emulation` (for the implementation PR).
  The two-PR pattern (design PR on `llm` per `journal/projects/endo-but-for-bots/README.md` § "Bot-fork roadmap branch", implementation PR on `master` per the same section) is the project default.
  The maintainer's directive on PR #435 explicitly overrode that for #435 ("integrate the design into a `DESIGN.md` in the affected packages") because the work is master-based.
  The same override likely applies here: the design lives in `packages/immutable-arraybuffer/DESIGN.md` (extended) or in a sibling `packages/immutable-arraybuffer/DESIGN-freezable-typedarray.md`.
  The liaison should ask the maintainer to confirm the placement before the designer dispatch fires.
- **Base branch**: `master`.
  Same rationale as PR #435 (the affected package `packages/immutable-arraybuffer/` exists on both `master` and `llm`; the implementation is master-base per `roles/builder/AGENT.md` and the package-availability rule in `journal/projects/endo-but-for-bots/README.md`).
- **Predecessor dependency**: **PR #435 must merge first**.
  PR #435 establishes the amplifier-with-this-fallthrough pattern, the lib-as-property-record shape, and the warn-and-overwrite shim install policy that the new PR translates to the TypedArray side.
  Building the new PR before #435 lands would either fork the pattern (the two PRs reach different shapes for the same problem) or force a rebase that rewrites the new PR's substance.

### Files added / modified

Translating the experiment branch's commits `721c68a3` + `2097641c` + `cfe99f7e` + `e02ec0d0` + `1ef6c174` onto the post-#435 master, with the drop-the-pseudo-prototype shape applied throughout:

| File                                                                            | Action | Origin (experiment branch)                                                                                |
| ------------------------------------------------------------------------------- | ------ | --------------------------------------------------------------------------------------------------------- |
| `packages/immutable-arraybuffer/src/freezable-typedarray-lib.js`                | NEW    | translates `freezable-typedarray-pony.js` (renamed per the lib convention from #435; drop pseudo-prototype) |
| `packages/immutable-arraybuffer/src/internal-heir.js`                           | NEW    | unchanged from experiment, *or* inlined into `freezable-typedarray-lib.js` if the redesign no longer warrants the helper (designer's call) |
| `packages/immutable-arraybuffer/src/immutable-arraybuffer-lib-internal.js`      | NEW    | translates `immutable-arraybuffer-pony-internal.js`; exposes `hiddenBuffers`, `reverseHiddenBuffers`, `FERAL_GET_ARRAY_BUFFER` to the freezable-typedarray lib without re-exporting from the public `lib.js` |
| `packages/immutable-arraybuffer/src/immutable-arraybuffer-lib.js`               | EDIT   | extend to expose the internal hooks (`hiddenBuffers`, `reverseHiddenBuffers`, `FERAL_GET_ARRAY_BUFFER`) via the new internal file; the public export surface (today: `isBufferImmutable`) does not change |
| `packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js`              | EDIT   | extend the shim to also install the freezable-TypedArray property record onto `%TypedArrayPrototype%` (per the drop-the-pseudo-prototype shape from #435) and to replace each concrete global TypedArray constructor with `makePseudoTypedArrayConstructor(OriginalCtor)` |
| `packages/immutable-arraybuffer/test/freezable-typedarray-lib.test.js`          | NEW    | translates `freezable-typedarray-pony.test.js` (4 tests; lib-renamed; assertions adjusted for drop-the-pseudo-prototype) |
| `packages/immutable-arraybuffer/test/freezable-typedarray-shim.test.js`         | NEW    | translates the experiment file as-is (8 tests; shim-level integration) |
| `packages/immutable-arraybuffer/test/freezable-typedarray-per-flavor.test.js`   | NEW    | per-TypedArray-flavor coverage table (see *Test coverage*) |
| `packages/immutable-arraybuffer/README.md`                                      | EDIT   | new section "The Freezable TypedArray Emulation" after "The Shim"; updates the "Caveats" section to remove the "Perhaps follow-on shims might modify `DataView` and `TypedArray`" caveat (the follow-on is now this PR) |
| `packages/immutable-arraybuffer/DESIGN.md`                                      | EDIT or NEW SIBLING | either extend #435's DESIGN.md with a new "Phase 2: TypedArray-side" section, or author a sibling `DESIGN-freezable-typedarray.md`; the maintainer's call |
| `packages/ses/src/permits.js`                                                   | EDIT   | extend the `%TypedArrayPrototype%` permits entry to cover the shim-installed slots; **do not** add a separate `%FreezableTypedArrayPrototype%` intrinsic (the drop-the-pseudo-prototype shape obviates it) |
| `packages/ses/src/get-anonymous-intrinsics.js`                                  | possibly EDIT | only if the freezable-TypedArray work introduces a new sampled intrinsic; with the drop-the-pseudo-prototype shape, no new sample is needed |
| `packages/ses/test/immutable-arraybuffer.test.js`                               | EDIT   | extend to cover the freezable-TypedArray case (a `Uint8Array` constructed from an immutable ArrayBuffer is frozen / immutable after lockdown) |
| `.changeset/<name>.md`                                                          | NEW    | minor (or major) bump on `@endo/immutable-arraybuffer`; patch (or minor) on `ses`; multi-package shape per `.changeset/host-module-exits.md` |
| `packages/immutable-arraybuffer/CHANGELOG.md`                                   | no edit | changesets generate this on merge |

### Test coverage

The experiment branch's 4 pony tests + 8 shim tests are the minimum.
Per-TypedArray-flavor coverage should add a parameterized test for each of the eleven concrete TypedArray constructors (`Int8Array`, `Int16Array`, `Int32Array`, `Uint8Array`, `Uint8ClampedArray`, `Uint16Array`, `Uint32Array`, `Float32Array`, `Float64Array`, `BigInt64Array`, `BigUint64Array`) covering at minimum:

- **Construction from immutable buffer succeeds** and yields a freezable wrapper.
- **Mutator methods throw**: `copyWithin`, `fill`, `reverse`, `set`, `sort` each `throws TypeError` with the "complaining mutator" shape.
- **Indexed assignment is silently swallowed**: `ta[0] = 42; t.is(ta[0], 0)` (the proposal's spec; the experiment branch's `543b4cb34` added coverage for this).
- **Read accessors and pure methods return correctly**: `byteLength`, `byteOffset`, `length`, `slice`, `subarray`, `at`, `with`, `toReversed`, `toSorted`, `toString`, `toLocaleString`, iterator protocols.
- **`Object.isFrozen(ta)` returns `true` after `freeze(ta)`** (the proposal's TypedArray-can-be-frozen guarantee).
- **`ta.buffer` returns the immutable wrapper, not the underlying genuine buffer** (the `virtualTypedArrayBufferGetter` redirect via `reverseHiddenBuffers`).
- **The pseudo-constructor as drop-in replacement**: `new Uint8Array(genuineMutableBuffer)` still works (the fallthrough branch via `construct(OriginalConstructor, args, new.target)`).
- **`getPrototypeOf(emulatedFreezableTA)` returns the right prototype**: with the drop-the-pseudo-prototype shape applied, this is `%TypedArrayPrototype%` (or `Uint8Array.prototype` for the concrete case), **not** a separate `FreezableTypedArrayPrototype`.

The eleven-flavor table is the right structural shape; the experiment branch's tests cover only `Uint8Array` and would let a regression on (for example) `Float32Array` slip through.
The barrister panel on PR #417 (`201004Z-result-barrister-c117d2`) flagged property-based fast-check shapes as appropriate for the live behaviour; the per-flavor table is the lighter-weight ancestor and is the right MVP for this PR.

### Cross-package consumer touchpoints

- **`packages/pass-style/src/byteArray.js`**: already noted in 3ab7bd's refinement as the load-bearing consumer of the immutable-ArrayBuffer brand check.
  The freezable-TypedArray work does not directly touch this file, but the byteArray pass-style logic admits `Uint8Array` instances whose backing buffer is immutable; with the freezable-TypedArray emulation in place, those `Uint8Array` instances are now freezable, and `harden(byteArray)` would freeze them rather than throw.
  Verify that `pass-style`'s test suite still passes; flag any regression to the designer.
- **`packages/marshal/`**: depends on byte-array pass-style behaviour for OCapN bulk-data wire-format.
  No direct edits expected; run `yarn workspace @endo/marshal test` after the implementation lands to catch any downstream surprise.
- **`packages/bytes/`**: the `to-immutable.js` consumer is the immutable-ArrayBuffer side, not the TypedArray side; no edits expected.

### Recommended role chain

Standard PR-creation-flow chain per `skills/pr-creation-flow/SKILL.md`:

1. **researcher** (this dispatch) — scope (read-only).
2. **designer** — author DESIGN.md (or DESIGN-freezable-typedarray.md sibling).
   Designer's dispatch root inlines the *Library and project references* section below.
3. **builder** — implement against master post-#435-merge.
   Builder's dispatch root inlines the same references section (plus any builder-only delta the next researcher pass surfaces).
4. **cleaner** — typo + comment sweep.
5. **barrister** (judge for builder work) → fixer-loop (if asks) → **justice** (re-panel) → **appellate** → un-draft.
   Standard chain end-to-end.

The chain runs only after PR #435 merges; otherwise the builder's diff includes #435's diff and the panel reviews both at once (which conflates two semantic changes).
Stage the dispatch sequence such that designer can author the DESIGN.md before #435 merges (the design is independent of the implementation), but the builder waits.

## Library and project references

The next designer dispatch inlines the fenced markdown block below verbatim into the dispatch prompt (typically before the *Acceptance* / *Report* sections, after the task statement).

````markdown
## Library and project references

### Library concepts and sections

- [`journal/library/sections/endo--packages-immutable-arraybuffer--ponyfill-plus-shim-with-purposeful-violation-and-six-caveats-and-weakmap-emulated-private-field-and-intermediate-prototype-inheriting-from-arraybuffer-prototype.md`](../../../library/sections/endo--packages-immutable-arraybuffer--ponyfill-plus-shim-with-purposeful-violation-and-six-caveats-and-weakmap-emulated-private-field-and-intermediate-prototype-inheriting-from-arraybuffer-prototype.md): the canonical cycle-201 section on the package; covers the WeakMap-as-emulated-private-field-and-brand-check pattern, the intermediate-prototype shape, the six named caveats (one of which is the "perhaps follow-on shims might modify `DataView` and `TypedArray`" caveat this PR retires), and the three-platform-degradation table.
- [`journal/library/sections/endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation.md`](../../../library/sections/endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation.md): the cycle-245 section on the shim file specifically; documents the pony-vs-shim split, the conditional-method-via-conditional-spread idiom, the warning-not-error overwrite policy, the better-fidelity-emulation-of-class-prototype via non-enumerable properties, and the TS-flow-inference-workaround via local rebinding.
- [`journal/library/sources/endo--packages-immutable-arraybuffer.md`](../../../library/sources/endo--packages-immutable-arraybuffer.md): provenance index; the README-level Purposeful-Violation framing the drop-the-pseudo-prototype PR #435 retires.
- [`journal/library/concepts/throwaway-instance-prototype-walk.md`](../../../library/concepts/throwaway-instance-prototype-walk.md): how SES discovers intrinsics at lockdown time via a throwaway-instance prototype walk; relevant because the freezable-TypedArray work should **not** add a new sampled intrinsic (the drop-the-pseudo-prototype shape obviates it).
- `journal/library/keywords.md` entries 6484-6508 (the `@endo/immutable-arraybuffer` cluster): shortcuts for `amplifyTypedArray`, `virtualTypedArrayBufferGetter`, `hiddenTypedArrays`, `makePseudoTypedArrayConstructor`, `makeInternalHeir`, `FERAL_GET_ARRAY_BUFFER`, `hiddenBuffers` / `reverseHiddenBuffers`, `freezable TypedArray pony`, `%FreezableTypedArrayPrototype%` permits entry (proposed but explicitly dropped under the drop-the-pseudo-prototype redesign), `drop-the-pony redesign`, `pseudo-prototype-as-property-record`, `drop-in replacement for genuine prototype method`.
- Adjacent: [`journal/library/sections/endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding.md`](../../../library/sections/endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding.md): sibling pony/shim pattern whose three-tier dispatch and Reflect.apply defensive binding carry over to the freezable-TypedArray lib.

### Project context

- [`journal/projects/endo-but-for-bots/README.md`](../../../projects/endo-but-for-bots/README.md) § Standing authorizations: the maintainer has authorized the garden to comment/review on `endojs/endo-but-for-bots` PRs without per-action gating, which covers opening the new design PR.
- [`journal/projects/endo-but-for-bots/README.md`](../../../projects/endo-but-for-bots/README.md) § Authority structure: erights is treated as maintainer-equivalent on this repo by virtue of the repo's permission gate; his "delayed freezable TypedArray emulation" comment on PR #435 is a directive, not a suggestion.
- [`journal/projects/endo-but-for-bots/README.md`](../../../projects/endo-but-for-bots/README.md) § "Bot-fork roadmap branch": designs land on `llm`, implementations on `master`; the maintainer's directive on PR #435 explicitly overrode for that PR ("integrate the design into a `DESIGN.md` in the affected packages"), and the same override likely applies here.
- [`journal/projects/endo-but-for-bots/followups/endo-but-for-bots--417.md`](../../../projects/endo-but-for-bots/followups/endo-but-for-bots--417.md) item "Post-shim-wiring second-round re-panel": the parked follow-up that names the live-behaviour-of-the-freezable-TypedArray re-panel as needed when the shim wiring lands; the new PR is the place that follow-up resolves.
- [`journal/projects/endo-but-for-bots/followups/endo-but-for-bots--435.md`](../../../projects/endo-but-for-bots/followups/endo-but-for-bots--435.md) item "DESIGN.md § Move 2 paragraph 7 and § Out of scope item": the DESIGN.md edit the new PR (or a #435 follow-up) handles; the freezable-TypedArray work is the natural home for the DESIGN.md addition.

### Project worktree pointers (master, `4a04d078b`; PR #435 builds on top)

- **The experiment branch `experiment/no-spackle-immutable-arraybuffer-417`** (origin remote; head `1ef6c174d`) is the working prototype the new PR translates.
  Foundational commits (chronological order):
  - `721c68a3` ("feat(immutable-arraybuffer): freezable virtual typedarrays") — introduces `freezable-typedarray-pony.js`, `internal-heir.js`, `immutable-arraybuffer-pony-internal.js`.
  - `2097641c` ("fixup: everything after the simple move").
  - `cfe99f7e` ("fixup: partial progress") — adds the 48-line `%FreezableTypedArrayPrototype%` permits entry; **this addition is explicitly dropped** under the drop-the-pseudo-prototype shape PR #435 establishes.
  - `e02ec0d0` ("feat(immutable-arraybuffer): shim installs freezable TypedArray pseudo-constructors with race-to-install") — the shim install body; **the new PR's shim install body is the post-#435 reshape of this**.
  - `1ef6c174` ("test(immutable-arraybuffer): shim-level tests mirroring freezable-typedarray-pony tests") — the 8 shim integration tests.
  - Four review-response fixups (`8a47022530`, `d3a550f37`, `74db04d04`, `740259d2`) on top of `1ef6c174` refine `e02ec0d0` (rename of `freezableTA` to `typedArray`, dropped "rendezvous participant" comment, rewritten buffer-getter rationale, strengthened indexed-assignment swallow test); fold them into the equivalent translation.
- **PR #435 `build/immutable-arraybuffer-drop-the-pseudo-prototype` branch** (origin remote; head `b1eceee2b` as of 2026-06-17): the immediate predecessor whose shape the new PR mirrors on the TypedArray side.
  The new PR depends on this branch's merge; do not start the builder dispatch before merge.
- **`packages/immutable-arraybuffer/DESIGN.md`** (on PR #435's branch; head `b1eceee2b`): § Out of scope says "The TypedArray-side analog (drop `%FreezableTypedArrayPrototype%` similarly). Separate PR, separate design."
  The new design is the response to that pointer.
- **`packages/immutable-arraybuffer/README.md`** (master; 75 lines): the Caveats section's "Perhaps follow-on shims might modify `DataView` and `TypedArray` to emulate that as well, but that is hard and beyond the ambition of this ponyfill + shim" caveat is the readme-side anchor for this PR's scope.
  The new PR rewrites that caveat to point at the freezable-TypedArray section.
- **`packages/ses/src/permits.js`** lines 1383-1387 (the three shim-installed entries on `%ArrayBufferPrototype%`): the parallel for the new PR is the same kind of shim-installed-method entries on `%TypedArrayPrototype%`; the existing `%TypedArrayPrototype%` permits entry needs the new slots added.
- **`packages/ses/src/get-anonymous-intrinsics.js`** lines 170-177 (the `%ImmutableArrayBufferPrototype%` sampling that PR #435 deletes): the new PR should **not** introduce a parallel sampling for `%FreezableTypedArrayPrototype%`; the drop-the-pseudo-prototype shape obviates the intrinsic.

### TC39 proposal anchors

- **`tc39/proposal-immutable-arraybuffer`** (Stage 2.7 as of 2026-06; advanced Stage 2 Dec 2024, Stage 2.7 Feb 2025): the proposal `@endo/immutable-arraybuffer` ponyfills + shims.
  The proposal's own text already says "A `DataView` or `TypedArray` using an immutable buffer as its backing store can be frozen and immutable"; the freezable-TypedArray emulation is the natural shim consequence of that proposal, not a separate proposal.
- **Not `tc39/proposal-limited-arraybuffer`** (no clear public stage advance since 2022): a separate proposal that adds read-only TypedArray/DataView views onto a read-write ArrayBuffer and range-limited views.
  The new PR's DESIGN.md should not conflate the two.

### Blockers and open questions

- **PR #435 merge order.** The new PR's builder cannot start until PR #435 merges; otherwise the diff conflates two semantic changes and the panel reviews both at once.
  The designer can run earlier (the design is independent), but the dispatch sequence stages such that the builder dispatch waits.
- **DESIGN.md placement.** The maintainer's directive on PR #435 was "integrate the design into a `DESIGN.md` in the affected packages."
  Whether the new PR extends `packages/immutable-arraybuffer/DESIGN.md` with a "Phase 2: TypedArray-side" section or authors a sibling `packages/immutable-arraybuffer/DESIGN-freezable-typedarray.md` is the maintainer's call; the liaison should ask before the designer fires.
- **`internal-heir.js` inline vs separate.** The experiment branch's `internal-heir.js` is a 100+ line helper that builds intermediate prototypes with redirect + complain semantics.
  Under the drop-the-pseudo-prototype shape, the intermediate prototype itself goes away; the helper either restructures into a property-record builder (still useful) or inlines into `freezable-typedarray-lib.js` directly.
  The designer's call.
- **Premise-2 dependency.** PR #435 left premise-2 (narrowing the package's `exports` to `./shim.js` only) as a follow-up; whether premise-2 lands before or after this PR affects whether the new lib file is reachable via `import { hiddenTypedArrays } from '@endo/immutable-arraybuffer/...'` from outside the package.
  The new PR should not depend on premise-2 either way; the internal lib hooks (`hiddenBuffers`, `reverseHiddenBuffers`, `FERAL_GET_ARRAY_BUFFER`) live in `immutable-arraybuffer-lib-internal.js` which is never publicly exported regardless of premise-2's state.
- **Hardened-JS interaction at lockdown.** The freezable-TypedArray emulation runs before `lockdown()` (as a shim install), and the `lockdown()` harden phase freezes everything it reaches.
  The new PR should verify that hardening the pseudo-constructors and the property-record entries does not break the freezable-TypedArray behaviour (the experiment branch did not run under SES; the `packages/ses/test/immutable-arraybuffer.test.js` extension catches any regression).
````

## Library writeback

No new keyword shortcuts added this engagement.
The 3ab7bd researcher dispatch (2026-06-09) added 18 shortcuts at `library/keywords.md:6484-6508` covering the redesign-relevant terms (`amplifier-with-this-fallthrough`, `amplifyTypedArray`, `virtualTypedArrayBufferGetter`, `hiddenTypedArrays`, `makePseudoTypedArrayConstructor`, `makeInternalHeir`, `FERAL_GET_ARRAY_BUFFER`, `hiddenBuffers` / `reverseHiddenBuffers`, `freezable TypedArray pony`, `%FreezableTypedArrayPrototype%` permits entry, `%ImmutableArrayBufferPrototype%` permits entry, `race-to-install detect-then-skip`, `drop-the-pony redesign`, `erights six-premises framing on #417`, `pseudo-prototype-as-property-record`, `drop-in replacement for genuine prototype method`).
Those shortcuts cover this dispatch's lookups too; no additions needed.

No section files pruned, no concept pages drafted.
A new section file documenting the *landed* drop-the-pseudo-prototype redesign and (separately) the freezable-TypedArray emulation is appropriate after both PRs merge to master; flag for the librarian as a post-merge follow-up.

## Open questions

- **Erights's exact reading of "delayed".** The hypothesis above (sequencing word, follow-up PR after #435 merges, constructor-time freezable semantics from the experiment branch) is the most coherent reading; the liaison may want to surface to the maintainer or directly to erights to confirm before the designer's DESIGN.md fires.
- **DESIGN.md placement vs sibling.** The maintainer should confirm whether the new design extends the existing `packages/immutable-arraybuffer/DESIGN.md` or lives in a sibling file; the liaison's dispatch prompt to the designer should name the choice.
- **`Object.prototype.toString.call(freezableTA)` value.** PR #435 retired the `[Symbol.toStringTag]` purposeful violation on the immutable-ArrayBuffer side; the parallel decision on the freezable-TypedArray side (does the lib install a `[Symbol.toStringTag]` of `'FreezableTypedArray'` per the experiment branch's `freezableTypedArrayInternalPrototype`, or inherit the genuine TypedArray's `[toStringTag]`?) is a designer call.
  The experiment branch sets it; the post-#435 idiom is to not set it.

Self-improvement: nothing this time.
The refinement piggybacks on 3ab7bd's prior keyword writeback; the scope is the natural projection of PR #435's *Out of scope* section onto a follow-up PR; the experiment branch carries the prototype the new builder translates; the TC39 proposal status is the standard freezable-TypedArray-as-consequence-of-immutable-buffer framing already in the proposal text.
The liaison's main pre-dispatch ask is the maintainer's call on DESIGN.md placement and the confirmation that "delayed" means "follow-up PR after #435 merges" rather than "lazy at-runtime semantics".
