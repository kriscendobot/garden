---
title: Facts as atomic units
source: notes/architecture overview.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query, local-first-sync]
status: current
---

> Abstract: At the core of DialogDB is the **fact** — an atomic, immutable unit of knowledge. Facts are never modified; the database only ever grows by adding new facts that may succeed previous ones. Even "deleting" data adds a **retraction** fact marking the previous fact as no longer valid. Each fact is a causally-related semantic quadruple: `the` (entity, the subject being described), `of` (attribute, the property), `is` (value), and `cause` (an optional reference to a fact being succeeded, establishing causality). This is the storage-layer statement of the same `{the, of, is, cause}` claim the concept model's associative layer exposes.

At the core of DialogDB is the concept of **facts** — atomic, immutable units of knowledge. Facts are never modified; instead, the database only ever grows by adding new facts that may succeed previous ones. Even when "deleting" data, the database simply adds a **retraction** fact that marks the previous fact as no longer valid.

Each fact is represented as a causally related semantic triple (quadruple with the cause):

- **Entity (`the`)**: the subject being described.
- **Attribute (`of`)**: the property of the entity.
- **Value (`is`)**: the value of the property.
- **Cause (`cause`)**: optional reference to a fact being succeeded, establishing causality.

(Note the naming convergence with the concept model in `notes/concept.md`, which describes the same `{the, of, is, cause}` claim — the architecture doc labels `the` as "entity" prose-side while `concept.md` binds `the` to the relation and `of` to the entity; both agree the quadruple's fourth member `cause` carries provenance. The claim/fact is the shared atom of the associative layer.)

The append-only, never-modified discipline is what makes every downstream property — temporal history, auditability, content-addressed dedup, and conflict-free merge — available without special machinery: the store only grows.

Source: [notes/architecture overview.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/architecture%20overview.md) at commit `f777fe7c`.
