---
title: Input prompts — capturing free-form interlocutor input into a variable
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

Abstract: Beyond menu choices, a prompt can *capture free-form input*. A `>` followed by a variable name fills that variable with the interlocutor's typed text, and an optional trailing *cue* lets a custom dialog implementation validate or convert the input (with reserved lowercase builtin cues like "name" and "number", and planned fallback-cue ordering). This is the smallest and most lens-relevant primitive in the language: it is how a kni graph *elicits* an open-ended answer and *records* it as durable, addressable state that later text and conditions read back — the deterministic-elicitation seam this ingest is evaluating.

A prompt with a variable name will fill that variable with input from the user.

```
What is your name?
> Name

We are very pleased to meet you, {(Name)}.
```

The prompt may also indicate an **input cue**. Custom dialog implementations may use the cue to validate or convert the user text:

```
What is your name?
> Name Name

We are very pleased to meet you, {(Name)}.
```

kni reserves the right to introduce builtin cues with any lowercase name for the default terminal and web modes. Some likely cues include "name" and "number." kni may also add support for **fallback cues**, so cues would need to be ordered from first to last precedence. This would allow a script to use custom behavior while still functioning in an input mode that only supports "number," for example.

The captured value is an ordinary kni variable: it is echoed with `{(Name)}`, tested in conditions, and threaded through the rest of the graph exactly like any variable an option's consequence would set. (The shipped `examples/read.kni` is a compact worked example: it interviews the interlocutor for a name, a gender via a menu, and some entropy, then renders a structured result sentence — a bounded interview whose answers become structured state.)

Source: [MANUAL.md](https://github.com/kriskowal/kni/blob/120fd885f15c2b0d9b2def4faa113b1a0a4e87ca/MANUAL.md) at commit `120fd885`.
