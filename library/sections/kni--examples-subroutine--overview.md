---
title: "Subroutines that build a menu"
source: examples/subroutine.kni
source_repo: kriskowal/kni
source_commit: 3841b36af13c70a45cc825da4fec0de3bf58729f
source_date: 2018-01-16
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: A demonstration that options are composable: `@kind(t, u)` contributes a single parameterized option, `@type(t)` adds descriptive text plus two `->kind(...)` calls, and the top level invokes `->type(1)` and `->type(2)` before its own `[Skip.]` option and the closing `>`. The presented menu is therefore assembled from subroutine calls, and — because the chosen option jumps past the prompt — the post-prompt text runs for every branch except the one that exits with `<-`.

The key mechanic is that a procedure invoked before a prompt's `>` can append options and text to that prompt; the prompt collects everything accumulated since the last one. The example's comment highlights the subtlety that a selection "jumps over the prompt," so shared trailing narrative (`Your choice is noted.`) is reached by every non-exiting choice, which then loops via `->start`.

For authoring, `subroutine` is the reference for factoring a large or repetitive menu into reusable, parameterized option-builders instead of hand-writing each option — the DRY counterpart to inline option lists, and the same procedure mechanism `nominal` and `ship` use for text rather than menus.

Source: [examples/subroutine.kni](https://github.com/kriskowal/kni/blob/3841b36af13c70a45cc825da4fec0de3bf58729f/examples/subroutine.kni) at commit `3841b36a`.
