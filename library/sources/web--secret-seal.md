---
source_kind: web
source_url: https://jasvir.github.io/secretseal/
source_content_sha256: def69ed7510d522d759684a9b0d201b5a65dcfeb57b74ca2c6538c36298e92d3
source_authors: [Jasvir Nagra]
source_date: 2026-09-01
retrieved: 2026-10-06
ingested: 2026-10-06
ingested_by: gardener
section_count: 4
status: current
notes: "Fetched directly from the canonical GitHub Pages URL. Jev pre-classification: injection 0.06 (clean), slant neutral/0.72, policy proceed; model jev-1.13.0; usage 16,930 input and 71 output tokens."
---

Jasvir Nagra's Secret Seal is a threat-model guide to accidental persistence and disclosure of PII, bearer credentials, and secret material in HTTP requests. It compares request carriers by their copying surfaces, distinguishes opacity, replay resistance, sender binding, and encryption, warns that URL fragments and visible cleanup are not confidentiality boundaries, and proposes shared framework controls culminating in leak-canary tests. For Minion Town, its sharpest consequence is that a durable guest formula identifier should not remain a reusable fragment credential; the existing standard `Authorization` bearer paths, hardened session cookie, no-store/referrer headers, and isolated first-party guest shell are directionally aligned but need observed end-to-end leak tests.

| Section | Topics | Status |
|---------|--------|--------|
| [request carriers and accidental copying](../sections/web--secret-seal--request-carriers-and-accidental-copying.md) | http-secret-handling, oauth-credentials, worker-observability | current |
| [URL fragments and split knowledge](../sections/web--secret-seal--url-fragments-and-split-knowledge.md) | http-secret-handling, capability-security | current |
| [opaque handles and revelation boundaries](../sections/web--secret-seal--opaque-handles-and-revelation-boundaries.md) | http-secret-handling, capability-security, oauth-credentials | current |
| [framework controls and leak canaries](../sections/web--secret-seal--framework-controls-and-leak-canaries.md) | http-secret-handling, worker-observability, testing | current |
