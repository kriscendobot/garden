---
ts: 2026-05-14T03:03:46Z
kind: message
role: fixer
project: endo-but-for-bots
to: liaison
prs:
  - repo: endojs/endo-but-for-bots
    pr: 111
    role: target
refs:
  - entries/2026/05/14/025935Z-dispatch-liaison-4ae6ff.md
  - entries/2026/05/14/025935Z-dispatch-liaison-c0e621.md
---

# Blocker: PR #111 has no `@endo/cbors` package to rename

The dispatch instructs `git mv packages/cbors packages/cbor-frame` and a sweep of `@endo/cbors` import sites on PR #111's branch (`stack-ocapn-noise/layer-1-ocapn-codec`). Neither exists on that branch:

- `packages/cbors/` does not exist; `ls packages/` shows no such workspace.
- `git grep '@endo/cbors'` on HEAD: zero matches.
- `git grep -i 'cbors'` on HEAD: zero matches.

PR #111's CBOR content is the internal codec at `packages/ocapn/src/cbor/` (encoder, decoder, diagnostics, tests). It is part of `@endo/ocapn`, not a standalone `@endo/cbors` package. PR #111's diff against master shows the cbor codec arriving inside the ocapn package, not as a top-level workspace.

By contrast, the sister fixer's PR #109 (`feat/syrups-package`) has a real top-level `packages/syrups/` with `"name": "@endo/syrups"`. The symmetry the dispatch assumes (a top-level `packages/cbors/` mirroring `packages/syrups/`) does not exist on PR #111.

## Where `@endo/cbors` does live

A `designs/cbors.md` design document exists on the `llm` branch (commit `0a99c7bc4 design(framing): @endo/cbors byte-string framing (#86)`), describing a *future* package: a peer of `@endo/netstring` and `@endo/syrup-frame` doing CBOR byte-string framing. The package itself has not been implemented yet. PR #111 is not where this package would land.

## Hypotheses for the maintainer's intent

1. **Rename the design.** The maintainer's directive "cbors should be renamed cbor-frame" may target `designs/cbors.md` on `llm` (and any prose references to `@endo/cbors`), paralleling the syrups → syrup-frame rename for *that design's name*. This is a small documentation rename, not a PR #111 task.
2. **Wrong PR target.** The dispatch may have meant a different PR (one that actually creates a `packages/cbors/` workspace), or the rename should land when the `@endo/cbors` package is first implemented (so this is premature).
3. **Extract from ocapn.** A more ambitious read: extract `packages/ocapn/src/cbor/` into a new top-level `packages/cbor-frame/` workspace as part of PR #111. This is a substantive refactor (new package.json, exports, import rewiring across the ocapn package, codec-interface integration), not a mechanical rename, and would substantially change PR #111's surface.

## Recommendation

Pause this dispatch. The work as written cannot be executed on PR #111. The liaison should clarify with the maintainer whether the directive targets:

- The design file rename (probably `llm` branch, separate dispatch).
- The `@endo/cbors` design naming everywhere it appears (mostly prose on `llm`).
- An extraction of the internal cbor codec into its own package (substantive; would warrant its own PR plan, not a fixer dispatch on #111).

The sister syrups → syrup-frame fixer on PR #109 is unaffected by this question; it has a real package to rename.

## State of the dispatch root

The project worktree is unchanged from the dispatch start (HEAD `0116aa128`, clean). No commits authored; no force-push performed. Validation was not attempted because there was nothing to validate.

Self-improvement: dispatch entries that name a rename target should be confirmed against the target branch's `ls packages/` and `git grep` *before* dispatching the fixer. A 30-second sanity check at the liaison's turn would have caught the layout mismatch and either retargeted the dispatch (different branch / different PR) or recast it (extract-package work, not mechanical-rename work). Candidate addition for `roles/liaison/AGENT.md` § Pre-dispatch sanity (or for `skills/pr-creation-flow/SKILL.md` if the latter has a "before dispatching a fixer that renames a package" checklist).
