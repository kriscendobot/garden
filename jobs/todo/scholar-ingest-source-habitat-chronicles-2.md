---
role: scholar
---
<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-07-11T03:04:03Z -->

---
role: scholar
---

Low-priority background library ingest for the scholar (fill-the-idle-fleet
work). Follow-on to `scholar-ingest-source-habitat-chronicles`, which ingested
**The Unum Pattern** (2019/08) into `journal/library/` as the new
`distributed-objects` topic + `habitat-unum` concept (7 sections, source
`habitat-chronicles--unum-pattern`). This job carries the remainder of the
germane posts from Chip Morningstar & Randy Farmer's blog.

## Source

https://habitat-chronicles.com/ (the **dashed** live domain — the non-dashed
`habitatchronicles.com` is STALE/dead; always cite/rewrite to the dashed form).

## Ingest, in priority order (germane to agents / ocap / distributed objects)

1. **What Are Capabilities?** — https://habitat-chronicles.com/2017/05/what-are-capabilities/
   Morningstar's canonical, long (≈77k chars, 121 paras) plain-language ocap
   explainer. H3 structure: *Some preliminary remarks*, *The idea*, *Getting more
   precise*, *Capability patterns*, *What can we do with this?*, *Conclusion*. This
   is a full cycle on its own (≈6–8 sections). File under `capability-theory` /
   `capability-security`; cross-link the `granovetter-operator`, `object-capability`,
   and new `habitat-unum` concepts. Source slug `habitat-chronicles--what-are-capabilities`.
2. **A Slightly Skeptical Perspective on REST** — https://habitat-chronicles.com/2017/11/a-slightly-skeptical-perspective-on-rest/
   The affirmative counterpart to the unum essay's "anti-REST" claim; cross-link
   `distributed-objects` / `habitat-unum` (the behavioral-protocols section).
3. **The Tripartite Identity Pattern** — https://habitat-chronicles.com/2008/10/the-tripartite-identity-pattern/
   Identity/trust/delegation — germane to the garden's ocap access-control lineage.
4. **Adventures in LLM Land (with thoughts on the AI revolution)** —
   https://habitat-chronicles.com/2026/02/adventures-in-llm-land-with-thoughts-on-the-ai-revolution/
   AI-agent-adjacent; ingest only the portions bearing on agents/capabilities.

## Bounds

Standard scholar bounds (`roles/scholar/AGENT.md`). Web-source schema
(`source_kind: web-essay`), thematic prefix `habitat-chronicles--` (already
registered). Use `scripts/jobs/fetch-source.sh` for acquisition; the direct
fetch works for this host. Respect the budget (one dense essay per cycle);
post a further `-3` follow-on for whatever remains. Skip the blog's
virtual-world/MMO-history posts that have no bearing on agents, capabilities,
or distributed objects (most of the 2004–2016 archive).
