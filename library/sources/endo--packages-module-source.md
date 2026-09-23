---
title: "@endo/module-source — ModuleSource shim for SES Compartments; the parsed-cache class with invisible Unicode prefix and AbstractModuleSource forward-compatibility"
source-slug: endo--packages-module-source
url: https://github.com/endojs/endo/tree/master/packages/module-source
authors: [Endo contributors]
repo: endojs/endo
path: packages/module-source
total-lines: 1088 source (across 6 files; 636 in babel-plugin.js alone) + ~60 README
status: shipping
ingest-cycle: 223
ingest-date: 2026-06-08
lane: chat
---

# @endo/module-source

Provides the `ModuleSource` class — a shim for the TC39 Source Phase Imports proposal's ModuleSource. Captures the parsed and analyzed result of one ESM module so a cache can be shared across SES Compartments. Six source files: `module-source.js` (152, the class), `transform-analyze.js` (189, the analysis orchestrator), `babel-plugin.js` (636, the heavy lifting), `transform-source.js` (63), `parse-babel.js` (28), `hidden.js` (20).

## Key design moves

- **§The-ModuleSource-class as parsed-cache shareable across Compartments**.
- **§Class-constructor-must-be-invoked-with-`new`** check with TypeError naming the class.
- **§Two-form-of-options with normalization** (string shorthand → object).
- **§Deep-freeze-of-everything** — explicit traversal of Map values + frozen-instance.
- **§The-`__double-underscore__`-private-names-convention** — the SES Compartment internal contract (`__syncModuleProgram__`, `__liveExportMap__`, etc.).
- **§The-babel-vs-babelStar-NESM-RESM matrix** as 4-by-2 ASCII table in opening comment — §honest-acknowledgment-of-platform-quirks. Fifth member of §runtime-version-or-environment-compat-hacks-and-disclosures family.
- **§The-shebang-comment-out-trick** — `if (source.startsWith('#!')) source = '//' + source;` preserves column numbers.
- **§The-`sourceOptions`-as-shared-state-bag pattern** with §ten-named-fields collected during Babel traversal.
- **§Object.create(null)-for-prototype-free-maps** against user-source key collisions with Object.prototype.
- **§The-`{ present: false }` pattern** — mutable boolean wrapped in object for out-parameter-style traversal mutation.
- **§AbstractModuleSource for forward-compatibility** — installs intermediate prototype anticipating TC39 Source Phase Imports proposal; §asymmetric-tolerance-discipline (lockdown tolerates absence of expected prototype but not presence of unexpected one); §WebAssembly.Module-entanglement-deferred with named rationale.
- **§HIDDEN_PREFIX with invisible combining character (U+034F)** — `$h͏_` looks like `$h_` but is uniquely recognizable; §use-an-invisible-Unicode-character-in-identifier-prefixes-to-avoid-collision.
- **§HIDDEN_META sized to match `import.meta` length** for source-map-friendly substitution.
- **§HIDDEN_IDENTIFIERS as enumerated allow-list** for collision-checking by consumers.
- **§Try-catch-wrap-with-cause** — `throw SyntaxError(..., { cause: err })` preserves the original Babel error while adding location context.

## Section files

- [§ModuleSource-class-as-parsed-cache + §invisible-combining-character-as-identifier-prefix + §babel-NESM-RESM-matrix + §AbstractModuleSource-forward-compatibility](../sections/endo--packages-module-source--ModuleSource-class-as-parsed-cache-and-invisible-combining-character-as-identifier-prefix-and-babel-NESM-RESM-matrix-and-AbstractModuleSource-forward-compatibility.md) — full source ingest covering the class + analyzer + hidden-identifiers.

## Ingest scope

Cycle 223 (chat-lane): ingest of module-source.js + transform-analyze.js (top) + hidden.js as one section. The 636-line babel-plugin.js is named but not deep-ingested — the §heavy-lifting-is-elsewhere; the §architectural-decisions-live-in-the-class-and-the-hidden-identifiers.
