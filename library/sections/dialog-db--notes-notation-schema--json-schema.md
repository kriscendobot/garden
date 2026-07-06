---
title: Dialog notation JSON schema
source: notes/notation/schema.json
source_repo: dialog-db/dialog-db
source_commit: bde506d786a080291051b2e069cabe38cda769b2
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: The machine-readable definition of Dialog's **formal notation** — a JSON Schema (draft 2020-12, `$id: https://gozala.io/schema/dialog/notation/schema.json`) whose `$defs` graph is the authoritative shape the notation reference (`notes/notation.md`) prose describes. Root types: **Attribute** (`the` required, `maxLength: 64`, pattern `^[a-z][a-z0-9.-]*[a-z0-9]?/[a-z][a-z0-9-]*[a-z0-9]?$`; `cardinality` via **Cardinality** enum `one`/`many` default `one`; `as` via **Assert** = `oneOf` **ScalarType** | **ConceptRef** | **SymbolEnum**, the latter two future extensions). **Concept** (`with`/`maybe` via **NamedRelations** mapping field names to inline **Attribute** or string **AttributeRef**). **Rule** (`deduce` a Concept, `when` array of **Premise** minItems 1, optional `unless`); a **Premise** pairs `assert` (`oneOf` Concept | **FormulaRef** | **ConstraintRef**) with `where` mapping to **Term** (`oneOf` **Variable** `{ "?": {...} }` | **Constant**). **FormulaRef** enumerates all 13 built-in formulas; **ConstraintRef** enumerates `==`. **MathFormula**/**TextFormula**/**LogicFormula**/**EqualityConstraint** carry the per-formula parameter shapes. **Claim**/**Provenance** define the associative-layer stored fact `{the, of, is, cause{by, period, moment}}`.

The companion JSON Schema to `notes/notation.md`. It is the normative definition of the formal notation the reference document narrates; where the prose and the schema both describe a type (Attribute, Concept, Rule, Premise, Term, Variable, Constant, Claim, Provenance, the formula/constraint families), they agree, and the `<details>` blocks in the prose are excerpts of these same `$defs`.

Header: `$schema` draft 2020-12; `$id` `https://gozala.io/schema/dialog/notation/schema.json`; title "Dialog Schema"; description "Schema for Dialog domain modeling: attributes, concepts, rules, formulas, and relations."

Definition graph (`$defs`):

- **Attribute** — `the` (required; the relation in `domain/name` format; `maxLength: 64`; `pattern` `^[a-z][a-z0-9.-]*[a-z0-9]?/[a-z][a-z0-9-]*[a-z0-9]?$`), `cardinality` (`$ref` **Cardinality**), `as` (`$ref` **Assert**), `description`.
- **Cardinality** — string enum `["one","many"]`, default `one`. `one` retracts the prior claim; `many` accumulates.
- **Assert** — `oneOf` **ScalarType** | **ConceptRef** | **SymbolEnum** (only scalar types currently supported; the latter two are planned).
- **ScalarType** — string enum `Bytes | Entity | Boolean | Text | UnsignedInteger | SignedInteger | Float | Symbol`. `Text` is shorthand for `dialog/Text`, etc.
- **ConceptRef** — string, pattern `^[a-zA-Z]`; dot-prefixed (`.Ingredient`) or fully qualified (`diy.cook/Ingredient`). *(Future extension.)*
- **SymbolEnum** — array of fully-qualified symbol strings, `minItems: 1`. *(Future extension.)*
- **Concept** — `with` (required, `$ref` **NamedRelations**, `minProperties: 1`), `maybe` (**NamedRelations**, future extension), `description`.
- **NamedRelations** — object; each value is `oneOf` **Attribute** (inline) | **AttributeRef** (string path).
- **AttributeRef** — string; `.` = same-named attribute under the current domain, `.name` resolves within the current domain, `domain/name` fully qualified.
- **Rule** — `deduce` (required, `$ref` **Concept**), `when` (required, array of **Premise**, `minItems: 1`), `unless` (array of **Premise**), `description`.
- **FormulaRef** — string enum of the 13 built-ins: `math/{sum,difference,product,quotient,modulo}`, `text/{concatenate,length,upper-case,lower-case,like}`, `boolean/{and,or,not}`.
- **ConstraintRef** — string enum `["=="]`.
- **Premise** — `assert` (required; `oneOf` **Concept** | **FormulaRef** | **ConstraintRef**), `where` (object; additionalProperties `$ref` **Term**).
- **MathFormula** / **TextFormula** / **LogicFormula** — objects keyed by each formula name, giving that formula's parameter properties (each a **Term**) and its required output list.
- **EqualityConstraint** — `this` / `is` **Term**s (both required); referenced as `==` in a premise's `assert`.
- **Term** — `oneOf` **Variable** | **Constant**.
- **Variable** — object with required `?`; the `?.name` string names the variable, omitted ⇒ a blank wildcard.
- **Constant** — `oneOf` string | number | integer | boolean.
- **Claim** — `the` / `of` / `is` / `cause` (all required); `is` is `oneOf` string/number/integer/boolean; `cause` `$ref` **Provenance**.
- **Provenance** — `by` (string DID), `period` (integer ≥ 0), `moment` (integer ≥ 0), all required.

Source: [notes/notation/schema.json](https://github.com/dialog-db/dialog-db/blob/bde506d786a080291051b2e069cabe38cda769b2/notes/notation/schema.json) at commit `bde506d7`.
