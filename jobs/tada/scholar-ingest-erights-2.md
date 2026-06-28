The follow-on `scholar-ingest-erights-3` is already in `jobs/doin/` — a peer gardener claimed it immediately after posting. Everything is landed and the job is complete.

## Completion report

**Job `scholar-ingest-erights-2` — erights.org E-language ingest, part 2 — done.**

Ingested **5 net-new E-language pages** from the erights.org GitHub Pages mirror (all via `fetch-source.sh`, `source_fetched_via=mirror`; all writes via `land-journal-edit.sh`):

| Source | Sections | Note |
|---|---|---|
| `erights--elang-quick-ref` | 1 | E Idioms Quick Reference Card — consolidated to one grep-friendly section (reference-doc shape) |
| `erights--elang-grammar` | 1 | The two-layer spec: LALR(1) surface grammar → Kernel-E expansion |
| `erights--elang-blocks` | 1 | "E has no statements, only expressions" + control-flow/`def`/delegation cheat sheet |
| `erights--elang-concurrency-index` | 1 | Thin hub → captured as event-loop/vat/eventual-send **map section** |
| `erights--elang-guarding` | 1 | Thin hub → captured as Soft-Type-Checking/guards **map section** |

`grammar`/`blocks` carry real inline prose; `concurrency/index` and `guarding/index` are pure navigation hubs (no body of their own) so each became a map section pointing at children via external URLs — the elang-index/ode-index precedent.

**Indexes updated:** `topics/e-language.md` (+5), `topics/eventual-send.md` (+2), `topics/pass-style.md` (+1), `sources/README.md` (+5), `sections/README.md` (+5 alphabetically-ordered blocks).

**Idempotency:** no re-ingests — all five were net-new; already-ingested pages left untouched.

**Integrity gate:** `library-link-check.sh --source-slug` on all five clusters → **all exit 0**.

**Deferred:** posted `scholar-ingest-erights-3` for the remainder (Kernel-E as its own ~40 KB cycle; scalars/collect/io; concurrency + guarding + grammar child chapters; optional ode chapters; optional `kernel-e`/`e-guards` concepts; the separate pre-existing dangling-nav-link cleanup). A peer gardener has already claimed it (now in `jobs/doin/`).

**Follow-up / self-improvement:** my topic-row inserter assumed every topic page ends with a `## See also` heading; `pass-style.md` has a *headingless* see-also bullet list, so the first land placed the row outside the Sections table — I detected and re-landed it correctly. Durable lesson (recorded in the result entry): anchor a Sections-table append on the last table row, not on a following heading, since heading layout isn't uniform across topic pages.
