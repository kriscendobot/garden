All 24 checks pass — CI is fully green. The PR is a draft and the job carries no authorization to comment on the external repo, so per External-repo etiquette I won't post a green-run summary comment.

## Completion report

**Job:** shepherd (auto: red CI) on endojs/endo-but-for-bots PR #637 — drive CI to green.

**What was red (head `b0020ffacb`):**
- `CI / lint` — FAILURE
- `CI (docs-only) / lint` — FAILURE
- `CI / test (24.x, macos-15)` — FAILURE

**Diagnosis:**
- Both `lint` failures shared one deterministic root cause: Prettier flagged two files added by the AWS-storage design commit — `packages/daemon/test/aws-emulator.js` and `packages/daemon/test/daemon-database-aws.test.js` (`Code style issues found in 2 files`).
- The `test (24.x, macos-15)` failure was a flake: `@endo/chat#test` failed only on that one matrix leg (passed on 22.x/24.x ubuntu and 22.x macos), accompanied by a spurious post-cleanup `node24 … No such file or directory` runner error — no real defect.

**What I did:**
- Got an isolated project worktree, `yarn install`ed, reproduced the exact Prettier failure, then ran `prettier --write` on the two files. Verified `prettier --check .github packages` reports "All matched files use Prettier code style". The diff is whitespace-only reformatting (a multiline ternary and an object literal wrap).
- Committed as an atomic `chore(daemon): prettier-format aws storage test files` and pushed to the PR head branch `design/endo-daemon-aws-storage` (new head `71d655d299`).

**Result:** The re-triggered CI run (https://github.com/endojs/endo-but-for-bots/actions/runs/28938952045) completed **success**. PR #637 rollup is now **24/24 SUCCESS, zero failures** — both `lint` checks green, and the previously-flaky `test (24.x, macos-15)` passed on re-run, confirming it was a flake.

**Notes:** No comment posted — the PR is a draft and the auto-dispatched job carried no per-action authorization to comment on the external repo. No escalation needed; CI is green (`next: none`).
