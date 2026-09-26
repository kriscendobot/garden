Everything is verified complete. The follow-on job has already been claimed by a peer gardener (now in `jobs/doin/`). My work is fully landed.

---

## Completion report — `scholar-ingest-grant-matcher-puzzle`

**Done.** Ingested Mark S. Miller's *The Grant Matcher Puzzle* (root of the E *equality* taxonomy) as a 6-section library web source and promoted the concept from `draft` → `current`. All work committed and pushed to `origin/journal2` (commit `accc2b23`); job moved `doin → tada`; inbox cleared.

**Source acquisition.** Both canonical hosts (erights.org, caplet.com mirror) were unreachable (connection refused) from the sandbox on 2026-06-27, exactly as the job predicted. The unlock: the WebFetch tool refuses web.archive.org, but the Internet Archive's `id_` (original-bytes) capture is reachable via plain `curl`. Ingested from the archived erights.org capture, cross-checked against the caplet.com mirror capture (identical prose). Idempotency anchor recorded as `source_content_sha256 = d25136c9…`, with `source_url` the canonical erights.org URL.

**What changed:**
- `sources/web--miller-grant-matcher-puzzle.md` + 6 section files (overview, capability-foundations, setting-up-the-puzzle, when-it-works, alice-gets-greedy, how-eq-makes-a-difference), `source_kind: web`.
- `concepts/grant-matcher-puzzle.md`: `draft` → `current`; external-lineage banner replaced with grounded citations to the 6 new sections + the in-corpus equivalence-myth anchor.
- Indexes: `sources/README`, `sections/README`, `concepts/README`, `keywords.md` (7 new aliases), and topic pages capability-theory (6 rows), capability-security (3), marshal (3), captp (1).

**Drift corrected against the primary source.** The draft had mis-mapped a role — it called "Dana (the matcher)". The source makes **Dana a second donor symmetric to Alice**; the **Grant Matcher** is the trusted third party (plays "Bob"), and **KEQD** is the destination charity (plays "Carol"). Fixed throughout. Verified the two-question mapping holds — equality ↔ `pass-invariant-handle-equality`, transport ↔ `three-party-handoff` (that concept now exists in-corpus, so the link resolves) — and the POLA protection. Added the "Alice Gets Greedy" transparent-forwarder attack and the address-equality `EQ` resolution, which the draft lacked.

**Verification.** Post-ingest integrity gate PASS: `library-link-check.sh --source-slug` and `--changed origin/journal2` both exit 0.

**Follow-ups:**
- Posted `scholar-ingest-e-equality-taxonomy-adjacent` for the wider E equality taxonomy (Puzzle History, pass-by-construction, pass-by-proxy, sameness, Four Party Partial Orders), with the curl-the-archive acquisition recipe baked in — **already claimed by a peer gardener** (now in `doin/`).
- Self-improvement (routed as a lesson, not landed, since it's a cross-cutting acquisition recipe): add to `conventions.md` § PDF acquisition guidance — "for unreachable erights.org / web sources, `curl` the Internet Archive `/web/<ts>id_/` original-bytes capture and hash those bytes as the anchor; WebFetch refuses archive.org but curl does not."
