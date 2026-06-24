---
ts: 2026-05-20T04:07:00Z
kind: result
role: cleaner
worktree: dispatches/cleaner--509a31/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/301
---

# Cleaner pass for PR #301 (kriskowal-error-trace)

PR is the rebased + Node-22-fixed branch (error-trace aggregator + `endo trace` verb). Cleaner entered after the fixer's `be73bd002` ran CI 23/23 green; pushed one test-only commit (`ce8848585`) raising coverage on the new error-trace surface.

## Findings

### Diff-only scoping of pre-push gates

Confirming the judge's prior observation on PR #306 (`entries/2026/05/20/020226Z-result-judge-907068.md`): the pre-push gates' probes (`sentence-per-line-md`, `no-ascii-banners`, `no-pull-citations`, `no-inline-import-jsdoc`, `filename-no-stutter`) walk the whole repo rather than the PR diff when the project worktree is detached-HEAD (the probes' `git rev-parse --abbrev-ref --symbolic-full-name '@{u}'` fallback fails on detached HEAD and they default to scanning everything that grep matches). The cleaner manually scoped each probe to `git diff origin/llm...HEAD --name-only --diff-filter=AM` and confirmed that every gate finding the unfiltered run surfaces is either:

- pre-existing in unchanged regions of files this PR touches (`ws-relay.test.js` ASCII banners on the pre-existing tests at lines 37, 83, 106, 212, 235; `daemon.js`/`captp.js`/`marshal.js` inline-import jsdoc on pre-existing code), or
- a false positive for `no-pull-citations` matching the new `error:Endo#42` error-identifier syntax (the probe's `#<n>` pattern matches the error ID format introduced for this aggregator), or
- a pre-existing file path stutter (`daemon/src/daemon-*.js`, `chat/chat-bar-component.js`) untouched by this PR.

No pre-push-gate finding traces to a line this PR introduced; the cleaner did not push gate-driven corrections.

### Coverage pass

Two packages with substantive new source. One package per engagement applied as a soft norm; both daemon and cli touched here because they share the error-trace surface and the gaps were small.

**daemon** (new files: `src/trace-aggregator.js`, `src/networks/network-marshal-save-error.js`):

| Before | After |
|---|---|
| 95.54% stmts / 77.89% branches | 96.12% stmts / 80% branches |

- `+2` tests on `test/trace-aggregator.test.js`:
  - `lookup forwards compartmentId when present on the record` (covers main-report `compartmentId` spread at line 374)
  - `clear by workerId also drops aliases targeting that worker` (covers alias-cleanup loop at line 432-433)
- Remaining uncovered lines (`215-216`, `225-227`, `320-321`) are byte-budget eviction edge cases and the "target survived but a cause was evicted" path. Tricky to test without contortion; left as-is per `skills/coverage-driven-testing/SKILL.md` "contortion is a smell, not a target".
- `network-marshal-save-error.js`'s catch block (lines 46-50) is defensive against `E.sendOnly` synchronously throwing, which it does not under normal conditions; the existing `survives a rejected reportTrace without throwing` test exercises the receiver-side rejection path. Left uncovered.

**cli** (new files: `src/error-trace.js`, `src/commands/trace.js`):

| Before | After |
|---|---|
| 70.85% stmts / 54.54% branches | 93.42% stmts / 82.53% branches |

- `+1` test on `test/trace.test.js` (`endo trace text-mode renders --stats, --recent, lookup, and usage hint`): a single daemon-startup test exercises the `formatReport` helper, the stats/recent/lookup text branches, and the usage-hint exit path. Raised `commands/trace.js` from 53.62% / 54.54% to 84.78% / 70.83%.
- `+1` new file `test/error-trace-format.test.js` with 7 unit tests for `printTraceReport` (annotations, causes, partial flag, compartmentId), `extractErrorId` (side-table-vs-SES-tag, undefined edges), and `markErrorPrinted` / `isErrorPrinted` idempotency. Raised `src/error-trace.js` from 82.07% / 54.54% to 99.05% / 89.74%.
- Stderr capture uses `process.stderr.write` rather than `console.error` stubbing because SES freezes `console`; documented inline.

### Regression-evidence verification

Every new test verified per `skills/regression-evidence/SKILL.md`: temporarily broke each targeted code path (compartmentId spread, alias cleanup loop, stats text label, top-level annotations block) and confirmed the test fails. All confirmed load-bearing.

### Dead code

No dead-code deletion warranted; the new error-trace surface is freshly introduced and every export has at least one consumer in `daemon.js` / `worker.js` / `endo.js`.

### Chat package

`packages/chat/error-trace.js` (257 LOC, consumed by `chat-bar-component.js`, `eval-form.js`, `connection.js`) was deferred. Same structural shape as the cli version, but the chat package's test surface is mostly component / e2e tests and `formatTraceReport` produces DOM-rendered output. Two-package scope per engagement applied; a future cleaner pass could close the chat gap if a maintainer surfaces a need.

## Commit and push

- Commit: `ce8848585` (`test(daemon,cli): expand error-trace coverage with formatter and edge-case tests`) — single test-only commit per cleaner-skill discipline; no production code touched; no `yarn.lock` churn (no new dependencies).
- Push: `git push origin HEAD:kriskowal-error-trace` succeeded (`be73bd002..ce8848585`).
- CI on the cleaner HEAD `ce8848585`: **partial — 10/23 SUCCESS, 0 FAILURE, 4 IN_PROGRESS, 9 QUEUED** at the time of this writing (50+ minutes after push). GitHub Actions runners are heavily saturated; the test matrix jobs (`test (20.x|22.x|24.x, ubuntu-latest|macos-15)`, `cover`, `viable-release`, `test-xs`, `build-wasm`, `check-action-pins`, `familiar-bundle` already SUCCESS) are still working through the queue. **No failures so far**. The cleaner verified locally that the new tests pass on the cleaner's host (`yarn ava` on the touched files in both `packages/daemon/` and `packages/cli/`); the matrix runs on CI would catch a Node-version-specific issue but the new tests use no Node 22/24-specific features and the daemon trace-aggregator tests are SES-pure.

## Judge-readiness

- PR is in draft (correct; cleaner does not un-draft).
- CI on the cleaner HEAD: **partial green** (10/23 SUCCESS, 0 FAILURE, 13 still running). The judge should re-verify CI on `ce8848585` before un-drafting; if any of the test matrix jobs surface a failure, the cleaner's tests are the likely suspects to inspect (`packages/daemon/test/trace-aggregator.test.js`, `packages/cli/test/trace.test.js`, `packages/cli/test/error-trace-format.test.js`).
- No `must-fix-loop` items in the cleaner's own report; the judge dispatch can proceed after CI converges, OR proceed immediately and re-check at panel-write time.

## Self-improvement

The diff-only scoping gap in `skills/pre-push-gates/SKILL.md` is now confirmed by two independent observers (judge on PR #306, cleaner on PR #301). Worth landing as either:

- a `--diff-only` flag on the driver that resolves the base branch from the PR (cleaner can read `gh pr view <N> --json baseRefName` to know the base), and threads the resolved base into each probe's environment so the probe's `git diff` against a real ref works on detached HEAD; or
- a per-probe convention that the probe accepts a `BASE_REF` env var the driver populates.

Either fixes the silent "scan-the-whole-repo" failure mode that fires whenever the worktree is detached. Routing as `message: cleaner → gardener` would normally be the path, but the gardener's queue is already growing on this topic; instead recording here in the result for the liaison to triage on read.

Self-improvement: noted in result body; no role / skill file written this engagement (the gap is in `skills/pre-push-gates/SKILL.md` and the fix is structural enough to warrant gardener authorship).
