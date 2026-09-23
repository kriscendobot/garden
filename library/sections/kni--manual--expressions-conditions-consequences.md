---
title: Expressions, variables, and options with conditions and consequences
source: MANUAL.md
source_repo: kriskowal/kni
source_commit: 120fd885f15c2b0d9b2def4faa113b1a0a4e87ca
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring, automatic-agentic-loop]
status: current
---

Abstract: The state and expression model. kni supports limited 32-bit-integer algebra with three precedence tiers, comparison/logical operators, and a function library (floor, round, abs, trig, pow, log, min/max/mean, distance, plus the novel unary `~` random, unary `#` hash, and binary `#` Hilbert). Variable names are words and dots, with brace-interpolated dynamic names (`point.{x}.{y}`). Load-bearing for the agent-context lens is the *conditions-and-consequences* option vocabulary: `{+n}`/`{-n}`/`{!n}`/`{?n}`/`{=m n}` each combine a guard (hide the option unless a state predicate holds) with a mutation (apply when chosen) — so an option is simultaneously a precondition check and a state transition, the crafting/inventory/lock primitive.

**Expressions.** kni supports limited algebraic expressions, sometimes needing parentheses to disambiguate precedence. All operators produce 32-bit integers; logical operators return 0 or 1. Precedence, tight to loose: unary `not` / `-` / `~` / `#`; then `*` `**` `/` `%` `~`; then `+` `-`; then comparisons `<` `<=` `==` `!=` `>=` `>`; then `and`; then `or`.

Notable operators: `**` exponentiation, `%` modulo, `and`/`or` logical, unary `not` negation. Unary `~` produces a random variable from 0 to less than the operand; binary `~` is a sampled random variable — in `x~y`, X is the number of samples and Y the per-sample upper bound, so `2~6` yields `[0, 12)` with a mean of 6 (the D&D `2d6` is `1~6 + 1~6 + 2`). Unary `#` is a consistent hash (same input → same pseudo-random output); binary `#` maps a coordinate to its point on a Hilbert curve, useful with `#` hash blocks for arbitrary-but-consistent 2-D content without accidental symmetry.

Functions: `floor`, `ceil`, `round`, `abs`, `acos`, `asin`, `atan2`, `exp`, `log` (natural or with base), `max`, `min`, `pow`, `sin`, `tan`, `sign`, `mean`, `root` (square root or nth), `distance`, `manhattan`.

**Variables.** Names consist of words and dots. kni supports interpolating expressions within variable names using braces:

```
{=10 x}
{=20 y}
{=1 point.{x}.{y}}
{(point.{x}.{y})}
```

**Options with conditions and consequences.** Five operators combine a condition and a consequence, so an option is both a guard and a state transition:

- `{+n}` / `{+m n}` — add one (or m) to n if this option is chosen.
- `{-n}` / `{-m n}` — subtract one (or m) from n if chosen, *and* hide the option unless n is at least one (or m).
- `{!n}` — set n to one if chosen, *and* hide the option if n is already one.
- `{?n}` — set n to zero if chosen, *and* hide the option if n is already zero.
- `{=m n}` — set n to m if chosen, *and* hide the option if n is already m.
- Other expressions are merely conditions: `{n <> m}` shows the option only when n and m differ.

This is the door-lock idiom (`examples/door-lock.kni`), where each option encodes the precondition and the effect of opening, closing, locking, or unlocking a door:

```
+ {Open and Unlocked} [You w[W]alk through the open door. ] ->Red
+ {?Open} [You c[C]lose the door. ]
+ {Unlocked} {!Open} [You o[O]pen the door. ]
+ {not Open} {!Unlocked} [You u[U]nlock the door. ]
+ {not Open} {?Unlocked} [You l[L]ock the door. ]
```

The "formulae" notation (conditions, components with the `-` consumption prefix, and products with the `+` prefix) is the same machinery applied to crafting: `{-coal} {-lyme} {-iron} {+2steel}` consumes reagents and yields a product, and hides the option unless the reagents are present. (Typographic helpers — `{"`/`"}` curly quotes, `--` en-dash, `---` em-dash — hyperlink blocks `{text URL}`, and multi-file weaving round out the manual.)

Source: [MANUAL.md](https://github.com/kriskowal/kni/blob/120fd885f15c2b0d9b2def4faa113b1a0a4e87ca/MANUAL.md) at commit `120fd885`.
