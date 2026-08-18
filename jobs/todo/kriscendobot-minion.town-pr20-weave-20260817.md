---
role: weaver
tier: minion
model-burned: mentor
dispatch: automatic
fallback-tier: 
---

# weave (rebase to clear conflicts) on kriscendobot/minion.town PR #20

Handed off from the shepherd job `kriscendobot-minion.town-pr20-shepherd`.
A trusted maintainer APPROVED PR #20 on its current head, but the PR is now
`mergeable: false` / `mergeable_state: dirty` (merge_commit_sha is null): it
conflicts with `main`. Because GitHub does not create the synthetic merge ref
for a conflicting PR, `pull_request` workflows do NOT dispatch on new pushes, so
CI cannot be driven green until the conflict is resolved. This is a weaver task,
not a shepherd fix (roles/shepherd/AGENT.md § Conflicting PRs block CI dispatch).

PR: https://github.com/kriscendobot/minion.town/pull/20
Head: kriscendobot/minion.town @ feat/endo-daemon-guest-mcp-b5 (bot-pushable)
Base: main

Rebase the head onto the current `main`, resolve conflicts, and push. Once the PR
is mergeable again and CI re-dispatches, the shepherd/conductor chain resumes via
the event watcher / reconcile tick. Never link to upstream agoric/agoric-sdk.

<!-- garden-reaped: 2 -->
