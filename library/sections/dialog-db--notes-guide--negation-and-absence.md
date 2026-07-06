---
title: Negation and absence — why you cannot negate an optional field or narrow from it
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

> Abstract: How `Absent` interacts with `unless` (negation, which filters a row when its inner query has at least one match). Given a `club/banned` fact for `"Ali"` and a rule negating banned nicknames: Alice's nickname is banned so she is filtered, but Bob passes because his `Absent` binding matches nothing — `club/banned` is a scalar fact lookup whose value slot demands a present value, and a person with no nickname cannot have a banned one (the same filter-by-default semantics arriving by another road). Two corollaries. **You cannot negate an optional field**: its lookup always yields a row once the entity is bound (`Present` or `Absent`), so negating something that always matches makes the rule vacuously false — the analyzer rejects it (`NegatedOptional`), and what you meant is to negate the *scalar* lookup (`unless person/nickname(?person, _)`) or the *concept* (`unless Person { this: ?person, .. }`). **Negation does not narrow types**: the inner `club/banned` demands a present `?nickname`, but if that demand counted as evidence about surviving rows, inference would tighten the optional lookup into a required one and drop Bob before the negation ran; the rule says "unless the nickname is banned", not "must have a nickname, and it must not be banned". So narrowing is computed from positive premises only — what a negated subquery demands says nothing about the rows that survive it (the reverse direction is design-note territory: `notes/polarity-and-negation.md`).

`unless` filters a row when its inner query has at least one match. With one more fact in the store:

```text
the           of     is
club/banned   club   "Ali"
```

and the rule body:

```rust
// Person { name: ?name, nickname: ?nickname }
// unless club/banned(_, ?nickname)
```

| row   | `?nickname` | inner query                  | verdict |
|-------|-------------|------------------------------|---------|
| alice | `"Ali"`     | finds `club/banned _ "Ali"`  | filtered (banned) |
| bob   | `Absent`    | matches nothing              | passes |

Alice's nickname is banned, so she is filtered. Bob passes because an `Absent` binding matches nothing: `club/banned` is a scalar fact lookup, its value slot demands a present value, and Bob's row carries the claim that there is no value. A person with no nickname cannot have a banned one. (The same holds in positive position: a scalar premise receiving an `Absent` binding filters the row, the filter-by-default semantics from the previous section arriving by another road.)

## You cannot negate an optional field

An optional field's lookup always yields a row once its entity is bound: `Present` when the fact exists, `Absent` when it does not. Negating something that always matches filters every row, making the rule vacuously false, so the analyzer rejects it at compile time (`NegatedOptional`). What you almost certainly meant is one of:

```rust
// "the entity has no nickname fact": negate the scalar lookup
// unless person/nickname(?person, _)

// "the entity is not a Person": negate the concept
// unless Person { this: ?person, .. }
```

## Negation does not narrow types

The banned-nicknames rule also shows why a negated premise must stay out of the rule's type narrowing. The inner `club/banned` lookup demands a present `?nickname`. If that demand counted as evidence about the rule's rows (the way a formula's demand does), inference would conclude that every row has a present nickname, the optional lookup would tighten into a required one, and Bob would be dropped before the negation ever ran. The rule says "unless the nickname is banned", not "must have a nickname, and it must not be banned"; if you want the second meaning, write it explicitly with a required field.

So narrowing is computed from positive premises only: what a negated subquery demands says nothing about the rows that survive it. The finer points, including the reverse direction (whether positive narrowing should flow *into* a negated subquery), are design-note territory rather than user-facing behavior: see `notes/polarity-and-negation.md`.

Source: [notes/guide.md](https://github.com/dialog-db/dialog-db/blob/3cd6607aa9e6f70d65bafe7692e1a52b953e1faf/notes/guide.md) at commit `3cd6607a`.
