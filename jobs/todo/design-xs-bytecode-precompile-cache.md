---
role: designer
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-06T14:56:05Z cleared=none -->

Design: bytecode precompile & content-addressed cache for XS — C and Rust engines.

GATE: blocked on endojs/endo-but-for-bots#600 (xs2rust-endor-engine — port XS to
Rust for endor). Auto-promoted when #600 merges.

Maintainer's premise (2026-07-25): both the C XS engine and the Rust XS engine
(#600) contain the machinery necessary to PRECOMPILE and/or CACHE byte code
compiled from a JavaScript source, KEYED ON A HASH of the source. Produce a design
covering BOTH implementations:
  - Where each engine exposes bytecode compile + load (C XS: its byte-code
    archive/mod machinery; Rust XS: the #600 port's equivalent surface).
  - A content-addressed cache keyed on a hash of the JS source: define the key
    precisely (raw source bytes vs normalized; must it fold in engine build /
    bytecode-format version so a stale entry can't be mis-loaded?).
  - Precompile-ahead vs lazy compile-then-cache; cache location, population,
    invalidation, and eviction.
  - Cross-engine key compatibility: can a C-XS cache entry be reused by Rust XS,
    or are keys engine/format-namespaced? State the invariant.
  - Integration points in endo-but-for-bots / endor.
Deliverable: a design doc (designer role) proposing the precompile+cache design
across both engines, with open questions surfaced. No implementation.

<!-- garden-annotation: key=ironhorse-modulesource-cache-contract-20260729 by=liaison at=2026-07-29T22:52:35Z -->

Maintainer amendment (2026-07-29): use the settled architecture vocabulary throughout: XS is the existing engine; Ironhorse is the new Rust engine; Endor is the platform binding that embeds an engine and owns the cache integration. Do not use C-XS, Rust XS, or xs2rust as current-facing names except immutable historical provenance. Make @endo/module-source internals an explicit design input and identify the stable source-analysis/compilation seam Endor should consume. Prefer a documented serializable intermediate contract over coupling Endor or Ironhorse to undocumented in-memory object layouts; if existing ModuleSource internals are insufficient, specify the minimal API/internal refactor required. Define cache identity over exact source bytes plus all compilation-relevant language/options and engine bytecode-format/build version. Preserve a common content/source identity while namespacing compiled payloads by engine and format: an XS artifact must never be loaded as Ironhorse bytecode or vice versa unless an explicitly proven shared format exists. Cover ahead-of-time and lazy population through archives, mounts, and CAS-backed module trees; invalidation, corruption detection, eviction, concurrent writers, and deterministic fallback to source compilation. Reconcile this design with daemon-make-archive and daemon-worker-import-from-mount, explaining how their source-only contract evolves without making portable archives depend on one engine bytecode format.
