---
title: Adventures In LLM Land — the essay, and the germane thesis (getting value from AI agents takes discipline, and the human role is *wanting*)
source_kind: web-essay
source_url: https://habitat-chronicles.com/2026/02/adventures-in-llm-land-with-thoughts-on-the-ai-revolution/
source_content_sha256: a4ddab90a5eb77fac616b8e9177dc7555f9086c787dad0ff39b4010f94094cc9
source_author: Chip Morningstar
source_date: 2026-02-18
ingested: 2026-07-11
ingested_by: scholar
topics: [agent-fleet-orchestration, llm-agent-frameworks]
status: current
notes: |
  Partial ingest — only the portions bearing on agents / capabilities /
  distributed objects (per the garden's ocap / distributed-object lineage) were
  taken. The essay's meandering personal-blog material — the home-library book
  cataloging saga, the AT&T-fiber networking debug, the "vibe coding" jargon
  gripe, and the AI-hype / Kuhnian-paradigm-shift / dot-com-Dance-of-the-Dinosaurs
  commentary — was deliberately skipped as not germane. The germane core is three
  sections: the agentic-development / fleet-of-agents framing, the human/machine
  division of labor, and the CEO-delegation analogy with its warning that you must
  delegate *wanting* (judgment/taste), not just tasks.
---

## Abstract

Chip Morningstar's 2026 personal-blog essay on a year and a half of building
software with AI coding tools (Cline, then Claude Code), from which the library
takes only the portions germane to the garden's **agent-fleet-orchestration** and
distributed-object lineage. The load-bearing thesis: contrary to the "vibe coding"
caricature, getting the maximum benefit from these tools takes a *surprising amount
of discipline* — just a different discipline than traditional programming. Working
with AI agents is like **managing a flock of brilliant but naive junior developers**
(engineering-management-as-programming-at-a-higher-level-of-abstraction), and the
central challenge is **maintaining the proper division of labor** between human and
machine: the machine does the mechanical heavy lifting, the human does the
*expressive* part — deciding and articulating what is wanted. Morningstar
generalizes this beyond coding into a claim about the human role in *any*
AI-assisted endeavor — *"the AI can make things for you, but it can't want things for
you"* — and closes with a warning to executives against naively swapping humans for
AIs in org-chart boxes, because delegation in a real hierarchy passes down not just
tasks but *judgment and taste* (many layers of "recursively ramified desire"). The
germane sections are cross-filed under `agent-fleet-orchestration` (the garden is
itself a fleet of semi-autonomous agents steered by a human who supplies the
wanting) and its single-agent `llm-agent-frameworks` neighbor.

## Content

For the past year and a half Morningstar has been experimenting with AI tools for
software development — starting with one small personal project (a system to catalog
his family's 10,000-plus-volume home library), growing to a couple of large personal
projects, and now a central part of his whole team's regular workflow. He is
"completely convinced that this is just the way software development is going to be
done henceforth, at least until the next turn of the paradigmatic wheel." The essay
summarizes what he learned; this section captures its germane thesis and points at
the three sections that develop it.

He opens by dismissing the emerging **"vibe coding"** label as "both a terrible
piece of jargon and a disappointingly sloppy way of approaching things," and notes
the parallel drift toward calling the practice **"agentic"** — possibly because the
tools make it easy to have several independent entities ("agents!") working on your
behalf at once, and possibly just because it sounds more serious than "vibe coding."

The counter to the laziness caricature is the essay's first real claim:

> My experience has been that, rather than letting you be lazy (which can be either
> an accusation or a touted payoff, depending on whether you are talking to a critic
> or an enthusiast), getting the maximum benefit out of these tools has taken a
> surprising amount of discipline. It's just that the discipline required is very
> different from what you need for traditional programming.

He recounts following his friend **Monica Anderson**'s recipe — which he observes has
become "pretty much the de facto pattern that everybody doing 'agentic' stuff uses,"
whether by direct influence or convergent evolution — writing a five-page spec
document (`library.md`), prompting the agent to "read library.md" then "create the
web app and database backend just described," and getting **"Instant software!"** that
"sort of?" worked. Two months of coaxing followed to get the UX and functionality
sane. A second, purely-functional task (an iPhone book-scanner app defined as "do
*this*") "worked perfectly on the first try. This was magic." The difference — a
*functional* target versus a target with a lot of aesthetic detail that had to be
"just so" — sets up the essay's central division-of-labor argument.

The germane development of these threads is carried in the three sibling sections:
the **agent-flock** framing (managing agents like junior developers), the
**human/machine division of labor**, and the **CEO-delegation / "learn to be a good
wanter"** argument.

Source: [Adventures In LLM Land, With Thoughts On The AI Revolution](https://habitat-chronicles.com/2026/02/adventures-in-llm-land-with-thoughts-on-the-ai-revolution/) by Chip Morningstar, 2026-02-18 (content sha256 `a4ddab90`).
