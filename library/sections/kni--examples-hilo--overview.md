---
title: "Binary-search question loop"
source: examples/hilo.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring, automatic-agentic-loop]
status: current
---

> Abstract: A `@try` label that computes a midpoint from the current `lo`/`hi` bounds, asks whether the target is below (then above) that midpoint, folds each recorded yes/no answer back into the bounds (`{=mid-1 hi}` / `{=mid lo}`), increments a question counter `{+q}`, and loops until `hi == lo`, then reports the answer and how many questions it took. It is the strongest example of a graph that gathers just enough information through successive bounded questions to converge on a result.

The loop embodies the elicitation discipline: each prompt is a decision point whose two options write the interval directly, the guard `{(hi == lo)? -> end}` is the convergence test, and `q` is an auditable record of how much was elicited. The graph — not the interlocutor — decides which question to ask next, computing it deterministically from accumulated state; the interlocutor supplies only the yes/no signal.

This is the canonical "ask the next question computed from what you already know" pattern an agent-context scaffold wants: bounded questions, monotonic narrowing, an explicit termination guard, and a tally of the interaction cost. Compared with `coin` (one elicited decision) and `read` (a fixed interview), `hilo` shows adaptive, state-driven question selection.

Source: [examples/hilo.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/hilo.kni) at commit `435ec3cf`.
