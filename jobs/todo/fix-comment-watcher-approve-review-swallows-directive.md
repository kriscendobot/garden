---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: an APPROVED review's text directive is swallowed by the approval→conduct path

On 2026-08-31T23:03:36Z kriskowal left an APPROVED review (id 5072222392) on
`kriscendobot/minion.town#60` with body `Post a builder.` — a plain-language
directive to post a builder job for the design's next step.

`scripts/jobs/comment-watcher.sh` processed this review but treated it purely as
an approval signal: it posted `kriscendobot-minion.town-pr60-conduct` (a
merge/re-verify job, index key `kriscendobot/minion.town#60:comment:5072222392`)
and never extracted "build" as an actionable verb from the review body. No
builder job was ever posted by the watcher for this directive. (A correctly
scoped builder job for the design's step 1 — `minion-town-remote-guest-endo-cli-endo-invite-primitive`
— did get posted the same day and eventually shipped `endojs/endo-but-for-bots#1125`,
but that job was hand-posted by a liaison/human reading the merged design, not
by the watcher's verb table. The gap surfaced when kriskowal followed up on
2026-09-03 asking to link the build PR, having apparently never seen one
referenced anywhere.)

Root cause (to confirm while fixing): the watcher's review handling likely
special-cases an APPROVED review as a pipeline-op (merge/conduct) before or
instead of running the verb table against the body text, so a review that is
BOTH an approval AND a directive ("approve, and also post a builder") only
acts on the approval half. Compare against how a CHANGES_REQUESTED review's
body is scanned for verbs — an APPROVED review's body should get the same
verb-table treatment, additive to (not instead of) whatever approval-driven
conduct/merge handling already fires.

The fix: make verb extraction from a review body run independently of the
review's approval state, so an APPROVED review whose body also names a verb
(build, rebase, retcon, shepherd, etc.) posts BOTH the state-driven job (if
any) and the verb-driven job, deduped the normal way by directive identity.
Add a regression test reproducing this exact case (an APPROVED review body
containing a bare imperative verb sentence) alongside the existing verb-table
and pipeline-op-only tests in `scripts/jobs/test/comment-watcher-test.sh`.

Garden repo work on `main2` (normal worktree, push CAS, no PR). Report the
confirmed root cause and the fix in your tada.
