I merged kriscendobot/minion.town#165 ("feat(claude): pin per-guest inbox responders"). The automatic deploy that followed passed, and production looks healthy about 5 minutes later.

**Before merging, I re-checked:**
- The PR was open, mergeable (`CLEAN`), and all 3 checks were green on head `fc7ff2f`.
- kriskowal's approval was still in effect (APPROVED 2026-10-07 02:11Z, review body: "@kriscendobot conduct, deploy, and validate").
- The bot can push to this repo, and there's no other merge job for this PR.
- The last review panel (round 3) came back must-fix. kriskowal approved after that panel, so I went ahead on the approval.

**Merge:**
- I marked the draft PR ready, then ran `ci-wait-merge.sh`. It moved the base from the snapshot `main-be0edb8` to `main`, found CI green, confirmed kriskowal's approval, and merged with a merge commit.
- The PR is MERGED at 05:20:54Z, merge commit `d750b09b30e9bb6ff00dd13e52e56f2acfdf9b23`.
- `sweep-frozen-bases.sh` deleted the old snapshot branch `main-be0edb8`.

**Deploy and check, as kriskowal asked:**
- The automatic deploy run (37575859240) and the test run on `main` (37575859364) both passed. Every deploy step passed its smoke test, including:
  - app healthz 200, and the gated account routes return 403;
  - endo-gateway, minion-git-remote and oauth2-proxy are up;
  - npm-minion-registry answers on loopback;
  - Caddy reloaded with the right gate tokens, and the landing page deployed.
- A read-only SSM check of the server showed `minion-mcp`, `endo-daemon`, `endo-gateway`, `minion-git-remote` and `caddy` all active with 0 restarts since the deploy. Each port in use (8920/3000/3002/3003) is held by the current process, with no leftover process from before. The app's local `/healthz` returns 200 and the public site returns 200.
- The only error in the minion-mcp log is one `CapTP minion-town-sites-install … Connection stream ended` at 05:22:20, when the daemon restarted. There's been no error since and no crash loop.

**Not done:**
- I didn't test the new pinned inbox responders themselves end to end (sending a message to a real guest's inbox and checking which responder handles it). What I checked is that the deploy succeeded and every service is up. A live check of the responders would need its own job.
- I didn't post a comment on the PR, because the job didn't authorize one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr165-conduct.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (690420 cached reads)
- Output: 5246 tokens
- Cost: $0.732668
- Wall-clock: 384s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
