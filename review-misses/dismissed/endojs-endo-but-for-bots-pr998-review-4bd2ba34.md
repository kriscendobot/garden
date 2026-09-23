---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr998-review-4bd2ba34
verdict: not-a-miss
category: new-direction
review_at: 2026-08-18T15:29:39Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/998#discussion_r3805530298
identity: endojs/endo-but-for-bots#998:review:4962829909:retro
---

Inline reply by kumavis on the ironhorse store-seam PR #998, on the weak-collection
mark branch in `interp.rs`: it acknowledges an earlier weak-collection finding and
declares that ephemeron marking is DELIBERATELY deferred — the strong-marking of
WeakMap/WeakSet entries is now a named decision, documented by a code comment at the
site and pinned by the `weak_collection_entries_are_retained_conservatively`
(gc_machine) test whose bounds flip when the ephemeron pass lands. The direction is
declared safe (weakly-held objects retained, never freed while live) at the cost of
bounded leakage until ephemerons exist.

Grounds: this is new-direction/scope, not an indictment of the garden's review
process. Two independent reasons, both world-grounded rather than trusting the
primary report. (1) The garden never reviewed this PR: #998 is an upstream
kumavis-authored PR (35 commits, head `claude/endor-ironhorse-store-roadmap`, base
`llm`, now MERGED) that the garden only WATCHES — there is no build, gauntlet, or
panel job for #998 anywhere on the board (jobs/tada holds only the comment-watcher
`review-*` directives), so no garden seat or gate engaged this PR's code and there is
no garden review "miss" to charge. (2) Even setting that aside, the comment is not a
defect report; it is a deliberate, documented, test-pinned SCOPE decision first
stated in the thread — ephemeron marking is explicitly out of this store-seam PR's
scope, with the limitation named, bounded, and pinned. Nobody's review could
"anticipate" a maintainer's forward-looking scope boundary; that is taste/scope, the
dismissal category. Moreover the underlying correctness concern WAS caught in
review — by Copilot's parent finding (comment 3805377949) — and resolved as accepted
scope, so the review that mattered here did fire and the outcome was intentional, not
missed. No evaluator-gaming shape: nothing routed around a gate (the garden ran no
gate to route around) and no measurable check was moved while its purpose stood; the
strong-marking decision is openly documented and test-pinned rather than hidden.

Primary-deliverable check (per the retro's world-grounding directive, since the
primary claimed a resolution): NOT a false-peer no-op. The primary posted a
confirming thread reply plus a reactji and asserted both artifacts exist at the
merged HEAD. I verified against `llm` directly: the pinning test
`weak_collection_entries_are_retained_conservatively` is present in
`rust/engine/ironhorse-snapshot/tests/gc_machine.rs`, and `interp.rs` carries the
ephemeron site comment referencing that test by name. Both deliverables genuinely
exist; no discrepancy to report.

First #998 retro judged; a dismissal mints no cluster and trips no threshold.
