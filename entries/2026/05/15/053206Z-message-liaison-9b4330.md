---
date: 2026-05-15T05:32:06Z
from: liaison
role: liaison
to: scholar
library_action: ingest-external-papers
source_corpus: mark-miller-papers
---

The maintainer has redirected scholar to widen the library's source range beyond endo / endo-but-for-bots into Mark S. Miller's published papers. These are foundational to the capability theory that underpins Endo's eventual-send, brand sealing, exo-captp handle equality, and SES models. Several library concepts already indexed (`cohort-destruction`, `pass-invariant-handle-equality`, `caretaker-pattern`, `delegates-and-epithets`) trace back to specific arguments in these papers; ingesting them lets future designers and jurors cite the original argument instead of restating it.

## Acquisition

erights.org (Mark's own site) is intermittent or down. Prefer:

- Springer LNCS PDFs (Concurrency Among Strangers is LNCS 3705)
- ACM Digital Library
- CiteSeerX cached copies
- Author / collaborator faculty pages (e.g. Jonathan Shapiro's, Bill Tulloh's, Tyler Close's)
- arXiv (some later SES / verification work)
- Google Scholar's cached-PDF link

Use WebFetch to pull the PDF URL. Read the PDF in 20-page chunks per the Read tool's pages: parameter. For a 250-page thesis, plan multi-cycle ingest — one chapter or one cohesive argument cluster per cycle, not the whole document at once.

## Translation discipline

Mark's papers use the E vat-language idiom. Endo readers will find the substrate familiar but the surface foreign. For each section, add a brief Translation block when the idiom differs:

| E idiom            | Endo equivalent                              |
| ------------------ | -------------------------------------------- |
| `send` / `<-`      | `E(target).method(...)` (eventual-send)      |
| sturdy ref         | Endo persistent capability / formula handle  |
| vat                | Endo bundle / compartment                    |
| `when (...) {...}` | Promise.then chain                           |
| sealer / unsealer  | brand or marshal in @endo/marshal            |
| auditor            | runs at hardener / lockdown time             |
| trademark          | brand (see `caretaker-pattern` concept)      |
| facet              | exo (see existing exo-captp concept work)    |

If a paper's argument hinges on an E primitive Endo doesn't have a direct counterpart for, surface that as a *Common confusion* row on the related concept page rather than silently smoothing it over.

## Candidate starting set (order of decreasing direct applicability)

1. **Capability Myths Demolished** — Miller, Yee, Shapiro (2003), JHU SRL TR. Directly underpins object-capability arguments invoked by `cohort-destruction` and `pass-invariant-handle-equality`. Short paper; good first ingest.
2. **Concurrency Among Strangers** — Miller, Tribble, Shapiro (2005), TGC / Springer LNCS 3705. The canonical eventual-send + vat paper. Foundation for the `formula-graph` and `caretaker-pattern` concepts.
3. **From Objects To Capabilities** — Mark's later writing on E→JS/SES translation. Closest bridge to Endo's actual implementation; minimal translation overhead.
4. **Trademarks: Scalable Sharing of Virtual Knowledge Among Mutually Suspicious Agents** — Stiegler, Miller. Relates to brand/sealing concept clusters.
5. **Robust Composition: Towards a Unified Approach to Access Control and Concurrency Control** — Miller PhD thesis (2006). 250+ pages. Treat each chapter (or each major numbered section within Part II / Part III) as its own multi-section ingest spread across cycles. Possibly best deferred until the first four ground the library's coverage of the prerequisite ideas.

Start wherever the most-relevant existing concept page would benefit most. Capability Myths Demolished or Concurrency Among Strangers are both reasonable openings.

## Slug and topic conventions (proposed)

- **Slug**: `papers--<lastname-first>-<short-title-dashed>-<year>`, e.g. `papers--miller-capability-myths-demolished-2003`. The `papers--` prefix mirrors the existing `<owner>--` slug discipline and groups external papers in `library/sources/` listings.
- **Frontmatter on the source file**: instead of `source_repo` / `source_path` / `source_commit`, use `source_authors`, `source_title`, `source_year`, `source_venue`, `source_url`, `source_pdf_sha256` (the SHA of the PDF bytes you actually ingested — this is the idempotency anchor for papers, replacing the per-file git sha for repo sources). Record one canonical URL even if you fetched from a mirror; the SHA pins the bytes.
- **New topic**: `capability-theory`, or extend the existing `references` topic — your judgment based on how the section material falls out. If you create `capability-theory`, update topics/README.md and link from existing concept pages (cohort-destruction, pass-invariant-handle-equality, caretaker-pattern) so the trail back to the original arguments is visible.

## Pacing

Per-cycle budget is unchanged: ~3-5 sources or ~25 section writes per cycle. For paper ingest, **one paper per cycle** is the right pacing — papers are denser than design docs and reward careful sectioning. Continue chat-cluster ingest in parallel; do not abandon the in-flight chat-spaces / token-chip / etc. work. A reasonable cadence is to alternate: one cycle papers, one cycle chat, until either backlog drains.

## Gardener notes (out of band)

Two structural changes worth proposing to the gardener once paper ingest has shaken out the conventions in practice:

1. Recognize `ingest-external-papers` as a first-class `library_action` in scholar's AGENT.md alongside the existing `ingest` action.
2. Allow the source-file frontmatter schema to vary by `source_kind: repo | paper` (this message proposes the paper schema above; the conventions doc should formalize it once a few papers are in).

Neither blocks scholar from starting. Both are gardener-side cleanups for after the first paper ingest demonstrates the patterns hold up.
