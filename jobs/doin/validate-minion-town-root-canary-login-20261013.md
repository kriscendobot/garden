---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=awaiting-maintainer priority=normal maintainer=true at=2026-10-14T04:02:37Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Validate and arm the minion.town root canary after interactive login

Resume the root-canary build on the draft PR created by `build-minion-town-root-canary-20261013` (`build/root-canary-principal`). Rediscover the PR by that durable garden-job marker before editing anything.

The maintainer must complete kriscendobot GitHub login and MFA interactively on `endolin-garden1`; do not automate or work around that authentication. Run the verification spike from `designs/root-canary-principal.md` build-scope item 0 and record durable, secret-free evidence for premises A1-A9. In particular, prove the initial and refreshed tokens use sub `79b9090e-20a1-70d2-94c7-717257e2be34`, that the refresh token is reusable and secret-bound, that one MCP session survives access-token refresh, and that revocation is effective.

Only after the spike passes: deploy the audit change, append the actual root-canary client id to `OAUTH_ALLOWED_CLIENT_IDS` and no other allowlist, run the live canary and the remaining mailbox/rate/slot/restart checks, and post the three design schedules (expiry reminder, two-run auth-unavailable alert, and serialized canary with `occupancy: skip`). Update the PR's phase/evidence ledger to `deliverable` with the observed evidence and push the changes to its existing head. Keep the PR draft so the completion machinery can stage its fresh gauntlet. If a premise fails, apply only its named fallback from the design and do not widen root subjects, hosts, or authority.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-14T04:03:00Z
