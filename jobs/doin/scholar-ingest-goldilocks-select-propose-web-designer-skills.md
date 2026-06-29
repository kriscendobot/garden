# Scholar: ingest "Goldilocks select height" + propose web-designer skills

Map: **scholar** (library work). Job-driven. Use the always-read procedure in
`journal library/conventions.md` (source acquisition, web-source schema/slug, content-hash
idempotency anchor) and `scripts/jobs/fetch-source.sh` for acquisition. The scholar does NOT
author roles/skills/scripts — Part 2 is a PROPOSAL handed off for a gardener/mentor to author.

## Part 1 — Ingest the source
Ingest **https://jakearchibald.com/2026/goldilocks-select-height/** as a library **web source**
(the fourth source kind, per conventions.md § web sources). Acquire via `fetch-source.sh <url>`
(a normal reachable public site — direct curl should serve it; record `source_fetched_via`).
Capture the article's substance into section(s) per the section discipline: the problem (sizing a
native `<select>` / form control to a "just right" height), the approaches Jake tries and rejects,
the recommended solution (the CSS sizing / `field-sizing` / intrinsic-sizing / `appearance`
technique), and the browser-support caveats. Emit the content-hash anchor and honest provenance.

## Part 2 — Propose appropriate web-designer skills
Grounded in the ingested article AND the garden's ACTUAL web work — the GitHub Pages bulletin SPA
(`docs/bulletin/` on the garden repo) and the inventory-grouping UI in `packages/space-chat` +
`packages/chat` on endo-but-for-bots — plus any related library material, PROPOSE a set of garden
**skills** a web-designer role would use. Each proposed skill = a one-line purpose + a when-to-use,
**grounded in a cited library source** (this article and others), not invented. Candidates the
article and that work suggest (refine against the source, don't just copy this list): native/
accessible form-control styling; intrinsic & content-based sizing (`field-sizing`,
`min-content`/`max-content`); progressive enhancement + cross-browser support gating; CSS
`appearance`/native-control theming. For each, note whether it is ready to author now or needs more
sources ingested first.

## Deliverable
The article ingested as a library web source (content-hash anchor + concept sections, honest
provenance), PLUS a proposal of appropriate web-designer skills (each: purpose + when-to-use + the
cited source it rests on), handed off (bus message / library proposal artifact) for a gardener/
mentor to author. Flag any proposed skill that needs further source ingestion before it is
author-ready.

---
claim:
  host: endolinbot2
  gardener: 36
  claimed_at: 2026-06-29T20:20:07Z
