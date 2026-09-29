Both of kriskowal's asks on https://github.com/kriscendobot/minion.town/pull/130 (review 5358829715, an approval with no inline comments) now have a job on the board. Neither is finished yet: the merge and the upstream investigation are with the jobs below.

- **Preflight:** the check returned exit 0, meaning no other worker had already handled this review.
- **Conduct (merge):** PR #130 is open, not a draft, mergeable with state CLEAN, and its three checks (`test` and the amd64/arm64 Claude harness) are green. A conductor job for it was already parked waiting for maintainer approval. This review is that approval, so I moved `kriscendobot-minion-town-pr130-conduct-prod-validate-20260928-resume` from plan to todo with `promote-plan.sh --maintainer`. It will:
  - merge the PR through the conductor (the merge method is left to the conductor);
  - watch the resulting CD run;
  - finish the PR #117 production validation and post the result there.
- **Idempotent daemon controls upstream:** I posted researcher job `endo-daemon-controls-idempotency-research`. It covers the two problems PR #130 works around:
  - `endo list` starts a daemon by itself when the socket isn't ready, which caused the `EADDRINUSE` race;
  - workers can survive after a stop, including the orphan holding port 8920 (https://github.com/kriscendobot/minion.town/pull/137).

  The job will write a ranked research note in endojs/endo-but-for-bots proposing fixes, such as an option to turn off auto-start, `start`/`stop` commands that do nothing when there's nothing to do, a lock allowing only one daemon, and exit codes a supervisor can rely on. It will then post follow-up design/build jobs and report back on PR #130.
- **Board check:** the GitHub API shows both jobs in `jobs/todo` on `journal2`.
- **PR comment:** I told the reviewer both asks are queued: https://github.com/kriscendobot/minion.town/pull/130#issuecomment-5900424326

No garden code changed, so there was nothing to commit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr130-review-ba8a9163.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (589380 cached reads)
- Output: 3979 tokens
- Cost: $0.5602799999999999
- Wall-clock: 72s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
