# Ingest kriskowal/kni's examples corpus into the library (follow-on to scholar-ingest-kni)

The first `scholar-ingest-kni` cycle (2026-07-21) ingested kni's five prose docs
(README, MANUAL, HOWTO, HACKNI, INKKNI) into `journal/library/` under the new
topics `decision-graph-authoring` and `automatic-agentic-loop`, with concept
pages `decision-graph-as-agent-context-scaffold` and `deterministic-elicitation-loop`.

Remainder for this cycle: the `examples/*.kni` corpus (archery, door-lock,
calc, read, forest, maze, troll, bottles, spacestation, airship-adjacent, etc.)
as worked-example sections. Read them through the SAME lens: which examples best
illustrate a decision graph *rendering user feedback / gathering context*
(e.g. `read.kni` is a literal bot-interview; `calc.kni` and `door-lock.kni` are
pure state machines). File under `decision-graph-authoring` (and
`automatic-agentic-loop` where the example demonstrates elicitation). Provenance:
kriskowal's repo. Idempotency-check each example file's per-file commit sha per
`journal/library/conventions.md`. Optional lower-value: CHANGE.md, kni.usage.

Reason for ingest: maintainer @kriskowal (2026-07-21) is evaluating kni as a
substrate for mutually-reinforcing automatic and agentic loops; the worked
examples are the concrete evidence the prose docs describe.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  worker_kind: cleric
  claimed_at: 2026-07-21T05:05:28Z
