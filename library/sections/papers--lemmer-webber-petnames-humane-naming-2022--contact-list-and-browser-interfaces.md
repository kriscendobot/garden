---
title: "Contact-list and browser interfaces"
source_kind: paper
source_url: https://files.spritely.institute/papers/petnames.html
source_content_sha256: c9f221a9a7aa4c2541ce81510aae03c0a1553a0eb867c1b66df7a3fea6982ee2
source_authors: [Christine Lemmer-Webber, Mark S. Miller, Zachary Larson, Kate Sills, Eli Yaacoby]
source_date: 2022
ingested: 2026-10-08
ingested_by: scholar
topics: [petnames, identity, capability-security]
status: current
content_caveat: "Jev preclassification was unavailable because TYPESAFE_API_KEY was absent; ingested under the standing untrusted-data discipline."
notes: "Derived from the authors' public paper but not the original."
---

Abstract: Contact lists already approximate petname systems by hiding opaque phone numbers behind local names; the paper adds secure introduction paths, explicit proposed-name treatment, and a priority order for display. For browsers, bookmarks become petname bindings displayed in trusted chrome, while edge-name hubs and DNS supply lower-confidence paths that page content cannot forge.

The contact-list walkthrough gives each name kind a distinct interaction. Personal petnames sort first, then shallow edge-name paths from trusted or frequently used contacts and directories. Saving an introduced contact is an explicit promotion from an edge or proposed name to a local petname. Proposed caller names remain marked as provisional and are disambiguated when they collide, rather than silently becoming trusted identity.

The browser design starts from bookmarks as user-controlled bindings. Petnames must appear above the browser's “line of death,” where page content cannot imitate or overwrite them. When no local petname exists, the interface may show an edge-name path; DNS can appear as a special naming hub, preserving familiar navigation without treating a domain string as the user's own relationship name. The paper credits Tyler Close's Petname Tool as the earlier browser implementation it borrows from.

Source: [*Petnames: A humane approach to secure, decentralized naming*](https://files.spritely.institute/papers/petnames.html), retrieved 2026-10-08, sha256 `c9f221a9`.
