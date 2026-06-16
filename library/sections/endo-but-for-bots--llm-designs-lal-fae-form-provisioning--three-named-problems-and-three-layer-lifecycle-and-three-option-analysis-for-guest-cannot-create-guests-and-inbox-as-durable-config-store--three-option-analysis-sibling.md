---
title: §Three-option-analysis (sibling pattern to cycle 208)
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

### Option A: §Evaluate-Proposal

> The manager sends an `evaluate` proposal to @host that calls `provideGuest`. [...] This requires the @host to review and grant the proposal.

§Drawback-named: §the-user-must-grant-every-guest-creation-via-eval-proposal-approval, which §adds-friction-to-what-should-feel-like-a-simple-form-fill.

### Option B: §Manager-Asks-@host

> Instead of the manager creating guests, the manager sends the form, and @host (the root user) submits the form. When the manager receives the `value` reply, it does not create the guest itself — it sends a `request` to @host asking for a guest with that name.

§Drawback-named: §requires-a-new-capability-or-a-multi-step-request/response-flow.

### Option C: §Grant-the-Manager-a-Host-Power (CHOSEN)

> The setup script introduces the `@agent` power (the host formula) to the manager guest. The manager can then call `E(agent).provideGuest(...)` using the host reference.

§Two-named-reasons for the choice:
1. §This-is-already-the-pattern-used-in-setup.js-today.
2. §The-form-submission-from-@host-already-serves-as-the-consent-mechanism — §@host-chooses-to-submit-the-form, which §triggers-guest-creation.

§The-consent-property-is-preserved without §the-eval-proposal-friction. §Borrowable-pattern: §reuse-existing-pattern-when-the-consent-property-is-preserved-by-the-existing-flow.

§Sibling-pattern to cycle 208 familiar-bundled-agents's §three-option-analysis for §The-Powers-Problem — both cycle 208 and cycle 210 are §sibling-designs with §parallel-three-option-analyses on §related-axes (cycle 208 about §how-the-agent-gets-bootstrap-powers; cycle 210 about §how-the-manager-creates-sub-guests).
