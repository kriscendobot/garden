---
ts: 2026-05-22T01:37:28Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: builder
prs:
  - repo: endojs/endo
    pr: 2948
    role: source
---

# Dispatch: builder mirrors endojs/endo#2948 (docs touch-ups) onto endo-but-for-bots@master

Dispatch root: `dispatches/builder--7367c7/`. Project worktree on `endojs/endo-but-for-bots@master` (head `0ec70c6dd`).

Maintainer directive (2026-05-22): *"Please mirror https://github.com/endojs/endo/pull/2948 based on master and run the gamut."*

Pre-flight: no existing mirror on endo-but-for-bots.

## Upstream PR #2948

- Author: kriskowal
- Title: "docs: Various touch-ups"
- Source branch: `kriskowal-docs-touch-up` (already fetched as `endo-upstream/kriskowal-docs-touch-up`)
- Base upstream: `master`. Mirror base: `master`.
- 4 files, +46 / -69
- Pure docs.

## Task

1. Read `garden/roles/COMMON.md`, then `garden/roles/builder/AGENT.md`.
2. Read `garden/skills/pre-push-gates/SKILL.md`, `pr-formation/SKILL.md`, `em-dash-style/SKILL.md`, `relative-paths/SKILL.md`. The sentence-per-line-md probe in pre-push-gates is the relevant gate for docs.
3. Cherry-pick the upstream diff onto master (tiny diff, almost certainly clean).
4. Local validation: `yarn format`, `yarn lint`, `yarn docs`, pre-push-gates.
5. Push to `endojs/endo-but-for-bots:mirror/2948-docs-touch-up`.
6. Open DRAFT PR against master. Title: `docs: Various touch-ups (mirror of endojs/endo#2948)`. Body: kriskowal's upstream body + leading mirror paragraph.

The contractor's PR-creation-flow scan picks up the orphan DRAFT (the docs-only variant typically skips the cleaner per the pure-docs heuristic).

## Per-action authorization

Push to mirror branch; open draft PR against master. READ-ONLY on endojs/endo. No comments outside the new PR's body.

## Out of scope

Cross-post; un-draft; ferry.

## Report

≤ 200 words. PR URL + head SHA, commit shape, conflicts, test status, one-line `Self-improvement: ...`. Write result as `journal/entries/2026/05/22/<HHMMSSZ>-result-builder-7367c7.md` and push journal (rebase if non-fast-forward).
