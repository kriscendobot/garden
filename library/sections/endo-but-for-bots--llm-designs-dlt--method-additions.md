---
title: Method additions — existing signatures unchanged, new methods for hints
source: designs/daemon-locator-terminology.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42
source_date: 2026-03-17
source_authors: [Kris Kowal]
topics: [daemon, agent-conventions]
status: current
---

The strict invariant is: **no existing method signatures change.**
Every current method continues to take and return what it does today;
two methods get richer return-value content (extra fields the caller
may ignore); two new methods are added for the hint-bearing paths.

## Low-level (`locator.js`, `formula-identifier.js`)

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

## High-level (`NameHub`, `EndoAgent`, `EndoHost`)

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

## Invitation methods (`EndoHost`)

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
