---
handed-off: activate-ironhorse-ratchet-autopilot-20260928
deliverable-complete: false
---
Landed `c3aae0b2c0c8` and `509c6c9d9daf` on `main2`: revocable delegation, head-pinned evidence and merge gates, scoped mentat scheduling, one-step watcher, escalation, tests, and documentation.

Validation: 48 new tests passed; existing merge, gauntlet, and comparator suites passed. Unrelated existing documentation violations still fail repository CI and block rollout. Live mentat execution remains unverified.

Registered the schedule, then deferred its first tick pending deployment:
```bash
GARDEN_SCHEDULE_OCCUPANCY=skip scripts/jobs/set-schedule.sh ironhorse-ratchet 2h ironhorse-ratchet-watch scripts/jobs/ratchet/watcher.md
scripts/jobs/snooze-schedule.sh ironhorse-ratchet '2026-09-28 22:55:00Z'
```

Controls:
```bash
scripts/jobs/ironhorse-ratchet.sh pause
scripts/jobs/ironhorse-ratchet.sh revoke /path/to/maintainer-reason.txt
```

Durably posted `activate-ironhorse-ratchet-autopilot-20260928` to own rollout, continued deferral, and actual mentat-tick verification. Draft PR #1359 remains blocked on its base, floor compatibility, and new-code coverage; the existing floor-resolution successor owns that resolution.

Self-improvement: documented delegation preservation during budget promotion and deployment readiness. Result report recorded in the journal.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ironhorse-ratchet-autopilot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2868s

<!-- garden-usage-end -->
