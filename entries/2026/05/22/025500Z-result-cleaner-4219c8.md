---
ts: 2026-05-22T02:55:00Z
kind: result
role: cleaner
project: endo-but-for-bots
worktree: dispatches/cleaner--9cce52/
prs:
  - repo: endojs/endo-but-for-bots
    pr: 355
    role: mirror
refs:
  - entries/2026/05/22/024134Z-dispatch-liaison-e9cc5a.md
---

# Result: cleaner deferred on PR #355 (mirror/3099-bundle-source-perf); needs weaver before cleaner

## Status

**Did not push.** PR #355 is `CONFLICTING` against base `master` (mergeStateStatus: `DIRTY`). Per `roles/cleaner/AGENT.md` operating norms ("If the PR is `CONFLICTING` against its base when the cleaner arrives, surface 'needs a weaver before cleaner' in the report and do not push coverage commits onto a non-mergeable head"), I stopped before touching the worktree.

## Findings

- PR: #355 in `endojs/endo-but-for-bots`, base `master`, head `mirror/3099-bundle-source-perf` at `1f4948de9`, DRAFT, single commit `perf(bundle-source): cut multi-entry agoric bundling time and add detailed profiling`.
- `statusCheckRollup` is empty (no CI runs visible on this head from the cleaner's vantage).
- `reviewDecision` is empty (no human review yet).
- The mirror diff against current `origin/master` (head `0ec70c6dd`) touches 34 files spanning five packages: `bundle-source`, `compartment-mapper`, `evasive-transform`, `module-source`, `zip` (+2969 / -374).

## Why a weaver first

`origin/master` advanced after the mirror branch was created. Two recent master commits likely overlap with the mirror's surface area:

- `7309d6933 feat(bundle-source): use Node/amaro for type stripping` (also in `bundle-source/src/script.js`, which the mirror rewrites heavily).
- `bbd399d31 chore: require erasable typescript syntax` (touches `package.json` and possibly `bundle-source` files).

Resolving these is conflict-resolution work owned by the weaver, not the cleaner. Pushing coverage commits onto a head that is not mergeable would compound the rebase later and force the weaver to redo the same merge over a larger commit graph.

## Cleaner readiness after weaver

Once the weaver lands the rebased head:

- The mirror touches **five packages**. Per cleaner norm "One package per engagement", the orchestrator should dispatch one cleaner per package in parallel (or pick the primary package `bundle-source` and judge the others as out-of-scope for this engagement). The contractor / steward sees this at dispatch time.
- The PR already adds two new test files (`packages/bundle-source/test/profiling.test.js`, `packages/compartment-mapper/test/node-powers.test.js`, `packages/compartment-mapper/test/parse-archive-mjs.test.js`, `packages/evasive-transform/test/evade-censor.test.js`), so some coverage surface is already extended; the cleaner pass would be supplemental, not a from-scratch build-out.

## Recommendation to orchestrator

1. Dispatch **weaver** on PR #355 to rebase `mirror/3099-bundle-source-perf` onto current `master` and resolve the bundle-source overlap with `7309d6933` and `bbd399d31`.
2. After the weaver's force-with-lease push and a clean fetch, re-dispatch the cleaner (one per touched package, or just `bundle-source` as the primary surface).
3. Then judge → fixer-loop → un-draft (the contractor's auto-gauntlet pattern resumes).

If CONFLICTING persists after a weaver attempt (e.g., a non-trivial three-way merge in `script.js` or `endo.js`), the weaver itself reports the gap and the orchestrator decides whether to escalate or re-mirror against the upstream head.

## Worktree state

`HEAD` unchanged at `1f4948de9`. No commits, no pushes, no PR comments. Worktree clean.

Self-improvement: nothing this time. The CONFLICTING guard is already in `roles/cleaner/AGENT.md` operating norms, the report follows it verbatim, and there is no friction to record.
