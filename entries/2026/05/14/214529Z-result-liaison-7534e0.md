---
date: 2026-05-14T21:45:29Z
host: endolin
role: liaison
kind: result
dispatch_root: dispatches/liaison--d67fd2
---

# Liaison: bootstrap library-lookup — keywords axis, concepts directory, skill, role wiring

## User asks across two turns

1. *"It might be useful for the library to have a directory dedicated to grepping for key words or key phrases and from there finding the relevant documents. We could use a single document that maps keywords and phrases to a unique identifier, and a directory with unique identifier markdown files that expand to the relevant sections and one line summaries."*

2. *"This all sounds good, including the stretch."* (referring to the writeback / queue-a-missive-to-scholar piece)

3. *"It should be noted that a librarian's job is not just to find information, but to ensure that the next search for the same information either succeeds where it did not before, or succeeds faster than it did before. That will imply indexing on the fly, both pruning distractions and adding shortcuts."*

The third turn reframed the skill from *search procedure* to *search-then-improve loop*. The writeback I called a "stretch" became the core discipline.

## Landed (journal branch)

`journal/library/`:

- **`keywords.md`** — new file, ~90 keyword→concept-id entries. Format: `<keyword or phrase> | <concept-id>`. Code symbols in backticks; prose plain.
- **`concepts/`** — new directory. 14 seed concept pages plus a `README.md`:
  - `cohort-destruction`
  - `crdt-in-formula-persistence` (the canonical concept-page-with-contradiction worked example — covers both where CRDT shape is used *and* where a bidirectional CRDT was rejected)
  - `dehydrate-hydrate`
  - `formula-graph`
  - `formula-persistence-thesis`
  - `four-tables-coordinated-retention`
  - `local-node-sentinel`
  - `per-agent-keypair`
  - `producer-typed-shape-consumer-rendering`
  - `retention-accumulator`
  - `revocation-by-withdrawal`
  - `sentinel-with-rationale`
  - `shape-not-content`
  - `six-aspects-of-sharing`
  - `throwaway-instance-prototype-walk`
- **`conventions.md`** — new top-level section *"Concepts and the keyword index"* covering concept-page shape, keyword-index shape, and the **"Indexing on the fly"** discipline (the user's third-turn point made explicit: three writeback actions — add shortcut, prune distraction, draft missing concept — that callers perform inline at lookup time, plus the permission model and the queue-a-scholar-review aggregation).
- **`README.md`** — refreshed Layout block (adds `keywords.md` and `concepts/`) and the *"How to find something"* block now leads with the keyword-lookup axis, then topics, then sources.

## Landed (main branch)

- **`skills/library-lookup/SKILL.md`** — new skill. Procedure has five steps: look up, fall back (synonym tries → flat-grep across sections → adjacent topic/source check), use the answer, **index on the fly** (the three writeback actions, each with a `Trigger` and an `Action`), commit and push. The skill mutates `keywords.md` and `concepts/` only; it never touches `sections/`, `sources/`, or `topics/` (those remain scholar's province). Output shape is a focused brief — concept summary + most relevant section's bold-fact summary + source provenance + a note on what writebacks were applied.
- **`roles/COMMON.md`** — new *"Library"* section between *"Project context"* and *"Where things are"*. Names the three indexing axes, points at `skills/library-lookup/SKILL.md` as the entry, and explains the compounding effect (one role's index improvement benefits every subsequent caller in every other role). Read by every dispatched subagent including all 17 jury seats.
- **`roles/designer/AGENT.md`** — added `library-lookup` as the first listed skill, with the directive *"before drafting, look up every domain term the prompt mentions so the new design names the same things the existing corpus names them, and references rather than reinvents prior art."*
- **`roles/builder/AGENT.md`** — added `library-lookup` as the first listed skill, with the directive *"before implementing, look up the domain terms named in the design / issue so the implementation uses the same identifiers, mechanisms, and naming as the rest of the corpus."*
- **`CLAUDE.md`** — added `library-lookup` to the skills inventory line.

Jury seats inherit the reference from `COMMON.md` (read first by every dispatched subagent), so I did not edit each of the 17 seat AGENT.md files. If a future maintainer wants per-seat emphasis (e.g. for the prover or breaker seats whose work most directly benefits from prior-art lookup), that is a one-line edit per seat.

## Rationale for liaison-driven implementation

Instead of queueing this as a missive for the next scholar cycle, I bootstrapped it directly because:

- The user was in the loop and had just approved the plan.
- The data (14 daemon-cluster concept pages) and the prose (SKILL.md, conventions.md extension) were both freshly loaded from cycles 46–49.
- The change spans both the journal branch (data + conventions) and the main branch (skill + role files), which is awkward to coordinate across two separate dispatches.
- Doing it in one coherent change avoided partial-landing states (e.g. the skill landing before the data, or vice versa).

The change is conservative — no existing files were restructured; the new axis layers on top of the existing three. The bootstrap content is daemon-cluster heavy because that material was already loaded; the skill's *Indexing on the fly* discipline is exactly what compensates as future callers reach for terms the seed inventory does not cover.

## Library state

- Sources: **98** (unchanged this dispatch).
- Sections: **443** (unchanged this dispatch).
- Topics: **25** (unchanged this dispatch).
- **Concepts: 14 (new this dispatch).**
- **Keywords: ~90 (new this dispatch).**

## For scholar's next cycle

Audit the seed inventory in `library/concepts/` and `library/keywords.md` for any obvious gaps or miscategorizations. The conventions document's new *"Indexing on the fly"* section names scholar as the role that audits writebacks in batch (one missive per dispatch from each library-lookup caller).

The cluster-review pass proposed at cycle-48 result is still pending — when scholar performs it, the concept pages are a useful synthesis surface (each concept page already collects multiple cross-cluster pointers).

## Open follow-ups (for a future cycle, not this one)

- **Per-seat reference for jurors**: if a future maintainer wants jury seats to have a per-seat hint about library-lookup beyond what COMMON.md provides, that is 17 one-line edits.
- **First worked instance of writeback**: this dispatch did not exercise the *Indexing on the fly* writebacks (no lookups were performed — the dispatch *created* the index). The first juror or builder or designer to invoke `library-lookup` against this seed will exercise the writebacks for the first time, and any rough edges will surface there.
- **The `[[concept-id]]` link convention** between concept pages mirrors the existing convention used in memory entries and a few section files; the convention is not yet formalized in `conventions.md` as a library-wide pattern — could be added the next time `conventions.md` is touched.
