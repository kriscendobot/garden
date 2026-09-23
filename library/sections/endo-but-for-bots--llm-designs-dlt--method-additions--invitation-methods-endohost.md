---
title: Invitation methods (`EndoHost`)
source: designs/daemon-locator-terminology.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42
source_date: 2026-03-17
source_authors: [Kris Kowal]
topics: [daemon, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-dlt--method-additions
---

`invite()` and `accept()` keep their signatures; their internals are
upgraded to emit and parse the new format respectively. The
`Invitation.locate()` accessor returns the new format. `accept()`
parses both old and new (see
[[endo-but-for-bots--llm-designs-dlt--locator-format-evolution]] for
the format-detection rule).

The split between `locate` (no hints) and `locateWithHints` (current
hints) is deliberate: callers that store the locator long-term should
prefer `locate` because hints are ephemeral and would otherwise stale
in storage; callers that present a locator for immediate sharing should
prefer `locateWithHints` so the recipient can connect.
