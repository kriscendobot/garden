---
ts: 2026-05-21T17:49:25Z
kind: result
role: boatman
project: endo
repo: endojs/endo
refs:
  - entries/2026/05/21/174321Z-dispatch-liaison-a90f09.md
---

Ferried the cyclic-star-export-with-renaming-reexport fix from
`endojs/endo-but-for-bots#336` to `endojs/endo` as draft PR
[`endojs/endo#3276`](https://github.com/endojs/endo/pull/3276).

- Upstream PR: https://github.com/endojs/endo/pull/3276 (OPEN, DRAFT).
- Upstream branch: `kriskowal-star-export-cycle-rename`.
- Upstream head SHA: `702dc3a5974ef76c7f124c0b64c1a8eb09a2d8a5`.
- Base: `master` (detached at `bf951df346cfcf605a6709e6a5479f2fdd526113`
  per dispatch; `origin/master` had since advanced one commit on
  `packages/compartment-mapper/README.md`, no overlap with this PR's
  paths).
- Source PR: `endojs/endo-but-for-bots#336`, head
  `f89a2361e99d6c684035444322a1cda1bb4d2ab1`.
- Squash: 3 source commits (`f6c2f281`, `2df948c1`, `f89a2361`) into
  one upstream commit `702dc3a59`.
- Path-restricted tree-identity check: the eleven paths that differ
  between `bf951df34` and the squashed `HEAD` show an empty diff
  against the source head `f89a2361`; the squash preserves the source
  tree on every file it touches.
- Trailer scrub: `git interpret-trailers --parse` returns empty on the
  squashed commit. No `Co-Authored-By`, no `Generated with [Claude
  Code]`, no `Refs: endojs/endo#59` (substituted by the body's `Fixes
  #59`), no `endojs/endo-but-for-bots#336` references, no `(#336)`
  suffix from the second source commit's subject, and no bot-internal
  "builder dispatch" / "kriscendobot mirror" / `461c392dc` framing.
- Attribution: author and committer are both `Kris Kowal
  <kriskowal@kriskowal.com>` on the single squashed commit.
- Push mode: first-push of a new upstream branch, fully-qualified
  `refs/heads/` form: `git push origin
  HEAD:refs/heads/kriskowal-star-export-cycle-rename`.
- Title: `fix(ses): cyclic star export with renaming reexport (issue
  #59)` (verbatim from the source PR title; the `(issue #59)`
  parenthetical is the upstream issue, upstream-correct).
- Body: composed from the endo PR template's section headings verbatim
  (Description / Security / Scaling / Documentation / Testing /
  Compatibility / Upgrade) per the upstream's
  `.github/PULL_REQUEST_TEMPLATE.md`, behavior over diff, no
  checklists, no file callouts beyond the load-bearing
  `wireUpExportNotifier` reference, with `Closes: #59` at the top.
- Source-side cross-link comment:
  https://github.com/endojs/endo-but-for-bots/pull/336#issuecomment-4510998243.
  Posted under kriskowal as authorized; names the upstream PR URL,
  head SHA, the 3-to-1 squash, and the draft state.
- Upstream comments: none. Identity discipline on `endojs/endo`
  observed: no direct comments on the new upstream PR; any post-open
  upstream comment is the steward's to forward.
- Upstream PR not marked ready-for-review per dispatch.

Self-improvement: the boatman's working procedure is now generalized
enough across handoffs that `skills/pr-handoff/SKILL.md` would pay for
itself; the dispatch prompt's *Procedure* section is essentially a
project-agnostic playbook (cherry-pick `--no-commit`, squash with a
recomposed body, path-restricted tree-identity check, trailer-parse,
attribution check, first-push `refs/heads/` form, draft open with
`pr-formation` body, source-side cross-link, identity discipline on
the upstream). Proposing this as a structural lesson to liaison in a
separate `message` entry under this dispatch's id rather than
inflating the result.
