---
title: "Calculator state-machine loop"
source: examples/calc.kni
source_repo: kriskowal/kni
source_commit: 5df7a8d89f6becb20cc572729e312fc00c634f58
source_date: 2018-03-09
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: A five-option calculator loop that displays one integer and returns to the same label after every mutation, illustrating a minimal explicit state machine rather than a narrative flow.

`n` begins at zero. The `Calc` label renders its value, offers increment, decrement, and fixed-value mutations, prompts, then jumps back to `Calc`. Each option contains its state transition beside the user-facing label, so the graph's loop and its mutable state are inspectable from the authored source.

This is the pure-state-machine end of kni's decision-graph surface. It provides a compact model for a deterministic agent-side controller when no free-form elicitation is needed: render state, expose legal actions, apply one named mutation, and repeat.

Source: [examples/calc.kni](https://github.com/kriskowal/kni/blob/5df7a8d89f6becb20cc572729e312fc00c634f58/examples/calc.kni) at commit `5df7a8d8`.
