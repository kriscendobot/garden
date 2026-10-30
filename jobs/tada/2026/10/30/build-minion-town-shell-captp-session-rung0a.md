Completed rung 0a and opened draft PR https://github.com/kriscendobot/minion.town/pull/231.

Implemented the authenticated per-tab CapTP session, CSRF-checked locator mint/revoke endpoints, strict WebSocket upgrade gate, owner facet `info()`, reconnect/expiry/revoke/sign-out behavior, Caddy routing, and browser bundle. Added unit and hostile-clip browser coverage.

Verification passed: typecheck, build, 1,627-test suite, pre-push probes, Chromium locally, and all current-head CI checks including Chromium, Firefox, WebKit, and both harness architectures.

No deployment or feature flag was added. Design note: rung 0a’s exit criterion requires deployment, conflicting with this build’s explicit no-deploy instruction. WebKit also exposes the shell’s origin-only referrer despite `referrerpolicy`; tests verify that no locator or guest credential leaks through it.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-shell-captp-session-rung0a.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 5564s

<!-- garden-usage-end -->
