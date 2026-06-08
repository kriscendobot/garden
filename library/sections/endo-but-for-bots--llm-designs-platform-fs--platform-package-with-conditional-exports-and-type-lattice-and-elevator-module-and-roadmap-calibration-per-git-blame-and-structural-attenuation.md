---
title: "designs/platform-fs.md — @endo/platform package with conditional exports + type lattice + elevator module + roadmap-calibration-per-git-blame + structural attenuation"
source-slug: endo-but-for-bots--llm-designs-platform-fs
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/platform-fs.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/platform-fs.md
total-lines: 787
ingest-cycle: 242
ingest-date: 2026-06-08
lane: designs
---

# @endo/platform package with conditional exports + type lattice + elevator module + roadmap-calibration-per-git-blame + structural attenuation

A 787-line **Complete** design (Created 2026-03-18; Updated 2026-05-19). The initial package shipped 2026-03-20 via commit `e0dda06fb` on the `llm` branch; refactor and lint/type fixups continued through 2026-05-11.

## §Roadmap-calibration-per-git-blame as named design-doc structure

The §Status section opens with a one-paragraph completion summary, then a §Roadmap-calibration sub-section that enumerates §five-named-bursts derived from `git blame` with specific commit hashes per burst:

- Burst 1 (2026-03-20): initial landing `e0dda06fb` + `ed234c6a7` CLI integration.
- Burst 2 (2026-03-30): `292a6d591`, `b8cca2d00` unification of cli exec.
- Burst 3 (2026-04-11): `a2dc8ec9f`, `d5a36e8ee`, `441770389`, `9faaddb92` types/lint/format fixups under PR #122 review.
- Burst 4 (2026-05-11): `194547611` typescript-catalog adoption.
- Plus content-store-gc work in `packages/daemon` triggering follow-up 2026-05-06 `5798b56f5`.

§Thirty-first-honest-design-evolution-record family member; §fifteenth-different-shape in 2026-06 cluster: §Roadmap-calibration-per-git-blame as the §retrospective-shape-of-an-already-shipped-design. §When-a-design-is-Complete, §the-Status-section-captures-the-implementation-history-as-named-bursts + §each-burst-cites-specific-commit-hashes + §the-active-development-span-distinguishes-calendar-time-from-active-authoring-time.

§Calendar-vs-active-development-distinction explicit: *the active authoring span includes long stretches of light-touch refactor / lint maintenance after the initial landing*. §When-a-shipped-design's-active-period-spans-many-weeks-but-most-of-them-are-light-touch, §name-the-light-touch-stretches-explicitly + §don't-overstate-the-effort-by-counting-calendar-days. §Sibling-to-cycle-238's-design-revision-after-CHANGES_REQUESTED (forward-looking provenance) — cycle 242 is the §retrospective-provenance shape: §two-different-temporal-postures-on-PR-provenance in 2026-06 cluster.

## §Conditional-exports as design discipline

The package's `package.json` defines §three-exports — `./fs`, `./fs/lite`, `./fs/node` — with the `"node"` condition gating `./fs`. §`@endo/platform/fs` resolves via the `"node"` condition (a bundler targeting `"browser"` would get a different implementation or an error). §`@endo/platform/fs/lite` is always platform-agnostic. §`@endo/platform/fs/node` is the explicit-request bypass that ignores condition resolution.

§Three-export-paths-with-one-condition-gate: §the-default-path-condition-gated + §the-lite-path-always-available + §the-explicit-platform-path-bypasses-condition-resolution. §When-a-package-must-work-on-multiple-platforms-but-default-to-one, §provide-three-export-paths-not-one + §make-the-lite-subset-always-available + §reserve-future-platform-paths-in-the-package.json-comment ("Future: browser, endo-go, endo-rust").

§`@endo/platform/fs/node` re-exports everything from `@endo/platform/fs/lite` plus the Node.js-specific factories. So §the-condition-gated-default-IS-a-superset-of-the-lite-module. §Superset-by-construction.

## §Type-lattice as 2×3 axis table

The §central-design-challenge is distinguishing §three-roles-an-object-can-play (Readable / Snapshot / Mutable) along §two-axes (Blob / Tree):

```
                     Blob                          Tree
                ┌─────────────┐             ┌──────────────┐
  Mutable       │    File     │             │   Directory   │
  Readable      │ ReadableBlob│             │ ReadableTree  │
  Snapshot      │ SnapshotBlob│             │ SnapshotTree  │
```

§Six-named-types in a §2x3-axis-table (3 roles × 2 kinds). §The-type-lattice-IS-the-design-vocabulary. §Sibling-to-cycle-236's-three-axis-table (Method × Source × Confinement) and cycle-241's-2x3-axis-table-for-handler-protocol — §three-cycles-with-axis-tables-as-design-vocabulary (cycles 236 + 241 + 242).

§Snapshot-extends-Readable: §a-SnapshotBlob-IS-A-ReadableBlob (has all read methods plus `sha256()`). §The-extends-relationship-is-structural-subtyping-enforced-by-interface-guards. §When-a-content-addressed-type-IS-a-readable-type-plus-an-identity-method, §use-extends-not-a-new-shape.

§Mutable-attenuates-to-Readable via `readOnly()`: §A-File-can-produce-a-ReadableBlob-via-readOnly + §A-Directory-can-produce-a-ReadableTree-via-readOnly. §The-attenuation-is-structural-not-behavioral: §the-returned-object-simply-lacks-mutation-methods-not-has-them-throw.

§Structural-attenuation-not-behavioral-attenuation as named design discipline. §Sibling-to-cycle-238's-the-controller-and-client-cap-split (both designs choose structural attenuation: the readable view simply omits write methods rather than including them as throw-stubs). §Two-cycles-with-explicit-structural-attenuation-discipline (cycles 238 + 242).

## §The-"elevator"-module pattern

`@endo/platform/fs/node` is the §elevator-module — §it-does-`import fs from 'node:fs'`-so-that-the-lite-module-never-has-to. The name *elevator* names the architectural role: §the-elevator-takes-platform-powers-up-to-the-platform-agnostic-layer-without-the-platform-agnostic-layer-knowing-the-platform.

§The-elevator-module as named architectural pattern. §When-a-platform-agnostic-module-needs-platform-powers, §define-an-elevator-module-that-does-the-platform-import-and-passes-powers-down + §dependency-injection-of-platform-powers-into-platform-agnostic-code. §First-explicit-observation of §the-elevator-module-as-named-architectural-pattern in library.

§Sibling-to-cycle-188's-`@endo/init/node-async-local-storage-patch.js` (a Node-specific module that patches a Node-specific shape so SES-locked-down code can use it portably) — §two-different-shapes-of-platform-bridge-discipline in library: §cycle-188's-monkey-patch-the-platform-shape + §cycle-242's-elevator-module-as-platform-import-isolator.

## §Three-roles + structural-subtyping

§Three-roles-an-object-can-play named explicitly:

1. **§Readable** — a shallow, possibly-remote capability. The holder can `list`, `lookup`, and stream content, but cannot write. §This-is-what-a-guest-or-CLI-client-holds-when-interacting-with-a-potentially-remote-daemon.
2. **§Snapshot** — a content-addressed, immutable snapshot whose identity is a hash. The holder can obtain the hash and retrieve content from a `SnapshotStore`. §This-is-what-the-daemon-persists.
3. **§Mutable** — a live filesystem node that supports writes. §`readOnly()`-attenuates-a-mutable-node-to-a-readable-one.

§The-three-roles-have-named-substrates: §Readable-holder-is-a-guest-or-client + §Snapshot-holder-is-the-daemon-persistence-layer + §Mutable-holder-is-the-live-filesystem-actor. §When-a-type-vocabulary-has-three-roles, §name-the-substrate-that-typically-holds-each-role.

## §No-help()-in-this-layer as explicit non-inclusion

§Design-Decision-5: §No-help()-in-this-layer. *`help()` is a daemon convention for LLM discoverability. `@endo/platform/fs` provides the raw interfaces; the daemon wraps them with `help()` when constructing Exos for guest consumption.*

§Layer-discipline-via-explicit-non-inclusion. §When-a-convenience-method-belongs-to-a-higher-layer, §the-lower-layer-explicitly-says-no + §names-the-higher-layer + §names-the-wrapping-mechanism. §Sibling-to-cycle-238's-`endo store` does-not-accept-stdin-in-non-zip-mode (both designs make an explicit *we-do-not-include-this* decision with the reason named).

§Two-cycles-with-explicit-non-inclusion-of-a-conventional-method (cycles 238 + 242). §When-a-design-decides-not-to-include-something-conventional, §the-decision-IS-load-bearing + §name-it-explicitly-with-the-layer-or-reason.

## §Push-interface-TreeWriter-vs-pull-interface-ReadableTree

§Design-Decision-7: §`TreeWriter` is a push interface. *Rather than requiring the checkout target to implement a full `Directory`, we define a minimal `TreeWriter` with `writeBlob` and `makeDirectory`. This decouples checkout from any specific mutable tree implementation and allows zip writers, memory buffers, or remote filesystems to serve as targets.*

§Push-interface-vs-pull-interface as orthogonal design axis: §`ReadableTree`-is-pull (caller asks for children) + §`TreeWriter`-is-push (callee receives children). §The-two-shapes-decouple-source-and-sink. §When-checkout-must-support-many-target-shapes (filesystem + zip + memory + remote), §define-a-minimal-push-interface-not-a-full-mutable-tree-interface + §the-minimum-IS-the-decoupling-mechanism.

§Two-named-methods-on-TreeWriter (writeBlob + makeDirectory) — §a-minimal-interface-by-construction. §When-an-interface-is-deliberately-minimal, §name-the-purpose-of-the-minimality (decoupling) + §name-the-targets-it-enables.

## §Tree-manifest-format named explicitly

§Design-Decision-6: §Tree-manifest-format-is-`[name, type, sha256][]`. *This matches the existing `readable-tree` formula content in the daemon's CAS. Sorted by name for deterministic hashing.*

§Three-element-tuple-per-entry + §sorted-by-name-for-deterministic-hashing. §When-a-content-addressed-tree's-manifest-format-affects-the-hash, §the-format-MUST-be-canonical + §the-canonicalization-IS-the-sort-order-and-the-tuple-shape. §Sibling-to-cycle-240's-blobs-are-bytes (both designs name an exact wire-form shape with explicit canonicalization).

## §Seven-numbered-Design-Decisions

Seven decisions enumerated:

1. **§`@endo/platform/fs` not `@endo/tree`** — the module name reflects the broader filesystem concern.
2. **§Condition-gated `"node"` export, not assumed** — explicit about platform resolution.
3. **§`ReadableBlob` is shallow; `SnapshotBlob` adds `sha256()`** — content-addressed identity separated from readable surface.
4. **§`readOnly()` returns the readable interface, not a frozen copy** — structural attenuation.
5. **§No `help()` in this layer** — layer discipline via explicit non-inclusion.
6. **§Tree manifest format is `[name, type, sha256][]`** — sorted by name for deterministic hashing.
7. **§`TreeWriter` is a push interface** — minimal interface decouples checkout from mutable tree implementations.

§Four-cycles-with-numbered-Design-Decisions in library now (cycle 230 had 5 + cycle 236 had 9 + cycle 240 had 3 + cycle 242 has 7). §Different-counts-each-time: 3, 5, 7, 9 — §the-decision-count-IS-the-design's-shape-not-a-template. §When-a-design-has-N-named-decisions, §the-N-IS-load-bearing-don't-pad-or-trim.

## §Relationship-to-existing-interfaces section

§Three-related-existing-interfaces enumerated:

- §EndoNameHub-/-EndoDirectory — `ReadableTree` is structurally compatible with the read surface; `Directory` is structurally compatible with the mutation surface. §But-`@endo/platform/fs`-types-do-NOT-include-formula-system-concepts (identify, locate, followNameChanges); §the-design-stops-at-the-filesystem-boundary.
- §EndoReadable — the existing daemon type maps directly to `SnapshotBlob`. §The-daemon-can-type-alias-EndoReadable-=-SnapshotBlob-or-keep-both-during-migration.
- §daemon-capability-filesystem.md — the `Dir` and `File` interfaces correspond to `Directory` and `File` here. §`subDir()`-is-not-in-this-design-because-it-is-a-VFS-namespace-concern-not-a-storage-concern + §it-belongs-in-a-future-VFS-layer-that-composes-`@endo/platform/fs`-primitives.

§Three-named-existing-types-with-explicit-mapping-or-non-mapping. §When-a-new-design-overlaps-with-existing-types, §enumerate-each-overlap-explicitly + §name-which-overlaps-are-aliases-vs-which-are-deliberate-omissions. §The-design-doesn't-pretend-the-existing-types-don't-exist — it names them and maps them.

§Stops-at-the-filesystem-boundary as named design discipline. §When-a-design-could-be-extended-into-an-adjacent-concern, §explicitly-name-the-boundary-and-defer-the-extension + §name-the-future-layer-that-would-extend-it.

## §Four-phase implementation plan with S/M complexity tags

Four phases:

1. **Phase 1: Package Skeleton and Types (S)** — package.json, conditional exports, types, interface guards. No behavioral code.
2. **Phase 2: Snapshot Store and Snapshot Blob/Tree (S)** — extract makeSnapshotSha256Store + makeSnapshotBlob + makeSnapshotTree.
3. **Phase 3: Checkin/Checkout Extraction (S)** — extract checkinTree + checkoutTree + makeLocalTree + makeLocalBlob + makeTreeWriter.
4. **Phase 4: Mutable Directory and File (M)** — File and Directory Exos with readOnly() attenuation.

§Three-S-and-one-M phase. §The-S/M-complexity-tag is the §size-effort-estimate per phase. §When-the-design-already-shipped, §the-Status-section's-roadmap-calibration-validates-the-phase-tags-against-actual-burst-durations. §Cycle-242's-burst-1 (initial landing) maps to Phases 1+2+3 in one day (S+S+S); §burst-2-and-burst-3 are §M-phase-and-cleanup-rolled-up.

§First-cycle-in-library-with-S/M-complexity-tag-per-phase that can be validated against §git-blame-burst-history.

## §The Prompt — explicit naming spec

§The-Prompt-section-IS-the-naming-specification: the user (maintainer) names the package (`@endo/platform`), the module (`@endo/platform/fs`), the elevator module (`@endo/platform/fs/node`), the lite module (`@endo/platform/fs/lite`), and the build condition (`"node"`). The Prompt explicitly says: *Distinguish Readable* (shallow) from content-addressable. Leave space for .readOnly() methods.*

§Seventh-Prompt-section-instance (cycles 198 + 224 + 230 + 236 + 238 + 240 + 242). §The-Prompt-IS-the-naming-spec — §the-prompt-fixes-the-vocabulary-at-the-outset-and-the-design-fills-it-in. §When-the-prompt-names-the-types, §the-design-doesn't-second-guess-the-names-it-fills-in-the-structure.

§Sibling-to-cycle-240's-identifier-conventions-TBD-pending-namer-dispatch (cycle 240 deferred naming; cycle 242 had the names in the prompt). §Two-different-postures-on-naming: §defer-to-namer-dispatch (cycle 240) + §names-in-prompt (cycle 242). §When-the-design-doc's-prompt-already-names-the-types, §the-design-doesn't-need-a-namer-dispatch.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §Roadmap-calibration-per-git-blame with named bursts and commit hashes (thirty-first honest-design-evolution-record family member).
- §Calendar-vs-active-development-distinction explicit when most of the calendar span is light-touch.
- §Conditional-exports with three paths (default condition-gated + lite always-available + explicit-platform bypass).
- §Type-lattice as 2×3 axis table (three roles × two kinds).
- §Structural-subtyping (Snapshot extends Readable) for content-addressed types.
- §Structural-attenuation-not-behavioral-attenuation — readOnly returns the readable interface, not a frozen copy.
- §The-"elevator"-module as named architectural pattern — platform-specific module does the import so the platform-agnostic module never has to.
- §No-help()-in-this-layer as explicit non-inclusion with the higher-layer named.
- §Push-interface (TreeWriter) vs pull-interface (ReadableTree) decoupling.
- §Tree-manifest-format named with explicit canonicalization (`[name, type, sha256][]` sorted by name).

**Tier-2 (design discipline):**

- §Three-roles-an-object-can-play with named substrates per role.
- §Relationship-to-existing-interfaces enumerates each overlap and names mapping or deliberate omission.
- §Stops-at-the-filesystem-boundary as named design discipline.
- §Four-phase implementation plan with S/M complexity tags.
- §Two-named-methods-on-TreeWriter (minimal interface by construction).
- §subDir-deferred-to-future-VFS-layer with reason and future-layer named.

**Tier-3 (named comparisons):**

- §The-Prompt-IS-the-naming-spec — when the prompt fixes the vocabulary, the design fills it in.
- §Superset-by-construction — `@endo/platform/fs/node` re-exports everything from `/lite` plus Node specifics.

## §Synthesis target — slot machine library

For a slot machine library:

- §Roadmap-calibration-per-git-blame for §game-engine-shipped-history-with-named-bursts.
- §Conditional-exports for §game-engine-on-different-platforms (default browser + lite always-available + explicit-platform paths).
- §Type-lattice for §game-state-roles (Player-view + Snapshot + Mutable) × (Single-game + Tournament).
- §Structural-subtyping for §game-state-snapshot-extends-game-state-readable.
- §Structural-attenuation-not-behavioral-attenuation for §player-view-of-game-state-simply-lacks-admin-methods.
- §The-"elevator"-module for §game-platform-bridge that does the platform-specific import so the platform-agnostic game engine never has to.
- §No-help()-in-this-layer for §game-rule-engine-doesn't-include-discoverability (layered separately).
- §Push-interface vs pull-interface for §game-state-rendering-target (TreeWriter analog).
- §Game-rule-manifest-format named with explicit canonicalization.
- §Stops-at-the-game-rule-engine-boundary as named design discipline.

## §Library meta-counters

- §Library-reaches-748-sections at cycle 242 (designs-lane platform-fs).
- §Seventy-sixth-consecutive designs-chat alternation cycle (cycles 166-242).
- §Thirty-first-honest-design-evolution-record family member (new shape: §Roadmap-calibration-per-git-blame as retrospective-design-doc-structure).
- §Fifteenth-different-shape-of-design-evolution-record in 2026-06 cluster (214 + 216 + 218 + 220 + 222 + 224 + 226 + 227 + 228 + 230 + 232 + 236 + 238 + 240 + 242).
- §Eight-cycles-on-no-new-abstractions discipline now (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242).
- §Six-cycles-with-Dependencies-table-with-Relationship-column (224 + 230 + 236 + 238 + 240 + 242).
- §Seventh-Prompt-section-instance (198 + 224 + 230 + 236 + 238 + 240 + 242).
- §Four-cycles-with-numbered-Design-Decisions (230 + 236 + 240 + 242) with different counts (5 + 9 + 3 + 7); §the-N-IS-load-bearing-not-a-template.
- §Three-cycles-with-axis-tables-as-design-vocabulary (cycles 236 + 241 + 242).
- §Two-cycles-with-explicit-structural-attenuation-discipline (cycles 238 + 242).
- §Two-cycles-with-explicit-non-inclusion-of-a-conventional-method (cycles 238 + 242).
- §Two-cycles-with-explicit-future-deferral-with-reason-and-future-layer (cycles 238 + 242 — cycle 238's edit/patch reservation + cycle 242's subDir-deferred-to-future-VFS).
- §Two-different-temporal-postures-on-PR-provenance (cycle 238 forward-looking + cycle 242 retrospective).
- §Two-different-postures-on-naming (cycle 240 namer-dispatch + cycle 242 names-in-prompt).
- §Two-different-shapes-of-platform-bridge-discipline (cycle 188 monkey-patch + cycle 242 elevator-module).
- §First-explicit-observation of four patterns: §Roadmap-calibration-per-git-blame as retrospective design-doc structure + §the-"elevator"-module as named architectural pattern + §structural-attenuation-not-behavioral-attenuation as named design discipline + §push-interface-vs-pull-interface-decoupling as orthogonal axis.
- §First-cycle-in-library-with-S/M-complexity-tag-per-phase that can be validated against git-blame-burst-history.

(Kris Kowal (prompted) authored)
