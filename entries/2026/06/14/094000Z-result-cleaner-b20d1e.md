---
ts: 2026-06-14T09:40:00Z
kind: result
role: cleaner
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/cleaner--b20d1e
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: cleaned
refs:
  - entries/2026/06/14/091200Z-result-builder-7cfbcc.md
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4701356019
---

# result: cleaner — PR #440 cut 3 (formula-inspector chat surface) hygiene pass

Cleaner re-gamut on the expanded scope of PR #440 after builder
`7cfbcc` landed cut 3 (Value modal Formula back face, chat surface, 4
commits over `f01499f1a`). Ran pre-push-gates, audited the four-commit
diff per the hygiene skills, fixed one in-scope ESLint error, updated
the PR body to describe cut 3, posted the top-level summary comment.

## Pre-push gates result

One actionable finding inside cut 3's scope, fixed in `888951a9f`:

- `object-shorthand` ESLint error in
  `packages/chat/test/component/inventory-component.test.js` lines 466
  to 467. The `id` and `path` properties in the `showValueFormula`
  callback used the longhand form `id: /** @type {string} */ (id)` to
  satisfy an array element type annotation. Since the file is
  `@ts-nocheck`, the casts were not load-bearing. Switched to the
  shorthand form per the `object-shorthand` rule.

The corresponding test ("gear button calls showValueFormula with id,
value, and itemPath") still passes locally.

Pre-existing repo-wide gate findings outside this PR's scope (left
untouched):

- `filename-no-stutter` on legacy `packages/chat/chat-bar-component.js`
  (predates cut 3 entirely).
- ASCII banner in `designs/trust-on-first-bind.md`.
- Inline `import()` JSDoc across legacy packages.
- Missing `packages/endo/SECURITY.md`.
- `sentence-per-line-md` multi-sentence lines in legacy docs.

The `no-non-ascii-in-source` probe did not trigger on cut 3 because it
scopes to `packages/<pkg>/(src|lib)/` and the `@endo/chat` package
keeps source at the package root. The one gear glyph (U+2699) in
`inventory-component.js` is rendered via `String.fromCodePoint(0x2699)`
(builder's `3e5f44604` covered this proactively).

## Cut 3 hygiene audit

- **Em-dash discipline**: no em-dashes introduced in cut 3 additions.
- **Latin shorthand**: no Latin shorthand (`cf.`, `i.e.`, `e.g.`,
  `etc.`, `vs.`, `viz.`, `ad hoc`) introduced in cut 3 additions.
- **Relative paths**: no absolute paths in cut 3 additions.
- **Test title spec spelling**: the 24 new test titles use accurate
  surface names (`getFormula`, `getFormulaViewSpec`,
  `listKnownFormulaTypes`, `publicKey`, `privateKey`, `lookupById`,
  `showValueFormula`, `Shift+P`, `Backspace`, `aria-live`). No
  spec-spelling departures.
- **Changeset discipline**: cut 3 touches only `@endo/chat`, which is
  a private package (`"private": true` in
  `packages/chat/package.json`). No changeset entry needed for cut 3.
  The existing `.changeset/formula-inspector-getformula.md` covers the
  public-surface changes in cuts 1+2.
- **Filename stutter**: no new files in cut 3 stutter the package name.

## PR body update

The previous body was authored at cut 1 and treated cut 3 as deferred
("Surfacing this gap to the maintainer rather than guessing"). Cut 3
has now landed, so the body needed an update. Rewrote to describe all
three cuts, with the chat-side substance pulled from the builder's
`91120Z-result-builder-7cfbcc.md` entry and from the four-commit
sequence. Status checkboxes now reflect cuts 1+2+3 landed; cut 4
(design-doc status bump) is still a separate PR on `llm`.

Cited `gh pr edit 440 --body-file /tmp/pr-body.md` to land the rewrite.

## Commits

One commit landed on the PR branch this engagement:

| SHA | Subject |
|---|---|
| `888951a9f` | `chore(chat): use property shorthand in gear icon test callback` |

## Verification

- `yarn ava` over the cut 3 test files passes locally: 24 / 24 across
  `formula-view-registry.test.js`, `formula-view-component.test.js`,
  `value-component-flip.test.js`, plus the 2 added cases in
  `inventory-component.test.js`.
- `yarn eslint packages/chat/...` over the cut 3 source files: 0
  errors after the hygiene push (warnings baseline unchanged; existing
  `@jessie.js/safe-await-separator`, `no-alert`, `jsdoc` warnings on
  modified-but-not-newly-introduced lines).
- `yarn prettier --check` over the cut 3 source files: all clean
  (builder's `ab50308a3` covered this).

## CI on cleaner's HEAD

Same red surface as cut 1+2 head (`f01499f1a`):

- `lint`: fails on `packages/daemon/test/endo.test.js` prettier drift
  (cut 1 hygiene issue; the builder's note in `91120Z-result-builder`
  explicitly explains they reverted prettier's repository-wide
  reformatting of this file so the diff stayed scoped to chat).
- `test` (TypeDoc step): fails on three TS errors in
  `packages/daemon/src/formula-record.js` — `HostFormula` does not
  have `.worker`; `'make-bundle'` literal type mismatch; `'never'`
  property access cascade.
- Per-platform `test (22.x|24.x, ubuntu|macos)` jobs fail downstream
  of the TypeDoc breakage.

These are all inherited cut-1 hygiene issues that predate cut 3; the
cleaner's cosmetic push did not add new red. Verified by enumerating
`/repos/endojs/endo-but-for-bots/commits/f01499f1a/check-runs` and
finding the same `lint` and `test` failures already present before any
cut-3 commit. The chat-side test surface (the 24 cases that exercise
cut 3) passes locally; CI's `test` job's failure is the TypeDoc step,
not the ava step.

## Top-level comment

Posted on the PR with the per-action authorization in the dispatch
prompt ("Post top-level summary comment on PR #440 at-mentioning
@kriskowal, ending with 'Next stage: barrister panel.'"):
<https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4701356019>

## Recommended next stage

**barrister panel.**

Cleaner does not un-draft; the next link is the barrister's first
code-panel round on the expanded (cuts 1+2+3) scope. The cut-1
TypeScript errors surfaced by CI's TypeDoc step warrant a separate
fixer pass, but that is a parallel concern; the barrister can proceed
on cut 3 substance in parallel (or, if the maintainer prefers, the
cut-1 fixer lands first and then the barrister runs on the cleaned
combined scope).

Self-improvement: nothing this time. The pre-push gates skill's probes
caught the single in-scope finding cleanly; the cleaner's "verify CI
on the cleaner's own HEAD" norm composed straightforwardly with the
"documented pre-existing infra red" exception once the cut-1 red was
traced and confirmed predating this cleaner's push. One small
operational nicety for the next cleaner running a re-gamut on an
expanded scope: when the prior cleaner result entry references a
different PR (here, `5c4828` ran on PR #442 daemon-cas), confirm via
`grep "pr: <N>"` over the day's journal entries that no earlier
cleaner ran on this exact PR's prior cut so the "re-gamut" framing is
accurate (in this case, none had; the builder's result was the only
prior cut-3 reference on PR #440).
