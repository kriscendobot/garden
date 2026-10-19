**Viability: proceed.** PR #209 has not been superseded, and the problem it fixes still exists. No clean, panel, fix or CI budget was spent.

- **PR state:** kriscendobot/minion.town#209 is open, unmerged and still a draft. Its base is now the pinned snapshot `main-8a3ce66` (`8a3ce66c4e8f`), and its head is `7f0b5e4b2cf6`.
- **The change:** one commit, 15 added lines in `deploy/aws/scripts/deploy-npm-registry.sh`. When less than 3 GiB is free, it trims the systemd journal, runs `apt-get clean` and prunes unused Docker build cache before the npm registry unit restarts. That unit's startup check refuses to run with under 1 GiB free.
- **Why it was opened:** this repair PR followed the failed deploy of 8a3ce66. The box had 1018 MiB free, so the registry kept restarting and failing and `npm.minion.town` returned 502. Production was cleaned up by hand, but nothing in the deploy script stops it happening again.

Deciding question: Does current `main` still deploy the npm registry without reclaiming disk caches first, with no newer PR or commit already doing that?

Evidence:
- The tip of `main` is still `8a3ce66c4` (the #204 merge), which is exactly this PR's pinned base, so there is no newer base history.
- The last change to `deploy-npm-registry.sh` on `main` is `ab92068dd` from 2026-10-17, which is about Node and `/usr/local`, not disk space.
- The file on `main` contains no `--vacuum-size`, `apt-get clean`, `builder prune` or free-space check. Its only `journalctl` call reads the unit's log after a failure.
- No other PR, open or merged, does the same job. #192 and #206 are unrelated deploy fixes.
- No reviews yet. The only comment is an earlier gauntlet halt because the PR was on a floating base, and the PR has since been pinned to `main-8a3ce66`, so that cause no longer applies.

The PR itself says the longer-term fix is still outstanding: a permanent journald size cap and regular build-cache pruning on the deploy host.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr209-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (120887 cached reads)
- Output: 1504 tokens
- Cost: $0.4203453999999999
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
