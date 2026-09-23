---
title: Options considered, and how Automerge and Datomic handle it
source: notes/causal-information-design-decision.md
source_repo: dialog-db/dialog-db
source_commit: 6cc234ab767985e44b68090143ac33027fafb158
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [change-propagation, datalog-query]
status: current
---

> Abstract: Three options for surfacing causal information, weighed against prior art. **Option 1 — custom primitive types** (`Text(String, Cause)`, `UnsignedInteger(u128, Cause)`): leaks infrastructure into the domain model, imposes a closed type set, and carries a 32-byte `Cause` hash for every scalar even though most tools won't need it. **Option 2 — a `Proof<T>` wrapper** where the query returns `Proof<M> { value: M::Type, provenance: M::Provenance }` (attribute provenance = `Cause`, concept provenance = a generated per-field-cause struct): clean separation, keeps the derive macros domain-focused, composes with cardinality-many (an iterator of `Proof<Assignee>` each with its own cause), but makes every tool author pay the cognitive cost of `Proof<T>` even when never needed. **Option 3 — weakened consistency (value-based CAS)**: don't surface causal info by default; tell the transactor the *value* a change is based on rather than the *cause*. This works for the modeling-note cardinality cases (the transactor inspects the claim set at write time) but can't distinguish two origins asserting the *same value* at different times for different reasons — a window that is extremely narrow in the primary deployment scenario (a service-worker local transactor with the UI main-thread submitting over a message channel — single-writer, where a remote sync landing between a UI read and its edit is rare) and not clearly actionable even when it occurs. Prior art: **Automerge** sidesteps CAS entirely (CRDT merge, no rejection, no staleness check), while **Datomic**'s built-in `:db/cas` is *value-based* (`[:db/cas e a old new]`, aborts if the current value isn't `old`) — chosen over version/tx-id CAS because "the value is what application logic actually depends on," and Datomic, like Dialog's local transactor, has a single serialized transactor giving linearized transactions with eventual consistency across replicas.

## Option 1: Custom Primitive Types

Replace built-in types with Dialog-specific wrappers that carry `Cause` (`pub struct Text(String, Cause)`, `pub struct UnsignedInteger(u128, Cause)`). This leaks infrastructure into the domain model — every attribute carries provenance concerns even when the author just wants to model their domain. It would also impose a closed set of supported types (already the case). The real concern: carrying a 32-byte `Cause` hash for every single scalar feels excessive when most tools won't need it.

## Option 2: Proof Wrapper Type

Query returns `Proof<T>` instead of `T`, where the macro generates parallel value and provenance structures:

```rs
pub struct Proof<M: Model> { value: M::Type, provenance: M::Provenance }
```

For attributes: `Type = String`, `Provenance = Cause`. For concepts: `Type = Employee`, `Provenance = EmployeeProvenance` (a generated struct with per-field causes). This gives clean separation: the derive macros stay domain-focused, and `Proof` is a query-time concern. It composes well with cardinality-many (an iterator of `Proof<Assignee>`, each with its own cause). The downside: every tool author pays the cognitive cost of understanding `Proof<T>` even if they never need causal information.

## Option 3: Weakened Consistency (Value-Based CAS)

Don't surface causal information by default. Instead of telling the transaction the `cause` a change is based on, tell it the `value` it's based on. This works for the cardinality cases in the modeling note: the transactor inspects the claim set at write time and applies sole-claim vs multi-claim rules without the submitter providing cause. It does *not* let the transactor differentiate when two different origins assert the *same value* at different times for different reasons — but in practice this window is extremely narrow in the primary deployment scenario, and even when it occurs the application's options (silently retry, or surface an error) don't produce meaningful benefit: silent retry for an unchanged value is incidental complexity, and a user-facing error is hard to build reasonable UX around.

### Primary deployment scenario

The near-term primary target is a service worker acting as the local transactor, with the main thread (UI) submitting queries and edits over a message channel. This is a single-writer setup where the transactor enforces consistency across local views. The window for a remote sync to land between a UI read and the subsequent edit submission is extremely narrow. Eventual consistency across replicas is a separate concern, reconciled at sync time based on what revision changes were made against.

## How other systems handle this

### Automerge

Automerge sidesteps CAS entirely. Changes compose via CRDT merge rules with no rejection and no staleness check. Concurrent writes to the same scalar key resolve deterministically, one value wins, and the API never asks the caller for a causal reference. It supports cross-thread communication (repo in a worker, UI in main thread via `MessageChannelNetworkAdapter`), but the design assumes all changes eventually merge — there is no concept of rejecting a stale write. Dialog's causal assertions instead express *intent* (which prior claim to succeed), enabling the cross-tool cardinality resolution where tools with different cardinality assumptions cooperate without a shared schema.

### Datomic

Datomic has a built-in `:db/cas` that is **value-based**: `[:db/cas entity attribute old-value new-value]`. It checks whether the entity currently has the expected old value and, if so, expands to retract + assert; otherwise the transaction aborts. Datomic could have done version- or tx-id-based CAS (it has full history and transaction IDs) but chose value-based as the built-in, reasoning that the value is what application logic actually depends on. An important architectural similarity: Datomic has a single serialized transactor giving linearized transactions — Dialog's local transactor works the same way as a single writer enforcing consistency across local views, with eventual consistency across replicas reconciled by revision, similar to Automerge's sync model.

Source: [notes/causal-information-design-decision.md](https://github.com/dialog-db/dialog-db/blob/6cc234ab767985e44b68090143ac33027fafb158/notes/causal-information-design-decision.md) at commit `6cc234ab`.
