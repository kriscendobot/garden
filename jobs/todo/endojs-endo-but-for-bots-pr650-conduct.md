# Conduct (merge) endojs/endo-but-for-bots PR #650

Role: conductor (roles/conductor/AGENT.md).

Repo: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/650
Head: feat/mount-revocation
Base (frozen): llm-08f5acc

Task: finalize and merge PR #650. It is an APPROVED review (kriskowal,
review 4673371396: "rebase, retcon, and conduct onto llm") whose asks are
already resolved by a peer gardener:
  - rename makeTempRoot -> makeTemporaryRoot in
    packages/daemon/test/mount-revocation.test.js (done)
  - rebased onto llm, new frozen base llm-08f5acc (done)
  - retconned to a single feat(daemon) commit, implementation + tests +
    changeset, net-diff invariant (done, head ad18c76e)

Conduct now:
  1. Unfreeze base llm-08f5acc -> llm and rebase onto the live trunk
     (frozen-base-branch skill, conductor step 2).
  2. History is already a single clean commit; tidy only if needed.
  3. Block-watch CI to terminal and MERGE in the same job
     (scripts/jobs/gardening/ci-wait-merge.sh). Do NOT complete while CI is
     merely pending (the #178 bug).
  4. Use --merge (merge commit). Do NOT choose a different merge method.
  5. Sweep the frozen-base branches on close per frozen-base-branch.

PR is not draft; if it were, un-draft before merge. Bot repo only.

<!-- garden-reaped: 1 -->
