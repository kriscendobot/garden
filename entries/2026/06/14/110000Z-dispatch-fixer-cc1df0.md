---
ts: 2026-06-14T11:00:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--cc1df0
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/kriskowal/garden/blob/journal/jobs/open/20260614T105226Z--ea095b--endo-but-for-bots-440-r2-summary-fix.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/14/105230Z-result-justice-1eed16.md
---

# dispatch: fixer — claim job ea095b on PR #440 (registry-host alignment)

Apply the single summary-fix item in job `ea095b`: align `packages/chat/formula-view-registry.js`'s `host` entry `propertyList` with the daemon's rewritten host case (drop singular `worker`; add `handle`, `hostHandle`, `mainWorker`, `nodeWorker` to match `formula-record.js`'s host case emission).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#440`, DRAFT, base `llm`, head `93b399160`.
- **Justice round 2 (terminating)**: 0 must-fix-loop, 1 summary-fix (this job), 1 follow-up, 5 acknowledge.
- **Appellate**: zero promotions; deferrals stand.
- **Existing followup ledger** carries 6 items (5 round-1 + 1 round-2) for merge-time review.

## Task

In your `project/` worktree at `93b399160`:

1. Read the job body at `journal/jobs/open/20260614T105226Z--ea095b--endo-but-for-bots-440-r2-summary-fix.md` for the exact contract.
2. Read `packages/daemon/src/formula-record.js` host case to confirm the canonical property order the daemon emits (`handle`, `hostHandle`, `mainWorker`, `nodeWorker`, `inspector`, `petStore`, `mailboxStore`, `mailHub`, `endo`, `networks`, `pins`).
3. Edit `packages/chat/formula-view-registry.js`'s `host` entry `propertyList` to match (drop singular `worker`, add the new properties in the curated order). Keep `omitProperties` (if any) intact.
4. Update any unit-test claim in `packages/chat/test/unit/formula-view-registry.test.js` that asserts the host's property list (if it does — check first; some tests just assert the canonical-types coverage, not the property lists).
5. Run `corepack yarn workspace @endo/chat test` to verify.
6. Commit: `fix(chat): align formula-view-registry host propertyList with daemon emission`.
7. Push to `feat/formula-inspector` (append only).
8. Move job entry from `journal/jobs/open/` to `journal/jobs/claimed/` per the job-board skill (or claim via the script if it works in dispatch-root layout; otherwise do it by hand).
9. Post a brief top-level comment on PR #440 at-mentioning `@kriskowal` with the SHA and item resolution.

## Out of scope

- Do NOT touch the broader daemon-vs-registry catalog drift (the round-1 follow-up that the optional/related note references); that stays in the ledger for merge time.
- Do NOT un-draft (orchestrator after CI green on the new push).
- Do NOT re-request review.

## Deliverable

A `result` entry under `journal/entries/2026/06/14/` naming:

- Pre/post head SHAs.
- The 1 commit SHA.
- `corepack yarn workspace @endo/chat test` result.
- PR #440 comment URL.
- Job claim path.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: orchestrator un-drafts PR #440 after CI green; then conductor for merge`.

End your turn with a concise summary back to the orchestrator.
