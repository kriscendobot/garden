## Completion report: comment-watcher-run-a-gauntlet-phrase

**Result:** fixed and pushed to `main2` as `c8792a8e760`. A comment like #1072's "Please run a gauntlet and then retcon." now records the gauntlet and parks the retcon to run after it. The watcher test passes 417/0. The mention-watcher and comment-latency tests also pass.

**What changed in `scripts/jobs/comment-watcher.sh`**
- **More gauntlet phrasings.** `gauntlet_phrase_present` now matches "run the gauntlet", "run a gauntlet", "run another gauntlet" and "run gauntlet". Like the old phrase, it counts wherever it appears in a comment, with no imperative-position check.
- **Gauntlet counts in the multi-part tally.** Before, "run a gauntlet … retcon" counted as one verb, which is why only the retcon survived.
- **"X and then Y" sequences.** This applies when a comment is from a trusted sender or @-mentions the bot. If the comment contains exactly two action verbs, both from gauntlet/rebase/retcon/refresh/shepherd, and the second comes after "then", the watcher:
  - handles X as it does today;
  - parks Y through `post-plan.sh --blocked --blocked-on <X-base>` with its proper role, and `unblock.sh` promotes Y when X reaches `tada/`. A staged gauntlet writes `tada/<base>` when it finishes, so the #1072 case works.

  Y's job name includes a hash of the comment, so an earlier finished job of the same verb can't swallow it. Y is parked before X is handled, so re-seeing the same comment still records the follow-up. If parking Y fails, the cursor stays put and the whole comment is retried. Sequences involving any other verb (for example "rebase, then refactor …") still go to a single `attention` job, as before.
- There is a new test override, `GARDEN_PLAN_POST`, defaulting to `post-plan.sh`.

**Tests** (in `scripts/jobs/test/comment-watcher-test.sh`)
- **GA1:** "Please run a gauntlet." records a gauntlet.
- **GA2:** the #1072 comment records the gauntlet, and the retcon is parked with `gate: blocked`, `blocked_on: …-pr1072-gauntlet` and `role: retcon`. No unblocked retcon or attention job appears, the comment is acked, and a second pass over the same comment is a no-op.
- **GA3:** "Rebase, then refactor the helper." still produces one attention job and no blocked follow-up.

**Things to know**
- **Behaviour change:** a trusted "Please rebase and run the gauntlet" (no "then") now becomes one attention job. Before, it became a gauntlet alone and the rebase was dropped.
- **Untrusted senders** with no @-mention still get only the first mechanical verb, which is unchanged.
- **Possible stuck follow-up (edge case):** X's own dedup check can hand it to a live job with a different name. The only case is a non-gauntlet X that another watcher already posted under its own job name for the same comment. Then Y's `blocked_on` points at a job that never finishes, and Y stays parked until someone promotes it by hand. Gauntlet-first sequences like #1072 can't hit this.
- **Flaky test:** in one of four runs the unchanged quote-reply test (BQ) failed because the stubbed source returned no comments. It passed in the other three runs, including on the final code.
- **Existing #1072 jobs:** the gauntlet and retcon that were posted by hand for #1072 already exist, so no further action is needed there.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/comment-watcher-run-a-gauntlet-phrase.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (2047696 cached reads)
- Output: 21137 tokens
- Cost: $1.6777432000000003
- Wall-clock: 616s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
