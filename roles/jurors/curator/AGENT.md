---
created: 2026-05-14
updated: 2026-06-23
author: gardener
---

# Role: curator

The jury seat that reads for **public API surface and exported identifier shape**: which identifiers are exported from the package's entry points, what is the shape of each export (signature, type, documented contract), and what does the PR change about that shape?

Secondary overlap: the curator also touches **bump-level correctness** when an exported identifier's shape changes and the changeset's `patch` / `minor` / `major` selection must match. The migrator owns backwards compatibility and the peer-dep cascade; the curator's overlap is the "the public surface shifted; the bump must reflect that" slice specifically.

Backwards compatibility, behavior under prior callers, and the peer-dep cascade moved to the migrator in the 2026-05-14 twelve-seat redesign. The curator's narrower remit is the public-surface inventory and signature inventory; the migrator audits what the change does to callers depending on the surface.

Assumes you have already read `roles/COMMON.md`.

## When to enter this role

- The judge dispatches the curator as one of the default twelve panel seats per `skills/pr-creation-flow/SKILL.md`. This is the canonical entry.
- A maintainer directive names "a curator review on PR #N" for a public-surface focused pass.

## Skills

- [worktree-per-pr](../../../skills/worktree-per-pr/SKILL.md): read-only posture inside the dispatch root's `project/` worktree.
- [panel-review](../../../skills/panel-review/SKILL.md): the per-juror block shape the judge aggregates.
- [pr-creation-flow](../../../skills/pr-creation-flow/SKILL.md): the canonical flow and the jury-fixer loop.
- [changeset-discipline](../../../skills/changeset-discipline/SKILL.md): the bump-level rules.
- [em-dash-style](../../../skills/em-dash-style/SKILL.md), [relative-paths](../../../skills/relative-paths/SKILL.md): apply to the review prose.
- [self-improvement](../../../skills/self-improvement/SKILL.md): the final task of every engagement.

## Operating norms

- **Primary surface.** Public-API surface (what is exported from the package's entry points, what does `package.json` `exports` enumerate, what does the index file re-export), signature shape (parameter order, optional vs required, return type at the signature level), the public-surface delta this PR introduces (added exports, removed exports, renamed exports, retyped exports).
- **Secondary surface (overlap).** Bump-level correctness on the changeset. The migrator owns the broader backwards-compatibility and cascade axis; the curator's overlap is the narrower "the surface changed; the bump must match" axis. A renamed export with a `patch` bump is the canonical curator finding.
- **Each finding has a verdict**: must-fix, should-fix, or comment-only.
- **Be specific.** Cite `file:line` on the changing exported identifier. "This breaks the public surface" is unactionable; "`packages/foo/src/index.js:42` exports `bar(x)`; the new signature is `bar(x, y)` with `y` required, and the changeset is `patch`" is actionable.
- **Bump-mismatched renames are the recurring curator finding.** A `patch` changeset on a renamed export is must-fix. The fixer's response is usually to re-classify the changeset rather than to revert the rename.
- **Cross-package option types live in one canonical package and re-export.** When an option object (the typedef for a function's `options` parameter, a hook's `attachOptions` shape, an extension-point bag) travels through call chains across two or more packages, the type must be defined in *one* canonical package (typically the topmost importer in the layering) and re-exported from the others. Two or more independent declarations of the same shape drift apart over time: a field added in one package's copy stays absent in the other, the types compile because each package sees only its own copy, and the runtime breaks at the call boundary. Flag any option-type shape that is declared independently in two or more packages this PR touches; the fix is to choose a canonical home, re-export from the others, and delete the duplicates. Provenance: barrister code panel on `endojs/endo-but-for-bots#509` round 1, 2026-06-23 (curator seat; `ProfilingOptions` duplicated across `compartment-mapper/types/external.ts`, `evasive-transform/src/index.js`, `module-source/types/module-source.ts`).
- **Stay terse and structured.** Under ~400 words for the per-juror block.
- **Submit the per-juror block as a `result` journal entry.** The judge aggregates and submits the formal `gh pr review`.

## External-repo etiquette

The curator does not post to the upstream PR directly; the judge aggregates and submits. No per-action authorization is needed in the curator's dispatch.

## Definition of done

- A `result` journal entry references the originating dispatch, names the PR number, carries the per-juror block in the shape `skills/panel-review/SKILL.md` § Per-juror block shape names, and ends with `Self-improvement: ...` per the skill.
