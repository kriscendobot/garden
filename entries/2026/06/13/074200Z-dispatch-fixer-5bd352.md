---
ts: 2026-06-13T07:42:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--5bd352
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/13/073900Z-result-barrister-25df0f.md
---

# dispatch: fixer — 3-item summary-fix bundle on #440 per barrister verdict

Continuing #440 gamut after barrister `25df0f` returned 0
MFL + 3 summary-fix items. CI is 15/15 green at head
`be93dadbb`. Cuts 1+2 are mergeable standalone.

## Summary-fix items (per barrister)

Read the barrister's review at PR #440 for full detail. Brief
summary:

1. **`host.js` — `getFormula` unknown-identifier-on-local-node
   error path**: not normalized; should match the error shape
   used elsewhere.
2. **`formula-record.js` — default-case fallthrough test**:
   no test for the default case when an unknown formula type
   is encountered.
3. **`types.d.ts` — `EndoInspector` + `KnownEndoInspectors`
   deprecation**: marked `@deprecated` but still exported.
   Either remove (with target version note) or scope as
   non-public.

## Task

In your `project/` worktree on `feat/formula-inspector` at
`be93dadbb` (FETCH if needed):

1. **Read** the barrister's full review (per the result entry
   `073900Z-result-barrister-25df0f.md` for the in-band
   verdict body).
2. Address each summary-fix:
   - **#1**: normalize the error in `host.js`'s `getFormula`
     unknown-identifier-on-local-node path.
   - **#2**: add a unit test for the default-case fallthrough
     in `formula-record.js`.
   - **#3**: pick a disposition for the deprecated exports
     (remove with target-version note, OR convert to internal
     /non-public scope). Document the choice.
3. Run tests + pre-push-gates.
4. Push (append).
5. Post a reply on PR #440 (or the barrister's review)
   summarizing the addressed items.
6. **Re-request review** from kriskowal — the panel cleared
   the substance and CI is green; with the summary-fix
   bundle landed, the PR is ready for maintainer review.

## Authorizations

- Push commits (append only).
- Top-level comment on PR #440.
- Re-request review from kriskowal.

## Out of scope

- Do NOT address the cut-3 chat impasse.
- Do NOT touch PR #441.
- Do NOT un-draft (un-draft happens at justice's
  terminator if the maintainer routes the impasse, or via
  the maintainer's APPROVED-then-conductor flow).

## Deliverable

A `result` entry naming:

- Pre/post SHAs.
- 3 commit SHAs (one per item, or 2 if bundleable).
- Per-item resolution.
- Test result.
- pre-push-gates result.
- Reply + re-request URLs.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
