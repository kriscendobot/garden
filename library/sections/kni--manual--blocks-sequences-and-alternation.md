---
title: Blocks — sequences, alternation, and random selection (deterministic and stochastic)
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

Abstract: Brace blocks `{...}`, delimited by `|`, are how a single point in the graph expresses one of several threads. This section covers the selection families: *sequences* (`{a|b|c}` — advance to the next thread each visit, sticking on the last, or vanishing if the last is empty), *alternation* (`{&day|night}`), and the *random* families — plain shuffle `{~a|b}`, weighted random with per-thread `(weight)` expressions, and hypergeometric "sampling without replacement" `{^N ...}` that draws N distinct threads. A sequence is backed by a variable named for its transition label, so the choice is stateful and inspectable. The deterministic (`&`, sequence) versus stochastic (`~`, `^`) split matters to the agent-context lens: kni cleanly separates reproducible routing from seeded randomness.

All remaining special syntax is the purview of blocks — instructions between braces `{` and `}`, often delimited with vertical bars `|`.

**Sequences.** A narrative can contain a sequence of threads. Each visit shows the next thread; once exhausted, every subsequent visit shows the last thread. `{apple|banana|cherry}`. The final thread may be empty so the sequence disappears once exhausted: `{There are two fish in the pond.|A cat rests by the pond.|}`. Behind the scenes, the sequence has a variable with the same name as the transition; a label names it (`@fruit {apple|banana|cherry}`), and the story can read or reset that variable (`{=0 fruit}`). Each visit increments the variable, even after the threads are exhausted.

**Alternation.** `When you emerge, {&day|night} greets you, with the {&sun|moon} overhead.`

**Random.** `You flip a coin. {~Heads|Tails}!` — the `~` expression chooses among the threads at random. kni supports **weighted random**: every thread has weight 1 by default; a parenthesized expression at the start of a block sets an alternate weight (`{~(2) heads |(3) tails }`), and the weight expression may contain variables and operators so the distribution can shift over a loop.

**Hypergeometric sampling** ("sampling without replacement"). With a `^` prefix followed by an expression giving the number of threads to sample, each sampled thread becomes ineligible for the next sample until the count or the threads are exhausted; per-thread weights apply, and weight 0 makes a thread ineligible:

```
{^2
|(smell) You smell roses.
|(sight) The sky is bright blue.
|(hearing) You hear bees buzzing.
|(touch) The air feels cool on your skin.
}
```

Unordered random sampling makes many interesting procedural narratives possible.

Source: [MANUAL.md](https://github.com/kriskowal/kni/blob/120fd885f15c2b0d9b2def4faa113b1a0a4e87ca/MANUAL.md) at commit `120fd885`.
