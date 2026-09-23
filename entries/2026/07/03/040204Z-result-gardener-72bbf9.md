---
kind: result
role: gardener
host: endolinbot2
at: 2026-07-03T04:02:06Z
---
# result: foreman active-job TARGET (default 3)

Job `foreman-active-job-target` — landed on `main2` as commit f34f7520c.

## What changed
- `scripts/jobs/foreman.sh`: new `GARDEN_FOREMAN_ACTIVE_TARGET` (default 3) replaces
  `GARDEN_FOREMAN_WIP` as the canonical knob (WIP kept as a deprecated alias:
  `${GARDEN_FOREMAN_ACTIVE_TARGET:=${GARDEN_FOREMAN_WIP:-3}}`). The trigger is now
  "act while todo+doin < TARGET" (under-subscribed), not only "board fully idle".
  On a sustained under-subscribed tick the foreman batch-promotes up to
  `TARGET - in-flight` top-priority deferred plan jobs in ONE tick (re-syncing the
  clone between picks), then falls through to generating ONE new step via the
  handler only when no deferred plan is queued. The expensive `claude -p` path
  stays paced at one step per tick; only cheap pre-approved deferred work fills in
  a single tick.
- Preserved invariants: `GARDEN_FOREMAN_IDLE_SETTLE` debounce, go-ahead + blocked
  plan jobs never auto-promoted, leader-only gating, anti-flap, token-quota back-off.
- `scripts/systemd/garden-foreman.service`: `GARDEN_FOREMAN_WIP=3` →
  `GARDEN_FOREMAN_ACTIVE_TARGET=3` (now redundant with the default, pinned for clarity).
- `scripts/jobs/test/run-test.sh`: added SUBTEST 14d (batch fill-to-target: 1 in
  doin + N deferred plans → promote exactly 2 to reach 3, top-priority first,
  go-ahead/blocked untouched, 0 at capacity). Pinned SUBTEST 14 and SUBTEST 20(5)
  to target=1 to preserve their single-slot semantics; SUBTEST 14a now also covers
  the deprecated WIP alias.

## Verification
Foreman/plan subtests (14, 14a, 14b, 14c, 14d, 20) run in isolation: 36 PASS, 0 FAIL.
The full suite is flaky at SUBTEST 6 (maintainer-channel) under this host's live
~100-gardener fleet load — a contamination hazard the harness header documents,
unrelated to this change.

## Activation note
This changes the DEPLOYED foreman only after a deploy (the running fleet uses the
deployed root checkout). Until then the maintainer is bridging to 3 by
hand-promotion, as flagged in the directive.
