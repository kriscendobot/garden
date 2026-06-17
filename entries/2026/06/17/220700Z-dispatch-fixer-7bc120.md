---
ts: 2026-06-17T22:07:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--7bc120
prs:
  - repo: endojs/endo-but-for-bots
    pr: 442
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/442
  - https://github.com/endojs/endo-but-for-bots/pull/442#pullrequestreview-4519931203
---

# dispatch: fixer — rebase + retcon + scope-narrow PR #442 per kriskowal

Maintainer kriskowal review on PR #442 (2026-06-17T22:05Z, CHANGES_REQUESTED):

> Rebase on latest LLM, retcon, and remove the unrelated work on registry, which should appear in a separate PR already.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#442` (daemon-cas extraction), DRAFT, base `llm-c85d618` (frozen), head `42f3a179e`.
- **llm** is now at `f9ff85c5` (just merged with master via weaver df5692).
- **Sibling PR** `#403` is the registry-capability work — that's where registry work belongs.

## Task per `garden/skills/retcon/SKILL.md`

In your `project/` worktree at `42f3a179e`:

1. Read `garden/skills/retcon/SKILL.md` + the recent commit history on this branch (`git log llm-c85d618..HEAD`).
2. Identify which commits are daemon-cas vs registry-capability work.
3. **Drop the registry-capability commits** (they belong on PR #403).
4. **Rebase** the remaining daemon-cas commits onto live `llm` (`f9ff85c5`).
5. **Retcon**: reset --mixed to base, restage per-package, separate `chore: Update yarn.lock`, implementation+tests combined.
6. Run `corepack yarn workspace @endo/daemon-cas test` + daemon mount tests + lint.
7. Run pre-push-gates.
8. Force-push with lease: `git push --force-with-lease origin feat/daemon-cas-extraction`.
9. Update PR body via `gh pr edit 442 --body ...` to reflect the narrowed scope (daemon-cas only).
10. Update PR base via `gh pr edit 442 --base llm` (live trunk, not frozen).
11. Post a top-level comment on PR #442 at-mentioning @kriskowal:
    - Pre/post head SHAs.
    - Per-commit retcon mapping.
    - Note registry-capability commits dropped (belong on PR #403).
    - Net-diff invariant within daemon-cas scope.

## Authorizations

- Force-push with lease.
- `gh pr edit` base + body.
- Top-level comment.
- Do NOT touch upstream endojs/endo.
- Do NOT un-draft.

## Out of scope

- Do NOT touch PR #403 (separate work).
- Do NOT pursue Class A items from prior gamuts.

## Deliverable

A `result` entry under `journal/entries/2026/06/17/` naming:

- Pre/post head SHAs.
- Rebase outcome (conflicts, resolution).
- Per-commit retcon mapping.
- Registry commits dropped (list).
- Test results.
- pre-push-gates result.
- PR #442 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: liaison` (maintainer re-reviews).

End your turn with a concise summary back to the orchestrator.
