---
ts: 2026-06-15T06:06:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--238bac
prs:
  - repo: endojs/endo-but-for-bots
    pr: 404
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/404
  - https://github.com/endojs/endo-but-for-bots/pull/404#pullrequestreview-(kriskowal 2026-06-15T06:04:03Z APPROVED)
---

# dispatch: fixer — apply design edit + retcon on PR #404 per kriskowal

Maintainer review on PR #404 (kriskowal, 2026-06-15T06:04:03Z, APPROVED):

> Approved with recommendation to move the plus button toward the top of the inventory. Please rebase, retcon, and conduct onto the llm branch.

PR #404 is a design doc PR (designs/chat-inventory-create-menu.md). Need:

1. Edit the design doc to position the + button toward the top of the inventory (currently at the bottom; move it to top per maintainer recommendation).
2. Retcon the branch (history-clean, net diff preserved).
3. After this dispatch returns, the orchestrator will dispatch a conductor to rebase onto live `llm` and merge.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#404`, DRAFT, base `llm-11a76ae` (frozen), head `531ddd648`.
- **Title**: design(chat): inventory + create menu and new-agent wizard

## Task

In your `project/` worktree at `531ddd648`:

1. Read `designs/chat-inventory-create-menu.md`.
2. Find the description of the `+` button position in the inventory. The current text places it at the bottom; update to top per maintainer recommendation. Cite the change in context (the design doc may also have a mermaid diagram or ASCII art mock-up that needs the same edit).
3. Verify any cross-references in the same doc (or sibling docs) for consistency.
4. Read `garden/skills/retcon/SKILL.md`.
5. **First commit** the design doc edit on top of the current tip: `design(chat): move + button to top of inventory per kriskowal review`.
6. **Then retcon** the entire branch per the skill: reset --mixed to `llm-11a76ae`, restage per logical group (single design doc + lock if any), commit; net diff invariant including the new top-position edit.
7. Verify net diff (`git diff llm-11a76ae..HEAD` should equal the pre-retcon diff plus the position-edit delta).
8. Force-push with lease: `git push --force-with-lease origin design/chat-inventory-create-menu`.
9. Post a brief top-level comment on PR #404 at-mentioning @kriskowal with new SHAs and the edit summary.

## Authorizations

- Force-push with lease.
- Top-level comment.
- Do NOT mark PR ready/un-ready (it's already not-draft per the APPROVED state).
- Do NOT re-request review.
- Do NOT dispatch conductor yourself (that's the orchestrator's follow-up).

## Out of scope

- Do NOT touch packages outside designs/.
- Do NOT rebase onto live `llm` (that's the conductor's job).

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- Pre/post head SHAs.
- Edit summary (file + line).
- Per-commit summary (retcon).
- Net diff verification.
- PR #404 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: conductor` to rebase onto live `llm` and merge.

End your turn with a concise summary back to the orchestrator.
