## Completion report: `endojs-endo-but-for-bots-pr513-rebase`

**Decision: no rebase performed — directive is a false-positive; deferred per its own source comment.**

### What the directive was
A watcher classified issue-comment 4800685785 on PR #513 as a `rebase` directive because the body contains the bare word "rebase." The comment is actually explanatory and ends: *"a subsequent rebase of this PR onto a fresh `llm` snapshot will pick it up. No action needed here until #528 merges."* That is a future/conditional mention, not a command.

### What I verified (GitHub state, independent of the untrusted comment body)
- **#528** (reconduct `@endo/cancel` onto `llm`) is still **OPEN and DRAFT** — the blocking precondition the comment names has not merged.
- **`@endo/cancel` is absent from both** live `llm` (tip `b898356`) and the PR's current frozen base `llm-44e3b17` — confirming the comment's root-cause claim (the package merged onto a frozen snapshot pre-*Unfreeze* discipline and was never conducted to trunk).
- **PR #513 does not depend on `@endo/cancel`**: not in `packages/pubsub/package.json` deps, source, or tests. The fixer's earlier "cancel missing" observation is tangential to #513's own mergeability.
- **#513 is MERGEABLE with green CI** (all checks pass; the only `pending` are in-progress macOS/ubuntu test jobs, no failures). `mergeStateStatus: UNSTABLE` reflects CI still running, not a failure.

### Why not rebase
Under the frozen-base model, trunk drift alone is **not** a reason to rebase — isolation from drift is the point. A rebase needs a reason; none exists here. It would re-trigger full CI, risk conflicts, still not add `@endo/cancel` (neither base nor live `llm` has it yet), and directly contradict the source comment's "wait for #528." So the job closes as a verified no-op.

### Follow-ups
1. **After #528 merges**, `@endo/cancel` lands on `llm`; if the maintainer later wants #513 current with trunk (before merge/ferry), a fresh rebase onto the new `llm` snapshot is the action — but it is optional for #513 since it doesn't use the package.
2. **Garden infra fix posted** as job `garden-comment-watcher-verb-imperative-gate`: `scripts/jobs/comment-watcher.sh` `classify()`'s fixed verb table matches `rebase|retcon|refresh|shepherd` as bare words with no imperative-cue gate, so verb-as-subject-matter fires directive jobs. This is the same class of bug commit 194b0a49 fixed for the *watchers* table; comment 4800685785 is the canonical case for the *fixed* table. The job asks to reuse the existing `reads_as_directive()` cue gate.

No worktree was created (read-only verification via `gh`/git refs). Inbox drained clean at close.

Self-improvement: nothing to land directly; routed the watcher-classification lesson as the posted garden-infra fix job rather than a role/skill edit, since it is a script bug, not a role norm.
