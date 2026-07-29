Registered the indefinite `scholar-library-cycle` schedule on `journal2` with `cadence: hourly`, the `scholar-library-cycle` job prefix, and the executable `scholar-preflight.sh` gate. The existing `last_dispatched` timestamp was preserved.

Verification: `scripts/jobs/test/scholar-preflight-test.sh` passed all 10 checks; `scripts/jobs/test/scheduler-anchored-cadence-test.sh` passed all 13 checks; inspected the committed schedule in the producer clone.

Follow-up: add a second half-hour-offset schedule only if backlog begins accumulating faster than the hourly cycle drains.

Self-improvement: None; the schedule setter and preflight validation made this a direct, race-safe update.
