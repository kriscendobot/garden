Fix round 1 for PR #253 is done, and CI on the pushed head is green (rc 0, 6 checks, 0 failed).

I pushed nothing in this run. A prior attempt had already pushed the panel-1 must-fix items at head `16a1218`:
- **Packager:** `3a57af7` adds the missing changeset `.changeset/waitlist-soon-page.md`.
- **Pruner:** `16a1218` drops the comments that restate the adjacent code. These were in `minion-town.caddy`, `home.js`, `index.html`, and `waitlist-soon-browser.test.ts`.
- **PR body:** already trimmed to short sections that link the design doc and `DEPLOYMENT.md`.

I left three items alone:
- The packager's suggestion to fold `4408e9f` and `1e9fc72` into `65552cb` so every commit is bisect-green. It is tidiness only, and rewriting history would force-push the PR head.
- The assessor's comment-only note that `#soon-status` in `index.html` is dead markup.
- The pruner's finding 1, which was already handled by the earlier trim.

`ensure-project-worktree.sh` failed with a read-only file system error under the monk sandbox. I cloned the PR head into `$TMPDIR` and used that to verify the state.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr253-screen-1e9fc729-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 66 tokens (2164412 cached reads)
- Output: 10330 tokens
- Cost: $1.3277946999999999
- Wall-clock: 4200s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
