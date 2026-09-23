Pushed to `main2`. Done.

## Completion report

**Problem:** `install-units.sh` only *omitted* excluded units from the enable set — it never actively disarmed them. Omission stops a reconcile from *re-enabling* a disabled unit, but does nothing to a unit that was *already armed* before it was paused. The deliberately-paused `garden-ironhorse-fuzz.timer` stayed enabled and kept launching ticks systemd SIGKILLed at their start timeout.

**Fix (`scripts/jobs/install-units.sh`):** Split the single `EXCLUDED_UNITS` list into two classes with distinct reconcile semantics — because the two excluded units need opposite treatment:
- `EXCLUDED_UNITS` (omit-only): `garden-mention-watcher.*` — monitoring-gated, which the maintainer may arm *by hand*, so a reconcile must **never** force-disable it (doing so would undo a deliberate arming on every install).
- `PAUSED_UNITS` (disarm): `garden-ironhorse-fuzz.*` — deliberately paused; actively stopped+disabled on every install/reconcile via a new `disable_paused()` (cheap unbounded `disable` + bounded non-blocking `stop`, idempotent, same split the scaler uses), so the pause is durable regardless of prior arm state.

`is_excluded()` now covers both lists (both stay out of auto-enable and pruning). `disable_paused` is called in both `render()` (install) and `enable_services()` (reconcile). `enable-services --verify` now reports a re-armed paused unit as drift and exits non-zero.

**Tests:** Added `scripts/jobs/test/install-units-paused-disable-test.sh` (mock `GARDEN_UNIT_CTL`, 11 assertions, ~0.6s) covering: install/reconcile disable the paused units, mention-watcher is never force-disabled, intended units still enable, and verify flags a re-armed pause. Wired it into the deploy candidate gate (`GARDEN_DEPLOY_TEST_SUITES` in `deploy-garden.sh`). All pass; both `bash -n` clean.

**Verification:** The two grep-gates that fired under `run-all.sh --dry-run` are pre-existing and unrelated to files I touched (an unindexed skill; the `groom` role loading message-bus).

**Follow-ups:** None. Re-arming ironhorse-fuzz remains the documented two-part act (delete its `PAUSED_UNITS` entries **and** `systemctl --user enable --now`); the comment block was updated to reflect the new mechanism. A host that currently has the stale-armed timer will be disarmed on its next `install`/`enable-services` reconcile (i.e. next deploy).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-paused-unit-reconciliation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (2992580 cached reads)
- Output: 26618 tokens
- Cost: $3.015979
- Wall-clock: 395s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
