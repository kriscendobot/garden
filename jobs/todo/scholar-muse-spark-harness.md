---
role: scholar
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-10T21:22:04Z -->

---
role: scholar
---

# Research: harnessing Meta's Muse Spark via Simon Willison's tool

**Primary source:** <https://simonwillison.net/2026/Jul/9/muse-spark-1-1/>
(Simon Willison, 2026-07-09, on **Muse Spark 1.1** by Meta). A web source, not a
repo — fetch it with `WebFetch`, and follow its outbound links (to the tool's
docs/repo, Meta's Muse Spark docs, any model card) as far as the budget allows.
Maintainer-directed one-off ingest of a specific chosen source → in-bounds scholar
work, not a standing watch.

**This is the RESEARCH step of a serial orchestration** (`orch-spark-gardeners`):
scholar → designer. Your library ingest is the designer's input for a follow-on
"introduce Spark gardeners" design, so bias the research toward what that design
will need.

## What to find out

1. **What is Muse Spark (1.1) by Meta** — what kind of model/product it is, its
   capabilities, and crucially whether it supports the things an agent harness
   needs: **tool/function calling**, multi-turn/agentic loops, streaming, system
   prompts, context window, and how it is accessed (API, endpoint, auth).
2. **What is Simon Willison's tool** here — almost certainly his `llm` CLI or a
   plugin/adapter for it. Establish: the tool's name, how it wraps Muse Spark
   (plugin? provider config?), how you invoke Muse Spark through it (the exact
   command / config), auth/credential mechanics, and whether it exposes tool-use
   or just text completion.
3. **How one would "harness" Muse Spark through that tool for agentic work** —
   the concrete invocation path from a prompt to a Muse-Spark-backed response,
   and any gaps (e.g. no tool-calling → no autonomous agent loop) that would
   constrain using it as a worker's model.
4. **Cost / token / rate-limit** shape, insofar as the source states it — this
   feeds the garden's token-spend concerns.

## Deliverable

Standard scholar library ingest under `journal/library/`, per your role and
[`journal/library/conventions.md`](../../journal/library/conventions.md):

- A **source-index** entry for the Willison post (URL + a stable identifier /
  date; note the transient-web caveat if no sha is available).
- **Concept / topic files** capturing (a) Muse Spark's agent-relevant
  capabilities, (b) the Willison tool's invocation/harness path, and (c) a
  focused **"can this back a garden worker?"** assessment — what works, what is
  missing, and what a Spark-backed worker could and could not do.
- Index + `keywords.md` updates.
- If the research implies a **structural change to the garden** (a new worker
  harness, a model-selection evolution, a new unit shape), do **not** edit
  roles/skills/top-level docs — route it as a `message` to `liaison` per
  [self-improvement](../../skills/self-improvement/SKILL.md); the follow-on design
  child will act on it.

## Skills

- [job-board](../../skills/job-board/SKILL.md),
  [journalism](../../skills/journalism/SKILL.md),
  [context-library](../../skills/context-library/SKILL.md),
  [library-lookup](../../skills/library-lookup/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done

Muse Spark 1.1 and the Willison harness path are ingested into `journal/library/`
as abstract-routed material, with an explicit "can it back a garden worker"
assessment the designer can build on. The `tada` report lists the library paths
written, the key findings (capabilities, invocation path, gaps), and any
structural lesson routed to `liaison`.
