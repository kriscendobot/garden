---
title: "Recursive integer-to-words procedure"
source: examples/nominal.kni
source_repo: kriskowal/kni
source_commit: 34ed07498fe487c255d7a28e0e0bac862f3fdecf
source_date: 2016-08-01
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: A single procedure `@nominally(n)` that renders any integer in `[0, 2**31)` as English words by structural recursion: it peels off the sign, then successively the billions/millions/thousands/hundreds place (emitting the word and recursing on quotient and remainder via `->nominally(n / 1000) thousand ... ->nominally(n % 1000)`), and finally a variable switch over the ones-and-teens and a tens table. It is the corpus's clearest example of a returning procedure calling itself with arithmetic-derived arguments.

Each magnitude clause is a conditional consequence `{(n >= 1000)? ... <-}` that renders its place and returns (`<-`) once handled, so the recursion terminates cleanly at the base cases in the final switch. The `->nominally(n/10*10)\-->nominally(n%10)` line composes two recursive calls to hyphenate compound tens (for example "twenty-one").

For authoring, `nominal` is the reference for recursion with computed arguments and early `<-` returns — a pure-function procedure with no options, no external state, and a bounded call depth set by the magnitude of `n`. It complements `subroutine` (procedures that build menus) and `tree` (recursion over a spatial position) by showing recursion over a numeric decomposition.

Source: [examples/nominal.kni](https://github.com/kriskowal/kni/blob/34ed07498fe487c255d7a28e0e0bac862f3fdecf/examples/nominal.kni) at commit `34ed0749`.
