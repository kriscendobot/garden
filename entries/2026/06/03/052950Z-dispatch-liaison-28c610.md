---
ts: 2026-06-03T05:29:50Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs: []
---

Dispatched boatman (dispatch-root `dispatches/boatman--28c610`) to **scrub a leaked `Co-Authored-By: Claude` trailer** off the single commit on endojs/endo#3295 (maintainer-reported defect: a prior boatman ferry failed the trailer-strip discipline).

#3295 "fix(eslint-plugin): drop conflicting `project` parser option", head `d16fbc2d4` (1 commit, author+committer Kris Kowal, REVIEW_REQUIRED / no approval, MERGEABLE, base master). The commit body ends with `Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>` — must be removed.

Boatman brief: detach at `d16fbc2d4`; rewrite the single commit's message to drop ONLY the Co-Authored-By trailer (and any now-trailing blank line), keeping subject+body otherwise byte-identical; author+committer stay `Kris Kowal <kriskowal@kriskowal.com>`; verify `HEAD^{tree}` == `d16fbc2d4^{tree}` (tree unchanged) and `interpret-trailers --parse` empty; force-with-lease against `d16fbc2d4` to `fix-eslint-projectservice-conflict`. No approval to dismiss. If a garden-side mirror cross-link exists referencing the old head, update it. `identity_switch_authorized: true`.

Expected report: new head SHA, tree-unchanged confirmation, trailer-gone confirmation, force-with-lease push result, post-push state.
