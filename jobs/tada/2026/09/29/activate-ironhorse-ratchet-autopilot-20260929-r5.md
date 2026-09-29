The Ironhorse press is now deployed and its first engagement is parked. It will not run until the maintainer gives a budget. I posted the evidence on kriscendobot/garden#51.

**Deployment**
- The leader `endolin-garden-ece02cb4` is on `36def9fd9e8`, which contains `9bf25f4362f`, so I did not need to hand off to r6.
- The follower `endolin-garden2-5bcdff64` is also on `36def9fd9e8`.
- `oros-studio-garden-ce242c49` is still offline at `e036bb8e`. The roll skips it and I did not bypass it.

**Gates, read in the deployed files**
- **Scheduler:** `scheduler.sh` always skips `ironhorse-ratchet.md`. That legacy schedule row is also gone from `origin/journal2`.
- **Press name:** `ratchet/policy.py` only accepts `ironhorse-test262-press-\d{8}-\d{6}`.
- **Claiming and running:** `claim-job.sh`, `monk-claude.sh` and `cleric-codex.sh` refuse a ratchet job unless the delegation is active and the job is the canonical press.
- **Foreman:** it admits deferred plans only through `plan_deferred_status`, which checks `not_before` and then the rolling arc budget.

**Runtime**
- No maintainer reply on #51 gives a cap, window or interval. `config/arc-budgets/ironhorse-test262-ratchet` is still absent, and I did not invent values.
- I ran `seed-ironhorse-press.sh`, which parked `jobs/plan/ironhorse-test262-press-20260929-173306.md`. It is the only `ironhorse-test262-press-*` in plan, todo, doin or tada.
  - It has `gate: deferred`, `foreman_only: true`, `issue_spine: issue-kriscendobot-garden-51`, and `issue_url` pointing to comment 5884119530.
  - The seed script posted it, not the scheduler.
- **Gate evidence:** I ran the deployed gate against a synced journal clone.
  - `plan_deferred_status` returns `arc-budget-untrusted:ironhorse-test262-ratchet:rc=2`, and `plan_deferred_ranked_omega` leaves the press out of the ranking.
  - The foreman promoted four other deferred jobs at 17:33Z and left the press parked. It has been at full capacity (10/10) since then.
- **Not captured:** the foreman only writes a `skipped=` entry to `.garden-state/foreman/decisions.log` on ticks with free capacity, and none came while I was running. So there is no live log line naming the press yet. The next tick with free capacity should record the same reason.

I made no code changes and no commits. The only journal write was the press plan. Nothing touched PR #1359 (no merge, no attestation), the enforced floor, sysop deploy ops or schedules. Issue #51 is still open, and I left the 901-path historical-floor question alone.

**Next step:** once the maintainer names a cap, window and interval on #51, install exactly those values with `scripts/jobs/set-arc-budget.sh ironhorse-test262-ratchet <cap> <window> <interval>`. The foreman will then promote the parked press on its own.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/activate-ironhorse-ratchet-autopilot-20260929-r5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1033055 cached reads)
- Output: 6909 tokens
- Cost: $0.8436469999999999
- Wall-clock: 1235s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
