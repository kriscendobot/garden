---
title: "designs/cli-http-client.md — Controller + client cap split + mutate-the-policy-not-the-client-identity + the-controller-IS-the-pet-name-handle + three SSRF defenses + design-revision-after-CHANGES_REQUESTED"
source-slug: endo-but-for-bots--llm-designs-cli-http-client
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-http-client.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-http-client.md
total-lines: 644
ingest-cycle: 238
ingest-date: 2026-06-08
lane: designs
kind: index
section_count: 21
---

Sections:

- [CLI HTTP client: controller + client cap split + mutate-the-policy-not-the-client-identity + the-controller-IS-the-pet-name-handle + three SSRF defenses + design-revision-after-CHANGES_REQUESTED](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-76b20381--cli-http-client-controller-cli.md)
- [§Design-revision-after-CHANGES_REQUESTED as named provenance](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-d-76b20381--design-revision-after-changes.md)
- [§The controller and client cap split (canonical ocap two-facet pattern)](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-d-76b20381--the-controller-and-client-cap.md)
- [§Mutate-the-policy-not-the-client-identity](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-76b20381--mutate-the-policy-not-the-clie.md)
- [§The-controller-IS-the-pet-name-handle](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-76b20381--the-controller-is-the-pet-name.md)
- [§`endo http` subcommand tree replaces single verb](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-76b20381--endo-http-subcommand-tree-repl.md)
- [§Method-placement-table — which methods sit on which facet](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-76b20381--method-placement-table-which-m.md)
- [§Cancellation-promise-as-platform-neutral-interface](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-76b20381--cancellation-promise-as-platfo.md)
- [§Two-independent-cancellation-channels](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-76b20381--two-independent-cancellation-c.md)
- [§Three-named-SSRF-vectors-and-three-named-defenses](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-76b20381--three-named-ssrf-vectors-and-t.md)
- [§Local-idioms-cited-table](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-76b20381--local-idioms-cited-table.md)
- [§Forward-compatibility-with-exo-stream via shim shape](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-76b20381--forward-compatibility-with-exo.md)
- [§Alternatives-considered with rejected/deferred labels](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-76b20381--alternatives-considered-with-r.md)
- [§Identifier-conventions-TBD-pending-namer-dispatch](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-76b20381--identifier-conventions-tbd-pen.md)
- [§Open-questions-section as named uncertainty](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-76b20381--open-questions-section-as-name.md)
- [§Test-plan section](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revisi-76b20381--test-plan-section.md)
- [§Dependencies-table-with-Relationship-column](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-76b20381--dependencies-table-with-relati.md)
- [§Prompt-section captures the originating review comment](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-76b20381--prompt-section-captures-the-or.md)
- [§Borrowable patterns](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revi-76b20381--borrowable-patterns.md)
- [§Synthesis-target — slot machine library](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-d-76b20381--synthesis-target-slot-machine.md)
- [§Library meta-counters](endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-re-76b20381--library-meta-counters.md)
