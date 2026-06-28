---
source_kind: web
source_url: http://erights.org/elang/concurrency/epimenides.html
source_effective_url: https://erights.github.io/erights-org-website/elang/concurrency/epimenides.html
source_fetched_via: mirror
source_content_sha256: 02342f70c87a06b27aff896def2e9d8ca8081437c2e71a903fcdb19ed8602bf7
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Epimenides' Paradox — a prose child chapter of the elang concurrency hub. One
  section captures the three reference states (near/eventual/broken) and data-lock
  (E's closest analog to deadlock). Grounds the data-lock concept. source_date is
  an era approximation matching the sibling concurrency chapters.
---

The E tutorial's **Epimenides' Paradox** chapter — uses the Liar Paradox to
motivate E's three **reference states** (near, eventual, broken) and **data-lock**,
E's closest analog to deadlock. A synchronous self-negating definition fails
because the value is still an eventual reference (promise); the eventually-send
form succeeds only formally, leaving a promise that can never resolve because its
resolution depends on itself. Unlike a threaded deadlock, data-lock hangs nothing
— the machine runs and the value is just a permanent `<Promise>`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [reference-states-and-data-lock](../sections/erights--elang-concurrency-epimenides--reference-states-and-data-lock.md) | eventual-send, e-language, references | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elang/concurrency/epimenides.html`.
- Content SHA-256 `02342f70c87a06b27aff896def2e9d8ca8081437c2e71a903fcdb19ed8602bf7`, 13717 bytes.
