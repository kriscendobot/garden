---
ts: 2026-05-14T21:28:19Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 247
    role: target
---

# Dispatch: judge dispatches twelve-seat code panel on PR #247

Dispatch root: `dispatches/judge--ab5f8b/`. Project worktree on `endojs/endo-but-for-bots@feat/eventual-send-test`. PR head `ac989794b`; CI 25/25 SUCCESS.

Continuing the gamut on #247 manually (the steward is alive again but the chain on #247 has been driven from the liaison side since the cleaner dispatch). The cleaner stage is done (`entries/2026/05/14/212704Z-result-cleaner-2ea353.md`); the judge is the next-stage-owed.

## PR shape

Code PR (changes under `packages/eventual-send/` and `packages/eventual-send-test/`, no `designs/` paths). Per `roles/judge/AGENT.md` § Panel-kind discrimination, the **twelve-seat code panel** is the right composition: assessor, typist, stylist, packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker.

## Per-action authorization

Standing on endo-but-for-bots: dispatch the twelve seats; request `@copilot` as a reviewer; aggregate; submit one formal `gh pr review`.

## Task

Run the judge per `roles/judge/AGENT.md`. Probe the harness for `Agent` / `Task` availability at the top of the dispatch; if absent, follow the In-band fallback (write each seat block in-band, one at a time, primary surface only, dedupe after all twelve blocks, submit one formal `gh pr review`). Tag the result entry with the mode used (`multi-seat-dispatch` or `in-band-fallback`).

`gh pr edit 247 -R endojs/endo-but-for-bots --add-reviewer @copilot` runs in parallel with the panel dispatches per the standard pattern.

## Out of scope

- No source changes (the judge does not edit code).
- No un-draft from this dispatch; the judge un-drafts only when the loop terminates (i.e., panel finds no in-scope must-fix items in a re-review round, which is at least one fixer cycle away).

## Report

≤ 400 words: which panel was dispatched (code-panel), which mode (multi-seat-dispatch / in-band-fallback), the verdict (request-changes / approve / comment), must-fix count, top-3 must-fix items if any, one-line `Self-improvement: ...`.
