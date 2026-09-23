---
title: Where errors surface — compile-time meets vs evaluation-time membership
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

> Abstract: The engine has exactly two error surfaces, and only one is reachable from a rule that compiled. **Compile time** (rule construction, whether authored locally or hydrated from the wire) rejects every misalignment between *known* types: a variable demanded as `String` by one slot and a number by another (an empty meet), a required head fed by an optional source, a negated optional lookup, a malformed `Coalesce`, a literal that cannot inhabit a formula's cell — if the knowledge exists to catch a mistake, it is caught here. **Evaluation time has no type errors, only membership**: a row either inhabits the types a premise demands or it is a non-match — a `String` fact under a numeric slot is filtered exactly as a wrong *value* under a pinned constant is, an `Absent` in a scalar slot is filtered, a row whose values cannot share a formula's type variable is filtered; nothing throws and nothing is coerced. The few runtime errors that remain are *contract* violations (an optional lookup scheduled with an unbound entity, a bind outside a variable's kind) — engine or construction-path bugs, unreachable from any compiled rule, kept as defense in depth. Placed against the three corners of the design space: PostgreSQL *errors* at runtime (a bad cast kills the query), SQLite *coerces* (`'abc' + 1 = 1`, occasionally nonsense — its `STRICT` tables exist because of that), and dialog *filters* — keeping SQLite's "a query never dies mid-stream on data" guarantee without ever fabricating a value.

The engine has exactly two error surfaces, and only one of them is reachable from a rule that compiled.

**Compile time** (rule construction, whether authored locally or hydrated from the wire) rejects every misalignment between *known* types: a variable demanded as `String` by one slot and as a number by another (an empty meet), a required head fed by an optional source, a negated optional lookup, a malformed `Coalesce`, a literal that cannot inhabit a formula's cell. If the knowledge exists to catch a mistake, it is caught here.

**Evaluation time has no type errors — only membership.** A row either inhabits the types a premise demands or it is a non-match: a `String` fact under a numeric slot is filtered the same way a wrong *value* under a pinned constant is, an `Absent` in a scalar slot is filtered, and a row whose values cannot share a formula's type variable is filtered. Nothing throws and nothing is coerced. The few runtime errors that remain in the engine are *contract* violations (an optional lookup scheduled with an unbound entity, a bind outside a variable's kind): they indicate an engine or construction-path bug, are unreachable from any rule that compiled, and exist as defense in depth.

For comparison, the three corners of this design space: PostgreSQL *errors* at runtime (a bad cast kills the query); SQLite *coerces* (`'abc' + 1 = 1`, no error, occasionally nonsense — its `STRICT` tables exist because of how that felt in practice); dialog *filters*. Filtering keeps SQLite's ergonomic guarantee — a query never dies mid-stream on data — without ever fabricating a value.

Source: [notes/guide.md](https://github.com/dialog-db/dialog-db/blob/3cd6607aa9e6f70d65bafe7692e1a52b953e1faf/notes/guide.md) at commit `3cd6607a`.
