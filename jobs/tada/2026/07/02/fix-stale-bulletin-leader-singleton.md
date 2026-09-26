The job is genuinely resolved. All Done-when criteria are met and there is no garden-code change to commit (this was an operational incident, not a dev task).

---

## Completion report — fix-stale-bulletin-leader-singleton

**Kind:** garden-infra / operational (explicitly out of a gardener's autonomous scope). I investigated read-only, escalated to the maintainer inbox, and verified the fix end-to-end rather than flipping identity or restarting the fleet myself.

**What I found (read-only investigation):**
- The job's "contested point" was already **resolved**: the `leader` marker had been re-pointed to `endolinbot2` (17:37:11Z), and all identity sources here agree on `endolinbot2` (env, `systemctl --user` manager, `.garden`, `identity-override`, `environment.d`), so `is-main-host.sh` returns **LEADER** on this host.
- **Real root cause of the outage:** during the earlier 14:34Z "yield to endolinbot" directive, this host stopped+disabled its *entire* leader-only singleton plane. Leadership was later handed back to `endolinbot2` (17:37Z) but the restore step (`install-units.sh enable-services`) was never run — so the designated leader was running **no** leader singletons. `garden-bulletin` (disabled+inactive since 14:34:30Z) was just the visible symptom; foreman/scheduler/reaper/deadmail/follow-up/orchestrate/repo-watcher were all down too.

**What I did:**
- Escalated to the maintainer inbox (`message-user.sh`) with the full diagnosis, the exact remediation (`install-units.sh enable-services` + start the continuous singletons), and the open precondition question about the host-side garden2 identity enforcer.
- Updated durable memory (`garden-endolinbot2-follower-identity.md`) to record the marker re-pointing back to endolinbot2 with the restore never performed.
- Polled and verified after the remediation was applied (by the maintainer/liaison in response).

**What changed / current state (verified 19:15Z):**
- `garden-bulletin.service`: **active + enabled** on this leader host; loop is actively posting (mid-cycle journalist run observed).
- All leader-only timers (foreman, scheduler, reaper, deadmail, follow-up, orchestrate, repo-watcher): **active + enabled**.
- `journal/README.md` freshness advanced **14:31:58Z → 19:13:10Z** — bulletin is current again.
- Identity triple self-consistent: `.garden`=endolinbot2, `GARDEN`=endolinbot2, `leader` marker=endolinbot2, `is-main-host`=LEADER.
- No garden-code change; worktree clean (nothing to commit to main2).

**Follow-up (durable risk, flagged to maintainer):** the host-side garden2 provisioner that previously force-wrote `GARDEN=endolinbot` at 14:28Z. If it isn't fixed at the host to write `endolinbot2`, the identity will flip again, `is-main-host` will return FOLLOWER, and the whole leader plane (bulletin included) will silently go dark once more. The durable fix is at the host, not in the container.
