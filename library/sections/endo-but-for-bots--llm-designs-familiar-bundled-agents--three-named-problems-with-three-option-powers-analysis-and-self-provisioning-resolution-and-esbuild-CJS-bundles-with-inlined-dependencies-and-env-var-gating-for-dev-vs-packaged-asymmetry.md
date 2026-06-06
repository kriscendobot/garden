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
---

# familiar-bundled-agents — §three-named-problems + §The-Powers-Problem with §three-option-analysis + §self-provisioning-resolution + §esbuild-CJS-bundles + §env-var-gating + §auto-incarnation-mirroring-@apps

## Source

- `endo-but-for-bots designs/familiar-bundled-agents.md` — 618 lines
- Status: **Complete** (created 2026-03-02; updated 2026-03-05)
- Author: Kris Kowal (prompted)
- Cycle 208 of `/loop resume the librarian work.` (designs-lane; alternates from cycle 207's chat-lane @endo/env-options; §forty-second consecutive designs/chat alternation cycle 166-208)

## Single most structurally interesting move

§The-Powers-Problem-with-three-option-analysis: §the-Specials-mechanism gives bundled-agent formulas §@endo-level-powers (full daemon access), but §agent-caplets-should-run-under-a-guest-profile-with-limited-authority. §Three-options-enumerated each with §named-drawbacks-and-benefits, §resolved-to-Option-A (§self-provisioning-from-@endo-to-guest) with §three-named-reasons-for-acceptability of the §brief-bootstrap-window-with-full-authority.

§The-design-encodes-a-trust-boundary-trade-off: §the-agent-receives-@endo-powers-and-voluntarily-drops-to-guest-level-authority. §The-three-acceptability-reasons-named: (1) §the-agent-code-is-bundled-and-shipped-by-us-not-user-provided; (2) §the-@apps-formula-already-has-this-pattern; (3) §the-agent-voluntarily-drops-immediately.

§Sibling-pattern to cycle 200 worker-rust-xs's §host-compartment-vs-guest-compartment-split — both designs §isolate-guest-code-from-host-authority. §Cycle-200-uses-engine-level-enforcement; §cycle-208-uses-self-provisioning-with-named-trust-assumption.

## §Three-named-problems with §explicit-user-facing-pain

> 1. **Requires the source tree.** The Familiar is a self-contained Electron app. End users who install it from a `.dmg` or `.zip` do not have the monorepo checkout, so they cannot run setup scripts.
>
> 2. **Requires `node_modules`.** The agent caplets use `import()` with bare specifiers (`@anthropic-ai/sdk`, `openai`, `ollama`). Node.js resolves these via `node_modules` lookup from the agent file's directory. In the packaged Familiar, there is no `node_modules` tree for agent code.
>
> 3. **No integrated first-run experience.** A user launches the Familiar for the first time and sees an empty inbox with no agents.

§Three-numbered-problems each with §explicit-user-facing-pain — §named-installation-form (.dmg/.zip), §named-module-resolution-failure-mode (bare specifiers), §named-first-run-pain (empty inbox).

§Sibling-pattern to cycle 200 worker-rust-xs's §three-numbered-problems each with named defense and cycle 196 endoclaw's §three-named-attacks paired with §three-structural-defenses — §problem-defense-enumeration as §canonical-Problem-section-shape.

## §Current-Architecture section — what already exists

§A-distinct-design-section that documents the §status-quo before proposing changes. §Three-subsections:
1. **§How-the-daemon-bundles-work-today** — esbuild produces four CJS bundles (endo-daemon / endo-worker / worker-node / endo-cli) + one compartment-mapper bundle (web-page-bundle); §daemon-manager spawns the daemon with environment variables redirecting built-in formulas to the bundled files.
2. **§How-caplets-are-loaded** — daemon's `makeUnconfined` stores formula with `specifier` URL; worker does `await import(specifierUrl); return namespace.make(powersP, contextP, { env });`; bare imports resolve via standard node_modules lookup.
3. **§How-the-@apps-formula-works** — `Specials` parameter map names to factory functions; @apps formula in daemon-node.js; `preformulate`d during daemon initialization; each special becomes a `platformName` in the root host's special names.

§This-is-the-same-mechanism-we-will-use-for-bundled-agents — §explicit-reuse-of-existing-extension-point.

§Borrowable-pattern: §Current-Architecture-section-before-Design-section as §design-discipline that prevents §reinventing-existing-mechanisms.

## §Dependency-Analysis table with §named-conclusion

| Package | Type | Notes |
| --- | --- | --- |
| `@anthropic-ai/sdk` | Pure JS | HTTP client using `fetch` / `node:http` |
| `openai` | Pure JS | HTTP client using `fetch` / `node:http` |
| `ollama` | Pure JS | HTTP client using `fetch` / `node:http` |

> **Conclusion: No binary dependencies need replacement.** The agents can be bundled as-is.

§Three-LLM-provider-SDKs-each-pure-JavaScript-HTTP-client. §The-explicit-conclusion-bolded-in-source removes §the-unspoken-question §"what-about-native-modules?" with §a-direct-answer.

§Borrowable-pattern: §Dependency-Analysis-table-with-named-conclusion for §packaging-or-bundling-designs that need to address §the-binary-dependency-question.

§The-bufferutil-and-utf-8-validate-aside is §honest-acknowledgement of §optional-WebSocket-dependencies already marked external; §they-are-not-a-factor for agent caplets.

## §SES-Compatibility section with §CLAUDE.md quoted constraint

> Unconfined plugins (e.g., `web-server-node.js`) run inside an already-locked-down worker and must **not** import `ses` or `@endo/init` themselves; doing so causes double-lockdown errors.

§The-CLAUDE.md-constraint quoted verbatim. §Then-the-section-verifies the agents comply: §Lal-and-Fae-do-not-import-`ses`-or-`@endo/init`; §the-esbuild-`import.meta.url`-plugin-handles-transitive-cases.

§Borrowable-pattern: §SES-Compatibility-section-with-CLAUDE.md-quoted-constraint for §packaging-designs-that-must-comply-with-architectural-axioms.

§Sibling-pattern to cycle 183 init+lockdown's §NOTE-TO-REVIEWERS pattern — both designs §preserve-architectural-constraints-as-readable-prose.

## §The-Powers-Problem — three-option analysis

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

## §Environment-variable-gating for dev-vs-packaged asymmetry

```js
if (process.env.ENDO_LAL_PATH) {
  specials['@lal'] = ({ '@main': MAIN, '@endo': ENDO }) => ({
    type: 'make-unconfined',
    worker: MAIN,
    powers: ENDO,
    specifier: process.env.ENDO_LAL_PATH,
    env: {},
  });
}
```

§Specials-only-registered-when-env-vars-set. §In-dev-mode the env vars are empty strings → §agents-not-registered → §user-installs-via-CLI-as-today. §In-packaged-mode env vars point to bundled `.cjs` files → §agents-auto-register → §immediate-first-run-experience.

§Borrowable-pattern: §environment-variable-gating-for-dev-vs-packaged-asymmetry for §designs-that-need-different-behavior-by-deployment-shape with §empty-string-as-not-set-discipline.

§Sibling-pattern to cycle 207 env-options — §env-variable-as-deployment-knob discipline at the same package layer that env-options reads.

## §Auto-incarnation mirroring @apps pattern

> The daemon already incarnates @apps on startup — the root host checks `has('@apps')` and `lookup('@apps')` to get the gateway address. For @lal/@fae, the incarnation happens similarly.

```js
if (process.env.ENDO_LAL_PATH && await E(host).has('@lal')) {
  await E(host).lookup('@lal');
}
if (process.env.ENDO_FAE_PATH && await E(host).has('@fae')) {
  await E(host).lookup('@fae');
}
```

§Two-condition-check: §env-var-set AND §formula-has-been-preformulated. §The-lookup-triggers-incarnation.

§On-subsequent-launches-the-formula-store-already-has-the-@lal/@fae-formulas-persisted. §`provideGuest`-is-idempotent — §returns-the-existing-guest. §The-agent-resumes-its-manager-loop and §respawns-workers-from-persisted-configs.

§Borrowable-pattern: §mirror-existing-startup-incarnation-pattern when extending §an-existing-extension-point (here, @apps).

## §First-Run-Experience section — six-step user journey

> 1. The daemon starts with @lal and @fae special formulas.
> 2. The @lal formula incarnates: the bundled `endo-lal.cjs` is `import()`ed in a worker.
> 3. Lal's `make()` provisions itself as a guest, then sends a configuration form to @host.
> 4. The form appears in the user's inbox in the Chat UI.
> 5. The user fills in their API key and preferred model, submits.
> 6. The agent creates a named persona and begins following its inbox.

§Six-step-user-journey from §daemon-startup to §agent-following-inbox. §Borrowable-pattern: §First-Run-Experience-section-as-explicit-user-journey for §packaging-or-installer-designs.

## §Interaction-with-Form-Based-Provisioning — complementary-to-sibling-design

> This design is complementary to [lal-fae-form-provisioning](lal-fae-form-provisioning.md). [...] The two designs compose naturally:
>
> 1. **Bundled agent** starts with @endo powers, self-provisions as a guest, sends configuration form to @host.
> 2. **Form-based provisioning** handles the configuration form, creates named agent personas, spawns worker loops.

§Two-designs-with-complementary-roles named explicitly. §Cycle-208 provides §the-delivery-mechanism (bundling + registration). §lal-fae-form-provisioning provides §the-configuration-mechanism (form → guest → worker loop).

§Borrowable-pattern: §Interaction-with-sibling-design-section + §explicit-composition-narrative for §designs-that-compose-without-strictly-depending-on-each-other.

§Sibling-pattern to cycle 198 patterns-diagnostic-feedback's §sibling-extension-pattern (extends an upstream segment shape) and cycle 200 hardened-url-shim's §sibling-design-split (TextEncoder/TextDecoder split into separate design under same source issue). §Cycle-208-has-the-§complementary-shape: §two-designs-merge-functionally-without-merge-at-source-level.

## §Seven Design Decisions canonical format

1. **§esbuild-CJS-bundles** — same approach as daemon and worker bundles; single-file with inlined dependencies; no node_modules at runtime.
2. **§No-native-dependencies-to-replace** — all three LLM provider SDKs and all @endo/* packages are pure JS; agents bundle cleanly.
3. **§Special-formulas-via-Specials-mechanism** — reuses existing pattern from @apps; no new daemon infrastructure.
4. **§@endo-powers-with-self-provisioning** — agent receives full daemon access initially and voluntarily drops to guest-level; parallels @apps and avoids Specials-mechanism changes.
5. **§Environment-variable-gating** — @lal/@fae specials only registered when ENDO_LAL_PATH/ENDO_FAE_PATH set; in dev mode, agents installed via CLI as today; in packaged mode, they auto-register.
6. **§Auto-incarnation-on-startup** — agents start automatically on fresh daemon state; enables immediate first-run experience.
7. **§Complementary-to-form-provisioning** — this design provides delivery; form-provisioning provides configuration; together they produce complete out-of-the-box experience.

§Seven-Design-Decisions canonical format (sibling to cycles 184/188/192/194/196/198/200x2/202/203/204/206). §Each-decision-names-the-alternative-or-rationale.

## §Four Implementation Phases

1. **§esbuild Bundles** — add endo-lal.cjs and endo-fae.cjs entries; verify bundles build; test import in worker subprocess outside monorepo.
2. **§Resource Paths and Daemon Manager** — add endoLalPath/endoFaePath; pass ENDO_LAL_PATH/ENDO_FAE_PATH; add @lal/@fae special formulas to daemon-node.js (conditional on env vars).
3. **§Agent Self-Provisioning** — modify packages/lal/agent.js make() to detect @endo-level powers and self-provision; same for fae; overlaps with form-provisioning phase 2.
4. **§Auto-Incarnation** — add @lal/@fae lookup to daemon-node.js startup sequence; test end-to-end.

§Four-phases-with-named-test-criteria per phase. §Borrowable-pattern: §phased-implementation-with-named-overlap-with-sibling-design (Phase 3 explicitly notes overlap with form-provisioning Phase 2).

## §Files-Modified table — six files with §named-change-per-file

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

## §Two Dependencies + §Four Related Designs

§Two-Dependencies: familiar-daemon-bundling (extends) + lal-fae-form-provisioning (uses, not strictly required).

§Four-Related-Designs: familiar-daemon-bundling, familiar-electron-shell, lal-fae-form-provisioning, daemon-form-request.

§Sibling-pattern to cycle 202 endor-run-expanded's §three-dependencies-with-named-relationship-types (Requires / Enables / Extends) — cycle 208 uses §plain-Dependencies + §Related-Designs without explicit relationship types; both shapes appear in the library.

## §Borrowable patterns (tier-1)

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

## §Synthesis-target

Slot machine library §packaged-installation-with-bundled-game-content:

- §Three-named-problems-with-explicit-user-facing-pain borrowable for §packaged-game-distribution rationale (no-source-tree / no-node_modules / no-integrated-first-run).
- §Current-Architecture-section borrowable as §pre-Design-discipline for §extending-existing-infrastructure.
- §Dependency-Analysis-table-with-named-conclusion borrowable for §game-asset-dependency-vetting.
- §Self-provisioning-from-@endo-to-guest-powers borrowable for §game-process-that-needs-bootstrap-elevation but should §voluntarily-drop-to-game-only-authority.
- §Environment-variable-gating borrowable for §dev-vs-packaged game build differentiation.
- §Auto-incarnation-mirroring-existing-pattern borrowable for §game-startup-flow that extends §an-existing-extension-point.
- §First-Run-Experience-section borrowable for §game-installer-UX-design.
- §Complementary-to-sibling-design-section borrowable for §game-features-that-compose-with-other-game-features.
- §Files-Modified-table borrowable for §implementation-ready game-design-documents.

## §Cycle 208 meta-observations

§The-forty-second-consecutive-designs/chat-alternation-cycle 166-208.

§Papers-lane-blocked 102+ consecutive cycles (since cycle ~106).

§Library-reaches-713-sections at cycle 208.

§The-Powers-Problem-with-three-option-analysis is §a-novel-pattern named at this fidelity. §Sibling-pattern to cycle 198 patterns-diagnostic-feedback's §nine-Design-Decisions each naming the alternative rejected and cycle 200 retention-path-notation's §five-alternatives-considered — §three-different-shapes for §recording-rejected-alternatives:
- Cycle 198: interleaved §each-Design-Decision-names-the-alternative-rejected.
- Cycle 200: collected §Alternatives-considered section.
- Cycle 208: §three-option-analysis as §a-distinct-design-subsection that drives §the-resolution.

§Each-shape-borrowable for §different-design-rhetorical-needs.

§The-`specials`-extension-point named in cycle 204 weblet-next's §seven-Patterns-Worth-Preserving is §directly-reused in cycle 208 — §the-pattern-survived-the-feature-removal (weblet) and §was-reused-for-a-new-feature (bundled agents). §Confirmation of cycle 204's §distinguishing-extension-point-from-extension-content discipline.
