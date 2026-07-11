# Reactivate xs2rust + xst-validation (Saturday resume of the temporary pause)

The maintainer temporarily paused two efforts until Saturday morning. Resume them.
Do all journal writes with proper CAS (fetch origin journal2, apply, commit, push with
retry) — the journal is high-traffic. Journal + local config only; no project repo, no
upstream.

1. RESTORE the two paused schedules — move each back into the scheduler's scan:
     paused-schedules/xs2rust-endor-press.md         -> schedules/xs2rust-endor-press.md
     paused-schedules/xst-validation-orchestrator.md -> schedules/xst-validation-orchestrator.md
   Their last_dispatched is stale (pre-pause), so the scheduler fires each promptly on the
   next tick — do NOT reset it. If either is already back in schedules/, skip that one.

2. RESUME the parked xs2rust follow-up. The stage5-fix6 orchestration record was removed
   during the pause; its child xs2rust-endor-stage5-fix6-verify was left parked in
   jobs/plan (gate orchestrated). If it is STILL parked and no orchestration owns it,
   re-create the orchestration over only the still-parked children so it runs:
     scripts/jobs/post-orchestration.sh --serial --on-child-failure halt \
       xs2rust-endor-build-stage5-fix6 xs2rust-endor-stage5-fix6-verify
   If the restored press driver has already re-established this orchestration or moved
   past it (verify no longer parked), SKIP — do not duplicate.

3. FOREMAN reset reminder. During the pause the maintainer dropped
   GARDEN_FOREMAN_ACTIVE_TARGET to 0 on the LEADER host and wants it back to 3. The
   foreman is a leader-only singleton and its threshold is a per-host systemd env (not
   journal state), so you likely cannot set it cross-host. Post a maintainer-inbox
   message (scripts/jobs/message-user.sh <this-job-base>) reminding the maintainer to
   reset GARDEN_FOREMAN_ACTIVE_TARGET to 3 on the leader host (remove the 0-override
   drop-in so it falls back to the unit default 3, then daemon-reload). If you happen to
   BE running on the leader (scripts/jobs/is-main-host.sh exits 0), do it yourself instead:
     rm -f ~/.config/systemd/user/garden-foreman.service.d/override.conf
     systemctl --user daemon-reload
   and verify `systemctl --user show garden-foreman -p Environment` shows 3.

4. Report exactly what you restored, resumed, and the foreman outcome.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 12
  claimed_at: 2026-07-11T16:05:16Z
