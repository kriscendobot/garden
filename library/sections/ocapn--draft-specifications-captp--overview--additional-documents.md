---
title: Additional Documents
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp]
status: current
notes: Draft spec. Largest single source in the library; 10 sections at H1 boundaries with Operations and Descriptors consolidated rather than per-H2-split. Future cycle could split if specific operations or descriptors become high-traffic lookups.
parent: ocapn--draft-specifications-captp--overview
---

This document does not stand alone, it relies upon multiple other documents
which together build up OCapN (Object Capability Network) specifications.

This specification uses the following other specifications:

-   [Syrup](https://github.com/ocapn/syrup): The serialization format used for all messages between actors
    separated by a CapTP boundary.
-   [OCapN Netlayers](./Netlayers.md): Specification to open a secure communication channel
    between two sessions, often on different networks.
-   [OCapN Locators][Locators]: Specification covers representation of object references
    for both in-band and out-of-band usage.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
