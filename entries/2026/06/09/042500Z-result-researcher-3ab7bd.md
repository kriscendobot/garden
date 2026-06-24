---
ts: 2026-06-09T04:25:00Z
kind: result
role: researcher
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
dispatch_root: /home/kris/dispatches/researcher--3ab7bd
short_id: 3ab7bd
to: steward
refs:
  - entries/2026/06/09/041700Z-dispatch-researcher-3ab7bd.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: predecessor
---

# result: researcher refinement for the SES pony-layer redesign (erights premise-2 / drop-the-pony) designer brief (3ab7bd)

The downstream designer dispatch will author a `DESIGN.md` inside
`packages/immutable-arraybuffer/` (master-based, NOT under `designs/`)
that captures the redesign erights proposed in comment `4655451705` on
PR #430. The redesign has five moves: (1) rename every "pony" filename
and identifier to "lib"; (2) extend the amplifier-with-this-fallthrough
pattern from freezable TypedArrays to immutable ArrayBuffers so the
pseudo-prototype methods become drop-in replacements for the genuine
prototype methods; (3) downgrade the exported "pseudo-prototypes" from
prototypes-of-emulated-instances to records-of-properties that the
shim copies onto the actual genuine prototypes (no constructor or
pseudo-constructor should refer to them after the change); (4) have
the shim do the property-copy onto `ArrayBuffer.prototype` and
`%TypedArrayPrototype%`; (5) remove the pseudo-prototype permits
entries from `permits.js`. Note that the pony-layer code only exists
in `packages/immutable-arraybuffer/`, not anywhere under
`packages/ses/`; the only ses-side surface is the `permits.js`
intrinsic entry and a single `lockdown.js` import. The researcher's
refinement enumerates the rename surface, the amplifier pointers, the
pseudo-prototype shapes, the shim-install function the property-copy
logic will land in, the permits entries to remove, the
`@endo/bytes` migration state, the PR #430 commits whose pattern the
designer translates, and the absence of any existing DESIGN.md in
`packages/immutable-arraybuffer/`.

````markdown
## Library and project references

### Library concepts and sections

- [`journal/library/sections/endo--packages-immutable-arraybuffer--ponyfill-plus-shim-with-purposeful-violation-and-six-caveats-and-weakmap-emulated-private-field-and-intermediate-prototype-inheriting-from-arraybuffer-prototype.md`](../../../library/sections/endo--packages-immutable-arraybuffer--ponyfill-plus-shim-with-purposeful-violation-and-six-caveats-and-weakmap-emulated-private-field-and-intermediate-prototype-inheriting-from-arraybuffer-prototype.md): canonical library section on the package; covers the WeakMap-as-emulated-private-field-and-brand-check, the intermediate-prototype-inheriting-from-ArrayBuffer.prototype shape (the very shape the redesign drops), the six named caveats, the three-platform-degradation (Hermes / Node ≤16 / some JavaScriptCore), the purposeful-violation rationale on `Symbol.toStringTag`, and the modern-shim-practice-frowns-on-conditional-installation policy. The redesign's "drop the pseudo-prototype" move is the inverse of this section's "intermediate-prototype" pattern; the section's enumerations are the input the designer rebuts or preserves.
- [`journal/library/sections/endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation.md`](../../../library/sections/endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation.md): section on the shim file specifically; documents the pony-vs-shim split, the conditional-method-via-conditional-spread idiom (for `transferToImmutable` when `optTransfer`/`structuredClone` are absent), the warning-not-error overwrite policy, the better-fidelity-emulation-of-class-prototype via non-enumerable properties via a `defineProperty` loop, the TS-flow-inference-workaround via local rebinding, and the `opt`-prefix-on-optional-pony-functions convention. The redesign keeps the conditional-spread idiom and the non-enumerable-loop pattern; it changes the install body to copy properties onto genuine prototypes instead of installing on the pseudo-prototype.
- [`journal/library/sources/endo--packages-immutable-arraybuffer.md`](../../../library/sources/endo--packages-immutable-arraybuffer.md): provenance index for both the above sections; consult for the README-level Purposeful-Violation framing and the seven caveats (README says six but the section counts seven distinct named limitations).
- [`journal/library/concepts/throwaway-instance-prototype-walk.md`](../../../library/concepts/throwaway-instance-prototype-walk.md): how SES discovers `%ImmutableArrayBufferPrototype%` at lockdown time via `new ArrayBuffer(0).sliceToImmutable()` then `getPrototypeOf`; relevant because the redesign that "removes the pseudo-prototype" must also delete the `%ImmutableArrayBufferPrototype%` hidden-intrinsic-sampling step at `packages/ses/src/get-anonymous-intrinsics.js:170-177`, or the sampling step now finds `ArrayBuffer.prototype` itself (which is fine, but the post-conditional-add needs to drop).
- `journal/library/keywords.md` entries 6468-6493 (the `@endo/immutable-arraybuffer` cluster, extended in this engagement; see *Library writeback* below): shortcuts for the redesign-relevant terms (`amplifier-with-this-fallthrough`, `amplifyTypedArray`, `virtualTypedArrayBufferGetter`, `hiddenTypedArrays`, `makePseudoTypedArrayConstructor`, `makeInternalHeir`, `FERAL_GET_ARRAY_BUFFER`, `%FreezableTypedArrayPrototype%` / `%ImmutableArrayBufferPrototype%` permits entries, `race-to-install detect-then-skip`, `drop-the-pony redesign`, `erights six-premises framing on #417`, `pseudo-prototype-as-property-record`).
- Adjacent: [`journal/library/sections/endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding.md`](../../../library/sections/endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding.md) and [`journal/library/sections/endo--packages-hex--ponyfill-with-load-time-dispatch-and-pre-lockdown-capture-and-native-error-rerun-polyfill-for-better-diagnostic.md`](../../../library/sections/endo--packages-hex--ponyfill-with-load-time-dispatch-and-pre-lockdown-capture-and-native-error-rerun-polyfill-for-better-diagnostic.md): sibling pony/shim patterns whose three-tier dispatch chain and pre-lockdown capture discipline carry over to the renamed lib layer.
- `docs/spackle.md` (in the project worktree, not the library): Kris Kowal's 2026-05-21 doc on the spackle pattern (polyfill + ponyfill + race-discipline). The "no-spackle" framing in PR #430's branch name (`experiment/no-spackle-immutable-arraybuffer-417`) means the redesign deliberately uses the simpler detect-then-skip race-to-install rather than the registered-symbol pin-on-first-install spackle pattern.

### Project context

- [`journal/projects/endo-but-for-bots/README.md`](../../../projects/endo-but-for-bots/README.md): rules of engagement for this repo. § Standing authorizations applies: the maintainer has authorized the garden's roles to comment/review on `endojs/endo-but-for-bots` PRs without per-action gating (the designer's draft PR is in scope). § Authority structure names erights as a maintainer-equivalent author on this repo by virtue of the repo's permission gate; his comment `4655451705` is therefore a directive, not a suggestion (the dispatch already treats it as such).
- [`journal/projects/endo-but-for-bots/README.md`](../../../projects/endo-but-for-bots/README.md) § "Bot-fork roadmap branch: `llm` (designs); implementation base: `master` (implementations)": the standing rule that design documents land on `llm` under `designs/`. The maintainer's dispatch authorization in this case explicitly overrides that rule for this design ("Instead of using the designs workspace, because this is based on master, integrate the design into a `DESIGN.md` in the affected packages"); the designer authors `packages/immutable-arraybuffer/DESIGN.md` against `master`, not `designs/<slug>.md` against `llm`.
- [`journal/projects/endo/README.md`](../../../projects/endo/README.md) § Authority structure: the cross-project framing that places erights as topic-authoritative on `ses`, `hardened-JS`, `marshal`, `pass-style`, `eventual-send`, `captp`, `patterns`, OCapN, and capability-security generally. The immutable-ArrayBuffer + freezable-TypedArray pony layer is in scope of `hardened-JS` (and adjacent to `pass-style` via the byteArray pass-style this enables), so erights's design framing here is technically authoritative.
- `endojs/endo-but-for-bots#430`'s open thread (the dispatch's pointer-set): the working pattern lives on branch `experiment/no-spackle-immutable-arraybuffer-417`. The two foundational commits the designer must translate to master:
  - `e02ec0d08` ("feat(immutable-arraybuffer): shim installs freezable TypedArray pseudo-constructors with race-to-install"): the experiment branch's shim install body that the designer adapts. The redesign's twist: instead of installing `PseudoTypedArrayPrototype` as the prototype of emulated instances, the new lib's pseudo-prototype becomes a record-of-properties that the shim's install body copies onto `%TypedArrayPrototype%` directly.
  - `2aec9ce92` ("refactor(bytes): use shim'd sliceToImmutable for premise 2 (#430)") and `a5e31162` ("refactor(immutable-arraybuffer): restrict exports to shim only per premise 2 (#430)"): the premise-2 migration, ahead of the master state. On master today, `packages/bytes/src/to-immutable.js` still imports `sliceBufferToImmutable` from `@endo/immutable-arraybuffer`, and `package.json` still exports the `.` entry; the designer's DESIGN.md should note whether premise-2 is a prerequisite (the redesign assumes the package exports only the shim), and the implementing builder will need to fold the bytes migration into the same series unless premise-2 lands first as a separate PR.
- `endojs/endo-but-for-bots#417`: the upstream sibling PR (the design-side cousin of #430); the source of the six-premises framing. Not yet read in this dispatch; the designer should consult #417's description for the full premise set.

### Project worktree pointers (master, `4a04d078b`)

Pony-layer code surface (the rename target — every "pony" filename and identifier moves to "lib"):

- `packages/immutable-arraybuffer/src/immutable-arraybuffer-pony.js` (253 lines): the only pony source file on master. Renames to `packages/immutable-arraybuffer/src/immutable-arraybuffer-lib.js`. Exports: `isBufferImmutable`, `sliceBufferToImmutable`, `optTransferBufferToImmutable`. Key identifiers (all stay; only file-paths and prose comments change): `ImmutableArrayBufferInternalPrototype` (the pseudo-prototype, redesign downgrades it to a property record), `makeImmutableArrayBufferInternal` (the must-not-escape factory), `buffers` (the WeakMap), `getBuffer` (the brand-check accessor).
- `packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js` (97 lines): the shim's install body. Imports from the pony file (rename the import path to `./immutable-arraybuffer-lib.js`). The shim's install body today calls `defineProperties(arrayBufferPrototype, getOwnPropertyDescriptors(arrayBufferMethods))` to add the three methods/getter; the redesign extends this so the shim *also* copies the (former) pseudo-prototype's own properties onto `ArrayBuffer.prototype`. Lines 94-97 are the install call; this is where the property-copy onto genuine prototypes lands.
- `packages/immutable-arraybuffer/index.js` (1 line): `export * from './src/immutable-arraybuffer-pony.js';` — renames to `./src/immutable-arraybuffer-lib.js`. NOTE: the experiment branch's premise-2 commit (`a5e31162`) restricts `package.json` `exports` to only `./shim.js` and drops the `.` entry; if the designer treats premise-2 as a prerequisite for this redesign, this file becomes unreachable from outside the package even though the file still exists as the in-package lib definition the shim transitively imports.
- `packages/immutable-arraybuffer/shim.js` (1 line): `import './src/immutable-arraybuffer-shim.js';` — no rename needed (the file is already "shim", not "pony").
- `packages/immutable-arraybuffer/test/immutable-arraybuffer-pony-slice.test.js` and `immutable-arraybuffer-pony-transfer.test.js`: rename to `immutable-arraybuffer-lib-slice.test.js` and `immutable-arraybuffer-lib-transfer.test.js`; each imports from `../src/immutable-arraybuffer-pony.js` (rename to `-lib.js`); the test bodies use "ponyfill" in test titles (`'Immutable ArrayBuffer ponyfill installed and not hardened'`, etc.); the redesign renames "ponyfill" -> "lib" in test prose as well, per the directive to rename "all occurrences".
- `packages/immutable-arraybuffer/README.md` (10305 bytes): heavy ponyfill prose throughout (lines 3, 4, 41 "The Ponyfill" section, 43, 54, 55, 56, 61, 62, 63, 64, 67, 71 "Purposeful Violation"). The redesign rewrites every instance to "lib" / "the lib layer"; the README's "ponyfill" subsection heading becomes "The Lib Layer".
- `packages/immutable-arraybuffer/CHANGELOG.md:18` carries one historical reference (`sliceToImmutable Hermes ponyfill and shim`); historical changelog text typically does not get retroactively rewritten, but the designer should consider whether to leave it as a historical artifact or rewrite per the directive's "all occurrences".

Files outside `packages/immutable-arraybuffer/` that mention "pony": none on master. `git grep -lI -i 'pony'` outside the package returns only `docs/spackle.md` and `packages/bytes/src/to-immutable.js` (the latter uses "ponyfill" in JSDoc prose to describe the import; the designer should rewrite to "lib" or rewrite the to-immutable usage entirely under premise-2). All matches are in `packages/immutable-arraybuffer/` and these two files.

Amplifier pattern + pseudo-prototype shapes (the redesign extends to ArrayBuffer; today's master has only the ArrayBuffer side, with the freezable-TypedArray amplifier pattern living only on the `experiment/no-spackle-immutable-arraybuffer-417` branch):

- Master today (`packages/immutable-arraybuffer/src/immutable-arraybuffer-pony.js`):
  - The amplifier on master is `getBuffer` (line 97-105): brand-check + amplify. It throws on non-emulated input. The redesign's "amplifier returns this on fallthrough" pattern (which erights praises) is the modification: replace `throw TypeError('Not an emulated Immutable ArrayBuffer')` with `return this` (or rather, `return immuAB`), so the methods become drop-in replacements that delegate to `apply(arrayBufferByteLength, immuAB, [])` when `immuAB` is a genuine ArrayBuffer.
  - The pseudo-prototype is `ImmutableArrayBufferInternalPrototype` (line 108-156): includes `byteLength`, `detached`, `maxByteLength`, `resizable`, `immutable`, `slice`, `sliceToImmutable`, `resize`, `transfer`, `transferToFixedLength`, `transferToImmutable`, `[toStringTag]`. After the redesign: this becomes a record-of-properties (no longer `__proto__: arrayBufferPrototype`; no longer the prototype of emulated instances) that the shim copies onto `ArrayBuffer.prototype` directly. The four "complaining mutator" methods (`resize`, `transfer`, `transferToFixedLength`, `transferToImmutable`) need the amplifier-fallthrough treatment so they only throw on emulated immutables and delegate to the genuine method on genuine ArrayBuffers; the read accessors (`byteLength`, `maxByteLength`, etc.) also need the fallthrough.
- Experiment branch only (`packages/immutable-arraybuffer/src/freezable-typedarray-pony.js`): the analog for TypedArrays. Key symbols the redesign's terminology refers to:
  - `hiddenTypedArrays` (WeakMap; emulated->genuine).
  - `amplifyTypedArray` (the brand-check + amplify; already has the fallthrough-to-`this` pattern erights praises).
  - `virtualTypedArrayBufferGetter` (the buffer accessor's replacement; switches genuine-vs-emulated and unwraps through `reverseHiddenBuffers`).
  - `makePseudoTypedArrayConstructor` (the factory for the pseudo-constructor).
  - The `freezableTypedArrayInternalPrototype` built via `makeInternalHeir` from `./internal-heir.js` (the experiment branch's helper that builds intermediate-prototypes with redirect + complain semantics).
  Master does NOT have `freezable-typedarray-pony.js`, `internal-heir.js`, `immutable-arraybuffer-pony-internal.js`, or any analog of `amplifyTypedArray` / `virtualTypedArrayBufferGetter` / `hiddenTypedArrays`. These are PR #430's contribution; the designer's redesign translates them to master, renamed and restructured per the drop-the-pony framing.

Shim install procedure (where the property-copy-onto-genuine-prototypes lands):

- `packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js`:94-97 (master): the `defineProperties(arrayBufferPrototype, getOwnPropertyDescriptors(arrayBufferMethods))` call. This is the only install site today. The redesign extends this site so it also copies the (former) pseudo-prototype's own properties onto `ArrayBuffer.prototype`; the function name does not change. On the experiment branch, the install body is wrapped in a `if (!('sliceToImmutable' in arrayBufferPrototype))` race-to-install guard (lines 53+ of the experiment shim); the master shim has only the warn-on-overwrite policy (lines 84-92). The designer's DESIGN.md should clarify whether the redesign keeps master's warn-and-overwrite or switches to the experiment branch's detect-then-skip (the latter is the no-spackle simplification erights also references).
- `packages/ses/src/lockdown.js:18`: the single ses-side import that triggers the shim install (`import '@endo/immutable-arraybuffer/shim.js';`). No rename needed; the import path is unchanged.
- `packages/ses/src/get-anonymous-intrinsics.js:170-177`: the conditional-add of `%ImmutableArrayBufferPrototype%` to the intrinsics map via `new ArrayBuffer(0).sliceToImmutable()` then `getPrototypeOf`. With the redesign, the immutable-internal prototype is no longer a separate object (the shim's properties now live on `ArrayBuffer.prototype` itself); `iabProto !== ArrayBuffer.prototype` will be false, the conditional body never runs, the intrinsic is never added. The designer should call out: this code becomes dead and may be removed in a follow-up; the corresponding `%ImmutableArrayBufferPrototype%` permits entry (see below) also goes away.

permits.js entries to remove (the redesign drops them):

- `packages/ses/src/permits.js:1393-1412`: the `'%ImmutableArrayBufferPrototype%'` permits entry (a `[[Proto]]: '%ArrayBufferPrototype%'` block with `byteLength`, `slice`, `@@toStringTag`, `transfer`, `resize`, `resizable`, `maxByteLength`, `transferToFixedLength`, `detached`, `transferToImmutable`, `sliceToImmutable`, `immutable`). Delete this block; the redesign collapses the immutable-internal prototype into `ArrayBuffer.prototype` itself, so no separate intrinsic exists.
- `packages/ses/src/permits.js:1383-1387` (inside `%ArrayBufferPrototype%`): the three lines `transferToImmutable: fn,` `sliceToImmutable: fn,` `immutable: getter,` (with the comment block above them). These STAY: they are the permits entries for the actual methods/getter the shim installs on `ArrayBuffer.prototype` (which the redesign keeps; the redesign only drops the *pseudo-prototype* intrinsic, not the prototype methods themselves).
- No `%FreezableTypedArrayPrototype%` entry exists on master; the experiment branch's `cfe99f7e6` ("fixup: partial progress") added a 48-line `'%FreezableTypedArrayPrototype%'` permits entry (lines 1196-1242 of the experiment branch's `permits.js`), but the redesign explicitly drops the pseudo-prototype layer, so this entry should never land on master in the form the experiment branch has it. The redesign's "TypedArray side" instead adds the pseudo-constructor methods directly onto `%TypedArrayPrototype%` (which permits already covers), and a small set of methods (the inheritance redirect targets: `slice`, `subarray`, `with`, `toReversed`, `toSorted`, the read accessors) gain shim-installed implementations on the existing `%TypedArrayPrototype%` slots rather than on a separate intrinsic.
- The brief mentions `enforce-pony-permits.js`; no such file exists. The actual permits-enforcing file is `packages/ses/src/permits-intrinsics.js` (283 lines), which removes intrinsics not named in permits. Since the redesign drops the `%ImmutableArrayBufferPrototype%` intrinsic and never adds `%FreezableTypedArrayPrototype%`, `permits-intrinsics.js` does not gain new logic; it simply has nothing extra to enforce.

@endo/bytes integration touchpoints (premise-2's other half):

- `packages/bytes/src/to-immutable.js` (master): imports `sliceBufferToImmutable` from `@endo/immutable-arraybuffer` (the lib export). This is the sole external consumer of the pony surface in the bytes package (`git grep -lI 'sliceBufferToImmutable\|isBufferImmutable\|transferBufferToImmutable'` outside the immutable-arraybuffer package returns only `packages/bytes/src/to-immutable.js`). Under premise-2 (which the redesign assumes is satisfied), this file migrates to using `ArrayBuffer.prototype.sliceToImmutable` directly and imports the shim itself for ordering safety. The experiment-branch commit `2aec9ce92` is the canonical implementation of this migration; the designer should reference it as the model and the implementing builder will fold it in (either as a prerequisite PR or as part of this PR's series).
- `packages/bytes/package.json`: declares `"@endo/immutable-arraybuffer": "workspace:^"` as a dependency; under premise-2 this stays (the bytes package imports the shim itself). If the designer's DESIGN.md scopes premise-2 out of this PR, the bytes side does not change; if scopes premise-2 in, the bytes side migrates per `2aec9ce92`.
- `packages/immutable-arraybuffer/package.json`:25-32 (master): the `exports` block carries `.` -> `./index.js`, `./shim.js` -> the shim entry, and `./package.json`. Under premise-2 (per experiment-branch `a5e31162`), drop the `.` entry; only `./shim.js` and `./package.json` remain. The `main` and `module` fields still name `./index.js` (the in-package lib definition); only the Node-ESM-resolution-visible `exports` entry shrinks.
- `packages/marshal/src/rankOrder.js:297` ("Account for gaps in the @endo/immutable-arraybuffer shim"): a comment-only reference; no migration impact, but the designer should be aware that marshal already depends on the shim's behavior for byteArray pass-style rank ordering.

PR #430's parent context (the working pattern the designer translates):

- Branch: `experiment/no-spackle-immutable-arraybuffer-417`, ahead of `master-4a04d07` by 13 commits.
- The translatable commits (in chronological order, excluding the typo-cleanup commits):
  - `721c68a3` ("feat(immutable-arraybuffer): freezable virtual typedarrays"): the initial freezable-TypedArray pony scaffolding (introduces `freezable-typedarray-pony.js`, `internal-heir.js`, `immutable-arraybuffer-pony-internal.js`).
  - `2097641c` ("fixup: everything after the simple move").
  - `cfe99f7e` ("fixup: partial progress"): the 192-line addition that also adds the 48-line `%FreezableTypedArrayPrototype%` permits entry (the redesign explicitly drops this addition).
  - `e02ec0d0` ("feat(immutable-arraybuffer): shim installs freezable TypedArray pseudo-constructors with race-to-install"): the shim install body the designer's redesign rebuilds. Contains the `if (!('sliceToImmutable' in arrayBufferPrototype))` race-to-install guard, the per-concrete-TypedArray-constructor `defineProperty(globalThis, name, {...})` loop, and the `defineProperty(typedArrayPrototype, 'buffer', {get: virtualTypedArrayBufferGetter})` replacement.
  - `1ef6c174` ("test(immutable-arraybuffer): shim-level tests mirroring freezable-typedarray-pony tests"): the test pattern the designer's redesign's tests will mirror (each pony unit test gets a matching shim integration test).
  - `2aec9ce9` ("refactor(bytes): use shim'd sliceToImmutable for premise 2 (#430)") and `a5e31162` ("refactor(immutable-arraybuffer): restrict exports to shim only per premise 2 (#430)"): the premise-2 pair.
- The four `chore` and `test` and `docs` commits after `1ef6c174` (`8a47022530`, `d3a550f37`, `74db04d04`, `740259d2`) are review-response fixups (the rename of `freezableTA` to `typedArray`, the dropped "rendezvous participant" comment, the rewritten buffer-getter rationale, the strengthened indexed-assignment swallow test); they refine the e02ec0d0 design but are not new architectural moves.

Existing `DESIGN.md` state in `packages/ses/`, `packages/immutable-arraybuffer/`, and adjacent packages:

- `packages/ses/`: no `DESIGN.md` (only `CHANGELOG.md`, `README.md`, `SECURITY.md`, `package.json.md`, and a `docs/` directory with `guide.md`, `secure-coding-guide.md`, `preparing-for-stabilize.md`, `draft-standalone-spec.md`, `ses-0.7.md`). The dispatch prompt names "packages/ses" but the actual pony code lives in `packages/immutable-arraybuffer/`; the designer should author the new DESIGN.md in the latter, not the former.
- `packages/immutable-arraybuffer/`: no `DESIGN.md` (only `CHANGELOG.md`, `README.md`, `SECURITY.md`, `LICENSE`, `package.json`, `shim.js`, `index.js`, `shim.types.d.ts`, `tsconfig.*.json`, and `src/`, `test/`). The designer creates a new `packages/immutable-arraybuffer/DESIGN.md` per the maintainer's directive.
- `packages/bytes/`: no `DESIGN.md`.
- The whole tree has exactly one `DESIGN.md` (verified via `find packages -name 'DESIGN.md'`): `packages/module-source/DESIGN.md` (a sibling-shape precedent for what a package-rooted DESIGN.md looks like).

### Blockers, asymmetries, and open questions the designer should surface

- **The dispatch says `packages/ses/` but the pony code is in `packages/immutable-arraybuffer/`.** The designer should author `packages/immutable-arraybuffer/DESIGN.md`; the only ses-side change is dropping the `%ImmutableArrayBufferPrototype%` permits entry and the corresponding hidden-intrinsic-sampling step in `get-anonymous-intrinsics.js`. Confirm whether the DESIGN.md placement matches the maintainer's intent or whether a separate `packages/ses/DESIGN.md` excerpt is also wanted to document the permits/intrinsics removal.
- **Premise-2 dependency.** The redesign assumes the immutable-arraybuffer package exports only the shim and the bytes package consumes via the shim'd method. On master today, premise-2 is *not* satisfied (`packages/immutable-arraybuffer/package.json` still exports `.`, and `packages/bytes/src/to-immutable.js` still imports the pony function). The designer should explicitly call out whether premise-2 lands in this PR (commit pair `2aec9ce9` + `a5e31162` translated to master) or whether premise-2 is treated as a separate prerequisite PR.
- **`%FreezableTypedArrayPrototype%` permits entry.** The experiment branch adds this 48-line entry to support its prototype-of-emulated-instances design; the drop-the-pony redesign removes the pseudo-prototype layer, so this entry should *not* be added on master. The designer should explicitly state that this addition (from experiment commit `cfe99f7e`) is dropped.
- **TypedArray-side amplifier extension on master.** Master has no analog of `amplifyTypedArray`, `virtualTypedArrayBufferGetter`, `hiddenTypedArrays`, `makePseudoTypedArrayConstructor`, `makeInternalHeir`, `FERAL_GET_ARRAY_BUFFER`, `hiddenBuffers`, `reverseHiddenBuffers`, or `immutable-arraybuffer-pony-internal.js`. The redesign introduces all of these as fresh master code, restructured per the drop-the-pony framing (the freezable-typedarray-pony file renames to `freezable-typedarray-lib.js`; the internal-heir helper renames or is inlined; the pseudo-prototype becomes a property record; the install body copies onto `%TypedArrayPrototype%`).
- **`packages/ses/src/get-anonymous-intrinsics.js:170-177` becomes dead code.** With the immutable-internal prototype collapsed into `ArrayBuffer.prototype`, the conditional `if (iabProto !== ArrayBuffer.prototype)` never fires; `%ImmutableArrayBufferPrototype%` is never added to the intrinsics map. Confirm the designer plans to delete this block (paired with the permits.js entry deletion) rather than leaving it inert.
- **Shim install policy: warn-and-overwrite (master today) vs detect-then-skip (experiment).** Master's shim warns-and-overwrites; the experiment branch's shim does detect-then-skip via `if (!('sliceToImmutable' in arrayBufferPrototype))`. The redesign should pick one explicitly; the dispatch does not name which.
- **The directive "rename all occurrences of 'pony'".** Interpretation question: does "all occurrences" include the CHANGELOG.md historical entry (line 18, describing the cycle 201 ship) and the README's "Purposeful Violation" section's discussion of "the ponyfill and shim"? The conservative read is yes, the maintainer means literally all; the alternative is that historical changelog text is exempt. The designer should pick one explicitly.
- **The brief mentions `enforce-pony-permits.js` as a file location.** No such file exists; the actual permits-enforcement happens in `packages/ses/src/permits-intrinsics.js` and the permits declarations live in `packages/ses/src/permits.js`. This is a brief-side terminology issue, not a code-side gap.
````

## Library writeback

Added 18 keyword shortcuts to `library/keywords.md` (immediately after line 6475's `no-spackle ponyfill+shim with race-to-install-detect-only` row, before the `genie-integration` row) for the redesign-relevant terms that were previously unindexed:

- `amplifier-with-this-fallthrough`
- `amplifyTypedArray`
- `virtualTypedArrayBufferGetter`
- `hiddenTypedArrays` WeakMap
- `makePseudoTypedArrayConstructor`
- `PseudoTypedArrayPrototype`
- `makeInternalHeir`
- `FERAL_GET_ARRAY_BUFFER`
- `hiddenBuffers` / `reverseHiddenBuffers`
- freezable TypedArray pony
- `%FreezableTypedArrayPrototype%` permits entry
- `%ImmutableArrayBufferPrototype%` permits entry
- race-to-install detect-then-skip
- drop-the-pony redesign
- erights six-premises framing on #417
- pseudo-prototype-as-property-record
- drop-in replacement for genuine prototype method

All shortcut targets are `(see source: endo--packages-immutable-arraybuffer)` since the existing source page and the two section files (the cycle-201 long-form section and the cycle-245 shim-file section) cover the substantive material. No new concept page was drafted: the redesign is not yet landed on master, and the substantive material on the existing pseudo-prototype/amplifier shapes lives in the two section files already. A future librarian or scholar cycle that documents the *landed* drop-the-pony redesign can draft a new section page with the keyword shortcuts pointing at it.

No section files were pruned.

## Open questions

- Whether `packages/ses/DESIGN.md` should also exist as a small companion to `packages/immutable-arraybuffer/DESIGN.md` to document the permits/intrinsics removal on the ses side, or whether a single DESIGN.md in `packages/immutable-arraybuffer/` (cross-referencing the ses changes) is enough.
- The cleanest interpretation of "rename all occurrences" with respect to historical CHANGELOG entries (rewrite vs leave as historical artifact).
- Whether PR #417 (the upstream sibling design PR) has materially diverged from the PR #430 working code in ways the designer must reconcile against; this researcher did not pull #417's description into context.

Self-improvement: nothing this time. The redesign's working code lives only on a feature branch and is not yet structurally settled (the drop-the-pony directive is itself a request for structural change); drafting a library concept page for "drop-the-pony" or a new section page for the redesign would be premature. The keyword writeback covers the immediate term-lookup needs the downstream designer will hit. The brief's reference to a non-existent `enforce-pony-permits.js` is the only gap that surfaced; the result entry's *Blockers* section calls it out so the designer treats the actual `permits-intrinsics.js` + `permits.js` pair correctly.
