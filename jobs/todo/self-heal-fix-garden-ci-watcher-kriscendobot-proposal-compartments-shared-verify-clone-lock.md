---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`scripts/jobs/ci-watcher.sh` defaults `GARDEN_CI_VERIFY_CLONE` to `$GARDEN_STATE/ci-watcher/verify` and `GARDEN_CI_RETIRE_CLONE` to `$GARDEN_STATE/ci-watcher/retire` — one shared clone (and shared `clone_lock`) across every `garden-ci-watcher@<repo>` instance (currently ~15: endojs-endo-but-for-bots, kriscendobot-garden, kriscendobot-proposal-compartments, kriscendobot-cosgov, etc). This instance's FATAL is `cannot acquire clone lock /home/kris/garden/.garden-state/ci-watcher/verify.lock after 3 waits of 60s and 0 reclaim attempt(s) (a live holder is still busy...)` — a sibling instance legitimately held the shared lock past the 180s wait budget; systemd then restarted this failed unit.

This is the identical shared-clone-lock-contention bug class already fixed for `receipt-watcher.sh` in commit `05c22e5c0e` ("fix(receipt-watcher): per-slug journal clone to end shared-clone contention"), which changed its default from a shared `$GARDEN_STATE/receipt-watcher/journal` to a per-slug `$GARDEN_STATE/receipt-watcher/journal-$slug`, giving every fan-out instance its own clone dir and its own `.lock` sibling so instances never share a lock. `ci-watcher.sh` was never given the same treatment for either its VERIFY or RETIRE clone.

Apply the same fix in `scripts/jobs/ci-watcher.sh`:
- Change `: "${GARDEN_CI_VERIFY_CLONE:=$GARDEN_STATE/ci-watcher/verify}"` to `: "${GARDEN_CI_VERIFY_CLONE:=$GARDEN_STATE/ci-watcher/verify-$slug}"`.
- Change `: "${GARDEN_CI_RETIRE_CLONE:=$GARDEN_STATE/ci-watcher/retire}"` to `: "${GARDEN_CI_RETIRE_CLONE:=$GARDEN_STATE/ci-watcher/retire-$slug}"`.
- Both env vars remain overridable (tests already pin explicit dirs per `scripts/jobs/test/ci-watcher-test.sh`, so this shouldn't disturb existing cases), but add a regression case mirroring `scripts/jobs/test/receipt-watcher-test.sh`'s added assertion: leaving `GARDEN_CI_VERIFY_CLONE`/`GARDEN_CI_RETIRE_CLONE` unset yields distinct per-slug dirs for two different repo slugs.
- Add a short comment above the defaults (mirroring receipt-watcher.sh's rationale block) explaining the fan-out/shared-lock contention this avoids.

Run the full `ci-watcher-test.sh` suite before pushing. This does not touch `GARDEN_CI_JOURNAL_OUTAGE_LATCH`, which is deliberately host-wide (not slug-keyed) per its own comment — leave that alone.
