---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-21T05:05:54Z
---
---
role: scholar
job: scholar-ingest-kni
date: 2026-07-21
---

# Ingested kriskowal/kni (decision-graph language) into the library

**Reason for ingest:** maintainer @kriskowal (2026-07-21, via the liaison) is
evaluating **kni** as a substrate for mutually-reinforcing automatic and agentic
loops — kni-style decision graphs as the deterministic half that routes, elicits,
and records structured context while an agent supplies open-ended reasoning.

No bare clone existed; read upstream directly via `gh` + a scratch clone of
`kriskowal/kni`, recording each file's per-file commit sha for the idempotency
anchor. Fresh ingest (no prior `kni--*` sources) — idempotency check trivially
passed.

## Sources ingested (5 docs → 20 section files)

- `kni--readme` (README.md, commit `120fd885`, 2 sections): overview + the CLI
  transcript/verify/JSON/`-d` diagnostic surface.
- `kni--manual` (MANUAL.md, commit `120fd885`, 10 sections): the language
  reference — text/symbols, indentation-threads, options-and-questions,
  input-prompts, flow-directives, procedures, blocks (sequences/alternation +
  switch/conditions/modifiers), expressions-conditions-consequences.
- `kni--howto` (HOWTO.md, commit `5e66290e`, 2 sections): the graduated tutorial
  (tutorial-shape, soft-flagged as overlapping MANUAL at a gentler altitude).
- `kni--hackni` (HACKNI.md, commit `0d6e2949`, 4 sections): implementation tour —
  parser-pipeline, runtime-engine, runtime-hooks (the handler seam), and
  dialogs-and-renderers. Most lens-load-bearing doc.
- `kni--inkkni` (INKKNI.md, commit `3a62b89e`, 2 sections): differences from
  Inkle's Ink and the capability boundary (the "gaps" of the fit assessment).

## Topics + concepts authored

- New topic **`decision-graph-authoring`** (20 sections): the kni language/engine,
  framing-neutral.
- New topic **`automatic-agentic-loop`** (8 sections): the deterministic ↔ agentic
  loop line of thinking, tying kni in as a candidate deterministic half.
- New concept **`decision-graph-as-agent-context-scaffold`**: the idea (encode
  tasks as graphs an agent walks to develop context) + fit assessment
  (determinism/replayability/resumability/auditable branch state; the
  32-bit-integer state gap; the handler seam where the agentic half plugs in).
- New concept **`deterministic-elicitation-loop`**: the route→elicit→record
  mechanism, where the seam falls, what each side hands the other; grounded in
  kni's input capture + handler `ask`/`answer`/`get`/`set` + waypoint/resume +
  transcript/verify. Both link to existing `[[human-in-the-loop]]`,
  `[[multi-agent-handoff]]`, `[[context-pruning]]`, `[[objectives-over-state-machine]]`.

## Indexes updated

`sources/README.md` (new "kriskowal/kni" section), `topics/README.md` (2 Index
rows; counts 20/8 matched the projection), `concepts/README.md` (2 bullets),
`keywords.md` (seeded a kni pointer block onto the previously-empty file).

## Integrity gate (step 8)

- `library-link-check.sh --changed --wikilinks`: **OK** — every newly-introduced
  link resolves to a committed file (6 pre-existing danglers on unrelated
  shared-index rows are advisory only).
- `regenerate-topics-counts.sh --check`: **counts current** (my hand-set 20/8
  matched the projection exactly).
- Final landing step: `regenerate-sections-index.sh` regenerated + landed
  `sections/README.md` (25 kni rows now present); `regenerate-topics-counts.sh`
  already current, nothing to land.

## Follow-on / deferred

Posted **`scholar-ingest-kni-examples`** for the `examples/*.kni` corpus (the
worked examples — `read.kni` bot-interview, `calc.kni`/`door-lock.kni` state
machines, etc.), read through the same lens. Key examples were cited inline in
the sections this cycle; a dedicated pass files them as worked-example sections.
Lower-value CHANGE.md / kni.usage noted as optional in that job.

Provenance kept explicit throughout: every section footer links kriskowal's
`github.com/kriskowal/kni` file at its captured commit; the concept pages state
the evaluation framing is the maintainer's ask.
