---
title: §Seven-Design-Decisions canonical format
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

1. **§Manager/worker split** — keeps manager's inbox clean; gives each worker own identity/inbox/pet-store.
2. **§Form for configuration** — daemon's form system provides structured/validated/UI-renderable flow; resubmittable.
3. **§@agent introduction** — manager receives @agent power via introducedNames; consent-boundary at form submission.
4. **§Per-worker provider** — each worker creates own LLM provider from form values; different workers can use different models.
5. **§Persisted configs for restart recovery** — worker configs in manager's pet store (Phase 3 §revised this to "inbox replay" — see Phases below).
6. **§No environment variables** — all configuration flows through the form; eliminates "baked-in at provisioning" problem.
7. **§Shared form fields** — Lal and Fae use identical form fields; the difference is worker loop behavior (Lal: reply-chain transcripts + static tools; Fae: flat transcripts + dynamic tool discovery).

§Note: Design Decision 5's "persisted configs" was §later-revised — Phase 3 (Complete) reads "No explicit config persistence needed. followMessages() replays all historical messages on restart". §The-original-decision was §the-form-was-going-to-need-persistence; §the-revised-implementation discovered §the-inbox-already-serves-as-the-durable-config-store. §An-honest-design-evolution between Decision 5 and Phase 3.

§Sibling-pattern to cycle 178 daemon-xs-worker-snapshot's §Revised-scope-2026-04-15 and cycle 198 patterns-diagnostic-feedback's §three-revision-pivots — §design-decisions-revised-during-implementation.
