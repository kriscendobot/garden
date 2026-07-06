---
title: Absent is a claim, not a hole — and why a concept needs a required attribute
source: notes/guide.md
source_repo: dialog-db/dialog-db
source_commit: 3cd6607aa9e6f70d65bafe7692e1a52b953e1faf
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: `Absent` is a positive claim about the store ("this entity has no such fact"), not a null hole. A variable in a row is in one of three states — **unbound** (nothing has looked), **`Present(v)`** (known to be `v`), **`Absent`** (*we looked, and there is no value*) — and the difference between unbound and `Absent` carries real information. Exactly one construct produces `Absent`: the optional lookup behind a concept's optional field (`OptionalAttributeQuery` internally); nothing else manufactures it and nothing ever stores it. This is why the optional lookup *requires the entity to be bound before it runs* — "Absent" answers "absent for whom?", meaningless without a concrete entity — and the planner enforces this structurally so an optional field's lookup can never lead an unbound scan; otherwise the lookup would silently degrade to an inner join and drop every entity lacking the fact, a correctness property hostage to the alphabetical position of a field name. It also forces the rule that **a concept must have at least one required attribute**: an all-optional concept is rejected at compile time (`TypeError::EmptyConcept`) because it would match everything (each optional field widens rather than constrains) and because nothing would bind the entity. The optional lookup's four behaviors (unbound + fact → `Present`; unbound + none → one `Absent` row; pinned `Present` mismatch → no row; upstream `Absent` contradicted or confirmed by the store) all fall out of reading `Absent` as a claim.

A variable in a row is in one of three states:

| state        | meaning                                  |
|--------------|------------------------------------------|
| unbound      | not yet known; nothing has looked        |
| `Present(v)` | known to be `v`                          |
| `Absent`     | *we looked, and there is no value*       |

The difference between unbound and `Absent` carries real information. `Absent` is a positive claim about the store ("this entity has no such fact"), produced by exactly one construct: the optional lookup behind an optional concept field (`OptionalAttributeQuery` internally). Nothing else in the engine manufactures `Absent`, and nothing ever stores it.

This is why the optional lookup *requires the entity to be bound* before it runs. "Absent" answers the question "absent for whom?", which is meaningless without a concrete entity. The planner enforces this structurally: an optional field's lookup can never lead an unbound scan; some required premise must bind the entity first.

If the planner did not enforce this, an optional field's lookup could end up leading the scan whenever it happened to sort first among the concept's fields. With no concrete entity there is nothing sound to report `Absent` *about*, so the fallback would have to be suppressed, and the lookup would silently degrade to an inner join: every entity lacking the optional fact would vanish from the result, based on nothing more than the alphabetical position of a field name. A correctness property must not depend on what you happened to name your fields.

## Why a concept must have at least one required attribute

A concept whose fields are *all* optional is rejected at compile time (`#[derive(Concept)]` fails to build it, and the dynamic constructors return `TypeError::EmptyConcept`). Two independent reasons, both falling out of the rules above:

1. **It would match everything.** Each optional field widens rather than constrains: any entity either has the fact (`Present`) or does not (`Absent`), so every entity in the store satisfies every optional field vacuously. An all-optional concept would be the concept of "anything at all", and a query for it would enumerate the universe.
2. **Nothing would bind the entity.** Every optional field's lookup requires `this` already bound, and in an all-optional concept there is no required field to bind it. The body would be unplannable by its own rules.

The required fields therefore do double duty: they are what gives the concept a meaning (they constrain which entities match), and they are what binds `this` so the optional fields have a concrete entity to report absence about.

The optional lookup itself has four behaviors, all consequences of reading `Absent` as a claim:

| input row state for `?nickname` | facts for the entity | output |
|---------------------------------|----------------------|--------|
| unbound                         | `"Ali"`              | row with `Present("Ali")` |
| unbound                         | none                 | one row with `Absent` |
| `Present("Al")` (pinned)        | `"Ali"` (mismatch)   | no row; a mismatch is *not* absence |
| `Absent` (claimed upstream)     | `"Ali"`              | no row; the fact contradicts the claim |
| `Absent` (claimed upstream)     | none                 | row passes; the store confirms the claim |

Source: [notes/guide.md](https://github.com/dialog-db/dialog-db/blob/3cd6607aa9e6f70d65bafe7692e1a52b953e1faf/notes/guide.md) at commit `3cd6607a`.
