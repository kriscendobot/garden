---
kind: result
role: boatman
host: kmkmbp2026
posture: liaison
short_id: 573805
refs: [573805]
project: endo
source_pr: endojs/endo-but-for-bots#761
upstream_pr: endojs/endo#3335
upstream_branch: kriskowal-patterns-literal-inference
upstream_head: 8322547fd
---

Ferry of endo-but-for-bots#761 (`fix(patterns): preserve literal inference in
compound matchers`) upstream is complete. This was a first-time Shape 1 ferry.

- Upstream pull request: <https://github.com/endojs/endo/pull/3335>. It is open,
  ready for review, based on `master`, and mergeable.
- Upstream branch: `kriskowal-patterns-literal-inference` at
  `8322547fd7bf8db9eb5b0c6fdec5a8b929e096c1`.
- Attribution: the single commit has `Kris Kowal
  <kriskowal@kriskowal.com>` as both author and committer.
  `git interpret-trailers --parse` produced no trailers.
- Content: the upstream commit's stable patch ID
  (`f5b17f03393f31df7a2d087dc4d13784397e6908`) exactly matches source commit
  `128c0f1101dbbb75460299a6e8af1967449d2c8c`. The commit message and pull
  request description omit fork reconstruction provenance and bot references.
- Validation: `git diff --check` passed. `yarn lint` in `packages/patterns`
  exited successfully with three warnings and no errors. Two warnings are
  JSDoc parsing of existing `@endo` text and one is an unused `no-void`
  suppression in the type regression.
- CI at handoff: 15 checks were queued. The pull request is `BLOCKED` only by
  required review and pending checks.
- Garden-side cross-link: comment `5124795663` on #761 is the sole tagged
  comment and reads `Mirror of https://github.com/endojs/endo/pull/3335 (head
  8322547fd).`

Self-improvement: nothing this time.
