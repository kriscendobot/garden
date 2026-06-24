---
ts: 2026-05-22T22:45:00Z
kind: dispatch
role: barrister
project: endo-but-for-bots
to: barrister
host: endolinbot
slot: 1
prs:
  - repo: endojs/endo-but-for-bots
    pr: 320
    role: target
refs:
  - entries/2026/05/22/224142Z-result-weaver-ab6eae.md
  - entries/2026/05/22/223122Z-result-cleaner-12a8b9.md
---

# Dispatch: barrister 9a97f1 — first code panel on endo-but-for-bots#320 (familiar stop/purge consolidation)

Dispatch root: `dispatches/barrister--9a97f1/`. Project worktree on `endojs/endo-but-for-bots@feat/familiar-consolidated-stop-purge` (head `b95d00637`, post-weaver-rebase; frozen-base `llm-b1c3f4d`).

Chain: cleaner-12a8b9 (landed bug fix `97ad09532`: clear daemon-control timeout on settle; recommended weaver before judge) → weaver-ab6eae (rebased past 140 commits of llm drift; clean; CI red traced to base-side ocapn `makeClient` rename, not #320's code).

## PR shape

PR #320 (`feat(familiar): consolidate daemon stop/purge via CapTP control helper`, G8 of #231). 7 files (.changeset, packages/familiar/*, yarn.lock); +concurrent stop/purge timeout-clear fix from cleaner.

## Task

Standard barrister pass per `garden/roles/barrister/AGENT.md` + `garden/skills/panel-review/SKILL.md`:
- Consult `panel-hints/SKILL.md`. Diff signal: familiar Electron daemon-control surface, CapTP helper, timeout cleanup. Seat subset: prover, breaker, saboteur, integrator, scribe, releaser, archivist, plus core.
- Dispatch concurrently.
- `gh pr edit 320 --add-reviewer @copilot`.
- Aggregate verdicts.
- **Note for panel**: CI's 3 failures (lint, cover 20.x, cover 24.x) are 100% base-side (ocapn `makeClient` import rename); not in #320's diff. Don't classify as must-fix on this PR.

## Per-action authorization

- `gh pr review 320 --comment`.
- `gh pr edit 320 --add-reviewer @copilot`.
- Juror sub-dispatches.
- READ-ONLY everywhere else. Don't un-draft.

## Out of scope

- Don't broaden PR's scope.
- Don't address base-side ocapn defect (separate concern).

## Report

≤ 300 words at `/home/kris/dispatches/barrister--9a97f1/journal/entries/2026/05/22/<HHMMSS>Z-result-barrister-9a97f1.md`; commit+push origin journal.
