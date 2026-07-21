---
title: The parser pipeline — four stages that compile nested script into a flat instruction graph
source: HACKNI.md
source_repo: kriskowal/kni
source_commit: 0d6e2949daf0701df3ed7c173899e2a04b0dcca2
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

Abstract: How authored kni becomes a graph. The parser is a four-stage recursive-descent pipeline — scanner → outline-lexer → inline-lexer → grammar — that incrementally generates a *story*: a directed graph of labeled instructions. Where the script has nested sub-arcs, the compiled story is completely flat and resembles an assembly or virtual-machine language that the runtime walks. This section captures each stage's job (line/indent scanning, indentation-to-start/stop tokens, fine token splitting, grammar state machine), the `story.create(path, type, arg)` node-building API, and the loose-ends/jumps threading by which the grammar wires branches together after prompts. This is the "authoring nesting → flat graph" translation the whole language rests on.

kni is a four-stage recursive descent parser, responsible for incrementally generating a story — a directed graph of labeled instructions. The runtime engine walks this graph to generate narrative, options, and pauses. Where the script may have nesting sub-arcs, the compiled story is **completely flat** and resembles an assembly or virtual machine language.

```
scanner -> outline-lexer -> inline-lexer -> grammar
```

- **scanner.js** transforms a stream of text into a sequence of lines, tracking each line's indentation and leading bullets; it trims lines, collapses internal whitespace, and strips comments. It recognizes lines that start with space-delimited bullets (`-`, `+`, `*`) and the prompt sigil `>` as special. Driven with `next(text)` / `return()` (the JavaScript generator interface); drives the outline lexer.
- **outline-lexer.js** transforms lines (each with known indentation and leading bullets) into a stream of `start`, `stop`, `break`, and `text` tokens. A line with leading bullets establishes a new indentation depth, writing a `start` token to go deeper or unrolling `stop` tokens to go shallower; `break` tokens mark blank lines. Tokens carry a `type` and `text`.
- **inline-lexer.js** passes `start`/`stop`/`break` through and breaks `text` tokens into finer `token`, `symbol`, `alphanum`, `alpha`, and `dash` tokens, tracking whether each was preceded by whitespace (normalizing runs to a single space). It recognizes one- and two-character symbols (`@`, `[`, `]`, `{`, `}`, `|`, `/`, `<`, `>`, `->`, `<-`, `==`, `!=`, `>=`, `<=`); all other characters are individual symbol tokens.
- **parser.js** drives the grammar state machine, passing each token to the current state and tracking the resulting state. Each grammar state has an informative `type` for debugging and returns a new state. None of these interfaces throw: on error, the grammar records it on the story and returns a best-effort next state.

The grammar (**grammar.js**, with **expression.js**, **variable.js**, **story.js**) builds the graph. A `story` contains `states` (a name→struct map, serializable as JSON and directly consumed by the runtime) and an `errors` array. States use `story.create(path, type, arg)` to create or update nodes. Each state carries a `path` (the next consumable path), `ends` (loose paths to tie to the next node in this context), and `jumps` (loose paths to connect after the next prompt). Parent states implement `return(path, ends, jumps, scanner)` so children thread their last path back and parents collect ends and jumps. When the parser encounters a prompt line, it creates a prompt node, ties all loose ends to it, then promotes the jumps to ends for the next state with a cleared jump set — the mechanism that reconnects branch tails after a choice.

Source: [HACKNI.md](https://github.com/kriskowal/kni/blob/0d6e2949daf0701df3ed7c173899e2a04b0dcca2/HACKNI.md) at commit `0d6e2949`.
