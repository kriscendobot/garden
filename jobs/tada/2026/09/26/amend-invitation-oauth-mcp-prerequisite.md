Implemented and opened draft PR [#121](https://github.com/kriscendobot/minion.town/pull/121).

- Confirmed production remains OAuth-gated: live `/` redirected to sign-in; unauthenticated `/mcp` returned 401.
- Added an explicit production-status callout to the invitation design.
- Added visible guest invitation-page copy clarifying that invitation credentials are not yet MCP credentials; MCP currently requires OAuth PKCE and provisions a separate `iss+sub`-derived guest.
- Local `npm test` (479 passed, 7 skipped), typecheck, and build passed.
- CI harness checks passed; CI’s unrelated live-daemon B1 self-healing test failed twice (`expected true to be false`).

Self-improvement: distinguished deployed behavior from landed source before amending user-facing copy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/amend-invitation-oauth-mcp-prerequisite.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s) (6 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (6 engagement(s) unpriced)
- Wall-clock: 756s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
