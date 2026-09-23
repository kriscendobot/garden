---
title: High-level (`NameHub`, `EndoAgent`, `EndoHost`)
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

| Current method | Signature | Change |
|---|---|---|
| `identify(...path)` | `...string[] → Promise<string?>` | Unchanged |
| `locate(...path)` | `...string[] → Promise<string?>` | Internal format change only — still returns a string |
| `reverseIdentify(id)` | `string → Name[]` | Unchanged |
| `reverseLocate(locator)` | `string → Promise<Name[]>` | Unchanged |
| `listIdentifiers(...path)` | `...string[] → Promise<string[]>` | Unchanged |
| `lookupById(id)` | `string → Promise<unknown>` | Unchanged |

| New method | Signature | Purpose |
|---|---|---|
| `locateWithHints(...path)` | `...string[] → Promise<string?>` | Resolve path to locator and inline the peer's *current* hints |
