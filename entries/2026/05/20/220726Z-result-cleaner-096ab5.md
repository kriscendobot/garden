---
ts: 2026-05-20T22:07:26Z
kind: result
role: cleaner
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/cleaner--be1be5/project
---

Cleaner step of the gamut for PR #326 (kumavis's "feat: add
@endo/remote-fs and @endo/9p-server"). Cross-author dispatch
authorized explicitly by `@kriskowal` at 2026-05-20T21:38:02Z.

## State on arrival

- PR #326, branch `feat/remote-fs-and-9p-server` on `endojs/endo-
  but-for-bots`, base `llm`, DRAFT, MERGEABLE.
- Pre-cleaner CI: all required jobs green; `cover (24.x)` pending
  on the inherited HEAD.
- Substantial assayer-shaped work already on the branch:
  - `4825ee23c refactor(remote-fs): factor shared helpers,
    BlobRef, and lock-table out of the three Filesystem
    implementations`
  - `35c1cac14 feat(remote-fs): add reference CAS consumer +
    CapTP transcript tests for cache hit/miss`
  - `d9bf9a266 review: address third batch of Copilot feedback
    on PR #326` (landed mid-cleaner; rebased onto cleanly).
- Cleaner respected kumavis's design and the prior assayer's
  shape; only added test-only coverage.

## Coverage baseline (pre-cleaner) and delta

`c8` was invoked via the `@endo/exo` workspace's bin, since
`@endo/remote-fs` and `@endo/9p-server` don't ship a `test:c8`
script. The CI's per-package `cover` job runs `yarn test:c8` per
workspace; these two packages currently no-op there. Adding a
`test:c8` script and the `c8` devDep is a packager-shaped change,
out of scope for the cleaner; surfaced here for the panel /
follow-up.

`@endo/remote-fs` (all files):

| Surface     | Before  | After   |
| ----------- | ------- | ------- |
| Statements  | 84.08%  | 85.42%  |
| Branches    | 76.73%  | 79.50%  |
| Functions   | 65.33%  | 68.40%  |

Per-file gains:

| File                     | Stmts before to after | Funcs before to after |
| ------------------------ | --------------------- | --------------------- |
| `src/cas.js`             | 96.42% to 100%        | 87.5% to 100%         |
| `src/shared/blobref.js`  | 93.22% to 100%        | 75% to 100%           |
| `src/shared/helpers.js`  | 96.91% to 100%        | 100% to 100%          |
| `src/shared/lock-table.js` | 96.63% to 100%      | 83.33% to 100%        |
| `src/readonly.js`        | 83.11% to 96.10%      | 62.22% to 82.22%      |

`@endo/9p-server` baseline (no cleaner-side test additions):
88.39% stmts, 63% branches, 94.33% funcs. Large gaps in
`server.js` (83.83% stmts, 55% branches) are mostly 9P protocol
error paths that would need a stateful mock-client harness to
exercise. Out of scope for this cleaner round; deferred to a
follow-up cleaner or a panel finding.

## Commit added

One commit, test-only, pushed to `feat/remote-fs-and-9p-server`:

`059fcac6c test(remote-fs): cover shared helpers, cas edge
cases, readonly attenuator` (370 insertions; one new file
`packages/remote-fs/test/shared-helpers.test.js` with 35 tests).

## Surfaces covered

- `rangesOverlap`: unbounded-b branch, both-unbounded, adjacent-
  bounded half-open semantics.
- `assertChildName`: non-string, empty, reserved (`.` / `..`),
  separator (`/`, NUL).
- `computeOpenMode`: every mode-derivation branch.
- `toSafeNumber` (the bigint-boundary helper added by the
  third-batch-of-Copilot-feedback commit): bigint in-range,
  negative-bigint reject, past-MAX_SAFE_INTEGER reject, number
  safe-integer accept, non-integer / negative / NaN / Infinity
  reject, non-bigint-non-number reject.
- `makeNotSupported`: bound ENOSYS factory plumbs the backing
  description through the message.
- `makeLockTable`: invalid-type reject, undefined / empty opts
  reject, default start / length, never-locked probe returns
  null, shared lock visible to probe, `Lock.help` body and
  method-arg fallback.
- `makeMemoryCas`: `has()` before and after `put`, `put` with
  non-string algorithm, `get` with non-string hash.
- `readOnly`: `Filesystem.named` forwards and attenuates (via
  `namespace`), `getQid` synchronous forward on Directory and
  File, `help(method)` fallback on every attenuator surface,
  `Directory.list` cursor read-through.
- `BlobRef.help`: default body and method-arg fallback.

## Regression-evidence spot-checks

Each of three representative new tests was confirmed to catch a
break in its target:

- `rangesOverlap: b unbounded` test fails when the b-unbounded
  branch is broken to `return false`.
- `cas: put with non-string algorithm rejects` test fails when
  the `keyOf` validation is short-circuited to `if (false)`.
- `readOnly: Filesystem.named forwards` test fails when the
  attenuator's `named()` ignores its argument.

Per `skills/regression-evidence/SKILL.md`, each new test would
break under the change it's intended to pin.

## Dead-code review

No dead code identified for deletion this round. The lower-
coverage files (`from-mount.js` at 76% stmts, `node-fs.js` at 79%,
`compose.js` at 83%) have a recognizable shape: protocol-error /
adversarial-mock paths (qid-type detection fallthroughs,
Mount-stream error handlers, `emptyFilesystem` mutation rejections)
that warrant test coverage rather than deletion. None of them
satisfy the four-criteria threshold (no live caller in src, no
cross-package caller, no `@import`, not on the exports map);
they're reached by the public API and are out-of-scope for this
cleaner round.

## Lint / format

- `yarn lint:prettier`: clean.
- `yarn workspace @endo/remote-fs run lint`: zero new errors;
  one pre-existing `@jessie.js/safe-await-separator` warning
  pattern in the test file (consistent with the rest of the test
  directory's pattern).
- All 166 `@endo/remote-fs` ava cases pass (was 131; 35 new).
- All 18 `@endo/9p-server` ava cases unchanged and passing.

## Push and CI

Pushed `059fcac6c` to `origin/feat/remote-fs-and-9p-server`. CI
re-running; pre-cleaner state was green on all required jobs.

## Judge-ready signal

The cleaner is done. PR #326 is ready for the **code panel** per
`skills/pr-creation-flow/SKILL.md` § Cleaner placement. The PR
remains in DRAFT; un-draft is the judge's responsibility after
the jury-fixer loop terminates.

## Self-improvement

`packages/remote-fs/package.json` and `packages/9p-server/
package.json` don't ship a `test:c8` script, so the monorepo's
`cover` CI job is a no-op for these packages. Surfacing as a
potential **packager**-seat finding rather than landing the
script in this cleaner pass (which would mix test-shape work
with package-config work).

Self-improvement: nothing this time.
