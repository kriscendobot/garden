---
ts: 2026-05-22T21:45:01Z
kind: dispatch
role: justice
project: endo-but-for-bots
to: justice
host: endolinbot
slot: 3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 290
    role: target
refs:
  - entries/2026/05/22/214008Z-result-fixer-eb50c1.md
---

# Dispatch: justice 818714 — re-panel #290 (lal pi-harness) post-fixer

Dispatch root: `dispatches/justice--818714/`. Project worktree on `endojs/endo-but-for-bots@feat/lal-pi-harness` (head after fixer's `b5d903d0c`).

Fixer-eb50c1 addressed 5 inline-comment threads on PR #290 (across `agent.js`, `README.md`, `primer/smallcaps.md`); pushed a single commit `b5d903d0c` exporting pet-name shapes from `@endo/daemon/type-guards.js`. All 5 threads resolved with replies. CI: 12 pass, 8 pending, 6 fail — the 6 failures are **pre-existing `@endo/fae` flakes** (configurations.test.js + cursor.test.js) on prior heads too; lal's own tests pass locally 17/1-skipped.

## Task

Standard justice pass per `garden/roles/justice/AGENT.md` and `garden/skills/panel-review/SKILL.md`:

- Re-run the code panel against the fixer's new head `b5d903d0c`.
- Consult `garden/skills/panel-hints/SKILL.md` for seat selection; for a sizeable refactor (`refactor(lal): adopt genie's pi-based harness + memory internals`) plus the new pet-name-shapes export, the appropriate subset likely includes a larger fraction than the barrister-#316 panel.
- The fixer's single commit `b5d903d0c` adds a new file `packages/daemon/src/type-guards.js`, updates daemon `interfaces.js`, lal `agent.js` imports, and a changeset. Justice's panel sees both the original PR diff and the fixer's commit.
- Aggregate verdicts.
- If any `must-fix-loop` items: dispatch another fixer (contractor's next cycle picks this up; justice doesn't loop itself).
- If 0 `must-fix-loop`: declare the chain done from the justice's perspective; the contractor's next cycle dispatches the appellate (for any acknowledge dispositions) or directly un-drafts.

**CI flake note**: the `@endo/fae` flakes are not the fixer's responsibility. Justice notes them but doesn't block on them. A separate shepherd dispatch can chase the flakes if the contractor sees fit.

## Per-action authorization

- `gh pr review 290 --comment` formal submission with the aggregated body.
- `gh pr edit 290 --add-reviewer @copilot` fire-and-forget (if not already added).
- Juror sub-dispatches via the panel skill.
- READ-ONLY everywhere else.
- **Don't un-draft.**

## Out of scope

- Don't dispatch a fixer yourself (orchestrator's call on the next cycle).
- Don't shepherd the pre-existing `@endo/fae` flake.

## Report

≤ 300 words: panel-hints selection; per-seat dispositions; aggregated verdict; formal review URL; CI status acknowledgment (with flake citation); one-line `Self-improvement: ...`.

Write to `journal/entries/2026/05/22/<HHMMSS>Z-result-justice-818714.md` and commit+push to origin journal.
