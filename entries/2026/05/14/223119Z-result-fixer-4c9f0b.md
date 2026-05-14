---
ts: 2026-05-14T22:31:19Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - PR endojs/endo-but-for-bots#109
---

Dispatched per kriskowal's "Please fix and shepherd" to address the failing `test-ocapn-guile-interop` check on `894510bec` at PR #109. Dispatch hypothesis was that this was fallout from the `syrups` -> `syrup-frame` rename; that hypothesis is wrong.

**Root cause: sustained Guix substitute infrastructure outage.** Every run of `.github/workflows/ocapn-guile-interop.yml` since ~14:19Z today has failed, across `chore/eslint-numeric-separators-style`, `ci/no-npm-lifecycle-master`, and `feat/syrups-package`. Symptom in every failing log:

- `bordeaux.guix.gnu.org: connection failed: Network is unreachable`
- `ci.guix.gnu.org: server is somewhat slow` fetching `texinfo-6.8`
- Guile still compiling `goblins` modules (`inbox.scm`) when the workflow's 120s `sturdyref:` wait loop expires
- "Failed to read sturdyref from Guile host log", exit 1

The PR's matrix is otherwise fully green (lint, cover x3, test x14, ocapn-python, xs, test262, hermes, async-hooks, viable-release, browser-tests, build, check-action-pins) and the `894510bec` rename sweep is not implicated. The failing step (`Start Guile goblin-chat host`) runs before any Endo code does.

Actions taken:
1. Reproduced the failure once via `gh run rerun --failed 25887739382`; same failure mode at the same step.
2. Posted a top-level summary on PR #109 documenting the cross-branch evidence and naming the workflow-level mismatch (`timeout 300s` on Guile vs. 120s on the wait loop). Comment URL: https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4455252124.
3. Did not push any change to `feat/syrups-package`. Per fixer norms ("do not fix the system from inside the smoke PR"), the workflow hardening belongs on `master`, not on this PR's branch. The dispatch's "fix and shepherd" framing was correct: the work falls to a shepherd targeting `master`, after which this PR rebases and turns green.

Suggested shepherd brief: in `.github/workflows/ocapn-guile-interop.yml`, the `Start Guile goblin-chat host` step's wait loop is `for i in $(seq 1 120); do ... sleep 1; done`. The surrounding `timeout 300s guix shell ...` gives the underlying Guile process 5 minutes. Extending the wait to match the inner timeout (e.g. `seq 1 300`) absorbs a slow substitute fetch without changing semantics. Alternatives the comment in the workflow already hints at: `--no-substitutes` (slower but resilient) or wrapping the guix-shell in a retry. Recommend the shepherd land the wait extension as a focused commit on master with a brief paragraph describing the May 14 outage, then rebase #109.

PR is unchanged at `894510bec` on origin. No follow-up commits pushed; no review re-requested (CI is intentionally red awaiting upstream workflow fix).

Self-improvement: nothing this time. The dispatch was internally consistent; the hypothesis-was-wrong outcome is exactly the kind of finding a fixer is supposed to surface rather than force, and the existing operating norm ("do not fix the system from inside the smoke PR") already gave a clean answer.
