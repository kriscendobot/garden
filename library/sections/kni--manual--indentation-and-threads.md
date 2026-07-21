---
title: Indentation and threads — significant whitespace builds the branch structure
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

Abstract: kni is a whitespace-significant language: indentation and leading bullets define *threads*, and the branch structure of the decision graph is inferred from them rather than declared. This section documents the three bullets (`*` optional-once, `+` always-offered, `-` organizational), how a deeper column starts a new thread that ends at the next shallower line, how loose ends of option branches are gathered and reconnected after the next prompt, and how a thread may open with a conditional expression that skips it. This is the structural heart of how authored nesting becomes graph nodes.

kni is a white-space significant language. All leading tabs and spaces, as well as bullet symbols, on a line determine the initial column number of the line. Tabs advance the cursor to the next tab stop (every fourth column). Bullet symbols are `-`, `*`, and `+`. Every time a line starts on a deeper column than the prior, it starts a **new thread** that ends on the next line that starts on a shallower column.

```
* [You s[S]ay, {"Hello."} ]
  You are too kind, hello
  again to you too.
+ You s[S]ay, {"Farewell."}
>
```

- The **asterisk** denotes an optional thread that the narrator will only propose once.
- The **plus** denotes a thread that the narrator will always propose.
- The **hyphen** denotes a thread separated purely for organizational purposes.

All loose ends in options will be gathered and connected after the next prompt. Within a thread, conditional jumps can optionally skip to the end of a thread:

```
- {door == open} The door is open.
  + [You w[W]alk through the open door. ] -> blue
```

Indented threads control the flow of the narrative. The `*` and `+` bullets indicate an optional branch and pose a choice for the interlocutor; the `-` bullet separates a thread of narrative without presenting an option. Any thread can begin with a conditional expression; failing the condition, the narrative skips the entire thread.

Source: [MANUAL.md](https://github.com/kriskowal/kni/blob/120fd885f15c2b0d9b2def4faa113b1a0a4e87ca/MANUAL.md) at commit `120fd885`.
