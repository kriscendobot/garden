---
ts: 2026-06-12T06:00:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--6abce3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 438
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
  - https://github.com/endojs/endo-but-for-bots/pull/438#pullrequestreview-4482896738
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/12/055700Z-result-barrister-821970.md
---

# dispatch: fixer — stage 3 of #438 gamut (2 MFL + 1 summary-fix from barrister)

Continuing the gamut on #438 after barrister `821970` returned
2 must-fix-loop + 1 summary-fix. Both design departures
dispositioned as `acknowledge` (maintainer's routing call).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#438`, DRAFT, head
  `chore/tsgo-lint-types` at `4dc641a27`.

## MFL items

1. **`AGENTS.md:110`** — new em-dash in Testing-section
   bullet (cleaner swept PR body but missed AGENTS.md).
   Replace per `garden/skills/em-dash-style/SKILL.md`.
2. **`AGENTS.md:17-43`** — new `sentence-per-line-md`
   violations in the new "TypeScript Preview (tsgo)"
   section the builder added. Apply sentence-per-line
   rewrap per the probe.

## Summary-fix

3. **PR body claim** that "pre.js already has `@ts-nocheck` so
   the wildcard include doesn't pin a check failure on it" is
   too broad. `post.js`/`commit.js`/`commit-debug.js` lack
   `@ts-nocheck` AND are included by the wildcard. Tighten
   the claim — name only `pre.js` explicitly, OR list each
   file's `@ts-nocheck` status accurately.

## Task

In your `project/` worktree on `chore/tsgo-lint-types` at
`4dc641a27`:

1. **Apply MFL-1**: edit `AGENTS.md:110` em-dash. Commit
   `docs(AGENTS): replace em-dash with comma in Testing
   section`.
2. **Apply MFL-2**: rewrap `AGENTS.md:17-43` to
   sentence-per-line. Commit `docs(AGENTS): sentence-per-line
   rewrap of new tsgo section`.
3. **Apply summary-fix**: edit the PR body via `gh pr edit
   --body-file` to tighten the @ts-nocheck claim.
4. **Run pre-push-gates**; confirm clean (the AGENTS.md
   probes that were flagged should now pass).
5. **Push** to `chore/tsgo-lint-types` (append push only).
6. **Reply on the barrister verdict review** (top-level
   comment on PR #438 if review-replies unavailable)
   citing each addressing commit SHA and naming the
   summary-fix body change.
7. **Do NOT re-request review** — the maintainer's routing
   on the two acknowledge-dispositioned design departures
   is still pending; the gamut continues to justice for
   re-run rather than back to maintainer.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to `chore/tsgo-lint-types` (append push
  only).
- **Edit the PR body** via `gh pr edit`.
- **Top-level comment** on PR #438 with addressed-items
  summary.
- Do NOT re-request review.

## Out of scope

- Do NOT address the 2 acknowledge-dispositioned design
  departures (maintainer's call).
- Do NOT touch source beyond AGENTS.md.
- Do NOT amend builder or cleaner commits.

## Deliverable

A `result` entry under `journal/entries/2026/06/12/` naming:

- Pre/post branch tip SHAs.
- The 2 commit SHAs.
- The PR body before/after summary.
- pre-push-gates result.
- The reply URL.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator dispatches justice for the re-run next and tears
down your dispatch root on return.
