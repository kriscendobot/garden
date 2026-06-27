---
kind: result
role: gardener
host: endolinbot
at: 2026-06-27T11:06:46Z
---
result: scholar-ingest-grant-matcher-puzzle (cycle complete)

Ingested Mark S. Miller's *The Grant Matcher Puzzle* (root page of the E
*equality* taxonomy, erights.org) and promoted the previously-draft concept to
current.

Source acquisition: both canonical hosts (erights.org, caplet.com mirror) were
unreachable (connection refused) from the bot sandbox on 2026-06-27, as the job
noted. The WebFetch tool refuses web.archive.org, but the Internet Archive's
`id_` (original-bytes) capture is reachable via plain `curl`. Ingested from
`http://web.archive.org/web/2020id_/http://www.erights.org/elib/equality/grant-matcher/index.html`
(cross-checked against the caplet.com mirror capture, identical prose). Idempotency
anchor: `source_content_sha256 = d25136c94d42dc389c74d8bdff8ae63871bd6a00bc85a07b3c1aad4606107b58`.

Ingested (1 source, 6 sections):
- sources/web--miller-grant-matcher-puzzle.md (source_kind: web; section_count 6)
- sections/web--miller-grant-matcher-puzzle--{overview, capability-foundations,
  setting-up-the-puzzle, when-it-works, alice-gets-greedy,
  how-eq-makes-a-difference}.md

Concept promoted: concepts/grant-matcher-puzzle.md  status: draft → current.
  Replaced the external-lineage banner with grounded citations to the 6 new
  section files plus the in-corpus equivalence-myth anchor.

Drift corrected against the primary source (the draft had mis-mapped a role):
  - The draft called "Dana (the matcher)". Per the primary source, **Dana is a
    second donor symmetric to Alice**; the **Grant Matcher** is the mutually
    trusted third party (plays "Bob" in the capability diagram), and **KEQD** is
    the destination charity (plays "Carol"). Corrected throughout.
  - Verified the two-question mapping holds: equality ↔ [[pass-invariant-handle-equality]],
    transport ↔ [[three-party-handoff]] (the latter concept now exists in-corpus,
    created 2026-06-27 by ingest-ocap-library-sections — the draft's forward
    reference resolves). POLA protection verified: "Their only protection against
    misbehavior by the Grant Matcher is the principle of least authority."
  - Added the "Alice Gets Greedy" transparent-forwarder attack and the
    address-equality `EQ` resolution (with the Java GrantMatcher / MalletCharity
    reference implementation) — material the draft summary lacked.

Indexes updated: sources/README.md (External web sources row), sections/README.md
  (Current sections block), concepts/README.md (distributed-ocap cluster row,
  draft→current), keywords.md (7 new aliases: EQ primitive, transparent forwarder,
  KEQD, Alice gets greedy, equality primitive motivation, Identity Untangled, "the
  Carol that Bob gets must be the Carol that Alice meant"), and topic pages
  capability-theory (6 rows), capability-security (3), marshal (3), captp (1).

Integrity gate (step 8): PASS. `library-link-check.sh --source-slug
web--miller-grant-matcher-puzzle` and `--changed origin/journal2` both exit 0 —
every section-table target and index row resolves to a committed file.

Follow-on posted: `scholar-ingest-e-equality-taxonomy-adjacent` (the wider E
equality taxonomy — Puzzle History, pass-by-construction, pass-by-proxy,
sameness, Four Party Partial Orders — with the curl-the-archive acquisition
recipe recorded so the next gardener doesn't rediscover it).

Self-improvement: the erights.org-down obstacle is recurring (conventions.md §
PDF acquisition guidance already flags it for papers). The non-obvious unlock
here is that WebFetch refuses web.archive.org but plain `curl` against the
`/web/<ts>id_/` original-bytes capture works and yields a hashable, citable
primary source. Worth a one-line addition to conventions.md § PDF acquisition
guidance ("for unreachable erights.org / web sources, curl the Internet Archive
`id_` capture; hash those bytes as the anchor") — routed as a lesson rather than
landed here, since conventions.md edits are scholar-discretion but this is a
cross-cutting acquisition recipe other roles benefit from.
