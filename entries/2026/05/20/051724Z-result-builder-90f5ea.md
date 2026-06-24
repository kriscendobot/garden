---
ts: 2026-05-20T05:17:24Z
kind: result
role: builder
project: endo
refs:
  - entries/2026/05/20/050724Z-dispatch-liaison-90f5ea.md
---

# Result: docs/spackle.md authored, branch pushed; PR-create blocked on bot permissions

## Deliverable

- `docs/spackle.md` (139 lines) authored from `/home/kris/spackle.md` per the dispatch outline.
- `typedoc.json` updated: one-line insertion of `"docs/spackle.md"` between `docs/message-passing.md` and `docs/reference.md` in `projectDocuments`. Minimal diff, no cosmetic reformat.
- Branch `docs-spackle` pushed to `kriscendobot/endo` (forked from `endojs/endo` at this dispatch's start).
- Head SHA: `8848cb052ed38a1dd1ccd8f04ff9e25a6a08a131`.

## PR creation blocked

`gh pr create --repo endojs/endo --base master --head kriscendobot:docs-spackle --draft` returns:

> GraphQL: kriscendobot does not have the correct permissions to execute `CreatePullRequest` (createPullRequest)

The fork exists and `gh api repos/kriscendobot/endo` reports admin/push permissions on the fork itself, but cross-fork PR creation against `endojs/endo` is denied. The bot identity has not been granted contributor status on the `endojs` org or this repo. The branch is ready; the maintainer can open the PR directly at:

  https://github.com/endojs/endo/compare/master...kriscendobot:endo:docs-spackle?expand=1

Title to use: `docs: introduce spackle, the polyfill+ponyfill race pattern`. Open as DRAFT.

## What was cut from the source draft

- The prototype.js / es5-shim historical preamble. Rhetorical motivation for the shim/polyfill/ponyfill contrast, no load-bearing content beyond what the definitions carry.
- The author's first-person aside about coining "shim" for es5-shim. Biographical, not pattern content.
- `(I believe, please cite)` and `[citation needed]` author notes; the "polyfill"/Remy Sharp attribution kept without citation; "shim" attribution dropped (the original author note conceded uncertainty).
- The repeated pass over surface vs volumetric harden (the draft makes the point across three paragraphs). Consolidated to one paragraph in the harden section.
- The sentence "There is not wide consensus in the JavaScript community about shim and polyfill" — unclear about what; recast as "Spackle combines a polyfill...with a ponyfill...and a race discipline" near the definition, where the synthesis lands.

## What was kept verbatim

- The `Object[Symbol.for('harden')](object)` and `import { harden } from '@endo/harden'` juxtaposition. Load-bearing because the article's whole point is that the same install can be reached two ways.
- The `if (!Array.prototype.map)` polyfill example. Concrete and short; the contrast with unconditional install is the next sentence.
- The eval-twins definition and the registered-symbol exception. The center of gravity for "why a new pattern".
- The lockdown coordination contract: lockdown-wins-installs-volumetric, spackle-wins-installs-surface, spackle-after-lockdown-corruption throws. All three are load-bearing.

## Editorial decisions worth flagging in the PR

- "Remy Sharp coined 'polyfill'" stated without citation, matching the surrounding docs' tone.
- The es5-shim biographical aside removed entirely.
- The prototype.js history removed entirely.
- The harden link points to the package README, not to inline-duplicate that document.

These are flagged in the PR body as items for the maintainer.

## typedoc.json position chosen

Between `docs/message-passing.md` and `docs/reference.md`, as the dispatch suggested. Concept/guide content sits with the other guides; the reference docs follow.

## yarn docs outcome

Completed. `api-docs/documents/spackle.html` is generated. 65 pre-existing warnings about anchor mismatches in errors/lockdown/captp links; none reference spackle. No new warnings.

## Style discipline applied

- No em-dashes anywhere in the file.
- One sentence per line, all lines under 100 columns (longest is line 32 at 80 chars).
- No agentic tropes ("Let's", "we'll dive", "It's worth noting", etc.).
- Bullet lists used only where the structure is genuinely enumerable (none in this draft; the article is prose).
- Frontmatter follows the `docs/message-passing.md` / `docs/lockdown.md` shape.
- Tone matched against `docs/message-passing.md` and `docs/guide.md` (factual, no marketing voice, definition-then-example).

## Pre-PR checks

- `node -e "JSON.parse(...)"` on typedoc.json: parses.
- `yarn prettier --check docs/spackle.md typedoc.json`: clean (after reverting an unintentional cosmetic reformat of typedoc.json; the file is not in the prettier-checked path of `lint:prettier`, which targets `.github` and `packages` only).
- `yarn docs`: completes; spackle.html generated; no new warnings.

## Self-improvement

The dispatch said "verify `git remote -v` before pushing" but did not flag that the bot identity may lack cross-fork PR-creation permission on the upstream repo. For docs PRs against `endojs/endo` originating from a bot host that has not been granted contributor status, the builder should anticipate this and surface the compare URL up front rather than discovering the block at PR-create time. A short pre-flight check (`gh api repos/<owner>/<repo>/pulls --silent --method POST --field ...` dry run, or simply checking org membership) would have moved this discovery to the start of the dispatch. Worth a one-line addition to the pre-PR checklist for builder dispatches that target an org the bot is not a member of.

Self-improvement: anticipate cross-fork PR-create permission blocks before authoring; the branch-push works but `gh pr create` may fail if the bot lacks org membership.
