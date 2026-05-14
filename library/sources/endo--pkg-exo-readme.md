---
source: packages/exo/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 11
status: current
notes: "Three Patterns" H2 split at H3 because each H3 (makeExo, defineExoClass, defineExoClassKit) defines a distinct API surface. "State Management" H2 kept consolidated because its 3 H3s are short variations of the same theme.
---

> Abstract: The @endo/exo package README. Covers Exo's three forms (makeExo, defineExoClass, defineExoClassKit) for declaring capability-bearing remotables with declarative method guards and per-instance state. Includes the multi-facet kit pattern (the canonical attenuator shape), async methods via M.callWhen(), state-management semantics, GET_INTERFACE_GUARD introspection, the virtual/durable variants for restart-surviving state, and integration points with patterns, marshal, eventual-send, captp.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/endo--pkg-exo-readme--overview.md) | exo | current |
| [why-exo](../sections/endo--pkg-exo-readme--why-exo.md) | exo, capability-security | current |
| [makeexo-single-instance](../sections/endo--pkg-exo-readme--makeexo-single-instance.md) | exo | current |
| [defineexoclass-multiple-instances](../sections/endo--pkg-exo-readme--defineexoclass-multiple-instances.md) | exo | current |
| [defineexoclasskit-multiple-facets](../sections/endo--pkg-exo-readme--defineexoclasskit-multiple-facets.md) | exo, capability-security | current |
| [async-methods-callwhen](../sections/endo--pkg-exo-readme--async-methods-callwhen.md) | exo, eventual-send, patterns | current |
| [state-management](../sections/endo--pkg-exo-readme--state-management.md) | exo | current |
| [introspection-interface-guard](../sections/endo--pkg-exo-readme--introspection-interface-guard.md) | exo, patterns | current |
| [virtual-durable-exos](../sections/endo--pkg-exo-readme--virtual-durable-exos.md) | exo, daemon | current |
| [integration-with-endo](../sections/endo--pkg-exo-readme--integration-with-endo.md) | exo | current |
| [see-also](../sections/endo--pkg-exo-readme--see-also.md) | exo | current |

## Provenance

- File last modified 2026-01-04 by Kris Kowal.
- Captured at endo file-specific commit `14a0b631`.

Source: [packages/exo/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/exo/README.md).
