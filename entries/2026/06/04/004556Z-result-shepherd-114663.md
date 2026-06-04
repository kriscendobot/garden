---
ts: 2026-06-04T00:45:56Z
kind: result
role: shepherd
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/shepherd--114663
prs:
  - repo: endojs/endo-but-for-bots
    pr: 418
    role: target
refs:
  - entries/2026/06/04/004159Z-dispatch-liaison-114663.md
  - https://github.com/endojs/endo-but-for-bots/pull/418#issuecomment-4617941453
next: weaver
---

# result: shepherd — #418 nine failures all stale-base, weaver hand-off

## Head and scope

- PR: endojs/endo-but-for-bots#418, DRAFT
- Branch: `fix/endo-make-node-evasive-runtime` at `0bbf4e8ec`
- Base: `llm-720a396` (frozen snapshot)
- Current `llm` head: `2bd9e0cbb` (PR base lags by 19 commits)

## Per-failure classification

All 9 failures resolve to two repairs that landed on `llm` after `llm-720a396` was frozen. No refactor-induced regression from fixer `091a1a`'s evasive-parser injection is in evidence.

### 1. lint (CI workflow) — stale-base

Job `79424271629`.
Log path (mid-job): `.garden-monitor/pr418/lint.log:3501-3503`:

```
packages/bytes: SECURITY.md differs from canonical
  (sha256 071c74499d6d695e590ea3816ab579cb2e40639adcf7cf75e2702c732071f41d
       vs d9acd9c238af1e13acd1ee0f8020dc542a579a828d70520f9829b6496ecc4e97)
packages/hex:   SECURITY.md differs from canonical (same hashes)
##[error]Process completed with exit code 1.
```

Eslint pass itself is clean: `✖ 2159 problems (0 errors, 2159 warnings)`. Failure is the post-eslint step `bash scripts/check-security-md.sh`. The canonical fix is `032d88462 fix(bytes,hex): resync SECURITY.md to canonical GitHub spelling`. `git merge-base --is-ancestor 032d88462 HEAD` reports NOT in HEAD.

Classification: **stale-base**.

### 2-7. test (20.x/22.x/24.x × ubuntu/macos), 6 shards — stale-base (same root cause)

Jobs `79424271678`, `79424271684`, `79424271718` (ubuntu) and `79424271690`, `79424271681`, `79424271727` (macos).

Sample from `test (20.x, ubuntu-latest)`, log `.garden-monitor/pr418/test-20-ubuntu.log:2730-2740`:

```
@endo/cjs-module-analyzer:test
file:///…/node_modules/.store/emittery-npm-2.0.0-eaad50ff39/package/index.js:780
    .filter(result => result.status === 'rejected')
TypeError: results.values(...).filter is not a function
    at Api.emit (…/emittery-npm-2.0.0-eaad50ff39/package/index.js:780:5)
##[error]@endo/cjs-module-analyzer#test: …exited (1)
```

The `test (24.x, macos-15)` variant surfaces the downstream `AssertionError: null == true` from `ava-virtual-51e10ba6e6` vs `ava-virtual-7620442f7d` (two distinct ava virtual stores resolving in parallel) at `.garden-monitor/pr418/test-24-macos.log:3621-3650`. Same root cause: two `ava` installations under `.store/ava-virtual-*` sharing emittery state.

Canonical fix is `608809998 fix(deps): dedup ava to a single virtual store` (adds `"resolutions": { "ava": "8.0.1" }` to root `package.json`), folded into the cleanup PR `9d826ce81 fix(ci): repair the base-wide CI reds on llm from the master→llm merge (#414)`. Neither in HEAD.

The job aborts at the first cjs-module-analyzer ava run, so daemon-side tests (the surface the fixer's evasive-parser refactor touched) never execute. No evidence that the refactor is implicated.

Classification: **stale-base**.

### 8-9. cover (20.x, 24.x ubuntu) — stale-base (same root cause)

Jobs `79424271608`, `79424271605`. Log `.garden-monitor/pr418/cover-20-ubuntu.log:434`:

```
TypeError: results.values(...).filter is not a function
```

Same ava-duplication shape as the test matrix.

Classification: **stale-base**.

## Action taken

- Pulled job logs for 4 representative failures (lint, test 20.x ubuntu, test 24.x macos, cover 20.x ubuntu).
- Verified `032d88462` and `608809998` are absent from `0bbf4e8ec` via `git merge-base --is-ancestor`.
- Verified `origin/llm` now at `2bd9e0cbb` contains both via `git log origin/llm-720a396..origin/llm`.
- Posted classification comment on #418: <https://github.com/endojs/endo-but-for-bots/pull/418#issuecomment-4617941453>.

No source changes pushed. No CI re-runs queued (a re-run on the same head would reproduce the same reds because the fixes are not in the base).

## Escalation

**`next: weaver`** — rebase #418 onto refreshed `llm` to fold in `032d88462` (SECURITY.md resync) and `608809998` / `9d826ce81` (ava-resolution dedup). The base-branch convention for this branch is `llm-720a396` (frozen snapshot) per `garden/skills/frozen-base-branch/SKILL.md`; the weaver decides whether to advance the snapshot to `llm@2bd9e0cbb` or rebase onto `llm` directly. Both routes resolve all 9 failures.

No refactor regression in evidence; the fixer's `091a1a` push does not need attention from `next: fixer`. If post-rebase CI surfaces a daemon test failing in the refactor surface that did not run today, that is a separate dispatch.

## Self-improvement

Nothing this time. The shepherd role's diagnosis recipe and the `pr-ci-watch` skill both held up cleanly on a stale-base case; the `feedback_shepherd_to_fixer_auto_chain.md` memory's `next: <role>` discipline is the right shape for this kind of two-cause split.
