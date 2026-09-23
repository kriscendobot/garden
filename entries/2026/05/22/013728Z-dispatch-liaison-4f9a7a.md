---
ts: 2026-05-22T01:37:28Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: builder
prs:
  - repo: endojs/endo
    pr: 2422
    role: source
---

# Dispatch: builder mirrors endojs/endo#2422 (Host module exits) onto endo-but-for-bots@master

Dispatch root: `dispatches/builder--4f9a7a/`. Project worktree on `endojs/endo-but-for-bots@master` (head `0ec70c6dd`).

Maintainer directive (2026-05-22): *"Please mirror https://github.com/endojs/endo/pull/2422 based on master and run the gamut."*

Pre-flight: no existing mirror on endo-but-for-bots.

## Upstream PR #2422

- Author: kriskowal
- Title: "feat(compartment-mapper): Host module exits"
- Source branch: `kriskowal-ponyfill-host-module` (already fetched as `endo-upstream/kriskowal-ponyfill-host-module`)
- Base upstream: `master`. Mirror base: `master`.
- 20 files, +282 / -26
- Subsystem: compartment-mapper

## Task

1. Read `garden/roles/COMMON.md`, then `garden/roles/builder/AGENT.md`.
2. Read `garden/skills/library-lookup/SKILL.md`, `pre-push-gates/SKILL.md`, `pr-formation/SKILL.md`.
3. Apply upstream diff onto master. Cherry-pick if clean; otherwise re-form per-package.
4. Local validation: `yarn install`, `cd packages/compartment-mapper && npx ava`, `yarn lint`, `yarn docs`, pre-push-gates.
5. Push to `endojs/endo-but-for-bots:mirror/2422-host-module-exits`.
6. Open DRAFT PR against master. Title: `feat(compartment-mapper): Host module exits (mirror of endojs/endo#2422)`. Body: kriskowal's upstream body + leading mirror paragraph.

The contractor's PR-creation-flow scan picks up the orphan DRAFT and runs the gamut (cleaner → judge → fixer-loop → un-draft).

## Per-action authorization

Push to mirror branch; open draft PR against master. READ-ONLY on endojs/endo. No comments outside the new PR's body.

## Out of scope

Cross-post; un-draft; ferry.

## Report

≤ 300 words. PR URL + head SHA, commit shape, conflicts, test status, one-line `Self-improvement: ...`. Write result as `journal/entries/2026/05/22/<HHMMSSZ>-result-builder-4f9a7a.md` and push journal (rebase if non-fast-forward).
