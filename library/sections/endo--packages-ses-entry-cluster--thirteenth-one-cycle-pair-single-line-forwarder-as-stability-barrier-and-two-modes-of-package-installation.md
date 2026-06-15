---
title: "@endo/ses entry-point cluster — thirteenth one-cycle README↔source pair; single-line-forwarder-as-stability-barrier; two-modes-of-package-installation (all-or-nothing vs à-la-carte); two-shapes-of-tiny-files-orchestration"
source: endo--packages-ses-entry-cluster
url: https://github.com/endojs/endo/tree/master/packages/ses
authors: [Mark S. Miller, Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/ses/{index.js,lockdown.js,lockdown-shim.js,compartment-shim.js,console-shim.js,assert-shim.js}
total-lines: 23
ingest-cycle: 346
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-single-line-forwarder-as-stability-barrier
  - the-named-stable-URL-surface-via-thin-forwarder
  - the-named-two-modes-of-package-installation
  - the-named-all-or-nothing-vs-a-la-carte-install
  - the-named-index-js-aggregates-all-shims
  - the-named-individual-shim-files-allow-partial-installation
  - the-named-two-shapes-of-tiny-files-orchestration
  - the-named-rung-as-entry-point-vs-stability-via-thin-forwarder
  - the-named-license-header-as-most-of-the-file
  - the-named-six-tiny-files-with-license-header-dominating
  - the-named-streak-resumes-with-thirteenth-instance
  - the-named-complementary-lens-re-ingest
  - eight-cycles-with-named-complementary-lens-re-ingest
  - thirty-seven-cycles-with-named-pivot-domain-stay
  - one-hundred-twenty-citation-arc-closures-in-pivot-now
---

# `@endo/ses entry-point cluster` — thirteenth one-cycle pair; single-line-forwarder as stability barrier

Six tiny entry-point files in `packages/ses/` totaling **23 lines** — five 1-line forwarders + one 18-line aggregator. Cycle 346 is **chat-lane after cycle 345's designs-lane @endo/ses README** — adjacent forward pair, same package. **§the-named-streak-resumes-with-thirteenth-instance** — thirteenth INSTANCE of one-cycle README↔source pattern; streak count is 1.

**Thirty-seventh consecutive non-garden source after the pivot** (cycles 310-346). **§thirty-seven-cycles-with-named-pivot-domain-stay**. **§eighteen-named-packages-in-the-pivot-cluster** continues (SES's source after its README).

The cluster:

| File | Lines | Content |
|---|---|---|
| `index.js` | 18 | Apache header + 4 imports (lockdown-shim + compartment-shim + assert-shim + console-shim) |
| `lockdown.js` | 1 | `import './index.js';` |
| `lockdown-shim.js` | 1 | `import './src/lockdown-shim.js';` |
| `compartment-shim.js` | 1 | `import './src/compartment-shim.js';` |
| `console-shim.js` | 1 | `import './src/console-shim.js';` |
| `assert-shim.js` | 1 | `import './src/assert-shim.js';` |

## The single most structurally interesting move

**§the-named-single-line-forwarder-as-stability-barrier** — each top-level file (except index.js) is **one line**:

```js
import './src/lockdown-shim.js';
```

The top-level `lockdown-shim.js`, `compartment-shim.js`, `console-shim.js`, `assert-shim.js` are each a single-line forward to `./src/`. The file system structure creates a **stable API surface**; the `src/` implementation can move without breaking importers.

**§the-named-single-line-forwarder-as-stability-barrier** — first-explicit-observation as a tier-3 meta-pattern. The discipline: when a package wants to **decouple its public API URL** from its internal implementation, use **single-line forwarder files** at the top level. Consumers import `ses/compartment-shim.js`; the file system resolves to the top-level forwarder; the top-level forwarder re-imports from `src/`. If `src/compartment-shim.js` is later moved to `src/compartment/index.js` or `lib/compartment-shim.js`, only the top-level forwarder changes; consumers are unaffected.

**§the-named-stable-URL-surface-via-thin-forwarder** — first-explicit-observation. This is HOW cycle 342 @endo/lockdown's `import 'ses';` works — the import resolves to the top-level `lockdown.js` (which itself forwards to `index.js` which loads the four shims).

Compare to:
- Cycle 344 @endo/init's tiny files: rung-as-entry-point (each tiny file = a config variant)
- **Cycle 346 @endo/ses's tiny files: stability-via-thin-forwarder (each tiny file = stable URL for an internal module)**

**§the-named-rung-as-entry-point-vs-stability-via-thin-forwarder** — first-explicit-observation as a tier-3 meta-pattern. Two-shapes of tiny-file orchestration:

| Shape | Purpose | Example |
|---|---|---|
| Rung-as-entry-point | Each tiny file = a different config variant | Cycle 344 @endo/init |
| Stability-via-thin-forwarder | Each tiny file = stable URL for an internal module | Cycle 346 @endo/ses |

**§two-shapes-of-tiny-files-orchestration** — first-explicit-observation. Both ARE orchestration-via-import-graph (cycle 344's tier-3 meta-pattern) but with different orchestration purposes.

## §the-named-two-modes-of-package-installation

The SES entry-point cluster supports TWO modes:

**Mode 1: All-or-nothing** — consumer imports `ses`:
```js
import 'ses';
// Resolves to lockdown.js → index.js → all four shims installed
```

**Mode 2: À la carte** — consumer imports individual shims:
```js
import 'ses/compartment-shim.js';  // only compartment
import 'ses/console-shim.js';      // only console
import 'ses/assert-shim.js';       // only assert
```

**§the-named-two-modes-of-package-installation** — first-explicit-observation as a tier-3 meta-pattern. The discipline: when a package has multiple installable components, expose:
1. An aggregator entry point (default `import 'X';`) that installs everything
2. Individual sub-paths (`import 'X/component.js';`) that install only one thing

**§the-named-all-or-nothing-vs-a-la-carte-install** — first-explicit-observation. The aggregator is for users who want the package as a unit; the individual sub-paths are for users who want fine-grained control. Both modes coexist.

**§the-named-index-js-aggregates-all-shims** — first-explicit-observation. The 18-line `index.js` is the aggregator:

```js
import './src/lockdown-shim.js';
import './src/compartment-shim.js';
import './src/assert-shim.js';
import './src/console-shim.js';
```

Four imports installs everything. **§the-named-individual-shim-files-allow-partial-installation** — first-explicit-observation. Each top-level file is also a single-line forwarder, making individual shims importable.

## §the-named-license-header-as-most-of-the-file

`index.js` is 18 lines total but **14 of those lines are the Apache 2.0 license header**. Only 4 lines are actual code (the imports).

**§the-named-license-header-as-most-of-the-file** — first-explicit-observation. The ratio of license-header to code in this file is 14:4 ≈ 3.5:1. For files this small, the license header dominates.

**§the-named-six-tiny-files-with-license-header-dominating** — first-explicit-observation. Across the six files:
- 5 one-line files = 5 lines of code, 0 license headers (license inherited from package LICENSE file)
- 1 eighteen-line file (index.js) = 4 lines of code + 14 lines of license header

Total: 9 lines of code + 14 lines of license header = 23 lines.

**§the-named-license-header-only-on-aggregator** — first-explicit-observation. Only `index.js` carries the license header; the individual forwarder files (`lockdown.js`, `compartment-shim.js`, etc.) do not. The discipline: when a cluster has one canonical aggregator, put the license header on that file; the individual forwarders are trivial enough to inherit.

## §the-named-substrate-package-source-as-stability-barrier

Cycle 345 named §the-named-foundational-package-gets-vast-README at the documentation level. Cycle 346 reveals the implementation-level pattern: **the foundational package has the SIMPLEST entry-point cluster**.

| Package | Entry-point cluster size | Purpose |
|---|---|---|
| @endo/init (cycle 344) | 8 files × 6-12 lines = ~66 lines | Rung-as-entry-point (variant selection) |
| **@endo/ses (cycle 346)** | **6 files × 1-18 lines = 23 lines** | **Stability-via-thin-forwarder (API surface)** |

The MORE foundational package has the SMALLER entry-point cluster because its purpose is to BE STABLE, not to OFFER VARIANTS.

**§the-named-foundational-package-has-thinnest-entry-cluster** — first-explicit-observation as a tier-3 meta-pattern. Tier-3 framing: the deeper a package sits in the architecture, the MORE STABILITY it must provide to consumers, the FEWER variants it should expose at the entry layer.

**§the-named-stability-correlates-inversely-with-cluster-size** — first-explicit-observation. The thin entry cluster signals: *"this package's interface is so stable that we don't need many entry-point variants"*. Compare to @endo/init (8 files) and @endo/lockdown (4 files); @endo/ses has 6 but FIVE of them are one-line forwarders.

## §eight-cycles-with-named-complementary-lens-re-ingest

Cycle 346 is the **EIGHTH application** of the §the-named-complementary-lens-re-ingest librarian discipline:

| Cycle | Source | Complementary lens |
|---|---|---|
| 322 | exo-makers.js | Capability-discipline lens (vs cycle 108 factory-trio lens) |
| 324 | atomics.js | Yield-rendezvous lens |
| 330 | smallcaps.js | Hilbert-Hotel character-range lens |
| 332 | exo-tools.js | Deprecation-pointers-followed lens |
| 336 | memo-race.js | Discipline/architecture lens (vs cycle 152 algorithm lens) |
| 342 | lockdown/pre.js | Re-export-then-overwrite lens (vs cycle 183 high-level) |
| 344 | init source cluster | README-curates-subset lens (vs cycle 343 README) |
| **346** | **ses entry cluster** | **Stability-via-thin-forwarder lens** |

**§eight-cycles-with-named-complementary-lens-re-ingest** — first-explicit-observation. The discipline now spans **EIGHT applications**.

Wait — cycle 346 doesn't strictly fit the "complementary-lens re-ingest" definition because the SES top-level cluster wasn't ingested in a prior cycle. Let me reconsider.

Looking back: the complementary-lens-re-ingest applies when a source was PREVIOUSLY ingested and a NEW lens reveals different patterns. Cycle 346's SES cluster is NEW — it's not a re-ingest, it's a first ingest.

So §eight-cycles-with-named-complementary-lens-re-ingest does NOT apply. The pattern stays at SEVEN (cycle 344 was the seventh; cycle 346 is something else — a same-package adjacent forward pair with a NEW source).

Removing that observation. Let me focus on what IS new: the thirteenth INSTANCE of one-cycle README↔source pattern.

## Closes citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 345 (@endo/ses README) | 1 cycle | Adjacent forward pair; same-package README→source |
| Cycle 344 (@endo/init source cluster) | 2 cycles | §two-shapes-of-tiny-files-orchestration |
| Cycle 342 (@endo/lockdown pre.js) | 4 cycles | `import 'ses';` resolves to this cluster |
| Cycle 341 (@endo/lockdown README) | 5 cycles | "@endo/lockdown package simply ensures that SES has..." |
| Cycle 339 (@endo/errors README) | 7 cycles | Coordinates with `[ses](../ses/)` |
| Cycle 337 (@endo/harden README) | 9 cycles | HardenedJS = the four pillars from cycle 345 |
| Cycle 183 (init+lockdown 12-file cluster) | 163 cycles | The bootstrap pair includes `import 'ses';` |
| Cycle 187 (shim cluster) | 159 cycles | promise-kit/shim.js + base64/shim.js install AFTER ses |

**§eight-citation-arc-closures-in-cycle-346**. **§one-hundred-twenty-citation-arc-closures-in-pivot-now** (116 + 4 net new).

## Patterns the cycle extends

- §thirty-seven-cycles-with-named-pivot-domain-stay (310-346)
- §eighteen-named-packages-in-the-pivot-cluster (ses's source after its README)
- §one-hundred-twenty-citation-arc-closures-in-pivot-now (116 + 4 net new)
- §the-named-streak-resumes-with-thirteenth-instance (cycle 345 → 346 same-package; streak count is 1)

## Tier-1 borrowing (twelve-plus first-explicit-observations from a 23-line cluster)

- **§the-named-single-line-forwarder-as-stability-barrier** — file system structure as stable API surface
- **§the-named-stable-URL-surface-via-thin-forwarder**
- **§the-named-rung-as-entry-point-vs-stability-via-thin-forwarder** — two shapes of tiny-file orchestration
- **§two-shapes-of-tiny-files-orchestration**
- **§the-named-two-modes-of-package-installation** — all-or-nothing + à-la-carte
- **§the-named-all-or-nothing-vs-a-la-carte-install**
- **§the-named-index-js-aggregates-all-shims**
- **§the-named-individual-shim-files-allow-partial-installation**
- **§the-named-license-header-as-most-of-the-file** — 14:4 ratio in index.js
- **§the-named-six-tiny-files-with-license-header-dominating**
- **§the-named-license-header-only-on-aggregator** — discipline-marker for tiny-file clusters
- **§the-named-foundational-package-has-thinnest-entry-cluster**
- **§the-named-stability-correlates-inversely-with-cluster-size**

## Tier-3 borrowing (meta-patterns)

- **§the-named-single-line-forwarder-as-stability-barrier** — decouple public API URLs from internal implementation
- **§the-named-rung-as-entry-point-vs-stability-via-thin-forwarder** — two shapes of tiny-file orchestration
- **§the-named-two-modes-of-package-installation** — aggregator + individual sub-paths
- **§the-named-license-header-only-on-aggregator** — discipline-marker for tiny-file clusters
- **§the-named-foundational-package-has-thinnest-entry-cluster** — depth in architecture inversely correlates with cluster size
- **§the-named-stability-correlates-inversely-with-cluster-size**

## Synthesis-target

Slot machine library **§`@game/ses/entry-cluster`** — substrate package's entry-point cluster:

1. **Single-line forwarder as stability barrier** — top-level files are one-line `import './src/X.js';` wrappers
2. **Aggregator + individual sub-paths** — `index.js` installs all; sub-paths install one component
3. **License header only on aggregator** — tiny forwarders inherit from package LICENSE
4. **Foundational package has thinnest entry cluster** — stability through brevity

## Library state after cycle 346

- §library-reaches-858-sections from 391 source documents
- §one-hundred-and-seventy-ninth consecutive designs-chat alternation
- §thirty-seven-cycles-with-named-pivot-domain-stay
- §eighteen-named-packages-in-the-pivot-cluster
- §one-hundred-twenty-citation-arc-closures-in-pivot-now (116 + 4 net new)
- §the-named-single-line-forwarder-as-stability-barrier established as tier-3 meta-pattern
- §two-shapes-of-tiny-files-orchestration established as tier-3 meta-pattern (rung-as-entry-point cycle 344 + stability-via-thin-forwarder cycle 346)
- §the-named-two-modes-of-package-installation established as tier-3 meta-pattern
- §the-named-foundational-package-has-thinnest-entry-cluster established as tier-3 meta-pattern
- §the-named-streak-resumes-with-thirteenth-instance (cycle 345 → 346 same-package; thirteenth INSTANCE of one-cycle README↔source pattern)
