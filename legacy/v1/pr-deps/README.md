# PR dependency registry

Per-PR dependency declarations the journalist and other roles read to order rows within a bulletin section, to walk transitive blockers, and to detect declared cycles. One file per source PR; the file documents *why* one PR depends on another, not just *that* it does.

The schema is intentionally light. The maintainer or any role with dependency insight (steward, journalist, fixer when it discovers an inter-PR coupling in a PR body) writes a file by hand or via the journal's normal commit-and-push path. The read side is `skills/pr-dependency-graph/SKILL.md` (on the `main` branch); the within-bin ordering rule that consumes the graph is `skills/pr-dependency-topo-sort/SKILL.md`.

## Filename

```
pr-deps/<owner>--<repo>--<n>.md
```

`<owner>` and `<repo>` are the GitHub slugs; the double-dash separator avoids ambiguity with a hyphenated repo name (e.g. `endojs--endo-but-for-bots--128.md`). `<n>` is the PR number with no padding.

## Frontmatter schema

```yaml
---
repo: <owner>/<repo>                 # the PR's repo, matching the filename
number: <n>                          # the PR number, matching the filename
blocked_by:                          # optional; omit when empty
  - repo: <owner>/<repo>             # may differ from this file's repo (cross-repo deps welcome)
    number: <n>
    reason: "<one-line why>"
blocks:                              # optional; omit when empty
  - repo: <owner>/<repo>
    number: <n>
    reason: "<one-line why>"
---

<optional prose body: longer explanation, links to the directive or design doc, follow-up notes>
```

Both `blocked_by` and `blocks` are optional. Omit the key entirely when the list would be empty (do not write `blocked_by: []`).

### Reciprocity

Reciprocity is *encouraged* but not *enforced*: if `A.blocked_by = [B]`, then `B.blocks = [A]` makes `B`'s file searchable for "what does B block?" without scanning every other file in the registry. But the canonical edge is the `blocked_by` side. A reader (typically `skills/pr-dependency-graph/SKILL.md`) builds the adjacency list from both sides and de-duplicates; the `reason` from the `blocked_by` side wins on conflict.

This means the maintainer or a writing role can declare a one-sided edge (only on the dependent's file) and the system still works. Reciprocity is a searchability convenience, not a correctness requirement.

### Cross-repo edges

A `blocked_by` or `blocks` entry may name a different `repo:` than the file's own. Cross-repo dependencies are first-class; the dependency graph carries them through.

## Lifecycle

- **Create.** Any role with dependency insight may write a file. Typical writers:
  - The **maintainer**, when they call out a dependency in a directive (the registry's seed entry for `endojs--endo-but-for-bots--128.md` was created in response to kriskowal's directive about exo-zip/exo-unzip's blocking effect on #128).
  - The **steward**, when its per-cycle survey surfaces a dependency it already annotated inline in the bulletin (the duct-tape annotation graduates to a registry entry on the steward's next cycle close).
  - The **journalist**, when it discovers an undeclared dependency while classifying rows (e.g., a PR body explicitly references another PR as a prerequisite). The journalist writes the file and surfaces the new entry in its `tick`.
  - The **fixer**, when working through review comments on a PR surfaces a coupling to another open PR. The fixer writes the dep file as a side effect of the cross-PR coordination "surface but do not act" rule in `roles/fixer/AGENT.md`.

- **Update.** Edit in place. Update the file's `updated:` timestamp if you carry one in the body's frontmatter (the registry's frontmatter schema does not require it; the journal's git history is the audit trail).

- **PR merge.** The file survives. An entry for a merged PR documents historical dependency context: future agents asking "did #128 ever depend on #160?" get a yes from the registry rather than having to read git history or scrape comments. The journalist's `walk_blockers` query filters merged PRs out at render time via the canonical-set check; the file itself stays.

- **PR close-without-merge.** The file survives by default. Delete the file only when the PR is closed-without-merge **and** the dependency context is no longer instructive (e.g., the close was a misclick, the dependency was speculative and never materialized). In doubt, keep the file. The registry is cheap; lost context is not.

- **Cycle resolution.** If `skills/pr-dependency-graph/SKILL.md`'s `detect_cycles` reports a cycle, the maintainer or an authorized role edits one of the entries to remove the contradicting edge, with a one-line `reason` change explaining why. The next journalist run re-reads the graph and the cycle is gone. The registry does not store the "I resolved this cycle on date X" record; that lives in the journal entry that explains the edit.

## Who writes vs. who reads

| Role / actor | Writes | Reads |
|---|---|---|
| maintainer | by-hand edits via PR or direct commit | not directly (the bulletin is the read surface) |
| steward | dep files for inline bulletin annotations (per-cycle close) | for cycle detection, dispatch ordering hints |
| journalist | dep files surfaced from row classification | every cycle, for within-bin ordering |
| fixer | dep files for couplings discovered in PR bodies / reviews | when a cross-PR question arises in the dispatch |
| other roles | (rare) when their work uncovers an inter-PR relationship | as needed |

Subagents commit and push these files via the same path as any journal write: `skills/journal-sync/SKILL.md` (on the `main` branch) covers the detached-HEAD push.

## Current entries

The list grows as files are added. Until it crosses a couple dozen entries a hand-maintained table here is the index; past that, a generated table or a `git ls-files pr-deps/` pointer suffices.

| File | Repo | PR | Blocked by | Blocks |
|---|---|---|---|---|
| [endojs--endo-but-for-bots--128.md](./endojs--endo-but-for-bots--128.md) | endojs/endo-but-for-bots | 128 | endojs/endo-but-for-bots#160 (exo-zip/exo-unzip name pick) | (none) |
