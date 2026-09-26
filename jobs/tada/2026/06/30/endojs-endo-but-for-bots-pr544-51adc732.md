Inbox empty, scratch worktree removed, remote branch tip confirmed at the landed fix `99f1f7039`. Job complete.

---

## Completion report

**Job:** attention directive from erights on endojs/endo-but-for-bots PR #544 (review comment `r3496039719`, plus a follow-on `r3496049749` on the same thread), on `designs/intra-package-plain-re-exports.md`.

**The directive (treated as data):** Reread #548's latest two-PR shape — #544's design description didn't match it. But #544 is accidentally an improvement: for the intra-package case the two #548 stages collapse into one because internal removals cause no inter-package compat problems, so #544 can skip the deprecation step and version bump. The follow-on comment corrected a specific line: the cross-package "don't merge into `endojs/endo` until no outstanding importers" caveat is "Not true" intra-package, since all such compat risks are inter-package only.

**What I did:** Set up a project worktree off the #544 branch and revised the design doc to collapse the staging, drop the deprecation step + version bump, reframe the #548 relationship, and remove the false inter-repo merge caveat. On push, the CAS was rejected: a **concurrent `endolinbot` worker had already landed the equivalent fix** (commit `99f1f7039`, ~03:57–03:58 UTC) — a job-board content race on the same review thread.

**What I verified rather than duplicated:** The landed `99f1f7039` fully and slightly more thoroughly addresses **both** erights comments:
- Staging collapses #548's two mechanical stages into one repoint-and-remove pass; deprecation step and major version bump both dropped.
- The inter-repo merge caveat (the exact line flagged by `r3496049749`) is corrected — removal carries no inter-repo hazard and may merge into `endojs/endo` once ready, with the local-only correctness obligation spelled out.
- A comprehensive inline reply to `r3496039719` and a top-level summary comment were posted; both explicitly acknowledge the third comment's merge-caveat point. The PR description was updated to match.

**My duplicate commit was never pushed** (rejected, rebase aborted), so no remote cleanup was needed. I deliberately did **not** post an additional inline reply to `r3496049749` — its substance is already explicitly answered in two places, and another comment would be redundant noise on the maintainer's thread, contrary to external-repo etiquette.

**Net change to the world from this job:** none needed — the directive was already satisfied. Scratch worktree torn down; inbox empty.

**Follow-ups:** none. PR #544 remains a draft pending erights' review of the rule; no source modules move.

**Self-improvement:** For "attention" jobs derived from a review comment (which bypass the gardening state machine's claim-CAS-per-PR-stage), a sibling job can race the same directive. Cheap front-loaded *content* dedup — check the branch's recent commits and the comment thread's existing replies for the directive's signature **before** doing substantive edits — would avoid redundant work the push-CAS only catches at the end. Borderline for encoding; noting it here for the gardener/job-board skill rather than routing a `message` to the liaison.
