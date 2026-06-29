# Rebase kriscendobot/agoric-sdk PR #7 onto master

**Repo:** `kriscendobot/agoric-sdk` (BOT FORK; base+head both on the fork).
Hard scope line: **never** touch upstream `agoric/agoric-sdk` — no upstream links/comments.

**PR:** https://github.com/kriscendobot/agoric-sdk/pull/7
- title: *fix(internal): XS-safe hex decoding table (bounded loop) + Bufferish codec validation*
- head: `fix/internal-hex-bufferish-validation`  →  base: `master`  (same-repo branch, not cross-fork)
- current state: **MERGEABLE** (no merge conflicts) but **UNSTABLE** — failing the `test-codegen` CI check.

**Task (weaver/rebase):** rebase the head branch `fix/internal-hex-bufferish-validation`
onto the current tip of the fork's `master`, resolve any conflicts that arise, and
force-push-with-lease to update the PR. Confirm CI re-runs after the push.

**Context / sequencing:** the `test-codegen` failure on #7 (and #6) is caused by a stale
generated `packages/orchestration/src/fetched-chain-info.js` on `master`; a sibling job
`agoric-sdk-fork-regen-fetched-chain-info-master` is opening a PR to regenerate it on
master. If that regen has already merged to `master` when you rebase, #7 will pick up the
fix and `test-codegen` should clear. If it has NOT merged yet, the rebase still refreshes
#7 onto master, but `test-codegen` may remain red until the regen lands — that residual
failure is expected and is NOT a rebase defect; note it in the handoff rather than chasing it.
