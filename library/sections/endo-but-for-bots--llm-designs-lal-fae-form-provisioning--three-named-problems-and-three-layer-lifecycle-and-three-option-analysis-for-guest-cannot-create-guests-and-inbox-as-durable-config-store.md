---
title: §Three-named-problems (config-baked-in / one-agent-per-install / no-user-consent-flow) + §three-layer-lifecycle (Setup script / Manager agent / Worker loops) with ASCII diagram + §Architectural-Constraint-section-Guest-Cannot-Create-Guests + §three-option-analysis (Eval-Proposal / Manager-Asks-@host / Grant-@agent-Host-Power) resolved to Option C with §named-rationale + §the-form-submission-from-@host-already-serves-as-the-consent-mechanism + §inbox-as-durable-config-store with §provideGuest-is-idempotent and §followMessages-replays-all-historical-messages-on-restart + §per-worker-provider + §three-Alternatives-Considered each rejected with named reason + §seven-Design-Decisions canonical + §four-Phases-all-Complete + §complementary-to-cycle-208-familiar-bundled-agents — endo-but-for-bots designs/lal-fae-form-provisioning.md
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
---

# lal-fae-form-provisioning — §three-named-problems + §three-layer-lifecycle + §Architectural-Constraint-Guest-Cannot-Create-Guests + §three-option-analysis + §inbox-as-durable-config-store + §complementary-to-cycle-208

## Source

- `endo-but-for-bots designs/lal-fae-form-provisioning.md` — 713 lines
- Status: **Complete** (created 2026-03-02; updated 2026-03-05; all four phases shipped)
- Author: Kris Kowal (prompted)
- Cycle 210 of `/loop resume the librarian work.` (designs-lane; alternates from cycle 209's chat-lane @endo/path-compare; §forty-fourth consecutive designs/chat alternation cycle 166-210)

## Single most structurally interesting move

§Three-layer-lifecycle (Setup-script / Manager-agent / Worker-loops) with §ASCII-diagram + §Architectural-Constraint-named-in-section-header (§"Guest Cannot Create Guests") + §three-option-analysis for the constraint (Eval-Proposal / Manager-Asks-@host / Grant-@agent-Host-Power) §resolved-to-Option-C with §named-rationale ("already the pattern used in setup.js today") + §the-form-submission-from-@host-already-serves-as-the-consent-mechanism + §inbox-as-durable-config-store (followMessages replays all historical messages on restart; provideGuest is idempotent; no explicit config persistence needed).

§The-design-encodes-a-consent-boundary: §the-form-submission-from-@host serves as §the-explicit-user-consent for each new guest creation. §The-@agent-introduction-bypasses-eval-proposal-friction while §preserving-the-consent-property.

## §Three-named-problems with §explicit-user-facing-pain

> 1. **Configuration is baked in at provisioning.** Changing the model or API key requires re-running the setup script with new environment variables.
> 2. **Only one agent identity per install.** Each `setup.js` creates exactly one guest profile [...] To run multiple independent agent personas, the user must manually duplicate and edit setup scripts.
> 3. **No user consent flow.** The agent starts following its inbox immediately with whatever configuration the environment provided.

§Three-numbered-problems with §explicit-user-facing-pain — §named-pain-points per problem.

§Sibling-pattern to cycle 208 familiar-bundled-agents's §three-named-problems and cycle 200 worker-rust-xs's §three-numbered-problems each with named defense. §Same-shape across the family.

## §Three-layer-lifecycle with §ASCII-diagram

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

## §Architectural-Constraint named in section header

> ### Architectural Constraint: Guest Cannot Create Guests
>
> The `provideGuest` method is on the `EndoHost` interface, not `EndoGuest`. A guest caplet (which is what the manager agent is) cannot directly create new guest profiles.

§The-constraint-named-in-a-section-header — §explicit-attention-to-a-tension that the design must resolve. §Sibling-pattern to cycle 208 familiar-bundled-agents's §The-Powers-Problem section.

§Borrowable-pattern: §Architectural-Constraint-as-section-header for §designs-that-must-resolve-a-named-axis-tension.

## §Three-option-analysis (sibling pattern to cycle 208)

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

## §The-form-submission-from-@host-already-serves-as-the-consent-mechanism

§The-load-bearing-insight: §the-existing-form-submission-flow IS §the-consent-boundary. §The-manager-doesn't-need-additional-consent-checks because §the-form-only-creates-a-guest-when-@host-actually-submits-it.

§Borrowable-pattern: §existing-user-action-as-consent-mechanism when §the-action-is-already-explicit-and-user-initiated.

§Sibling-pattern to cycle 196 endoclaw's §three-named-attacks-with-three-structural-defenses — both designs §name-consent-or-defense-mechanisms-explicitly. §Cycle-210-is-more-architectural: §the-consent-is-baked-into-the-flow-design.

## §Inbox-as-durable-config-store

> No explicit config persistence needed. `followMessages()` replays all historical messages on restart, including past `value` submissions. The manager re-processes each submission: `provideGuest` is idempotent (returns the existing guest), and the worker loop is respawned. The inbox itself serves as the durable config store.

§Inbox-as-durable-config-store is §a-load-bearing-architectural-pattern. §Three-pieces-fit-together:
1. **§followMessages-replays-all-historical-messages-on-restart** — the daemon's inbox is durable; on restart, the iterator replays from the beginning.
2. **§provideGuest-is-idempotent** — calling `provideGuest('ada', ...)` twice returns the same guest both times.
3. **§Manager-re-processes-each-submission** — replay creates the same guests, spawns the same worker loops.

§The-result: §no-explicit-config-persistence-needed. §The-inbox-IS-the-config-database. §The-daemon's-existing-message-durability suffices.

§Sibling-pattern to cycle 202 endor-run-expanded's §root-hash-printed-to-stderr-for-re-run (both designs §use-existing-substrate-as-handle-storage) and cycle 175 harden-selector's §pin-on-first-install (§use-existing-mechanism-as-anchor).

§Borrowable-pattern: §use-existing-durable-substrate-as-config-store when §the-operations-are-idempotent and §the-substrate-supports-replay.

## §Per-worker-provider (each worker can use different LLM model)

> Each worker creates its own LLM provider from the form submission's `host`/`model`/`authToken`. Different workers can use different models or providers.

§The-form-submission-is-per-worker, so §each-worker-has-its-own-LLM-config. §Two-guests-can-talk-to-two-different-models simultaneously.

§Borrowable-pattern: §per-instance-provider-via-form-submission for §multi-tenant-systems-where-each-tenant-can-have-different-backend.

## §Manager-Worker-Split discipline

> The agent caplet acts as a manager that spawns independent worker loops. This keeps the manager's inbox clean (it only handles form submissions) and gives each worker its own identity, inbox, and pet store.

§Three-named-benefits of the split:
1. §Manager's-inbox-is-clean (only form submissions).
2. §Each-worker-has-its-own-identity.
3. §Each-worker-has-its-own-inbox-and-pet-store.

§Single-responsibility-per-caplet: §manager-handles-provisioning; §worker-handles-conversation.

§Borrowable-pattern: §manager-worker-split for §systems-where-provisioning-and-operation-have-different-shapes.

## §Three-Alternatives-Considered each rejected with named reason

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

## §Seven-Design-Decisions canonical format

1. **§Manager/worker split** — keeps manager's inbox clean; gives each worker own identity/inbox/pet-store.
2. **§Form for configuration** — daemon's form system provides structured/validated/UI-renderable flow; resubmittable.
3. **§@agent introduction** — manager receives @agent power via introducedNames; consent-boundary at form submission.
4. **§Per-worker provider** — each worker creates own LLM provider from form values; different workers can use different models.
5. **§Persisted configs for restart recovery** — worker configs in manager's pet store (Phase 3 §revised this to "inbox replay" — see Phases below).
6. **§No environment variables** — all configuration flows through the form; eliminates "baked-in at provisioning" problem.
7. **§Shared form fields** — Lal and Fae use identical form fields; the difference is worker loop behavior (Lal: reply-chain transcripts + static tools; Fae: flat transcripts + dynamic tool discovery).

§Note: Design Decision 5's "persisted configs" was §later-revised — Phase 3 (Complete) reads "No explicit config persistence needed. followMessages() replays all historical messages on restart". §The-original-decision was §the-form-was-going-to-need-persistence; §the-revised-implementation discovered §the-inbox-already-serves-as-the-durable-config-store. §An-honest-design-evolution between Decision 5 and Phase 3.

§Sibling-pattern to cycle 178 daemon-xs-worker-snapshot's §Revised-scope-2026-04-15 and cycle 198 patterns-diagnostic-feedback's §three-revision-pivots — §design-decisions-revised-during-implementation.

## §Four-Phases all Complete

> ### Phase 1: Extract Worker Loop — **Complete**
> ### Phase 2: Manager Loop and Form — **Complete**
> ### Phase 3: Restart Recovery — **Complete**
> ### Phase 4: Fae Parity — **Complete**

§A-completed-design with §all-four-phases-shipped. Status **Complete**.

§Phase-3 is §the-honest-design-evolution moment: original plan was config persistence; §implementation-discovered the inbox already serves the role.

§Sibling-pattern to cycle 184 daemon-xs-worker-metering (Complete; all seven phases tested) and cycle 188 daemon-rust-xs-performance (Active; performance investigation).

## §Complementary-to-cycle-208 — §the-sibling-pair-is-complete

Cycle 208 familiar-bundled-agents named §lal-fae-form-provisioning as §the-configuration-mechanism that composes with §the-bundling-delivery-mechanism. Cycle 210 names §familiar-bundled-agents only obliquely (the sibling design that provides the delivery vehicle).

§Together-they-produce: §launch-Familiar → §form-appears-in-inbox → §user-fills-API-key → §agent-starts.

§Borrowable-pattern: §sibling-design-pair where §each-design-references-the-other-explicitly + §the-composition-narrative-is-named-in-both.

§The-pair-completion: cycle 208 (delivery) + cycle 210 (configuration) form §a-complete-feature with §each-design-having-its-own-Status-Complete-marker. §The-pair-is-the-feature.

## §Files-Modified table — five files

| File | Change |
| --- | --- |
| `packages/lal/setup.js` | Remove env vars, add `@agent` introduction |
| `packages/lal/agent.js` | Extract worker loop, add manager logic, send form on startup |
| `packages/lal/agent.types.d.ts` | Add `WorkerConfig`, remove `LalEnv` |
| `packages/fae/setup.js` | Remove env vars, add `@agent` introduction |
| `packages/fae/agent.js` | Extract worker loop, add manager logic, send form on startup |

§Five-files. §Symmetric-changes-between-Lal-and-Fae (sibling implementations).

§Sibling-pattern to cycle 208's §Files-Modified-table (seven files) — both designs use §the-Files-Modified-table convention for §implementation-ready-designs.

## §Borrowable patterns (tier-1)

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

## §Synthesis-target

Slot machine library §multi-tenant-game-table-provisioning:

- §Three-layer-lifecycle borrowable directly — §Setup-script (provisions one casino-floor manager) / §Manager-agent (sends form to operator on startup, spawns new tables on submission) / §Worker-loops (one per game table, each with its own table state).
- §Existing-user-action-as-consent-mechanism borrowable — §operator-submitting-the-add-game-table-form serves as consent for table creation.
- §Inbox-as-durable-config-store borrowable directly — §operator's-form-submission-history persisted in inbox; replay on restart recreates all tables.
- §Per-instance-provider-via-form-submission borrowable — each table can use a different game variant.
- §Manager-worker-split borrowable for §provisioning-vs-operation discipline.
- §Three-option-analysis borrowable for §resolving-multi-tenant-isolation-constraints.

## §Cycle 210 meta-observations

§The-forty-fourth-consecutive-designs/chat-alternation-cycle 166-210.

§Papers-lane-blocked 104+ consecutive cycles (since cycle ~106).

§Library-reaches-715-sections at cycle 210.

§The-sibling-pair-completion: cycle 208 (familiar-bundled-agents) + cycle 210 (lal-fae-form-provisioning) = §a-complete-feature with §two-Status-Complete-designs. §The-pair-is-the-feature.

§Fourteenth-honest-design-evolution-record family member: §Design-Decision-5 (persisted configs) was §later-revised — Phase 3 (Complete) replaced explicit persistence with §inbox-replay. §An-honest-evolution-between-decision-and-implementation that is §preserved-in-the-design-document. §A-new-shape: §decision-revised-during-implementation-with-both-recorded.

§Two-rhetorical-shapes-for-recording-rejected-alternatives in one document: §three-option-analysis (in body for §architectural-constraint resolution) + §Alternatives-Considered (at end for §design-axis decisions). §Different-axes-of-rejection-recorded-separately.

§Mermaid-vs-ASCII-vs-narrative-walkthrough — cycle 210 uses ASCII for the fan-out diagram (sibling to cycle 200 worker-rust-xs's three-process-boxes and cycle 206 inventory-cancel-and-liveness's UI mockup); cycle 209 uses Mermaid for dependency graphs. §Three-different-visualization-conventions for §three-different-shape-needs.
