Empty inbox. Work complete.

## Completion report

**Confirmed root cause.** The comment source (`comment-source-gh.sh`) prefixes every review body with leading state markers — `[APPROVED] `, `[CHANGES_REQUESTED] `, `[INLINE-REVIEW] ` (each `"[WORD] "`). Those markers push any bare imperative out of **clause-initial** position, and `imperative_verb_present` keys strictly on the start of the body / a sentence boundary. So `[APPROVED] Rebase.` did **not** read as a rebase directive, and `[APPROVED] Post a builder.` read as neither imperative nor a named verb. In `classify()`'s `pr-review-body` branch, an APPROVED review with no detected asks falls straight to `VERB=finalize` — so a review that was **both** an approval and a directive acted only on the approval half. That is exactly `kriscendobot/minion.town#60` review 5072222392 ("Post a builder.", 2026-08-31): the watcher posted `…-pr60-conduct` and never posted a builder. I verified the regex behavior empirically (`[approved] rebase.` fails to match; `rebase.` matches).

The special-casing the job hypothesized is real but slightly different from "approval checked before the verb table": the verb table *was* being run on the approved body — it just couldn't see through the marker prefix.

**The fix** (`scripts/jobs/comment-watcher.sh`):
- In `classify()`, strip the leading run of `"[UPPER] "` state markers into a `scan`/`lc` pair (mirroring the source's own strip) and run all directive/verb/imperative detection against the stripped text, while the approval-state detection (`inline`/`cr`/`approved`) still reads the **raw** body's markers. Verb extraction is now **additive** to the finalize handling: an approval carrying a directive routes as one whole-review job, whose body already carries the "APPROVAL bundled with asks → finalize after" note (so it resolves the directive *and* finalizes).
- Added `post` to `OPEN_DIRECTIVE_VERBS` so the exact "Post a builder." phrasing reads as a directive.

**Regression tests** (`scripts/jobs/test/comment-watcher-test.sh`, cases YA/YB): an `[APPROVED] Post a builder.` review and an `[APPROVED] Rebase.` review each route to exactly one whole-review job (never a bare conduct), the review body retains the finalize-after note, and the rebase directive is recorded. Full suite: **349 passed, 0 failed** (existing clean-approval→finalize cases T–Y unaffected — `[APPROVED] Looks great, ship it.` still finalizes). `bash -n` clean; `shellcheck -S error` clean.

Committed and pushed to `main2` (`a87eeaf91e`) on the first CAS attempt.

**Follow-ups:** none required. Minor note: adding `post` means a trusted review opening with a hyphenated compound like "Post-merge, …" would now over-route to a review job instead of a direct finalize — a safe-direction over-mint (a gardener reads it), consistent with the watcher's existing err-toward-attention posture.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-comment-watcher-approve-review-swallows-directive.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (2997854 cached reads)
- Output: 32322 tokens
- Cost: $3.848608
- Wall-clock: 637s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
