---
title: §Three-layer-lifecycle with §ASCII-diagram
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

```
                    ┌──────────┐
                    │  @host   │
                    │ (root)   │
                    └────┬─────┘
                         │ form: "Add an agent"
                         │   fields: name, host, model, authToken
                         ▼
                    ┌──────────┐
                    │ Manager  │ (lal / fae)
                    │ Guest    │ profile-for-lal / profile-for-fae
                    └────┬─────┘
                         │ on each value reply:
                         │   provideGuest(name, ...)
                         │   spawn worker loop
                         ▼
              ┌──────────┴──────────┐
              ▼                     ▼
       ┌────────────┐        ┌────────────┐
       │ Guest "ada"│        │ Guest "bob"│
       │ worker loop│        │ worker loop│
       └────────────┘        └────────────┘
```

§Three-layers each with named role:
1. **§Setup-script** — provisions a single "manager" guest profile with no LLM configuration.
2. **§Manager-agent** — sends configuration form to @host on startup; on each `value` reply, creates a new guest profile and spawns an agentic loop.
3. **§Worker-loops** — each follows a specific guest's inbox; processes messages using the LLM configuration from the form submission.

§ASCII-art-as-design-prose for §the-fan-out-pattern. §Sibling-pattern to cycle 200 worker-rust-xs's §ASCII-architecture-diagram-with-three-process-boxes (different shape; same convention).

§Borrowable-pattern: §three-layer-lifecycle-with-manager-worker-split for §multi-agent-systems-with-shared-substrate.
