---
ts: 2026-06-11T00:58:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--ff4651
prs:
  - repo: endojs/endo-but-for-bots
    pr: 401
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/401
  - https://github.com/endojs/endo-but-for-bots/pull/401#issuecomment-4676193609
---

# dispatch: fixer — fold shellcheck step into lint job on PR #401 per kriskowal directive

Maintainer directive on PR #401 (kriskowal at 2026-06-11T00:56:36Z,
issue comment `4676193609`):

> @kriscendobot Please integrate the shellcheck step into the
> lint job instead of a fresh job.

The 👀 reactji is on the directive comment
(`reactions/368458507`).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#401`
  ("chore(shellcheck): add yarn shellcheck script and CI
  workflow"), DRAFT, base `master-4a04d07`, head
  `chore/shellcheck-ci` at `85ebc883a52226665b40bce0b418967145ea8170`
  (`85ebc883a`).

## Task

In your `project/` worktree on `chore/shellcheck-ci` at
`85ebc883a`:

1. **Inspect the current workflow file** at
   `.github/workflows/shellcheck.yml` (the dedicated workflow
   the PR added). Confirm its shape: triggers, paths filter,
   action pins, the actual shellcheck invocation
   (`yarn shellcheck` or `scripts/shellcheck.sh`).
2. **Inspect the existing lint workflow/job** at
   `.github/workflows/ci.yml` (or wherever the `lint` job
   lives — find it via
   `grep -lr 'lint' .github/workflows/`). Identify the right
   place to add a shellcheck step.
3. **Integrate**:
   - Add a `Run shellcheck` step to the existing `lint` job.
     Use the same invocation the standalone workflow used
     (`yarn shellcheck` or equivalent).
   - The standalone workflow's `paths:` filter was on
     `**/*.sh`. The lint job runs unconditionally per CI
     convention; the new step should either run
     unconditionally (preserving the gate-on-master behavior)
     or check for the presence of `.sh` files via a small
     `if:` conditional. Mirror the existing workflow's
     conditional pattern if there is one.
   - **Delete** the standalone `.github/workflows/shellcheck.yml`.
4. **Verify the fold preserves the gate**: shellcheck should
   still run on every PR that touches `.sh` files (or on
   every PR if lint runs unconditionally — which is the
   project's existing pattern).
5. **Run pre-push-gates** in `project/` and confirm clean.
6. **Commit** with conventional commit message:
   `chore(shellcheck): fold into lint job per kriskowal
   directive`. Single commit (delete + add).
7. **Push** to `chore/shellcheck-ci` (append push only).
8. **Reply on kriskowal's directive comment**
   (`4676193609`) at-mentioning kriskowal, naming the
   addressing commit SHA and the integration shape (which
   `lint` job, what conditional if any, that the standalone
   workflow file was deleted).
9. **Re-request review** from kriskowal once the reply is
   posted.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to `chore/shellcheck-ci` (append push only;
  do NOT amend prior commits; do NOT force-push).
- **Reply on the directive comment** on PR #401. Standing
  `endo-but-for-bots` broad-comment authorization.
- **Re-request review** from kriskowal.

## Out of scope

- Do NOT rebase or force-push.
- Do NOT amend prior commits.
- Do NOT touch other workflow files beyond the shellcheck
  fold + the lint integration.
- Do NOT un-draft the PR; the maintainer un-drafts when
  ready.

## Deliverable

A `result` entry under `journal/entries/2026/06/11/` naming:

- Pre/post branch tip SHAs.
- The integration commit SHA.
- The lint job name + workflow file that gained the
  shellcheck step.
- The conditional shape (unconditional vs `if:` on `.sh`
  touched).
- Confirmation the standalone shellcheck workflow file was
  deleted.
- pre-push-gates result.
- The reply URL.
- The re-request-review URL/status.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
