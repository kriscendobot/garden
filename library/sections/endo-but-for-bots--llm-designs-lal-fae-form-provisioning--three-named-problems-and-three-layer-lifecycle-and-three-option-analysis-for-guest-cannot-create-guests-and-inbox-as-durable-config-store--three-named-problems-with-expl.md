---
title: §Three-named-problems with §explicit-user-facing-pain
source: endo-but-for-bots designs/lal-fae-form-provisioning.md
source-slug: endo-but-for-bots--llm-designs-lal-fae-form-provisioning
ingest-cycle: 210
ingest-date: 2026-06-06
lane: designs
status: Complete (2026-03-02 created; 2026-03-05 updated; all four phases shipped)
author: Kris Kowal (prompted)
related:
  - endo-but-for-bots--llm-designs-familiar-bundled-agents (cycle 208; §complementary-sibling — 208 provides delivery; cycle 210 provides configuration; together produce complete out-of-the-box experience)
  - endo-but-for-bots--llm-designs-daemon-form-request (form primitives used for configuration form)
  - endo-but-for-bots--llm-designs-daemon-value-message (value messages used as reply mechanism for form submissions)
  - endo-but-for-bots--llm-designs-lal-reply-chain-transcripts (transcript node store used by Lal worker loops)
  - endo-but-for-bots--llm-designs-daemon-capability-persona (delegate/epithet system; each worker guest is a distinct persona)
  - endo-but-for-bots--llm-designs-endopi (cycle 121; sibling-agent-shape comparison)
keywords:
  - three-named-problems (config-baked-in / one-agent-per-install / no-user-consent-flow)
  - three-layer-lifecycle (Setup script / Manager agent / Worker loops)
  - ASCII-diagram-of-three-layer-lifecycle
  - Architectural-Constraint-named-in-section-header
  - Guest-cannot-create-guests
  - three-option-analysis (Eval-Proposal / Manager-Asks-@host / Grant-@agent-Host-Power)
  - introducedNames-@agent-as-consent-boundary
  - form-submission-as-consent-mechanism
  - inbox-as-durable-config-store
  - followMessages-replays-all-historical-messages-on-restart
  - provideGuest-is-idempotent
  - no-explicit-config-persistence-needed
  - per-worker-provider (different workers can use different LLM models)
  - manager-worker-split-discipline
  - shared-form-fields between Lal and Fae
  - four-form-fields (name / host / model / authToken)
  - three-Alternatives-Considered (env-vars / eval-proposal / unconfined-worker-caplets)
  - seven-Design-Decisions canonical
  - four-Phases-all-Complete
  - Files-Modified-table with five files
  - complementary-to-cycle-208-familiar-bundled-agents
  - fourteenth-honest-design-evolution-record family member (the sibling pair completion)
  - cycle 210 designs-lane
  - forty-fourth consecutive designs/chat alternation cycle 166-210
parent: endo-but-for-bots--llm-designs-lal-fae-form-provisioning--three-named-problems-and-three-layer-lifecycle-and-three-option-analysis-for-guest-cannot-create-guests-and-inbox-as-durable-config-store
---

> 1. **Configuration is baked in at provisioning.** Changing the model or API key requires re-running the setup script with new environment variables.
> 2. **Only one agent identity per install.** Each `setup.js` creates exactly one guest profile [...] To run multiple independent agent personas, the user must manually duplicate and edit setup scripts.
> 3. **No user consent flow.** The agent starts following its inbox immediately with whatever configuration the environment provided.

§Three-numbered-problems with §explicit-user-facing-pain — §named-pain-points per problem.

§Sibling-pattern to cycle 208 familiar-bundled-agents's §three-named-problems and cycle 200 worker-rust-xs's §three-numbered-problems each with named defense. §Same-shape across the family.
