---
title: §Two-phase-flow named explicitly
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

> The flow: create an XS machine with fs powers, load the compartment mapper bundle, invoke `mapNodeModules()`, get back a `CompartmentMap`, then ingest sources into the CAS.

§Phase-A: §map-in-XS — create mapper machine with fs powers; invoke `mapNodeModules()`; get `CompartmentMap` + ingest sources into CAS.
§Phase-B: §execute-in-fresh-XS — separate XS machine for actual execution; reads from CAS by hash.

§Two-machines-not-one: §the-mapper-and-the-executor-are-distinct-XS-instances. §Mapping-runs-with-fs-powers; §execution-runs-with-CAS-backed-loading-only.

§Capability-discipline-applied-to-the-build-pipeline. §Sibling-pattern to cycle 200 worker-rust-xs's §host-compartment-vs-guest-compartment-split — same architectural discipline at different layers (build vs runtime).

§Borrowable-pattern: §two-machines-not-one for §build-and-run-as-distinct-capability-scopes.
