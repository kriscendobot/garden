---
title: Why this matters
source: designs/daemon-locator-terminology.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42
source_date: 2026-03-17
source_authors: [Kris Kowal]
topics: [daemon, persistence, capability-security]
status: current
parent: endo-but-for-bots--llm-designs-dlt--dehydration-and-hydration
---

- **No state migration.** Pet stores already contained formula keys
  (then called formula identifiers); the locator format change is
  invisible to them.
- **Hints stay fresh.** Long-stored locators never become unreachable
  because their hints are looked up at presentation, not frozen at
  capture.
- **Identity is stable across hint changes.** A pet name continues to
  refer to the same formula even if the peer's transport address
  changes — the formula key did not change.

This is the same **typed-shape-in / typed-shape-out, formatting at the
edges** discipline as
[[endo-but-for-bots--llm-designs-rpn--rpn-string-notation]] (producers
own the typed shape, consumers own rendering): the formula key is the
typed shape, the locator is the rendered form, and dehydration is the
mirror of that — capture the typed shape, discard the rendering.

See also
[[endo-but-for-bots--llm-designs-dlt--locator-format-evolution]] for
the URL format that carries the hints, and
[[endo-but-for-bots--llm-designs-dlt--method-additions]] for the
`locate` / `locateWithHints` split that surfaces this discipline at
the API boundary.
