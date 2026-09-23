This was an **attention/routing** job — no code change required, so nothing to push to `main2`. Report below.

---

## Completion report: attention directive on endojs/endo-but-for-bots #548 (comment 4860688337)

**Directive (re-fetched, treated as untrusted data).** erights (a maintainer) replied to kriscendobot's offer: *"Rather than use separate PRs as slices, just use separate commits in PR #590 as slices. Go ahead and do all of them in #590."* A companion comment (4860697264) adds the same for #591: do all removal slices as commits in #591.

**What the directive asks for.** Extend the existing stacked pair rather than open new PRs. In **#590** (non-breaking repoint+deprecate stage), add the remaining inter-package plain-re-exporter slices the PR body already enumerates — `@endo/marshal` (`export * from '@endo/pass-style'` + `deeplyFulfilled`), `@endo/captp` (`export * from '@endo/marshal'` + `Nat` from `@endo/nat`), `@endo/patterns` (`FullCompare` type; deprecate-only) — each as its own commit, following the same recipe used for the `@endo/far` slice. Then rebase #591 and add the matching removal slices.

**Routing decision.** I found the live peer **gardener 87** (`ebfb-pr548-inter-package-re-exports-mechanical-repoint-remove-followup`, in `doin/`) is the sole author/owner of both #590 and #591. Two agents pushing the same branch would collide, so I did **not** post a parallel board job or start the work in my worktree. I routed the directive to that owner via `inbox-send` (deterministic `GARDEN_MSG_ID=route-4860688337` for idempotency). The message is a self-contained spec (per-slice recipe, all import forms, `@deprecated` + workspace-dep discipline, separate-commit + separate yarn.lock discipline, verification + summary-comment expectations, and the sibling #591 directive folded in so the stacked pair stays coherent).

**Delivery confirmed.** Landed in the peer's live inbox (`inbox/ebfb-pr548-…/route-4860688337`). If gardener 87 completes before reading it, `inbox-send`'s dead-letter fallback promotes the intent into a fresh board job, so the directive is not lost either way.

**Follow-ups / notes.**
- The sibling directive for **#591** (comment 4860697264) has **no** board job of its own yet. I folded it into the routed message; if a separate attention job later spawns for it, it should be recognized as already-owned by the same peer to avoid a duplicate branch owner.
- No `main2` change; no upstream endojs/endo contact (bot-fork work, direct push). Inbox drained clean; nothing pending.
