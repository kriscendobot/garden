Inbox empty. Work is complete, verified, and pushed.

## Completion report

**Job:** Harden `set-schedule.sh` to validate the `preflight:` reference at write time so a dangling gate can never be committed.

**What I found:** Much of this job's surface had already landed in prior commits (`48053a960` set-time env-var guard, `6f0e35c05` scheduler escalation, `0e1d7a0ad` authored the missing `gardening/xs2rust-endor-press-preflight.sh`). The one gap the job spec called out that remained open was the **"or when preserving an existing `preflight:` line"** clause: the preserve path (`set-schedule.sh:60`) copied a schedule's current `preflight:` reference back verbatim on a plain cadence re-run, so a gate that had gone dangling could be **re-committed silently** and then fail open every tick in the scheduler.

**What I changed** (commit `fe4b52c91`, pushed to `main2`):
- `scripts/jobs/set-schedule.sh` — factored the resolve-and-executable check into a `validate_preflight()` helper and now call it for **both** sources: the env-var gate (up front, before touching the clone) and a **preserved** gate (inside the CAS loop, off the freshest board state). Either path refuses the write with a clear error if the gate is missing or non-executable. Updated the header comment accordingly.
- `scripts/jobs/test/run-test.sh` — added a SUBTEST 8b case for the preserve-path rejection: register a schedule with a real executable gate, delete the script, then re-run `set-schedule` with a new cadence and no env var → the write is refused.

**Verification:** Ran SUBTEST 8 + 8b in an isolated harness (the full `run-test.sh` aborts earlier at SUBTEST 6 on a **pre-existing, unrelated** `maintainer-reply` flake — confirmed reproducing identically on the clean stashed tree, in code my change doesn't touch). All 15 assertions pass (`8B-RESULT pass=15 fail=0`), including the new preserve-path rejection. `bash -n` clean; shellcheck adds no new warnings.

**Companion journal-side sweep:** Swept all `journal2` schedules with `preflight:` lines — both (`scholar-library-cycle.md`, `xs2rust-endor-press.md`) now resolve to executable scripts in `main2`. The xs2rust dangling reference was already fixed (script authored by `0e1d7a0ad`); the recurring `scheduler.sh:126` WARN clears on the next deploy of `main2` to the root checkout. Nothing else dangles.

**Follow-up (out of scope, flagging):** `run-test.sh` SUBTEST 6 (MAINTAINER CHANNEL) FATALs pre-existingly — `maintainer-reply.sh` picks the oldest unread maintainer message via `head -1`, which grabs an earlier leaked message lacking `reply_to`, aborting the whole harness under `set -e`. Worth a separate job to make that subtest target the message it just sent.
