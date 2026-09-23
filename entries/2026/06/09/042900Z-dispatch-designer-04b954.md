---
ts: 2026-06-09T04:29:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: designer
dispatch_root: /home/kris/dispatches/designer--04b954
prs:
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: predecessor
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4655451705
  - https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4656037929
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/09/042500Z-result-researcher-3ab7bd.md
---

# dispatch: designer — author `packages/immutable-arraybuffer/DESIGN.md` for the drop-the-pony redesign

Maintainer authorization (kriskowal at 2026-06-09T04:15:35Z on
PR #430, issue comment `4656037929`):

> @kriscendobot Please establish a fresh PR that pursues this new
> design. Please dispatch the designer and builder serially,
> without waiting for a review or landing on the design. Instead
> of using the designs workspace, because this is based on master,
> integrate the design into a `DESIGN.md` in the affected packages.
> Run the gamut until done. Please report the PR link here.

erights's design framing (issue comment `4655451705` on PR #430,
the substance the designer is asked to encode):

> Good observations. This suggests a further simplification. With
> the @endo/bytes change I suggest above, the pony layer is
> completely invisible. So we no longer need the pony layer that
> is coherent as a standalone pony. So instead,
> - Rename all occurrences of "pony", including in the filenames,
>   to "lib".
> - The simplification you did for freezable TypedArrays, where the
>   amplifier just returns the normal one if there is no amplified
>   one, is great. It results in the freezable TypedArray
>   pseudo-prototype methods being drop-in replacements for the
>   original TypedArray prototype methods. I would like the
>   immutable ArrayBuffer pseudo-prototype methods to have the same
>   drop-in replacement character. To achieve this, the "other"
>   methods would need to switch on whether the "this" is an
>   emulated vs genuine ArrayBuffer, and delegate to the original
>   methods if so.
> - Still have the lib layer export the pseudo-prototypes. But these
>   are no longer pseudo-prototypes. Rather, they are a record of
>   properties for the shim to copy onto the actual prototypes.
>   Therefore, no constructors or pseudo-constructors should refer
>   to these pseudo prototypes.
> - Have the shim copy these properties onto the actual prototypes.
> - Remove the pseudo-prototype from `permits.js`.

## Library and project references

(inlined verbatim from researcher `3ab7bd`'s result entry; see
`journal/entries/2026/06/09/042500Z-result-researcher-3ab7bd.md`
for the full source.)

### Library concepts and sections

- [`journal/library/sections/endo--packages-immutable-arraybuffer--ponyfill-plus-shim-with-purposeful-violation-and-six-caveats-and-weakmap-emulated-private-field-and-intermediate-prototype-inheriting-from-arraybuffer-prototype.md`](../../../library/sections/endo--packages-immutable-arraybuffer--ponyfill-plus-shim-with-purposeful-violation-and-six-caveats-and-weakmap-emulated-private-field-and-intermediate-prototype-inheriting-from-arraybuffer-prototype.md): canonical library section on the package; covers the WeakMap-as-emulated-private-field-and-brand-check, the intermediate-prototype-inheriting-from-ArrayBuffer.prototype shape (the very shape the redesign drops), the six named caveats, the three-platform-degradation, the purposeful-violation rationale on `Symbol.toStringTag`, and the modern-shim-practice-frowns-on-conditional-installation policy. The redesign's "drop the pseudo-prototype" move is the inverse of this section's "intermediate-prototype" pattern.
- [`journal/library/sections/endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation.md`](../../../library/sections/endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation.md): section on the shim file specifically; documents the pony-vs-shim split, the conditional-method-via-conditional-spread idiom, the warning-not-error overwrite policy, the better-fidelity-emulation via non-enumerable properties, the TS-flow-inference-workaround, and the `opt`-prefix convention.
- [`journal/library/sources/endo--packages-immutable-arraybuffer.md`](../../../library/sources/endo--packages-immutable-arraybuffer.md): provenance index for both the above sections.
- [`journal/library/concepts/throwaway-instance-prototype-walk.md`](../../../library/concepts/throwaway-instance-prototype-walk.md): how SES discovers `%ImmutableArrayBufferPrototype%` at lockdown time; the redesign deletes the `%ImmutableArrayBufferPrototype%` sampling step at `packages/ses/src/get-anonymous-intrinsics.js:170-177` along with the corresponding permits entry.
- `journal/library/keywords.md` entries 6468-6493 (extended in this engagement; the `@endo/immutable-arraybuffer` cluster). Shortcuts for `amplifier-with-this-fallthrough`, `amplifyTypedArray`, `virtualTypedArrayBufferGetter`, `hiddenTypedArrays`, `makePseudoTypedArrayConstructor`, `makeInternalHeir`, `FERAL_GET_ARRAY_BUFFER`, `%FreezableTypedArrayPrototype%` / `%ImmutableArrayBufferPrototype%` permits entries, `race-to-install detect-then-skip`, `drop-the-pony redesign`, `erights six-premises framing on #417`, `pseudo-prototype-as-property-record`.
- `docs/spackle.md` (in the project worktree): Kris Kowal's 2026-05-21 doc on the spackle pattern. The "no-spackle" framing in PR #430's branch name (`experiment/no-spackle-immutable-arraybuffer-417`) means the redesign uses the simpler detect-then-skip race-to-install rather than the registered-symbol pin-on-first-install pattern.

### Project context

- [`journal/projects/endo-but-for-bots/README.md`](../../../projects/endo-but-for-bots/README.md): rules of engagement. § Standing authorizations applies (the designer's draft PR is in scope). § Authority structure names erights as a maintainer-equivalent author by virtue of the repo's permission gate; his comment `4655451705` is a directive.
- The maintainer's dispatch authorization explicitly overrides the "design documents land on `llm` under `designs/`" rule for this engagement: "Instead of using the designs workspace, because this is based on master, integrate the design into a `DESIGN.md` in the affected packages."
- [`journal/projects/endo/README.md`](../../../projects/endo/README.md) § Authority structure: erights is topic-authoritative on `ses`, `hardened-JS`, `marshal`, `pass-style`, `eventual-send`, `captp`, `patterns`, OCapN, and capability-security generally. The immutable-ArrayBuffer + freezable-TypedArray pony layer is in scope of `hardened-JS` (and adjacent to `pass-style` via the byteArray pass-style).
- PR #430's working pattern lives on branch `experiment/no-spackle-immutable-arraybuffer-417`. Two foundational commits to translate:
  - `e02ec0d08` ("feat(immutable-arraybuffer): shim installs freezable TypedArray pseudo-constructors with race-to-install"): the experiment branch's shim install body. Redesign twist: instead of installing `PseudoTypedArrayPrototype` as the prototype of emulated instances, the new lib's pseudo-prototype becomes a record-of-properties that the shim copies onto `%TypedArrayPrototype%` directly.
  - `2aec9ce92` ("refactor(bytes): use shim'd sliceToImmutable for premise 2 (#430)") and `a5e31162` ("refactor(immutable-arraybuffer): restrict exports to shim only per premise 2 (#430)"): the premise-2 migration, ahead of master.
- PR #417: upstream sibling design PR; source of six-premises framing. Designer should consult #417's description.

### Project worktree pointers (master, `4a04d078b`)

**Pony-layer code surface (rename target — every "pony" → "lib"):**

- `packages/immutable-arraybuffer/src/immutable-arraybuffer-pony.js` (253 lines): only pony source on master. Renames to `-lib.js`. Exports: `isBufferImmutable`, `sliceBufferToImmutable`, `optTransferBufferToImmutable`. Key identifiers (stay): `ImmutableArrayBufferInternalPrototype` (pseudo-prototype; redesign downgrades to property record), `makeImmutableArrayBufferInternal`, `buffers` (WeakMap), `getBuffer` (brand-check accessor).
- `packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js` (97 lines): shim install body. Imports rename to `./immutable-arraybuffer-lib.js`. Lines 94-97 install via `defineProperties`; redesign extends to copy the (former) pseudo-prototype's own properties onto `ArrayBuffer.prototype`.
- `packages/immutable-arraybuffer/index.js` (1 line): rename import path. NOTE: experiment branch's premise-2 commit `a5e31162` restricts `package.json` `exports` to only `./shim.js`.
- `packages/immutable-arraybuffer/shim.js`: no rename (already "shim").
- `packages/immutable-arraybuffer/test/immutable-arraybuffer-pony-{slice,transfer}.test.js`: rename to `-lib-...`; update import paths and test titles (`'Immutable ArrayBuffer ponyfill installed and not hardened'` → "...lib...").
- `packages/immutable-arraybuffer/README.md` (10305 bytes): heavy ponyfill prose throughout (lines 3, 4, 41 "The Ponyfill" section, 43, 54-56, 61-64, 67, 71 "Purposeful Violation"). Redesign rewrites every instance.
- `packages/immutable-arraybuffer/CHANGELOG.md:18`: historical reference. Designer decides whether to retroactively rewrite.

**Files outside `packages/immutable-arraybuffer/` mentioning "pony":** `docs/spackle.md` and `packages/bytes/src/to-immutable.js` (JSDoc prose; rewrite to "lib" or rewrite the usage entirely under premise-2).

**Amplifier pattern + pseudo-prototype shapes:**

- Master (`immutable-arraybuffer-pony.js`):
  - Amplifier `getBuffer` (line 97-105): brand-check + amplify; throws on non-emulated. Redesign: replace `throw` with `return this` / `return immuAB` so methods become drop-in replacements that delegate to `apply(arrayBufferByteLength, immuAB, [])` for genuine ArrayBuffers.
  - Pseudo-prototype `ImmutableArrayBufferInternalPrototype` (line 108-156): includes `byteLength`, `detached`, `maxByteLength`, `resizable`, `immutable`, `slice`, `sliceToImmutable`, `resize`, `transfer`, `transferToFixedLength`, `transferToImmutable`, `[toStringTag]`. After redesign: property record (no `__proto__`, no longer prototype of emulated instances). Mutators (`resize`, `transfer`, `transferToFixedLength`, `transferToImmutable`) need amplifier-fallthrough: throw on emulated immutables, delegate on genuine ArrayBuffers.
- Experiment branch only (`freezable-typedarray-pony.js`): the TypedArray analog. Symbols `hiddenTypedArrays`, `amplifyTypedArray` (already has fallthrough), `virtualTypedArrayBufferGetter`, `makePseudoTypedArrayConstructor`, `freezableTypedArrayInternalPrototype` via `makeInternalHeir` from `./internal-heir.js`. Master has none of these; designer introduces them on master, restructured per drop-the-pony.

**Shim install procedure:**

- `packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js:94-97` (master): the `defineProperties(arrayBufferPrototype, getOwnPropertyDescriptors(arrayBufferMethods))` call. Redesign extends to also copy the (former) pseudo-prototype's own properties onto `ArrayBuffer.prototype`. Function name unchanged.
- `packages/ses/src/lockdown.js:18`: single ses-side import (`import '@endo/immutable-arraybuffer/shim.js';`). No rename.
- `packages/ses/src/get-anonymous-intrinsics.js:170-177`: conditional-add of `%ImmutableArrayBufferPrototype%`. Becomes dead code after redesign; designer should call out the deletion.

**permits.js entries to remove:**

- `packages/ses/src/permits.js:1393-1412`: `%ImmutableArrayBufferPrototype%` block. Delete.
- `packages/ses/src/permits.js:1383-1387` (inside `%ArrayBufferPrototype%`): the three lines `transferToImmutable: fn,`, `sliceToImmutable: fn,`, `immutable: getter,`. STAY (these are the actual prototype methods/getter the shim installs).
- `%FreezableTypedArrayPrototype%` entry from experiment commit `cfe99f7e`: explicitly NOT landed on master. Redesign drops the pseudo-prototype layer entirely; pseudo-constructor methods land on `%TypedArrayPrototype%` directly.
- No `enforce-pony-permits.js` file (brief-side terminology issue); actual enforcement is `packages/ses/src/permits-intrinsics.js` (283 lines), which needs no new logic.

**@endo/bytes integration (premise-2):**

- `packages/bytes/src/to-immutable.js` (master): imports `sliceBufferToImmutable` from `@endo/immutable-arraybuffer`. Sole external consumer of the pony surface. Under premise-2 (which redesign assumes satisfied), migrates to `ArrayBuffer.prototype.sliceToImmutable` directly + imports shim for ordering safety. Canonical implementation: experiment commit `2aec9ce92`.
- `packages/bytes/package.json`: `"@endo/immutable-arraybuffer": "workspace:^"` stays under premise-2 (bytes imports the shim).
- `packages/immutable-arraybuffer/package.json`:25-32 (master): `exports` block. Under premise-2 (experiment `a5e31162`): drop `.` entry, keep only `./shim.js` and `./package.json`. `main`/`module` still name `./index.js`.
- `packages/marshal/src/rankOrder.js:297`: comment-only reference; no migration impact.

**Existing DESIGN.md state:**

- `packages/ses/`: no DESIGN.md.
- `packages/immutable-arraybuffer/`: no DESIGN.md. Designer creates new `packages/immutable-arraybuffer/DESIGN.md`.
- `packages/bytes/`: no DESIGN.md.
- Whole tree has exactly one DESIGN.md (`packages/module-source/DESIGN.md`) as a shape precedent.

### Blockers, asymmetries, and open questions (the designer surfaces these in DESIGN.md)

- **Dispatch said `packages/ses/` but the pony code is in `packages/immutable-arraybuffer/`.** Author `packages/immutable-arraybuffer/DESIGN.md`; the only ses-side change is dropping the `%ImmutableArrayBufferPrototype%` permits entry + the corresponding hidden-intrinsic-sampling step. Confirm placement matches maintainer intent or whether a small `packages/ses/DESIGN.md` companion is also wanted.
- **Premise-2 dependency.** Master today does NOT satisfy premise-2 (package still exports `.`, bytes still imports the pony function). DESIGN.md should explicitly state whether premise-2 lands in this PR (`2aec9ce9` + `a5e31162` translated) or as a separate prerequisite PR.
- **`%FreezableTypedArrayPrototype%` permits entry**: experiment branch adds it (commit `cfe99f7e`); drop-the-pony redesign drops it. DESIGN.md should state explicitly.
- **TypedArray-side amplifier extension on master**: master has none of the symbols (`amplifyTypedArray`, `virtualTypedArrayBufferGetter`, `hiddenTypedArrays`, etc.). DESIGN.md introduces all as fresh master code restructured per drop-the-pony.
- **`packages/ses/src/get-anonymous-intrinsics.js:170-177` becomes dead code.** Confirm plan to delete (paired with permits.js deletion).
- **Shim install policy**: warn-and-overwrite (master) vs detect-then-skip (experiment). DESIGN.md picks one explicitly.
- **"Rename all occurrences of 'pony'"** interpretation: include CHANGELOG.md historical entry + README "Purposeful Violation" prose, or exempt historical text? DESIGN.md picks one explicitly.

## Task

You are the **designer** for this engagement. Read `garden/roles/designer/AGENT.md` and `garden/skills/process-documents/SKILL.md`. In your `project/` worktree at master (`4a04d078b`):

1. **Read PR #430's branch** (`experiment/no-spackle-immutable-arraybuffer-417`) commits cited above to ground the design in the working code. Use `git fetch origin experiment/no-spackle-immutable-arraybuffer-417` then `git log` / `git show` to read them.
2. **Read PR #417's description** to absorb the six-premises framing.
3. **Read the existing master files** the references section pins (the pony source, the shim, the permits entries, the bytes consumer).
4. **Author `packages/immutable-arraybuffer/DESIGN.md`** capturing the redesign in full:
   - Goal statement (one paragraph): pony layer becomes invisible after @endo/bytes change; drop the standalone-pony framing; rename "pony" → "lib"; pseudo-prototypes become property records; shim copies onto genuine prototypes.
   - Rename surface (file-by-file enumeration; designer's specific call on CHANGELOG.md treatment).
   - Amplifier-with-this-fallthrough pattern for ArrayBuffer (mirroring the TypedArray simplification erights praises): brand-check returns `this` on fallthrough; mutators throw on emulated, delegate on genuine; read accessors delegate.
   - Pseudo-prototype → property-record downgrade: shim's `defineProperties` body extends to copy the (former) pseudo-prototype's own properties onto `ArrayBuffer.prototype`; constructors / pseudo-constructors no longer reference the pseudo-prototype.
   - TypedArray-side mirror (introducing `amplifyTypedArray`, `virtualTypedArrayBufferGetter`, `hiddenTypedArrays`, pseudo-constructor factory, freezable-TypedArray-lib analog) on master, also restructured as property records copied onto `%TypedArrayPrototype%`.
   - Permits cleanup: delete `%ImmutableArrayBufferPrototype%` entry + the corresponding `get-anonymous-intrinsics.js` sampling step; do not introduce `%FreezableTypedArrayPrototype%`.
   - Premise-2 stance (designer's explicit call: in-this-PR vs prerequisite).
   - Shim install policy (designer's explicit call: warn-and-overwrite vs detect-then-skip).
   - CHANGELOG.md rename interpretation (designer's explicit call).
   - Test strategy: each renamed lib unit test gets the matching shim integration test (mirror experiment `1ef6c174`).
   - Migration ordering: shim install body change order vs permits removal order; bytes consumer migration timing.
5. **No other code changes** in this dispatch. The designer's only commit is the new DESIGN.md.
6. **Commit** with conventional commit message: `docs(immutable-arraybuffer): DESIGN.md for drop-the-pony redesign`. New branch off `master` named `design/immutable-arraybuffer-drop-the-pony` (or similar; designer chooses).
7. **Push** to the new branch on the fork (regular push, no force).
8. **Do NOT open a PR** for the design artifact alone. Per maintainer directive: "dispatch designer and builder serially, without waiting for a review or landing on the design". The builder picks up this branch and continues; the PR opens when the builder lands its first commit.

## Authorizations (per-action, forwarded by steward)

- **Push the new branch** to the fork. Implicit in the designer dispatch.
- **Do NOT open a PR**, do NOT post comments, do NOT request review — the builder owns the PR-opening step.

## Out of scope

- Implementation work (the builder dispatches next).
- Touching files outside `packages/immutable-arraybuffer/DESIGN.md`.
- Opening a PR.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` naming:

- The DESIGN.md path and its key sections (goal, rename surface, amplifier pattern, pseudo-prototype downgrade, permits cleanup, premise-2 stance, shim install policy, CHANGELOG interpretation, test strategy, migration ordering).
- The new branch name, base, and pushed commit SHA.
- The designer's explicit calls on the open questions (premise-2 in/out, shim install policy, CHANGELOG rewrite scope, ses-side companion DESIGN.md or not).
- The builder's recommended starting state (which branch, which DESIGN.md sections to implement first).
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The orchestrator dispatches a researcher-then-builder chain next and tears down your dispatch root on return.
