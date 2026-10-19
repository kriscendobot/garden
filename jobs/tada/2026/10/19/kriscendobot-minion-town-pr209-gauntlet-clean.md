Clean stage for kriscendobot/minion.town PR #209 (draft, "fix(deploy): reclaim disk caches before restarting the npm registry"): nothing needed changing, so nothing was pushed. CI is green at head `7f0b5e4b`.

- **What the PR changes:** one file, `deploy/aws/scripts/deploy-npm-registry.sh`, and only 15 added lines. Before the unit restarts, the remote deploy script now checks free disk. If less than 3 GiB is free, it trims the journal, runs `apt-get clean`, and prunes the Docker build cache. It never fails the deploy over any of this.
- **Coverage:** I made no changes. The new lines are a best-effort shell snippet that runs on the remote host during deploy, and nothing in the repo's tests could exercise it. So I didn't check out the branch or run anything locally.
- **Dead code:** none. The change only adds lines, so it can't leave anything unused.
- **CI:** `ci-wait-merge.sh kriscendobot/minion.town 209 --no-merge` returned rc 0 (3 checks, 0 failed): `changes` and `test` passed, and `Claude harness` was skipped. I ran it with a 600s deadline, shorter than the 3600s the job specified, because CI had already finished.

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr209-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (175041 cached reads)
- Output: 1087 tokens
- Cost: $0.4006042000000001
- Wall-clock: 16s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
