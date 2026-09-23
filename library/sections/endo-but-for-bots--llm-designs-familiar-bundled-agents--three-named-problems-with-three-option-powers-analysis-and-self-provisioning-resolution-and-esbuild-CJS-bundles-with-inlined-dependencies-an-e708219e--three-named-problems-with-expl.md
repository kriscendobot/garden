---
title: §Three-named-problems with §explicit-user-facing-pain
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

> 1. **Requires the source tree.** The Familiar is a self-contained Electron app. End users who install it from a `.dmg` or `.zip` do not have the monorepo checkout, so they cannot run setup scripts.
>
> 2. **Requires `node_modules`.** The agent caplets use `import()` with bare specifiers (`@anthropic-ai/sdk`, `openai`, `ollama`). Node.js resolves these via `node_modules` lookup from the agent file's directory. In the packaged Familiar, there is no `node_modules` tree for agent code.
>
> 3. **No integrated first-run experience.** A user launches the Familiar for the first time and sees an empty inbox with no agents.

§Three-numbered-problems each with §explicit-user-facing-pain — §named-installation-form (.dmg/.zip), §named-module-resolution-failure-mode (bare specifiers), §named-first-run-pain (empty inbox).

§Sibling-pattern to cycle 200 worker-rust-xs's §three-numbered-problems each with named defense and cycle 196 endoclaw's §three-named-attacks paired with §three-structural-defenses — §problem-defense-enumeration as §canonical-Problem-section-shape.
