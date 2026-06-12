---
ts: 2026-06-12T06:05:00Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--6abce3/project
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
refs:
  - entries/2026/06/12/055700Z-result-barrister-821970.md
  - entries/2026/06/12/053500Z-dispatch-barrister-7d0508.md
  - https://github.com/endojs/endo-but-for-bots/pull/438#pullrequestreview-4482896738
  - https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-4687952034
---

# result: fixer — addressed barrister's 2 MFL + 1 summary-fix on #438

Round-one fixer pass after barrister 821970's first code-panel
verdict on the tsgo migration draft PR #438. Two must-fix-loop
items in `AGENTS.md` and one summary-fix in the PR body.

## Pre-dispatch state

- PR head pre-push: `4dc641a27` (docs commit).
- PR state: DRAFT, base `master-4a04d07`, branch `chore/tsgo-lint-types`.
- Barrister verdict review: `pullrequestreview-4482896738`
  (COMMENTED; `--request-changes` blocked on self-authored PRs).
  No inline comments tied to the review; the verdict is the
  top-level body, with the must-fix-loop section enumerating
  the three items.

## Work performed

### Commit 1 — em-dash rewrite (`9dc8128c9`)

`docs(agents): rewrite tsgo em-dash in Testing section`. The
new Testing-section bullet line `Type-check: yarn lint:types
(uses tsgo — TypeScript 7 native preview).` joined two
clauses with an em-dash. Rewritten as a parenthetical phrase
plus a sentence-per-line continuation:

```markdown
- Type-check: `yarn lint:types` (uses `tsgo`, the TypeScript 7 native preview).
  See "TypeScript Preview (tsgo)" above for the rationale and the division of labor.
```

Verified no em-dashes remain in `AGENTS.md` via
`grep -nP '\xe2\x80\x94' AGENTS.md`.

### Commit 2 — sentence-per-line rewrap (`a619bea05`)

`docs(agents): one sentence per line in new tsgo section`. The
new `### TypeScript Preview (tsgo)` section packed multiple
sentences per physical line in two paragraphs, three Notes
bullets, and four Division-of-labor table cells. Per the
CONTRIBUTING.md Markdown Style Guide ("Start each sentence on
a new line"):

- Prose paragraphs split onto separate physical lines.
- Notes bullets split via continuation lines (one sentence
  per line, two-space indent).
- Multi-sentence table cells use `<br>` to keep the table
  renderable while honoring the sentence-per-line shape.
  The `typecheck-packages` Why cell was tightened from
  "Runs each workspace's `lint:types` against its own
  tsconfig, resolving dependencies through `node_modules`
  entrypoints as a consumer would." down to a single-sentence
  form that fits one line.

### PR body edit — `@ts-nocheck` claim narrowed

The original *Design departures and gaps* item 2 claimed
`pre.js already carries @ts-nocheck so it doesn't fail under
tsc and likely also doesn't fail under tsgo`. Verified
ground truth in the worktree:

- `packages/lockdown/pre.js` carries `// @ts-nocheck`.
- `packages/lockdown/post.js` does NOT.
- `packages/lockdown/commit.js` does NOT.
- `packages/lockdown/commit-debug.js` does NOT.

All four are matched by `tsconfig.json`'s wildcard
`include: packages/**/*.js`. Narrowed the claim to name
which file is covered and which three are not, per the
barrister's recommended wording. Edit applied via
`gh pr edit 438 --body-file /tmp/pr-body.md`.

## Reply

Top-level summary comment
[#issuecomment-4687952034](https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-4687952034)
cites each addressing SHA and the body edit, and notes the
pre-existing `sentence-per-line-md` violations on AGENTS.md
lines 44, 48, 59 are out of scope (the barrister framed
them as "pre-existing"; the diff is the new section only).
No re-request of review (the verdict's two `acknowledge`
routings on the material design departures remain
maintainer-pending; per the brief).

## Post-push state

- PR head post-push: `a619bea05303bff62320e12ea37c87a9089df682`.
- Force-push not used; append-only push as required by the
  brief ("Do NOT touch builder/cleaner commits").
- CI: in-progress at handoff time. The `typecheck-all` and
  `typecheck-packages` steps are expected to fail per the
  PR body's documented intent (intentional DRAFT-load-bearing
  signal until routing is picked). No re-request of review.

## Items not addressed (out of scope)

- Pre-existing `sentence-per-line-md` violations on AGENTS.md
  lines 44, 48, 59. These predate the PR; framed by the
  barrister as "pre-existing"; not in the MFL list.
- The two `acknowledge`-disposition routings on Material gaps 1
  and 2 (root-cause JSDoc fix vs documented exclusion;
  yarn `resolutions` hold-back vs upstream fix wait). These
  are explicitly maintainer-pending per the brief.
- The three `follow-up`-disposition items (lockdown
  `lint:types` script; per-package timing-comparison table;
  tsgo panic bisect). Ledger to be appended by the
  orchestrator on the same beat; not in this fixer's lane.

## CI handoff

The PR stays DRAFT. The orchestrator's next step is **justice**
(re-run of the code panel) per `skills/panel-review/SKILL.md`'s
post-fixer judge re-dispatch and per the brief's "The
orchestrator dispatches justice for re-run next". The justice
brief should include this round's verdict so the panel sees
that the two MFL items are addressed.

## Recommended next stage

`next: justice` (re-run of code panel on the post-fix head).

Self-improvement: nothing this time.
