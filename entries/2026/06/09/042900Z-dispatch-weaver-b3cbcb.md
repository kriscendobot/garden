---
ts: 2026-06-09T04:29:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: weaver
dispatch_root: /home/kris/dispatches/weaver--b3cbcb
prs:
  - repo: endojs/endo-but-for-bots
    pr: 401
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/401
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/09/042300Z-result-shepherd-344723.md
---

# dispatch: weaver — frozen-base rebase of PR #401 (shepherd `next: weaver` escalation)

Follow-on dispatch after shepherd `344723` escalated test-xs as
out-of-scope. Per shepherd's diagnosis: PR #401's frozen base
`master-814dfa1` predates upstream commit `ba26f4cdb`
(PR endojs/endo#3294 "install xs/v8 via direct download instead
of esvu"), which moved test-xs from `esvu` (now broken) to direct
binary downloads. The fix is to move the frozen base forward to
`master-4a04d07` (already pushed) and rebase the PR head onto it.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#401`
  ("chore(shellcheck): add yarn shellcheck script and CI workflow"),
  DRAFT, base `master-814dfa1` (frozen-base snapshot),
  head `chore/shellcheck-ci` at `8fcb24157` (post-shepherd-zizmor-fix).
  CI on `8fcb24157`: 17 SUCCESS, 1 FAILURE (test-xs, esvu-broken).
- **Target frozen base**: `master-4a04d07` (matching current
  `origin/master` tip `4a04d078b`). The branch is already pushed
  to the fork per shepherd's note.
- **No conflicts expected**: PR touches `scripts/*.sh`,
  `packages/{compartment-mapper,nat}/test/...`,
  `.github/workflows/{shellcheck,release}.yml`, `package.json`.
  esvu replacement is in `packages/benchmark/...` — disjoint.

## Task

Per `garden/skills/frozen-base-branch/SKILL.md` § Rebase: move
both base and head. In your `project/` worktree on
`chore/shellcheck-ci` at `8fcb24157`:

1. **Fetch** `origin master master-4a04d07 master-814dfa1
   chore/shellcheck-ci`.
2. **Verify** `master-4a04d07` exists on the fork and matches
   `origin/master`'s tip. If it does not exist, push it from the
   current `origin/master`.
3. **Rebase `chore/shellcheck-ci` onto `master-4a04d07`**:
   `git rebase --onto master-4a04d07 master-814dfa1
   chore/shellcheck-ci`. Resolve conflicts per
   `garden/skills/conflict-resolution/SKILL.md` if any arise
   (none expected per shepherd's diff analysis).
4. **Force-with-lease push** the rebased head:
   lease anchor `8fcb24157f...` (use the 40-char SHA, per the
   standing rule against short-form anchors).
5. **Retarget the PR base** via
   `gh pr edit 401 --repo endojs/endo-but-for-bots
   --base master-4a04d07`.
6. **Watch CI** briefly via
   `gh pr view 401 --json statusCheckRollup` to verify test-xs
   now passes (the esvu-replacement commit is now in the base
   tree). Do not wait for full convergence — the shepherd will
   pick up convergence-management. If first-look shows test-xs
   passing (or QUEUED to fresh state), that's the green-light
   confirmation.
7. **Post a brief reply** on PR #401 noting the rebase outcome:
   pre/post head SHAs, base bump (`master-814dfa1` → `master-4a04d07`),
   any conflicts resolved (none expected), and that test-xs
   should now pass since the esvu-replacement is in the new base.

## Authorizations (per-action, forwarded by steward)

- **Force-with-lease push** to `chore/shellcheck-ci` with lease
  anchor `8fcb24157` (full 40-char SHA). Implicit in the weaver
  dispatch.
- **Retarget PR base** via `gh pr edit --base`. Implicit.
- **Top-level reply** on PR #401. Standing
  `endo-but-for-bots` broad-comment authorization.

## Out of scope

- Do NOT amend any of PR #401's commits. Rebase is a re-application
  of the existing commit series onto a new base; no commits get
  rewritten beyond what `git rebase --onto` does mechanically.
- Do NOT touch source files. The base bump is the only structural
  change.
- Do NOT post a CI convergence summary; that's the next shepherd's
  job if CI still needs convergence work.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` naming:

- Pre/post branch tip SHAs (the rebase moves the head).
- Base bump: `master-814dfa1` → `master-4a04d07`.
- Conflict-resolution notes (one line per conflict if any; "none"
  if clean).
- The `gh pr edit --base` outcome.
- First-look CI state post-rebase (test-xs status, any new
  failures introduced).
- The reply comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: if test-xs passes cleanly,
  `next: none` (chain closes; PR back in kriskowal's queue with
  re-requested review still pending). If test-xs still fails,
  `next: shepherd` for a second convergence pass.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
