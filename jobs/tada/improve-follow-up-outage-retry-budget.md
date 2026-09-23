Landed on `main2` as `45fbc9a586`.

## Report

**What the bug was.** `follow-up.sh`'s bounded-retry counter charged *every* failed tick to the pending digest. Since quarantine at the ceiling **discards work** (advances the seen-marker over follow-ups that were never executed), a fleet-wide outage — which fails every tick for a reason unrelated to the digest — silently spends the whole budget and then throws good follow-ups away. The 2026-07-28 storm got to 4/5.

**What I changed.**

- `scripts/jobs/common.sh` — added the transient exit convention next to the existing environmental one: `GARDEN_TRANSIENT_RC` (EX_TEMPFAIL 75, named separately per the `GARDEN_ENV_RC`/`GARDEN_OFFLINE_RC` precedent), `die_transient`, and `is_nonattributable_rc` (transient ∪ environmental).
- `scripts/jobs/handlers/follow-up-claude.sh` — its two transient arms (inner-`claude -p` API blip, producer push-contention exhaustion) now `die_transient` instead of `die`, so the classification rides the **exit code** rather than being re-derived from captured text, as the job suggested. The non-transient arm (route-to-maintainer, exit 0) is untouched.
- `scripts/jobs/follow-up.sh` — a failed tick is counted only when **attributable** to the digest. `uncounted_cause` returns the cause when: the handler exited a not-attributable rc; `fleet_brake_engaged`; the output carries a transient `claude -p` signature; or the output is empty and the rc is `is_transient_empty_failure`. An uncounted tick leaves `fail-count` *and* the seen-marker untouched and exits `GARDEN_TRANSIENT_RC`.
- **Uncounted is not unbounded** (the optional wall-clock cap): a new `$GARDEN_STATE/follow-up/transient` marker (`<first-epoch> <sha> <notified>`) tracks the stretch, keyed by the pending set exactly like the streak. After `GARDEN_FOLLOWUP_TRANSIENT_MAX_SECS` (default 6h) it escalates **once** to the maintainer and keeps retrying — deliberately never quarantining, since the cause is environmental and a human fixing the host recovers the work.
- `scripts/jobs/self-heal-run.sh` — its EX_TEMPFAIL normalization now uses `is_nonattributable_rc` and says "transient/environmental" rather than "connectivity outage". Numerically identical today (all three rcs are 75); correct if they're ever tuned apart. So an outage tick costs no budget, no `Failed with result 'exit-code'`, and no self-heal responder.

**Tests.** New `SUBTEST 13d` plus `scripts/jobs/test/follow-up-outage-stub.sh`: asserts each not-attributable cause (rc signal / transient signature / engaged fleet brake) leaves the streak at 1 with nothing quarantined, that uncounted ticks exit 75, that an attributable failure still counts 1→2 and clears the stretch marker, and that a backdated long stretch notifies the maintainer exactly once without quarantining. Suite: **336 passed / 30 failed**, against a **332 / 30** baseline measured on the same fixtures with my changes stashed — +4 passes, no new failures. The 30 are pre-existing (a missing `_fetch_stderr_is_corrupt` helper, an absent `garden-gardener@.service` in this checkout, gh-dependent issue-inbox cases).

**Follow-ups.**
- The shared garden repo at `/home/kris/garden2/.git` is reporting `gc.log` corruption on push — `fatal: unable to read 9ad05cc3563a7ba4b8f3a0b3e7941090e4d427d6` / `failed to run repack`. My push succeeded on retry, but that is host-level repo health for the root-repo-guard / a maintainer; I did not touch it (no git in the garden root).
- `gardener.sh` still classifies its own inner-claude failures by text and rc separately; it could adopt `is_nonattributable_rc` for symmetry, but nothing is broken there today.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-follow-up-outage-retry-budget.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 93 tokens (4519329 cached reads)
- Output: 32812 tokens
- Cost: $4.223084500000001
- Wall-clock: 764s

<!-- garden-usage-end -->
