Both follow-up jobs are on the board. Note: the fresh-PRs job body references comment id `4849708600`, but the authoritative id for erights' 02:26 directive is `4849705813` (URL: https://github.com/endojs/endo-but-for-bots/pull/572#issuecomment-4849705813); the job body carries the verbatim quote + exact timestamp (2026-07-01T02:26:04Z) so it's unambiguous, and the consumer is instructed to re-check the live thread. My scoped work is complete.

---

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #572 (erights comment 4849713366).

**Directive:** erights (full maintainer authority) asked why #572 is still draft, judged it qualifies for "Ready for review," and asked to change status if we agree.

**Assessment:** #572 is a design-only PR (`designs/README.md`, `designs/bytearray-uint8array-view.md`). Its own body explicitly deferred un-drafting to "the maintainer's call after review." After 13 rounds of erights review — with Design Decisions 3–7 resolved (restrictive whole-buffer span, withdraw-and-open-fresh disposition, approved helper naming) and the #429 / endo-but-for-bots#57 / endojs/endo#3226 closures folded in — that gate is met. Agreeing was correct.

**Actions taken:**
1. **Un-drafted #572** → now `isDraft: false` (Ready for review). Verified.
2. **Replied to erights** on the thread (comment 4849722680) — confirmed agreement, explained the draft gate was the maintainer-review deferral now satisfied, and flagged two follow-ups so nothing drops. (Reply, not a silent reactji, per the maintainer-comment norm.)

**Follow-ups posted to the job board (neither was previously tracked):**
- `endojs-ebfb-fresh-bytearray-view-impl-prs` — erights' *other* 02:26 directive on the same thread ("where are these fresh PRs… please write them"): open the fresh view-based implementation PR(s) seeded from `feat/narrow-bytearray-to-uint8`, targeting the #572 design of record, and reply with links.
- `endojs-ebfb-pr572-weave-readme-conflict` — #572 is `mergeStateStatus: DIRTY` / `CONFLICTING` against base `llm` (a `designs/README.md` doc-only conflict); weave/rebase to clear it. This is a mergeability concern separate from review-readiness, so it did not block un-drafting.

**Follow-up note:** the fresh-PRs job body cites comment id `4849708600`; the authoritative id is `4849705813` — corrected here; body quote+timestamp are exact and the consumer re-checks the live thread, so no board edit was risked.

**State:** inbox empty; no code changes in this worktree (all work was GitHub-side + job-board posts).
