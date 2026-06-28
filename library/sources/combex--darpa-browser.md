---
source_kind: web
source_url: http://www.combex.com/tech/darpaBrowser.html
source_fetched_via: wayback
source_wayback_url: http://web.archive.org/web/20260504023216id_/http://www.combex.com/tech/darpaBrowser.html
source_wayback_timestamp: 20260504023216
source_content_sha256: 3a68fd803bbbddc03fa419d5351ee7a03ac1df9620d96e51257c6862858f86bd
source_authors: [Combex, Inc.]
source_date: 2026-06-28
ingested: 2026-06-28
ingested_by: scholar
section_count: 3
status: current
notes: |
  "The DarpaBrowser" — the project document Combex submitted to and accepted by
  DARPA for a capability-confined HTML rendering engine, "presented as is for
  historical interest". The single most substantive CapDesk-era primary in the
  Combex corpus (40 KB). Fetched via the Internet Archive original-bytes capture
  (source_fetched_via=wayback). The DarpaBrowser is the public demonstration that
  produced the famous "Malicious Renderer" red-team result, later written up as
  the Wagner/Tribble security review.
---

## Abstract

"The DarpaBrowser", the project document Combex submitted to DARPA for a capability-secure web browser whose HTML rendering engine is capability-confined so that a buggy or malicious renderer cannot compromise any other part of the system — "not even the field in the browser which displays the URL". It specifies a Benign Renderer for ordinary browsing and a Malicious Renderer that relentlessly attempts to escape confinement, both running on an "E Language Machine" (a Sanitized Linux that executes only the TCB plus capability-confined E caplets). The document is the most detailed CapDesk-era primary: it states the work, milestones, and deliverables, and describes Combex and the E language's history and capabilities.

| Section | Topics | Status |
|---------|--------|--------|
| [executive-summary-and-confined-renderer](../sections/combex--darpa-browser--executive-summary-and-confined-renderer.md) | capability-security, capability-theory | current |
| [statement-of-work-and-milestones](../sections/combex--darpa-browser--statement-of-work-and-milestones.md) | capability-security | current |
| [combex-and-e-technology](../sections/combex--darpa-browser--combex-and-e-technology.md) | capability-theory | current |

## See also

- [combex--edesk](combex--edesk.md) — the CapDesk primary; the DarpaBrowser is the DARPA-funded browser application of CapDesk's capability confinement.
- [papers--miller-tribble-shapiro-concurrency-among-strangers-2005](papers--miller-tribble-shapiro-concurrency-among-strangers-2005.md) — the canonical E promise-based concurrency / vat paper whose model the DarpaBrowser builds on.
- [ocap-history--e-capdesk-polaris](ocap-history--e-capdesk-polaris.md) — secondary-source market-history survey companion.
