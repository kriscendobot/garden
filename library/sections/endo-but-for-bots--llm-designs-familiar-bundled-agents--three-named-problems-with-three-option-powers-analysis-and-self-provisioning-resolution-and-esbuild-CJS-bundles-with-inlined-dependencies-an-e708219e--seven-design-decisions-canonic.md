---
title: §Seven Design Decisions canonical format
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

1. **§esbuild-CJS-bundles** — same approach as daemon and worker bundles; single-file with inlined dependencies; no node_modules at runtime.
2. **§No-native-dependencies-to-replace** — all three LLM provider SDKs and all @endo/* packages are pure JS; agents bundle cleanly.
3. **§Special-formulas-via-Specials-mechanism** — reuses existing pattern from @apps; no new daemon infrastructure.
4. **§@endo-powers-with-self-provisioning** — agent receives full daemon access initially and voluntarily drops to guest-level; parallels @apps and avoids Specials-mechanism changes.
5. **§Environment-variable-gating** — @lal/@fae specials only registered when ENDO_LAL_PATH/ENDO_FAE_PATH set; in dev mode, agents installed via CLI as today; in packaged mode, they auto-register.
6. **§Auto-incarnation-on-startup** — agents start automatically on fresh daemon state; enables immediate first-run experience.
7. **§Complementary-to-form-provisioning** — this design provides delivery; form-provisioning provides configuration; together they produce complete out-of-the-box experience.

§Seven-Design-Decisions canonical format (sibling to cycles 184/188/192/194/196/198/200x2/202/203/204/206). §Each-decision-names-the-alternative-or-rationale.
