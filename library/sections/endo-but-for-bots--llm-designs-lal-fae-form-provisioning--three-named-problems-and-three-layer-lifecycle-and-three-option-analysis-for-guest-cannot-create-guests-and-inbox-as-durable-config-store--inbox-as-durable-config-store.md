---
title: §Inbox-as-durable-config-store
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

> No explicit config persistence needed. `followMessages()` replays all historical messages on restart, including past `value` submissions. The manager re-processes each submission: `provideGuest` is idempotent (returns the existing guest), and the worker loop is respawned. The inbox itself serves as the durable config store.

§Inbox-as-durable-config-store is §a-load-bearing-architectural-pattern. §Three-pieces-fit-together:
1. **§followMessages-replays-all-historical-messages-on-restart** — the daemon's inbox is durable; on restart, the iterator replays from the beginning.
2. **§provideGuest-is-idempotent** — calling `provideGuest('ada', ...)` twice returns the same guest both times.
3. **§Manager-re-processes-each-submission** — replay creates the same guests, spawns the same worker loops.

§The-result: §no-explicit-config-persistence-needed. §The-inbox-IS-the-config-database. §The-daemon's-existing-message-durability suffices.

§Sibling-pattern to cycle 202 endor-run-expanded's §root-hash-printed-to-stderr-for-re-run (both designs §use-existing-substrate-as-handle-storage) and cycle 175 harden-selector's §pin-on-first-install (§use-existing-mechanism-as-anchor).

§Borrowable-pattern: §use-existing-durable-substrate-as-config-store when §the-operations-are-idempotent and §the-substrate-supports-replay.
