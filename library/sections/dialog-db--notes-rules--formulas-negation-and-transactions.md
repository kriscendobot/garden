---
title: Formulas, attribute expressions, negation, and writing data in rules
source: notes/rules.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: Four ways rule bodies reach past plain concept patterns. **Formulas** appear as premises that compute derived values from bound variables (a `Concatenate` premise builds a greeting string from a bound `name`). **Attribute expressions** — the `the!("person/name").of(entity).is(value)` builder — let a rule work directly with the associative claim model without defining a wrapping concept. **Negation** uses the `!` prefix on a premise (an attribute expression or a concept query): the rule matches only when the negated pattern does *not* hold, subject to the grounding rule that a negated premise's variables also appear positively. **Writing data** is done through transactions on a `Session`: `tx.assert(...)` and `tx.retract(...)` stage concept-shaped facts, and `session.commit(tx).await?` applies them.

**Using formulas in rules.** Formulas can be used as premises to compute derived values from bound variables:

```rs
fn greeting_rule(greeting: Query<Greeting>) -> impl When {
    (
        Query::<Employee> {
            this: greeting.this.clone(),
            name: Term::var("name"),
            role: Term::blank(),
        },
        Query::<Concatenate> {
            first: "Hello, ".to_string().into(),
            second: Term::var("name"),
            is: greeting.message,
        },
    )
}
```

**Using attribute expressions in rules.** Attribute expressions can be used directly as premises, allowing rules to work with the associative model without defining a concept:

```rs
fn employee_from_relations(employee: Query<Employee>) -> impl When {
    (
        the!("person/name")
            .of(employee.this.clone())
            .is(employee.name.clone()),
        the!("person/role")
            .of(employee.this.clone())
            .is(employee.role.clone()),
    )
}
```

**Negation.** Use `!` to negate a premise. The rule matches only when the negated pattern does *not* hold:

```rs
fn employee_without_role(employee: Query<Employee>) -> impl When {
    (
        the!("person/name")
            .of(employee.this.clone())
            .is(employee.name.clone()),
        // Entity must NOT have a role claim
        !the!("person/role")
            .of(employee.this.clone())
            .is(Term::<String>::blank()),
        employee.role.is(employee::Role("unknown".into())),
    )
}
```

Concept queries can also be negated (`!Query::<Manager> { ... }`), matching only entities for which the negated concept does not hold.

**Writing data.** Use transactions to assert and retract facts:

```rs
let mut tx = session.edit();
tx.assert(Employee {
    this: alice.clone(),
    name: employee::Name("Alice".into()),
    role: employee::Role("cryptographer".into()),
});
session.commit(tx).await?;

// Retract
let mut tx = session.edit();
tx.retract(Employee {
    this: alice,
    name: employee::Name("Alice".into()),
    role: employee::Role("cryptographer".into()),
});
session.commit(tx).await?;
```

Source: [notes/rules.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/rules.md) at commit `f777fe7c`.
