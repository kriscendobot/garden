## Retro report: endojs/endo-but-for-bots #1116, review 5360612317

**Verdict: not a review miss (new direction).** The review process shouldn't have been expected to catch this feedback, so I recorded it as dismissed and dispatched no improvement job.

**Why:**
- **The gauntlet did run.** PR #1116 is a draft design PR (`designs/guest-native-invitations.md`). `journal/jobs/tada/2026/09/02–04` holds its full design gauntlet: the clean stage, panel rounds 1–6 and fix rounds 1–6. No evaluator was skipped or gamed.
- **The review answers the design's own open questions.** The design left five questions for the maintainer, and kriskowal's inline comments resolve them:
  - who may accept an invitation, with a guest account created automatically for a new user;
  - remove the leftover `@pins/guest-*` pin, since per-agent pins now cover it;
  - break ties the way CapTP does, by comparing formula identifiers;
  - invitation state must be durable in the formula store;
  - unreachable formulas should be collected promptly.
- **The rest is new direction or later change.** One item is a new request: a follow-up for minion.town guest-account coupons and rate limiting, which the review says this design doesn't need. The top-level ask is to reconcile the design with implementation work that landed after the Sept 2–4 gauntlet (#1305, #1306, #1310, and in-flight #1277 and #399). No panel could have seen that coming.
- **It doesn't fit the closest existing pattern.** The design raised the leftover pin as an open question instead of polishing it unquestioned, so the `vestigial-mechanism-unquestioned` cluster doesn't apply.

**What changed:**
- `review-misses/dismissed/endojs-endo-but-for-bots-pr1116-review-70b9d56c.md` is now on journal2 (the writer printed `recorded=… verdict=not-a-miss`). The record paraphrases the review and links to it; none of the review text is copied in.
- No cluster was touched and no builder job was posted. No garden code changed.

**Checked on GitHub, not just in the primary's report:**
- The primary job's work exists. The bot pushed commit `f7b82cba0` at 03:09Z and replied on the PR at 05:11Z. The reply asks two follow-up questions: whether to keep a returned `{status}` record rather than the thrown errors #1310 uses, and whether #1277 should drop its `hostPins`.
- **One gap:** I can't find the coupon/rate-limit follow-up job the review asked for. Searching the board's `jobs/` and `plan/` for "coupon" found nothing new, and the reply doesn't mention it. I messaged the maintainer inbox about it. It belongs to the primary loop, so I didn't post it myself.

**Follow-ups:** post the coupon/rate-limit follow-up job for minion.town guest accounts, unless the maintainer says it's covered elsewhere.

Self-improvement: nothing to change in the skill. The journal clone lock plus push races made the record write take about 11 minutes, which is the known oros-studio clone slowness, not something new.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1116-review-70b9d56c-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (891667 cached reads)
- Output: 6747 tokens
- Cost: $0.7536013999999999
- Wall-clock: 960s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
