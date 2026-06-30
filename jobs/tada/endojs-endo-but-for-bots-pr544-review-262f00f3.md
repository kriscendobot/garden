## Completion report — job `endojs-endo-but-for-bots-pr544-review-262f00f3`

**Scope.** erights' COMMENTED review `4597135096` on `endojs/endo-but-for-bots#544` (design: intra-package plain re-exports). The review body was empty; its sole inline comment was `3496049749` on `designs/intra-package-plain-re-exports.md` line 122: *"Not true. For the intra-package case, there is no such compat risk, since all such compat risks of concern are only inter-package."*

**Finding.** The flagged line (anchored against commit `50dae1166`) was the old draft's claim that the intra-package removal stage must be deferred for `endojs/endo` "until adequately confident there are no outstanding importers... in this repository or in others" — language wrongly borrowed from #548's inter-repo caution. **This was already fixed** by commit `99f1f7039` ("collapse staging — intra-package removal needs no deprecation or version bump"), pushed at 03:57Z by a peer gardener working the closely-related line-102 review (`4597123028`). The current doc now states intra-package pass-throughs are never on the published `"exports"` surface, so removal carries no inter-repo hazard and may merge into `endojs/endo` once ready/approved with no major-version deferral — fully resolving the line-122 point.

**Action taken.** No source change was owed (already landed). The line-122 thread had no reply, so I posted the inline acknowledgment citing `99f1f7039`: https://github.com/endojs/endo-but-for-bots/pull/544#discussion_r3496066276. No second top-level summary posted — the peer already posted one citing the same SHA at 03:58Z; another would be redundant noise.

**Coordination.** This job was a **duplicate**: gardener `179ea36a` (still alive) held an "attention" job for the *same* comment `3496049749` via the comment-watcher's review-comment path, while mine came via the review-body path. I messaged that peer to stand down on the reply before posting, avoiding a double-post.

**No commit/push** (no working-tree changes).

**Follow-up.** The garden's comment-watcher is still emitting paired jobs (review-body + review-comment) for the same underlying inline comment, and paired review-body/attention jobs (`51adc732`/`b359d8d2` for line 102, `179ea36a`/this for line 122) — four concurrent gardeners on one small PR. The recent HEAD commit "comment-watcher dedup inline review-comment vs review-body jobs" targets exactly this; these jobs predate/raced that dedup, so no new fix is filed, but the dedup's effectiveness is worth confirming on the next review burst.

**Self-improvement:** nothing this time — the duplicate-job class is already tracked by the recent comment-watcher dedup commit; coordinating via the inbox before the irreversible PR reply is the existing-norm behavior and it worked.
