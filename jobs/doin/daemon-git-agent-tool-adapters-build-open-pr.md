---
posted_at: 2026-11-02T12:54:09Z
arc: minion-town-git-remote
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---

Open-the-PR relay for `daemon-git-agent-tool-adapters-build`. Host `oros-studio-garden-ce242c49` got a 403 on `createPullRequest` for endojs, so this runs on a host that can create the PR. The code is finished and pushed. Do not change either branch.

1. Get a project checkout: `scripts/jobs/ensure-project-worktree.sh daemon-git-agent-tool-adapters-build-open-pr endojs/endo-but-for-bots build/daemon-git-tool-paths`, and run the next step with that as your cwd.
2. Confirm on GitHub that head `build/daemon-git-tool-paths` is at `be6462bc2358d69e8f3cdf8cf2d89c21eeb19e11` and frozen base `llm-48d6f3e` is at `48d6f3e08bcc37fdd4c0dc8b85d1481ca861320c`. If either differs, stop and report it.
3. Write the text between the BODY markers below to a file, verbatim, then run this. The first argument is the ORIGINAL job's base, so the PR carries its marker:
   `scripts/jobs/gardening/ensure-pr.sh daemon-git-agent-tool-adapters-build endojs/endo-but-for-bots build/daemon-git-tool-paths llm-48d6f3e --title 'fix(exo-git): resolve diff and stash paths through the mount' --body-file <file>`
4. Confirm the PR is a DRAFT, and name its full URL in your completion report so the gauntlet is staged.

-----BEGIN BODY-----
Refs: designs/daemon-git-next-steps.md, designs/daemon-git-capability.md § Agent-Facing Tool Adapters

## Description

The agent tool adapters this job set out to build are already on `llm`: `makeGitTool`, `makeGitMountTools`, and `makeGitRemoteTool` expose `status`, `diff`, `add`, `commit`, `fetch`, `pull`, and `push`, and `provisionWorkspaceTools` composes them over a granted `Git` and `GitRemote` (#523, #616, #705, #707). This PR builds the one gap left against the adapter contract, which is that path inputs must become `EndoMountEntry` values at the boundary.

`add`, `restore`, and `checkoutConflict` already did that. `diff` and `stashPush` did not: their `paths` option went to git unchanged. The JSON `diff` tool reaches that option, and its schema described only an opaque options record, so a model had no way to discover `paths` either.

- `Git.diff` and `Git.stashPush` now resolve `paths` through the worktree mount, with the same helper `add` uses.
- The `diff` tool schema documents `cached`, `base`, `head`, and `paths`. It stays open, because the runtime guard is an open record and the divergence gate pins the two together.

Three identifiers in `json-tools/git.js` gain the full `_PROPERTY` suffix because the spell-out probe flags the lines this change touches. There is no behavior change in that rename.

### Security Considerations

Before this change, `diff({ paths: ['../x'] })` through the JSON tool returned git's `'../x' is outside repository at '<worktree host path>'`, which disclosed the host path to the model. An absolute spelling of a worktree file was also honored, so a model could confirm a guessed host path. Now `..` clamps at the worktree root, an absolute spelling is read as worktree-relative, and git never sees a path the mount did not produce.

This does not add deny-pattern enforcement to `diff`: an unscoped diff still covers the whole worktree.

### Scaling Considerations

Each path costs one extra `mount.entry()` call, which does no filesystem work.

### Documentation Considerations

Updates `@endo/exo-git`'s help text, the `@endo/agent-tools` README, and the implementation notes in `designs/daemon-git-capability.md`.

### Testing Considerations

New tests run the real tool, `Git`, mount, and git binary stack: path limiting, a deleted path, `..` clamping, an absolute spelling, root refusal with no host path in the error, and the reader facet. The `stashPush` paths are covered in `packages/daemon/test/git.test.js`. Restoring the pass-through makes both new integration tests fail.

Run on host `oros-studio-garden-ce242c49`, with `rerere.enabled=true` in its global git config:

- `packages/agent-tools`: `git-flow`, `git-tool`, `divergence`, `git-worked-loop`, `workspace`, `exports`, and the code-mode tests. The only failure is `makeGitTool derives the rewriter-facet catalog against a real Git cap`, which also fails on the unmodified base.
- `packages/daemon/test/git.test.js`: eight failures, all of which also fail on the unmodified base (`checkoutConflict`, `cherryPick`, `reword`, `status` merge conflicts, and `askpass`). I did not diagnose each one; the host's rerere setting explains at least the merge-conflict message mismatch.
- `packages/exo-git`: all pass.
- `lint:types` in `exo-git` and `agent-tools`, prettier and eslint on the changed files, and the pre-push probes pass. The repo-wide `lint:fix` did not finish within this host's time limit, so CI is the first full lint run.

### Compatibility Considerations

A `paths` entry that denotes the worktree root, such as `.`, is now refused, matching `add`; omit `paths` to cover the whole worktree. A `..` path that used to fail now clamps, and an absolute path now reads as worktree-relative. No caller on `llm` outside tests passes `paths` to either method.

### Upgrade Considerations

Replace `paths: ['.']` with no `paths` option.

<!-- garden-job: daemon-git-agent-tool-adapters-build -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
-----END BODY-----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-03T02:00:43Z
