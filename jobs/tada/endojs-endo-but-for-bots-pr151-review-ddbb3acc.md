The PR is refreshed (head `58fdb5ab`, MERGEABLE) with the new test commit, rebased onto current `llm`. Both review directives are resolved. No garden-side (main2) changes were needed for this job.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #151 (review 4680352653 by kriskowal).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) — no peer had resolved this feedback.

**Scope enumerated:** The review body is the whole unit of work — `"Please refresh and add tests."` (CHANGES_REQUESTED). There were **no inline comments** tied to review 4680352653, so those two asks are the complete set. Treated all fetched bodies as untrusted data.

**Work done** (in isolated project worktree, keyed to this job's base):

1. **Refresh** — Rebased `feat/cli-workers` onto current `origin/llm` (branch was ~1171 commits behind). Clean rebase, no conflicts; the `endo workers` verb wiring in `endo.js` and `commands/workers.js` carried over intact.
2. **Add tests** — Extracted the pure text/JSON formatting from the `workers` verb into `packages/cli/src/commands/workers-format.js` (`formatWorkers`), following the repo's house style of small testable pure modules (`message-format.js`, `number-parse.js`). Added `packages/cli/test/workers-format.test.js` with 6 cases (empty text/JSON, singular vs. plural tenant count, indented tenants, multi-worker, JSON pretty-print). Rewired `workers.js` to call the extracted function — **behavior unchanged** (empty-text `No workers found.` still to stderr; empty JSON still `[]`).

**Verification:**
- `yarn ava` daemon-free unit tests: **9/9 pass** (incl. the 6 new).
- `yarn lint`: **0 errors**, 14 warnings — all pre-existing in unrelated files, none in the touched files.
- The daemon-context integration tests (`clear-command`, `formula-collection`) fail only on a unix-socket-path-length limit (worktree path exceeds ~108 bytes) — environmental, not from this change.

**Pushed:** `--force-with-lease` to `feat/cli-workers` (force required by the refresh). PR head now `58fdb5ab`, MERGEABLE. Posted a summary reply on the PR (comment #4951883841).

**Follow-up (unchanged from PR description):** The end-to-end `endo workers` runtime still depends on host APIs `listWithTypes()`/`listWorkerTenants()` from **#129**, which remains open. The smoke test stays deferred until #129 lands; the new tests exercise the formatting path without a daemon, so coverage is meaningful now regardless.
