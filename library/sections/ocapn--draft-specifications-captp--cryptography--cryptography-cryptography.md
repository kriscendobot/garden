---
title: "[Cryptography](#cryptography)"
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
parent: ocapn--draft-specifications-captp--cryptography
---

Each party within a CapTP session has their own per session key pair which is
used for signing certain structures for example in the [third party handoffs
section](#third-party-handoffs). These key pair values are generated EdDSA with
a SHA512 hash.

**NOTE:** These representations are considered temporary and we are anticipating
replacing them, probably with record-based representations.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
