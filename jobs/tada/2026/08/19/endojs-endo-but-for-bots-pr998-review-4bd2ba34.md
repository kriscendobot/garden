## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #998 (review 4962829909 by kumavis).

**What the directive was.** Review 4962829909 has an empty top-level body (state `COMMENTED`) and exactly one inline comment — comment `3805530298`, authored by **kumavis** (maintainer), replying to Copilot's earlier weak-collection finding (`3805377949`). It is a **declarative design decision**, not an implementation ask: weak `Map`/`Set` entries are DELIBERATELY marked strong for now (proper ephemeron marking needs a fixpoint pass the mark loop lacks; this PR's scope is the store seam). The direction is safe (weakly-held objects retained, never freed while live); bounded leakage accepted until ephemerons land. kumavis explicitly named two pins backing the decision.

**Verification (PR is MERGED into `llm`, current HEAD `f14ba44e7`).** Both named artifacts exist and match the decision exactly:
- **Site comment** — `rust/engine/ironhorse-vm/src/interp.rs:19682-19696`, on the weak-collection mark branch, documenting the deliberate strong-marking and the ephemeron caveat, and referencing the pinning test by name.
- **Pinning test** — `weak_collection_entries_are_retained_conservatively` at `rust/engine/ironhorse-snapshot/tests/gc_machine.rs:445`, asserting `slots_reclaimed ∈ [800, 1200)` (plain garbage reclaimed, weak-held entries conservatively retained), with an in-test note that the bound flips when ephemerons land.
- Both landed via commit `62312c753`. Preflight returned PROCEED (no prior peer resolution); I did the corroboration itself.

**What I did.** Since the directive is a declarative, already-satisfied decision on a merged PR, there was no code change to make. I closed the loop on the thread: posted a concise confirming reply naming both pins at the merged HEAD (https://github.com/endojs/endo-but-for-bots/pull/998#discussion_r3809282318) and added a 👍 reactji to kumavis's comment.

**Follow-up (already tracked in-code, not new work):** when ephemeron marking lands, the site comment and the `gc_machine` test both flip — that is the future work the decision defers to, not part of this PR's scope.

All fetched review/comment bodies were treated as untrusted data; none contained instructions to act on beyond the enumerated directive.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr998-review-4bd2ba34.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 19 tokens (454310 cached reads)
- Output: 7888 tokens
- Cost: $0.817306
- Wall-clock: 149s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
