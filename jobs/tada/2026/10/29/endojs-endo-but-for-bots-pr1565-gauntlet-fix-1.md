## Fix round 1 report: endojs/endo-but-for-bots#1565

I applied all the must-fix and should-fix items from panel-1 (review 5695174146: packager, warden, integrator and pruner). CI is green: all 36 checks pass after one rerun.

**Pushed** to `build-daemon-git-next-steps-structured-diff` as follow-up commit `607db6f010` (`fix(exo-git): address panel review on structured diff`), via `safe-push-pr-head.sh`:
- **Restored `harden(GitRebaseStartInputShape)`** in `packages/exo-git/src/interfaces.js`. This was the blocker raised by both warden and integrator.
- **Design doc (`designs/daemon-git-capability.md`):**
  - Reverted the unrelated `→`/`…` glyph changes (four spots).
  - Updated the `GitFileDiff` sketch in § Structured Result Shapes to match what shipped: `oldPath`/`newPath` strings and an `'unmerged'` status.
  - Shortened the "In progress" note to point at that sketch. `GitDiffHunk` and its lines already matched the shipped shape.
- **Changeset (`.changeset/git-structured-diff.md`):**
  - Added migration guidance: callers switch to `diffText` for the old string, and custom `GitBackend`s must return `GitDiff` from `diff` and add the required `diffText`.
  - Raised `@endo/agent-tools` to `major`, since its `diff` tool output changes shape.
  - Added `@endo/agentry: patch`.
  - Cut the paragraph that narrated the implementation.
  - `@endo/floot` is `private: true`, so it gets no entry. The PR body says so.
- **Comment trims:**
  - In `native-git-backend.js`: shortened the `diff` JSDoc, dropped the last sentence of the `diffArguments` JSDoc, and shortened the `--end-of-options` comment.
  - In `git.js`: dropped "(callers can use either)".
- Prettier is clean, and ESLint on the touched files shows no errors.

**PR metadata** (via `gh pr edit`):
- The title is now `feat(exo-git)!: …` to mark the breaking change.
- I cut the body from about 900 words, following pruner's list: removed the roadmap history, the consumer bullets, the per-package test tallies and the duplicated remaining-slices list. I kept the regression evidence, the rerere note and the compatibility section. Its compatibility section now says three packages get a major bump.

**CI:** the first run had one red leg, `test (24.x, macos-15)`. The failure was the uncaught exception in `test/restore-context.test.js`, the known `claude-sandbox` macOS flake that also hits other PRs. This PR doesn't touch that package. After `gh run rerun --failed`, `ci-wait-merge.sh` returned rc 0 with 0 of 36 failed.

**Follow-ups:**
- The panel's comment-only suggestion to narrow the `diff`/`diffText` options guard (currently `M.recordOf(M.string(), M.any())`) is left for the locksmith or a later round.
- The driver posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1565-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2827931 cached reads)
- Output: 12353 tokens
- Cost: $1.4936942000000004
- Wall-clock: 4838s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
