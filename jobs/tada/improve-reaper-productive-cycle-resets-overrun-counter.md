Empty inbox. Work is complete.

## Completion report

**What the job asked:** Extend the reaper's productive-cycle doctrine to the `garden-deadline-overrun` counter, symmetric to how it already spares the `garden-reaped` requeue counter, so a builder on the sanctioned resume treadmill (which hits its own 2400s handler wall every cycle by design and gets `garden-deadline-overrun` stamped each time) no longer false-poisons at `GARDEN_REAP_OVERRUN_THRESHOLD=2` after two *productive* wall-hits.

**What I changed:**

- `scripts/jobs/reaper.sh` — In the requeue loop, the `has_productive_cycle_hint` branch now sets a `productive` flag. After `overrun="$(deadline_overrun_count "$f")"` is read, a productive cycle with a non-zero overrun count:
  - zeroes `overrun` for the poison decision, **and**
  - strips the `garden-deadline-overrun` marker from the requeued `body` (via `grep -vE "$DEADLINE_OVERRUN_MARKER_RE"`). This is the crucial half: the marker survives `clean_body` by design, so merely zeroing the local variable would let the next cycle re-read the stale N and re-accumulate — the marker must actually be re-stamped to 0 on the requeued job. A NON-productive wall-hit is untouched, so a genuinely deadlocked handler (which never earns the productive marker) still poisons at threshold 2 with the `deadline-overrun` signature.

- `scripts/jobs/test/productive-cycle-test.sh` — Extended `place_stale` to optionally stamp an overrun-counter marker, and added **SUBTEST 4** with two cases (poison threshold lifted to 99 so only the overrun path is under test): (a) a productive wall-hit at overrun-threshold 2 is requeued to `todo/` with the overrun counter reset and its marker stripped, NOT poisoned; (b) a non-productive wall-hit at overrun-threshold 2 still poisons into `plan/` with `poison_signature: deadline-overrun`.

**Verification:** `bash -n` clean on both files; shellcheck shows only a pre-existing unrelated SC2034. Full test suite passes 10/10 (all prior 8 plus the 2 new).

**Follow-ups:** None. The concrete case that motivated this (the stage-3 `xs2rust-endor-build-stage3` `text-math-json` orchestration child) will no longer false-poison-and-halt its serial chain once this deploys.

Committed as `28bf014a3` and pushed to `main2` (first-attempt CAS success).
