---
ts: 2026-06-03T20:14:20Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--a259cb
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/417
  - entries/2026/06/03/201004Z-result-barrister-c117d2.md
---

# dispatch: fixer — #417 gamut stage 3 (jury-fixer loop, must-fix-loop items)

User explicit ask:

> Please mirror https://github.com/endojs/endo/pull/3164 and
> run the gamut.

Mirror at #417; cleaner stage 1 closed (5 typo fixes at
`984b5d4df`); barrister stage 2 closed with verdict
`must-fix-loop` (2 items) + `summary-fix` bundle (5 items)
per `entries/2026/06/03/201004Z-result-barrister-c117d2.md`.
This dispatch is gamut stage 3: the fixer-loop's first
iteration.

## Target

- PR: endojs/endo-but-for-bots#417
- Branch: `mirror/3164-freezable-typedarrays`
- Head: `984b5d4df`
- Base: `master` (`ba26f4cdb`)
- State: DRAFT.

## Must-fix-loop items (from barrister verdict)

1. **`src/freezable-typedarray-pony.js:65`**: `throw new
   TypedArray(...)` should be `throw TypeError(...)`. (The
   intent is to throw a type error, not construct a new
   typed array.)

2. **`src/freezable-typedarray-pony.js:193`**: `weakMapSet(...)`
   called without `apply`, value wrapped in array. Two bugs in
   one line; uncovered because the only test is
   `t.pass('placeholder')`.

## Summary-fix bundle (5 items, also for this fixer to land)

3. **`TypeArray` typos × 4** in `src/pony-internal.js` JSDoc.
4. **New test title** uses `TypeArray` and `subArray` (typos).
5. **Missing `freeze()`** on the new module's exports.
6. **Placeholder-only test** for the new module — replace with
   a real test that covers the must-fix-loop fix from item 2.
7. **`permits.js`** slot has no installer.

(Note: items 6 and 7 may overlap with the must-fix-loop items;
use judgment to bundle cleanly.)

## Procedure

1. Apply each must-fix-loop fix in `src/freezable-typedarray-
   pony.js` per item 1 and item 2.
2. Apply the summary-fix bundle items 3-7 in the appropriate
   files.
3. Replace the placeholder test with a real test that exercises
   the bug from item 2 (would have caught it).
4. Run gates locally: `yarn lint`, `yarn ava` on the touched
   test file, `yarn lint:types`.
5. Commit one or more regular-append commits + push to
   `mirror/3164-freezable-typedarrays`.
6. After push: liaison dispatches justice (the re-panel) next.

## Per-action authorizations

- Edit `src/freezable-typedarray-pony.js`, `src/pony-internal.js`,
  the test file, `permits.js`. Authorized.
- Add a new test or expand the placeholder test. Authorized.
- One or more regular-append commits + push to
  `endojs/endo-but-for-bots:mirror/3164-freezable-typedarrays`.
  Authorized.

## Not authorized

- Force-pushing.
- Un-drafting (justice or appellate does that at gamut end).
- Editing files outside the named ones.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--a259cb/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--a259cb/garden/roles/fixer/AGENT.md`
3. Other skills referenced just-in-time.

Project worktree at `project/` on `mirror/3164-freezable-typedarrays`
(head `984b5d4df`).

## Report

A `result` journal entry. Include:

- Per-item verdict (applied / partial / blocked).
- New head SHA + commit messages.
- Local gate exit codes.
- Whether the placeholder test was replaced with a real test
  that catches the bug from item 2.
