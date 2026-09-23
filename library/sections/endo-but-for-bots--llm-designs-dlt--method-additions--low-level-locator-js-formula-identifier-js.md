---
title: Low-level (`locator.js`, `formula-identifier.js`)
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
| `parseId(id)` | `string → {number, node}` | Unchanged |
| `formatId(record)` | `{number, node} → string` | Unchanged |
| `parseLocator(locator)` | `string → {formulaType, node, number}` | Adds `hints` field to the returned record |
| `formatLocator(id, type)` | `(string, string) → string` | Unchanged (no hints) |
| `idFromLocator(locator)` | `string → string` | Unchanged |

| New method | Signature | Purpose |
|---|---|---|
| `formatLocatorWithHints(id, type, hints)` | `(string, string, string[]) → string` | Format locator including the inline `@`-separated hints |
