---
ts: 2026-05-15T02:22:38Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 240
    role: target
refs:
  - entries/2026/05/15/021448Z-dispatch-liaison-3e60f4.md
  - entries/2026/05/15/021841Z-dispatch-liaison-6fdde1.md
---

# Dispatch: judge runs 12-seat code panel on #240 (gamut step 3)

Dispatch root: `dispatches/judge--862a3d/`. Project worktree on `endojs/endo-but-for-bots@feat/turbo-test-depends-on-build` (head `223aacfe1`).

Step 3 of the gamut on #240. Weaver done (rebased on current llm). Cleaner returned skip (config-only PR; no coverage surface). Judge is next-stage-owed.

#240 is a config PR (changes `turbo.json` + `turbo.json.md`); not a design-only PR (no `<project>/designs/` paths). Per `roles/judge/AGENT.md` § Panel-kind discrimination, the **12-seat code panel** is the right composition: assessor, typist, stylist, packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker.

## Per-action authorization

Standing on endo-but-for-bots: dispatch panel + request `@copilot` + aggregate + submit one formal `gh pr review`.

## Task

Run the judge per `roles/judge/AGENT.md`. Probe for `Agent`/`Task` tool at the top; if absent, in-band-fallback per the role file (write each seat's block one at a time, primary surface only, dedupe after all twelve, submit one formal `gh pr review`). Tag result entry with the mode used.

`gh pr edit 240 -R endojs/endo-but-for-bots --add-reviewer @copilot` runs in parallel with the panel work.

## Out of scope

- No code changes.
- No un-draft from this dispatch (un-draft is the judge's final act on a successful loop in a follow-up dispatch).

## Report

≤ 400 words: panel kind, mode, verdict, must-fix count, top-3 must-fix items, one-line `Self-improvement: ...`. The liaison reads this and dispatches either a fixer (if must-fix items) or a final judge to un-draft (if loop terminated).
