---
ts: 2026-05-22T01:06:59Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: builder
prs:
  - repo: endojs/endo
    pr: 2902
    role: source
---

# Dispatch: builder mirrors endojs/endo#2902 (Deduplicate bundle-lite) onto endo-but-for-bots@master

Dispatch root: `dispatches/builder--09ac1f/`. Project worktree on `endojs/endo-but-for-bots@master` (head `0ec70c6dd`).

Maintainer directive (2026-05-22): *"Please mirror https://github.com/endojs/endo/pull/2902 based on the master branch and run the gamut."*

Pre-flight: no existing mirror found on endo-but-for-bots.

## Upstream PR #2902

- Author: kriskowal
- Title: "refactor(bundle-lite): Deduplicate bundle-lite"
- Source branch: `kriskowal-dedup-bundle-lite` (already fetched as `endo-upstream/kriskowal-dedup-bundle-lite`)
- Base on upstream: `master`. **Mirror base on the bot fork: `master`** per the maintainer directive.
- State: OPEN
- 3 files, +16 / -585
- Subsystem: bundle-source

## Task

1. Read `garden/roles/COMMON.md`, then `garden/roles/builder/AGENT.md`.
2. Read `garden/skills/library-lookup/SKILL.md`, `garden/skills/pre-push-gates/SKILL.md`, `garden/skills/pr-formation/SKILL.md`.
3. Apply the upstream diff onto `master`. The mirror is small (3 files); cherry-pick (shape a) is almost certainly cleanest.
4. Local validation: `yarn install`, `cd packages/bundle-source && npx ava`, `cd packages/bundle-lite && npx ava` (if it exists post-dedup), `yarn lint`, `yarn docs`, pre-push-gates.
5. Push to `endojs/endo-but-for-bots:mirror/2902-dedup-bundle-lite` (first push, non-force).
6. Open **DRAFT** PR on `endojs/endo-but-for-bots` against `master`. Title: `refactor(bundle-lite): Deduplicate bundle-lite (mirror of endojs/endo#2902)`. Body uses kriskowal's upstream PR body + leading paragraph naming the mirror relationship.
7. **Do NOT** cross-post on `endojs/endo#2902`. **Do NOT** un-draft (the chain unfolds: cleaner → judge → fixer-loop → judge un-drafts).

## Gamut chaining

The maintainer asked for "the gamut" — the full PR-creation-flow chain to un-draft. The contractor's per-cycle PR-creation-flow scan picks up the orphan DRAFT after this builder returns and dispatches the next-owed stage (cleaner → judge → fixer-loop → un-draft) per the 2026-05-21 norm. The liaison may optionally chain it manually in-session, but the contractor's scan is the load-bearing path.

## Per-action authorization

- Push to `endojs/endo-but-for-bots:mirror/2902-dedup-bundle-lite`.
- Open draft PR on `endojs/endo-but-for-bots` against `master`.
- READ-ONLY on `endojs/endo`.

## Out of scope

- No cross-post on `endojs/endo#2902`.
- No un-draft.
- No upstream ferry.

## Report

≤ 300 words. Fork PR URL + head SHA. Commit shape chosen. Conflict resolutions. Local test status per command. One-line `Self-improvement: ...`. Write the result as `journal/entries/2026/05/22/<HHMMSSZ>-result-builder-09ac1f.md` and push journal (rebase if non-fast-forward).
