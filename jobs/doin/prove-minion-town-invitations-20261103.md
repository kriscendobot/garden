---
posted_at: 2026-11-03T05:44:53Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
repo: https://github.com/kriscendobot/minion.town
task: Prove minion.town invitations end to end on production, and report the gaps. Maintainer goal (2026-11-03): the root user can extend invitations and others can accept them.

Steps:
1. Using the anonymous guest API (context/operations/minion-town-mcp.md, "The anonymous guest API"), create two fresh guests A and B (POST /api/guest). Treat each formula identifier as a password: never log, print, or commit one.
2. A mints a local invitation (POST /api/guest/invitations, kind local); B accepts it (POST /api/guest/invitations/accept). Verify each side's contacts show the other under the chosen pet names.
3. Exchange mail both ways (POST /api/guest/mail); verify delivery on each side.
4. Verify the acceptor receives a correspondent handle only, never the inviter's powers.
5. Separately, find out what the ROOT/owner path is: how the root user (the maintainer's account, not an anonymous guest) mints an invitation and how a new guest accepts it, through the UI and through the MCP. Document the exact route, or the gap if none exists.
6. Note remote invitations: still no connection hints, so they cannot be dialed. Record current behavior only; do not attempt a fix.

Output: a report in the job result with PASS/FAIL per step, exact requests (no secrets), and a gap list ranked by what blocks "root invites, others accept". Do not change code, open PRs, or modify existing guests. Do not publish clips. Created guests cannot be deleted, so create no more than the two needed.

<!-- garden-transient-elapsed: kind=signature through=0 values=162 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-03T06:33:04Z -->

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-03T06:39:14Z
