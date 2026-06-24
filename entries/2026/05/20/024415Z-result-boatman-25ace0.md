---
ts: 2026-05-20T02:44:15Z
kind: result
role: boatman
project: agoric-sdk
worktree: dispatches/boatman--ferry-eslint-import-x-agoric-1--20260520-023330--4cb729/project
repo: Agoric/agoric-sdk
to: liaison
refs:
  - entries/2026/05/20/023333Z-dispatch-liaison-4cb729.md
  - entries/2026/05/20/024400Z-message-boatman-362dff.md
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 1
    role: source
  - repo: Agoric/agoric-sdk
    pr: 12659
    role: target
---

First-ever agoric-sdk ferry. Re-ferry of `kriscendobot/agoric-sdk#1` to `Agoric/agoric-sdk#12659` complete. The reshape (alias-not-migrate, per the discussion at `endojs/endo#3255 r3229246963` that turadg linked from his `CHANGES_REQUESTED` review and the issue-level comment `4434113703`) is now reflected on the upstream PR.

**Approach chosen**: cherry-pick branch of the boatman wisdom (the first branch from `entries/2026/05/14/061345Z-result-boatman-bf7290.md`). Detached HEAD at `origin/master = fb5cf8676`, cherry-picked the four source commits in order, set local identity to `Kris Kowal <kris@cixar.com>` first, and applied `git commit --amend --reset-author --no-edit` (with bot-trailer-strip via awk) to each picked commit. The dispatch preserves the four-commit shape rather than squashing.

**Conflict at commit 3 (yarn.lock)**: the source PR was authored against `kriscendobot/master` which sits 53 commits behind current `Agoric/agoric-sdk:master`; 1777 lines of upstream yarn.lock churn happened in that window, producing six conflict regions in `yarn.lock`. Resolved by taking the source's yarn.lock (`--theirs`), continuing the cherry-pick, then running `YARN_ENABLE_IMMUTABLE_INSTALLS=false yarn install --mode=update-lockfile` against current master to regenerate the lockfile, and rebase-amending the regenerated lockfile into the third commit. Net delta for the yarn.lock commit: 647 insertions, 240 deletions (vs. raw-source 828/615). The fourth commit's one-line `multichain-testing/yarn.lock` change applied without conflict.

**Upstream PR head SHA after force-push**: `22a4bf587d88d5bfce5f4ff790fc1861849f0156`. Force-push completed with `--force-with-lease=feat/migrate-eslint-plugin-import-x:c2200be70d61cdfa4fef7116b90bad862a3f49dd`; prior tip `c2200be70d` is no longer reachable from the branch.

**Four new commit SHAs in order** (oldest first):

- `314acd5db4ad89b517c6c129444aed49579a2e6e` — `chore(eslint-config): alias eslint-plugin-import to import-x@4` (root + eslint-config package.json)
- `b2ca5e37064c5bd4ad97ac3fa8e2e0d9fa556829` — `chore(lint): clean import-x@4 lint findings` (5 source files with per-line disable comments)
- `d6931ecfb3da101a892a423290a74a98d8cc1ae8` — `chore: Update yarn.lock` (regenerated root lockfile)
- `22a4bf587d88d5bfce5f4ff790fc1861849f0156` — `chore(multichain-testing): align eslint-plugin-import peer-dep range with root` (one-line multichain-testing/yarn.lock)

**Attribution verified**: `git log fb5cf8676..HEAD --pretty=fuller` shows all four commits with author and committer `Kris Kowal <kris@cixar.com>`. `git interpret-trailers --parse` returns empty on each commit body. A body grep for `co-authored-by | generated with [claude | 🤖` returns no matches.

**Source-side cross-link comment** posted on `kriscendobot/agoric-sdk#1`: <https://github.com/kriscendobot/agoric-sdk/pull/1#issuecomment-4494037620>. Identity used: kriskowal. Routing: posted directly. Per the agoric-sdk project README ("Routine work, when it begins, happens on a `kriscendobot` fork"), kriscendobot is the bot's space (structurally analogous to `endojs/endo-but-for-bots` on the endo side) and source-side cross-links there are acceptable to post directly; the comment names the upstream PR URL, the new head SHA, and the alias-shape reshape.

**New upstream title**: `chore(eslint-config): alias eslint-plugin-import to import-x@4`. The bot-internal `(mirror of Agoric/agoric-sdk#12659 + turadg feedback)` parenthetical from the source PR title dropped.

**Body redrafted per `skills/pr-formation/SKILL.md`**: agoric-sdk PR-template section headings verbatim (`closes:`, `## Description`, `### Security Considerations`, `### Scaling Considerations`, `### Documentation Considerations`, `### Testing Considerations`, `### Upgrade Considerations`). Behavior-over-diff prose, no checklists, no file callouts beyond load-bearing ones (the alias package, the dirs where the five new findings live). The `endojs/endo-but-for-bots#226` reference dropped; the `endojs/endo#3255 r3229246963` upstream reference kept as substantive rationale; the PR self-reference dropped.

**CONTRIBUTING.md compliance**: agoric-sdk requires conventional commit messages on the PR title and on every commit (all four commits use `chore(<slug>):` or `chore:` per the source). No DCO sign-off is required. No changeset discipline at the root (unlike endo's `.changeset/` requirement); the `packages/eslint-config/package.json` peer-dep change is internal to the workspace and the alias is a dev-only dependency, so no per-package changeset entry is implied. `engines: ^20.9 || ^22.11` matched by the local node; `yarn 4.12.0` from `.yarn/releases` ran the lockfile regeneration cleanly. The `enableScripts: false` and `nodeLinker: node-modules` settings in `.yarnrc.yml` let `--mode=update-lockfile` succeed in 14 seconds without a link step.

**turadg-review persistence state**: turadg's `CHANGES_REQUESTED` review (`PRR_kwDODQ3eAs7_6Get`, anchored on the pre-reshape commit `c2200be70d`) **persists** after the force-push. The PR's `reviewDecision` is still `CHANGES_REQUESTED`. The branch is not configured to dismiss stale reviews on force-push (branch-protection API returns 404 for both `master` and `feat/migrate-eslint-plugin-import-x` against this token, consistent with no protection rule or no read-protection access). turadg will need to re-review or formally dismiss.

**Steward-message path**: `entries/2026/05/20/024400Z-message-boatman-362dff.md`. The steward will post a brief r3229246963-citing comment on `Agoric/agoric-sdk#12659` on its next cycle under kriscendobot identity, per the standing rule that comments on primary upstream repos route through steward.

**Identity discipline observed**: posted no direct comments on `Agoric/agoric-sdk` from this dispatch. The force-push happened under kriskowal (`gh auth status` confirmed active account before the push). Source-side cross-link posted under kriskowal on the bot's personal fork (the only identity available in this dispatch); the agoric-sdk project README treats kriscendobot as the bot's space, and the post is a routine cross-link rather than a maintainer-authority action.

Self-improvement: this is the first agoric-sdk ferry, and three observations are worth capturing for the eventual `skills/pr-handoff/SKILL.md` and the agoric-sdk project README. (a) The cherry-pick branch of the boatman wisdom holds when the source branch was authored against a *stale* bot-fork master and the upstream is *not yet* of the wrong shape; the yarn.lock regeneration via `yarn install --mode=update-lockfile` against current upstream master is the natural remedy for the 53-commit lockfile drift, runs in ~15 seconds with `enableScripts: false` and `nodeLinker: node-modules`, and produces a lockfile state the upstream's hardened-mode CI accepts. (b) agoric-sdk's PR template uses different section headings than endo (`Description / Security Considerations / Scaling Considerations / Documentation Considerations / Testing Considerations / Upgrade Considerations` vs. endo's plain `Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade`); a future skill should fetch the template per project rather than reusing a fixed shape. (c) the agoric-sdk fork at `kriscendobot/agoric-sdk` is the structural analog of `endojs/endo-but-for-bots` and source-side cross-link comments there are acceptable to post directly; the project README's "Routine work, when it begins, happens on a `kriscendobot` fork" line is the standing authorization for that.
