The clean stage is not finished. No coverage or dead-code changes were made, and CI is still pending. I'm reporting still-pending so the driver re-posts this stage.

- **Checks:** 16 are green and 18 are skipped. The only checks still pending are `test (22.x, macos-15)` and `test (24.x, macos-15)`, both QUEUED. The 22.x and 24.x Ubuntu test legs went green during the wait.
- **Coverage pass:** I did not run it locally. The `cover (22.x/24.x, ubuntu-latest)` CI jobs passed, and I made no pushes.
- **CI wait:** `ci-wait-merge.sh` was killed by the 600s background time limit. I polled `gh pr view` by hand in the foreground for about 40 minutes. The macOS runners never started, with no sign of failure or billing block.
- **Follow-up:** Re-post this clean stage to wait on the two macOS legs. There are no code follow-ups.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1586-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 72 tokens (2056656 cached reads)
- Output: 10874 tokens
- Cost: $1.2019411
- Wall-clock: 7786s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
