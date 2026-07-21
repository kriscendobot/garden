# Ingest github.com/kriskowal/kni into the library — read it as agent-context scaffolding

Ingest `github.com/kriskowal/kni` (kriskowal's own repo) into `journal/library/` per
`journal/library/conventions.md` and `skills/context-library`. No bare clone exists;
read upstream content directly via `gh` / a scratch clone (record each file's per-file
commit sha for the idempotency check).

## What kni is

kni is a **language for expressing decision graphs** (interactive narrative / dialogue
trees originally, but read past the storytelling framing). Cover its **documentation,
design, usage, and examples** — the grammar, the runtime/engine model, how a graph is
authored, evaluated, and how state/choices thread through it.

## The lens to read it through (the reason we're ingesting it)

Do NOT ingest it as "a fiction-authoring toy." Read and frame it as a **potential tool
for deterministically rendering user feedback to an agent** — a way to encode common
tasks as decision graphs that an agent walks to **dig deep and develop context**
before/while acting. The thesis to test against the material: kni-style decision graphs
could be the **deterministic half of a mutually-reinforcing automatic ↔ agentic loop** —
the graph deterministically routes and elicits (asks the right next question, surfaces
the right context, records the user's answers as structured state), and the agent
supplies the open-ended reasoning the graph can't encode. Evaluate concretely:

- What does kni's graph/state model give us that ad-hoc prompting does not
  (determinism, replayability, resumability, auditable branch state)?
- How would a graph "render user feedback" — i.e. drive a bounded interview / triage /
  context-gathering flow whose transcript becomes durable agent context?
- Where does the deterministic graph END and agentic reasoning BEGIN — what's the seam,
  and what does each side hand the other?
- Fit and gaps as a garden tool: does it map onto how we already gather context (the
  liaison's ask-before-acting, the maintainer inbox, press/orchestration loops)? What
  would be missing to use it this way?

## Output

- Source-index + section files for the repo's docs/design/examples under
  `journal/library/sources/…` per conventions (abstract-at-top, many small files).
- At least one **concept** page capturing the idea itself — e.g.
  `decision-graph-as-agent-context-scaffold` (and/or `deterministic-elicitation-loop`) —
  linked to any existing concepts on agentic loops / context development, so the idea is
  findable by other roles in one or two queries, not just buried in a repo summary.
- A topic entry tying kni into the automatic↔agentic-loop line of thinking.
- Keep provenance explicit (kriskowal's repo). If evidence fans out beyond this job's
  budget, write what's supported, post a follow-on `scholar-ingest-kni` for the
  remainder, and complete. Route any structural lesson via `skills/self-improvement`
  (do not edit roles/skills).

Reason for ingest (record in the result entry): maintainer @kriskowal (2026-07-21, via
the liaison) is evaluating kni as a substrate for mutually-reinforcing automatic and
agentic loops.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 5
  worker_kind: gardener
  claimed_at: 2026-07-21T04:44:29Z
