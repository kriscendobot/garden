---
ts: 2026-06-13T07:34:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: barrister
dispatch_root: /home/kris/dispatches/barrister--25df0f
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/13/072236Z-result-builder-256add.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/13/072905Z-result-cleaner-5283f6.md
---

# dispatch: barrister — stage 2 of #440 gamut (formula-inspector code panel)

Continuing #440 gamut after cleaner `6a6bee` pushed
hygiene commit. Head now `be93dadbb`. Builder's cut-3 chat
impasse remains documented but unaddressed by design.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#440`, DRAFT, base
  `master-4a04d07`, head `feat/formula-inspector` at
  `be93dadbb` (FETCH before starting; dispatch-prepare may
  have older head).

## Task

You are the **barrister** (first code panel). Run standard
panel-review discipline.

Primary panel value:

1. **Validate daemon cut (cut 1)**: `EndoHost.getFormula`
   shape, FormulaRecord normalization, `@info` removal,
   guest-absence enforcement, cross-peer-locator rejection.
2. **Validate CLI cut (cut 2)**: `endo inspect <name>` verb,
   `--identifier` and `--json` flags, integration test
   shape.
3. **Spec-coverage** on the new tests per
   `garden/skills/coverage-driven-testing/SKILL.md` and
   `garden/skills/saboteur-adversarial-review/SKILL.md`.
4. **Assess cut-3 chat impasse routing**: builder surfaced
   that master has `packages/goblin-chat`, not
   `packages/chat` as the merged design assumes. Panel
   should opine: should cut 3 happen in this PR (with
   rename adaptation), in a separate PR after this lands,
   or via a separate design refresh? Probably
   `acknowledge` (maintainer routes), but the panel can
   recommend.
5. **PR body adequacy** for routing the impasse.

Render verdict as top-level PR comment.

## Authorizations

- Compose and dispatch jurors (in-band fallback if needed).
- Top-level verdict comment.
- Do NOT push.

## Out of scope

- Do NOT push to branch.
- Do NOT touch PR #441.
- Do NOT request review or un-draft.

## Deliverable

`result` entry under `journal/entries/2026/06/13/`:

- Panel composition.
- Per-juror verdict.
- Per-cut validation.
- Cut-3 impasse routing recommendation.
- Consolidated verdict.
- PR comment URL.
- **Recommended next stage** (fixer if must-fix-loop;
  justice if clean).
- `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
