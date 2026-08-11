---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# weave (rebase onto llm to clear conflict) — endojs/endo-but-for-bots PR #903

PR #903 (`feat(sha256): platform-neutral SHA-256, unblocking the XS daemon
bundle`; head branch `pr824-endo-sha256`, base `llm`) is **APPROVED** by
kriskowal on its current head (2026-08-11T21:46Z) but is
`mergeable: false` / `mergeStateStatus: DIRTY` (CONFLICTING) against base
`llm`, with `merge_commit_sha: null`. Because the merge ref cannot be built,
GitHub dispatches **no CI** on the head (`gh pr checks 903` reports "no checks
reported"), so a shepherd cannot drive CI green until the conflict is cleared.

Rebase the PR's commits onto current `origin/llm`, resolving conflicts by
reading both sides (no blind `--ours`/`--theirs`), preserving net diff
(`git range-diff`), and `--force-with-lease` push to `pr824-endo-sha256`.

PR: https://github.com/endojs/endo-but-for-bots/pull/903
Head: endojs/endo-but-for-bots `pr824-endo-sha256` (bot-pushable)

Once mergeable and CI dispatches, a shepherd/conductor follows (the approval
reconciler will re-dispatch, or a green run triggers the event watcher).
Never link to upstream agoric/agoric-sdk.
