---
source_kind: web
source_url: https://erights.org/elib/equality/same-ref.html
source_effective_url: https://erights.github.io/erights-org-website/elib/equality/same-ref.html
source_fetched_via: mirror
source_content_sha256: 09ca5c97fdeb57becfb90d5917b45cd03a837fafee39406216d9138984d2856a
source_authors: [Mark S. Miller]
source_date: 2000-01-01
retrieved: 2026-06-27
ingested: 2026-06-27
ingested_by: scholar
section_count: 1
status: current
notes: "Mark Miller's *Reference Sameness* — the equality-taxonomy classification page for reference (not object) sameness, sibling of [`web--miller-grant-matcher-puzzle`](web--miller-grant-matcher-puzzle.md) and mutually recursive with [`web--miller-equality-object-sameness`](web--miller-equality-object-sameness.md). Defines the synchronous `==` predicate (true/false/throws), designational equivalence, monotonicity, Settled vs Unsettled, EMap-requires-Settled-keys, promises-as-logic-variables, and the designational-vs-computational distinction via Disconnected references plus PowerKey/CycleBreaker. The source carries an explicitly-marked \"stale notes\" appendix (\"please ignore\") that nonetheless holds the clearest Near/Far/Disconnected and PowerKey exposition; the section summarizes it with that caveat. Fetched 2026-06-27 from the erights.github.io GitHub Pages mirror via scripts/jobs/fetch-source.sh (`source_fetched_via=mirror`; erights.org refuses connections from the sandbox). The mirror bytes are byte-identical to the prior Internet-Archive `id_` capture (content SHA-256 unchanged), so this is a provenance refresh, not a re-ingest. Undated; source_date is the era approximation. Idempotency anchor is source_content_sha256."
---

Mark S. Miller's *Reference Sameness* is the equality-taxonomy page defining when two *references* (as opposed to objects) are the same in E, via the synchronous `==` predicate. It establishes that `==` returns `true`, returns `false`, or throws (throwing only when an operand is Unsettled); the **designational equivalence** it tests (same sameness formulas); its **monotonicity** (a returned answer never changes); the Unsettled → Settled one-way transition; and EMap's requirement that keys be Settled for stability. It explains promises as logic variables in the sameness-formula calculus, distinguishes **designational** from **computational** equivalence through the Disconnected (partition-broken Far) reference that still designates but no longer conveys authority, and sketches the PowerKey / CycleBreaker wrappers for using unsettled references as hashtable keys. It is the reference-side companion to [Object Sameness](web--miller-equality-object-sameness.md) and the E-language ancestor of Endo's [[pass-invariant-handle-equality]].

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/web--miller-equality-reference-sameness--overview.md) | capability-theory, marshal, eventual-send | current |
