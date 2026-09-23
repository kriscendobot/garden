---
ts: 2026-05-22T22:14:00Z
kind: dispatch
role: cleaner
project: endo-but-for-bots
to: cleaner
host: endolinbot
slot: 1
prs:
  - repo: endojs/endo-but-for-bots
    pr: 320
    role: target
---

# Dispatch: cleaner 12a8b9 — gauntlet stage on endo-but-for-bots#320 (familiar stop/purge consolidation)

Dispatch root: `dispatches/cleaner--12a8b9/`. Project worktree on `endojs/endo-but-for-bots@feat/familiar-consolidated-stop-purge`.

Contractor slot-1 refill (after #134 parked on Gateway design dep): PR #320 `feat(familiar): consolidate daemon stop/purge via CapTP control helper (#231 G8)`. State `MERGEABLE`, no review. 2.5+ days idle.

## PR shape

G8 of `designs/familiar-release.md`/#231: refactors the familiar daemon stop+purge surface to share a CapTP control helper. Source-touching code change.

## Task

Standard cleaner pass per `garden/skills/pr-creation-flow/SKILL.md`:
- Coverage sweep: verify the new CapTP control helper has tests; surface gaps.
- Adversarial coverage: error paths and concurrent invocations of stop/purge.
- Dead-code audit: any pre-consolidation stop/purge paths now unused?
- Body audit; `gh pr edit` if test-plan checkboxes can be completed given CI evidence.
- CI watch on any commits pushed.

If you push nothing, say so explicitly.

## Per-action authorization

- Push to `feat/familiar-consolidated-stop-purge`.
- `gh pr edit` on body/labels of #320.
- READ-ONLY everywhere else. Don't un-draft.

## Out of scope

- Don't broaden beyond stop/purge consolidation.

## Report

≤ 300 words at `/home/kris/dispatches/cleaner--12a8b9/journal/entries/2026/05/22/<HHMMSS>Z-result-cleaner-12a8b9.md`; commit+push origin journal. Cover coverage assessment per file; body audit; commits landed (subjects + head SHA) or "no commits"; CI status; one-line `Self-improvement: ...`.
