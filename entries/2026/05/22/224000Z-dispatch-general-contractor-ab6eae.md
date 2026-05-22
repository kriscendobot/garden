---
ts: 2026-05-22T22:40:00Z
kind: dispatch
role: weaver
project: endo-but-for-bots
to: weaver
host: endolinbot
slot: 1
prs:
  - repo: endojs/endo-but-for-bots
    pr: 320
    role: target
refs:
  - entries/2026/05/22/223122Z-result-cleaner-12a8b9.md
---

# Dispatch: weaver ab6eae — rebase #320 past 30 commits of llm drift (ocapn rename)

Dispatch root: `dispatches/weaver--ab6eae/`. Project worktree on `endojs/endo-but-for-bots@feat/familiar-consolidated-stop-purge` (head `97ad09532`).

Cleaner-12a8b9 landed a bug fix (`fix(familiar): clear daemon-control timeout on settle`, commit `97ad09532`) and recommended weaver before judge: CI red is due to llm base drift, not the fix. The `packages/ocapn/test/netlayer-tcp-syrup.test.js` imports `makeClient` from a file that now exports `makeOcapn` on origin/llm (same rename that affected #242). ~30 commits behind.

## Task

Rebase `feat/familiar-consolidated-stop-purge` onto current `origin/llm`. Resolve any conflicts (likely concentrated on the ocapn rename surface, though #320 doesn't touch ocapn — most rebase should be clean). Force-push-with-lease.

Per `garden/skills/frozen-base-branch/SKILL.md`: apply frozen-base convention.

Post-rebase: verify other-file integrity; CI re-runs and converges (the ocapn test failure should disappear since it's not in #320's diff — it was a llm-side issue caught by the running test suite).

## Per-action authorization

- Force-push-with-lease on `feat/familiar-consolidated-stop-purge`.
- Frozen-base branch push.
- READ-ONLY everywhere else. Don't un-draft.

## Out of scope

- Don't broaden PR's scope.

## Report

≤ 300 words at `/home/kris/dispatches/weaver--ab6eae/journal/entries/2026/05/22/<HHMMSS>Z-result-weaver-ab6eae.md`; commit+push origin journal. Cover pre/post-rebase SHAs; conflict-resolution shape; other-file integrity; CI status post-push (esp. ocapn test); slot-1 next-stage recommendation (barrister); one-line `Self-improvement: ...`.
