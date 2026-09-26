Both halves complete. Final report:

---

## Completion report: `scholar-erights-github-pages-mirror-source`

### Build half (landed on `origin/main2`, commit `d82d7056f`)
Wired the erights.org GitHub Pages mirror into the source fetcher. Built in an isolated worktree off `origin/main2`, committed with explicit pathspecs, pushed `HEAD:main2` via rebase-CAS (clean on attempt 1).

**`scripts/jobs/fetch-source.sh`** — new acquisition order for `erights.org`/`caplet.com` URLs:
1. direct `curl` (unchanged),
2. **NEW** — rewrite to `https://erights.github.io/erights-org-website/<path>` (strips a leading `http(s)://(www.)?{erights.org,caplet.com}/`, preserves the path) and curl it; on 200 use those bytes and record `source_fetched_via=mirror`,
3. existing Internet-Archive `id_` original-bytes fallback for what the mirror lacks.

The rewrite is gated on the erights/caplet host (a `[[ =~ ]]` capture), so other URLs skip the mirror. `source_fetched_via` now reports `direct|mirror|wayback` so provenance is honest. Header doc, manifest-field doc, and exit-code notes updated to match.

**`scripts/jobs/test/fetch-source-test.sh`** — stub recognizes the mirror host; three new cases: HTML→mirror-200 (asserts the path-preserving rewrite + archive untouched), PDF→mirror-404→archive (asserts fallthrough order), non-erights→mirror-skipped. **30/30 pass.**

**`roles/scholar/AGENT.md`** — fetch note (~line 69) now names the erights.github.io mirror as the primary substitute with the "PDFs not mirrored → archive fallback" caveat, in one sentence in the existing style.

**Verification** — against the three known paths, live, from the bot host:
- `elang/index.html` → mirror 200 (10,724 B), effective URL correctly rewritten ✓
- `elib/capability/ode/index.html` → mirror 200 (8,228 B) ✓
- `talks/asian03/paradigm.pdf` → mirror 404 (rc=22) → drops through to archive ✓ (order confirmed)

### Re-ingest half (scholar work — posted as a job, per the role split)
Enumerated erights/caplet-sourced library entries. Two exist:
- `sources/ocap-history--e-capdesk-polaris.md` (`source_url: https://erights.org/elang/index.html`) — its frontmatter records erights.org was **ECONNREFUSED at retrieval time**, so the page is a web-survey from secondary sources, not the primary E-language page. The mirror now serves it (confirmed). **Posted `scholar-ingest-source-erights-elang-mirror`** with precise instructions to re-ingest from the mirror, supersede/cross-link under the conventions, fix the provenance note, and run the link-integrity gate.
- `sources/papers--miller-shapiro-paradigm-regained-2003.md` — a PDF via web.archive.org. The mirror carries no PDFs, so the archive remains correct provenance; marked out-of-scope in the posted job.

I did the script/role/test edits as the build agent and split the scholar ingestion to a posted job, since the scholar may not edit scripts/roles.

### Follow-ups
- The posted `scholar-ingest-source-erights-elang-mirror` job is on `todo/` awaiting a gardener wearing the scholar hat.
- Worktree and temp files cleaned up; no other erights HTML sources were found beyond the one re-ingest target.

Self-improvement: the mirror substitute generalizes the existing archive-fallback pattern — a useful template for any future "primary host unreachable but a path-preserving mirror exists" source.
