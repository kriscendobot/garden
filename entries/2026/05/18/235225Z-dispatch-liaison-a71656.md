---
ts: 2026-05-18T23:52:25Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/18/234439Z-result-liaison-8c1a6e.md
prs:
  - repo: endojs/endo
    pr: 3268
    role: target
---

Squash dispatch on `endojs/endo#3268` (the stacked-on-#3084 Node 20 drop I opened ~20 min ago). User asked to squash the two commits into one.

This is a force-push under kriskowal credentials, gated by `identity_switch_authorized: true`, so it routes through a boatman dispatch rather than a direct liaison-side operation. Small focused engagement.

## Current state

- Repo: `endojs/endo`, PR #3268.
- Branch: `kriskowal-drop-node-20`
- Base: `ta/node-matrix` (= `endojs/endo#3084`, Turadg's branch)
- Current head: `5153162b719799aa4a939e6b85d8389304edcbc3`. Two commits:
  - `46687badc` `chore(ci): drop Node.js 20 from the test matrix` — author Kris Kowal. Body cites `endojs/endo-but-for-bots#260` (fork-only ref the boatman's prior cleanup pass missed).
  - `5153162b7` `ci: preserve Node 20 SES-viable patch history` — author Kris Kowal. Body references "Per kriskowal's CHANGES_REQUESTED review on #280" (another fork-only ref).

PR state: OPEN, non-draft, no reviews yet, CI presumably in flight or settled.

## Task

Squash the two commits into one. Compose the squashed commit's subject and body per `pr-formation` and the standing trailer-strip discipline:

- **Subject**: `chore(ci): drop Node.js 20 from the test matrix` (matches the PR title; the SES-viable-patch-history preservation is a sub-aspect, not a separate logical change worth a second commit).
- **Body**: combine the two existing bodies into a coherent single body. Specifically:
  - Keep the substantive content from commit 1 (Node 20 maintenance/winding-down framing, standalone-job advances to 22.x, test-async-hooks lane advancement).
  - Keep the substantive content from commit 2 (the SES-viable-patch-history restored block with its four bullets about Node 20.3–20.9 patch viability).
  - **Drop fork-only references**:
    - `endojs/endo-but-for-bots#260` — translate to a behavior note like "the test-xs (macos-15) lane was filed as flaky on Node 20" without the issue number (matches the PR body's same translation).
    - `Per kriskowal's CHANGES_REQUESTED review on #280` — drop entirely; the review request is bot-side history and not upstream-visible.
  - Drop the "The 2ec645b45 commit ..." retrospective framing in commit 2's body; the squashed commit doesn't need to reference its own pre-squash structure.
- **Attribution**: author + committer `Kris Kowal <kris@cixar.com>` (unchanged).
- **Trailer-strip**: `git interpret-trailers --parse` per the standing discipline. Zero `Co-authored-by`, zero `Generated with Claude Code`, zero bot trailers.

## Procedure

1. In `project/` (already detached at `5153162b7`, the current head of `kriskowal-drop-node-20`):
   - Reset to the base `git reset --hard origin/ta/node-matrix` (= `010cc15fe`).
   - Cherry-pick the two-commit range and squash: `git cherry-pick --no-commit 46687badc 5153162b7` (squashes into the staged tree), or alternatively `git reset --soft 46687badc~` after the original tip and then `git commit` with the composed message.
   - Set local `user.name='Kris Kowal'` / `user.email='kris@cixar.com'`.
   - `git commit -m '<subject>' -m '<body>'` with the composed subject/body.

2. Verify: `git log origin/ta/node-matrix..HEAD --pretty=fuller` shows one commit, author + committer `Kris Kowal <kris@cixar.com>`. `git interpret-trailers --parse` empty.

3. Force-push: `git push origin HEAD:kriskowal-drop-node-20 --force-with-lease=kriskowal-drop-node-20:5153162b7`. The lease ensures no concurrent pusher gets clobbered.

4. Verify the PR's new head SHA via `gh pr view 3268 -R endojs/endo --json headRefOid`.

5. **Title and body untouched.** User asked to squash; no PR-attribute changes.

6. **Source-side cross-link**: optionally post a follow-up comment on `endojs/endo-but-for-bots#280` naming the new single-commit SHA. The earlier #280 cross-link comment already exists; you may post a brief follow-up if you judge it useful, or skip.

7. **Identity discipline**: no direct comments on `endojs/endo#3268`. Steward-routed comment unlikely to be useful for a squash.

8. **Journal `result` entry** in `journal/entries/2026/05/18/<HHMMSS>Z-result-boatman-<short-id>.md`. Reference dispatch `entries/2026/05/18/235225Z-dispatch-liaison-a71656.md` in `refs:`. Include the new head SHA, the squashed commit's subject, attribution verified, force-push confirmed (with lease against the prior `5153162b7`), one-line `Self-improvement: ...`.

## Out of scope

- Title or body edits on #3268.
- Comments on the upstream PR.
- Any other change to the diff (the squashed commit's tree must be identical to the pre-squash tree).

## Expected report

≤200 words:
- New head SHA after force-push.
- Single squashed commit's subject + author confirmed.
- Force-push confirmed (with `--force-with-lease` against the prior tip).
- One-line `Self-improvement: ...`.

If blocked (lease violation, tree-identity check fails, etc.), `message`-to-liaison and stop.
