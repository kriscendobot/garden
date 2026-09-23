---
ts: 2026-06-03T05:00:35Z
kind: result
role: shepherd
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 343
    role: target
refs:
  - entries/2026/06/03/045453Z-dispatch-liaison-797060.md
  - https://github.com/endojs/endo-but-for-bots/pull/343
  - https://github.com/endojs/endo-but-for-bots/pull/343#issuecomment-4609224477
---

# result: shepherd — #343 CI diagnosis (10 failures, all stale-base-induced)

## Summary

All 10 failing jobs on PR #343 (head `89d68e71e`) classify as
**stale-base-induced**. The PR base `llm-b1c3f4d` predates the recent
bots/llm sync to `actual/master`; the current `origin/llm` head
`720a39600` carries both fixes the failures need.

`next: weaver` — rebase #343 onto a refreshed frozen-base snapshot
`llm-720a396`. Same recovery shape as #388 and #394.

## Per-failure classification with log evidence

The check_run rollup for PR #343 has 25 entries. 15 are green (lint
in CI-docs-only, build, zizmor, test in CI-docs-only, familiar-bundle,
sandbox-drivers, test-async-hooks, test262 20.x/24.x, test-hermes,
check-action-pins, viable-release 20.x/24.x, test-ocapn-python,
build-wasm). 10 are FAILURE, all completed; no still-running checks.

### Group A: makeClient import error (9 jobs)

Run `26789453121`, jobs:

- lint (`78972445515`)
- test (20.x, ubuntu-latest) (`78972445594`)
- test (20.x, macos-15) (`78972445609`)
- test (22.x, ubuntu-latest) (`78972445589`)
- test (22.x, macos-15) (`78972445583`)
- test (24.x, ubuntu-latest) (`78972445591`)
- test (24.x, macos-15) (`78972445631`)
- cover (20.x, ubuntu-latest) (`78972445522`)
- cover (24.x, ubuntu-latest) (`78972445548`)

Shared root cause:

```
packages/ocapn/test/netlayer-tcp-syrup.test.js:7
  import { makeClient } from '../src/client/index.js';
  SyntaxError: The requested module '../src/client/index.js' does not
  provide an export named 'makeClient'
```

The lint job surfaces the same as `import/named`:

```
##[error]    7:10  error    makeClient not found in '../src/client/index.js'
```

Verified on the frozen base: `git show b1c3f4dca:packages/ocapn/src/client/index.js`
exports only `makeOcapn`, not `makeClient`. The test was renamed by
endo PR #349 (commit `2ecf40ed8`, "fix(ocapn): port netlayer-tcp-syrup
test from makeClient to makeOcapn"), which is on `origin/llm`
(`720a39600`) but not on `llm-b1c3f4d`. On `720a39600` the test imports
`makeOcapn` from `../src/client/index.js`, matching the export.

PR #343's own diff does not touch `packages/ocapn/`. The failure is
pure base inheritance. Classification: **stale-base-induced; resolves
by rebase onto refreshed llm snapshot.**

### Group B: test-xs install-engines failure (1 job)

Run `26789453121`, job `78972445532`.

```
yarn workspace @endo/benchmark run install-engines
Installing engines...
Error installing XS or V8:
...
XS ❯ Downloading https://github.com/Moddable-OpenSource/moddable/releases/download/8.1.1/xst-lin64.zip
XS ❯ Extracting /tmp/esvu-dccf6f4869bc84bd65bf149067f9eda6
esvu ✖ Some engines were not installed.
...
V8 ❯ Installing version 15.1.4
##[error]Process completed with exit code 1.
```

The frozen base uses esvu to download XS and V8 binaries; the esvu
fetch fails on current GitHub Actions runners. endo PR #3294
(commits `04083b872` and `ba26f4cdb`, "fix(benchmark): install xs/v8
via direct download instead of esvu") replaces the esvu path with
direct downloads. PR #3294 is on `origin/llm` (`720a39600`) but not on
`llm-b1c3f4d`.

Classification: **stale-base-induced; resolves by rebase onto refreshed
llm snapshot.**

## Diagnosis verification

- Frozen base `llm-b1c3f4d` exposed test imports `makeClient`; client
  index.js exports only `makeOcapn`. Confirmed by `git show
  b1c3f4dca:packages/ocapn/test/netlayer-tcp-syrup.test.js` and `git
  show b1c3f4dca:packages/ocapn/src/client/index.js`.
- Current `origin/llm` head `720a39600` has the test importing
  `makeOcapn` and the install-engines step using direct downloads.
  Confirmed by `git show 720a39600:packages/ocapn/test/netlayer-tcp-syrup.test.js`
  and `git log b1c3f4dca..720a39600` showing `2ecf40ed8` (#349) and
  the #3294 fix commits.
- PR #343's own diff (head `89d68e71e` over base `llm-b1c3f4d`) is
  the `design(gateway): overarching @endo/gateway package` commit
  plus base. It does not touch `packages/ocapn/` or
  `packages/benchmark/`.

## Action taken

- **Classification comment posted to PR #343** at
  `https://github.com/endojs/endo-but-for-bots/pull/343#issuecomment-4609224477`,
  enumerating per-job root cause and naming the recommended rebase
  target. Authorized by dispatch brief § Per-action authorizations.

## Action not taken (and why)

- **No CI re-runs.** None of the failures are operational flakes
  covered by a retired shepherd-ignore broadcast; same-failure
  re-enqueues would burn API budget without changing the outcome.
- **No source edits.** Not authorized (per dispatch brief § Not
  authorized). The fix lives at the rebase layer, not in the PR diff.
- **No rebase.** Weaver work; not authorized for the shepherd.
- **No un-draft / re-draft.** Out of shepherd scope.

## Escalation

`next: weaver`. Rebase #343 onto a fresh frozen-base snapshot
`llm-720a396` (origin/llm head `720a39600`). Per the
`frozen-base-branch` skill pattern: create the snapshot branch off
`720a39600`, set #343's base to `llm-720a396` via the GitHub PR-edit
API, and rebase the design commit `41b1d400f` onto it. Per
memory `feedback_shepherd_to_fixer_auto_chain.md`, this verdict is
the authorization for the steward to auto-dispatch the weaver next
cycle.

Same recovery shape as #388 and #394 (per dispatch brief). #343 is
the foundation layer; fixing it unblocks the entire phase-2 through
phase-10 gateway-package stack.

## Worktree / push

No project-side commits. Project worktree was read-only consultation
(`git show <sha>:<path>` to verify the diagnosis hypothesis against
both bases). The dispatch root will be torn down by the orchestrator
on return.

Self-improvement: nothing this time.
