Deployed `e9b99f02d7ce30689f20f952b03100dce574767a` to the live EC2 host via SSM and restarted `minion-mcp`. The service is active/enabled with `NODE_ENV=production`, `ENDO_SOCK=/run/endo-daemon/endo.sock`, and `CLIP_SITES_LIVE=1`; loopback health returned 200.

Authenticated production `clip_publish` reproduced the suspected failure. The pinned daemon rejects `guest.has("@main")` with `Invalid pet name "@main"` rather than resolving false; the rejection propagated and prevented publishing. The same error appears in the live service log.

Opened draft PR https://github.com/kriscendobot/minion.town/pull/71 at commit `79c0430`. It treats rejected or non-boolean `has("@main")` results as absent, retains the `MAIN` fallback, and adds regression coverage for the production rejection. Verification passed: 290 tests, 5 skipped; typecheck passed; PR CI passed.

Follow-up: merge and deploy PR #71, then repeat the authenticated publish/serve/unpublish smoke. Production remains healthy, but live clip publishing remains broken until that fix deploys.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-e9b99f0-guest-main-worker-deploy-verify.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 343s

<!-- garden-usage-end -->
