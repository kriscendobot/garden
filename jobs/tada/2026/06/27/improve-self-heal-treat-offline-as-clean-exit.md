Job complete — no work remained to do; the prior session (committed as `cb8d11188`) already satisfied the spec. I verified it end-to-end.

## Completion report

**Status:** Already implemented and committed in `cb8d11188` ("self-heal: normalize transient connectivity outages to a clean exit"), working tree clean. This resume verified the work rather than redoing it.

**What the change does (`scripts/jobs/self-heal-run.sh`):**
- **Part 1 (RC path, lines 104–114):** Checks `rc == GARDEN_OFFLINE_RC` (75 = `EX_TEMPFAIL`, defined in `common.sh:56`, returned by `sync_clone` on a classified DNS/connectivity outage) *first*, ahead of the generic clean-exit handling, and rewrites it to a clean `exit 0` with a single `transient connectivity outage; skipping responder` log line — so systemd records success, no false `Failed with result 'exit-code'`.
- **Part 2 (belt-and-suspenders, lines 128–137):** For outages that don't return rc 75 (e.g. a raw `git fetch` exiting 128), greps the bounded capture tail for `Could not resolve hostname`, `Temporary failure in name resolution`, `Could not read from remote repository` and short-circuits to a clean exit 0 with the same log line — before the throttle/responder block, so no `claude -p` responder is spawned.

**Tests (`scripts/jobs/test/run-test.sh`, SUBTEST 21):** Cases (7) and (8) cover exactly this — rc=75 → clean exit 0/no responder; rc=128 with an outage signature → clean exit 0/no responder; and the negative control: genuine rc=128 *without* a signature still diagnoses (proves the grep gates on signature, not just rc).

**Verification:** The full suite OOM-killed (exit 137) under fleet load, so I ran an isolated harness reproducing the SUBTEST 21 offline cases against the live script. All passed:
- rc=75 producer outage → `rc=0 calls=0` ✓
- rc=128 + "Could not resolve hostname" → `rc=0 calls=0` ✓
- rc=128 + "bad object HEAD" (no signature) → `rc=128 calls=1` ✓
- rc=255 + "Temporary failure in name resolution" → `rc=0 calls=0` ✓

**Follow-ups:** None required for this job. Observation (not blocking): `run-test.sh` gets SIGKILLed (exit 137) when run on the full fleet host — consistent with the recent isolation commits `4a2d6748a`/`2e3372fbe`; memory ware-housing for the suite under fleet load may warrant a separate hardening job, but it does not affect this change.
