---
ts: 2026-06-09T02:45:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--4172f7
prs:
  - repo: endojs/endo-but-for-bots
    pr: 131
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/131
  - https://github.com/endojs/endo-but-for-bots/pull/131#issuecomment-4655481103
---

# dispatch: fixer — retcon PR #131 per kriskowal directive (conductor merge follows)

Maintainer comment on `endojs/endo-but-for-bots#131` at
2026-06-09T02:43:56Z (kriskowal):

> Please retcon and merge.

Two-stage chain: this dispatch does the **retcon**; a follow-on
**conductor** dispatch does the **merge** once the retcon push
lands.

## State at dispatch time

- **PR #131**, source-touching, non-draft, base `llm-11a76ae`
  (frozen base), head `feat/chat-inventory-dnd` at full SHA
  `261b6375ee3225f2379155eeb16bfd34a8ff8add`.
- **CI**: 21/0/0 SUCCESS/FAILURE (green; the shepherd's
  lint-dangle fix + check-action-pins re-run landed cleanly).
- **reviewDecision**: CHANGES_REQUESTED (carries from
  kriskowal's prior review; the maintainer's "merge" directive
  overrides the stale review state).

## Task

Per [`skills/retcon/SKILL.md`](../../skills/retcon/SKILL.md):

1. **Save pre-retcon reference**:
   `git tag pre-retcon-4172f7 HEAD` for the no-net-change
   verification.
2. **Identify the base**: PR base is `llm-11a76ae`.
3. **Reset to base** with `--mixed`:
   `git reset --mixed origin/llm-11a76ae` (keeps the working
   tree, unstages everything).
4. **Restage by package**, separate `chore: Update yarn.lock`
   commit:
   - The PR touches `packages/chat/` (the main implementation).
     Stage `packages/chat/` and commit as
     `feat(chat): inventory drag-and-drop, cancel, and type
     badges`.
   - Any other packages touched (per the cleaner's pass; verify
     by `git diff origin/llm-11a76ae..pre-retcon-4172f7
     --name-only`) get one commit each.
   - `yarn.lock` (if touched) is a separate `chore: Update
     yarn.lock` commit.
   - Tests + implementation **bundled in the same commit** per
     the retcon skill's discipline.
5. **Verify no net change**:
   `git diff pre-retcon-4172f7..HEAD` must be empty.
6. **Force-with-lease push** the retconned history:
   `git push --force-with-lease=feat/chat-inventory-dnd:261b6375ee3225f2379155eeb16bfd34a8ff8add origin HEAD:feat/chat-inventory-dnd`.
7. **Delete the local pre-retcon tag** (just hygiene; not
   pushed):
   `git tag -d pre-retcon-4172f7`.
8. **Reply on PR #131** with the retcon outcome (commit count
   before vs after, per-package commit SHAs, net-diff-invariant
   confirmation).

## Authorizations (per-action, forwarded by steward)

- **Force-with-lease push** to `feat/chat-inventory-dnd` (lease
  anchor `261b6375ee3225f2379155eeb16bfd34a8ff8add`).
- **Reply comment** on PR #131 (`endo-but-for-bots` standing
  broad-comment authorization).

## Out of scope

- Do NOT add or remove substance; the retcon's net diff must be
  invariant.
- Do NOT touch other PRs.
- Do NOT merge the PR; the conductor handles that next (the
  steward dispatches the conductor on this dispatch's return).
- Do NOT trigger panel/judge.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` per the
retcon-skill deliverable: pre/post head SHAs, per-package
commit SHAs, the no-net-change verification result, the
reply-comment URL, `Self-improvement: ...`.

End your turn with a concise summary back to the orchestrator.
The orchestrator tears down your dispatch root on return and
dispatches the conductor.
