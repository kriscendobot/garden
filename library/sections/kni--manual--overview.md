---
title: Manual overview — parser, compiler, and runtime in one command
source: MANUAL.md
source_repo: kriskowal/kni
source_commit: 120fd885f15c2b0d9b2def4faa113b1a0a4e87ca
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
notes: Reference-shape language manual; overlaps HOWTO.md (tutorial-shape) — soft cross-reference, not a contradiction.
---

Abstract: The kni MANUAL is the language reference manual (the graduated tutorial is [HOWTO.md](kni--howto--tutorial-getting-started.md)). This overview section captures the top-level fact that kni is simultaneously a **parser, a compiler, and a runtime**, all reachable through the `kni` command: by default it accepts one or more `.kni` files and opens an interactive console; `-j` bypasses the runtime and dumps the compiled JSON state machine; `--html` emits a standalone page. It names the version-pinning discipline and points at the sub-sections that follow.

kni is a parser, compiler, and a runtime, all of which are accessible with the `kni` command as installed by npm.

```
npm install kni
npx kni --help
```

Be sure to use a project-local installation of `kni`. While the language evolves, there are likely to be multiple radically different major versions of this project in concurrent use.

By default, `kni` accepts one or more `.kni` files (see one of the many examples) and opens up an interactive console for the story. The `-j` command line flag bypasses the runtime and dumps the compiled JSON state machine for the story. kni will generate a stand-alone story with `npx kni script.kni --html page.html`, which supports flags `--html-background-color skyblue` and `--html-title "My Story"`.

That the compiled artifact is a **JSON state machine** separate from the runtime is the load-bearing architectural fact of the language: authoring produces a graph; a small engine consumes it. The remaining manual sections document the surface syntax that authors write, which the parser lowers into that graph — text and spacing, indentation and threads, options and questions, input prompts, flow directives (labels, gotos, loops, procedures), and brace-delimited blocks (sequences, alternations, switches, conditions, modifiers, and expressions).

Source: [MANUAL.md](https://github.com/kriskowal/kni/blob/120fd885f15c2b0d9b2def4faa113b1a0a4e87ca/MANUAL.md) at commit `120fd885`.
