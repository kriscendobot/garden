---
source_kind: web
source_url: https://erights.org/elib/equality/grant-matcher/history.html
source_effective_url: https://erights.github.io/erights-org-website/elib/equality/grant-matcher/history.html
source_fetched_via: mirror
source_content_sha256: 192e45c43ca28de5ec06b15dbb9ed316b18922cd3b81678dbdc3d8257f0c4c8e
source_authors: [Mark S. Miller]
source_date: 2000-01-01
retrieved: 2026-06-27
ingested: 2026-06-27
ingested_by: scholar
section_count: 2
status: current
notes: "Mark Miller's *History of the Grant Matcher* — the EQ-history essay the root [`web--miller-grant-matcher-puzzle`](web--miller-grant-matcher-puzzle.md) overview links at (\"the implications of these different answers were *not understood* until…\"). Traces the EQ controversy Lisp EQ → the 1972 trio Smalltalk / Actors / KeyKOS → Joule's reconciliation → the Escrow Exchange Agent that produced the puzzle, and closes with Dean Tribble's Sealer/Unsealer-without-EQ result and the EQ ⇄ Sealer/Unsealer mutual-constructibility hypothesis. Fetched 2026-06-27 from the erights.github.io GitHub Pages mirror via scripts/jobs/fetch-source.sh (`source_fetched_via=mirror`; erights.org refuses connections from the sandbox). The mirror bytes are byte-identical to the prior Internet-Archive `id_` capture (content SHA-256 unchanged), so this is a provenance refresh, not a re-ingest. Undated page; source_date is the equality-taxonomy-era approximation matching the sibling pages. Idempotency anchor is source_content_sha256, not a git SHA."
---

Mark S. Miller's *History of the Grant Matcher* is the historical-lineage essay sitting under the [Grant Matcher Puzzle](web--miller-grant-matcher-puzzle.md) in the erights.org `elib/equality/grant-matcher/` tree, and the page the puzzle's own text links at where it says the implications of different answers to object-identity questions were "not understood until the Grant Matcher Puzzle." It narrates the `EQ` controversy from Lisp's pointer-identity `EQ` through the three foundational 1972 dynamic object systems (Smalltalk, Actors, KeyKOS), Actor behavioral-indistinguishability and transparent forwarders, KeyKOS's `EQ`/DISCRIM and its security patterns, the Joule design effort that reconciled the two traditions, and the WebMart Escrow Exchange Agent whose intractable-without-`EQ` problem Norm Hardy distilled into the puzzle. The "It's not so simple" coda records Dean Tribble's demonstration that the puzzle is solvable with Sealer/Unsealer pairs and no `EQ`, and the resulting hypothesis that `EQ` and Sealer/Unsealer pairs are mutually constructible (each builds the other), but neither is constructible in a pure capability system that has neither.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/web--miller-grant-matcher-history--overview.md) | capability-theory, capability-security | current |
| [sealer-unsealer-equivalence](../sections/web--miller-grant-matcher-history--sealer-unsealer-equivalence.md) | capability-theory, capability-security | current |
