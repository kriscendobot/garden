---
title: "@endo/init source cluster — seventh complementary-lens; README curates subset of implementation rungs (5 vs 3); orchestration via import graph; two-shapes-of-tolerance-ladder-rung; twelfth one-cycle README↔source pair"
source: endo--packages-init-source-cluster
url: https://github.com/endojs/endo/tree/master/packages/init
authors: [Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/init/{index.js,debug.js,unsafe-fast.js,legacy.js,debug-async-hooks.js,pre.js,pre-remoting.js,pre-bundle-source.js}
total-lines: 66
ingest-cycle: 344
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-README-curates-subset-of-implementation-rungs
  - the-named-five-rungs-in-implementation-vs-three-in-README
  - the-named-two-shapes-of-tolerance-ladder-rung
  - the-named-re-export-from-variant-vs-direct-call-with-options
  - the-named-orchestration-via-import-graph
  - the-named-tiny-files-where-the-COMPOSITION-is-the-content
  - the-named-layered-shim-with-named-addition
  - the-named-pre-remoting-adds-eventual-send-to-pre
  - the-named-base64-and-promise-kit-as-canonical-pre-lockdown-shims
  - the-named-export-star-from-named-lockdown-variant
  - the-named-direct-import-and-call-when-custom-options
  - the-named-deprecated-with-named-replacement-in-source
  - the-named-async_hooks-patch-with-named-platform-limitation
  - the-named-doubled-underscores-as-internal-API-marker
  - the-named-complementary-lens-re-ingest
  - seven-cycles-with-named-complementary-lens-re-ingest
  - the-named-streak-resumes-with-twelfth-instance
  - thirty-five-cycles-with-named-pivot-domain-stay
  - one-hundred-five-citation-arc-closures-in-pivot-now
---

# `@endo/init source cluster` — seventh complementary-lens; README curates subset of implementation rungs

A cluster of 8 tiny source files (6-12 lines each; ~66 lines total) under `packages/init/`. Cycle 344 is **chat-lane after cycle 343's designs-lane @endo/init README** — adjacent forward pair, same package. **§the-named-streak-resumes-with-twelfth-instance** — twelfth INSTANCE of one-cycle README↔source pattern; streak count is 1.

**Thirty-fifth consecutive non-garden source after the pivot** (cycles 310-344). **§thirty-five-cycles-with-named-pivot-domain-stay**. **§seventeen-named-packages-in-the-pivot-cluster** continues (init's source after its README).

**§seven-cycles-with-named-complementary-lens-re-ingest** (322 exo-makers + 324 atomics + 330 smallcaps + 332 exo-tools + 336 memo-race + 342 lockdown-pre + **344 init-source-cluster**) — the librarian discipline now spans **SEVEN applications**. Cycle 183 ingested 12 init+lockdown bootstrap files as comment-fragment naming high-level patterns; cycle 344 takes the implementation-side view of just the @endo/init subset (8 files).

## The single most structurally interesting move

**§the-named-README-curates-subset-of-implementation-rungs** — cycle 343's README named **three rungs** of the tolerance ladder:

| README rung | Cycle 343 |
|---|---|
| `@endo/init` (default) | Lines 1-15 |
| `@endo/init/debug.js` | Lines 18-43 |
| `@endo/init/unsafe-fast.js` | Lines 47-52 |

Cycle 344's implementation reveals **FIVE actual rungs** plus three preamble files:

| File | Lines | Role | In README? |
|---|---|---|---|
| `index.js` | 6 | Default entry point | **YES** (named `@endo/init`) |
| `debug.js` | 6 | Less-safe + better debugging | **YES** |
| `unsafe-fast.js` | 8 | Extreme: `__hardenTaming__: 'unsafe'` | **YES** |
| `legacy.js` | 12 | Loosest: severe + verbose + unsafe-error | **NO** |
| `debug-async-hooks.js` | 12 | Debug + Node.js async_hooks patch | **NO** |
| `pre.js` | 7 | Shim preamble (lockdown + base64 + promise-kit) | Indirectly via `@endo/init/pre.js` |
| `pre-remoting.js` | 7 | pre.js + eventual-send/shim | Indirectly |
| `pre-bundle-source.js` | 8 | DEPRECATED — replaced by `@endo/init` | Not mentioned |

**§the-named-five-rungs-in-implementation-vs-three-in-README** — first-explicit-observation. The README's three rungs are a **curated user-facing subset**; the implementation has **five rungs** (adding `legacy.js` and `debug-async-hooks.js` for specific niches).

**§the-named-README-curates-subset-of-implementation-rungs** — first-explicit-observation as a tier-3 meta-pattern. The README simplifies the surface for the reader; the source reveals the full architecture. Tier-3 framing: README documentation can DELIBERATELY UNDERSTATE the implementation's complexity to keep the user-facing surface tractable; the full rungs are discoverable from the source.

Compare to:
- Cycle 326 @endo/patterns/index.js: deprecated re-exports kept for backward compatibility (canonical-path-vs-backward-compatibility-path)
- Cycle 337 @endo/harden's isFake-deprecated-with-named-regret (regret about an existing option)
- Cycle 343 @endo/init's three-rung documentation
- **Cycle 344's revelation: README documents three; implementation provides five**

**§the-named-curated-vs-full-API-distinction** — first-explicit-observation as a tier-3 meta-pattern. The README's *curated* API is what we want users to default to; the *full* API includes rungs that exist for specific niches (legacy migration + Node.js async_hooks debugging).

## §the-named-two-shapes-of-tolerance-ladder-rung

The five rungs split into TWO structural shapes:

**Shape 1: Re-export-from-variant** (index.js + debug.js + debug-async-hooks.js):

```js
import './pre-remoting.js';
export * from '@endo/lockdown/commit.js';     // or commit-debug.js
```

No options passed; the lockdown VARIANT is chosen by which file is re-exported. The lockdown configuration lives in the @endo/lockdown package; @endo/init just CHOOSES the variant.

**Shape 2: Direct-call-with-options** (unsafe-fast.js + legacy.js):

```js
import { lockdown } from '@endo/lockdown';
import './pre-remoting.js';

const options = { __hardenTaming__: 'unsafe' };  // or { overrideTaming: 'severe', ... }
lockdown(options);
```

Imports the function and calls with explicit options.

**§the-named-two-shapes-of-tolerance-ladder-rung** — first-explicit-observation as a tier-3 meta-pattern. The discipline:
- Use **re-export-from-variant** when the safety/debugging tradeoff is encoded in the lockdown variant package
- Use **direct-call-with-options** when the variant is NOT pre-configured (legacy.js) OR when an unusual option is needed (unsafe-fast.js's `__hardenTaming__`)

**§the-named-re-export-from-variant-vs-direct-call-with-options** — first-explicit-observation. Compare to cycle 342's §the-named-re-export-then-overwrite-pattern (in lockdown/pre.js); cycle 344's pattern is the *consumer-side* of cycle 342's wrapper.

**§three-shapes-of-tolerance-ladder-implementation** — first-explicit-observation:

| Shape | Cycle | Location |
|---|---|---|
| Separate entry-point files | 183 | File system as policy boundary |
| Re-export-from-variant | 344 | Encoded in `@endo/lockdown/commit*.js` choice |
| Direct-call-with-options | 344 | Options bag passed to `lockdown()` |

The cycle 183 + 343 + 344 trilogy now names the full architecture of tolerance ladders.

## §the-named-orchestration-via-import-graph

The 8 files form an IMPORT GRAPH:

```
unsafe-fast.js ──┐
                 ├──► pre-remoting.js ──► pre.js ──► @endo/lockdown
legacy.js ───────┤
index.js ────────┤                                  @endo/base64/shim
debug.js ────────┤                                  @endo/promise-kit/shim
debug-async-hooks.js ─┐
                      └──► (also imports ./src/node-async_hooks-patch.js)

pre-bundle-source.js (DEPRECATED) ──► pre.js
pre-remoting.js ──► @endo/eventual-send/shim
```

**§the-named-orchestration-via-import-graph** — first-explicit-observation as a tier-3 meta-pattern. The package's purpose is initialization-orchestration; the import graph IS the architecture. No file exceeds 12 lines because the graph carries the complexity.

**§the-named-tiny-files-where-the-COMPOSITION-is-the-content** — first-explicit-observation. Each file is tiny; the value is in HOW THEY COMPOSE. Compare to cycle 152's memo-race.js (170 lines; algorithmic complexity) vs cycle 344's init cluster (8 files × ~8 lines = composition-as-content).

**§two-shapes-of-substrate-package-implementation** — first-explicit-observation:

| Shape | Example | Complexity location |
|---|---|---|
| Single substantial file | cycle 338 make-hardener.js (471 lines) | Within one file |
| Tiny-files-orchestrated | cycle 344 init cluster (8 × ~8 lines) | In the import graph |

## §the-named-layered-shim-with-named-addition

`pre.js` (7 lines):

```js
import '@endo/lockdown';
import '@endo/base64/shim.js';
import '@endo/promise-kit/shim.js';
export * from '@endo/lockdown';
```

`pre-remoting.js` (7 lines):

```js
export * from './pre.js';
export * from '@endo/eventual-send/shim.js';
```

**§the-named-pre-remoting-adds-eventual-send-to-pre** — first-explicit-observation. `pre-remoting.js` is structurally `pre.js + eventual-send-shim`. The layered design: `pre.js` is the basic shim cluster; `pre-remoting.js` extends it with HandledPromise/eventual-send.

**§the-named-layered-shim-with-named-addition** — first-explicit-observation as a tier-3 meta-pattern. The discipline: when a package has variants that differ by adding ONE FEATURE, structure them as layers (`base.js` + `extended.js`) rather than separate independent files.

**§the-named-base64-and-promise-kit-as-canonical-pre-lockdown-shims** — first-explicit-observation. `pre.js` installs THREE pre-lockdown shims: lockdown itself, @endo/base64, @endo/promise-kit. These are the canonical pre-lockdown stack. Cycle 187 named the shim cluster; cycle 344 reveals the exact three-package composition.

## §the-named-deprecated-with-named-replacement-in-source

`pre-bundle-source.js` (8 lines):

```js
// pre-bundle-source.js - initialization to use @endo/bundle-source
// DEPRECATED: no longer necessary, imports of this module can be replaced with
//   import '@endo/init';
// or if further vetted shim initialization is needed:
//   import '@endo/init/pre.js';

// eslint-disable-next-line import/export
export * from './pre.js';
```

**§the-named-deprecated-with-named-replacement-in-source** — first-explicit-observation. The file is DEPRECATED with the migration path NAMED INLINE: *"imports of this module can be replaced with `import '@endo/init';`"*. Two named alternatives are provided: simple (`@endo/init`) AND advanced (`@endo/init/pre.js`).

Compare to:
- Cycle 326 @endo/patterns/index.js: @deprecated tags with canonical pointers
- Cycle 337 @endo/harden's isFake-deprecated-with-named-regret
- Cycle 343 @endo/init's unsafe-fast-with-aspiration-to-remove
- **Cycle 344's pre-bundle-source.js: file-header DEPRECATED comment with TWO named replacements**

**§five-shapes-of-deprecation-discipline** — first-explicit-observation as a tier-3 meta-pattern:

| Shape | Cycle | Example |
|---|---|---|
| @deprecated tag with canonical pointer | 326 | Patterns/index.js re-exports |
| Deprecated with named regret | 337 | Harden isFake |
| Deprecated with named aspiration to remove | 343 | Init unsafe-fast |
| Deprecated with named replacement in source | 344 | Init pre-bundle-source |
| Deprecated with forwarding-comment to alternative | 211 | @endo/common ident-checker |

Five named shapes; deprecation discipline at five different levels.

## §the-named-async_hooks-patch-with-named-platform-limitation

`debug-async-hooks.js` (12 lines):

```js
// Install async_hooks patches for Node.js debugging in lockdown mode
// This is a specialized entrypoint for debugging scenarios where async_hooks
// compatibility is needed (e.g., for debuggers in older Node.js versions).
// Note: This patch may not work in Node.js 24+.
import './src/node-async_hooks-patch.js';
import './pre-remoting.js';
export * from '@endo/lockdown/commit-debug.js';
```

**§the-named-async_hooks-patch-with-named-platform-limitation** — first-explicit-observation. The file's comment names BOTH:
1. **Purpose**: debugging in older Node.js versions
2. **Limitation**: *"This patch may not work in Node.js 24+"*

The file is built for a SPECIFIC PLATFORM VERSION WINDOW. **§the-named-platform-version-window-named-explicitly** — first-explicit-observation. The discipline: when a feature is tied to a platform version, name the END of the window explicitly so users know when to revisit.

## §the-named-doubled-underscores-as-internal-API-marker

`unsafe-fast.js` uses `__hardenTaming__: 'unsafe'`:

```js
const options = {
  __hardenTaming__: 'unsafe',
};
```

**§the-named-doubled-underscores-as-internal-API-marker** — first-explicit-observation. The double-underscore-prefix-AND-suffix convention marks this as an INTERNAL/non-public-API option. Users see the option in the source and know it's not part of the stable API.

Compare to cycle 337 @endo/harden README's discussion of `harden:unsafe` build-condition; cycle 344 reveals the runtime equivalent uses doubled-underscores naming. **§two-shapes-of-internal-API-marker** (build-condition + doubled-underscores).

## Closes citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 343 (@endo/init README) | 1 cycle | Adjacent forward pair; same-package README→source |
| Cycle 342 (lockdown pre.js) | 2 cycles | init/lockdown sibling implementations |
| Cycle 341 (lockdown README) | 3 cycles | substrate package introduction cluster |
| **Cycle 183 (init+lockdown 12-file cluster)** | **161 cycles** | **SEVENTH complementary-lens re-ingest** |
| Cycle 187 (shim-and-prepare cluster) | 157 cycles | @endo/eventual-send/shim is in pre-remoting.js |
| Cycle 152 (memo-race.js) | 192 cycles | @endo/promise-kit/shim installs Promise.race = memoRace |
| Cycle 326 (deprecation-with-redirect) | 18 cycles | §five-shapes-of-deprecation-discipline |
| Cycle 337 (harden README) | 7 cycles | prepare-* convention; debug-async-hooks fits the prepare pattern |
| Cycle 211 (@endo/common's ident-checker DEPRECATED with forwarding-comment) | 133 cycles | §five-shapes-of-deprecation-discipline |

**§nine-citation-arc-closures-in-cycle-344**. **§one-hundred-five-citation-arc-closures-in-pivot-now** (98 + 7 net new) — **CROSSES THE 100-ARC MILESTONE**.

**§seven-cycles-with-named-substrate-package-introduction** (337 + 339 + 340 + 341 + 342 + 343 + 344) — the substrate-introduction phase extends to **eight consecutive cycles**. **§the-named-substrate-package-cluster-introduction-trend-extends-to-eight-cycles** — first-explicit-observation.

## Patterns the cycle extends

- §thirty-five-cycles-with-named-pivot-domain-stay (310-344)
- §seventeen-named-packages-in-the-pivot-cluster (init's source after its README)
- §one-hundred-five-citation-arc-closures-in-pivot-now (98 + 7 net new; **100-arc milestone CROSSED**)
- **§seven-cycles-with-named-complementary-lens-re-ingest** (322 + 324 + 330 + 332 + 336 + 342 + 344) — librarian discipline confirmed across **SEVEN applications**
- §seven-cycles-with-named-substrate-package-introduction (337-344 inclusive)
- §the-named-substrate-package-cluster-introduction-trend-extends-to-eight-cycles
- §five-shapes-of-deprecation-discipline (326 + 337 + 343 + 344 + 211)
- §the-named-streak-resumes-with-twelfth-instance

## Tier-1 borrowing (twenty-plus first-explicit-observations)

- **§the-named-README-curates-subset-of-implementation-rungs** — README documents 3; implementation has 5
- **§the-named-five-rungs-in-implementation-vs-three-in-README**
- **§the-named-curated-vs-full-API-distinction**
- **§the-named-two-shapes-of-tolerance-ladder-rung** — re-export-from-variant + direct-call-with-options
- **§the-named-re-export-from-variant-vs-direct-call-with-options**
- **§three-shapes-of-tolerance-ladder-implementation** — separate-entry-point-files + re-export-from-variant + direct-call-with-options
- **§the-named-orchestration-via-import-graph**
- **§the-named-tiny-files-where-the-COMPOSITION-is-the-content**
- **§two-shapes-of-substrate-package-implementation** — single-substantial-file + tiny-files-orchestrated
- **§the-named-pre-remoting-adds-eventual-send-to-pre**
- **§the-named-layered-shim-with-named-addition**
- **§the-named-base64-and-promise-kit-as-canonical-pre-lockdown-shims**
- **§the-named-export-star-from-named-lockdown-variant**
- **§the-named-direct-import-and-call-when-custom-options**
- **§the-named-deprecated-with-named-replacement-in-source**
- **§five-shapes-of-deprecation-discipline**
- **§the-named-async_hooks-patch-with-named-platform-limitation**
- **§the-named-platform-version-window-named-explicitly**
- **§the-named-doubled-underscores-as-internal-API-marker**
- **§two-shapes-of-internal-API-marker** — build-condition + doubled-underscores

## Tier-2 borrowing (multi-cycle patterns extended)

- §thirty-five-cycles-with-named-pivot-domain-stay
- §seventeen-named-packages-in-the-pivot-cluster
- §one-hundred-five-citation-arc-closures-in-pivot-now (100-arc milestone CROSSED)
- §seven-cycles-with-named-complementary-lens-re-ingest (322 + 324 + 330 + 332 + 336 + 342 + 344)
- §seven-cycles-with-named-substrate-package-introduction (337-344)
- §the-named-substrate-package-cluster-introduction-trend-extends-to-eight-cycles
- §five-shapes-of-deprecation-discipline
- §the-named-streak-resumes-with-twelfth-instance

## Tier-3 borrowing (meta-patterns)

- **§the-named-README-curates-subset-of-implementation-rungs** — README can deliberately understate complexity for user-facing tractability
- **§the-named-curated-vs-full-API-distinction**
- **§the-named-two-shapes-of-tolerance-ladder-rung**
- **§three-shapes-of-tolerance-ladder-implementation**
- **§the-named-orchestration-via-import-graph** — tiny files connected via import graph encode full architecture
- **§two-shapes-of-substrate-package-implementation** — single-substantial-file vs tiny-files-orchestrated
- **§the-named-layered-shim-with-named-addition** — when variants differ by one feature, structure as layers
- **§five-shapes-of-deprecation-discipline** — @deprecated-pointer + regret + aspiration + replacement-in-source + forwarding-comment
- **§the-named-platform-version-window-named-explicitly**
- **§two-shapes-of-internal-API-marker** — build-condition + doubled-underscores

## Synthesis-target

Slot machine library **§`@game/init/source-cluster`** — initialization-orchestration via tiny files:

1. **README curates subset of implementation rungs** — document the canonical three rungs; reveal the full five in source for power users
2. **Two-shapes-of-tolerance-ladder-rung** — re-export-from-variant + direct-call-with-options
3. **Orchestration via import graph** — tiny files connected via imports encode full architecture
4. **Layered shim with named addition** — `pre.js` (basic) + `pre-remoting.js` (pre + extension)
5. **Deprecated-with-named-replacement-in-source** — file-header comment names the migration path
6. **Async_hooks-style platform-version-window** — name the END of the support window
7. **Doubled-underscores as internal API marker** — runtime equivalent of `-C unsafe-fast` build condition

## Library state after cycle 344

- §library-reaches-856-sections from 389 source documents (one new section + new source-cluster page)
- §one-hundred-and-seventy-seventh consecutive designs-chat alternation
- §thirty-five-cycles-with-named-pivot-domain-stay
- §seventeen-named-packages-in-the-pivot-cluster (init's source after its README)
- **§one-hundred-five-citation-arc-closures-in-pivot-now** (98 + 7 net new; **CROSSES 100-ARC MILESTONE**)
- **§seven-cycles-with-named-complementary-lens-re-ingest** (322 + 324 + 330 + 332 + 336 + 342 + 344) — librarian discipline confirmed across SEVEN applications
- §seven-cycles-with-named-substrate-package-introduction (337-344); §the-named-substrate-package-cluster-introduction-trend-extends-to-eight-cycles
- §the-named-README-curates-subset-of-implementation-rungs established as tier-3 meta-pattern
- §the-named-orchestration-via-import-graph established as tier-3 meta-pattern
- §five-shapes-of-deprecation-discipline established as tier-3 meta-pattern
- §the-named-streak-resumes-with-twelfth-instance (cycle 343 → 344 same-package; twelfth INSTANCE of one-cycle README↔source pattern; streak count is 1)
