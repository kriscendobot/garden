---
title: The runtime engine — a program counter and call stack walking the JSON graph
source: HACKNI.md
source_repo: kriskowal/kni
source_commit: 0d6e2949daf0701df3ed7c173899e2a04b0dcca2
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring, automatic-agentic-loop]
status: current
---

Abstract: The runtime (engine.js) walks the compiled JSON instruction graph — evaluating expressions, switching cases, collecting text and options — with a *program counter* (the current instruction) and a *call stack* for labeled procedures. It has a per-instruction-type method (dollar-prefixed) and drives a pluggable "dialog" and "renderer" plus pluggable storage for variables and a pluggable random number generator. The default `end` behavior can be patched (e.g. reset storage and restart). evaluate.js runs the S-expression algebra (32-bit-clamped), and — crucially for reproducibility — threads the RNG through every function, using a seeded xorshift128 PRNG when generating/verifying transcripts so each read draws the same sequence. This is the "small engine consumes the graph" half, and the seam where external systems plug in.

The product of the parser is a JSON instruction graph. The **engine** (engine.js) walks this graph, evaluating expressions, switching cases, and collecting text and options. It drives a "dialog" and a "renderer" (different implementations for web and command line) and takes an optional start state, **pluggable storage** for the story variables, and a **pluggable random number generator**.

The runtime has a method, prefixed with a dollar sign, for each instruction type in the story language. The engine tracks the current instruction as a sort of **program counter**, and has a **stack** for "calling" labeled procedures. Labels can be used for both goto-arrow targets and function calls; a function returns when it reaches the end of a chain of instructions. The `end` method implements the default end-of-story behavior (display the remaining narrative and quit) and can be patched for alternate behavior, like resetting storage and starting again from the beginning.

**evaluate.js.** Some instructions evaluate algebraic expressions, which are like S-expressions using nested JSON arrays, mostly wrapping JavaScript operators clamped to 32-bit integers. The engine **threads the random number generator through all of these functions**: naïvely it uses the `Math` object, but while generating and verifying transcripts kni uses a **xorshift128 PRNG** to ensure each read uses the same sequence of random numbers — the determinism guarantee behind the transcript/verify tooling.

kni provides operators for simple probability distributions. Unary random `~n` gives a number in `[0, n)`; binary random `n~m` gives the sum of n samples of a `[0, m)` variable, biased toward the mean `n*m/2` (an homage to D&D `2d6`, but starting at zero and composing better). Two novel operators serve procedural generation: unary **hash** `#x` produces a deterministic pseudo-random number from an arbitrary value (a seed or position), and binary **hilbert** `x#y` produces a position along a space-filling curve over a 64K×64K square; combined (`#x#y`) they assign a pseudo-random-but-consistent number to every position in that space.

Source: [HACKNI.md](https://github.com/kriskowal/kni/blob/0d6e2949daf0701df3ed7c173899e2a04b0dcca2/HACKNI.md) at commit `0d6e2949`.
