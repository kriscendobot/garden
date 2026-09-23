---
ts: 2026-05-22T02:41:34Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: builder
prs:
  - repo: endojs/endo
    pr: 3099
    role: source
---

# Dispatch: builder mirrors endojs/endo#3099 (bundle-source perf + profiling) onto endo-but-for-bots@master

Dispatch root: `dispatches/builder--e9cc5a/`. Project worktree on `endojs/endo-but-for-bots@master` (head `0ec70c6dd`).

Maintainer directive (2026-05-22): *"Please mirror https://github.com/endojs/endo/pull/3099 and run the gamut"*

Base defaulted to **master** (no explicit "llm" in the directive; the standard builder norm "implementations branch off master" applies).

Pre-flight: no existing mirror.

## Upstream PR #3099

- Author: kriskowal (head branch `codex/bundle-source-profiling`)
- Title: "perf(bundle-source): cut multi-entry agoric bundling time and add detailed profiling"
- Source branch: `codex/bundle-source-profiling` (already fetched as `endo-upstream/codex/bundle-source-profiling`)
- Base upstream: `master`. Mirror base: `master`.
- State: OPEN, **DRAFT**
- 34 files, +3009 / -373
- Subsystem: bundle-source, performance + profiling

## Task

1. Read `garden/roles/COMMON.md`, then `garden/roles/builder/AGENT.md`.
2. Read `garden/skills/library-lookup/SKILL.md`, `pre-push-gates/SKILL.md`, `pr-formation/SKILL.md`.
3. Apply upstream diff onto master. Cherry-pick if clean; otherwise re-form per-package.
4. Local validation: `yarn install`, package tests for `bundle-source` and any other touched packages, `yarn lint`, `yarn docs`, pre-push-gates. Upstream is DRAFT — some tests may legitimately fail; report status, don't let upstream-draft failures block the mirror.
5. Push to `endojs/endo-but-for-bots:mirror/3099-bundle-source-perf`.
6. Open **DRAFT** PR against master. Title: `perf(bundle-source): cut multi-entry bundling time + profiling (mirror of endojs/endo#3099)`. Body: kriskowal's upstream body + leading mirror paragraph.

The contractor's PR-creation-flow scan picks up the orphan DRAFT and runs the gamut (cleaner → judge → fixer-loop → un-draft).

## Per-action authorization

Push to mirror branch; open draft PR against master. READ-ONLY on endojs/endo. No comments outside the new PR's body.

## Out of scope

Cross-post on upstream; un-draft; ferry.

## Report

≤ 400 words. PR URL + head SHA, commit shape, conflicts, per-command test status, one-line `Self-improvement: ...`. Write result as `journal/entries/2026/05/22/<HHMMSSZ>-result-builder-e9cc5a.md` and push journal (rebase if non-fast-forward).
