---
ts: 2026-05-22T22:55:01Z
kind: dispatch
role: justice
project: endo-but-for-bots
to: justice
host: endolinbot
slot: 2
prs:
  - repo: endojs/endo-but-for-bots
    pr: 242
    role: target
refs:
  - entries/2026/05/22/224400Z-result-fixer-1dd67c.md
---

# Dispatch: justice db422b — re-panel #242 (syrups-ocapn) post-fixer-scope-correction

Dispatch root: `dispatches/justice--db422b/`. Project worktree on `endojs/endo-but-for-bots@feat/syrups-ocapn-framing`.

Fixer-1dd67c found 10/12 barrister items were **out of scope** — they targeted the `@endo/syrup-frame` package and `packages/ocapn/{src/netlayers/tcp-test-only.js, index.js}` which landed on `origin/llm` via PR #109 (merged 2026-05-20), not on this PR's 3-file diff. The fixer addressed the 1 actually-in-scope summary-fix item (commit `eb5db6534`: SHA pin sentinel comment). Recommendation: separate follow-up PR opens against `endojs/endo-but-for-bots@llm` for the out-of-scope items.

## Task

Standard justice re-panel per `garden/roles/justice/AGENT.md` against the **actual** 3-file diff (not the 20-file scope the barrister saw). Use `panel-hints/SKILL.md` against the correct scope:
- `.changeset/python-test-suite-pin.md` (or equivalent)
- `.github/workflows/ci.yml` (with sentinel comment)
- `packages/ocapn/test/python-test-suite/index.js` (with sentinel comment)
- `packages/ocapn/test/python-test-suite/README.md`

This is a small documentation/sentinel-comment scope; expect a small panel verdict.

## CI flake note

3 base-side CI failures (lint, cover) are pre-existing ocapn `makeClient` rename issue; not this PR's responsibility; don't block.

## Report

≤ 300 words at `/home/kris/dispatches/justice--db422b/journal/entries/2026/05/22/<HHMMSS>Z-result-justice-db422b.md`; commit+push.
