---
title: Abbreviated notation — deductive rules
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

> Abstract: How the abbreviated notation writes deductive rules. Rules use the enclosing-key structure for naming and domain scoping; premises in `when` and `unless` use a compact syntax that expands into the formal concept-based premise form. **Concept matching** — a concept reference in a premise matches entities satisfying that concept, and a named concept's fields map to `where` bindings (`?name` is the variable shorthand). **Constraints** — the equality `==` premise asserts two terms hold equal values (`- ==: { this: ?name, is: Alice }`). **Formulas** — referenced by name with parameters as bindings (`- math/sum: { of: ?qty, with: ?qty, is: ?doubled }`). **Negation** — `unless` filters out results where a pattern can be satisfied (e.g. a `SafeMeal` deduced from a `PlannedMeal` `unless` an `AllergyConflict` holds for the same person and recipe). Each abbreviated rule form has a defined expansion into the verbose formal `deduce`/`when`/`unless` shape.

In abbreviated notation, rules use the enclosing key structure for naming and domain scoping. Premises in `when` and `unless` use a compact syntax that expands into the formal concept-based premise form.

### Concept matching

A concept reference in a premise matches entities that satisfy that concept. A rule keyed under `diy.cook: { Ingredient: { deduce: {...}, when: [...] } }` lists premises as `- diy.cook/ingredient-name: { this: ?this, is: ?name }`, which expand to full `{ assert: { with: {...} }, where: {...} }` premises binding `?this`/`?name` as variables.

When a premise references a named concept, the concept's fields map to `where` bindings:

```yaml
org.example:
  employee-from-person:
    deduce:
      Employee:
        name: ?name
        role: ?role
    when:
      - org.example/Person:
          name: ?name
          title: ?role
```

### Constraints

Constraints restrict variable bindings. The equality constraint `==` asserts that two terms must hold equal values:

```yaml
    when:
      - org.example/Person:
          name: ?name
          title: ?role
      - ==:
          this: ?name
          is: Alice
```

### Formulas

Formulas compute derived values. They are referenced by name with their parameters as bindings:

```yaml
    when:
      - diy.cook/quantity:
          this: ?this
          is: ?qty
      - math/sum:
          of: ?qty
          with: ?qty
          is: ?doubled
```

### Negation

`unless` filters out results where a given pattern can be satisfied:

```yaml
diy.planner:
  safe-meal:
    deduce:
      SafeMeal:
        attendee: ?person
        recipe: ?recipe
        occasion: ?occasion
    when:
      - diy.planner/PlannedMeal:
          attendee: ?person
          recipe: ?recipe
          occasion: ?occasion
    unless:
      - diy.planner/AllergyConflict:
          person: ?person
          recipe: ?recipe
```

If any attendee has an allergy conflict with a recipe, that meal is excluded from the results.

Source: [notes/notation.md](https://github.com/dialog-db/dialog-db/blob/bde506d786a080291051b2e069cabe38cda769b2/notes/notation.md) at commit `bde506d7`.
