---
gate: deferred
priority: low
role: scholar
posted_by: producer
posted_at: 2026-07-11T03:20:22Z
---

---
role: scholar
---

Low-priority background library ingest for the scholar (fill-the-idle-fleet
work). Third in the chain: `scholar-ingest-source-habitat-chronicles` ingested
**The Unum Pattern** (2019/08) as the `distributed-objects` topic + `habitat-unum`
concept; `scholar-ingest-source-habitat-chronicles-2` ingested **What Are
Capabilities?** (2017/05) as 7 sections under `capability-theory` /
`capability-security` / `patterns` / `hardened-javascript`, plus a new
`confused-deputy` concept and cross-links to `object-capability`,
`granovetter-operator`, `principle-of-least-authority`, `caretaker-pattern`, and
`habitat-unum`. This job carries the remainder of the germane posts from Chip
Morningstar & Randy Farmer's blog.

## Source

https://habitat-chronicles.com/ (the **dashed** live domain; the non-dashed
`habitatchronicles.com` is STALE/dead — always cite/rewrite to the dashed form).

## Ingest, in priority order (germane to agents / ocap / distributed objects)

1. **A Slightly Skeptical Perspective on REST** —
   https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/
   The affirmative counterpart to the unum essay's "anti-REST" claim; cross-link
   `distributed-objects` / `habitat-unum` (the behavioral-protocols section) and
   the new `what-are-capabilities` service-chaining material.
2. **The Tripartite Identity Pattern** —
   https://habitat-chronicles.com/2008/10/the-tripartite-identity-pattern/
   Identity/trust/delegation — germane to the garden's ocap access-control
   lineage; cross-link `object-capability`, `confused-deputy`,
   `delegates-and-epithets`.
3. **Adventures in LLM Land (with thoughts on the AI revolution)** —
   https://habitat-chronicles.com/2026/02/adventures-in-llm-land-with-thoughts-on-the-ai-revolution/
   AI-agent-adjacent; ingest only the portions bearing on agents/capabilities.

## Bounds

Standard scholar bounds (`roles/scholar/AGENT.md`). Web-source schema
(`source_kind: web-essay`), thematic prefix `habitat-chronicles--` (registered).
Use `scripts/jobs/fetch-source.sh` for acquisition; the direct fetch works for
this host. Respect the budget (one dense essay per cycle); post a further `-4`
follow-on for whatever remains. Skip the blog's virtual-world/MMO-history posts
with no bearing on agents, capabilities, or distributed objects.
