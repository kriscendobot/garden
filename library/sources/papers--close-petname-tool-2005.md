---
source_kind: paper
source_authors: [Tyler Close]
source_title: "Petname Tool: Enabling web site recognition using the existing SSL infrastructure"
source_year: 2005
source_venue: "W3C Workshop on Transparency and Usability of Web Authentication"
source_url: https://www.w3.org/2005/Security/usability-ws/papers/02-hp-petname/
source_content_sha256: 8c8fef18371588f6000f0957760fd8b1b7011b9bd52fe3cf4a1fb851ff8e09f8
source_fetched_via: direct
retrieved: 2026-10-08
ingested: 2026-10-08
ingested_by: scholar
section_count: 1
status: current
content_caveat: "Jev preclassification was unavailable because TYPESAFE_API_KEY was absent; ingested under the standing untrusted-data discipline."
---

Tyler Close's 2005 workshop paper gives the canonical browser anti-phishing application of petnames. A toolbar field, controlled by the browser rather than the visited page, binds the user's reminder note to an SSL relationship identifier. Three visible states distinguish insecure transport, an authenticated but unknown site, and a previously named relationship; the implementation deliberately tolerates site key and domain rotation through its CA-and-subject binding.

| Section | Topics | Status |
|---------|--------|--------|
| [trusted relationship UI over SSL](../sections/papers--close-petname-tool-2005--trusted-relationship-ui-over-ssl.md) | petnames, identity, capability-security | current |
