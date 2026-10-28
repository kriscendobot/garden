## Completion report: endojs-endo-but-for-bots-pr1349-fix-maintainer-review

The one open item in the maintainer's changes-requested review is fixed. PR #1349's new head is `991f8af47e`, and all 15 checks pass there.

**What was outstanding**
- The changes-requested review from kriskowal (2026-10-08) and their 2026-10-27 comments all had replies. Most were done; one had come undone.
- kriskowal asked for a narrower Chromium range than "before 138" (r4392486550). `91cca8a551` added the measured range, but a later panel follow-up, `fe74338e19`, removed it from the changeset. Both guides and the `tame-text-codecs.js` comment also still said "before 138". So the reply saying it was fixed no longer matched the code.

**What I changed** (one commit pushed to `build/hardened-text-codecs-shim`)
- `991f8af47e` `docs(ses): restore the measured Chromium codec range (#1349)`
- It touches `.changeset/hardened-text-codecs-encapsulated.md`, `packages/ses/docs/guide.md`, `docs/guide.md` and `packages/ses/src/tame-text-codecs.js`.
- These now state the tested results: Chromium 120, 126, 127, 133, 136 and 137 had the restricted shape, and 138, 139 and 140 did not. The changeset also says versions before 120 were not tested.
- I first pushed this as `420af28429` without the `docs/guide.md` copy, then amended and force-pushed with a lease, replacing only my own commit.
- I replied on the thread with the commit and the CI result: https://github.com/endojs/endo-but-for-bots/pull/1349#discussion_r4397387628

**Follow-ups**
- **The ferry directive is out of date.** `jobs/ferry/endojs-endo-but-for-bots-pr1349.md` expects the PR head to be `b122ff91ef`. Panel follow-ups had already moved it to `1e19cde89b`, and this job moved it to `991f8af47e`. The boatman checks the head and will stop, so the directive needs re-staging at `991f8af47e`. I've sent this to the maintainer inbox.
- The review still shows changes-requested until kriskowal re-reviews. kriskowal's latest review already asked for a ferry upstream.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `1e19cde89b2810be097cf4bd8839ec4d7d43905f`; this job presented `991f8af47e27cee09c6e3db5babf9714dbd60214`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-fix-maintainer-review.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1332576 cached reads)
- Output: 7135 tokens
- Cost: $0.9683832
- Wall-clock: 767s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
