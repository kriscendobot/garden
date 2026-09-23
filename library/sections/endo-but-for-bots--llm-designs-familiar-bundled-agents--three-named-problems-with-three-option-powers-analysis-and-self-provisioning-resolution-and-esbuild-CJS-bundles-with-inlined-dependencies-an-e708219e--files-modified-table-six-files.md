---
title: §Files-Modified table — six files with §named-change-per-file
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

| File | Change |
| --- | --- |
| `packages/familiar/scripts/bundle.mjs` | Add `endo-lal.cjs` and `endo-fae.cjs` esbuild entries |
| `packages/familiar/src/resource-paths.js` | Add `endoLalPath`, `endoFaePath` |
| `packages/familiar/src/daemon-manager.js` | Pass `ENDO_LAL_PATH`, `ENDO_FAE_PATH` env vars |
| `packages/daemon/src/daemon-node.js` | Register @lal/@fae special formulas; auto-incarnate on startup |
| `packages/daemon/src/types.d.ts` | No changes (Specials type is already generic) |
| `packages/lal/agent.js` | Detect @endo powers and self-provision (or coordinate with form-provisioning) |
| `packages/fae/agent.js` | Same as lal/agent.js |

§Greppable-shopping-list for §the-implementer. §The-`No changes`-row for `types.d.ts` is §honest-acknowledgment that §Specials-type-is-already-generic. §Sibling-pattern to cycle 204 weblet-next's §Removed-Files-table — both designs §enumerate-files-as-change-list-with-roles, but at opposite lifecycle ends (cycle 204 enumerates files removed; cycle 208 enumerates files changed).

§Borrowable-pattern: §Files-Modified-table-with-named-change-per-file for §implementation-ready-designs.
