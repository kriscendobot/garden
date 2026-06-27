# Wire the erights.org GitHub Pages mirror into fetch-source.sh; re-ingest previously-unreachable erights sources

Map: **build** (garden infra) on the garden's own repo, branch main2 — for the
fetch-source.sh / role / test edits (scholar may NOT edit scripts/roles itself). Isolated
worktree off origin/main2; explicit-pathspec commit; push HEAD:main2 via git-rebase CAS.
The RE-INGEST half is scholar work (post `scholar-ingest-source` follow-ons, or hand off).

Maintainer directive 2026-06-27: the scholar can use
`https://erights.github.io/erights-org-website/` as a substitute for erights.org and
should ingest sources it was previously unable to reach.

## Verified facts (empirical, from the bot host)
- Bare `erights.org` REFUSES connections from the sandbox (curl exit 7) — confirmed; the
  existing fetch-source.sh Internet-Archive fallback exists for exactly this.
- The GitHub Pages mirror `https://erights.github.io/erights-org-website/` is directly
  reachable (HTTP 200) and **preserves erights.org paths**: `elang/index.html` and
  `elib/capability/ode/index.html` both → 200.
- BUT the mirror does NOT carry PDFs / talk files: `talks/asian03/paradigm.pdf` → 404.
  So the mirror replaces the HTML site, not the PDFs.

## Required change to scripts/jobs/fetch-source.sh
For any `erights.org` (and its `caplet.com` mirror) URL, change the acquisition order to:
1. direct `curl` (unchanged; still fails from the sandbox, but cheap and correct elsewhere),
2. **NEW — the GitHub Pages mirror:** rewrite the URL to
   `https://erights.github.io/erights-org-website/<path>` (preserve the path after the
   host; strip a leading `http(s)://erights.org/` or `caplet.com/`) and curl it; on HTTP
   200 use those bytes,
3. the existing **Internet Archive original-bytes** fallback (for what the mirror lacks —
   PDFs, or any path that 404s on the mirror).
Keep emitting the `source_content_sha256` anchor from whichever source succeeded, and
record WHICH substitute was used (mirror vs archive) so the library source frontmatter is
honest about provenance/fidelity. Verify the path-rewrite against the three known paths
above (two 200, one 404→archive) in the build.

## Role + test updates
- `roles/scholar/AGENT.md` (the fetch note, ~line 69): add the erights.github.io mirror as
  the PRIMARY substitute for erights.org, with the "PDFs not mirrored → archive fallback"
  caveat. Keep it one tight sentence in the existing style.
- `scripts/jobs/test/fetch-source-test.sh`: extend to cover the erights.org → mirror
  rewrite (mock/stub the mirror 200 and a 404→archive path) so the rewrite + fallback
  order is asserted deterministically.

## Re-ingest the previously-unreachable sources (scholar)
Enumerate erights.org-sourced entries in the library source index
(`journal/library/**` — sources whose URL is on erights.org/caplet.com, especially those
that recorded an Internet-Archive fallback or were left unreachable). For each, re-run the
scholar ingestion now that the mirror is reachable (higher-fidelity than the archive
capture for HTML pages), updating the source file + concept/topic pages and the provenance
note. Post these as `scholar-ingest-source` jobs (or do them in-line if the build agent
also wears scholar) — the scholar may not edit the scripts above, so split accordingly.

Deliverable: fetch-source.sh prefers the erights.github.io mirror for erights.org/caplet.com
URLs (archive remains the fallback for PDFs/404s), role note + test updated, and the
previously-unreachable erights sources re-ingested from the mirror with honest provenance.
