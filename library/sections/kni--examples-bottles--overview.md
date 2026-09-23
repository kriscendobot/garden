---
title: "Recursive countdown refrain"
source: examples/bottles.kni
source_repo: kriskowal/kni
source_commit: aaf798b724fb8db639fd9303376b16ef6e96fc8c
source_date: 2018-03-09
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: A `@refrain` label that renders one verse from the `Bottle` counter, decrements it with `{-Bottle}`, and tail-recurses into itself (`{(Bottle)||->refrain}`) until the counter hits zero — the smallest terminating, counter-driven loop in the corpus, with each numeral phrase (`No more bottles` / `1 bottle` / `N bottles`) selected by a variable switch.

The whole program is one initialization (`! Bottle = 99`) and one label whose last line is a guarded self-jump: `{(Bottle)||->refrain}` re-enters the label only while `Bottle` is nonzero, so the loop terminates deterministically. Every noun phrase is a variable-switch block that maps the counter to the grammatically correct wording.

Read as decision-graph authoring, this is the canonical "loop by re-entering a label under a guard" idiom stripped to its minimum: no options, no external input, purely a counter mutated toward a base case. It is the generator dual of the interactive state machines — the same jump-under-guard control flow that `calc`, `door`, and `maze` use to loop, but with the branch decided by state alone rather than by an elicited choice.

Source: [examples/bottles.kni](https://github.com/kriskowal/kni/blob/aaf798b724fb8db639fd9303376b16ef6e96fc8c/examples/bottles.kni) at commit `aaf798b7`.
