---
title: Translation block (paper idiom → contemporary surface)
source: "ACLs don't (Tyler Close, ~2009)"
source_kind: paper
source_authors: [Tyler Close]
source_year: 2009
source_venue: "Position paper (Hewlett-Packard Labs, Palo Alto; references span Hardy 1988 to Close 2008 + Hansen-Grossman 2008 — published ~2009)"
source_url: https://papers.agoric.com/papers/acls-dont/
source_pdf_sha256: d1ffe9e6e56f513dc83e8143ef7134ffb01f5f30020b10816e4798913181fc75
source_paper_pages: "1-3 (§1 Introduction + §2 Access Matrix through §2.3 Confused Deputy attack)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory]
status: current
parent: papers--close-acls-dont-2009--compilation-scenario-and-the-confused-deputy-attack
---

| 2009 paper concept | Contemporary surface |
| ------------------ | -------------------- |
| Access matrix (1971 Protection) | The conceptual model both ACL and capability systems implement; ACL = column-stored, capability = row-stored. |
| Capability transfer | The contemporary `@endo/marshal` + `captp` discipline: capabilities flow on the wire with their permission attached; the receiver wields them directly. |
| ACL checking (column look-up) | Web cookies; HTTP basic auth; Unix file permissions; the standard *check-the-sender's-permission-on-the-object* discipline. |
| Confused Deputy | The defining attack class for ACL systems; called out in Miller-Tulloh-Shapiro 2004 *Structure of Authority* and Miller-Shapiro 2003 *Paradigm Regained* as the motivating example for *only connectivity begets connectivity*. |
| Vendor + User + Compiler scenario | Reusable teaching example; structurally identical to any web-application + browser + browser-extension trio, or any IDE + user + plugin trio. |
