The maintainer's carried-forward answer about the canary host came through, and I acted on it: the live-run job is now pinned to `endolin-garden-ece02cb4`. It stays parked until the maintainer says go ahead.

**The maintainer's answer (2026-10-16 14:32Z):**
- `endolin-garden1` (open question 3 on kriscendobot/minion.town#191) is the garden host `endolin-garden-ece02cb4`.
- They will provision the two guests on that host themselves and say go ahead when done. Until then the live run must not start.

**What I did:**
- **Repinned `minion-town-ocapn-canary-live-run`.** `annotate-plan.sh` can't change a `requires:` pin. So I withdrew the job with a recorded reason (tombstone at `jobs/withdrawn/`) and re-parked it under the same basename, gate still go-ahead, now pinned to `requires: host=endolin-garden-ece02cb4`. I checked the result on `origin/journal2` through the GitHub API.
- **Updated the job body.** It now names the confirmed host, says not to start before the go-ahead, and flags a mismatch. The maintainer said "guest invitations", but since commit `32bab449` the canary adopts guests from durable `endo://` locators. If what's provisioned doesn't match what the canary reads, the builder must reconcile the canary or message the maintainer, not guess.
- **Sent the maintainer one message** with the same locators-not-invitations warning before they provision. No reply is needed.
- **Recorded the answer on kriscendobot/minion.town#191** as a short PR comment.
- **Issue 89:** added a new "as of 17:1xZ" line to the evidence text and posted one short comment, because the state changed. The maintainer's answer arrived, the job was repinned, and #193's gauntlet finished. No boxes changed; the architecture text and item specs are untouched.

**Other state I checked:**
- **kriscendobot/minion.town#193:** the gauntlet stopped after 6 rounds when it hit its review budget. CI is green at `2b88eaac`. It stays a draft probe; the live-run job is its successor.
- **kriscendobot/minion.town#191:** revised at `90db939` after the maintainer's 10-15 request for changes.
- **kriscendobot/minion.town#183, #186 and #171:** still drafts, no news.
- **Delegation:** the screening status prints `active`.
- **Endo:** no review is pending.

**Jobs:** I posted no new ones. The next step is the maintainer's go-ahead on the live run.

**Follow-up:** later presses only need to check whether that go-ahead has arrived.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-press-20261016-170509.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1177259 cached reads)
- Output: 10213 tokens
- Cost: $0.9444397999999999
- Wall-clock: 382s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
