---
title: Promises
source: "draft-specifications/CapTP Specification.md"
source_repo: kriscendobot/ocapn
source_commit: 8704f69e01f93701de8bc5eb4bb22b9927a2665a
source_date: 2026-03-12
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, captp, eventual-send]
status: current
notes: Maps to library/sections/endo--pkg-eventual-send-readme--handled-promise.md and library/sections/endo--pkg-eventual-send-readme--promise-pipelining.md.
parent: ocapn--draft-specifications-captp--promises
---

Promises are a key part of CapTP. They are used to represent a value which is
not yet known. Promises without a value are said to be unresolved, they can
become resolved by being `fulfill`ed with a value (including another promise),
or broken (`break`) with an error.

Promises are often created by sending an `op:deliver` message, where they
represent the eventual value of the response. They can be chained together in
what is called [Promise Pipelining](#promise-pipelining), whereby messages are
sent to the promise which should be delivered to its resolution value if it is
fulfilled with a single (as opposed to breaking with an error, or fulfilled with
multiple values).

Source: `draft-specifications/CapTP Specification.md` at commit `8704f69e` (held at kriscendobot/ocapn).
