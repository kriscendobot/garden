---
title: Defining deductive rules — grounding, premise ordering, installation
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

> Abstract: A deductive rule derives new concepts from existing data, Datalog-style. A rule is a function that takes a `Query<T>` pattern for the conclusion and returns an `impl When` describing the premises — a tuple of patterns that must all hold for the conclusion to be derived. Two structural constraints follow the Datalog tradition. **Grounding:** every variable in the conclusion must be bound by at least one positive premise, and every variable in a negated premise must also appear in a positive premise, so derived facts are always grounded in existing data (`.install()` returns an error on violation). **Premise ordering does not matter** — the query planner reorders premises during compilation for optimal execution. Rules are installed into a `Session` with `.install()`, which compiles and validates the rule; thereafter querying the conclusion concept also finds facts derived through the rule.

Deductive rules derive new concepts from existing data (Datalog-style inference). Attributes and concepts are defined with derive macros:

```rs
mod employee {
    #[derive(Attribute, Clone, PartialEq)]
    pub struct Name(pub String);

    #[derive(Attribute, Clone, PartialEq)]
    pub struct Role(pub String);
}

#[derive(Concept, Debug, Clone, PartialEq)]
pub struct Employee {
    pub this: Entity,
    pub name: employee::Name,
    pub role: employee::Role,
}
```

A rule is a function that takes a `Query<T>` pattern for the conclusion and returns an `impl When` describing the premises. The premises are a tuple of patterns that must all hold for the conclusion to be derived:

```rs
fn employee_from_contractor(employee: Query<Employee>) -> impl When {
    (
        Query::<Contractor> {
            this: employee.this.clone(),
            name: employee.name.clone(),
            position: employee.role.clone(),
        },
    )
}
```

**Grounding.** Following Datalog's grounding requirement, every variable used in the conclusion must be bound by at least one positive premise, and every variable in a negated premise must also appear in a positive premise. This ensures that derived facts are always grounded in existing data. If these conditions are not met, `.install()` returns an error as rule validation fails.

**Premise ordering.** The order of premises in a rule body does not matter. The query planner reorders them during compilation for optimal execution.

**Installing rules.** Rules are installed into a `Session` with `.install()`, which compiles and validates the rule:

```rs
let session = Session::open(artifacts)
    .install(employee_from_contractor)?;

// Now querying Employee will also find conclusions derived from Contractor
let employees = Query::<Employee>::default()
    .perform(&session)
    .try_vec()
    .await?;
```

Source: [notes/rules.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/rules.md) at commit `f777fe7c`.
