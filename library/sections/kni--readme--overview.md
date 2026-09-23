---
title: What kni is — a decision-graph language with a graph-walking runtime
source: README.md
source_repo: kriskowal/kni
source_commit: 120fd885f15c2b0d9b2def4faa113b1a0a4e87ca
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring, automatic-agentic-loop]
status: current
---

Abstract: kni (kriskowal's own project) presents itself as "an interactive story language for multiple-choice text adventures, interactive fiction, and phone bots," but read past the storytelling framing: it is a **language for expressing decision graphs** plus a **runtime engine that walks the graph**. A kni script is descriptive text interleaved with *options*; the compiler flattens the authored nesting into a flat, labeled instruction graph, and an engine enters at the top of the file, accumulates options, presents a prompt, and traces the chosen direction. This section captures that core model, the canonical hello example, and the trace/prompt loop that makes it a graph an interlocutor (human — or, per this ingest's lens, an agent) walks.

kni is an interactive story language for multiple-choice text adventures, interactive fiction, and phone bots. The name is an homage (silent) to Inkle's [Ink](https://github.com/inkle/ink) (the same, but backwards), and like other languages named thus, kni also has significant whitespace.

Install and run via npm; the CLI requires Node.js 4+, and you pin a major version explicitly (`npm install kni@4`) because the language evolves across radically different major versions.

**The core model.** kni stories consist of *descriptive text* and *options*. Kni runtime engines trace the dialog, entering at the top of the file and exiting out the bottom. The dialog accumulates options and presents a prompt for the interlocutor to choose the direction of the narrative.

```
Hello, {"World!"}

@loop
+ [You s[S]ay, {"Hello."} ]
  You are too kind, hello
  again to you too. ->loop
+ [You s[S]ay, {"Farewell."} ]
>

The End.
```

Run with the interactive reader (`kni hello.kni`): the engine prints the text, offers the numbered options, waits for a choice, and continues from the branch the interlocutor picked:

```
$ kni hello.kni
Hello, "World!"
1. Say, "Hello".
2. Say, "Farewell."
> 1

You say, "Hello".
You are too kind, hello again to you too.
1. Say, "Hello".
2. Say, "Farewell."
> 2

You say, "Farewell."
The End.
```

Scripts can also be loaded and bound with scenes in a web page (`kni hello.kni --html hello.html`). Several shipped example apps (Peruácru, archery, journey, airship) illustrate shops, gambling, procedurally-generated survival, and even a simulation of a steampunk airship's controls — evidence that a kni graph can drive more than linear prose.

Documentation set the README links to: [How to Write Kni](HOWTO.md) (a graduated tutorial), the [Language Reference Manual](MANUAL.md), [Differences between Ink and Kni](INKKNI.md), and [How to hack Kni](HACKNI.md).

Source: [README.md](https://github.com/kriskowal/kni/blob/120fd885f15c2b0d9b2def4faa113b1a0a4e87ca/README.md) at commit `120fd885`.
