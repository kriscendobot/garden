## Gauntlet fix round 6: kriscendobot/minion.town PR #182

I made the panel's requested doc changes, pushed them as one follow-up commit, and CI passed.

**What the panel asked for.** The round-6 review (5489046396, head `65dfad9`) had one request-changes vote. It came from the pruner seat, which found four places where `DEPLOYMENT.md` said the same thing more than once. The other 33 seats approved or left comments only.

**Changes in `DEPLOYMENT.md`** (commit `7b1c418`, pushed with `safe-push-pr-head.sh` as `65dfad9..7b1c418`):
1. **"no issue opens" said three times.** It now appears once, in the *Runner* paragraph. I removed it from the offline-runner sentence and from the JSON-value paragraph.
2. **Fallback instructions in three places.** In *Runner*, "and unset it to return" now points to the § CI runner *Trust note*, which explains how to go back.
3. **Repeated opening of the Trust note.** I cut its first sentence ("Production secrets reach this host…"), because the sentence after it makes the same point.
4. **Billing-block alert said twice.** I cut "the billing block is the alert" and kept the one-hour-queued rule.
5. **Assessor nit:** I rewrapped the over-long line in the § CI runner intro and changed "It does not" to "They do not", since the sentence is about both CI and CD.

**CI:** `ci-wait-merge.sh --no-merge` exited 0. All 3 checks passed: test, Claude harness amd64, Claude harness arm64.

**Follow-ups:** Some should-fix and comment-only suggestions from other seats are still open and were not required this round:
- Move the report logic out of the workflow into a module that can be tested.
- Truncate issue bodies so they stay under GitHub's 65,536-character limit.
- On a green run, close every open issue that carries the probe-failure label, not just the first one.
- Upgrade to `github-script@v8`.
- Delete any leftover `prod-probe-summary.json` before downloading the artifact.

The driver posts panel round 7 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr182-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (720640 cached reads)
- Output: 3899 tokens
- Cost: $0.70494
- Wall-clock: 905s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
