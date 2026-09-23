---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-16T09:30:26Z
---
---
kind: result
role: decomplector
repo: kriscendobot/endo-but-for-bots
project: endo
---

Design-panel seat `decomplector`, PR #997 (`designs/worker-retention-and-revocation.md` + `designs/README.md`), diff base `16fa8ebcc`, head `f341840e9` (round 4).

### decomplector

**Verdict:** request-changes

**Findings:**

- `designs/worker-retention-and-revocation.md:1150` vs `:519` — worker discipline is placed in two incompatible spots. Design Decision 4 (and the README row) call it "an explicit per-worker constraint on the **incarnation formula**"; Thread 4's own prose calls it "a constraint expressed at **request time**". The document defines a formula (`:26-34`) as the durable, *content-addressed* recipe whose cryptographic name is the formula identifier, so the two placements are not interchangeable: put `WorkerDiscipline` in the formula and it participates in content addressing, which means one source plus endowments under `{kind:'ephemeral'}` and under `{kind:'durable-succession'}` are two distinct formulas with two identifiers and no EQ between them, and "change a worker's discipline" is a rename that strands every edge pointing at the old identifier. That is operational policy braided into value identity, exactly the axis Thread 4 spent its length decomplecting when it replaced the product type with a sum type. Put it on the incarnation request and the formula stays one value while discipline stays a property of the place it runs. Should-fix: pick one and say which, and if it is in the hash, own the rename consequence. [proposed-rule: a design that adds a field to a content-addressed record must state whether the field participates in the content hash and what identity consequence follows from changing it]

- `designs/worker-retention-and-revocation.md:793` / `:999` / `:1281` — the per-root lease now bounds two unrelated intervals through one knob. Q2 mechanism 2 originally bounded "the question never settles"; Q4 extends the same lease across resolution to also bound "the question settled but the counterparty withholds `op:gc-exports`". Different trigger, different counterparty (the local question holder vs. the remote importer), different remedy (reject the question locally vs. forcibly drop a remote retention edge), and different natural time constant (application pipelining depth vs. a network round trip plus the peer's finalizer). The Open Question at `:1281` is the tell: one number must now be calibrated against two distributions, so it is set to the max and is loose for the case it should be tight on, and an operator retuning the stalled-question bound silently retunes the adversarial-import bound. Decomplected form: two independent bounds on the same root, a question lease expiring into a local rejection and a cross-peer-drop lease starting at resolution and expiring into a forced edge drop. Same fail-safe, two knobs, and Q2/Q4 lose the "the lease continues to run across resolution" special case. Should-fix. [proposed-rule: when a bound is extended to cover a second condition with a different trigger, remedy, and time constant, split it into two bounds rather than widening one]

- `designs/worker-retention-and-revocation.md:1102` — the Design Decisions list represents "recommended, pending the maintainer" and "committed constraint" in one shape. The doc opens as a reassessment that is "not a mandate to conclude" and the README sizes it "research doc (no build)", yet the numbered decisions speak in commitment voice ("the extension this design commits to", "this decision commits only that..."). A later implementer cannot tell which numbers bind. Comment-only: a per-decision status token (Recommended / Committed / Deferred), or rename the section Recommendations while Status is Proposed. [proposed-rule: in a Proposed research design, each numbered decision carries an explicit recommended-vs-committed marker]

**Notes (out of scope but worth flagging):**

- `designs/README.md` banner (top of file) says the design was added "to M3 (Remote Access and Coding Capabilities)" and that the "M3 milestone row" was synced, but the row actually landed in the Milestone 4 (Networking) table (`README.md:902`, under the `#### Milestone 4: Networking` heading at `:879`) and the row's own prose reads "Milestone home is M4 (Networking)". The banner contradicts the placement. Scribe/archivist lane, not mine, but it is a concrete factual error in this diff. [rule: designs/AGENTS.md § Progress Tracking]

- Q1's third window (`:750-768`) names a second `@endo/captp` prerequisite (reply with a genuine `CTP_RETURN` rejection on `Unknown export` instead of the silent drop). The Dependencies table's `packages/captp` row records only the question-observation seam. Pedant lane. [rule: designs/AGENTS.md § Dependencies]

- The admission cap over the transitively pinned closure makes wire-visible admissibility depend on exporter-side union-find topology. The doc names the ergonomic cost honestly and the retained set genuinely is the group, so I read this as essential rather than accidental complexity and raise no finding.

Self-improvement: nothing this time. The seat brief's "stop at the boundary of what the design claims" discipline was the operative constraint on this round (it kept the union-find admission-cap observation out of the findings list), and it is already written in `roles/jurors/decomplector/AGENT.md`.
