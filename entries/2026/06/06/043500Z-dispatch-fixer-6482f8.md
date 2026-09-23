---
ts: 2026-06-06T04:35:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--6482f8
prs:
  - repo: endojs/endo-but-for-bots
    pr: 351
    role: target
  - repo: endojs/endo
    pr: 2422
    role: source
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/351
  - https://github.com/endojs/endo/pull/2422
---

# dispatch: fixer — rebase and retcon endo-but-for-bots#351 against upstream endo#2422

User directive (2026-06-06, this terminal session): *"Please take the
changes at https://github.com/endojs/endo/pull/2422 and rebase and
retcon on our mirror https://github.com/endojs/endo-but-for-bots/pull/351"*.

Per the maintainer's standing rule on `endo-but-for-bots` PRs (memory
2026-05-22T20:01Z): *"please rebase" is the compound: sync bot-master
to current endo-upstream/master, then rebase, then conflict-resolve,
then retcon-if-needed*. The user's "rebase and retcon" naming is the
explicit-retcon variant of that same compound.

## State at dispatch time

- **Mirror PR** `endojs/endo-but-for-bots#351`
  ("feat(compartment-mapper): Host module exits (mirror of
  endojs/endo#2422)"), branch `mirror/2422-host-module-exits`,
  head `eadb6c7`, base `master` at `ba26f4c`. 14 commits.
  reviewDecision CHANGES_REQUESTED. mergeStateStatus UNSTABLE,
  mergeable MERGEABLE. Last updated 2026-06-03T04:56:40Z.
- **Upstream PR** `endojs/endo#2422`
  ("feat(compartment-mapper): Host module exits"), branch
  `kriskowal-ponyfill-host-module`, head `a509e0e`, base `master` at
  `5865ff1`. 14 commits with the same headlines as the mirror's, in
  the same order (the mirror is content-equivalent to upstream).
  reviewDecision APPROVED. Last updated 2026-06-06T04:30:23Z (about
  an hour before this dispatch).
- **Bot master** at `07aff33` (the same SHA the frozen-base `master-07aff33`
  on PR #411 captured); **upstream master** at `5865ff1`. The two
  diverge.

## Task

Apply the four-step compound in order, in your `project/` worktree:

1. **Sync bot master to upstream master.** Add the upstream remote if
   absent (`git remote add upstream https://github.com/endojs/endo.git`),
   `git fetch upstream master`, and force-push upstream's master tip
   to `origin/master` on the bot fork using
   `git push --force-with-lease=master:07aff334e6e87235807c373c668acb696af1708e origin upstream/master:master`.
   The lease SHA `07aff334` is the current bot master and is the
   anchor. Refuse and surface to liaison if the lease fails (means
   bot master moved during your dispatch). This step is the
   memory-anchored sync rule applied to this dispatch.

2. **Rebase the mirror branch onto the new bot master.** With
   `mirror/2422-host-module-exits` checked out, `git fetch origin` and
   `git rebase origin/master`. Resolve any conflicts (the mirror's
   content matches upstream's PR per commit-list comparison, so
   conflicts should be minimal but not impossible). The PR's
   `(#351)` merge-suffixes on commits `c884ca1` and `dbc53b0` are
   bot-side artifacts and will be discarded by step 3 anyway.

3. **Retcon per [`skills/retcon/SKILL.md`](../../skills/retcon/SKILL.md).**
   Reset the branch back to the (synced) bot master and restage as a
   sensibly grouped per-package history:

   - **One commit per affected package.** From the upstream commit
     titles, the affected packages are `packages/ses/`
     (`feat(ses): StrictModuleDescriptor type`),
     `packages/compartment-mapper/` (every other feat / fix / test /
     docs / style commit), plus the top-level changeset directory.
     Group: `feat(ses): ...`, `feat(compartment-mapper): ...`
     (combining implementation + tests + docs + style commits into
     one), and a `docs(changeset): ...` commit for the `.changeset/`
     entry. Implementation+tests bundled per the skill.
   - **Separate `chore: Update yarn.lock`** if the lockfile changed
     across the net diff.
   - **Net diff invariant.** Tag the pre-retcon HEAD per the skill's
     *Save a pre-retcon reference* step; verify
     `git diff <pre-retcon-tag>..HEAD` is empty before force-pushing.

4. **Force-push the retconned history.** `git push --force-with-lease
   origin HEAD:mirror/2422-host-module-exits`. The lease is the
   pre-retcon mirror tip `eadb6c7`; refuse if a sister session pushed
   since.

## Authorizations (per-action, forwarded by steward)

- **Force-push to bot `endojs/endo-but-for-bots/master`** with the
  lease anchor `07aff334` (memory-anchored bot-master sync rule;
  user directive is the authority).
- **Force-with-lease push to** `mirror/2422-host-module-exits` after
  the retcon. Implicit in the "retcon #N" dispatch verb.
- **Top-level summary comment** on `endojs/endo-but-for-bots#351`
  after the push lands, naming each per-package commit's resulting
  SHA and noting the four-step compound was run. The
  `endo-but-for-bots` standing authorization (broad-comment, per
  bulletin) covers this without further per-action grant.
- **Re-request review** after CI converges (if applicable per the
  fixer's normal post-fix flow). The mirror PR carries
  CHANGES_REQUESTED; if the retcon's net-diff-invariant property
  means the prior review-comments still apply unchanged, you may
  defer re-request to the next maintainer touch. Use judgment.

## Notes and pitfalls

- The mirror's two `(#351)`-suffixed commits indicate a prior squash
  or rebase merged something specific to the mirror; the retcon
  discards them automatically because step 3 resets to base and
  restages by package.
- Pre-retcon tag: `git tag pre-retcon-6482f8` before step 3's reset,
  to support the no-net-change verification. Delete after the push
  lands.
- The mirror's substantive content should match upstream's net diff
  once you've reset to the synced bot master. If you find the net
  diff differs (anything beyond the bot-side `(#351)`-suffix
  artifacts), that is a real divergence the user needs to know about:
  stop, write a `message: fixer → liaison`, and do not force-push.
- The retcon's per-package commit grouping is the canonical PR-shape
  for the panel re-run; the existing CHANGES_REQUESTED review will
  re-run against the new shape. The panel is not in this dispatch's
  scope.

## Deliverable

A `result` entry under `journal/entries/2026/06/06/` naming:

- The pre-retcon and post-retcon mirror HEAD SHAs.
- The bot-master before/after SHAs.
- The per-package commit SHAs in the retconned history.
- The net-diff-invariant verification result.
- The summary-comment URL (if posted) and any re-request-review URL.
- A `Self-improvement: ...` line per the standing skill.
