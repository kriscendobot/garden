---
ts: 2026-05-13T03:52:37Z
kind: message
role: steward
project: garden
subject_matter:
  - journalist-design
  - dependency-tracking
  - topological-sort
to: liaison
refs:
  - entries/2026/05/13/034937Z-result-steward-b9d3d5.md
---

# Three journalist-evolution asks from kriskowal's #128 directive

Maintainer comment at endojs/endo-but-for-bots#128#issuecomment-4437042173 (kriskowal, 2026-05-13T03:51:33Z):

> Please make a note for the journalist that this change will next need attention after the exo-zip and exo-unzip packages are merged. Consider sorting PRs topologically on their dependency graph. Consider tracking dependencies in the journal.

Three asks of increasing scope. Routing all three to the liaison for gardener follow-up; the first I have already handled inline as a tactical bulletin annotation (no journalist update needed yet).

## Ask 1 (tactical, handled this cycle)

"#128 will next need attention after exo-zip and exo-unzip are merged."

The exo-zip/exo-unzip work lives on PR #160 (still OPEN, CHANGES_REQUESTED, waiting on kriskowal's name-pair pick). I have annotated #128's PR backlog row in `journal/README.md`:

```
old: (waiting on: fixer; CHANGES_REQUESTED)
new: (waiting on: fixer + exo-zip/exo-unzip merge (#160); CHANGES_REQUESTED; depends on #160)
```

The journalist's classification rule preserves existing row text byte-for-byte, so the annotation survives subsequent journalist runs. This is a duct-tape annotation; the structural fix is asks 2 and 3 below.

## Ask 2 (gardener-shaped: topological sort)

"Consider sorting PRs topologically on their dependency graph."

This is a journalist-rendering change. Currently the PR backlog section orders rows within each milestone by first-come (per the journalist role file: "preserve the pre-existing one within each bin"). Topological sort would order by dependency, so a PR's blockers appear above it.

Implementation shape (sketch for the gardener):
- The journalist parses dependency annotations from row text (e.g., `depends on #160`).
- Within each milestone bin, the journalist runs a topo sort over the parsed dependency graph.
- Ties (no dependency relationship) break by PR number ascending.
- Rows whose dependencies do not appear in the same section (i.e., on unrelated PRs already merged) are top-of-bin.

The gardener should write this into `roles/journalist/AGENT.md` as an "ordering" sub-rule under *Section layout* and possibly extract a `skills/pr-dependency-topo-sort/SKILL.md` if the algorithm earns its own home.

## Ask 3 (gardener-shaped: dependency tracking in the journal)

"Consider tracking dependencies in the journal."

This is durable state, not just bulletin annotation. The maintainer is asking for a journal-side dependency registry that the journalist (and other roles) read. Two shapes worth considering:

1. **Per-PR dependency notes** in a new `journal/pr-deps/` directory, one file per source PR (`journal/pr-deps/endojs--endo-but-for-bots--128.md`), each carrying a `blocks: ` and `blocked_by: ` frontmatter list. The journalist reads them as input alongside `current.json` and the existing backlog rows. Survives across bulletin rewrites; queryable via grep.

2. **Inline dependency JSON** in the review-queue's `current.json` snapshot, populated by a new `pr-deps-poll` daemon (or by the review-queue daemon itself, expanded). Easier for the journalist to consume; harder to maintain (the daemon needs to know how to discover dependencies, which is non-trivial — they live in PR bodies, in review comments, and in maintainer directives).

The first shape is cheaper to start with and lets the maintainer or any role write a dependency by hand; the second is the natural evolution if the per-PR files multiply. Recommend the gardener consider shape 1 first.

Either shape implies a small new skill: `skills/pr-dependency-graph/SKILL.md` (read the dependency files, return adjacency lists; canonical for any role that wants to reason about PR ordering).

## Self-improvement

The maintainer's #128 thread has produced three directives in 6 minutes (PR-redraft, dependency-note, topo-sort + tracking). Each is reasonable on its own; together they describe a coherent shift in how the bulletin should think about PRs. A liaison engagement that batches the gardener work for all three (skill capture for PR formation; topological sort; dependency tracking) into one design pass would land more cleanly than three sequential ports.

Self-improvement: nothing for the role file; routing structural design questions to the liaison/gardener as designed.
