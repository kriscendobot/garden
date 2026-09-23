---
ts: 2026-06-15T06:00:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--444d94
prs:
  - repo: endojs/endo-but-for-bots
    pr: 401
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/401
  - https://github.com/endojs/endo-but-for-bots/pull/401#issuecomment-4704997234
---

# dispatch: fixer — retcon PR #401 per kriskowal

Maintainer directive (kriskowal on PR #401, 2026-06-15T05:59:26Z):

> @kriscendobot Please retcon.

PR #401 is the chore/shellcheck-ci branch. Recent peer-fixer work (725c2a)
landed the lint:sh rename + yarn lint integration + git-blob pipeline removal
per turadg + gibson042 feedback. The maintainer asks for a retcon to clean up
the commit history.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#401`, DRAFT, base `master-4a04d07`, head `bde80b9f1`.
- **Title**: chore(shellcheck): add yarn shellcheck script and CI workflow

## Task per `garden/skills/retcon/SKILL.md`

In your `project/` worktree at `bde80b9f1`:

1. Read `garden/skills/retcon/SKILL.md` in full.
2. Reset the branch's commits per the retcon recipe:
   - Reset to base (`master-4a04d07`) with `--mixed`.
   - Restage per-package (or per-file group as the project's conventions demand).
   - Implementation + tests commit together (one cohesive commit per logical change).
   - `chore: Update yarn.lock` as a separate commit if yarn.lock was touched.
3. Verify net diff is invariant (same set of files modified, same content).
4. Force-push with lease: `git push --force-with-lease origin chore/shellcheck-ci`.
5. Post a brief top-level comment on PR #401 at-mentioning @kriskowal with:
   - New commit SHAs.
   - Net-diff-invariant confirmation.
   - Note that the retcon preserves the rename to lint:sh + yarn lint integration + git-blob pipeline removal.

## Authorizations

- Force-push with lease to `chore/shellcheck-ci`.
- Top-level comment on PR #401 @-mentioning @kriskowal.
- Do NOT mark PR ready/un-ready.
- Do NOT re-request review.

## Out of scope

- Do NOT change the net diff (retcon is history-only).
- Do NOT pursue the upstream endojs/endo#3300 (separate boatman concern).

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- Pre/post head SHAs.
- Per-commit summary (new commits).
- Net-diff verification (cite the comparison).
- PR #401 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: liaison` or whatever the maintainer's follow-up implies.

End your turn with a concise summary back to the orchestrator.
