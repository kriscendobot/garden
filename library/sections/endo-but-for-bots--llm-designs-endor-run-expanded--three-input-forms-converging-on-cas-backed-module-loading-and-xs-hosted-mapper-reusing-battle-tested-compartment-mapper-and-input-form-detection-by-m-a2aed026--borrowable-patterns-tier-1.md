---
title: §Borrowable patterns (tier-1)
source: endo-but-for-bots designs/endor-run-expanded.md
source-slug: endo-but-for-bots--llm-designs-endor-run-expanded
ingest-cycle: 202
ingest-date: 2026-06-06
lane: designs
status: In Progress (2026-04-17; Phases 1-2 shipped; Phases 3-5 remaining)
author: Kris Kowal (prompted)
related:
  - endo-but-for-bots--llm-designs-daemon-cas-management (Requires: ContentStore for blob/tree storage, retain/release)
  - endo-but-for-bots--llm-designs-endor-npm-registry-proxy (Enables: Form 3 package resolution without node_modules)
  - endo-but-for-bots--llm-designs-daemon-endor-architecture (cycle 176; Extends: `endor run` becomes CAS-aware)
  - endo-but-for-bots--llm-designs-worker-rust-xs (cycle 200; foundational predecessor design — `endor run` is a CLI surface on top of this worker)
  - endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot (cycle 178; CAS-streaming snapshot is the §sibling-CAS-integration at a different layer)
  - endo--packages-compartment-mapper (the JS library that the XS-hosted mapper reuses)
  - endo--packages-immutable-arraybuffer (cycle 201; §by-copy-network-protocol kinship — CAS blobs are also bulk-data-by-hash-not-by-reference)
keywords:
  - three-input-forms-converging-on-one-runtime-path
  - input-form-detection-by-magic-bytes-not-flags (PK\x03\x04 ZIP magic)
  - three-option-mapper-implementation (Rust-native / XS-hosted / shell-out-to-Node)
  - shell-out-to-Node rejected ("defeats the purpose")
  - XS-hosted-mapper reuses battle-tested @endo/compartment-mapper
  - lazy-module-loading-from-CAS by hash on demand
  - five Design Decisions canonical format
  - five Implementation Phases with named test cases per phase
  - Phases-1-2-shipped-with-code-paths-named (cas_archive.rs / ingest_archive / load_archive_from_cas)
  - Phases-3-5-remaining
  - root-hash-printed-to-stderr-for-re-run
  - --no-cas-fallback-for-read-only-filesystems
  - standalone-CAS-when-no-daemon (temp directory)
  - --cas-dir flag for non-default CAS location
  - three-dependencies-with-named-relationship (Requires / Enables / Extends)
  - CAS-as-universal-backing-store
  - two-phase-flow (map-in-XS-then-execute-in-fresh-XS)
  - mapper-runs-in-XS-with-fs-powers
  - Status-section-with-completed-phases-and-remaining-phases
  - cycle 202 designs-lane
  - thirty-sixth consecutive designs/chat alternation cycle 166-202
parent: endo-but-for-bots--llm-designs-endor-run-expanded--three-input-forms-converging-on-cas-backed-module-loading-and-xs-hosted-mapper-reusing-battle-tested-compartment-mapper-and-input-form-detection-by-magic-bytes-not-flags
---

1. **§Three-input-forms-converging-on-one-runtime-path** — multiple input shapes share an ingestion-then-runtime split; only ingestion differs.
2. **§Input-form-detection-by-magic-bytes-not-flags** (PK\x03\x04 ZIP magic, compartment-map.json presence) + §explicit-flags-available-but-rarely-needed for §power-user-disambiguation.
3. **§Three-option-implementation-with-rejected-option-named** ("shell-out-to-Node defeats the purpose"); §each-option-has-named-rationale + §the-rejected-option-names-its-failure-mode.
4. **§Reuse-battle-tested-code-via-running-it-inside-the-target-engine** (XS-hosted @endo/compartment-mapper) instead of porting it (Rust-native).
5. **§Two-phase-flow** (map-in-XS-then-execute-in-fresh-XS) as §two-machines-not-one for §build-and-run-as-distinct-capability-scopes.
6. **§Lazy-module-loading-from-CAS-by-hash-on-demand** — fetch bytes on demand for large applications where only a fraction of modules are imported at runtime.
7. **§Root-hash-printed-to-stderr-for-re-run** — `endor[run]: archive root sha256:abc123...` enables `endor run --cas sha256:abc123...`; §expensive-ingestion-with-cheap-retrieval; §the-hash-becomes-the-handle.
8. **§Standalone-mode-when-no-daemon** — CLI tool creates local CAS in temp dir; doesn't couple to daemon lifecycle; benefits from daemon when present.
9. **§Backward-compatibility-via-flag** (`--no-cas`) with §named-use-case (read-only filesystems); §the-default-is-the-new-behavior; §opt-out-restores-legacy.
10. **§Status-section-with-completed-phases-and-code-paths-named** — `Phase 2: rust/endo/src/cas_archive.rs — ingest_archive extracts ZIP contents into CAS...` for §multi-phase-designs in §In-Progress-state.
11. **§Five-Design-Decisions canonical format** with §each-decision-names-the-rationale-and-trade-off.
12. **§Five-Implementation-Phases each with named-test-cases-per-phase** as §greppable-completion-criteria.
13. **§Three-dependencies-with-named-relationship-types** (Requires / Enables / Extends) for §multi-design-context with §named-coupling-strengths.
14. **§Four-CLI-options with named-defaults** symmetric across §three-input-shapes (hash / directory / file).
15. **§Self-contained-binary as a named-design-axiom** — rejected shell-out-to-Node "defeats the purpose of being self-contained".
16. **§Honest-cost-disclosure** ("~100ms startup overhead for the mapper machine — acceptable for a CLI tool") with §form-factor-context for the acceptable trade-off.
