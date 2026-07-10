---
title: The LORE corpus — a distilled-incident lesson library
source: LORE/INDEX.md
source_repo: jcorbin.tngl.sh/unum
source_commit: 764a14d8d8149de6ad6a021440a605fb7fb0a5e7
source_date: 2026-07-09
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
topics: [agent-fleet-orchestration, repository-governance]
status: current
notes: |
  Shape-not-content ingest of the LORE/ directory as a corpus. The 67 individual
  lesson files are NOT transcribed one-to-one; the transferable ones are
  consolidated into four thematic sibling sections (unum--lore-claim-lifecycle,
  unum--lore-journal-durability, unum--lore-crash-safe-guards,
  unum--lore-engineering-discipline). This section captures the corpus's *shape*
  and the practice that produces it.
---

## Abstract

**LORE/** is unum's directory of ~67 distilled hard-won lessons — "entries that
transcend a single task: architectural decisions and their *why*, recurring
patterns, operator-given guidance with context, and bug sagas whose implications
are broad." It is a **deliberate curation layer**, structurally distinct from the
other three doc kinds (`STANDARDS/` = how to code, `skills/` = how to do a
recurring operation, `TADA/` = per-task completion records). LORE entries are
written **by the steward, never by invokers as busywork**, only when a lesson is
genuinely durable; candidate lessons surface from a `lesson:` frontmatter field
mined out of completed `TADA/` task files. This is the same instinct the garden's
own library embodies — turn raw incident records into navigable, abstract-routed
material — arrived at independently. The corpus is the single richest transferable
vein in unum, and the four sibling `unum--lore-*` sections distil its coordination,
durability, and engineering-discipline content.

## The corpus shape (captured, not transcribed)

Per the "shape, not content, for upstream meta-tables" convention, this section
records the LORE index's structure — its category partition, its per-entry shape,
and its authorship discipline — without mirroring all 67 rows (which change at
unum's cadence, not the library's). Query the live `LORE/INDEX.md` at the repo for
the current row set.

Each LORE file is frontmattered `kind: lore` with `tags:` (a controlled-ish
vocabulary: `pattern`, `bug-saga`, `recurring`, `directive`, `architecture`,
`decision`, `anti-pattern`, `process-hazard`, …), a `created:` date, and a
`sources:` list pointing at the `TADA/`/`TOQU/` task files the lesson was distilled
from. The body is a short essay: *why it matters* → *the pattern* → *evidence*
(numbered task references) → *exceptions / caveats*. Many carry a `## See also`
block cross-linking sibling lessons — the corpus is a graph, not a flat list.

`LORE/INDEX.md` groups the entries into eight areas, each a Markdown table of
`(lesson-link, one-line gist, tags)`:

| Area | What it collects |
|---|---|
| Process & steward behaviour | role boundaries, context-exhaustion handling, task-id minting, release-tag gates |
| Design discipline & decisions | the "lighter cut", design-out-the-hazard, schema-duplication drift, config-schema evolution |
| Git & repo mechanics | bare-repo/worktree gotchas, commit-attribution trailers, merge-noop detection, worktree reaping |
| Journal, state & durability | journal-ref CAS, write-once vs RMW primitive selection, cutover atomicity, breadcrumb ordering |
| Merge, claim & lifecycle hazards | claim-state atomicity, false-stranded cascades, branch-landed≠done, dead-claimer deadlocks |
| systemd / logind / shutdown | delay inhibitors, scheduled-shutdown detection, re-exec invisibility, killswitch source guards |
| Notifications / televoke | single-emitter ownership, resume-visibility, reply-threading, persona-scoped transcript routing |
| Go patterns & testability | seam injection, targeted-cancel vs shutdown, silent-failure log-and-swallow |

## The distillation practice (the transferable meta-lesson)

The workflow that *produces* LORE is itself the pattern worth carrying:

1. A completed task records a portable insight in a `lesson:` frontmatter field
   (`grep -rl "^lesson:" TADA/` is an instant lesson index). Context-specific
   observations go in a separate `notes:` field.
2. A steward-driven **lesson-mining** pass (unum's `skills/mine-learnings/`)
   promotes the recurring, root-understood lessons out of `TADA/` into a durable
   `LORE/` entry — with the *why*, the evidence trail, and the caveats.
3. The `LORE/INDEX.md` gist table plus the per-file *why/pattern/evidence/caveats*
   shape make each entry a fast lookup target, and the SOUL workflow tells every
   fresh agent to **scan `LORE/INDEX.md` for its task's area before starting**.

This is a convergent design with the garden's `journal/library/` (abstract-routed
concept/section pages mined from `journal/entries/`), differing mainly in
granularity: LORE keeps one file per lesson with a hand-curated category index;
the garden adds the keyword/concept axis and deterministic section-table
projection on top.

Source: [LORE/INDEX.md](https://tangled.org/jcorbin.tngl.sh/unum) at commit `764a14d`.
