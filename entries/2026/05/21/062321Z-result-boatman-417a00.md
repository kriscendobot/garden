---
ts: 2026-05-21T06:23:21Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/21/061720Z-dispatch-liaison-6c7e30.md
---

Ferried `endojs/endo-but-for-bots#67` (the eslint-plugin `harden-exports` destructuring fix) to upstream as `endojs/endo#3274`.

- Upstream PR: https://github.com/endojs/endo/pull/3274
- State: OPEN, non-draft
- Base: `master` at `bf951df346cfcf605a6709e6a5479f2fdd526113`
- Head branch: `kriskowal-harden-exports-2390`
- Head SHA: `3541665dd64da9dccc9e66417b9c83395f4b86fe`
- Push mode: first-push fully-qualified `git push origin HEAD:refs/heads/kriskowal-harden-exports-2390` per the #329 lesson.

Squash and tree-identity:

- Source PR carried two commits (`9f30cbd4` and `7ddcfa48`); both were cherry-picked with `--no-commit` then a single composed commit was made. The squashed commit's subject `fix(eslint-plugin): harden-exports handles destructuring patterns (#2390)` is verbatim from source commit 1; the upstream `(#2390)` reference is upstream-correct and was kept.
- `git diff 7ddcfa48 HEAD -- .changeset/harden-exports-destructuring.md packages/eslint-plugin/lib/rules/harden-exports.js packages/eslint-plugin/test/harden-exports.test.js` is empty: tree identity holds across the three touched paths. (A naive `git diff 7ddcfa48 HEAD -- .` is *not* the right check here; the source-PR head was cut from a different base than `origin/master`, so its tree contains unrelated changesets. Comparing only the touched paths is the correct identity check.)

Attribution: `git log origin/master..HEAD --pretty=fuller` reports one commit with both author and committer `Kris Kowal <kriskowal@kriskowal.com>`. `git interpret-trailers --parse` on the commit body is empty: no `Co-authored-by`, no Claude trailer, no bot framing.

Body: composed per `skills/pr-formation/SKILL.md` against the endo `.github/PULL_REQUEST_TEMPLATE.md` template at the head of `master`, using its section headings verbatim (Description, Security Considerations, Scaling Considerations, Documentation Considerations, Testing Considerations, Compatibility Considerations, Upgrade Considerations). No checklists. The binding-shape table was retained as a behavior-centric reference; the test fixture file path `packages/eslint-plugin/test/harden-exports.test.js` appears in the Testing Considerations section as load-bearing reviewer-reproduction context (in line with the dispatch prompt's explicit allowance). Bot trailers, `endo-but-for-bots#67` references, and the test-plan checklist from the source PR body were dropped. `Closes: #2390` is on the first line, replacing the template's `Closes: #XXXX` placeholder.

Source-side cross-link: https://github.com/endojs/endo-but-for-bots/pull/67#issuecomment-4505363626. Names the upstream PR URL, head SHA, the 2→1 squash, and that the `Fixes #2390` closing keyword was added.

No comments were posted on the new upstream PR. No changes were made to source-side PR #67. The PR is non-draft as requested.

Self-improvement: the `git diff <source-head> HEAD -- .` tree-identity check in the dispatch prompt is misleading when the source-PR head was cut from a different base than the upstream target (here, the source branch carried 60+ unrelated changesets ahead of upstream master). The correct identity check restricts the diff to the touched paths: `git diff <source-head> HEAD -- <path1> <path2> ...` after `git diff origin/master..HEAD --name-only` lists them. This belongs in `skills/pr-formation/SKILL.md` (or a new `skills/pr-handoff/SKILL.md` when the boatman procedure is promoted) as a footnote on the tree-identity check.
