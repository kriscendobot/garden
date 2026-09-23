---
title: Blocks — echo, variable switch, conditions, loops-over-variables, and modifiers
source: MANUAL.md
source_repo: kriskowal/kni
source_commit: 120fd885f15c2b0d9b2def4faa113b1a0a4e87ca
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

Abstract: The variable-driven block families, all sharing brace syntax. *Echo* reads a variable into the narrative (`{(gold)}`). A *variable switch* (`{(gold)|no|some} gold`) picks the thread indexed by the variable, clamping out of range. A *ternary condition* (`{(cond)?then|else}` or `{(cond)? <-}`) is the load-bearing conditional (with the happy accident that a bare switch already serves as an if/else). A *loop over a variable* (`{@day|Mon|Tues|...}`) wraps the index with a mathematical modulo; an *arbitrary switch* (`{#x|...}`) selects deterministically by hash. *Modifiers* mutate state in place: `{+10 gold}`, `{-10 gold}`, `{=10 gold}`, and `*`/`/`. This is the read/branch/write surface over the graph's variable state.

**Echo a variable.** The narrator reads variables directly: `You have {(gold)} gold.`

**Switch on variable.** Any number of bar-delimited threads after a variable choose a thread by the variable's value, starting at 0, clamping to the final thread for values beyond the count and to the first for negatives; a switch does not implicitly increment. `You have {(gold)|no|some} gold.`

**Conditions.** By happy accident, switching on an expression serves as a conditional: `{(gold == 0)| poor | rich }` (0 is false → "else" thread; >0 → final "then" thread). A **ternary** block `{(condition)?then}` or `{(condition)?then|else}` fixes the awkward order and lets you omit clauses: `{(not gold)? <-}` skips to the end if there is no gold; `{(gold)? rich | poor }`.

**Loop over a variable.** Using `@`, the narrator draws a circle around a sequence, using a proper mathematical modulo to wrap the variable around the thread count: `Today is {@day|Mon|Tues|Wednes|Thurs|Fri|Sat|Sun}day.` Negative values wrap from the end. A variable loop does not implicitly modify the variable.

**Arbitrary switch.** `{#x|an ash|an oak|a birch|a yew}` picks an arbitrary-but-deterministic (hash-based, not random) thread for the value of `x` — useful for procedurally consistent content across a space.

**Modify a variable.** Modifiers take the concise form operator, value, variable: `{+10 gold}` (add), `{-10 gold}` (subtract), `{=10 gold}` (set). kni also supports `*` and `/` to multiply or divide in place; the quantity is optional and defaults to 1 (`{+arrow}`).

Source: [MANUAL.md](https://github.com/kriskowal/kni/blob/120fd885f15c2b0d9b2def4faa113b1a0a4e87ca/MANUAL.md) at commit `120fd885`.
