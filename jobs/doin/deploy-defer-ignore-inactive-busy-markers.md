# Garden-library fix: deploy defer/quiesce must ignore stale busy markers of INACTIVE gardeners

Garden's own code; land on `main2` directly (no PR — CLAUDE.md § Conventions). No
project repo, no upstream.

## Bug (observed 2026-07-07)
`scripts/jobs/deploy-garden.sh` decides whether to defer (step 0 DEFER CHECK) and
whether the fleet has quiesced (step 1 DRAIN) by reading this host's gardener busy
markers at `$GARDEN_STATE/gardeners/<id>/busy` and treating any marker older than the
long-job threshold (default 300s) as a live long job. See the `count_busy` /
mid-job-counting logic near the top of deploy-garden.sh.

The defect: a **STALE** busy marker — one left behind by a gardener whose systemd unit
is no longer running (e.g. a worker killed mid-job during an outage, or an id above the
current pool size after downsizing) — is honored as a live long job **forever**. It
never ages out and no live process removes it, so `deploy-garden.sh` DEFERS on every
attempt and the host can never deploy. Real incident: `gardeners/55/busy` was an empty
file 28h old with `garden-gardener@55.service` INACTIVE (pool was sized to 20); it
blocked two deploys until an operator removed it by hand.

## Fix
When evaluating a busy marker, first confirm the gardener is actually live:
`systemctl --user is-active garden-gardener@<id>.service`. A marker whose unit is
**inactive is STALE** — do NOT count it as busy/long-job in either the step-0 defer
check or the step-1 quiesce count. **Sweep it** (remove the stale marker) and **log**
what was removed (id + marker age) — never a silent skip, so it stays diagnosable. A
marker whose unit IS active is honored exactly as today (a genuine mid-job gardener
still defers / blocks quiesce as before).

Keep the change tight and localized to the busy-marker evaluation; do not alter the
drain/merge/restart sequence, the timeouts, or the defer exit-status contract.

## Test (required)
Extend the deploy test suite (add a focused test if none covers this). Make the
unit-liveness check STUBBABLE (e.g. an overridable `gardener_unit_active <id>` function
or an injectable `is-active` command, mirroring how the rest of the deploy logic is
tested without a real systemd). Assert:
- a busy marker whose unit-liveness stub reports INACTIVE is ignored (does not defer,
  does not count toward quiesce) AND is swept (file removed) with a log line;
- a busy marker whose unit reports ACTIVE still defers / blocks quiesce as before;
- mixed case: one stale + one live → the live one governs, the stale one is swept.
Everything green before land.

## Land
Commit to `main2` directly with a clear message; push. Report the fix + test results.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 15
  claimed_at: 2026-07-07T05:24:25Z
