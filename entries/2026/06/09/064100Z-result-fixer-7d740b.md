---
ts: 2026-06-09T06:41:00Z
kind: result
role: fixer
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--7d740b
short_id: 7d740b
to: steward
refs:
  - entries/2026/06/09/055200Z-result-barrister-f35f52.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 435
    role: fixed
---

# result: fixer addressed barrister panel verdict on #435 (7d740b)

## Pre-dispatch state check

The brief flagged the dispatch as stale at `53e276c66`. Fetched and checked out `9dc8bd5d50dda09c83ea9cc1e78acc6590a2ef33` (the cleaner's HEAD) before any edits.

## Must-fix-loop items addressed

Each item ships as one or more atomic commits, per `skills/review-feedback-followup-commits/SKILL.md`. SHAs are on the push to `build/immutable-arraybuffer-drop-the-pseudo-prototype`.

### MFL-1: shim `console.warn` unguarded and resizable-proposal accessors trigger overwrites list

Commit `87a00bd0b` (`fix(immutable-arraybuffer): guard shim console.warn and expand expectedOverwrites`).

Two complementary fixes per the barrister's options (a) and (b):

- Extended `expectedOverwrites` to include `byteLength`, `detached`, `maxByteLength`, `resizable`. On modern Node these are expected overwrites; on Hermes / XS / Node <= 18 they are absent, so listing them is harmless.
- Guarded the `console.warn` call with `typeof console !== 'undefined' && typeof console.warn === 'function'` so the shim is loadable on engines without a `console` global.

Resolves `test-hermes` and `test-xs` CI failures.

### MFL-2: `[Symbol.toStringTag]` removal breaks concordance's buffer sniff

Commits `2bf4eb32b` (`fix(immutable-arraybuffer): restore Symbol.toStringTag as own-property on emulated immutables`) and `e65d8dc42` (`fix(pass-style): allow Symbol.toStringTag own-property on emulated immutable buffers`).

Per the barrister's option (a): restored the `[Symbol.toStringTag] = 'ImmutableArrayBuffer'` slot as an own property on each emulated immutable buffer (via `defineProperty` in `makeImmutableArrayBufferInternal`), not on the shared prototype. Genuine ArrayBuffers continue to inherit `'ArrayBuffer'` from the prototype; emulated immutables carry their own `'ImmutableArrayBuffer'` slot. The design's "no intermediate prototype" property is preserved.

This MFL-2 fix immediately broke `packages/pass-style/src/byteArray.js`'s `assertRestValid`, which asserted `ownKeys(candidate).length === 0` on the byteArray brand check. The toStringTag own-property now violated that invariant and broke 67 ocapn tests with `TypeError: ByteArrays must not have own properties: "[ImmutableArrayBuffer]"`. The companion fix in e65d8dc42 replaces the zero-keys assertion with an explicit allow-list containing `Symbol.toStringTag`; defense-in-depth shape preserved.

Resolves all 13 codec failures the barrister surfaced in `test (22.x, ubuntu-latest)`, `test (24.x, ubuntu-latest)`, and `cover`. Verified locally: all 260 ocapn tests pass.

### MFL-3: TS type errors in `src/lib.js`

Commit `0d92fb1c3` (`fix(immutable-arraybuffer): annotate lib property record methods with @this {ArrayBuffer}`).

Per the barrister's option (a): added explicit `@this {ArrayBuffer}` JSDoc annotations on every method and getter of `immutableArrayBufferLibProperties`. `yarn lint:types` (`tsc`) passes; `yarn lint` (eslint + tsc) is clean.

## Summary-fix items addressed

The 7 `summary-fix` items from the barrister's review:

- **changeset/README/index.js misalignment** and **README's "Purposeful Violation (no longer applies)" section**: `ae3b59b6e` rewrote the changeset paragraph (describes the actual pending-premise-2 exports surface and the toStringTag departure observable) and the README's lib-layer paragraph. The *Purposeful Violation* section is restored under the new own-property-only shape rather than the prior intermediate-prototype shape.
- **No-op "four mutator overwrites do not fire" test**: replaced in `f948d7cc8` with a steady-state contract test asserting all eight shim-installed properties.
- **Missing positive-case coverage for read accessors**: added in `f948d7cc8` ("emulated immutable read accessors return immutable-shape values" and "genuine ArrayBuffer.prototype.immutable returns false").
- **`amplifyArrayBuffer` not isolation-tested**: added in `f948d7cc8`, exposed via internal-test export `_amplifyArrayBufferForTests`. Three tests cover the helper's contract.
- **Duplicated setup-rationale prose in `lib-slice.test.js` / `lib-transfer.test.js`**: hoisted in `f948d7cc8` to `test/_lib-setup.md`; test files keep a single-line pointer.
- **`.changeset/drop-the-pseudo-prototype.md` body misstates exports**: covered by the changeset rewrite in `ae3b59b6e`. The toStringTag own-property departure is now described as part of the user-observable changeset prose.
- **README:113 "Purposeful Violation" no-longer-applicable**: same as above; the section was restored under the new shape.

## DESIGN.md design-departure annotations

Commit `0d0442a7b` updates DESIGN.md to record the two departures the fixer-loop landed:

- Move 2 paragraph 7: toStringTag-as-own-property restoration (the prior "drop the violation entirely" was empirically wrong about concordance's Buffer.from handling).
- Move 4 paragraph 4: expectedOverwrites expansion + console-guard (the prior list-them-as-overwrites broke Hermes / XS and made cold-start noise on modern Node).

The *Out of scope* item for "Retiring the concordance purposeful-violation note in the README" is reworded to reflect that the README's *Purposeful Violation* section now applies (in modified form).

## Pre-push-gates compliance

Commit `448fa0298` addresses three findings the pre-push-gates surfaced after the substantive fix-up bundle:

- `src/lib.js:324`: replaced U+00A7 (`§`) in a code comment with the ASCII word "Move".
- `test/_lib-setup.md:13`: split a multi-sentence line per the `sentence-per-line-md` probe.
- `test/shim-amplifier.test.js`: re-flowed a `t.is(...)` call onto one line per `yarn format`.

Final pre-push-gates run: all probes pass.

## Local verification

- `packages/immutable-arraybuffer`: 53/53 tests pass, lint clean, typecheck clean.
- `packages/pass-style`: 24/24 tests pass, lint clean.
- `packages/ocapn`: 260/260 tests pass (the 13 codec failures the panel surfaced are resolved).
- `packages/ses`: 505 tests pass, 2 known failures, 2 skipped (no new failures introduced).
- `packages/bytes`: 32/32 tests pass.

## Push and PR comment

Pushed 8 commits to `build/immutable-arraybuffer-drop-the-pseudo-prototype`:

```
448fa0298 chore(immutable-arraybuffer): satisfy pre-push gates (non-ASCII source, sentence-per-line, prettier)
f948d7cc8 test(immutable-arraybuffer): tighten amplifier coverage and dedupe lib-test setup prose
ae3b59b6e docs(immutable-arraybuffer): align changeset and README with actual exports and toStringTag
e65d8dc42 fix(pass-style): allow Symbol.toStringTag own-property on emulated immutable buffers
0d0442a7b docs(immutable-arraybuffer): record design departures for toStringTag and expectedOverwrites
2bf4eb32b fix(immutable-arraybuffer): restore Symbol.toStringTag as own-property on emulated immutables
0d92fb1c3 fix(immutable-arraybuffer): annotate lib property record methods with @this {ArrayBuffer}
87a00bd0b fix(immutable-arraybuffer): guard shim console.warn and expand expectedOverwrites
```

Top-level PR summary comment posted: https://github.com/endojs/endo-but-for-bots/pull/435#issuecomment-4656838673

Did not re-request review (this is a draft PR; the justice re-run is the orchestrator's next step per the brief).

## Open follow-ups not addressed

The 3 `follow-up`-disposition items the barrister surfaced remain parked in `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--435.md`:

1. `packages/pass-style/src/byteArray.js` load-order silent-always-false risk on `immutableGetter`. (Was the same risk in master; the byteArray change in this fixer dispatch did not address it because the brief did not authorize a follow-up PR.)
2. `packages/immutable-arraybuffer/DESIGN.md` post-merge update for the actual fixer-loop landing decision. Partially addressed by the DESIGN.md update in `0d0442a7b`, but the post-merge sweep can re-confirm the as-shipped DESIGN matches the as-merged code.
3. `packages/ses/src/get-anonymous-intrinsics.js` dead-import sweep.

The 3 `acknowledge` items the barrister surfaced are deliberate no-ops (premise-2 deferral; filename rename; pre-existing hermes/xs warnings).

The 2 `drop` items the barrister surfaced are deliberately not the fixer's lane (Array.prototype.includes idiom; optResize/optTransferToFixedLength platform-parity).

## Self-improvement

The MFL-2 fix unexpectedly tripped `packages/pass-style/src/byteArray.js`'s `ownKeys(candidate).length === 0` invariant, which the barrister panel surfaced as a `follow-up` (load-order) but not as a substance regression on the brand check itself. The fixer noticed the byteArray ownKeys assertion only after running the ocapn test suite locally and seeing 67 failures (not just the 13 the panel predicted). The lesson: when restoring a previously-dropped own-property to a value that downstream brand checks consume, the fixer's verification scope should include the downstream brand-check assertions, not just the originally-flagged failures. The garden's `regression-evidence` skill covers the general shape; the specific instance might warrant a one-line addition under "when restoring a feature that was intentionally dropped, exercise every downstream brand check that consumed the dropped feature".

Below the threshold for a dispatch-time message to the gardener on its own; surfaces here for future pattern recognition.

Self-improvement: nothing this time.
