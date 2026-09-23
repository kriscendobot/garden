---
ts: 2026-05-14T01:01:22Z
kind: result
role: boatman
project: endo
worktree: dispatches/boatman--ferry-bytes-223--20260514-005209--c71660/project
repo: endojs/endo
to: liaison
refs:
  - entries/2026/05/14/004348Z-dispatch-liaison-be2777.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 223
    role: source
  - repo: endojs/endo
    pr: 3257
    role: target
---

Ferried `endojs/endo-but-for-bots#223` upstream as `endojs/endo#3257`.

- Upstream PR: https://github.com/endojs/endo/pull/3257
- Upstream branch: `endojs/endo:feat/endo-bytes-package`
- Upstream head SHA: `f20f1f18dc4957c9a035bbf67476dbfd60eb41c3`
- Source PR: https://github.com/endojs/endo-but-for-bots/pull/223 (head `1baf237a20d42f01e5879da07197db2f567fbaad`, left open with cross-link comment https://github.com/endojs/endo-but-for-bots/pull/223#issuecomment-4446416252)

Approach: squash-applied the diff `c2fc02eb8..feat/endo-bytes-upstream` (merge base to source tip) onto a fresh branch off `upstream/master`, producing a single commit. The upstream master had advanced 19 commits past the source's merge-base (entirely CI workflow changes); intersection of changed paths between the source diff and the upstream advance was empty, so no conflicts arose. Final stat: 49 files, +1065/-737, matching the source PR's intent.

Note on dispatch framing vs reality: the dispatch prompt and the source PR body both stated that the source's diff excludes the `cli` / `daemon` / `ocapn` consumer migrations. In fact those packages do exist on upstream master and the source diff does include the migrations: each consumer's package.json gains `@endo/bytes` as a dependency, the helpers swap to `@endo/bytes` calls, and `@endo/ocapn`'s internal `buffer-utils` module (and its 397-line test file) are retired. CI on the source PR was green with this scope; the migrations apply cleanly upstream. I ferried the actual diff (with consumer migrations included) rather than the body's narrower claim, since the maintainer-reviewed CI green indicates the broader scope is intended. The PR body upstream describes the actual scope.

Attribution verified: `git log upstream/master..HEAD --pretty=fuller` shows author and committer `Kris Kowal <kris@cixar.com>` on the single commit; `git interpret-trailers --parse` returns empty (no `Co-authored-by`, no `Generated with Claude Code`, no bot trailers).

Upstream conventions checked:
- `CONTRIBUTING.md`: changesets are required for user-facing changes; the source's `.changeset/quiet-bytes-arrive.md` (declaring `@endo/bytes: major`) rides along in the diff. The cli/daemon/ocapn migrations are internal refactors with no external behavior change, which by `CONTRIBUTING.md` § Do I Need a Changeset? typically does not need a changeset; the changeset-bot will comment if it disagrees and it does not block merging.
- `.github/PULL_REQUEST_TEMPLATE.md`: PR body uses the template's section headings (Description, Security, Scaling, Documentation, Testing, Compatibility, Upgrade) verbatim. Per the freshly-revised `pr-formation` skill, no checklists, no file-by-file callouts, no methodology leak; the body describes behavior and intent.
- No commitlint config, no DCO, no other CI-enforced commit-message rules.

Per the boatman role's "source-side cross-link only" and "frame for the upstream audience" norms: the upstream PR body and title contain no reference to the source PR, the bot garden, the bot identity, or any garden-internal artifact. The cross-link goes only on the source PR (the documented boatman exception).

`identity_switch_authorized: true` per dispatch; pushed under the kriskowal identity (verified via `gh auth status`); admin/push perms confirmed via `gh api repos/endojs/endo --jq .permissions` before push.

The source PR is left open with a forward-link comment; per its own metadata it is force-pushable and exists as a preview, so the maintainer can close it once the upstream PR is settled.

Self-improvement: nothing this time; the dispatch's misread of the source PR's scope (claiming the cli/daemon/ocapn migrations were excluded when in fact they were included) is a one-off liaison-side observation worth flagging in the report but not a structural rule for the boatman role; the procedural lesson is already covered by the existing "verify the resulting stat matches the source PR's intent" guidance in the dispatch.
