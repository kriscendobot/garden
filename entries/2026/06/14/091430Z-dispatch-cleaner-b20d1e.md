---
ts: 2026-06-14T09:14:30Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: cleaner
dispatch_root: /home/kris/dispatches/cleaner--b20d1e
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/14/091200Z-result-builder-7cfbcc.md
---

# dispatch: cleaner — PR #440 expanded-scope re-gamut after cut 3 landed

Builder `7cfbcc` landed cut 3 (chat surface) on PR #440 — 4 commits over the post-weaver tip `f01499f1a`. The prior cleaner pass (`5c4828` per memory; actually the pre-rebase cleaner pre-weaver) reviewed only cuts 1+2. This dispatch is the cleaner re-gamut on the expanded scope (cuts 1+2+3 = all chat-side surface + daemon getFormula + CLI `endo inspect`).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#440`, DRAFT, base `llm`, head `ab50308a3`.
- **Cut 3 commits**: `e894ffc09`, `3e5f44604`, `b446f5cc3`, `ab50308a3`.
- **New chat-side files**: `packages/chat/formula-view-registry.js`, `packages/chat/formula-view-component.js`, plus extensive `value-component.js`, `inventory-component.js`, `chat.js`, `index.css` edits; 35 new unit + component tests; 6 Playwright e2e stubs.

## Task

In your `project/` worktree at `ab50308a3`:

1. Read `garden/skills/pre-pr-checklist/SKILL.md` and `garden/skills/pr-formation/SKILL.md`.
2. Run `pre-push-gates`. Builder reported the only probe failures were in pre-existing files outside the dispatch diff; verify.
3. Audit PR body for cut 3 description (the PR body may need an update for the chat surface now that all three cuts are present).
4. Audit cut 3 diff per hygiene skills (changeset, em-dash, no-latin-shorthand, relative-paths, test-title-spec-spelling).
5. Push hygiene fixes per category.
6. Post top-level summary comment ending with "Next stage: barrister panel."

## Authorizations

- Push commits to `feat/formula-inspector` (append only).
- Edit PR body via `gh pr edit` if cut 3 description is missing.
- Top-level summary comment.

## Out of scope

- Do NOT touch cut 3 substance (the chat surface design departures noted by the builder are intentional).
- Do NOT touch daemon-cas extraction (separate PR #442).
- Do NOT rebase or force-push.

## Deliverable

A `result` entry per the standard cleaner deliverable shape.

End your turn with a concise summary back to the orchestrator.
