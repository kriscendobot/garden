Report: undraft stage for endojs/endo-but-for-bots PR #250 ("ci: disable npm lifecycle scripts in workflows")

**Outcome:** I changed nothing. The PR was already out of draft at the head the panel reviewed, so this stage was a no-op and I did not run `gh pr ready`.

- **Check before acting:** `gh pr view` returned state=OPEN, isDraft=false, headRefOid=`a31662b49fae9d5629be6dd5c26b59f6cbdf0c11`. That matches the head the passing panel covered exactly.
- **Final check:** isDraft=false, and headRefOid is still `a31662b49fae9d5629be6dd5c26b59f6cbdf0c11`.

**Advisory review (light and non-blocking; recorded only):** I read the diff across the 9 workflow files. It adds `YARN_ENABLE_SCRIPTS: 'false'` and `npm_config_ignore_scripts: 'true'` to each workflow's env, switches installs to `yarn install --immutable`, and makes one pin comment more precise (`v3` → `v3.0.3`). I found nothing the panel systematically missed. One thing to watch: the workflow-wide `npm_config_ignore_scripts` also covers the npm install in `browser-test/`. That subtree's `.npmrc` already sets `ignore-scripts=true`, so this should not change behavior there.

**Follow-ups:** none.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr250-gauntlet-20261007-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (163847 cached reads)
- Output: 970 tokens
- Cost: $0.3781534
- Wall-clock: 16s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
