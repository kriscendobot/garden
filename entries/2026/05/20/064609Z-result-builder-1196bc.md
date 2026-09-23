---
ts: 2026-05-20T06:46:09Z
kind: result
role: builder
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/builder--1196bc/project
---

Implemented G16 from #231 (`designs/familiar-release.md` L405): smoke tests for the Primer-into-CAS packaged-build flow.

PR: https://github.com/endojs/endo-but-for-bots/pull/324 (DRAFT, base `llm`, head `test/familiar-primer-cas-smoke`, commit `628300c47`).

File added:
- `packages/lal/test/primer-cas-smoke.test.js` (317 lines, 4 serial AVA tests).

Tests added (all passing locally on the `lal` package's `yarn test`):
1. `familiar bundle step copies every lal/primer/ file into bundles/primer/` — per-file sha256 byte-identity check between `packages/lal/primer/` and `packages/familiar/bundles/primer/`.
2. `bundled primer contains the documents the agent loop references` — presence + non-empty check for `README.md`, `cli-reference.md`, `chat-reference.md`, and the four `howto-*.md` files the system prompt directs the LLM to read.
3. `host can checkin the bundled primer via storeTree + makeLocalTree` — spins up a fresh daemon, runs `makeLocalTree(bundledPrimer)` + `storeTree(localPrimerTree, 'lal-primer')` (the exact sequence `lal/agent.js`'s `runManager()` runs at startup), asserts the host can `lookup`/`identify` the resulting `ReadableTree`, and verifies `README.md` content round-trips through the daemon CAS unchanged.
4. `sub-guest receives the primer via storeIdentifier and can read it` — mirrors `provisionPrimer(guest)` from `agent.js`, asserts the guest can `lookup('primer')` to reach the tree, `list()` every bundled file, and read `README.md` / `cli-reference.md` content through the `lookup` + blob `text()` path.

Regression evidence: each of tests 1, 2, 4 was demonstrated to fail under controlled tampering of `bundles/primer/` (deleting `cli-reference.md` fails 1, 2, 4; mutating `README.md` content fails test 1's per-file sha256). Test 3 covers a path that is exercised by the daemon's own `endo.test.js` `storeTree` suite, so its meaningful regression is via integration coverage rather than a unique invariant.

Lint and format: `yarn lint:eslint` on the new file is clean (0 errors, 0 warnings on the added file; pre-existing warnings in `agent.js`, `providers/*.js`, `setup.js`, `test/simulator/*` are unchanged). `yarn format` applied prettier reformatting to the new file. `yarn lint:types` (tsc) has pre-existing failures in `providers/anthropic.js` that are unrelated to this PR (verified by `git stash`).

Scope discipline: the dispatch named `test/familiar-primer-cas-smoke off llm` and that is the base. The Primer-into-CAS code under test (`packages/lal/agent.js`, `packages/familiar/scripts/bundle.mjs`) only exists on `llm` (master has no `packages/lal` or `packages/familiar`), so the "design on roadmap, implementation on master" norm does not apply: the implementation surface itself is roadmap-only.

End-to-end Electron-launching smoke is deferred. It requires a display harness (xvfb on Linux CI) and would not catch any failure modes these four tests do not already cover. The design's G16 acceptance criterion ("observe the Primer tree appearing in the host namespace and the worker loop receiving a `primer` reference") is met by tests 3 and 4 in combination, modulo the Electron launch which is environmental rather than runtime-path-validating.

Self-improvement: nothing this time. The role file's *Modeled-on designs abbreviate their source* norm paid off: reading `lal/agent.js`'s `runManager()` before writing the tests surfaced the exact two-step `storeTree` + `identify` sequence that the smoke needs to mirror, rather than guessing from the design's prose. One small field observation: the `ensureBundledPrimer()` helper at module load is awkward (it runs `bundle.mjs` in a synchronous `execFileSync` on first invocation), and a cleaner shape would be either (a) a `pretest` script in `packages/lal/package.json` that runs `step:bundle`, or (b) a CI workflow change to chain `familiar-bundle -> test`. Both are out-of-scope for this PR; if the maintainer prefers (a) it would be a small follow-up. One incidence does not yet meet the self-improvement threshold; surfacing here for the reviewer's awareness.
