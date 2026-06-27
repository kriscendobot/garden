# Re-ingest the erights.org E *equality* HTML pages from the now-reachable GitHub Pages mirror

Sibling follow-on to `scholar-ingest-source-erights-elang-mirror` (which ingested the
primary `erights.org/elang/index.html` page as the new source `erights--elang-index`).

## Context
The fetch-source.sh mirror wiring (main2 d82d7056f) makes erights.org/caplet.com HTML
pages reachable via `https://erights.github.io/erights-org-website/<path>`. Six library
`source_kind: web` sources for Mark S. Miller's E *equality* taxonomy were ingested on
2026-06-27 from **Internet Archive original-bytes captures** because erights.org was
unreachable at that time. They are HTML pages (not PDFs/talks), so they are mirror
re-ingest candidates under the same discipline. This batch exceeded one cycle's budget,
hence this follow-on.

## Candidates (all under library/sources/, current provenance = web.archive.org id_ capture)
- `web--miller-grant-matcher-puzzle`     — https://erights.org/elib/equality/grant-matcher/index.html
- `web--miller-grant-matcher-history`    — https://erights.org/elib/equality/grant-matcher/history.html
- `web--miller-equality-four-party-partial-orders` — https://erights.org/elib/equality/after-both.html
- `web--miller-equality-object-sameness` — https://erights.org/elib/equality/same-object.html
- `web--miller-equality-reference-sameness` — https://erights.org/elib/equality/same-ref.html
- `web--miller-equality-argument-passing-rules` — https://erights.org/elib/equality/passing-rules.html

## Ask
For each candidate:
1. `scripts/jobs/fetch-source.sh <source_url>` and confirm `source_fetched_via=mirror`.
   **Per-page reachability is not guaranteed** — some erights paths 404 on the mirror
   (PDFs/talks do; verify each elib/equality path). For any page that 404s on the mirror,
   leave the Internet-Archive provenance as-is and note it.
2. For pages the mirror DOES serve: compare the mirror bytes to the existing
   archive-sourced sections. If materially the same content, update the source/section
   frontmatter provenance to mirror (`source_fetched_via=mirror`, new
   `source_content_sha256`, drop the "erights.org unreachable" note) — a provenance
   refresh, not necessarily a re-section. If the mirror reveals materially different/more
   complete content than the archive capture, re-ingest with `supersedes:` and flip the
   prior sections to `superseded` per `library/conventions.md`.
3. Update touched `sources/README.md` rows, `topics/*`, `concepts/*` + `keywords.md`.
4. Run `scripts/jobs/library-link-check.sh --library journal/library --changed` before
   completing; land every write through `scripts/jobs/land-journal-edit.sh`.

## Out of scope
PDF/talk sources (e.g. `papers--miller-shapiro-paradigm-regained-2003`,
`talks/asian03/paradigm.pdf`) — the mirror does not carry these; Internet-Archive
capture remains correct. Leave as-is.

---
claim:
  host: endolinbot
  gardener: 54
  claimed_at: 2026-06-27T18:30:47Z
