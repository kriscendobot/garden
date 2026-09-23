---
source_kind: web
source_url: http://erights.org/elib/concurrency/when/when-catch.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/when/when-catch.html
source_fetched_via: mirror
source_content_sha256: 6f664b3f644a170182fb237e326e8aa5593ba95504a9857e00f4e2cc86ea8cf0
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Layer 3 child chapter of the Four Layers of When sub-hub
  (erights--elib-concurrency-when-index). The upstream page is an unwritten stub
  ("*** To be written"); one section records its place in the four-layer map and its
  Endo lineage. This is the DIRECT ANCESTOR of `@endo/eventual-send`'s `E.when` and
  the promise-reaction combinators (and of JavaScript's Promise.then). source_date
  is an era approximation matching the sibling concurrency chapters.
---

**The when-catch Syntactic Shorthand** (Layer 3 of the Four Layers of When) under
ELib — E's `when (p) -> ok(v) { ... } catch e { ... }` surface syntax, sugar over
registering a When\* reactor (Layer 2) that reads like a try/catch over an eventual
value: the `when` arm runs in a later turn on fulfillment, the `catch` arm on
breakage, and neither blocks the vat. This is the **direct ancestor of
`@endo/eventual-send`'s `E.when(target, onFulfilled, onRejected)` and the
promise-reaction combinators**, and more broadly of JavaScript's `Promise.then`. The
upstream chapter is an unwritten stub; this source records the layer's pivotal place
in the lineage.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [when-catch-syntactic-shorthand](../sections/erights--elib-concurrency-when-catch--when-catch-syntactic-shorthand.md) | e-language, eventual-send | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/when/when-catch.html`.
- Content SHA-256 `6f664b3f644a170182fb237e326e8aa5593ba95504a9857e00f4e2cc86ea8cf0`, 6698 bytes. The page is an unwritten stub ("\*\*\* To be written").
