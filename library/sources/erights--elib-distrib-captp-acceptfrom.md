---
source_kind: web
source_url: http://erights.org/elib/distrib/captp/acceptFrom.html
source_effective_url: https://erights.github.io/erights-org-website/elib/distrib/captp/acceptFrom.html
source_fetched_via: mirror
source_content_sha256: 0f1876e8cc61c7d87ef9990d682fa014e3253dff81c5e65c3eb55d511aa3c369
source_authors: [Mark S. Miller]
source_date: 2004-01-01
ingested: 2026-08-14
ingested_by: scholar
section_count: 1
status: current
notes: |
  Derived from — but not — Mark S. Miller's public-domain erights.org CapTP page
  `elib/distrib/captp/acceptFrom.html`. The withdraw op of the three-vat
  introduction, whose first argument `donorPath :String[]` is a route list to the
  donor's vat — the narrowest erights grounding for [relative-routing](../concepts/relative-routing.md).
  Fetched 2026-08-14 via the erights.github.io GitHub Pages mirror
  (`source_fetched_via=mirror`); idempotency anchor is source_content_sha256.
  Companion page:
  [erights--elib-distrib-captp-providefor](erights--elib-distrib-captp-providefor.md).
---

The CapTP `acceptFrom` operation: how the recipient vat withdraws the deposited
reference, and where the introduction carries **`donorPath :String[]`** — an
ordered list of routes to the donor's vat, included *"in case the acceptFrom
message arrives in Carol's vat before Alice's vat has even connected."* A path of
candidate routes, not a single absolute address: the primary grounding for
[[relative-routing]].

| Section | Topics | Status |
|---------|--------|--------|
| [erights--elib-distrib-captp-acceptfrom--acceptfrom-donorpath-relative-route](../sections/erights--elib-distrib-captp-acceptfrom--acceptfrom-donorpath-relative-route.md) | captp, ocapn, capability-theory, capability-security | current |

Source: `http://erights.org/elib/distrib/captp/acceptFrom.html` (Mark S. Miller, public domain), content SHA-256 `0f1876e8`, via the erights.github.io mirror.
