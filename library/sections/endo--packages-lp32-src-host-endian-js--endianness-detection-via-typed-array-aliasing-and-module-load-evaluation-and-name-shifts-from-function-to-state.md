---
title: "@endo/lp32/src/host-endian.js — Endianness detection via typed-array aliasing + module-load evaluation + name shifts from function to state"
source-slug: endo--packages-lp32-src-host-endian-js
source-url: https://github.com/endojs/endo/blob/master/packages/lp32/src/host-endian.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/lp32/src/host-endian.js
total-lines: 9
ingest-cycle: 243
ingest-date: 2026-06-08
lane: chat
---

# Endianness detection via typed-array aliasing + module-load evaluation + name shifts from function to state

[`@endo/lp32/src/host-endian.js`](../sources/endo--packages-lp32-src-host-endian-js.md) is a §nine-line-file that detects whether the host platform is little-endian and exposes the result as a module-level constant. This is the smallest file ingested in the library so far that still earns its keep.

## §Endianness-detection-via-typed-array-aliasing — the canonical trick

```js
const isHostLittleEndian = () => {
  const array8 = new Uint8Array([1, 0]);
  const array16 = new Uint16Array(array8.buffer);
  return array16[0] === 1;
};
```

§The-`Uint8Array`-shares-buffer-with-`Uint16Array`-via-the-`.buffer`-property + §same-memory-different-view. §The-Uint8Array-stores-the-two-bytes [1, 0] + §when-read-as-Uint16: §little-endian-platforms-give-1 (LSB first: 0x0001) + §big-endian-platforms-give-256 (MSB first: 0x0100).

§The-typed-array-aliasing-IS-the-detection-mechanism. §When-the-host-platform's-byte-order-must-be-known-at-runtime, §write-known-bytes-via-one-view-and-read-them-via-another-view + §the-discrepancy-IS-the-evidence. §No-NodeJS-API-call-required + §no-`os.endianness()`-import + §the-detection-is-pure-JavaScript-language-feature-only.

§Sibling-pattern-to-cycle-241's-`new Promise((resolve, reject) => { ... })`-resolve-callback-captured-via-closure — both patterns use a §JavaScript-language-feature-to-extract-a-fact-not-available-via-the-feature's-stated-purpose. §The-canonical-tricks-are-load-bearing.

## §The test buffer is two bytes not four — minimum reliable detection

§The-test-buffer-uses-two-bytes-not-four. §Two-bytes-is-sufficient-because-Uint16-reads-two-bytes; §using-four-bytes-would-be-equally-correct-but-not-more-discriminating. §When-detecting-byte-order, §use-the-smallest-unit-that-distinguishes-the-orderings. §Sibling-to-cycle-237's-the-`despite`-clauses-construct-the-tie-scenario-to-verify-the-tie-breaker-fires — both patterns construct the §minimum-evidence-the-test-needs.

§The-bytes-[1, 0]-are-not-arbitrary: §the-1-is-the-distinguishing-bit + §the-0-is-the-don't-care-padding. §The-test-distinguishes-1-from-256-because-256-is-1-shifted-by-8. §When-the-test-relies-on-a-single-distinguishing-bit, §put-the-bit-in-the-byte-that-the-target-endianness-treats-as-the-LSB.

## §Module-load evaluation memoizes the result

```js
export const hostIsLittleEndian = isHostLittleEndian();
```

§The-function-is-called-at-module-load-not-on-demand + §the-result-is-frozen-into-a-module-level-constant. §The-host's-byte-order-doesn't-change-between-loads-of-the-same-module + §so-the-one-time-evaluation-IS-the-correct-shape. §When-a-fact-about-the-host-platform-is-stable-for-the-lifetime-of-the-module, §evaluate-it-at-module-load-and-export-it-as-a-constant-not-as-a-function.

§Sibling-pattern-to-cycle-239's-GET_INTERFACE_GUARD-named-constant — both designs use §a-module-level-export-as-the-canonical-record-of-a-fact. §The-constant-IS-the-API + §the-API-doesn't-need-a-function-call-to-retrieve-the-fact.

## §The name shifts from function to state

§The-helper-function-is-named-`isHostLittleEndian` (predicate shape) + §the-exported-constant-is-named-`hostIsLittleEndian` (state shape). §The-`is`-prefix-and-the-`Host`-subject-rearrange-when-the-shape-changes: §predicate (verb-first: *is the host little-endian?*) → §state (subject-first: *the host is little-endian*).

§The-name-IS-the-shape. §When-a-function-returns-a-fact-and-the-fact-is-cached-as-a-constant, §rename-from-predicate-to-state-form. §Predicate-form-with-`is`-prefix-asks-the-question + §state-form-with-subject-prefix-IS-the-answer.

§First-explicit-observation in library of §the-name-shifts-from-predicate-to-state-when-the-function-result-is-cached. §Sibling-to-cycle-237's-`stringCompare`-and-`pathCompare`-where-the-function-names-stay-stable-because-the-functions-themselves-are-the-exports; §contrast: cycle 243's function is internal scaffolding + the constant is the export.

## §The function is IIFE-shaped-but-named — design choice

```js
const isHostLittleEndian = () => { ... };
export const hostIsLittleEndian = isHostLittleEndian();
```

§The-canonical-IIFE-shape would be:

```js
export const hostIsLittleEndian = (() => { ... })();
```

§The-author-chose-the-named-form-over-the-IIFE-form. §The-named-form-makes-the-function-debuggable + §the-named-form-makes-the-stack-trace-meaningful-if-the-function-throws + §the-named-form-makes-the-function-testable-in-isolation (though this file doesn't export the function).

§When-an-IIFE-would-suffice-but-the-function's-purpose-is-named-able, §prefer-the-named-form-over-the-anonymous-IIFE + §the-name-IS-the-documentation. §Sibling-to-cycle-241's-`function postpone(...)`-debug-name-via-`function`-keyword-syntax — both designs give names to functions that didn't need them syntactically.

## §Why endianness matters at this layer

§The-lp32-package (length-prefix-32) reads and writes streams framed by 32-bit length prefixes. §When-reading-or-writing-a-32-bit-integer-into-or-out-of-a-byte-stream, §the-byte-order-must-be-known. §The-protocol-might-specify-network-byte-order (big-endian) and §the-host-might-be-little-endian, so §the-package-needs-to-know-whether-to-byte-swap.

§The-constant-IS-the-input-to-the-byte-swap-decision. §When-the-host-byte-order-is-known-at-module-load, §the-byte-swap-decision-can-be-baked-into-the-read/write-functions-not-decided-on-every-call. §Performance-by-construction: §the-typed-array-aliasing-runs-once + §every-subsequent-frame-uses-the-cached-result.

## §The file is the design — no more no less

§Nine-lines + §one-helper + §one-export + §no-tests-in-this-file + §no-imports. §The-file-does-one-thing-exhaustively. §When-a-package-needs-a-platform-fact, §isolate-the-detection-in-its-own-file-not-mixed-into-the-using-module + §the-file-IS-the-named-decision.

§Sibling-to-cycle-239's-`@endo/exo/src/get-interface.js` (28-line file with a constant and a typedef) + §cycle-241's-`postponed.js` (46-line file with the postponed handler). §Three-cycles-with-small-files-that-each-isolate-one-named-decision (cycles 239 + 241 + 243). §The-pattern: §isolate-the-named-decision-in-its-own-file-and-let-the-file-name-state-the-purpose.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §Endianness-detection-via-typed-array-aliasing — `Uint8Array` + `Uint16Array` over the same buffer; the discrepancy IS the evidence.
- §The-test-buffer-is-the-minimum-unit-that-distinguishes-the-orderings.
- §The-bytes-have-a-distinguishing-bit-and-don't-care-padding.
- §Module-load-evaluation-memoizes-the-result — when a host fact is stable, evaluate at module load and export as a constant.
- §The-name-shifts-from-predicate-to-state — `isHostLittleEndian` (function) → `hostIsLittleEndian` (constant).
- §The-named-form-over-the-IIFE-form — the name IS the documentation.

**Tier-2 (file-shape patterns):**

- §Isolate-the-named-decision-in-its-own-file — let the file name state the purpose.
- §The-constant-IS-the-API + §the-API-doesn't-need-a-function-call-to-retrieve-the-fact.
- §Performance-by-construction: §the-detection-runs-once + §every-call-uses-the-cached-result.

**Tier-3 (small-file patterns):**

- §Nine-lines-as-a-complete-platform-detection-artifact + §no-imports + §no-tests-in-the-file.
- §The-file-does-one-thing-exhaustively.

## §Synthesis target — slot machine library

For a slot machine library:

- §game-platform-detection-via-language-feature-aliasing — when the host platform's behavior must be known at runtime, write known values via one view and read them via another view; the discrepancy IS the evidence.
- §game-feature-detection-at-module-load — when a host fact is stable for the lifetime of the module, evaluate it at module load and export it as a constant.
- §the-name-shifts-from-predicate-to-state — predicate-form asks the question, state-form is the answer.
- §isolate-the-named-decision-in-its-own-file for §game-platform-flags-and-feature-detection.
- §the-constant-IS-the-API for §game-platform-feature-flags consumed by other game modules.
- §the-named-form-over-the-IIFE-form for §game-platform-detection-helpers-named-for-stack-trace-readability.

## §Library meta-counters

- §Library-reaches-749-sections at cycle 243 (chat-lane @endo/lp32/src/host-endian).
- §Seventy-seventh consecutive designs-chat alternation cycle (cycles 166-243).
- §Smallest-file-ingested-so-far at nine lines (previous smallest: cycle 239's 28-line get-interface.js).
- §Thirty-ninth-member of §small-files-with-large-knowledge-density family.
- §Three-cycles-with-small-files-that-each-isolate-one-named-decision (cycles 239 + 241 + 243).
- §First-explicit-observation of §endianness-detection-via-typed-array-aliasing as borrowable pattern.
- §First-explicit-observation of §module-load-evaluation-memoizes-the-result as named caching shape.
- §First-explicit-observation of §the-name-shifts-from-predicate-to-state.
- §First-explicit-observation of §isolate-the-named-decision-in-its-own-file as file-shape discipline.
- §First-direct-ingest from `@endo/lp32/src/` (the lp32 package previously had `reader-writer.js` ingested at the package-level synthesis, but the source was indirect).

(Endo Project Contributors authored)
