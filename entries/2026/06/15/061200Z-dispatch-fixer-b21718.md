---
ts: 2026-06-15T06:12:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--b21718
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
  - repo: endojs/endo
    pr: 3276
    role: upstream-source
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379
  - https://github.com/endojs/endo/pull/3276#pullrequestreview-4489675443
  - https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4705051704
---

# dispatch: fixer — apply upstream review 4489675443 to mirror PR #379

Maintainer directive (kriskowal on PR #379, 2026-06-15T06:09:55Z):

> @kriscendobot rsvp https://github.com/endojs/endo/pull/3276#pullrequestreview-4489675443

Upstream review (boneskull on endojs/endo#3276, 2026-06-12T22:58:53Z, APPROVED) carries 4 inline nits:

1. **`packages/ses/src/notifier-with-resolver.js:1`** — (nit) add a `@module` docstring.
2. **`packages/ses/src/notifier-with-resolver.js:19`** — (nit) the comment is brittle. Reference `{@link makeNotifierWithResolver}` within the docstring for `wireUpExportNotifier` instead.
3. **`packages/ses/src/notifier-with-resolver.js:41`** — (style opinion) Change this (and `resolve` below) so the conditional uses strict equality (`resolvedTargetNotify === undefined`) and/or use an `else` instead of an early return.
4. **`packages/ses/test/import-cjs.test.js:700`** — (note to self) #3220 creates a "real" `CjsModuleSource` in `@endo/module-source` which this test should use instead of the mock.

Mirror PR #379's own inline comments are all RESOLVED (kriscendobot addressed all maintainer asks). The only outstanding work is folding boneskull's 4 nits.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#379`, OPEN, not draft, reviewDecision CHANGES_REQUESTED, base `master`, head `ca17e11e4`.

## Task

In your `project/` worktree at `ca17e11e4`:

1. Read each cited line in the mirror branch.
2. Apply nits 1, 2, 3 (substantive code/doc edits).
3. Decide on nit 4: if upstream #3220 has landed in the mirror's base, swap the mock for the real `CjsModuleSource`; otherwise leave the mock + add a TODO comment referencing #3220 and the swap.
4. Run `corepack yarn workspace ses test` and `corepack yarn workspace @endo/module-source test`.
5. Run pre-push-gates from project/.
6. Commit per nit (or one cohesive commit if tightly coupled). Suggested:
   - `style(ses): add @module docstring + use {@link} reference + strict equality per boneskull`
   - `style(ses): note about #3220 real CjsModuleSource swap per boneskull` (or apply the swap if landed)
7. Push to `fix/issue-59-star-export-cycle` (append only).
8. Reply to each upstream inline comment by quoting it on a top-level summary comment on PR #379 (since the mirror is on a different repo, threaded replies don't cross over; consolidate into one top-level summary @-mentioning @kriskowal with the 4 resolutions + SHAs).

## Authorizations

- Push commits to `fix/issue-59-star-export-cycle` (append only).
- Top-level summary comment on PR #379.
- Do NOT post on upstream endojs/endo#3276 (boatman territory; mirror's feedback flows upstream via boatman ferry).
- Do NOT mark PR ready/un-ready.
- Do NOT re-request review.

## Out of scope

- Do NOT touch endojs/endo directly.
- Do NOT pursue broader CI green work (the browser-tests playwright timeout is a separate concern being addressed on PR #411).

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- Pre/post head SHAs.
- Per-nit resolution mapping (file:line + commit SHA).
- Test results.
- pre-push-gates result.
- PR #379 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: liaison` (maintainer reviews + decides re-request-review or ferry-upstream).

End your turn with a concise summary back to the orchestrator.
