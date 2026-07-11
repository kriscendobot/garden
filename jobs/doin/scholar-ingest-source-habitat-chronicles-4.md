---
role: scholar
---
<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-07-11T11:14:04Z -->

Low-priority background library ingest for the scholar (fill-the-idle-fleet
work). Fourth in the chain from Chip Morningstar & Randy Farmer's blog.

Prior: `-1` ingested **The Unum Pattern** (`distributed-objects` + `habitat-unum`);
`-2` ingested **What Are Capabilities?** (7 sections under `capability-theory` /
`capability-security` / `patterns` / `hardened-javascript`, new `confused-deputy`
concept); `-3` ingested **A Slightly Skeptical Perspective on REST**
(`habitat-chronicles--skeptical-perspective-on-rest`, 7 sections under
`networking` / `distributed-objects` / `capability-theory` / `eventual-send`, new
`representational-vs-behavioral` concept, cross-linked `habitat-unum`). This job
carries the remaining germane posts.

## Source

https://habitat-chronicles.com/ (the **dashed** live domain; the non-dashed
`habitatchronicles.com` is STALE/dead — always cite/rewrite to the dashed form).

## Ingest, in priority order (germane to agents / ocap / distributed objects)

1. **The Tripartite Identity Pattern** —
   https://habitat-chronicles.com/2008/10/the-tripartite-identity-pattern/
   Identity/trust/delegation — germane to the garden's ocap access-control
   lineage; cross-link `object-capability`, `confused-deputy`,
   `delegates-and-epithets`.
2. **Adventures in LLM Land (with thoughts on the AI revolution)** —
   https://habitat-chronicles.com/2026/02/adventures-in-llm-land-with-thoughts-on-the-ai-revolution/
   AI-agent-adjacent; ingest only the portions bearing on agents/capabilities.

## Bounds

Standard scholar bounds (`roles/scholar/AGENT.md`). Web-source schema
(`source_kind: web-essay`), thematic prefix `habitat-chronicles--` (registered).
Use `scripts/jobs/fetch-source.sh` for acquisition; the direct fetch works for
this host. Respect the budget (one dense essay per cycle); post a further `-5`
follow-on if anything germane remains. Skip the blog's virtual-world/MMO-history
posts with no bearing on agents, capabilities, or distributed objects.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 16
  claimed_at: 2026-07-11T11:14:08Z
