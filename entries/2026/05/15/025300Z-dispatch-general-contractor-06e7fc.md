---
ts: 2026-05-15T02:53:00Z
kind: dispatch
role: general-contractor
to: cleaner
project: endo-but-for-bots
worktree: dispatches/cleaner--06e7fc/project
refs:
  - entries/2026/05/15/025151Z-result-builder-03b9cc.md
  - entries/2026/05/15/024200Z-dispatch-general-contractor-03b9cc.md
---

# Dispatch cleaner: coverage pass on PR #259 (slot 3)

Slot 3's builder `03b9cc` returned at 02:51Z with draft PR #259 (`feat: hardened TextEncoder/TextDecoder shim`, base master, head `fc2aa8d3c`). 14 new tests; regression evidence verified.

Dispatch root: `dispatches/cleaner--06e7fc` (project worktree at `endojs/endo-but-for-bots@feat/hardened-text-codecs-shim`).

## Task

Per `garden/roles/cleaner/AGENT.md` and `skills/coverage-driven-testing/SKILL.md`:

1. Run a coverage pass on `packages/ses/` (the only touched package).
2. Push coverage-additions and any dead-code cleanups as one or more commits on `feat/hardened-text-codecs-shim`.
3. Watch CI converge on the cleaner's HEAD; treat propagating-only-pre-existing-infra-red as acceptable.
4. Report done. **Do not un-draft** — the judge's authority per the 2026-05-14 redesign.

## Per-action authorization

- Pushes to `feat/hardened-text-codecs-shim` implicit.
- No PR comments authorized.

If `mergeable_state` is `CONFLICTING` at start (master may move while you run), surface "needs a weaver before cleaner" and stop.

Report: coverage delta (lines covered before vs after), any commits pushed, CI status on cleaner HEAD, whether judge dispatch is owed next (default yes; cleaner returns done after its pushes converge).

Self-improvement per `garden/skills/self-improvement/SKILL.md`.
