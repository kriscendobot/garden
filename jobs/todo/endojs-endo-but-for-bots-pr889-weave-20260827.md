---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# weave directive on endojs/endo-but-for-bots PR #889

Map: **weave** → rebase the PR head onto its base and resolve conflicts.

Repo: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/889
Head branch: design/exo-git-follow-root-advancement (base: llm)

PR #889 ("docs: Design exo-git root advancement follower") is APPROVED and CI is
green on its head, but mergeable_state is `dirty` (CONFLICTING with base `llm`).
Rebase the head onto origin/llm, resolve conflicts (docs-only design PR), push
with --force-with-lease, and confirm CI reconverges to green. If it was left
draft only because of the conflict, it can be un-drafted once green and mergeable.
