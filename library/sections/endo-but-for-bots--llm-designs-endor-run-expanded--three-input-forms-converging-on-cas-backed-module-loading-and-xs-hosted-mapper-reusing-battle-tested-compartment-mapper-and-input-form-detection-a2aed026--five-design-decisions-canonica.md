---
title: §Five Design Decisions canonical format
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

1. **§CAS-as-the-universal-backing-store** — all three input forms converge on the same CAS-backed module loading path; the runtime behavior is identical regardless of input form; only the ingestion differs.
2. **§Lazy-module-loading-from-CAS** — large applications may have thousands of modules but only import a fraction at runtime; fetching bytes on demand avoids loading unused modules into memory.
3. **§XS-hosted-compartment-mapper (near term)** — reuses the battle-tested `@endo/compartment-mapper` JavaScript code; the alternative (Rust-native mapper) is a large undertaking that duplicates well-tested logic; the XS-hosted approach has ~100ms startup overhead for the mapper machine — acceptable for a CLI tool.
4. **§Standalone-CAS-for-`endor run`** — when no daemon is running, `endor run` creates a local CAS in a temp directory; this avoids coupling `endor run` to the daemon lifecycle while still enabling CAS deduplication and caching when the daemon is present.
5. **§Input-form-detection-by-file-type-not-flags** — `endor run foo` examines `foo` to determine the form; explicit `--zip`, `--dir`, `--entry` flags are available for disambiguation but rarely needed.

§Five-Design-Decisions canonical format (sibling to cycles 184/188/192/194/196/198/200-hardened-url-shim/200-worker-rust-xs). §Each-decision-names-the-rationale and §the-trade-off.

§Decision-3-§"acceptable-for-a-CLI-tool" is §a-named-acceptance-of-startup-latency for §the-CLI-form-factor. §The-form-factor-context shapes the acceptable trade-off.
