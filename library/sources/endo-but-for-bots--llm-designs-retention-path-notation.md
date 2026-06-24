---
source: designs/retention-path-notation.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: dea3e7186cb482a5fc9c368d0cc95355e3f0271d
source_date: 2026-05-10
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
section_count: 6
status: current
notes: First library content on daemon internals at this level of detail. Bridges to a library gap — daemon coverage was previously thin (only the daemon README). Cross-cuts heavily with capability-security (the host-only API design rationale; guests can't enumerate retention paths through caps they don't own), exo (RetentionPath is a typed value), and the broader PR #151 `endo workers` work. Sibling design `daemon-retention-paths.md` provides the per-target subscription; this one is the bulk variant + CLI notation.
---

> Abstract: Design for two related additions to the daemon's GC machinery: (1) a host-method `listRetentionPaths(targetIds)` that returns one **best path per target** in a single call (bulk variant of `daemon-retention-paths.md`'s per-target API); (2) a **typed `RetentionPath` shape** whose segments each carry their own locator (so CLI + chat consumers can drill in without a second round-trip); (3) a **canonical CLI string notation** that distinguishes pet-name edges (`/<name>`), field edges (`:<field>`), retention edges (`~peer:<id>`), persistent roots (`@<root-name>`), transient roots (`*<id-prefix>`), and merged groups (`#<type>+<mergeKind>`); (4) a **best-path selection rule** (persistent over transient → pet-named over field-only → shortest → lex-smallest). The daemon owns the typed shape; CLI owns its string notation; chat UI owns its markup rendering — typed `RetentionPath` is the backbone that keeps them consistent. Per-segment `locator` field is the load-bearing addition for "click any component to drill in" UX.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-status-quo](../sections/endo-but-for-bots--llm-designs-rpn--problem-and-status-quo.md) | daemon, capability-security | current |
| [retention-path-model](../sections/endo-but-for-bots--llm-designs-rpn--retention-path-model.md) | daemon, exo | current |
| [host-method-api-and-best-path](../sections/endo-but-for-bots--llm-designs-rpn--host-method-api-and-best-path.md) | daemon, capability-security | current |
| [cli-string-notation](../sections/endo-but-for-bots--llm-designs-rpn--cli-string-notation.md) | daemon, tooling | current |
| [integration-and-phased-implementation](../sections/endo-but-for-bots--llm-designs-rpn--integration-and-phased-implementation.md) | daemon, tooling | current |
| [alternatives-and-decisions](../sections/endo-but-for-bots--llm-designs-rpn--alternatives-and-decisions.md) | daemon, capability-security | current |

## Cross-references

- Sibling: `daemon-retention-paths.md` (the per-target subscription; not yet ingested).
- The PR #151 row-format that this unblocks: `endo workers` (in flight).
- Endo-side cross-peer GC where this kind of retention metadata originates: `daemon-cross-peer-gc.md` (cycle-38 noted as Complete in the corpus).

## Source

[designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
