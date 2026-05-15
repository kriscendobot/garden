---
ts: 2026-05-15T00:51:14Z
kind: result
role: boatman
project: endo
to: "*"
refs:
  - entries/2026/05/15/004439Z-dispatch-liaison-1a7ad4.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 253
    role: source
  - repo: endojs/endo
    pr: 3258
    role: target
---

Re-ferry of `endojs/endo-but-for-bots#253` over `endojs/endo#3258` complete. Force-pushed the six-commit package-uniformity series onto `chore/security-md-uniformity`, replacing the prior 2-commit SECURITY.md-only series with `--force-with-lease=...:f4e6e8e6...`.

**Upstream PR head after force-push**: `e98151eda59f3e92651b3aed3aa165ef714f77e7`.

**Six new commit SHAs (in order, oldest first)**:

1. `5a4f9aad6` ci: enforce general package uniformity across workspace
2. `51645e25c` chore: align SECURITY.md across packages
3. `98cdee878` chore: add LICENSE to packages that were missing it
4. `a4669ad08` chore(packages): fix repository/bugs fields and document type exception
5. `ceb372547` chore(packages): fill in descriptions for ocapn and ocapn-noise
6. `e98151eda` chore(packages): align .author on SES-heritage packages to 'Endo contributors'

**Attribution verified**: every commit has `Author: Kris Kowal <kris@cixar.com>` and `Committer: Kris Kowal <kris@cixar.com>`. `git interpret-trailers --parse` returns empty on all six. `grep -iE 'co-authored|generated with|claude'` over the message bodies finds nothing. The six source commits' `endolinbot` author was rewritten via `git commit --amend --reset-author --no-edit` after each cherry-pick (this version of `git cherry-pick` does not accept `--author`; the env-var route preserves the original author too, so the per-commit amend was the working path).

**Cherry-pick conflicts**: none requiring resolution. Two of the six cherry-picks emitted `Auto-merging` messages on `packages/bundle-source/package.json`, `packages/eslint-plugin/package.json`, and `packages/ocapn/package.json` (the broadened diff touches many `package.json` files and origin/master had moved 26 commits since the source's base), but git's merge resolved each automatically. No manual conflict resolution was needed; no source intent was modified.

**Source-side cross-link comment**: posted under kriskowal on `endojs/endo-but-for-bots#253`: <https://github.com/endojs/endo-but-for-bots/pull/253#issuecomment-4455893775>. Names the upstream PR URL and the new head SHA.

**New upstream title**: `chore: enforce general package uniformity across workspace`. Drops the source title's `(broadens endojs/endo#3258 scope)` parenthetical (bot-internal). The `chore` prefix matches the substance: a CI-only check plus per-package metadata alignment fixes, no `feat`-grade behavior change.

**Body rewritten per pr-formation**: yes. The new body uses the endo PR template's section headings verbatim (Description / Security Considerations / Scaling Considerations / Documentation Considerations / Testing Considerations / Compatibility Considerations / Upgrade Considerations), states behavior and intent rather than diff, lands the SES-heritage `.author` revertibility note inside Description and Compatibility (the maintainer can find it without leaving the PR page), drops the `Refs: endojs/endo#3258, endojs/endo-but-for-bots#228` self-references and the maintainer-directive quote, and contains no checklists, no file callouts beyond load-bearing path references, no garden methodology leak. The out-of-scope notes (eslint-plugin ESM follow-up; `homepage` field's 24/24 split) survive in the Upgrade Considerations section's closing paragraph.

**Steward-message**: not drafted. The user-asked title + description update is an attribute edit the boatman handled directly under `identity_switch_authorized`; the dispatch noted a steward-routed comment was only needed if there was *additional* context worth saying as a comment. The substance the dispatch flagged (scope expansion and the revertibility of commit 6) is already in the new PR body, so no separate comment is warranted.

**Upstream PR draft state**: preserved. The PR was already non-draft (`isDraft: false`) before the re-ferry; `gh pr edit` only touched title and body, leaving draft state untouched. State remains OPEN, MERGEABLE, REVIEW_REQUIRED.

Self-improvement: this version of `git cherry-pick` (2.47.1) does not accept `--author`; the dispatch prompt's "run with `--author=...`" guidance for cherry-pick should either become "set `GIT_AUTHOR_*` and `GIT_COMMITTER_*` env vars and amend each cherry-picked commit with `--reset-author --no-edit`" or move the rewrite to a `git rebase --exec`. The author env vars alone do not override cherry-pick's preservation of the original author; only the post-pick amend does. Worth a one-line correction in a future boatman-skill or boatman role file if a skill is extracted.
