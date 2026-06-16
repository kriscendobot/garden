---
title: §The-Powers-Problem — three-option analysis
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

### §The-tension-named

> The `Specials` mechanism maps a name to a formula that is `preformulate`d during daemon initialization — before the root host, pet stores, or guest profiles exist. Special formulas have access to `Builtins` (`@new`, `@main`, `@endo`) but not to host-level powers like `provideGuest`.
>
> The @apps formula works because the web server needs root-level access (it serves all agents). Agent caplets, however, should run under a guest profile with limited authority.

§The-tension: §Specials-run-too-early to use host-level powers, §but-agents-need-host-level-provisioning-to-get-guest-powers. §Three-options-enumerated:

### Option A: §Self-provisioning (CHOSEN)

```js
export const make = async (endoPowers) => {
  const host = await E(endoPowers).host();
  const guest = await E(host).provideGuest('lal', {
    introducedNames: {},
    agentName: 'profile-for-lal',
  });
  // Now operate using guest powers...
};
```

§The-agent-briefly-has-root-access. §Drawback-named: §a-bug-in-the-bootstrap-sequence-could-accidentally-exercise-root-powers. §Benefit-named: §self-contained, §no-changes-to-Specials-mechanism, §follows-existing-@apps-pattern.

### Option B: §Setup-as-separate-special-formula (REJECTED)

§Two-special-formulas-per-agent: one-shot setup formula + agent formula. §Drawback-named: §complex; §Specials-mechanism-does-not-support-inter-formula-dependencies.

### Option C: §Hardcoded-guest-provisioning-in-the-daemon (REJECTED)

§Guest-provisioning-logic-in-daemon-node.js (after host created but before signalling "ready"). §Drawback-named: §mixes-agent-provisioning-concerns-into-the-daemon-node-entry-point. §Benefit-named: §the-agent-runs-with-proper-guest-level-authority-from-the-start.

### §Resolution: Option A with §three-named-reasons

> The brief bootstrap window with full authority is acceptable because:
> 1. The agent code is bundled and shipped by us, not user-provided.
> 2. The @apps formula already has this pattern and has worked without issues.
> 3. The agent voluntarily drops to guest-level authority immediately.

§Three-named-reasons making §the-bootstrap-window-explicitly-acceptable. §Sibling-pattern to cycle 197 panic's §"no-further-loss-in-security"-argument — both designs §argue-acceptability-via-named-mitigating-factors.

§Borrowable-pattern: §three-option-analysis with §named-drawbacks-and-benefits-per-option + §resolution-with-named-reasons-for-acceptability for §design-decisions-that-trade-off-security-against-simplicity.
