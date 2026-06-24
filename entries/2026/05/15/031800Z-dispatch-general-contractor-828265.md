---
ts: 2026-05-15T03:18:00Z
kind: dispatch
role: general-contractor
to: fixer
project: endo-but-for-bots
worktree: dispatches/fixer--828265/project
refs:
  - entries/2026/05/15/031730Z-result-judge-df5d88.md
  - entries/2026/05/15/031200Z-dispatch-general-contractor-df5d88.md
---

# Dispatch fixer: address design-panel verdict on PR #249 (slot 2)

Slot 2 advances after judge `df5d88` returned at 03:17Z with a design-panel verdict carrying 7 in-scope must-fix items, 5 should-fix, 4 out-of-scope. Verdict review id (submitted at 2026-05-15T03:15:06Z) is on PR #249.

Dispatch root: `dispatches/fixer--828265` (project worktree at `endojs/endo-but-for-bots@design/ses-top-level-await`, head ~`f191dd1ae`).

## Must-fix items (7 in scope)

The judge's `result` entry at `entries/2026/05/15/031730Z-result-judge-df5d88.md` summarizes:

1. **Metadata table** to match `designs/CLAUDE.md` convention; use a valid Status value; use `Name (prompted)` for Author.
2. **Add design to `designs/README.md`** (summary table, milestone, dependency graph, size estimate).
3. **Add `## Prompt` section** at the end of the design.
4. **Address 7 substantive inline kriskowal comments** on lines 146, 217, 358, 364, 370, 378, 384, 391. The line-391 cycle-root question is the heaviest single item: either justify cycle-root tracking with an observable-difference example, or excise the cycle-root machinery. Fetch the comments via:
   ```sh
   gh api 'repos/endojs/endo-but-for-bots/pulls/249/comments' --paginate
   ```
5. **Em-dash sweep** across prose per `garden/skills/em-dash-style/SKILL.md`.
6. **Normalize section heading case** (sentence case throughout).
7. **Add `#Lnnn` line anchors** to inline file references.

## Should-fix items (5 in scope)

See the panel verdict body on the PR (and the judge's result entry per-seat sections) for full list.

## Important note on this PR's review state

The kriskowal `CHANGES_REQUESTED` was authored with an empty review body but **carries 7 inline comments on specific design lines**. These are real maintainer feedback, not placeholder. The fixer addresses them alongside the panel's must-fix items; the addressing-SHA-per-item table cites both panel items and inline-comment line numbers.

## Per-action authorization (forwarded by general-contractor)

- Commits and pushes to `design/ses-top-level-await` implicit.
- Thread replies on each inline review thread per `garden/skills/pr-review-thread-replies/SKILL.md`.
- One top-level summary comment on the PR after the revision pass lands, naming addressing SHAs.

## Definition of done

- Each must-fix item addressed (commit or thread reply rationale).
- Each should-fix item addressed.
- PR head moved to the new revision; CI re-running.
- Result entry naming each must-fix and each kriskowal inline comment with addressing-SHA-or-rationale.

The contractor's next cycle re-evaluates next-stage-owed; with a fixer push since the panel verdict, the heuristic returns "judge re-dispatch owed".

Self-improvement per `garden/skills/self-improvement/SKILL.md`.
