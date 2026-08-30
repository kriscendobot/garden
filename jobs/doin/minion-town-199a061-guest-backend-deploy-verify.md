---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town. Commit 199a06138d6e259dcbd215079847f9d6d481c696 ("fix(endo): gate the in-memory guest fallback on an explicit local/dev signal") changed how the guest backend is selected: `Config.guestBackend` is now derived by `selectGuestBackend` in `src/config.ts`, and under `NODE_ENV=production` an unset/empty `ENDO_SOCK` now defaults to the socket at `/run/endo-daemon/endo.sock` instead of silently serving a non-durable in-memory host.
This is a behavior change on a live deployment, so verify it on the deployed host rather than trusting the tests alone:
1. Deploy/restart the `minion-mcp` service at the current `origin/main` and confirm it comes up healthy.
2. Confirm the running service resolves `guestBackend: "socket"` — i.e. the unit still supplies `NODE_ENV=production` and an `ENDO_SOCK` path, the endo daemon socket exists at the configured path, and guest tools (`guest_write_text` and a read-back) survive a service restart (durability, the exact failure the commit was written to prevent).
3. Check the `WEBLET_SITES_LIVE=1` path: with the socket backend it should install the daemon weblet registry; with the memory backend it should skip the install and report a degraded, non-serving scaffold naming the empty-socket cause. Report which posture the deployed host is actually in.
Report findings back on the job; if the deployed unit turns out to be missing `ENDO_SOCK` or `NODE_ENV=production`, say so explicitly — under the new code that is now a loud daemon error rather than a silent in-memory fallback, so it will surface as a guest-tool outage, not as data loss.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-30T05:58:34Z
