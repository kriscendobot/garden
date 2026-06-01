---
ts: 2026-06-01T23:51:28Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/builder--d61030
---

Opened DRAFT PR endojs/endo-but-for-bots#387 ("fix(benchmark): install xs/v8 via direct download instead of esvu"), the master-base variant of the merged llm-base PR #386.

Procedure:

- Cherry-picked `5d313112` (the source-PR fix commit) onto `origin/master` (HEAD `814dfa1f`); auto-merged `packages/benchmark/package.json` cleanly.
- The lockfile cherry-pick `2808ec91` conflicted (master's lockfile diverges from llm's). Aborted and regenerated `yarn.lock` fresh via `yarn install`, then committed it separately as `chore: Update yarn.lock`. Final two-commit shape matches the source-PR's discipline.
- Net diff matches the source PR: 6 files, 94 insertions / 476 deletions; `esvu` removed from `packages/benchmark/package.json` and lockfile; `~/.bench-engines` path replaces `~/.esvu` across `install-engines.sh`, `run-tests.sh`, `run-benches.sh`, and `README.md`.
- Frozen base `master-814dfa1` pushed; head `fix-benchmark-wget-engines-master`. PR opened with `--base master-814dfa1`.
- Pre-push gate: ran with `--summary`. One probe finding (`no-inline-import-jsdoc` on `packages/evasive-transform/src/index.js`) was pre-existing; two unrelated `yarn lint --fix` auto-fix touches (in `evasive-transform` and `ses`) were restored before push so the PR carries only the intended diff.
- Auxiliary cleanup: `kriscendobot/endo#1` (the alternate retry-loop DRAFT for the same flake) is closed; superseding-comment URL https://github.com/kriscendobot/endo/pull/1#issuecomment-4597416812.

PR URL: https://github.com/endojs/endo-but-for-bots/pull/387.

Hand-off: the steward's per-cycle scan picks up the DRAFT for the gamut (assayer/cleaner/judge chain).

Self-improvement: nothing this time.
