---
role: scholar
---

# Ingest source: jcorbin's `unum` (tangled.org) — patterns useful for the garden

**Source:** <https://tangled.org/jcorbin.tngl.sh/unum> — a repo on **tangled.org**
(an atproto-hosted git forge, **not** GitHub). No bare clone exists under
`worktrees/`; fetch the content directly — browse the repo page and its files
with `WebFetch`, and/or `git clone` the tangled remote into a scratch dir if it
is cloneable. It is a maintainer-directed one-off ingest of a specific source the
maintainer chose, so it is in-bounds scholar work (not a standing watch).

## What to look for

Read `unum` for **patterns that would be useful for the garden**, with a
**particular focus on tracking token spend** — how a fleet/agent system meters,
attributes, budgets, or reports LLM token (and cost) usage. Capture anything
transferable to the garden's own control surfaces and job system, e.g.:

- **Token-spend tracking specifically:** how spend is measured, attributed (per
  job / role / model / session), aggregated, budgeted or capped, surfaced to an
  operator, and persisted. This is the primary interest — mine it hardest and map
  each pattern onto where it would live in the garden (the job lifecycle, the
  journal, the bulletin, the model-selection map, a budget/quota surface).
- Secondary: any other transferable patterns — orchestration, scheduling, agent
  tooling, budget/quota enforcement, observability, session/transcript handling —
  that the garden could adopt. Note them, but keep token-spend the through-line.

## Deliverable

Standard scholar library ingest, per your role and
[`journal/library/conventions.md`](../../journal/library/conventions.md):

- A **source-index** entry for `unum` under `journal/library/` (record the source
  URL and, where you can pin them, per-file commit shas for the idempotency
  check; if tangled does not expose stable shas the way GitHub does, note that and
  record whatever stable identifier it offers).
- **Section / topic / concept files** capturing the transferable patterns,
  abstract-routed so another role can find them in one or two queries, with a
  distinct concept file (or a focused topic) for the **token-spend tracking**
  findings.
- Update the master README indexes and `keywords.md` for the new material.
- If a finding implies a **structural change to the garden itself** (a new control
  surface, a model-selection/budget evolution, a job-lifecycle field for spend),
  do **not** edit roles/skills/top-level docs — route it as a self-improvement
  `message` addressed to `liaison` per
  [self-improvement](../../skills/self-improvement/SKILL.md) and record it in the
  `tada` report, so the maintainer can act on the token-spend design deliberately.
- If the source fans out beyond this job's budget, write what is supported and
  post a follow-on `scholar-ingest-unum-remainder` job for the rest.

## Skills

- [job-board](../../skills/job-board/SKILL.md),
  [journalism](../../skills/journalism/SKILL.md),
  [context-library](../../skills/context-library/SKILL.md),
  [library-lookup](../../skills/library-lookup/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done

`unum` is ingested into `journal/library/` as navigable, abstract-routed material
with a focused write-up of its **token-spend tracking** patterns mapped onto the
garden, the indexes updated, and any structural lesson routed to `liaison`. The
`tada` report lists the library paths written, the key token-spend patterns found
(or "no transferable token-spend pattern found, here is what `unum` does
instead"), and any self-improvement message raised.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  claimed_at: 2026-07-10T20:39:44Z
