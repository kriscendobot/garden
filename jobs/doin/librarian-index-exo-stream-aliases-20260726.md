# Index gap: concepts/exo-stream.md lacks aliases: frontmatter

`library/concepts/exo-stream.md` has NO `aliases:` frontmatter (frontmatter is
only created/updated/author/status/topics? — in fact it has created/updated/
author/status but no `aliases:` and no `topics:`). Per library/keywords.md and
skills/context-library, keyword resolution is served primarily by each concept
page's `aliases:` frontmatter; a concept without aliases is unreachable by
term-based (library-lookup) search. exo-stream is the ONLY concept in
library/concepts/ missing aliases.

Add an `aliases:` list (and a `topics:` list) to the exo-stream frontmatter
covering its high-value terms, e.g.: `@endo/exo-stream`, `exo-stream`,
`exo stream`, `CapTP streaming`, `reader-ref`, `ref-reader`, `stream-ref`,
`async iterator over CapTP`, `synchronize chain`, `acknowledge chain`,
`bidirectional stream protocol`, plus any others the page's body warrants.
Follow the alias-list shape used by peer concepts (e.g. concepts/endo-pubsub.md,
concepts/passable-equality.md). If a keywords.md cross-term pointer is
warranted, add one there too.

Land the edit through `scripts/jobs/land-journal-edit.sh library/concepts/exo-stream.md`
(per skills/context-library and roles/librarian). Do NOT hand-git the live
journal/ worktree. Deliverable: exo-stream.md carries an aliases: list so
term search resolves to it.

(Found by the librarian library audit, job librarian-library-audit-20260725-170501.)

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-26T01:27:41Z
