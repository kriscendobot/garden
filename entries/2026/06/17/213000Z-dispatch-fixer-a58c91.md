---
ts: 2026-06-17T21:30:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--a58c91
prs:
  - repo: endojs/endo-but-for-bots
    pr: 449
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/449
  - https://github.com/endojs/endo-but-for-bots/pull/449#pullrequestreview-4519751581
---

# dispatch: fixer — PR #449 design-doc loop round 1 (4 must-fix + 13 summary-fix)

Solicitor `365835` panel verdict on PR #449 design doc:
**must-fix-loop=4, summary-fix=13, follow-up=2, acknowledge=2, drop=0**.

## 4 must-fix-loop items (per solicitor's report)

1. **critic**: *Open question* § 1 about `internal-heir.js` is moot on post-#435 master — remove the open question or update it.
2. **skeptic**: pass-style admit-immutable-buffer premise needs verification or downgrade to explicit risk. Also see erights' inline comment on PR #449 (discussion `r3431570369`) about `packages/pass-style/src/byteArray.js` needing a frozen Uint8Array.
3. **skeptic**: per-flavor test matrix needs BigInt-distinct argument shapes for `with`/`fill`/`set`.
4. **novice**: Background scaffold needed before first `hiddenBuffers`/`reverseHiddenBuffers` mention.

The 13 summary-fix items + 2 follow-up + 2 acknowledge are listed in the full panel review body at the URL above.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#449`, DRAFT, base `master-4a04d07`, head `ce6108477`.

## Task

In your `project/` worktree at `ce6108477`:

1. Read the full panel review body via `gh api repos/endojs/endo-but-for-bots/pulls/449/reviews/4519751581 --jq '.body'`.
2. Read erights' new inline comment `r3431570369` about pass-style/byteArray.js.
3. Address ALL 4 must-fix-loop items + the 13 summary-fix items.
4. For each addressed item, note which file/section was edited.
5. Run pre-push-gates from project/.
6. Commit per logical group (probably one cohesive commit per must-fix item + one for the summary-fix bundle).
7. Push to `design/immutable-arraybuffer-freezable-typedarray-emulation` (append only).
8. Post a top-level comment on PR #449 at-mentioning @kriskowal @erights:
   - Per-item resolution table.
   - SHAs.
   - Note design-doc loop terminating.

## Authorizations

- Append-push.
- Top-level comment.
- Do NOT touch upstream endojs/endo.
- Do NOT un-draft (judge does that after re-run).

## Out of scope

- Do NOT change the design's substance arbitrarily.

## Deliverable

A `result` entry under `journal/entries/2026/06/17/` naming:

- Pre/post head SHAs.
- Per-item resolution.
- Commit SHAs.
- pre-push-gates result.
- PR #449 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: solicitor` for re-run (round 2).

End your turn with a concise summary back to the orchestrator.
