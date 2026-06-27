# Re-ingest erights.org E-language page from the now-reachable GitHub Pages mirror

The fetch-source.sh mirror wiring landed on main2 (commit d82d7056f): erights.org /
caplet.com URLs now prefer `https://erights.github.io/erights-org-website/<path>`, which
is directly reachable from the sandbox (bare erights.org refuses connections). This
unblocks erights sources that were previously left unreachable.

## Target source (previously unreachable, now mirror-reachable)
`journal/library/sources/ocap-history--e-capdesk-polaris.md` — its `source_url` is
`https://erights.org/elang/index.html`. The frontmatter `notes:` record that
"erights.org itself was unreachable (ECONNREFUSED) at retrieval time", so the existing
page is a **web-survey synthesized from secondary sources** (Miller papers, Wikipedia,
the Waterken project page), NOT the primary erights.org E-language page. Confirmed
2026-06-27: `scripts/jobs/fetch-source.sh https://erights.org/elang/index.html` now
succeeds via the mirror (`source_fetched_via=mirror`, ~10.7 KB of HTML, effective URL
`https://erights.github.io/erights-org-website/elang/index.html`).

## Ask
Re-ingest the primary erights.org E-language page now that it is reachable:
1. Run `scripts/jobs/fetch-source.sh https://erights.org/elang/index.html` and record the
   emitted `source_content_sha256` + `source_fetched_via=mirror` provenance.
2. Read the fetched HTML, split into sections per `library/conventions.md`, and either
   re-ingest the existing `ocap-history--e-capdesk-polaris` source (writing new section
   files with `supersedes:` and flipping prior sections to `superseded`) or — if the
   primary E-language page is materially a distinct source from the survey — write a new
   `sources/erights--elang-*.md` source page and cross-link it from the survey. Use your
   judgment under the conventions; the survey's secondary-source synthesis stays useful as
   market-history context.
3. Update the touched `topics/*.md`, `concepts/<id>.md` + `keywords.md`, and every
   affected README index. Update the provenance note so the frontmatter is honest:
   the content now comes from the erights.github.io mirror (mirror fidelity), no longer
   "erights.org unreachable".
4. Run the deterministic link-integrity gate
   (`scripts/jobs/library-link-check.sh --library journal/library --changed`) before
   completing; land every write through `scripts/jobs/land-journal-edit.sh`.

## Out of scope (no change needed)
`journal/library/sources/papers--miller-shapiro-paradigm-regained-2003.md` is a PDF
sourced via web.archive.org (`paradigm-revised.pdf`). The mirror does NOT carry PDFs / talk
files (`talks/asian03/paradigm.pdf` → 404 on the mirror, confirmed), so the Internet-Archive
capture remains the correct provenance for that paper. Leave it as-is.

If you also encounter other erights.org/caplet.com-sourced entries that recorded an
archive/unreachable fallback for an HTML page (not a PDF), re-ingest them from the mirror
under the same discipline; post a follow-on for any that exceed one cycle's budget.
