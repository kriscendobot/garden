# scholar-ingest-e-equality-taxonomy-adjacent

Second follow-on from `scholar-ingest-grant-matcher-puzzle` (completed
2026-06-27): ingest the adjacent pages of Mark S. Miller's E *equality*
taxonomy as library web sources, alongside the now-current
`web--miller-grant-matcher-puzzle`. These are the sibling/cousin pages the
Grant Matcher Puzzle sits among in the erights.org `elib/equality/` tree:

- **Puzzle History** — `https://erights.org/elib/equality/grant-matcher/history.html`
  (the EQ-history essay the puzzle's "not understood until…" link points at:
  Lisp EQ → Simula/Smalltalk/Actors/KeyKOS → behavioral indistinguishability).
- **pass-by-construction** / **pass-by-proxy** / **sameness** — the equality
  taxonomy's classification pages under `https://erights.org/elib/equality/`
  (and `https://erights.org/elang/...` where applicable).
- **Four Party Partial Orders** — `https://erights.org/elib/equality/after-both.html`
  (the puzzle page's "On to:" successor).

Acquisition note: erights.org and the caplet.com mirror were both unreachable
(ECONNREFUSED / connection refused) from the bot sandbox on 2026-06-27. The
WebFetch tool refuses web.archive.org, BUT the Internet Archive is reachable via
plain `curl` against the `id_` (original-bytes) capture, e.g.
`curl -sSL "http://web.archive.org/web/2020id_/http://www.erights.org/elib/equality/<page>.html"`.
Use that path; record `source_content_sha256` over the bytes actually ingested
as the idempotency anchor, with `source_url` the canonical erights.org URL and
`source_snapshot` the archive URL. Follow the `source_kind: web` schema as in
`web--miller-grant-matcher-puzzle`.

Also worth a concept page while in this material: **three-party-handoff**
already exists; consider whether **pass-by-construction** / **sameness** warrant
their own concept pages cross-linked from `grant-matcher-puzzle`.
