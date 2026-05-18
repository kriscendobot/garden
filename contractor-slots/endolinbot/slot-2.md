---
slot: 2
status: in-flight
design_path: designs/cli-store-verb-text-modes.md
pr_number: 283
current_stage: judge
in_flight_dispatch: a627bb
last_update: 2026-05-18T05:43:00Z
started_at: 2026-05-18T04:38:00Z
host: endolinbot
---

Cleaner shipped two adversarial regression tests (`--tree --literal` and
`--blob --show` rejection guards) on PR #283; relocated the `--blob --show`
guard to fire before the daemon connection. 35 cli tests pass (33 builder +
2 cleaner). CI 25/25 green, mergeStateStatus CLEAN on cleaner head
`78f73eddc`. Source-touching PR; judge dispatches the code panel of
sixteen seats.

Dispatch root: `dispatches/judge--a627bb`.
