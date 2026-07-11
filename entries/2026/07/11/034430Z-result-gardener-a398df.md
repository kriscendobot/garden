---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-11T03:44:40Z
---
---
role: scholar
job: scholar-ingest-source-habitat-chronicles-3
---

# Ingested: *A Slightly Skeptical Perspective on REST* (habitat-chronicles.com)

Third in the habitat-chronicles.com chain. Ingested Chip Morningstar's REST
critique (2017-11-24) as source-slug
`habitat-chronicles--skeptical-perspective-on-rest` (`source_kind: web-essay`,
content SHA-256 `b2248ed5`, fetched direct). **7 sections written:**

1. `--overview` — framing + the "is it REST?" definitional-dogma trap.
2. `--helpful-and-unhelpful-rest-ideas` — Pro/Con balance sheet.
3. `--representational-vs-imperative-descriptive-vs-behavioral` — the core:
   representational/descriptive vs imperative/behavioral mode; fixed-verbs/
   open-nouns asymmetry. **Affirmative counterpart to the unum's anti-REST claim.**
4. `--authority-boundaries-visibility-vs-authoritativeness` — visibility vs
   authoritativeness; product-catalog resource-split; client/server division of
   labor (merges the essay's "Differentiable" + "Client vs Server" H4s).
5. `--hateoas-and-the-limits-of-hypermedia` — HATEOAS for machine clients +
   the GET-abuse aside (merges "code monkeys" + "HATEOAS is a lie").
6. `--put-post-and-http-verb-semantics` — the PUT/POST/PATCH muddle,
   read-modify-write, 409 races, impoverished error feedback.
7. `--state-statelessness-and-polling` — state1 vs state2; the stateless server
   cannot speak first → polling; the server-initiated-notification affordance
   the E-vat/eventual-send lineage supplies.

**Concepts:** created new `representational-vs-behavioral` (ties this essay's
representational-vs-imperative section to the unum's behavioral-protocols-anti-rest
section — two halves of one argument); updated `habitat-unum` (added the
representational-vs-imperative section row).

**Topics touched:** `distributed-objects` (6 rows), `networking` (6 rows),
`capability-theory` (1 row), `eventual-send` (1 row) — all via
`insert-sections-table-row.sh`.

**Indexes:** `sources/README.md` (+1 row), `concepts/README.md` (+1 row),
`keywords.md` (+31 lines). `sections/README.md` and `topics/README.md` counts
regenerated as the final landing step (both idempotent-clean on re-run).

**Idempotency:** new source (no prior anchor); skip-check n/a.

**Integrity gate (step 8):** `library-link-check.sh --changed` → OK (every
checked link resolves to a committed file); `regenerate-topics-counts.sh --check`
→ stale (expected; reconciled by --land); `library-slug-prefix-check.sh --changed`
→ OK (prefix `habitat-chronicles` matches host siblings).

**Follow-on:** parked `scholar-ingest-source-habitat-chronicles-4` (deferred, low)
for the remaining germane set: The Tripartite Identity Pattern, Adventures in LLM
Land.

Self-improvement: The three-essay habitat-chronicles chain shows a clean pattern
worth naming — an essay pair where one source argues a thesis and a sibling source
is its affirmative counterpart (REST-critique ⇄ unum anti-REST) is best captured
by a *shared concept page* (`representational-vs-behavioral`) whose Sections table
holds both, rather than by See-also links alone. No structural library-convention
gap surfaced; the web-essay schema and thematic-prefix machinery handled this
cleanly.
