---
title: §three-named-problems-with-explicit-user-facing-pain (no-source-tree + no-node_modules + no-integrated-first-run-experience) + §Current-Architecture-section-showing-what-already-exists + §Dependency-Analysis-table-with-conclusion-no-binary-dependencies-need-replacement + §SES-Compatibility-section-with-CLAUDE.md-quoted-constraint + §The-Powers-Problem-with-three-option-analysis-(A-self-provisioning-B-separate-setup-formula-C-hardcoded-provisioning)-resolved-to-Option-A-with-three-named-reasons + §brief-bootstrap-window-with-full-authority-acceptable-with-three-reasons + §environment-variable-gating-for-dev-vs-packaged-asymmetry + §auto-incarnation-mirroring-@apps-pattern + §idempotent-provisioning + §seven-Design-Decisions-canonical-format + §complementary-to-sibling-design-form-provisioning + §Files-Modified-table-with-named-change-per-file — endo-but-for-bots designs/familiar-bundled-agents.md
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
kind: index
section_count: 18
---

Sections:

- [Source](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-and-env-var-gating-for-dev-e708219e--source.md)
- [Single most structurally interesting move](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-an-e708219e--single-most-structurally-inter.md)
- [§Three-named-problems with §explicit-user-facing-pain](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-an-e708219e--three-named-problems-with-expl.md)
- [§Current-Architecture section — what already exists](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-an-e708219e--current-architecture-section-w.md)
- [§Dependency-Analysis table with §named-conclusion](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-an-e708219e--dependency-analysis-table-with.md)
- [§SES-Compatibility section with §CLAUDE.md quoted constraint](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-an-e708219e--ses-compatibility-section-with.md)
- [§The-Powers-Problem — three-option analysis](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-an-e708219e--the-powers-problem-three-optio.md)
- [§Environment-variable-gating for dev-vs-packaged asymmetry](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-an-e708219e--environment-variable-gating-fo.md)
- [§Auto-incarnation mirroring @apps pattern](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-an-e708219e--auto-incarnation-mirroring-app.md)
- [§First-Run-Experience section — six-step user journey](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-an-e708219e--first-run-experience-section-s.md)
- [§Interaction-with-Form-Based-Provisioning — complementary-to-sibling-design](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-an-e708219e--interaction-with-form-based-pr.md)
- [§Seven Design Decisions canonical format](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-an-e708219e--seven-design-decisions-canonic.md)
- [§Four Implementation Phases](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-and-en-e708219e--four-implementation-phases.md)
- [§Files-Modified table — six files with §named-change-per-file](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-an-e708219e--files-modified-table-six-files.md)
- [§Two Dependencies + §Four Related Designs](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-and-e708219e--two-dependencies-four-related.md)
- [§Borrowable patterns (tier-1)](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-and-en-e708219e--borrowable-patterns-tier-1.md)
- [§Synthesis-target](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-and-env-var-gati-e708219e--synthesis-target.md)
- [§Cycle 208 meta-observations](endo-but-for-bots--llm-designs-familiar-bundled-agents--three-named-problems-with-three-option-powers-analysis-and-self-provisioning-resolution-and-esbuild-CJS-bundles-with-inlined-dependencies-and-e-e708219e--cycle-208-meta-observations.md)
