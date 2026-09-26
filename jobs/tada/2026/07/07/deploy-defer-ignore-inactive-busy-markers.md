Pushed to `main2`. Work complete.

## Completion report

**Job:** Garden-library fix — deploy defer/quiesce must ignore stale busy markers of INACTIVE gardeners. Landed on `main2` (commit `dd2e00463`), no PR (per CLAUDE.md § Conventions).

**Bug:** `scripts/jobs/deploy-garden.sh` honored any busy marker older than the long-job threshold as a live long job. A **stale** marker — left by a gardener whose systemd unit is no longer running (killed mid-job in an outage, or an id above the pool size after a downsize) — never ages out and no live process removes it, so the deploy DEFERRED on every attempt forever (real incident: `gardeners/55/busy`, empty, 28h old, `garden-gardener@55` inactive, pool sized to 20 — blocked two deploys until an operator removed it by hand).

**Fix (localized to busy-marker evaluation):**
- Added `gardener_unit_active <id>` — `unit_ctl is-active garden-gardener@<id>.service`, routed through the existing `unit_ctl` indirection so `GARDEN_UNIT_CTL` stubs it in tests.
- Added `sweep_stale_busy <id> <age>` — removes the stale marker and logs the id + marker age (never a silent skip).
- `busy_count` (step-1 quiesce) and `oldest_busy` (step-0 defer check) now check unit liveness per marker: an **inactive** unit's marker is swept + logged and excluded from both counts; an **active** unit's marker is honored exactly as before.
- The drain/merge/restart sequence, timeouts, and the defer exit-status contract are untouched. Sweep logging goes to stderr (`log`), so it doesn't corrupt the command-substituted count outputs.

**Test:** Added an `is-active` verb to `mock-systemctl.sh` (the armed set stands in for running units, so an unarmed id models an inactive unit). New `STALE BUSY MARKER` section in `deploy-garden-test.sh` asserts: (a) an inactive marker is ignored, swept, and logged — deploy proceeds, no defer; (b) an active long-job marker still defers and is not swept; (c) mixed — the live gardener governs the deferral while the stale one is swept.

**Results:** Full suite green — **80 passed, 0 failed**. All pre-existing busy-marker tests (QUIESCE-WAIT/TIMEOUT, LONG-JOB DEFER, MID-DRAIN) still pass, as gardeners 1/2 are in the fixture's armed set → reported active → behavior unchanged.

**Follow-ups:** None.
