---
title: §Three-option-mapper-implementation with §shell-out-to-Node-rejected
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

For Form 3 (entry-point module), the design needs to run §the-compartment-mapper to discover dependencies, resolve modules, and build the archive. §Three options enumerated:

### Option A: §Rust-native mapper (preferred for long term)

> Implement module resolution and dependency walking in Rust. This avoids depending on Node.js for the build step.

§Named-future-direction. The mapper needs: JavaScript parser for `import`/`require` extraction (or simpler regex-based heuristic for static imports), `package.json` reading and `exports`/`main` resolution, registry table for package resolution.

### Option B: §XS-hosted mapper (preferred for near term — CHOSEN)

> Run the compartment mapper itself inside an XS machine. The mapper is JavaScript — it can execute in XS with filesystem host functions.
>
> The flow: create an XS machine with fs powers, load the compartment mapper bundle, invoke `mapNodeModules()`, get back a `CompartmentMap`, then ingest sources into the CAS.
>
> This reuses the existing well-tested mapper code with minimal new Rust code. The cost is a startup latency for the mapper machine, but this is a one-time cost per `endor run` invocation.

§Reuse-battle-tested-@endo/compartment-mapper-via-running-it-inside-XS. §Sibling-pattern to cycle 200 worker-rust-xs's §host-compartment-vs-guest-compartment-split (in worker-rust-xs, the host compartment has cap-std powers for guest evaluation; here, the host XS machine has fs powers for mapper execution).

§Two-phase-flow named explicitly: §map-in-XS-then-execute-in-fresh-XS. §The-mapper-XS-machine ingests sources into the CAS during mapping; §the-execute-XS-machine then runs the program with CAS-backed module loading.

§Startup-latency-cost-acknowledged-but-amortized: §one-time-cost-per-endor-run-invocation. §Honest-cost-disclosure.

### Option C: §Shell-out-to-Node — REJECTED

> Use `node -e "..."` to run the compartment mapper. **This defeats the purpose of `endor run` being self-contained. Rejected.**

§Self-contained-as-a-design-axiom — the entire `endor` binary should not depend on Node.js at runtime. §Shell-out-to-Node would §defeat-the-purpose.

§Borrowable-pattern: §three-option-implementation-with-shell-out-rejected when §self-contained-binary is a §named-design-axiom.

§Sibling-pattern: cycle 200 worker-rust-xs's §XS-over-V8 for engine choice — both designs explicitly reject Node.js dependencies in the deployment target. §Cycle-200 names Compartment as the decisive factor; §cycle-202 names self-containedness as the decisive factor.
