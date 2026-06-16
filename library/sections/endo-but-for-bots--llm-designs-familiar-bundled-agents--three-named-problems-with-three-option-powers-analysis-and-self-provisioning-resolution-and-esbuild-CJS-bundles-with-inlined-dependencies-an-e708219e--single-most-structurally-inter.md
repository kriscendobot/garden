---
title: Single most structurally interesting move
source: endo-but-for-bots designs/familiar-bundled-agents.md
source-slug: endo-but-for-bots--llm-designs-familiar-bundled-agents
ingest-cycle: 208
ingest-date: 2026-06-06
lane: designs
status: Complete (2026-03-02 created; 2026-03-05 updated)
author: Kris Kowal (prompted)
related:
  - endo-but-for-bots--llm-designs-familiar-daemon-bundling (esbuild infrastructure this design extends)
  - endo-but-for-bots--llm-designs-lal-fae-form-provisioning (complementary form-based configuration flow)
  - endo-but-for-bots--llm-designs-familiar-electron-shell (Familiar architecture including resource paths)
  - endo-but-for-bots--llm-designs-daemon-form-request (form primitives used for agent configuration)
  - endo-but-for-bots--llm-designs-weblet-next (cycle 204; the §specials-extension-point pattern this design reuses)
  - endo-but-for-bots--llm-designs-endopi (cycle 121; sibling agent-shape comparison; Lal and Fae are referenced)
keywords:
  - three-named-problems with explicit user-facing pain
  - Current-Architecture section showing what already exists
  - Dependency-Analysis table with conclusion no-binary-dependencies-need-replacement
  - SES-Compatibility section with CLAUDE.md quoted constraint
  - The-Powers-Problem with three-option analysis
  - Option A self-provisioning (with three named reasons for acceptability)
  - Option B separate setup formula (rejected — Specials mechanism doesn't support inter-formula deps)
  - Option C hardcoded provisioning (rejected — mixes agent provisioning into daemon entry)
  - brief-bootstrap-window-with-full-authority-acceptable
  - voluntarily-drops-to-guest-level-authority
  - environment-variable-gating for dev-vs-packaged asymmetry
  - auto-incarnation mirroring @apps pattern
  - idempotent provisioning (provideGuest returns existing)
  - seven Design Decisions canonical format
  - four Implementation Phases
  - Files-Modified-table with named change per file
  - Two-Dependencies + Four-Related-Designs
  - complementary-to-sibling-design (form-provisioning composition)
  - esbuild CJS bundles with inlined dependencies (no node_modules at runtime)
  - all three LLM provider SDKs are pure JavaScript HTTP clients
  - the specials mechanism extension-point (reuses @apps pattern)
  - cycle 208 designs-lane
  - forty-second consecutive designs/chat alternation cycle 166-208
parent: endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-and-env-var-gating-for-dev-vs-packaged-asymmetry
---

§The-Powers-Problem-with-three-option-analysis: §the-Specials-mechanism gives bundled-agent formulas §@endo-level-powers (full daemon access), but §agent-caplets-should-run-under-a-guest-profile-with-limited-authority. §Three-options-enumerated each with §named-drawbacks-and-benefits, §resolved-to-Option-A (§self-provisioning-from-@endo-to-guest) with §three-named-reasons-for-acceptability of the §brief-bootstrap-window-with-full-authority.

§The-design-encodes-a-trust-boundary-trade-off: §the-agent-receives-@endo-powers-and-voluntarily-drops-to-guest-level-authority. §The-three-acceptability-reasons-named: (1) §the-agent-code-is-bundled-and-shipped-by-us-not-user-provided; (2) §the-@apps-formula-already-has-this-pattern; (3) §the-agent-voluntarily-drops-immediately.

§Sibling-pattern to cycle 200 worker-rust-xs's §host-compartment-vs-guest-compartment-split — both designs §isolate-guest-code-from-host-authority. §Cycle-200-uses-engine-level-enforcement; §cycle-208-uses-self-provisioning-with-named-trust-assumption.
