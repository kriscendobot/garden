Weaved and pushed the stack:

- #151: `4ce1125`, based on `main-39867df`.
- #152: `1de8101`, based on `chore/javascript-only-scripts-part-1-4ce1125`. Added the seven shell allowlist entries, provisioning-side Caddy token synchronization, shared JS helper, and tests.
- #153: `882d867`, based on `chore/javascript-only-scripts-part-2a-1de8101`. Retained its original work and only the `deploy-caddy.js` portion of the Caddy synchronization fix.

Verification: JavaScript-only gate, typecheck, 150 focused tests, and the full suite passed locally (1,056 passed, 11 skipped). #151 CI failed solely because its seven new-main shell scripts are intentionally allowlisted in #152; #152 and #153 are cleanly mergeable but did not receive new remote CI runs.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr152-weave-20261009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1078s

<!-- garden-usage-end -->
