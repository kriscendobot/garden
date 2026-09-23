---
title: §Borrowable patterns (tier-1)
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

1. **§Three-named-problems-with-explicit-user-facing-pain** as §canonical-Problem-section-shape.
2. **§Current-Architecture-section-before-Design-section** as §design-discipline that prevents §reinventing-existing-mechanisms.
3. **§Dependency-Analysis-table-with-named-conclusion** for §packaging-or-bundling-designs that need to address §the-binary-dependency-question.
4. **§SES-Compatibility-section-with-CLAUDE.md-quoted-constraint** for §packaging-designs-that-must-comply-with-architectural-axioms.
5. **§The-Powers-Problem-with-three-option-analysis** + §named-drawbacks-and-benefits-per-option + §resolution-with-named-reasons-for-acceptability for §design-decisions-that-trade-off-security-against-simplicity.
6. **§Self-provisioning-from-@endo-powers-to-guest-powers** as §a-trust-boundary-trade-off pattern.
7. **§Brief-bootstrap-window-with-full-authority-acceptable** with §three-named-mitigating-factors.
8. **§Environment-variable-gating-for-dev-vs-packaged-asymmetry** with §empty-string-as-not-set-discipline.
9. **§Auto-incarnation-mirroring-@apps-pattern** when extending §an-existing-extension-point.
10. **§First-Run-Experience-section-as-explicit-user-journey** for §packaging-or-installer-designs.
11. **§Interaction-with-sibling-design-section** + §explicit-composition-narrative for §designs-that-compose-without-strictly-depending-on-each-other.
12. **§Seven-Design-Decisions canonical format** with §each-decision-names-the-alternative-or-rationale.
13. **§Four-Implementation-Phases** with §named-test-criteria-per-phase + §named-overlap-with-sibling-design.
14. **§Files-Modified-table-with-named-change-per-file** for §implementation-ready-designs (sibling to cycle 204 weblet-next's §Removed-Files-table at opposite lifecycle end).
15. **§Idempotent-provisioning** — `provideGuest` returns existing guest on subsequent launches.
16. **§Specials-mechanism-extension-point** as §canonical-shape for §platform-specific-formula-injection (this design reuses what cycle 204 weblet-next's §the-`specials`-extension-point pattern named).
