# scholar-ingest-grant-matcher-puzzle — done

Ingested *The Grant Matcher Puzzle* (Mark S. Miller, E equality taxonomy) as the
library web source `web--miller-grant-matcher-puzzle` (6 sections) and promoted
the concept `grant-matcher-puzzle` from draft → current.

## What I did
- Both canonical hosts (erights.org, caplet.com) were unreachable on 2026-06-27
  as the job predicted. Fetched the primary source from the Internet Archive
  `id_` original-bytes capture via plain curl (WebFetch refuses archive.org but
  curl works), cross-checked against the caplet.com mirror capture.
- Wrote sources/web--miller-grant-matcher-puzzle.md + 6 section files (overview,
  capability-foundations, setting-up-the-puzzle, when-it-works, alice-gets-greedy,
  how-eq-makes-a-difference), source_kind: web, idempotency anchor
  source_content_sha256 d25136c9.
- Promoted concepts/grant-matcher-puzzle.md draft → current; replaced the
  external-lineage banner with grounded citations.
- Updated indexes: sources/README, sections/README, concepts/README, keywords.md
  (7 new aliases), and topic pages capability-theory/-security/marshal/captp.

## Drift corrected against the primary source
- Draft said "Dana (the matcher)"; the source makes Dana a **second donor**
  symmetric to Alice, the **Grant Matcher** the trusted third party, **KEQD** the
  destination charity. Corrected throughout.
- Verified equality ↔ pass-invariant-handle-equality, transport ↔
  three-party-handoff, and the POLA protection — all hold against the source.
  three-party-handoff concept exists in-corpus, so the link resolves.

## Verification
- Integrity gate PASS: library-link-check.sh `--source-slug` and `--changed
  origin/journal2` both exit 0.
- Committed and pushed to origin/journal2 (commit accc2b23).

## Follow-ups
- Posted follow-on job `scholar-ingest-e-equality-taxonomy-adjacent` for the
  wider E equality taxonomy (Puzzle History, pass-by-construction, pass-by-proxy,
  sameness, Four Party Partial Orders) with the archive-acquisition recipe.
- Self-improvement (routed as a lesson, not landed): add the "curl the Internet
  Archive id_ capture for unreachable erights.org/web sources" recipe to
  conventions.md § PDF acquisition guidance.
