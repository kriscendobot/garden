---
ts: 2026-05-29T05:09:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--99363b
prs:
  - repo: endojs/endo-but-for-bots
    pr: 375
    role: source
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/375#issuecomment-4570809104
  - https://github.com/endojs/endo-but-for-bots/pull/375#issuecomment-4570839576
---

# dispatch: builder — reconstruct XS-only subset of #375 onto master frozen-base

Maintainer directive on PR #375 (0xpatrickbot-authored
`fix(daemon): EndoMount data-safety and XS-powers fixes (#339 follow-up)`):
*"Please reconstruct, based on master, focusing on addressing the XS
issue. Note that it failed in CI and will require a shepherd."*
(comment URL: https://github.com/endojs/endo-but-for-bots/pull/375#issuecomment-4570809104)

Maintainer re-confirmed via terminal session at 2026-05-29T05:06:30Z
to the steward to act on this comment. Steward posted an
acknowledgment at https://github.com/endojs/endo-but-for-bots/pull/375#issuecomment-4570839576
committing to (a) reconstruct the XS-only subset onto a fresh
`master-<sha>` frozen base, (b) open a new bot-authored PR, (c) link
back from this thread, (d) shepherd CI.

This dispatch executes (a) and (b). The shepherd dispatch (d)
follows when the new PR is open.

## Current state

- PR #375 is on `endojs/endo-but-for-bots`, head `pc-endomount-fs-fixes`,
  base `llm`, MERGEABLE, +455/-19 across 9 files. The 9 files split
  into (i) XS-powers fixes (`rust/endo/xsnap/src/{host_aliases.js,
  powers/fs.rs}`, `packages/daemon/src/{bus-daemon-rust-xs-powers.js,
  bus-xs-host-globals.d.ts}`) and (ii) EndoMount data-safety fixes
  (`packages/daemon/src/{mount.js,types.d.ts}`, `packages/daemon/test/
  {mount-platform-fs-conformance.test.js,mount.test.js}`,
  `.changeset/daemon-endomount-fs-fixes.md`). The maintainer wants
  only (i) reconstructed.
- Bot/master is at `c49fb048b39e633363ea6e7dd6d8a7f788fec04f` (synced
  this morning by the cycle-5 weaver dispatch).
- Frozen base `master-c49fb04` already exists at that SHA from the
  weaver dispatch.
- Project worktree is checked out on `master-c49fb04` (detached HEAD
  at `c49fb048b`).

## Task

1. Inspect PR #375's diff for the XS-only subset:
   - `rust/endo/xsnap/src/host_aliases.js`
   - `rust/endo/xsnap/src/powers/fs.rs`
   - `packages/daemon/src/bus-daemon-rust-xs-powers.js`
   - `packages/daemon/src/bus-xs-host-globals.d.ts`
   plus any tests or supporting files dedicated to those XS-powers
   fixes. The `.changeset/` entry needs a fresh changeset that names
   only the XS scope (use a new filename — don't reuse the original
   `daemon-endomount-fs-fixes.md` which conflates the two scopes).

2. Read the original PR's body (https://github.com/endojs/endo-but-for-bots/pull/375)
   and the failing CI logs to understand what specifically the "XS
   issue" the maintainer named is. The maintainer mentioned the CI
   failure as the immediate motivation; the reconstruction should
   address whatever CI symptom drove the maintainer's note.

3. Create a new head branch `fix-daemon-xs-powers-375` (or similar
   descriptive slug) from `master-c49fb04`.

4. Apply ONLY the XS-subset changes. Use `git cherry-pick --no-commit`
   from #375's commits where possible, or hand-extract via
   `git show <sha> -- <xs-paths> | git apply`. The non-XS files
   (`mount.js`, `types.d.ts`, the mount tests, the EndoMount changeset)
   are explicitly out of scope.

5. Build the PR body in the project's standard shape (see
   `garden/skills/pr-formation/SKILL.md` for the four-part body
   convention). Cross-reference the original PR (#375) and the
   underlying issue (#339, the original feature the fix follows up on).

6. Open the PR as DRAFT against base `master-c49fb04` (per the
   frozen-base convention). The PR-creation-flow chain (cleaner →
   judge → fixer-loop → un-draft) is the contractor/steward's job
   post-open; you focus on opening cleanly.

7. Once open, comment on PR #375 referencing the new PR URL so the
   maintainer can see the link. Reply to the maintainer's
   `issuecomment-4570809104` (or just post a top-level comment) with
   the new PR URL.

## Per-action authorizations (forwarded)

- Push the new head branch to `endojs/endo-but-for-bots` under
  kriscendobot identity. Authorized.
- `gh pr create` on `endojs/endo-but-for-bots`. Authorized.
- Posting a comment on PR #375 referencing the new PR. Authorized.

## Not authorized

- Modifying or closing PR #375 (the original 0xpatrickbot PR — leave
  it as-is; the maintainer may close it separately).
- Pushing to upstream `endojs/endo` (this stays on the bot fork).
- Force-pushing to master (you don't need to; master is current).
- Shepherd dispatch (the steward dispatches that separately after
  you return).

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/builder--99363b/garden/roles/COMMON.md`
2. `/home/kris/dispatches/builder--99363b/garden/roles/builder/AGENT.md`
3. `/home/kris/dispatches/builder--99363b/garden/skills/pr-formation/SKILL.md`
   and `garden/skills/frozen-base-branch/SKILL.md` as needed.
4. Other skills the builder role names just-in-time.

Project worktree starts at `project/` on the `master-c49fb04`
branch (detached HEAD at `c49fb048b`).

## Report

A `result` journal entry. Include: new PR number and URL, head SHA,
list of files in the diff, the original commits cherry-picked from
#375 (or "hand-extracted" if applied directly), the comment ID
posted on #375 with the new PR link, and any non-trivial decisions
made about what to include in the XS subset.
