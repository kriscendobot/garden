---
title: "lal-fae-form-provisioning — form-based agent configuration replacing env-var setup"
source-slug: endo-but-for-bots--llm-designs-lal-fae-form-provisioning
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/lal-fae-form-provisioning.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/lal-fae-form-provisioning.md
total-lines: 713
status: Complete (2026-03-02 created; 2026-03-05 updated; all four phases shipped)
ingest-cycle: 210
ingest-date: 2026-06-06
lane: designs
---

# lal-fae-form-provisioning.md

A 713-line **Complete** design (2026-03-02 / updated 2026-03-05) refactoring Lal and Fae from environment-variable configuration to form-based configuration via the daemon's form/value-message system. §The-sibling-design to cycle 208 familiar-bundled-agents (which provides delivery; this provides configuration).

## The three named problems

> 1. **Configuration is baked in at provisioning.** Changing the model or API key requires re-running the setup script.
> 2. **Only one agent identity per install.** Each `setup.js` creates exactly one guest profile.
> 3. **No user consent flow.** The agent starts following its inbox immediately with whatever configuration the environment provided.

## Key design moves

- **§Three-layer-lifecycle** with §ASCII-diagram-of-fan-out-pattern:
  - Setup script — provisions one "manager" guest profile.
  - Manager agent — sends form to @host; on each `value` reply, creates a new guest and spawns a worker loop.
  - Worker loops — one per submission, each following its own guest's inbox with its own LLM config.
- **§Architectural-Constraint-named-in-section-header** — "Guest Cannot Create Guests" (provideGuest is on EndoHost not EndoGuest).
- **§Three-option-analysis** for the constraint:
  - Option A: Evaluate Proposal — manager sends eval-proposal to @host for each guest creation. REJECTED (friction).
  - Option B: Manager Asks @host — multi-step request/response flow. REJECTED (complexity).
  - Option C: Grant @agent Host Power — setup script introduces `@agent` to manager via introducedNames. CHOSEN.
- **§The-form-submission-from-@host-already-serves-as-the-consent-mechanism** — §existing-user-action-as-consent-mechanism; no additional eval-proposal needed.
- **§Inbox-as-durable-config-store** — followMessages() replays all historical messages on restart; provideGuest is idempotent; the inbox itself serves as the durable config store. §No-explicit-config-persistence-needed.
- **§Per-worker-provider** — each worker creates its own LLM provider from form values; different workers can use different models or providers.
- **§Manager-worker-split** — manager handles provisioning; worker handles conversation. §Three-named-benefits: manager's inbox stays clean; each worker has own identity; each worker has own inbox/pet-store.
- **§Shared form fields** between Lal and Fae (name / host / model / authToken); difference is worker loop behavior (Lal reply-chain; Fae flat transcripts).
- **§Three-Alternatives-Considered** each rejected with named reason: env-vars-with-form-override (preserves one-agent limit) / eval-proposal-for-guest-creation (friction) / unconfined-worker-caplets (deferred to future).
- **§Seven-Design-Decisions canonical format** — Design Decision 5 (persisted configs) was §later-revised in Phase 3 to "inbox-replay" — §honest-design-evolution-between-decision-and-implementation.
- **§Four-Phases-all-Complete**.
- **§Files-Modified-table** with five files (symmetric Lal/Fae changes).

## ASCII fan-out diagram

```
                    ┌──────────┐
                    │  @host   │
                    └────┬─────┘
                         │ form
                         ▼
                    ┌──────────┐
                    │ Manager  │
                    └────┬─────┘
                         │ provideGuest(name) + spawn worker loop
                         ▼
              ┌──────────┴──────────┐
              ▼                     ▼
       ┌────────────┐        ┌────────────┐
       │ Guest "ada"│        │ Guest "bob"│
       └────────────┘        └────────────┘
```

## Inbox-as-durable-config-store

> No explicit config persistence needed. `followMessages()` replays all historical messages on restart, including past `value` submissions. The manager re-processes each submission: `provideGuest` is idempotent (returns the existing guest), and the worker loop is respawned. The inbox itself serves as the durable config store.

§Three-pieces-fit-together: followMessages-replays + provideGuest-idempotent + manager-re-processes. §The-inbox-IS-the-config-database.

## Complementary to cycle 208 — the sibling-pair completion

| Cycle | Design | Role |
| --- | --- | --- |
| 208 | familiar-bundled-agents | §Delivery (bundling + registration) |
| 210 (this cycle) | lal-fae-form-provisioning | §Configuration (form → guest → worker loop) |

§Together-they-produce: launch Familiar → form appears in inbox → user fills API key → agent starts.

## Ingest scope

Cycle 210 (designs-lane): full ingest of the 713-line design as one section.

## Related material in the library

- **cycle 208 familiar-bundled-agents**: §complementary-sibling — 208 provides delivery; this provides configuration.
- **`daemon-form-request.md`** (not yet ingested): form primitives used for the configuration form.
- **`daemon-value-message.md`** (not yet ingested): value messages used as the reply mechanism for form submissions.
- **`lal-reply-chain-transcripts.md`** (not yet ingested): transcript node store used by Lal worker loops.
- **`daemon-capability-persona.md`** (not yet ingested): delegate/epithet system; each worker guest is a distinct persona.
- **cycle 121 endopi**: sibling agent-shape comparison; Lal and Fae are referenced.
- **cycle 196 endoclaw**: §three-named-attacks-with-three-structural-defenses sibling for §named-consent-or-defense-mechanisms.
- **cycle 200 worker-rust-xs**: §three-numbered-problems each with named defense sibling — both designs use §problem-defense-enumeration Problem-section shape.
- **cycle 202 endor-run-expanded**: §root-hash-printed-to-stderr-for-re-run sibling — both designs §use-existing-substrate-as-handle-storage; cycle 210's §inbox-as-durable-config-store is the same pattern at a different layer.
- **cycle 175 endo--packages-harden-make-selector**: §pin-on-first-install — sibling discipline (§use-existing-mechanism-as-anchor).
- **cycle 178 daemon-xs-worker-snapshot**: §Revised-scope-2026-04-15 sibling — §honest-design-evolution-between-decision-and-implementation.
- **cycle 198 patterns-diagnostic-feedback**: §three-revision-pivots sibling — both designs §evolve-during-implementation; cycle 210 has the §decision-revised-during-implementation shape.
- **cycle 206 inventory-cancel-and-liveness**: §ASCII-visual-layout-diagram sibling.
- **cycle 200 worker-rust-xs**: §ASCII-architecture-diagram sibling.
