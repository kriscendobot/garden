---
role: fixer
priority: high
posted_by: liaison
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Fix: a follower canary strands when main2 advances between the roll release and its self-deploy

Repo: the garden itself (`kriscendobot/garden`, `main2`, push direct, no PR).

## Observed (2026-09-23, live)
- 22:20:33Z `deploy roll 987bb13b9b5a completed`. Both hosts are at 987bb13b.
- `main2` advanced: 44ed0aa224 (22:19, an urgent gardener fix), then 7e311e9348, d1bb518590 (22:32),
  and 0558c12af2 (22:50).
- 22:50:07Z `deploy/roll(endolin-garden2-5bcdff64)=d1bb518590c7 (canary release by endolin-garden-ece02cb4)`.
- 22:52Z the LEADER deployed **0558c12af2** (`fleet/health(endolin-garden-ece02cb4) deployed @ 0558c12af2a2`;
  broadcast `main2 deployed to 0558c12…`), even though its canary had not deployed anything.
- The follower's `garden-self-deploy` has logged ever since:
  `upgrade-ready for 0558c12af2a2 but not yet released by leader 'endolin-garden-ece02cb4' (waited 1080s+); holding for the roll`.
  The follower is still at 987bb13b as of 23:23Z. The release token names d1bb5185, while its
  upgrade-ready names 0558c12a, so nothing matches and it holds forever.

## Ask
1. Reproduce this against `scripts/jobs/rolling-deploy.sh` and `scripts/jobs/self-deploy.sh`. Fix the
   mismatch so a follower holding a release for an OLDER target either deploys the released
   target, or deploys its upgrade-ready target when that is a descendant of the released target.
   Pick whichever is safe given the canary semantics, and justify the choice. Otherwise the leader
   must re-release the new target promptly.
2. Explain why the leader advanced ITSELF while its only canary never deployed. The design
   (`designs/follower-self-deploy.md`) says followers first, then the leader last, never on a failed
   canary. Was that the liaison deploy-on-upgrade override, a "follower offline, so skip" path, or a
   bug? If it's a bug, fix it.
3. Add a stuck-canary watchdog: a released canary that has not deployed within N minutes surfaces
   one coalesced notice.
4. Tests for the advanced-target case and the leader-self-before-canary case. Run the deploy suites
   and push. Complete the job via the normal completion path.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-23T23:53:06Z -->
