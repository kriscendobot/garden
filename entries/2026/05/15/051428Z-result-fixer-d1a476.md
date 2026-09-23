---
ts: 2026-05-15T05:14:28Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--4bf911/project
refs:
  - entries/2026/05/15/045835Z-result-cleaner-924af9.md
  - entries/2026/05/15/042000Z-result-builder-a232cc.md
---

# Result: fixer addressed both CI reds on PR #263 (hardened-url-shim)

## Branch / head

`feat/hardened-url-shim`, head advanced from `9acdcc4f0` (cleaner) to `3b483ee7d` (fixer +2 commits).

PR `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`. Still draft (fixer did not un-draft; that is the judge's terminator).

## Commits

1. **`944fb0594` `fix(ses): silence polymorphic-call lint on URLSearchParams iterator sampler`** — adds the 6th `// eslint-disable-next-line @endo/no-polymorphic-call` comment to `packages/ses/src/get-anonymous-intrinsics.js:187`, immediately above the `new globalThis.URLSearchParams().entries()` sampling line, matching the style of the five existing disables (lines 146, 150, 161, 165, 171) for Iterator.from / AsyncIterator.from / ArrayBuffer.sliceToImmutable.

2. **`3b483ee7d` `fix(ses): tolerate undeletable arguments/caller on native function intrinsics`** — cherry-pick of `b2a3657fc` from `feat/hardened-text-codecs-shim` (PR #259). The original cherry-pick conflicted only on the sibling PR's changeset file `.changeset/hardened-text-codecs.md` (modify/delete: the URL-shim branch never had that file). Resolved by removing the sibling changeset and appending the analogous user-visible paragraph about `cauterizeProperty` tolerating `arguments` / `caller` on native function intrinsics (Chromium V8's `URL` constructor in this PR's case) to the existing `.changeset/hardened-url-shim.md`. The fix to `packages/ses/src/cauterize-property.js` itself is general: it extends the tolerate-undeletable escape hatch (already in place for `prototype`) to also detect non-configurable own `arguments` and `caller` on functions, skipping with a warning instead of throwing. Net diff: `+28 / -2` lines in `cauterize-property.js`, `+2 / 0` in the changeset.

## Pre-PR checklist on fixer's HEAD

- `npx corepack yarn install` at monorepo root: completed with the same pre-existing peer-dependency warnings as the cleaner's run; no install errors.
- `npx corepack yarn lint:eslint` in `packages/ses`: 0 errors, 1 unrelated pre-existing JSDoc warning on `compartment.js:340`. The previous `@endo/no-polymorphic-call` error is gone.
- `npx corepack yarn ava` in `packages/ses`: **525 tests passed, 2 known failures (pre-existing), 2 skipped**. Same count as the cleaner's run.
- No `yarn.lock` change.

## CI status on `3b483ee7d` (after push + 10 min)

**27/27 checks pass.** Each of the two reds named in the cleaner's report is now green:

- `lint`: pass (was fail with `@endo/no-polymorphic-call` on `get-anonymous-intrinsics.js:188`)
- `browser-tests` (Chromium): pass (was fail with `TypeError: Cannot delete property 'arguments' of function URL() { [native code] }` at `cauterizeProperty`)

All other jobs in the matrix (build, check-action-pins, cover 18/20/24, test on 18/20/22/24 across ubuntu and macos-15, test-async-hooks 18/20, test-hermes, test-ocapn-python, test-xs, test262 18/20/24, viable-release 18/20/24, zizmor) are pass.

## Definition of done

- Both must-fix items from the cleaner's red analysis are addressed in citable commits.
- No `yarn.lock` churn, so no separate `chore: Update yarn.lock` commit required.
- No PR comments authorized for this dispatch (per the dispatch prompt: "No PR comments").
- CI is green on the new head; the PR is ready for the judge.

## Whether the judge dispatch is owed next

**Yes.** Per `skills/pr-creation-flow/SKILL.md` and the dispatch prompt's `Next-stage-owed after green: judge`. The PR is `MERGEABLE` / `CLEAN`, still draft, 27/27 checks pass.

## Self-improvement

Nothing this time. The cherry-pick conflict on the sibling PR's changeset file (`.changeset/hardened-text-codecs.md`) is a foreseeable case of `cherry-pick-followup`'s domain (one PR's hot fix is wanted on a sibling branch that does not share the originating PR's changeset slug), and the `changeset-discipline` skill already covers the resolution shape (merge the user-visible paragraph into this branch's existing changeset, drop the sibling's changeset, do not duplicate the changeset slug across branches). No new lesson worth landing.
