---
title: §Three-Alternatives-Considered each rejected with named reason
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

### Alt 1: §Environment-Variables-with-Optional-Form-Override

§Keep-the-current-env-based-setup-as-the-default; §add-form-based-configuration-as-an-optional-second-path. **Rejected** because §it-preserves-the-"one-agent-per-install"-limitation and §does-not-exercise-the-form-system-as-the-primary-configuration-path.

### Alt 2: §Eval-Proposal-for-Guest-Creation

§Instead-of-introducing-@agent, §the-manager-sends-eval-proposals-for-each-provideGuest-call. **Rejected** in favor of the simpler `@agent` introduction.

### Alt 3: §Unconfined-Worker-Caplets

§Each-form-submission-triggers-makeUnconfined-to-launch-a-separate-caplet-per-worker. §Benefit: §better-isolation (workers crash independently). §Drawback: §more-complex (dynamically constructing caplet specifiers). **Deferred** to future iteration. §The-in-process-approach-is-simpler-and-sufficient-for-now.

§Three-different-rhetorical-shapes-for-recording-rejected-alternatives now in library (cycle 198/200/208/210):
- Cycle 198: interleaved §each-Design-Decision-names-the-alternative-rejected.
- Cycle 200 retention-path: §collected Alternatives-considered section (five-alternatives).
- Cycle 208 familiar-bundled-agents: §three-option-analysis as distinct subsection driving resolution.
- Cycle 210 (this cycle): §Alternatives-Considered section (three-alternatives) PLUS §three-option-analysis subsection in the body — §two-shapes-in-one-document.

§Cycle-210-uses-both-shapes — alternatives-considered AND three-option-analysis. §Different-axes-of-rejection-recorded-separately.
