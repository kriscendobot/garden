---
title: "[The bootstrap Object](#bootstrap-object)"
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp, capability-security]
status: current
parent: ocapn--draft-specifications-captp--bootstrap-object
---

The bootstrap object is responsible for providing access to local objects on the
session. It has three different behaviors, selected using the conventional CapTP
method mechanism of sending a symbol as the first argument. The following
methods are available:

-   `fetch`
-   `deposit-gift`
-   `withdraw-gift`

The bootstrap object MUST be exported on each newly initialized CapTP session at
export position `0`. A session is considered initialized if both sides send and
receive both [`op:start-session`](#opstart-session) messages.

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
