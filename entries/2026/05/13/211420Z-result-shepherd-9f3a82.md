---
ts: 2026-05-13T21:14:20Z
kind: result
role: shepherd
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/shepherd--pr-126-ci--20260513-204047--1f8d1f/project
---

PR #126 (`ci/no-npm-lifecycle`) shepherd-through-CI completion.

Pre-dispatch state: PR head 15c9833f6, 5 failing checks on the 2026-05-09 CI run (lint, test (24.x, macos-15), viable-release (18/20/24.x, ubuntu-latest)).

Diagnosis: all five failures were base-branch-staleness, not anything introduced by this PR's workflow-YAML edits.

- `lint`: TS2694 on `packages/daemon/src/daemon-node-powers.js:421` (`ED25519KeyPairKeyObjectOptions` removed from `@types/node` `crypto` namespace). Fixed on `llm` by #214 (the type annotation is now `{}`).
- `viable-release (*, ubuntu-latest)`: TS2345 on `packages/ocapn/src/netlayers/tcp-test-only.js:137` (`socket.on('data', ...)` payload now typed `string | Buffer`). Fixed on `llm` by #227 (now cast `/** @type {Buffer} */ (data)`).
- `viable-release (18.x, ubuntu-latest)`: matrix entry already removed on `llm` by #232 (`chore(ci): drop Node 18 from CI matrix`); after rebase, the 18.x row no longer exists.
- `test (24.x, macos-15)`: 524 tests passed with `1 unhandled rejection` exiting the daemon test workspace. This was the same stale-base condition; the rebased run passed `test (24.x, macos-15)` cleanly.

Fix: single rebase of `ci/no-npm-lifecycle` onto `origin/llm` HEAD (68246ad92a). No conflicts; the two workflow-YAML commits (`922eda37c`, `82ef4ec4c`) replayed clean.

Push: force-with-lease 15c9833f6...82ef4ec4c → `origin/ci/no-npm-lifecycle`.

Final CI rollup on 82ef4ec4c: SUCCESS=24, no FAILURE / CANCELLED / IN_PROGRESS. Green CI workflow run: https://github.com/endojs/endo-but-for-bots/actions/runs/25825337334.

Top-level comment posted with green-run URL: https://github.com/endojs/endo-but-for-bots/pull/126#issuecomment-4445258165.

Re-requested review from `kriskowal` via `gh api .../requested_reviewers`; response confirmed `requested_reviewers: ["kriskowal"]`. PR is back in kriskowal's review queue.

Self-improvement: when a PR has been sitting for days with the failing CI run pre-dating recent base activity, the cheapest first action is `git diff <PR-head> <base-tip> -- <failing-file>` against the base branch tip, not `--log-failed` triage of the stale run. Worth a one-line note in the shepherd role's operating norms about "rebase first when the failing run is older than the base's most recent commit." Will not file a structural message; flagging here for the next shepherd dispatch on a stale PR.
