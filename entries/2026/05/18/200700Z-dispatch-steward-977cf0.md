---
ts: 2026-05-18T20:07:00Z
kind: dispatch
role: steward
project: agoric-sdk
to: "*"
prs:
  - repo: Agoric/agoric-sdk
    pr: 12198
    role: source
refs:
  - entries/2026/05/18/195800Z-message-liaison-12198.md
---

# Dispatch A: fixer drafts `@photostructure/sqlite` migration PR on `kriscendobot/agoric-sdk` (turadg's Step 1)

Dispatch root: `dispatches/fixer--977cf0/`. Project worktree on `Agoric/agoric-sdk@master` (read-only mirror; pushes go to bot fork).

Full directive at `entries/2026/05/18/195800Z-message-liaison-12198.md` — read it for upstream context, mhofman's review asks, and turadg's plan.

## Per-action authorization

- Add remote `kriscendobot` pointing at `git@github.com:kriscendobot/agoric-sdk.git`.
- Push to feature branch `fix/photostructure-sqlite-backend` on the fork.
- Open DRAFT PR on `kriscendobot/agoric-sdk` base `master`.
- READ-ONLY on upstream `Agoric/agoric-sdk` — no comments on #12198 or #12194.

## Task (Dispatch A)

Migrate `packages/swing-store` from `better-sqlite3` to `@photostructure/sqlite` (turadg's Step 1 backend-entrypoint approach), applying mhofman's three asks:

1. Use native `iterate` through the adapter (do not load all results into memory).
2. Use native `isTransaction` (drop the custom `inTransaction` property tracking).
3. Switch DB-serialization tests to the backup API (`sqlite.backup()` instead of `serialize()` clones).

**Backend-entrypoint design** per turadg's plan: introduce a single SQLite construction entrypoint in `packages/swing-store` with a native-first local surface (`prepare`, `exec`, `iterate`, `isTransaction`). The local surface should be shaped so Dispatch B's `node:sqlite` swap is a constructor change, not a repo-wide rewrite.

**Build off the existing copilot work** if it speeds you up: cherry-pick from `Agoric/agoric-sdk@copilot/switch-to-node-sqlite` (head `728b01765`) into `fix/photostructure-sqlite-backend`, then layer mhofman's feedback. Or start fresh — your call based on diff inspection.

## Commits

- Per `skills/yarn-lock-separate-commit/SKILL.md`: lockfile churn in its own commit.
- Conventional-commit messages per the builder/fixer discipline.
- Push to `kriscendobot/agoric-sdk` (via the `kriscendobot` remote).
- Open draft PR with title: `chore(swing-store): migrate from better-sqlite3 to @photostructure/sqlite (backend entrypoint)`.
- Body cites upstream #12198 + #12194 + mhofman's review.

## Gamut continuation

This dispatch is **stage 1** of the gamut per `skills/pr-creation-flow/SKILL.md`. The fixer produces the draft PR; subsequent stages (cleaner, judge, fixer-loop, un-draft) run via the autonomous-steward's standing PR-creation-flow scan. Don't try to run the whole gamut in this single dispatch.

## Report

≤ 500 words. PR number + URL, final head SHA, key files touched, test status (target: full green including the 2 skipped + 7 failing from #12198), build/lint/type-check status, one-line `Self-improvement: ...`.
