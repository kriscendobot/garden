---
role: researcher
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-30T19:25:07Z cleared=none -->

---
role: researcher
requires: host=endolin-garden2-5bcdff64
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Revise the garden book: a title, an inference-tiers reference, and a new library-architecture chapter

The book (edition 2026-09-30) is published at
https://qxx6onyv2lkrchlytrmh2dos4xndfz5erojrkwfplor65h2ipgrq.ocap.site/, built
from `journal/projects/garden-book/ch*.md` by the tooling documented in
`journal/projects/garden-book/build/README.md`. This is a revision job, not a
rebuild from scratch — read that README first.

## 1. A title

The book currently has no real title (just a generic heading in
`build/intro.html`). Pick something catchy that actually fits what this book
is — a garden of AI agents, staged through several self-described
"metamorphoses," tending real software across many repos. Don't force a pun
that doesn't earn its place; a title that's clear AND has a bit of
personality beats a strained one. Update `intro.html`'s title page
accordingly (and its `<title>` if the build sets one from there).

## 2. An inference-tiers reference

A compact reference chapter, not a narrative one — write it to
`journal/projects/garden-book/ch10-inference-tiers-reference.md`. Ground it
in `skills/model-selection/SKILL.md` (the canonical role-to-tier map) and
whatever tier-inventory / routing-default tables it points at
(`model-tier-inventory.tsv`, `model-routing-defaults.tsv`, or equivalents —
confirm the actual current file names/paths rather than assuming). Cover:
the tiers themselves (`minion`, `mentor`, `mentat`, and how `mentat`/manual
dispatch differs from the two automatic tiers), the worker kinds bound to
each provider (`monk` for native Anthropic, `cleric` for OpenAI, and any
others currently live — check, don't assume the roster from an old
memory), per-role tier floors, and fallback-tier behavior (mentor-with-
minion-fallback as the automatic default). This is meant to be genuinely
useful as a reference — a reader should be able to look up "what tier does
role X get, and what happens if that provider is unavailable" and find the
answer.

## 3. A new chapter: the library's structure, growth, and context economy

Write to `journal/projects/garden-book/ch9-library-structure.md` — a full
chapter, placed after chapter 8 (the build tooling sorts `ch*.md`
numerically, so `ch9`/`ch10` slot in correctly after `ch8`).

Ground it in:
- `journal/library/conventions.md` — the canonical schema: the three
  indexing axes (sources, topics, concepts), file naming, the abstract
  contract, staleness/contradiction handling, per-source-kind variants.
- `skills/library-lookup/SKILL.md` — the concepts-axis lookup-and-index-
  on-the-fly discipline. This is the crux of "how it's used for research":
  explain concretely how a role (the researcher role above all, but any
  role touching the library) looks up a domain term, what it does on a hit
  vs. a miss (flat-grep fallback, writeback), and how every successful
  lookup improves the index for the next caller.
- `skills/context-library/SKILL.md` — the authoring discipline: abstract-
  at-the-top, partition cleanly, many small files over one long file. Pull
  this thread all the way through to the point the user specifically asked
  for: *why* this partitioning exists — a subagent doing a bounded lookup
  reads one small, targeted concept or topic page instead of a monolithic
  document, so its context fills with what's actually relevant to the task
  at hand rather than everything the library happens to know. Make the
  token-economy argument explicit and concrete (cite the section-budget and
  per-cycle bounds the scholar operates under as supporting evidence of the
  same discipline applied to writing, not just reading).
- `roles/scholar/AGENT.md` — how the library actually grows: job-driven (not
  a standing daemon), the per-job ingestion procedure, the idempotency check
  against a source's recorded anchor sha (so a re-ingest is cheap and
  re-ingestion is append-only, never a silent rewrite), the section-budget
  per cycle, and posting follow-on jobs for remainder work rather than
  truncating silently.
- `roles/researcher/AGENT.md` — the other side of "how it's used for
  research": a researcher job reads the task, walks the library via
  library-lookup, and returns a `## Library and project references` section
  inlined into the downstream design/build job *before* that work starts —
  this is the concrete mechanism by which the library keeps a design or
  build grounded in existing terminology and prior art instead of
  reinventing it.

Structure the chapter so a reader comes away with a real mental model: what
the library actually looks like on disk (`journal/library/{sources,topics,
concepts,sections}/`, `keywords.md`, the README index at each level), how a
piece of content gets in, how it gets found again, and why the whole shape
is optimized around a subagent's limited, costly context window rather than
around being a complete encyclopedia.

## 4. Rebuild and republish

Follow `build/README.md`'s own instructions to rebuild `index.html` with all
10 chapters (the original 8 plus the two new ones) and the updated
`intro.html`, and publish a new edition via `mcp__minion-town__publish`.
Update `build/README.md`'s own "Edition" line with the new date and URL
(keep the prior edition's URL in the README as history, don't just overwrite
it). Report the new URL plainly in your completion report and via
`scripts/jobs/message-user.sh <this-job-base>` to the maintainer inbox,
along with the title you picked.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T20:44:48Z
