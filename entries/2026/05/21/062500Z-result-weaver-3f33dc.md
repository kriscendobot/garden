---
ts: 2026-05-21T06:25:00Z
kind: result
role: weaver
worktree: dispatches/weaver--dd5d19/project
repo: endojs/endo-but-for-bots
project: endo
to: steward
refs: []
---

PR #74 (`design/audit-module-source-visitors`) rebase onto `origin/master`: the rebase reveals the branch's premise is fully superseded. All three branch commits are upstream-mirror duplicates of commits that have already landed on master via the merge of upstream PR endojs/endo#3241 (master commit `0e3c980c5`). No force-push was performed; per the weaver norm "if the rebase reveals that the branch's premise no longer makes sense on the new base, stop and surface the question to the dispatcher," the dispatch stops here and asks the steward / liaison how to proceed (close PR #74, or leave the branch as a historical pre-mirror snapshot).

## Pre-rebase state

- Remote head: `cb73507827eaa6ec8173909155156ea732839279` (verified via `git ls-remote origin design/audit-module-source-visitors`).
- Base `origin/master`: `bf951df346cfcf605a6709e6a5479f2fdd526113`.
- Ahead/behind: 3 ahead, 66 behind.
- Branch commits, in order:
  - `01380110b` fix(module-source): support `export * as ns from 'src'`
  - `e9631f575` fix(module-source): supply Babel Hub so reserved-id diagnostic reports cleanly
  - `cb7350782` fix(module-source): apply boneskull review comments from endo#3241 (#74)
- Combined branch diff vs `01380110b^`: 3 files (`packages/module-source/src/babel-plugin.js`, `packages/module-source/src/transform-source.js`, `packages/module-source/test/module-source.test.js`), 130 insertions, 12 deletions.

## Post-rebase state

- Local HEAD after rebase: `bf951df346cfcf605a6709e6a5479f2fdd526113` (= `origin/master`).
- Ahead of `origin/master`: 0 commits. `git diff origin/master..HEAD --stat` is empty.
- **Not pushed.** Remote still at `cb7350782`.

## What survived and what dropped

| Branch commit | Upstream landing | Disposition | Reason |
|---|---|---|---|
| `01380110b` "support `export * as ns from 'src'`" | `4ffd85548` on master (from PR #3241 merge `0e3c980c5`) | dropped as empty during `git rebase origin/master` | identical patch already on base; commit became no-op |
| `e9631f575` "supply Babel Hub" | `5bcce1755` on master | `git rebase --skip` after reading both conflict sides | content identical except for stylistic refinements that upstream already incorporated via `0456f5674` (JSDoc `File`/`NodePath` vs `object`/`object`, custom-message-string folded into assertion args, cross-repo issue ref formatting) |
| `cb7350782` "apply boneskull review comments from endo#3241 (#74)" | `0456f5674` on master | dropped as empty after the skip | identical patch already on base |

## Conflicts (during `e9631f575` replay)

Both files conflicted because master already contains the *post-review* version (boneskull's JSDoc/message-string refinements from `0456f5674`) while branch commit `e9631f575` is the *pre-review* version.

### `packages/module-source/src/transform-source.js`

One hunk, JSDoc on `makeHubParentPath`:

- HEAD (master, post-boneskull): `@param {File} ast` / `@returns {NodePath}`.
- Incoming (`e9631f575`, pre-boneskull): `@param {object} ast` / `@returns {object}`.

Boneskull's review fix (`0456f5674` on master, `cb7350782` on the branch's tip) replaces the `object`/`object` annotations with `File`/`NodePath`. Master already has the better annotations. No woven third state needed because the third branch commit `cb7350782` is the same edit.

### `packages/module-source/test/module-source.test.js`

Four conflict hunks, all in the reserved-identifier regression tests added by `e9631f575`:

1. **Line 444-448**: comment reference `// Regression test for the second crash reported in #1596:` (HEAD) vs `endojs/endo#1596` (branch). Boneskull's review left the ref form alone upstream; the branch's third commit `cb7350782` did not retouch this line either. The branch's `endojs/endo#1596` form is the more cross-repo-explicit one; master's `#1596` is the upstream-native form that lands when the fix is mirrored back to `endojs/endo`. Either is correct; the difference is irrelevant if the branch is closed.
2. **Line 466-470**: HEAD (master) has no explanatory comment between the `t.throws(...)` assertion and the following `t.notRegex(...)`; branch `e9631f575` has a two-line explanatory comment. Master folded that explanation into the assertion's custom-message argument (the boneskull review fix in `0456f5674` / branch's `cb7350782`).
3. **Line 476-479**: HEAD has the custom-message string `'Hub-backed diagnostic must flow through; ...'` as the third arg to `t.notRegex`; branch `e9631f575` has the plain two-arg form. Same boneskull review story as hunk 2.
4. **Line 495-498**: identical pattern to hunk 3, in the sibling `'invisible joiner character in constified variable is reserved'` test.

All four conflicts collapse to the same root cause: master is the post-review form; branch `e9631f575` is the pre-review form; branch `cb7350782` is the same review fix as the upstream `0456f5674` master applied. After resolving by reading both sides and walking to `cb7350782`, the result is identical to master, so the commit is genuinely empty in the rebase-skip sense.

## Force-push result

**Not performed.** Remote `design/audit-module-source-visitors` is still at `cb7350782`. Force-pushing the rebased detached HEAD would push `bf951df3` (= `origin/master`) which would:

1. Empty the PR's diff to zero, which GitHub treats as a no-op PR. GitHub does not auto-close on empty-diff but `gh pr view` would show 0 changed files.
2. Erase the branch's only remaining distinguishing characteristic (the three pre-mirror snapshot commits) without giving the steward / liaison a chance to decide whether to (a) close PR #74 as superseded by upstream PR #3241, (b) keep the branch as a historical snapshot, or (c) repurpose the branch for a follow-up.

## Recommendation

The maintainer's dispatch comment ("rebase, resolve conflicts, and run the gauntlet on what remains") was written before the maintainer had visibility into the empty-after-rebase outcome. Options for the steward / liaison to surface:

1. **Close PR #74 as superseded** by upstream PR endojs/endo#3241 (now landed on `endojs/endo` master and mirrored into `endo-but-for-bots` master). No code action needed; the work is upstream.
2. **Force-push the empty rebase** (`bf951df3`) and let the PR sit as a zero-diff record before closing. This is the literal interpretation of the dispatch but offers no value over option 1.
3. **Leave the branch unrebased** and ask the maintainer to confirm option 1.

Self-improvement: nothing this time. The weaver norm "the branch's premise no longer makes sense on the new base — stop and surface" worked exactly as written; this is a textbook application, not a missing rule.
