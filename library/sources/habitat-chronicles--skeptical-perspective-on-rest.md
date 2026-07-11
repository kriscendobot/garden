---
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/
source_content_sha256: b2248ed5e0aab5476282172f0e0b86c4a9580ce760045d93b3094072641329a2
source_author: Chip Morningstar
source_date: 2017-11-24
retrieved: 2026-07-11
ingested: 2026-07-11
ingested_by: scholar
section_count: 7
status: current
notes: |
  Third ingest from **habitat-chronicles.com** (the dashed live domain; the non-dashed
  `habitatchronicles.com` is STALE/dead — always cite the dashed form). Chip
  Morningstar's skeptical-but-fair critique of **REST**, written from his time in
  PayPal's Central Architecture organization. It is the **affirmative counterpart** to
  the sibling [unum-pattern](habitat-chronicles--unum-pattern.md) essay's claim that
  behavioral distributed-object protocols are "about as anti-REST as you can be": the
  same descriptive/representational-vs-imperative/behavioral fault line, argued from the
  REST side. Fetched live (`source_fetched_via=direct`); the content hash is the
  idempotency anchor. Cross-links the `habitat-unum` concept (the representational-vs-
  behavioral section is the affirmative half of the unum's anti-REST argument), the new
  `representational-vs-behavioral` concept created this cycle, and the sibling
  [what-are-capabilities](habitat-chronicles--what-are-capabilities.md) essay's
  service-chaining / confused-authority material (the authority-boundaries section).
  Ingested under maintainer job `scholar-ingest-source-habitat-chronicles-3`; a follow-on
  `-4` job carries the rest of the germane set (The Tripartite Identity Pattern,
  Adventures in LLM Land).
---

## Abstract

Chip Morningstar's collection of skeptical-but-fair observations about **REST**
(Representational State Transfer), written out of his work in PayPal's Central
Architecture organization. There is no single unifying thesis; the essay is an antidote
to the **dogma** around REST, which Morningstar traces ironically to the *lack* of a
clear objective definition (Roy Fielding as "a rather enigmatic oracle"). He declines the
"is it *really* REST?" litmus test and asks instead whether a design *works well for its
purpose*. The through-line most germane to the garden's distributed-object / ocap lineage
is the distinction between REST's **representational / descriptive mode** (a world of
data objects whose primary characteristic is current state — REST's good fit) and the
**imperative / behavioral mode** (functional objects whose primary characteristic is
behavior — where "a RESTful interpretation is much more strained"), and the **profound
asymmetry** that REST fixes its verbs while leaving nouns open. This is exactly the
affirmative counterpart to the unum pattern's "behavioral, not data — about as anti-REST
as you can be." The essay also anatomizes REST's **authority-boundary confusion**
(visibility vs. authoritativeness; the product-catalog example of aligning resource
splits with authority; client-vs-server division of labor), the **limits of HATEOAS for
machine clients** (humans are general-purpose context interpreters with a built-in
ontology, machines are blind; transitions are *referenced but not described*; the
analysis happens at development time, not use time — "the client must be anticipatory
whereas the human user can be reactive"), the **PUT/POST/PATCH verb muddle** and the
read-modify-write problem, and the **statelessness / polling** critique (state1 vs state2;
the server cannot speak first, so the client must poll, and caching does not fix it) —
which is precisely the server-initiated-notification affordance the E-vat / eventual-send
lineage provides by construction.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [A Slightly Skeptical Perspective on REST — framing and the "is it REST?" trap](../sections/habitat-chronicles--skeptical-perspective-on-rest--overview.md) | networking, distributed-objects | current |
| [Pro and con — what REST gets right and what it gets wrong](../sections/habitat-chronicles--skeptical-perspective-on-rest--helpful-and-unhelpful-rest-ideas.md) | networking, distributed-objects | current |
| [Representational (descriptive) vs. imperative (behavioral) — the resource conceit and its asymmetry](../sections/habitat-chronicles--skeptical-perspective-on-rest--representational-vs-imperative-descriptive-vs-behavioral.md) | distributed-objects, networking | current |
| [Authority boundaries — visibility vs. authoritativeness, and client vs. server representation](../sections/habitat-chronicles--skeptical-perspective-on-rest--authority-boundaries-visibility-vs-authoritativeness.md) | distributed-objects, capability-theory | current |
| [HATEOAS and the limits of hypermedia for machine clients (and the GET-abuse temptation)](../sections/habitat-chronicles--skeptical-perspective-on-rest--hateoas-and-the-limits-of-hypermedia.md) | networking, distributed-objects | current |
| [PUT, POST, PATCH, DELETE — the verb-semantics muddle and the read-modify-write problem](../sections/habitat-chronicles--skeptical-perspective-on-rest--put-post-and-http-verb-semantics.md) | networking | current |
| [What is this "state"? — state1 vs state2, statelessness, and why polling is the wrong primitive](../sections/habitat-chronicles--skeptical-perspective-on-rest--state-statelessness-and-polling.md) | networking, distributed-objects, eventual-send | current |
