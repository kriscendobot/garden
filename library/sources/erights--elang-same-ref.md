---
source_kind: web
source_url: http://erights.org/elang/same-ref.html
source_effective_url: https://erights.github.io/erights-org-website/elang/same-ref.html
source_fetched_via: mirror
source_content_sha256: 95878351747c7ff30439056002718ed330ca2e723c13ca901e85e666cea382c0
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 2
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. Marked "written
  ahead of the implementation" (a semantics specification). The direct ancestor
  of Endo's pass-style equality and the pass-by-copy / pass-by-reference split.
  Idempotency anchor is source_content_sha256.
---

The *Semantics of "Same"* chapter of the E language reference: E's notion of
**synchronous sameness**, the `==` operator. The chapter defines `==` by
**substitutability** (algebraic replaceability of equals), guarantees it is
**reflexive** even for `NaN` (departing from IEEE, which would break map lookup;
`<=>` is the separate IEEE magnitude operator), specifies scalar sameness
(same-type-and-value), and develops the **selfish vs selfless** object
distinction — identity-based sameness by default, contents-based sameness for
objects declared transparent (immutable + open state + open source), which then
**pass by copy between vats**. The chapter closes by outlining further topics
(broken references, deferred references vs stable answers, *join* as asynchronous
sameness, cooperatively-transparent forwardability) that are not expanded here.
This is the conceptual root of Endo's pass-style discipline.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [synchronous-sameness-and-reflexivity](../sections/erights--elang-same-ref--synchronous-sameness-and-reflexivity.md) | e-language, pass-style | current |
| [selfish-and-selfless-objects](../sections/erights--elang-same-ref--selfish-and-selfless-objects.md) | e-language, pass-style | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elang/same-ref.html`.
- Content SHA-256 `95878351747c7ff30439056002718ed330ca2e723c13ca901e85e666cea382c0`, 21666 bytes, last modified 1998-10-03.
