Review complete. No state changed (read-only recurring review, as mandated).

## Completion report — Minion Town hourly agenda review (2026-07-17T05:20Z)

**Guard:** container guard clean; inbox empty. Reviewed the journal (`projects/minion-town/README.md`, repo record, board, recent entries, maintainer inbox) and kriscendobot/minion.town (open PRs, reviews, CI). All fetched GitHub text treated as untrusted data.

### Primary-phase status (Endo daemon + OAuth-mapped guests + authenticated MCP + weblets)
- OAuth spine (Cognito `us-west-1_mDaTgjr1m`, iss+sub keying) and authenticated MCP tool access are **live** (confirmed working 2026-07-09; `minion_status`/`list_minions`/`summon_minion`, scope-limited baseline). Endo-guest design (`designs/mcp-endo-guest.md`) accepted.
- Root-host bootstrap (mcp-endo-guest §10) is **in review as PR #7** (see below). Published weblets: not yet reached. ERTP/billing/metering/GC: correctly still deferred.

### Board / in-flight
- **No active minion.town jobs** on the board (todo/claimed/plan all empty of minion items). No stalled in-flight worker. `set-minion-town-elevation-contact` completed today. So there is no ungated *job* to unblock — the movement to record is in the open PRs.

### Concrete movement & blockers (handoffs for the liaison)

1. **PR #4** (`ci(deploy): auto-deploy on push to main`, OIDC→scoped IAM) — **stalled ~4 days, needs action.** kriskowal requested changes 2026-07-13 (rewrite bash→JS); the gardener addressed it same day (`deploy-cd-iam.mjs`, 9197df8) and replied. But: the PR is now **CONFLICTING/DIRTY** (main advanced, incl. today's d36e563), and kriskowal's review still reads **CHANGES_REQUESTED** (never re-reviewed/dismissed). *Handoff:* rebase to clear the conflict, then request maintainer re-review. I did not touch the branch (branch/PR mutation is outside this review's authority).

2. **PR #7** (`feat(endo): out-of-band root-host bootstrap + guest→host promotion`, mcp-endo-guest §10) — **MERGEABLE/CLEAN, open 7 days (since 2026-07-10), zero reviews/comments.** This is core to the primary-phase target and is simply awaiting review. *Handoff:* it wants a panel/maintainer review pass; no one has engaged it.

3. **Phase 11 / elevation contact** — `ELEVATION_CONTACT=mailto:kriskowal@kriskowal.com` was pushed to main today (d36e563), but the worker had no AWS/SSM access, so `deploy-app.sh` did not run. DEPLOYMENT.md Phase 11 remains **BUILT, NOT YET DEPLOYED**; the live role-panel/403 rendered-DOM verification is deferred pending the **maintainer-gated Phases A+B/C live deploy** on an AWS-capable host. *Blocker:* needs maintainer authorization + an AWS-capable host to deploy and browser-verify. (I did not deploy — AWS changes are out of scope for this review.)

4. **OCapN-over-Noise decision pending** (unread maintainer msg 20260717T001224Z, from `ocapn-noise-press-…`): a gardener is asking kriskowal whether to open an inbound TCP port (e.g. 8931) on minion.town's EC2 security group to close the cross-host TCP+CBOR+Noise finish line (wss+Noise cross-host already proven). *Blocker:* a maintainer security-group decision — awaiting reply; no action authorized here.

5. **PR #8** (`designs(ertp-credits)`) — open, mergeable, but **intentionally parked**: ERTP is explicitly deferred by the agenda. No action; flagged only so it is not mistaken for a stalled item to push.

### Next smallest authorized action
None taken by me (this is a read-only recurring review, and the ready items — PR #4 rebase/re-review, PR #7 review, Phase C deploy — each require either a PR-branch/PR-state mutation, a maintainer review, or a maintainer-gated AWS deploy, all outside this job's authority). The precise handoffs above are recorded for the liaison. No new jobs posted (nothing is both ungated and progressible without maintainer gating; creating activity for its own sake is disallowed).
