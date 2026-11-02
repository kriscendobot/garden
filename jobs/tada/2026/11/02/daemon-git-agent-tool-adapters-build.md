---
handed-off: daemon-git-agent-tool-adapters-build-open-pr
deliverable-complete: false
---
**The code is finished and pushed, but the draft PR isn't open yet.** This host got a 403 on `createPullRequest`, so I posted `daemon-git-agent-tool-adapters-build-open-pr`, pinned to `endolin-garden-ece02cb4`, to open it. `post-job.sh` reported success, but the job file wasn't in my local `journal/` checkout's `todo/` or `doin/` when I looked right after, so I haven't seen it on the board.

## The gap
The adapters already exist on `llm`: `makeGitTool`, `makeGitMountTools` and `makeGitRemoteTool`, composed by `provisionWorkspaceTools`. They cover all seven verbs (#523, #616, #705, #707), so I built only what was missing.

Path conversion at the boundary was missing for `diff` and `stashPush`, which passed their `paths` option straight to git. Through the JSON `diff` tool, `../x` returned `'../x' is outside repository at '<host path>'`, exposing the worktree's host path to the model. An absolute path to a worktree file was also honored.

## What changed
Branch `build/daemon-git-tool-paths` is at `be6462bc2`, on frozen base `llm-48d6f3e`:
- **Path handling:** `Git.diff` and `Git.stashPush` now resolve `paths` through the mount, as `add` does. `..` clamps at the worktree root, and an absolute path is read as worktree-relative.
- **Compatibility change:** a path that means the worktree root, such as `.`, is now refused; omit `paths` to cover the whole worktree. No non-test caller on `llm` passes `paths` to either method.
- **`diff` tool schema:** it now documents `cached`, `base`, `head` and `paths`. It stays open because the divergence gate requires it to match the open runtime guard.
- **Rename:** `PATHS_PROP` and `CONFLICT_SIDE_PROP` became `*_PROPERTY` because the spell-out probe flagged the lines I touched; behavior is unchanged.
- **Docs and release notes:** updated the help text, README and design notes, and added a changeset (minor for `@endo/exo-git` and `@endo/agent-tools`).

## Test results
- **New tests:** integration tests run the real tool, `Git`, mount and git stack, and a schema test covers the `diff` options. With the old pass-through restored in `diff` and `stashPush`, both integration tests fail.
- **Remaining failures, all also on the unmodified base:**
  - `agent-tools`: 1, the rewriter catalog test in `git-flow`.
  - `daemon/test/git.test.js`: 8 (`checkoutConflict`, `cherryPick`, `reword`, `status` conflicts, `askpass`).
  - I didn't diagnose them individually. This host's global `rerere.enabled=true` accounts for at least one merge-conflict message mismatch.
- **Passing:** all of `exo-git`, `lint:types` in `exo-git` and `agent-tools`, prettier and eslint on the changed files, and the pre-push probes. Two scoped reruns after the last edits were narrower: the `agent-tools` rerun covered `git-tool`, `git-flow` and `divergence`, and the last rename was followed only by `git-tool` and `divergence`.
- **Not completed:** the repo-wide `lint:fix` in the pre-push gates hit the time limit and was killed, so CI will be the first full lint. The PR body says so.

## Follow-ups
- **PR and gauntlet:** the successor job opens the draft PR with this job's marker, and its completion should stage the gauntlet.
- **Unscoped `diff`:** it still covers the whole worktree, so mount deny patterns don't limit it. This PR doesn't change that, and the PR body says so.
- **Possible overlap:** draft #1589 changes `workspace.js` and provisions Fae and Lal. It doesn't touch the files this PR's code changes are in, but it may need a look if the two land close together.
- **Stale roadmap:** `daemon-git-next-steps.md` still reads as if the adapters are open work, and `daemon-agent-tools.md` Phase 3.5 still lists `add` and `checkoutConflict` under `makeGitMountTools`. I left both as they are.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/daemon-git-agent-tool-adapters-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (3726160 cached reads)
- Output: 38658 tokens
- Cost: $2.8203680000000007
- Wall-clock: 4405s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
