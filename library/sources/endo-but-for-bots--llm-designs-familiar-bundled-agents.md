---
title: "familiar-bundled-agents — bundle Lal/Fae agents into the Familiar Electron shell"
source-slug: endo-but-for-bots--llm-designs-familiar-bundled-agents
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-bundled-agents.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-bundled-agents.md
total-lines: 618
status: Complete (2026-03-02 created; 2026-03-05 updated)
ingest-cycle: 208
ingest-date: 2026-06-06
lane: designs
---

# familiar-bundled-agents.md

A 618-line **Complete** design (2026-03-02 / updated 2026-03-05) bundling Lal and Fae agent caplets into the Familiar Electron shell so end users get §an-immediate-out-of-the-box-conversational-AI-experience without needing the monorepo source tree.

## Key design moves

- **§Three-named-problems with §explicit-user-facing-pain** as canonical Problem-section shape: (1) requires source tree (.dmg/.zip users have no monorepo); (2) requires node_modules (bare specifier imports fail in packaged Familiar); (3) no integrated first-run experience.
- **§Current-Architecture-section before §Design-section** with three subsections (daemon-bundles / caplets-loaded / @apps-formula) — §explicit-reuse-of-existing-extension-point.
- **§Dependency-Analysis-table-with-named-conclusion** ("No binary dependencies need replacement"): all three LLM SDKs (@anthropic-ai/sdk, openai, ollama) are pure JS HTTP clients; all @endo/* packages are pure JS.
- **§SES-Compatibility-section-with-CLAUDE.md-quoted-constraint** (unconfined plugins must NOT import ses or @endo/init); verified against agent imports.
- **§The-Powers-Problem with §three-option-analysis**:
  - Option A: Self-provisioning (CHOSEN) — agent receives @endo powers and voluntarily drops to guest-level.
  - Option B: Setup as separate special formula (REJECTED — Specials mechanism doesn't support inter-formula dependencies).
  - Option C: Hardcoded guest provisioning in daemon (REJECTED — mixes agent provisioning into daemon entry).
- **§Brief-bootstrap-window-with-full-authority-acceptable** with §three-named-reasons: (1) agent code is bundled and shipped by us, not user-provided; (2) @apps formula already has this pattern; (3) agent voluntarily drops immediately.
- **§Environment-variable-gating** for dev-vs-packaged asymmetry — Specials only registered when `ENDO_LAL_PATH`/`ENDO_FAE_PATH` set; dev mode unaffected.
- **§Auto-incarnation mirroring @apps pattern** — daemon checks `has('@lal')` and `lookup('@lal')` on startup; idempotent provisioning via `provideGuest` returning existing guest.
- **§First-Run-Experience-section** with §six-step-user-journey (daemon start → @lal incarnate → form to @host → form in inbox → user fills API key → agent creates persona).
- **§Interaction-with-Form-Based-Provisioning** — §complementary-to-sibling-design with explicit composition narrative.
- **§Seven Design Decisions canonical format**.
- **§Four Implementation Phases** with §named-test-criteria-per-phase + §named-overlap-with-sibling-design (Phase 3 overlaps with form-provisioning Phase 2).
- **§Files-Modified-table** with named change per file (seven files, including "No changes" for types.d.ts).

## The Powers Problem — resolved to Option A self-provisioning

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

§The-agent-briefly-has-root-access. §Voluntarily-drops-to-guest-level-authority. §Three-named-reasons-for-acceptability of the bootstrap window.

## Environment-variable gating

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

§Dev-mode: env vars are empty strings → agents not registered → user installs via CLI as today.
§Packaged-mode: env vars point to bundled .cjs files → agents auto-register → immediate first-run experience.

## Ingest scope

Cycle 208 (designs-lane): full ingest of the 618-line design as one section.

## Related material in the library

- **`familiar-daemon-bundling.md`** (Dependency named in design): esbuild infrastructure this design extends.
- **`lal-fae-form-provisioning.md`** (Dependency): complementary form-based configuration flow.
- **`familiar-electron-shell.md`** (Related): Familiar architecture including resource paths.
- **`daemon-form-request.md`** (Related): form primitives used for agent configuration.
- **cycle 204 weblet-next**: §the-`specials`-extension-point pattern this design reuses (named as one of cycle 204's §seven-Patterns-Worth-Preserving — §the-pattern-survived-the-feature-removal and §was-reused-for-a-new-feature).
- **cycle 200 worker-rust-xs**: §host-compartment-vs-guest-compartment-split sibling — both designs isolate guest code from host authority (cycle 200 via engine-level enforcement; cycle 208 via self-provisioning with named trust assumption).
- **cycle 196 endoclaw**: §three-named-attacks paired with §three-structural-defenses sibling for §Problem-section-with-numbered-problems-and-named-defenses.
- **cycle 198 patterns-diagnostic-feedback**: §nine-Design-Decisions each naming the alternative rejected — sibling rhetorical shape (cycle 208 uses §three-option-analysis as §distinct-subsection; cycle 198 interleaves).
- **cycle 200 retention-path-notation**: §five-alternatives-considered (collected section) — another sibling rhetorical shape for §recording-rejected-alternatives.
- **cycle 197 panic**: §"no-further-loss-in-security"-argument sibling — both designs argue acceptability via named mitigating factors.
- **cycle 207 env-options**: §environment-variable-as-deployment-knob discipline at the same package layer that env-options reads.
- **cycle 121 endopi**: sibling agent-shape comparison; Lal and Fae are referenced.
- **cycle 183 init+lockdown**: §NOTE-TO-REVIEWERS pattern — both designs preserve architectural constraints as readable prose.
- **cycle 204 weblet-next**: §Files-Modified-table sibling at opposite lifecycle end — cycle 204 enumerates files removed; cycle 208 enumerates files changed.

## The XS-worker-family kinship

This design uses the §`specials` extension point that cycle 204 weblet-next named as §one-of-seven-Patterns-Worth-Preserving from the removed weblet feature. §The-pattern-survived-the-feature-removal (weblet) and §was-reused-for-a-new-feature (bundled agents). §Confirmation that cycle 204's §distinguishing-extension-point-from-extension-content discipline produces durable patterns.
