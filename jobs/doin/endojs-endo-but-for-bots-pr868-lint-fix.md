# fixer on endojs/endo-but-for-bots PR #868 (lint break from eslint-plugin-unicorn 72)

Wear roles/fixer/AGENT.md. The dependabot PR
<https://github.com/endojs/endo-but-for-bots/pull/868> bumps
`eslint-plugin-unicorn` from 56.0.1 to 72.0.0 and turns the `lint` CI check
red with 7 real errors. The botany review
(`endojs-endo-but-for-bots-pr868-dependabot`) rendered
**EMBARGO-2026-08-02** on supply-chain maturity grounds and diagnosed the
lint break to the exact mechanism below. Your job is to make the PR's `lint`
check green so the PR is mergeable the moment the embargo lifts.

Work on the PR head branch `dependabot/npm_and_yarn/eslint-plugin-unicorn-72.0.0`
(head SHA at review time `f8cf6acf688cff25033412355d2047609d2e9cc2`, base `llm`).
Get an isolated checkout with
`scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots dependabot/npm_and_yarn/eslint-plugin-unicorn-72.0.0`.
Note that dependabot force-pushes this branch when it rebases; re-fetch before
you push, and do not force-push over a newer dependabot head.

## The failures (from CI run 30218264146, job 89836077119)

All 7 are `unicorn/numeric-separators-style` -- "Invalid group length in numeric value":

| File | Lines |
|---|---|
| `packages/ocapn/test/codecs/passable.test.js` | 317:27, 327:27 |
| `packages/random/src/random.js` | 10:18 |
| `packages/random/test/random.test.js` | 130:5, 130:31, 131:5, 131:31 |

Every one of them is a **fractional-part** separator group, for example
`3.141_59`, `1.110_223_024_625_156_5e-16`, `0.202_492_713_878_710_48`.

## Root cause (verified by reading both rule sources)

v56.0.1 `rules/numeric-separators-style.js` formatted a float as:

```js
addSeparator(integer, options) + dot + addSeparatorFromLeft(fractional, options)
```

so the fractional part was grouped left-to-right using the same `groupLength: 3`.

v72.0.0 introduced a separate `fractionGroupLength` option and changed the line to:

```js
addSeparator(integer, options) + dot + addSeparatorFromLeft(fractional, {...options, groupLength: options.fractionGroupLength})
```

with the default `number: {minimumDigits: 5, groupLength: 3, fractionGroupLength: Infinity}`.
`Infinity` means **no fractional grouping at all** by default, so every existing
fractional separator in the repo is now reported as an invalid group.

The repo configures the rule at `packages/eslint-plugin/src/configs/shared.js`
around line 568 and does not set `fractionGroupLength`, so it picks up the new
default.

## Preferred fix

Add `fractionGroupLength: 3` to the `number` options in
`packages/eslint-plugin/src/configs/shared.js`:

```js
'unicorn/numeric-separators-style': [
  'error',
  {
    onlyIfContainsSeparator: false,
    number: { minimumDigits: 5, groupLength: 3, fractionGroupLength: 3 },
    binary: { minimumDigits: 0, groupLength: 4 },
    octal: { minimumDigits: 0, groupLength: 4 },
    hexadecimal: { minimumDigits: 0, groupLength: 4 },
  },
],
```

The schema accepts `fractionGroupLength` as an integer >= 1 (validated in the
v72 rule source), and this restores the exact v56 behaviour, so all 7 literals
stay as written and the diff stays a config one-liner. Prefer this over
`eslint --fix`, which is also available (the rule is `fixable: 'code'`) but
would rewrite 7 numeric literals across 3 packages to strip their fractional
separators, changing the repo's deliberate readability convention without a
decision.

Also update the wiring test
`packages/eslint-plugin/test/internal-numeric-separators.test.js` if it asserts
the old option shape, and re-run it.

## Second required change: a changeset

`eslint-plugin-unicorn` is a **runtime `dependencies` entry** of the published
package `@endo/eslint-plugin` (currently 2.6.0, not private), not a
devDependency. Bumping its range from `^56.0.1` to `^72.0.0` changes what every
downstream consumer of `@endo/eslint-plugin` lints, and the dependabot PR
carries no changeset. Add one under `.changeset/` per
`skills/changeset-discipline/SKILL.md`. Treat the fractional-separator default
change as the user-visible behaviour change to describe.

## Before you push

Run the CI-equivalent checks locally per `skills/local-verify/SKILL.md` and
`skills/pre-push-gates/SKILL.md`; a red lint in CI after your push is an
automation defect, not just a PR fix (`roles/COMMON.md` § Reporting).

Commenting on `endojs/endo-but-for-bots` is covered by the repo's standing
authorization (`journal/projects/endo-but-for-bots/README.md` § Standing
authorizations), so post the completion summary comment on the PR per
`skills/pr-completion-summary-comment/SKILL.md`. Do **not** merge or un-embargo
the PR: the embargo lifts at 2026-08-02T16:39:39Z and the scheduled recheck
`dependabotany-recheck-endo-but-for-bots-pr868` fires at 2026-08-02T17:15:00Z
to render the terminal verdict.

<!-- garden-reaped: 0 -->

<!-- garden-productive-cycle -->
---
claim:
  host: ps23
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-28T07:16:17Z
