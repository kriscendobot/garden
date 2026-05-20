---
ts: 2026-05-20T05:19:10Z
kind: result
role: liaison
project: endo
to: maintainer
dispatch: 050724Z-dispatch-liaison-90f5ea
---

# Result: builder 90f5ea — spackle docs article on endo master (branch ready, cross-fork PR blocked)

Builder dispatch `90f5ea` complete. Deliverable: `docs/spackle.md` (139 lines) on branch `docs-spackle` at `kriscendobot/endo` head `8848cb052ed38a1dd1ccd8f04ff9e25a6a08a131`. Self-report at `journal/entries/2026/05/20/051724Z-result-builder-90f5ea.md`.

## Outcome

- `docs/spackle.md` authored from `/home/kris/spackle.md` (the kriskowal draft).
- `typedoc.json` updated: one-line insertion of `"docs/spackle.md"` in `projectDocuments`, between message-passing and reference.
- `yarn docs` generates `api-docs/documents/spackle.html` cleanly. 65 pre-existing warnings unrelated to the new page.
- Style discipline applied: one-sentence-per-line per `CONTRIBUTING.md`, no agentic tropes, no em-dashes, frontmatter shape matches `docs/message-passing.md`.

## What was cut / kept / flagged

**Cut**: Prototype.js / es5-shim historical preamble, first-person aside about coining "shim", `(I believe, please cite)` and `[citation needed]` author notes, redundant surface-vs-volumetric harden passes (draft had three; consolidated to one), the unclear "no wide consensus" sentence.

**Kept**: `Object[Symbol.for('harden')]` / `import harden` juxtaposition, `if (!Array.prototype.map)` polyfill example, eval-twins definition with the registered-symbol exception, three-way lockdown coordination contract.

**Maintainer editorial calls**: Remy Sharp attribution without citation; prototype.js history removed entirely; harden section links to `packages/harden/README.md` rather than duplicating it.

## PR-creation blocker

`gh pr create --repo endojs/endo --base master --head kriscendobot:docs-spackle --draft` failed: *"kriscendobot does not have the correct permissions to execute CreatePullRequest"*. The bot identity is not an `endojs` org contributor; the fork-side branch push works, the cross-fork PR-open does not.

The branch is ready. Maintainer can open the draft PR at:

  https://github.com/endojs/endo/compare/master...kriscendobot:endo:docs-spackle?expand=1

Title: `docs: introduce spackle, the polyfill+ponyfill race pattern`.

Alternative: a boatman ferry under kriskowal credentials from `kmkmbp2021` would open the PR upstream as-the-maintainer (same shape as past upstream ferries). This is the maintainer's call.

## Self-improvement (carried from the builder)

Anticipate cross-fork PR-create permission blocks before authoring. A pre-flight `gh api repos/<org>/<repo>/collaborators/<bot>` check (or simply documenting the compare-URL fallback as the canonical hand-off shape) would move this discovery to dispatch-prep rather than the end of the work.

## Teardown

Dispatch root `/home/kris/dispatches/builder--90f5ea/` torn down by the liaison after this entry lands.
