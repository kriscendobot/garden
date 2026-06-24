---
title: §Borrowable patterns (tier-1)
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

1. **§Three-named-problems-with-explicit-user-facing-pain** as canonical Problem-section shape (sibling to cycles 200/208).
2. **§Three-layer-lifecycle (Setup-script / Manager-agent / Worker-loops)** with §ASCII-diagram-of-fan-out-pattern for §multi-agent-systems-with-shared-substrate.
3. **§Architectural-Constraint-named-in-section-header** for §designs-that-must-resolve-a-named-axis-tension.
4. **§Three-option-analysis** (sibling to cycle 208) for §resolving-named-architectural-constraints + §named-drawbacks-and-benefits-per-option + §resolution-with-named-rationale.
5. **§Existing-user-action-as-consent-mechanism** when the action is already explicit and user-initiated — form submission serves as consent without additional eval-proposal.
6. **§Inbox-as-durable-config-store** — use existing durable substrate when (a) operations are idempotent, (b) substrate supports replay; sibling to cycle 202's §root-hash-printed-to-stderr.
7. **§Per-instance-provider-via-form-submission** for §multi-tenant-systems-where-each-tenant-can-have-different-backend.
8. **§Manager-worker-split** for §systems-where-provisioning-and-operation-have-different-shapes.
9. **§Three-Alternatives-Considered each rejected with named reason** (env-vars / eval-proposal / unconfined-worker-caplets) — sibling rhetorical shape to cycle 200 retention-path.
10. **§Seven-Design-Decisions canonical format** with §design-decision-5-revised-during-implementation (Phase 3 honest-design-evolution).
11. **§Four-Phases-all-Complete** as §status-marker for §shipped-design.
12. **§Complementary-to-sibling-design** with §each-design-having-its-own-Status-Complete-marker — §the-pair-is-the-feature.
13. **§Files-Modified-table** with named change per file — symmetric-changes-between-Lal-and-Fae rows.
14. **§Two-rhetorical-shapes-in-one-document** — both §three-option-analysis (in body) and §Alternatives-Considered (at end) — §different-axes-of-rejection-recorded-separately.
