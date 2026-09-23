---
ts: 2026-05-22T01:27:16Z
kind: result
role: boatman
project: endo
repo: endojs/endo
refs:
  - entries/2026/05/22/012219Z-dispatch-liaison-a98757.md
---

Ferried `endojs/endo-but-for-bots#64` (`design/issue-2632-harden-exports-pattern-makers`, head `e38cc69d73d8bd03063c768420ac344503984ef7`, 3 commits) upstream to `endojs/endo` as a single non-draft PR.

- Upstream PR: endojs/endo#3277, https://github.com/endojs/endo/pull/3277
- Upstream branch: `kriskowal-harden-exports-pattern-makers-2632`
- New commit SHA: `7d853dc825668ad56339f4909df41a88b51c0f3e`
- Base: `endojs/endo@master` (tip `6804b7dc8aafe56a0812039d77f2b01a625b7a0e`; the dispatch named `bf951df346...` parenthetically, but `origin/master` had advanced three commits to `8f4149555` and then six more to `6804b7dc8` between fetch attempts, all unrelated to `packages/eslint-plugin/`; opening against current tip avoids an immediate rebase).
- Draft state: non-draft.
- Title: `feat(eslint-plugin): harden-exports skips M.* pattern makers (#2632)`.
- Body: written against the endo PR template section-for-section (`Closes:`, Description, Security / Scaling / Documentation / Testing / Compatibility / Upgrade Considerations); behavior over diff; no checklists; no garden-side framing.
- Squash: 3 source commits (`5fce579b`, `d4836378`, `e38cc69d`) squashed into one. `git cherry-pick --no-commit` followed by a single `git commit -F` of the redrafted message.
- Path-restricted tree-identity check: `git diff e38cc69d HEAD -- $PATHS` (where `$PATHS = git diff origin/master..HEAD --name-only`) was empty. Six paths: `.changeset/harden-exports-pattern-makers.md`, `packages/eslint-plugin/lib/configs/recommended.js`, `packages/eslint-plugin/lib/rules/harden-exports.js`, `packages/eslint-plugin/lib/rules/no-harden-pattern-maker.js`, `packages/eslint-plugin/test/harden-exports.test.js`, `packages/eslint-plugin/test/no-harden-pattern-maker.test.js`.
- Attribution: `git log origin/master..HEAD --pretty=fuller` shows one commit with author and committer both `Kris Kowal <kriskowal@kriskowal.com>`. `git interpret-trailers --parse` on the message reports no trailers (the `Co-Authored-By: Claude Opus 4.7` trailers on the three source commits were dropped during the squash redraft).
- Push mode: first-push of a new branch using the fully-qualified `refs/heads/` form: `git push origin HEAD:refs/heads/kriskowal-harden-exports-pattern-makers-2632`.
- Source-side cross-link: posted on `endojs/endo-but-for-bots#64` under kriskowal at https://github.com/endojs/endo-but-for-bots/pull/64#issuecomment-4514157889, naming the upstream URL, head SHA, the 3-to-1 squash, and that `Fixes #2632` was added.
- No comments on the new upstream PR (identity discipline; kriskowal identity reserved for actions that need maintainer authority).
- Body deviation from dispatch wording: the dispatch named `#issuecomment-2479055797` as the @erights quote source; the actual comment on `endojs/endo#2632` is `#issuecomment-2477602697` (the only comment on the issue, authored by erights). The quote in the commit body and the framing paragraph in the PR body both use the correct comment.

Self-improvement: nothing this time. The four-part `pr-formation` body order generalized cleanly to the endo template's section list; the only field-worthy observation is that the dispatch named an `issuecomment-` ID that did not exist (presumably hallucinated upstream of the boatman), and verifying it against the actual issue comments before quoting was a small step that should be standard whenever a dispatch prompt names a specific GitHub comment ID, but that is too thin to land as a skill row without seeing it again.
