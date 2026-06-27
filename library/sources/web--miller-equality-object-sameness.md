---
source_kind: web
source_url: https://erights.org/elib/equality/same-object.html
source_effective_url: https://erights.github.io/erights-org-website/elib/equality/same-object.html
source_fetched_via: mirror
source_content_sha256: 463a4dc5aed174f5366545e46d35e9104b1a6d30dea298701c2d7a57b8bf5d1f
source_authors: [Mark S. Miller]
source_date: 2000-01-01
retrieved: 2026-06-27
ingested: 2026-06-27
ingested_by: scholar
section_count: 1
status: current
notes: "Mark Miller's *Object Sameness* — the equality-taxonomy classification page for object (not reference) sameness identity, sibling of [`web--miller-grant-matcher-puzzle`](web--miller-grant-matcher-puzzle.md). Defines Selfish (creation identity, PassByProxy default) vs Selfless (value identity, Transparent + Frozen), the Scalar vs Composite-Selfless split, Settled state, and sameness-as-Herbrand-terms. Several subsection headings (PassByProxy/PassByCopy/Infinite-Rational-Trees) are stubs (\"to be written\") on the source. Fetched 2026-06-27 from the erights.github.io GitHub Pages mirror via scripts/jobs/fetch-source.sh (`source_fetched_via=mirror`; erights.org refuses connections from the sandbox). The mirror bytes are byte-identical to the prior Internet-Archive `id_` capture (content SHA-256 unchanged), so this is a provenance refresh, not a re-ingest. Undated; source_date is the era approximation. Single overview section per the single-screen-reference-doc guidance. Idempotency anchor is source_content_sha256."
---

Mark S. Miller's *Object Sameness* is the equality-taxonomy page defining when two *objects* (as opposed to references) are the same in E. It reasons about sameness identity by analogy to ground formulas / Herbrand terms in logic programming, partitions objects into **Selfish** (atomic creation-based identity; PassByProxy and Settled by default) and **Selfless** (value-based identity; always Transparent and Frozen), and further splits Selfless into **Scalars** (calculable atomic ground symbols, always Settled) and **Composite Selfless** objects (cycle-tolerant recursive comparison of components, with a canonical `__optUncall()` triple and possibly-infinite rational-tree sameness formulas). It is the base-case companion to [Reference Sameness](web--miller-equality-reference-sameness.md), with which it is mutually recursive, and the E-language ancestor of Endo's pass-style / [[pass-by-construction]] classification.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/web--miller-equality-object-sameness--overview.md) | capability-theory, marshal | current |
