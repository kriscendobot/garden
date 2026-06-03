---
source: designs/endo-bytes.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endo-bytes.md
source_path: designs/endo-bytes.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Designer (dispatched per kriskowal review)
topics:
  - tooling
  - patterns
  - pass-style
genre: §endo-but-for-bots-design
cycle: 172
lane: designs
status: current
---

# Maximal-power-minimal-area four-helper package with no barrel and qualified export names

> §Endo-but-for-bots-design genre (designs-lane). Status:
> **Implemented** (PR #142). §Sourced-from-PR-inline-
> review-comment ([PR 122 comment 3205507716]).

`designs/endo-bytes.md` (617 lines) is the design for
extracting duplicated `Uint8Array` helpers into a new
`@endo/bytes` utility package. The single most structurally
interesting move is the **§maximal-power-minimal-area
discipline** (per user's review guidance): §ship-the-
smallest-API-that-retires-the-existing-duplicates; §add-
helpers-when-a-real-consumer-asks.

Cycle 167's @endo/where/index.js and cycle 171's
@endo/stream/index.js are §sibling-utility-packages with
similar shape (small, focused, foundational). This design
shows what the §process-of-extracting-a-new-utility-package
looks like.

## §The-portability-problem (§three-platform-constraint)

> *Endo runs in three byte-handling platforms: Node (where
> `Buffer` is ambient), XS (no `Buffer`, no
> `globalThis.Buffer`), and SES-locked compartments (where
> `Buffer` may exist on the host platform but is
> intentionally not propagated into the locked
> compartment).*

§Three-platforms-with-different-byte-substrate-availability:

| Platform | Buffer? | Uint8Array | TextEncoder/Decoder |
|----------|---------|------------|---------------------|
| Node | Ambient global | Yes | Yes |
| XS | None | Yes | Yes |
| SES-locked compartment | Deliberately withheld | Yes (safe intrinsic) | Hand-threaded via globals |

§Uint8Array-is-the-portable-choice; §Buffer-is-Node-only-
unportable-baggage. §SES-deliberately-withholds-Buffer to
avoid Node-specific behavior leaking into compartments.

§The-codebase-rule: *Prefer Uint8Array over Node Buffer*.
§The-rule-was-honored-at-call-sites; §but-every-site-
reinvented-the-same-handful-of-Uint8Array-operations.

## §Five-existing-duplicates audit (the trigger)

§PR-122-triplication: three near-identical `concatChunks`
helpers in `packages/platform/src/fs-node/{file,directory,
tree-writer}.js`, each a §verbatim-copy-of-the-same-nine-
line-function.

§Broader-audit shows §at-least-five-separate-concat-a-list-
of-chunks-functions with §subtly-different-signatures
(`concat`, `concatChunks`, `concatUint8Arrays`,
`asyncConcat`, plus inline `Buffer.concat(...)` ports).

§Three-concrete-costs:

1. §Each-new-caller-invents-another-copy.
2. §Subtle-drift-between-copies (`length` vs `byteLength`;
   `for`-loop vs `reduce`; etc.).
3. §Buffer-ports-still-landing (Node-only dependencies
   keep being introduced where they don't need to be).

§The-immediate-trigger is PR 122's triplication; §the-
broader-state was identified during the audit.

## §Maximal-power-minimal-area discipline (the design ethos)

> *The principle (per the user's "maximal-power-minimal-
> area" guidance): ship the smallest API that retires the
> existing duplicates, add helpers when a real consumer
> asks.*

§User-guidance-cited-as-design-principle. §The-discipline
encodes:

- §Audit-first-design-second: count the existing
  duplicates before deciding what to include.
- §Justify-each-helper-with-existing-duplicate-count.
- §Defer-helpers-that-don't-yet-retire-duplicates.
- §Don't-build-for-hypothetical-future-consumers.

§Four-helpers-MVP: concatBytes + bytesEqual + bytesFromText
+ bytesToText. §Each-has-rationale-with-existing-
duplicates-count.

§Six-helpers-explicitly-deferred (with named-reasons): slice
(use subarray); fromBase64/toBase64 (use @endo/base64);
fromHex/toHex (use @endo/hex); compare (no current call
site); concatInto (TC39 may standardize); fromArrayBuffer
(one-liner already).

§Document-what's-not-included-and-why. §Negative-space-is-
load-bearing.

## §Helper rationale table

| Helper | Existing duplicates | Why include |
|--------|---------------------|-------------|
| concatBytes | 5+ (PR 122 ×3 + cli/store.js + ocapn buffer-utils + Buffer.concat ports) | Highest-value extraction; the immediate trigger |
| bytesEqual | Several inline loops (not yet a named helper) | Pre-empts the next reviewer flag |
| bytesFromText | 8 module-scoped TextEncoders in daemon/src + connection.js + worker.js | Avoids per-module encoder allocation |
| bytesToText | 4+ fresh-TextDecoder-per-call sites | Symmetric with bytesFromText |

§Each-helper-is-justified-by-a-count. §Counts-are-
auditable. §The-design-doesn't-include-a-helper-with-zero-
duplicates.

## §No-barrel-module-per-helper-surface (Decision 5)

> *Each export gets its own surface module at the package
> root, which re-exports from the matching implementation
> file under `src/`. Consumers import from `@endo/bytes/
> <helper>.js` directly.*

§No-index.js-aggregate. §No-root-export. §Per-helper-
surface-module.

§Why-no-barrel:

1. §Tree-shaking-friendliness: a consumer importing only
   `concatBytes` doesn't drag in `bytesFromText`'s
   TextEncoder allocation.
2. §Per-helper-surface-area-is-easy-to-audit.
3. §The-discipline-kriskowal-asked-for-during-PR-142-
   implementation-review.

§Each-surface-module-is-a-thin-re-export (one line):

```js
// packages/bytes/concat.js
export { concatBytes } from './src/concat.js';
```

§Synthesis-target: future utility packages can follow §per-
helper-surface-without-barrel pattern.

## §Qualified-export-names (Decision 6)

> *The exported identifier carries the `bytes` qualifier
> (`concatBytes`, `bytesEqual`, `bytesFromText`,
> `bytesToText`) so the call site reads unambiguously
> without an import rename.*

§File-name-doesn't-stutter (concat.js, not concat-bytes.js).
§Export-name-carries-the-qualifier (concatBytes, not just
concat).

§kriskowal-on-PR-142: *the exported module names do not
need to stutter 'bytes'. Just the exported names.*

§Reasoning: §at-import-site the qualifier helps reader
identify the package; §at-file-site stutter is redundant.

§Kebab-case-file-names-for-multi-word (from-string.js;
to-string.js); §single-word-files-keep-plain-form
(concat.js; equals.js). §Per-the-project-house-naming-
guide.

## §Module-scoped TextEncoder / TextDecoder

> *Module-scoped `TextEncoder` and `TextDecoder` instances
> are created once at module load and frozen. They are
> passed as captured constants; no globals are read after
> module init.*

§Capture-at-module-load: §no-per-call-allocation;
§captured-before-lockdown-can't-be-defeated-post-lockdown.

§Why-this-matters-for-SES: a globalThis modification after
lockdown can't affect a captured constant. §Closure-over-
captured-bindings is the §defense.

§Cycle-167-where/index.js doesn't have a similar capture
because path-resolution functions take env/info as args.
§Different-substrate-different-pattern.

## §No-input-validation-beyond-primitives (Decision 4)

> *Inputs are not validated beyond what the underlying
> primitives do; passing a non-`Uint8Array` to
> `concatBytes` will fault at the `.length` read or the
> `.set()` call. Adding a `passStyleOf`-style guard would
> add a `@endo/pass-style` dependency to a leaf utility
> package, which we want to avoid.*

§Leaf-utility-stays-leaf. §Don't-add-pass-style-dependency
because it would §inflate-the-dependency-graph for §a-leaf-
package-that-thousands-of-consumers-might-pull-in.

§Let-the-primitives-fault: §.length-on-non-array-is-
undefined; §.set-on-non-array-throws. §Native-errors-are-
informative-enough.

§Cycle-167-where/index.js does the same: §no-input-
validation-beyond-what-the-OS-API-provides.

## §Eight Decisions from PR #142 review

§The-Open-Questions-raised-by-the-original-draft-were-
resolved-during-implementation. §Decisions-recorded-for-
future-readers (not Open-Questions-deferred).

1. §Package-name-`@endo/bytes` (sibling-precedent
   `@endo/base64` + `@endo/hex`).
2. §bytesEqual-binary-not-variadic.
3. §UTF-8-only (no encoding option).
4. §No-re-exports-from-@endo/base64-or-@endo/hex.
5. §Per-module-surface-no-barrel.
6. §Qualified-export-names.
7. §Kebab-case-file-names.
8. §First-release-at-1.0.0 (major changeset bump from
   0.x baseline).

§Open-Questions-resolved-during-implementation is a
§lifecycle-pattern: design doc → implementation PR →
implementation review feedback → recorded as Decisions.
§The-design-doc-evolves-with-the-implementation.

§Cycle-149's-three-open-questions and cycle-170's-seven-
open-questions stayed open; this design's open questions
were *resolved during implementation*. §Implementation-
can-resolve-design-questions when it surfaces concrete
choices.

## §First-release at 1.0.0 (Decision 8)

> *The first release ships as `1.0.0` via a `'@endo/bytes':
> major` changeset entry. The workspace `package.json`
> `version` stays at the `0.1.0` floor; the changeset's
> major bump from a `0.x.y` baseline lands the published
> version at `1.0.0`. This matches the convention recently
> established for fresh utility packages where the first
> published artifact is API-stable from day one and there
> is no `0.x` line to leave behind.*

§First-release-API-stable-from-day-one. §No-0.x-purgatory.

§Why-this-matters: §0.x-versions-signal-instability and
many consumers refuse to depend on them. §Starting-at-
1.0.0-says-the-API-is-deliberately-stable.

§Implemented-via-changeset-major-bump (not by hand-editing
package.json). §Tooling-driven-versioning.

§Synthesis-target: future utility-package designs in Endo
can follow §start-at-1.0.0 pattern.

## §Four-phase migration

| Phase | Content | PR |
|-------|---------|-----|
| 1 | Create `@endo/bytes` package | #142 |
| 2 | Migrate PR 122's three `concatChunks` | Follow-up |
| 3 | Migrate sibling duplicates (cli/ocapn/envelope) | #142 |
| 4 | Migrate TextEncoder/TextDecoder instantiations | #142 |

§PR-#142-shipped-Phases-1-3-4-in-three-commits (scaffold,
implementation, yarn.lock).

§Phase-2-deferred because PR 122 was still in review;
§coordinate-with-still-in-flight-work via §layer-the-
migration or §wait-for-merge.

§The-package-is-shipped-first-and-adopted-incrementally;
§no-call-site-rewrites-are-load-bearing-for-the-package-
itself. §Decoupled-rollout.

## §The §sourced-from-PR-inline-review-comment lifecycle

> Source: [PR 122 inline review comment 3205507716]

§Design-doc-was-spawned-by-a-review-comment. §Reviewer-
flagged-the-triplication; §design-doc-canonicalized-the-
extraction.

§Three-cycle-instances-of-this-lifecycle observed in
prior cycles:
- Cycle 149 (unhandled-rejection-display): Issue + repro PR
- Cycle 157 (exo-zip-package): PR inline comment
- Cycle 161 (filesystem-watchers): standalone Issue

§This-cycle-172 adds a fourth: PR inline comment with
explicit-discussion-id.

§Synthesis-target: §design-spawned-by-review-comment is a
§healthy-design-lifecycle. §Reviewers-can-flag-systemic-
duplication and the response is a §design-doc-that-
canonicalizes-the-extraction.

## §SES-and-hardening considerations

- §Every-export-harden()-ed.
- §Module-scoped-TextEncoder/TextDecoder created once at
  module load.
- §TextEncoder/TextDecoder-available-in-all-target-
  platforms (Node + XS + browser + SES-locked).
- §No-mutable-module-state.
- §No-pass-style-validation (leaf utility).

§Sibling-to-cycle-167's-where-and-cycle-171's-stream in
the §harden-everything-individually discipline. §The-
substrate-files-all-share-this-harden-discipline.

## §Out-of-scope explicit list

§Out-of-scope-explicit:

- Full `Buffer` replacement library (use `buffer/`-shim).
- Hex encoding (use @endo/hex).
- Base64 (use @endo/base64).
- Streaming API (use @endo/stream).
- Async helpers (one-liners over sync helpers).

§Defer-to-sibling-packages discipline. §Each-package-has-
one-concern. §Don't-build-a-mega-package.

§Cycle-167's-where/index.js follows the same shape:
location-resolution is its concern; everything else is
elsewhere.

## §Comparison with sibling utility packages

| Package | Lines | Cycle | Concern |
|---------|-------|-------|---------|
| @endo/where | 115 | 167 | Platform path resolution |
| @endo/stream | 247 | 171 | Async iterator streams |
| @endo/bytes | (small) | 172 | Uint8Array helpers |
| @endo/base64 | (small) | — | Base64 encoding |
| @endo/hex | (small) | — | Hex encoding |

§Family-of-small-focused-utility-packages. §Each-handles-
one-concern.

§Pattern: §minimal-leaf-utility-with-narrow-surface. §No-
peer-deps-when-avoidable.

§Synthesis-target: §when-you-see-duplication-across-the-
monorepo-extract-it-into-a-leaf-utility.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 167 (where/index.js) | §Sibling-utility-package shape (small, focused, foundational) |
| 171 (stream/index.js) | §Sibling-utility-package; this @endo/bytes is leaf, stream is also leaf |
| 157 (exo-zip-package) | §PR-comment-sourced-design lifecycle precedent |
| 149 (unhandled-rejection-display) | §Issue-and-repro-PR-sourced precedent |
| 161 (filesystem-watchers) | §Standalone-Issue-sourced precedent |
| 165 (ocap-kernel platform-specific) | §Cross-platform-portability sibling discipline |

## §Tier-1 vocabulary borrowing candidates

§Maximal-power-minimal-area discipline (audit first,
include only what retires existing duplicates).

§No-barrel-module-per-helper-surface (tree-shaking +
audit-friendly).

§Qualified-export-names (concat.js → concatBytes; file
name doesn't stutter, export carries qualifier).

§Module-scoped-TextEncoder/TextDecoder (capture-at-module-
load; no per-call allocation).

§First-release-at-1.0.0 (no 0.x purgatory for new utility
packages).

§Open-Questions-resolved-during-implementation (design
doc evolves with implementation review).

§Sourced-from-PR-inline-review-comment as a §design-
lifecycle.

§Tier-2: §helper-rationale-table-with-existing-duplicates-
counts (audit-driven inclusion).

## §Synthesis-target

When the garden grows a utility package to retire
duplication, follow this design's pattern:

1. Audit existing duplicates with counts.
2. Apply §maximal-power-minimal-area.
3. Per-helper-surface, no barrel.
4. Qualified export names.
5. Module-scoped captured globals.
6. No peer deps unless absolutely required.
7. Start at 1.0.0.
8. Resolve Open Questions during implementation.

§Slot machine library will likely need similar leaf-
utility packages. §Reuse-this-pattern.

## §A complete design (Status: Implemented)

§Status-Implemented (via PR #142). §The-design-is-not-
speculative; §the-implementation-validated-the-shape.
§The-eight-Decisions-record-what-was-learned-during-
implementation.

§Sibling-to-cycle-168-daemon-checkin-checkout (also
Status: Complete; design + implementation pair).
§Complete-designs-are-the-archive of validated
disciplines.
