Inbox drained — one empty coordination ping from the peer, nothing actionable.

The job is complete: this PR-review directive was already fully satisfied by a concurrent peer before I could push. I correctly avoided clobbering it with duplicate churn. Final report follows.

---

**Completion report — job `endojs-endo-but-for-bots-pr548-7ad385cd` (attention directive on endo-but-for-bots PR #548)**

**Directive:** erights' review comment r3495960357 on the design `designs/inter-package-plain-re-exports.md`, anchored to the "Deprecation mechanism" open question: *"Just use an `@deprecated` JSDoc tag on the re-export."* This settles which of the three candidate mechanisms (JSDoc tag / lint rule / both) the first PR uses.

**Finding — already resolved by a concurrent peer.** This comment was part of a batch of three simultaneous erights review comments on the PR (r3495955062 `export *` scope, r3495957598 type-only re-exports, r3495960357 deprecation mechanism). A peer endolinbot gardener, working a sibling job, correctly folded all three into one fix and finished ~73 seconds before my push attempt:
- Commit **5055d0577** (already on `origin/design/inter-package-plain-re-exports`) converts all three "Open questions" into "Resolved questions", drops the per-export residual-value judgment from the `@endo/far` example, and records the `@deprecated` JSDoc tag as the settled mechanism.
- All three inline threads were replied to, including a direct reply to this job's comment: *"Done. The deprecation mechanism is now settled as an `@deprecated` JSDoc tag on the re-export; the lint-rule alternative is dropped. (5055d0577)"*
- A top-level summary comment was posted (2026-06-30T03:28:31Z).

**Action taken.** I independently produced an equivalent edit (local commit 40f3df969) before discovering the peer's already-pushed work on `git push` (rejected, branch behind). Rather than force-push redundant churn over landed, already-acknowledged work, I **abandoned my commit** and tore down my project worktree. No competing push, no double-posted comments. Nothing was changed on the PR or the branch by this job.

**What changed:** nothing — the directive was already satisfied. **Follow-ups:** none for the PR.

**Self-improvement:** The duplicate work arose because the comment-watcher spawns one "attention" job per review comment, so a single erights review of three comments on one PR became three separate jobs — and the fold-all-asks norm meant one gardener completing its job also completed the other two, wasting the parallel claims. Worth routing to the liaison: the job producer (comment-watcher) should batch multiple near-simultaneous review comments on the same PR into a single attention job, rather than emitting one per comment, to avoid redundant gardener fan-out.
