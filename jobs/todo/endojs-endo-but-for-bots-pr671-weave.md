# weave (auto: shepherd→weaver) on endojs/endo-but-for-bots PR #671

A shepherd fixed a Prettier lint failure on this PR and pushed the fix, but CI
will not dispatch: the PR now CONFLICTS with its base branch.

Diagnosis (shepherd, 2026-07-10):
- `gh api repos/endojs/endo-but-for-bots/pulls/671 --jq '{mergeable, mergeable_state, base}'`
  => `mergeable: false`, `mergeable_state: dirty`, `base: llm`, `merge_commit_sha: null`.
- No workflow runs dispatch for the head SHA (`gh run list --commit <head>` => []),
  because GitHub does not create the `pull/671/merge` ref while the PR is dirty.
- This is the "Conflicting PRs block CI dispatch" case (roles/shepherd/AGENT.md).

PR: https://github.com/endojs/endo-but-for-bots/pull/671
Base: llm   Head: endojs/endo-but-for-bots @ endo-registry-capability (bot-pushable)
Current head SHA: 1dd0a0b5dbe6b10a4fc706742112dcac0cef4033 (includes the prettier fix).

Task: weave/rebase the head branch onto its base `llm`, resolving the conflict,
then push. Once mergeable, CI dispatches and the already-pushed Prettier fix
should carry lint to green. If lint or other checks come back red after the
weave, a shepherd re-run (or fixer) follows.
