---
ts: 2026-05-29T05:42:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--bc7a55
refs:
  - https://github.com/endojs/endo/pull/3291
  - entries/2026/05/29/035200Z-result-steward-e2f3a4.md
  - entries/2026/05/29/051600Z-result-steward-c6d7e8.md
---

# dispatch: fixer — mirror endojs/endo#3291 esvu-retry fix onto bot fork

Maintainer directive in steward's terminal session at 2026-05-29T05:36Z:
*"Please note the CI failure on https://github.com/endojs/endo/pull/3291
and dispatch a fixer to our mirror of that change."*

## Context

PR #3291 on endojs/endo is `fix(benchmark): retry esvu installs in
install-engines.sh` by kriskowal (OPEN, MERGEABLE). It addresses the
operational flake the steward observed twice today already: PR #79
test-xs failed with `V8 ❯ ... esvu ✖ Some engines were not installed`
(see `entries/2026/05/29/035200Z-result-steward-e2f3a4.md`), and PR
#375 test-xs has the same shape with the XS engine download (see
`entries/2026/05/29/051600Z-result-steward-c6d7e8.md`).

#3291's CI is itself failing on test-xs with the same signature
(meta-irony: the very fix can't ride its own retry through because
the runner couldn't download esvu's binary at all). The diff is a
single-file shell-script change to
`packages/benchmark/install-engines.sh` wrapping each `yarn dlx esvu
install <engine>` call in a 3-attempt retry with 5s backoff.

There is **no existing bot-side mirror** PR for this change (the
steward searched the open and recently-closed PR list). The task is
to create one.

## Task

Mirror the one-commit patch from #3291 onto the bot fork as a new
small bot-authored PR:

1. **Fetch the patch** from upstream:
   `git fetch endo-upstream 44b80546d` (or
   `gh pr diff 3291 -R endojs/endo --patch > /tmp/3291.patch`).
2. **Create a new branch** `fix-benchmark-install-engines-retry` (or
   similar) off `master-c49fb04` (the project worktree's current
   branch).
3. **Apply the patch** to `packages/benchmark/install-engines.sh`.
   The file exists on bot master and the patch should apply cleanly.
4. **Compose a single atomic commit** matching the upstream message
   header: `fix(benchmark): retry esvu installs in install-engines.sh`.
   Body cites this is a mirror of endojs/endo#3291 by kriskowal.
5. **Add a changeset** under `.changeset/` per the project's
   convention. Single-line description; `@endo/benchmark` patch
   bump scope.
6. **Push** the branch and **open the PR as DRAFT** against base
   `master-c49fb04`. Title and body shape per
   `garden/skills/pr-formation/SKILL.md`. PR body should:
   - Cite #3291 as the source ("Mirror of endojs/endo#3291").
   - Mention the two on-fork CI failures this addresses (#79
     test-xs V8, #375 test-xs XS).
   - Note that upstream #3291 itself is awaiting its own CI to
     clear (the irony is worth noting in passing).
7. **No comment** on #3291 (that's upstream; the boatman would
   handle cross-link, but this dispatch isn't a boatman dispatch).
   A future cycle's cross-link backfill or boatman dispatch picks
   that up.

## Why fixer not builder

The maintainer named "fixer" in the directive. The change shape is
fixer-scope (single-file surgical patch, no design, no test
authoring). The fixer also fits the operational-flake mitigation
framing per `roles/steward/AGENT.md` § Operational-flake handling
step 3 (a resilience PR via builder OR fixer depending on scope).
Single-file shell-script edit lands cleanest as a fixer.

## Per-action authorizations (forwarded)

- Push the new head branch to `endojs/endo-but-for-bots` under the
  bot identity. Authorized.
- `gh pr create` on `endojs/endo-but-for-bots`. Authorized.
- Posting any explanatory comment on the new PR (post-CI summary,
  etc.). Authorized.

## Not authorized

- Modifying or commenting on upstream #3291.
- Force-pushing to bot master.
- Un-drafting (the cleaner/judge/un-draft chain follows; not your
  call).

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--bc7a55/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--bc7a55/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-formation/SKILL.md`
4. `garden/skills/frozen-base-branch/SKILL.md` (consult on the
   `master-c49fb04` base shape).
5. Other skills the fixer role names just-in-time.

Project worktree starts at `project/` on `master-c49fb04` (detached
HEAD at `c49fb048b`).

## Report

A `result` journal entry. Include: new PR number and URL, head SHA,
the upstream commit SHA cherry-picked or hand-applied, and a note on
whether the patch applied cleanly.
