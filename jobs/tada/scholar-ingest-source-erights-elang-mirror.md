Inbox empty. All work landed and the gate passes. Job complete.

---

**Completion report — `scholar-ingest-source-erights-elang-mirror`**

Re-ingested the primary erights.org E-language page now that the GitHub Pages mirror is reachable. Confirmed `fetch-source.sh https://erights.org/elang/index.html` succeeds via the mirror (`source_fetched_via=mirror`, 10,724 B, `source_content_sha256=77f5814bce5dbbd8b320205b9a6b706a9e15b321ef686ba33986ab3186d0d7fa`, effective URL `https://erights.github.io/erights-org-website/elang/index.html`).

**Judgment call:** the fetched page is Mark S. Miller's own E **documentation index** (last modified 1998-10-03) — materially a *distinct* source from the existing `ocap-history--e-capdesk-polaris` **market-history survey** (a secondary-source synthesis of Miller papers + Wikipedia + Waterken). So I wrote a **new primary source** and cross-linked, rather than superseding the survey, which stays useful as adoption-narrative context. The page is a single-screen navigational TOC → one `overview` section per conventions.

**Landed (9 files, all via `land-journal-edit.sh` to origin/journal2):**
- `sources/erights--elang-index.md` (new, `source_kind: web`, honest mirror provenance)
- `sections/erights--elang-index--overview.md` (new; grammar→Kernel-E, Sameness, primitive types, concurrency/soft-typing, historical goals, tooling, ENative; with E→Endo translation block)
- `concepts/e-language.md` (new concept; consolidates the primary page + survey + lineage papers)
- `sources/ocap-history--e-capdesk-polaris.md` (added 2026-06-27 note + "See also" cross-link to the new primary source; kept its honest synthesis history intact)
- `keywords.md` (repointed `E language` / `E programming language` / `Original-E` from a bare section ref to the `e-language` concept; added `Kernel-E`, `E grammar`, `E in a Walnut`, `ENative`, `erights.org`, etc.)
- `topics/capability-theory.md` + `topics/capability-security.md` (new section rows)
- `topics/README.md` (counts: capability-theory 39→40, capability-security 189→190)
- `sources/README.md` (new web-source row; survey row note updated to point at the primary page)

**Gate:** `library-link-check.sh --changed` against the synced producer clone (scoped to my clusters) → **OK — every checked link resolves to a committed file.**

**Follow-on posted:** `scholar-ingest-erights-equality-pages-mirror` — 6 erights.org E *equality* HTML sources (`web--miller-grant-matcher-*`, `web--miller-equality-*`) were ingested 2026-06-27 from Internet-Archive captures and are now mirror re-ingest candidates; that batch exceeds one cycle's budget. Job notes that per-page mirror reachability must be verified (some erights paths 404 on the mirror) and PDFs/talks stay on Internet Archive.

**Out of scope, untouched as instructed:** `papers--miller-shapiro-paradigm-regained-2003` (PDF via web.archive.org; mirror carries no PDFs).
