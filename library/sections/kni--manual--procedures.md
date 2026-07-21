---
title: Procedures — callable, returning labels with local scope and arguments
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

Abstract: A *procedure* is a label that can be called and returned from — the graph's subroutine mechanism. Calling a label with parenthesized comma-separated arguments (`->greet(0)`) introduces a scope with local variables, evaluates the arguments in the caller's scope, applies them to the callee's parameters, runs the procedure body, and returns to the transition after the call site (the procedure implicitly returns at the end of its thread; `<-` returns early). This is what lets a kni graph factor repeated sub-flows — an inventory readout, a reusable room description — into named, parameterized fragments rather than duplicating them.

A procedure is a label that can be called and returned from. Procedures can be used as goto targets, but with the special syntax for calling a procedure, they can introduce a scope with local variables and return to the next transition after where they were called. The procedure implicitly returns at the end of the thread.

```
- @greet(time)
  {(time)|Hello|Good bye}, World!

->greet(0)
->greet(1)
```

A label followed by parenthesized and comma-separated argument expressions signifies a call and return, instead of just going to a label. These arguments are evaluated in the caller scope, then applied to parameters in the callee scope.

**Returning or exiting.** The reverse arrow `<-` skips to the end of a procedure. For the main narrative, this means exiting out the bottom of the file; within a procedure, it means exiting out the end of the procedure. Regardless, the reverse arrow pops the stack and proceeds after the call site, or ends the narrative.

Source: [MANUAL.md](https://github.com/kriskowal/kni/blob/120fd885f15c2b0d9b2def4faa113b1a0a4e87ca/MANUAL.md) at commit `120fd885`.
