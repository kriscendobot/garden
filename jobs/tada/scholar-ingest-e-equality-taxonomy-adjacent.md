Job complete. Report follows.

---

# scholar-ingest-e-equality-taxonomy-adjacent — done

Ingested the adjacent pages of Mark S. Miller's E *equality* taxonomy from erights.org's `elib/equality/` tree as library web sources, alongside the existing `web--miller-grant-matcher-puzzle`. Committed and pushed to `origin/journal2` (commit `6e5613b76`).

## What I did
- **Acquisition:** erights.org and caplet.com were unreachable (ECONNREFUSED) as the job predicted. Fetched every page via the documented Internet Archive `id_` original-bytes recipe (`curl …web.archive.org/web/2020id_/…`); recorded `source_content_sha256` over the bytes actually ingested as the idempotency anchor, with `source_url` the canonical erights URL and `source_snapshot` the archive URL — `source_kind: web` schema matching the predecessor.
- **5 new web sources + 8 sections:**
  - `web--miller-grant-matcher-history` (2: overview, sealer-unsealer-equivalence) — the EQ-history essay the puzzle's "not understood until…" link points at: Lisp EQ → 1972 trio Smalltalk/Actors/KeyKOS → Joule → Escrow Exchange Agent → the puzzle; plus the EQ ⇄ Sealer/Unsealer mutual-constructibility result.
  - `web--miller-equality-four-party-partial-orders` (2: overview, joining-the-orders) — the puzzle's "On to:" successor (`after-both.html`); the distributed-`join` and message-delivery partial order.
  - `web--miller-equality-object-sameness` (1) and `web--miller-equality-reference-sameness` (1) — the sameness classification (Selfish/Selfless, `==`/designational equivalence, Settled state).
  - `web--miller-equality-argument-passing-rules` (2: vat-independent-semantics, vat-based-rules) — where PassByCopy/PassByConstruction/PassByProxy and the leaving-home/going-home/travelling transforms live.
- **2 new concept pages** (both cross-linked from `grant-matcher-puzzle`, as the job invited): `object-sameness` (the equality half; E-language ancestor of `pass-invariant-handle-equality`) and `pass-by-construction` (the transport/passing half, with an E ↔ Endo pass-style translation table).
- **Indexes/topics updated:** `sources/README` (+5 rows), `sections/README` (+8 entries, count 5826→5834), `concepts/README` (+2 inventory entries), `keywords.md` (+~45 aliases), topic pages `capability-theory`/`capability-security`/`marshal`/`eventual-send`/`captp`, and `grant-matcher-puzzle.md` (new interlock rows + an "adjacent E equality-taxonomy pages" section + See-also links).

## Scope decisions
- `join.html` ("Joining References") is a one-line stub ("To be written") that only points back to Four Party Partial Orders — I did **not** create a standalone source for it and documented that in the four-party source notes.
- Reference Sameness carries an explicitly-marked "stale notes, please ignore" appendix; I captured the live content as authoritative and summarized the appendix's still-useful definitions (designational-vs-computational, PowerKey/CycleBreaker) under that caveat.

## Verification
- Integrity gate PASS: `library-link-check.sh --wikilinks` exits 0 for all 5 new `--source-slug` clusters, the `--files` set of every modified nav/concept/topic page, and `--changed origin/journal2` against the current tip.
- **Caught a stale-base hazard:** origin/journal2 advanced mid-job (a peer's `concepts/endoclaw.md` commit landed). My first `--changed` run flagged 10 endoclaw danglers that were artifacts of my stale base, not my work. I cherry-picked my commit onto the fresh tip (one trivial `keywords.md` tail conflict, resolved keeping both blocks), re-ran the gate clean, then pushed. Worktrees torn down; inbox empty.

## Follow-ups
- `conventions.md` documents the repo / paper / comment-fragment source schemas but not the **`source_kind: web`** schema, even though it now has 15 web sources following an undocumented precedent. Worth a gardening pass to add a "Sources from the web" section (frontmatter fields `source_url`/`source_snapshot`/`source_content_sha256`, the Internet-Archive `id_` acquisition recipe) so future web ingests have a written contract. Not posted as a job yet — flagging for the liaison/gardener queue.
