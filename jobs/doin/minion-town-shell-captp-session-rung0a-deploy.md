---
tier: mentor
arc: minion-town-ui
posted_at: 2026-10-30T07:02:45Z
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-30T07:04:06Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Deploy and evidence rung 0a of the shell CapTP session (kriscendobot/minion.town PR #231)

Repo: kriscendobot/minion.town. PR: https://github.com/kriscendobot/minion.town/pull/231
(head `build/shell-captp-session`). Governing design: https://github.com/kriscendobot/minion.town/pull/230 (rung 0a).

PR #231 is an `orchestrated-slice`: it builds the per-tab shell CapTP session, but
rung 0a's exit criterion also requires deployment plus observed production
behavior, which the build directive excluded. This job owns that remainder.

1. Reconcile design #230's open question (j), per-tab vs per-browser sessions, with
   the per-tab model #231 implements: answer it in the design or change the
   implementation to match the design's settled choice.
2. Deploy #231's head to production with its Caddy route changes (`deploy-caddy.sh`
   and `deploy-www.sh` together, plus the app), per the repo's deploy procedure.
3. Observe in production and record evidence: the signed-in shell opens the owner
   facet and `info()` answers; a dropped socket reconnects; revocation (per-locator
   and sign-out-wide) closes the socket; a hostile clip named "Settings" cannot
   reach the session; `/shell-session.js` and `/shell-captp.js` are served publicly.
4. Update the PR body's phase-and-evidence ledger to `Disposition: deliverable`
   with `Rung 0a: satisfied` and `Acceptance: satisfied` citing those observations,
   then run the gauntlet on #231 again so a passing panel can un-draft it.

<!-- garden-productive-cycle -->
<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-30T07:04:34Z
