---
slug: exo-guard-matches-static-type
category: spec-violation
status: open
count: 1
members:
  - kriscendobot-agoric-sdk-pr15-review-396a141c
prs: [15]
---

An exo interface-guard PR reaches the maintainer with loose M.any()/M.record()/M.string() guards on methods whose static type is precisely known, when the repo convention (agoric-sdk CONTRIBUTING § TypedPatterns) is that each guard match its static type as tightly as possible and any remaining looseness be a documented, reasoned exception; the code panel affirms the loose guards as upgrade-safe rather than flagging the under-specification, because no seat carries the guard-tightness-vs-known-type lens.
