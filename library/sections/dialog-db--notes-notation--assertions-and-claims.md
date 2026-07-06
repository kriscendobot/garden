---
title: Assertions and claims
source: notes/notation.md
source_repo: dialog-db/dialog-db
source_commit: bde506d786a080291051b2e069cabe38cda769b2
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: Tools write to the associative layer by submitting **assertions** (a relation holds) and **retractions** (it no longer does). Once the transactor incorporates an assertion it becomes a **claim** — the fundamental stored unit. An assertion names a relation (`the`), an entity (`of`), and a value (`is`); assertions need no attribute defined in advance because the associative layer merely accretes and never validates, enforces, or interprets. An optional `cause` field on an assertion is a causal reference to the provenance of a prior claim this assertion intends to *succeed*: absent ⇒ additive, no succession; present ⇒ the transactor resolves succession over the same entity-attribute pair. An incorporated claim records full provenance in `cause = { by, period, moment }`: `by` the producing authority (DID), `period` the last synchronization cycle (coordinated time), `moment` local ordering within that period (uncoordinated time) — together a partial order across the distributed system. This is the notation-level view of the `{the, of, is, cause}` fact.

Tools interact with the associative layer by submitting **assertions** and **retractions**. An assertion proposes that a relation holds; a retraction proposes that it no longer does. Once the transactor incorporates an assertion, it becomes a **claim**, the fundamental unit of information stored in the associative layer.

An assertion specifies a relation (`the`), an entity (`of`), and a value (`is`):

```yaml
assert!:
  the: diy.cook/quantity
  of:  did:key:zCarrot
  is:  2
```

Assertions can be made without defining attributes in advance. The associative layer simply accretes; it does not validate, enforce, or interpret.

An assertion may carry an optional `cause` field: a causal reference to the provenance of a prior claim this assertion intends to succeed. When `cause` is absent, no succession is intended and the assertion is additive. When present, the transactor resolves succession based on the existing claims for the same entity-attribute pair.

Once incorporated by the transactor, a claim records the full provenance of its production:

```yaml
the: issue/assignee
of:  did:key:zIssue42
is:  did:key:zDana
cause:
  by: did:key:zWork
  period: 4
  moment: 1
```

The `cause` on a claim captures when and where it was produced: `by` identifies the producing authority (the DID of the operator or session authority), `period` reflects the last synchronization cycle, and `moment` captures local ordering within that period. Together they establish a partial order across the distributed system.

Schema (`Claim`): required `the` (relation), `of` (entity), `is` (value: string, number, integer, or boolean), and `cause` (`Provenance`). `Provenance`: required `by` (string DID), `period` (integer ≥ 0), `moment` (integer ≥ 0).

Source: [notes/notation.md](https://github.com/dialog-db/dialog-db/blob/bde506d786a080291051b2e069cabe38cda769b2/notes/notation.md) at commit `bde506d7`.
