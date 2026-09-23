---
title: Consuming an optional value — filter by default, Coalesce for a default
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

> Abstract: When an optional `?value` flows into a context that demands a present value (a formula like `math/sum`), the rule-level type inference *narrows* the variable: rows where it is `Absent` cannot satisfy the formula, so they are excluded — people without an age simply do not appear, no error and no `Absent` reaching the formula. This is ordinary relational semantics (a premise is a predicate; one that demands presence filters rows lacking it, the same way the scalar nickname lookup filtered Bob), best read as occurrence typing: using `?age` where a number is required *is* the evidence of presence, parallel to `?x.text()`, `?x.starts_with("did:")`, or `?x.less_than(?y)` narrowing their operands. The planner exploits the narrowing — when a sibling premise guarantees presence, the optional lookup can never take its `Absent` branch and is *demoted* to a plain scalar scan (same semantics, less work). If filtering is not wanted, `unwrap_or` (the `Coalesce` constraint) is the one operator that *consumes* an `Absent` and produces a present value (substituting a default like `"Anon"`); filter-vs-default is the one intent the engine cannot infer, so the relationally-natural filter is the default and `Coalesce` is the explicit opt-in. `Coalesce`'s `source` is a *hard dependency* — scheduled only after the premise resolving the variable — because otherwise the cheap constraint would run first, an unbound source would be indistinguishable from an absent one, and the default would shadow real values; an unbound source at evaluation time is therefore an error, never a silent fallback.

What happens when `?nickname` flows into a context that demands a present value, say a formula?

```rust
// person: required name, optional age
// then: math/sum { of: ?age, with: 1, is: ?next }
```

The rule-level type inference sees that `math/sum` demands a present number for `?age`. It *narrows* the variable: rows where `?age` is `Absent` cannot satisfy the formula, so they are excluded. People without an age simply do not appear in the result. No error, no `Absent` reaching the formula.

This is ordinary relational semantics. A premise is a predicate on the row set, and a predicate that demands presence filters rows lacking it, exactly the way the scalar nickname lookup filtered Bob. Think of it as occurrence typing: using `?age` in a context that requires a number *is* the evidence of presence, the same way the `?x.text()` type predicate narrows `?x` to strings, or `?x.starts_with("did:")` narrows it to the textual kinds a literal prefix could begin, or `?x.less_than(?y)` narrows both sides to numbers.

The planner exploits the narrowing: when inference proves a sibling premise guarantees the value is present, the optional lookup can never take its `Absent` branch, so it is *demoted* to a plain scalar scan. Same semantics, less work.

If filtering is not what you want, say so explicitly with a default:

```rust
let nickname: Term<Option<String>> = Term::var("nickname");
let display: Term<String> = Term::var("display");
nickname.unwrap_or("Anon".to_string()).is(display)
```

`unwrap_or` (the `Coalesce` constraint) is the one operator that *consumes* an `Absent` and produces a present value from it:

```text
?person   ?nickname        ?display
alice     Present("Ali")   "Ali"
bob       Absent           "Anon"
```

The choice between "filter rows missing the value" and "substitute a default" is the one intent the engine cannot infer, so the default is the relationally natural filter, and `Coalesce` is the explicit opt-in for defaults.

## Coalesce is ordered after its source

The coalesce's `source` slot is a *hard dependency*: the planner schedules the constraint only after the premise that resolves `?nickname` (to `Present` or to `Absent`) has run. This matters because the constraint is very cheap, so a greedy planner would otherwise love to schedule it first, and if it ran before the lookup, an unbound source would be indistinguishable from an absent one: `"Anon"` would shadow Alice's real nickname on every row. For the same reason, an unbound source at evaluation time is an error, never a silent fallback; silently substituting the default is precisely the failure mode the ordering rule exists to prevent.

Source: [notes/guide.md](https://github.com/dialog-db/dialog-db/blob/3cd6607aa9e6f70d65bafe7692e1a52b953e1faf/notes/guide.md) at commit `3cd6607a`.
