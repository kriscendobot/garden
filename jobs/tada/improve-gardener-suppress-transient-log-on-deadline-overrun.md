The work this job specifies has already been completed. No changes were needed.

## Completion report

**Finding:** This job is a duplicate — the exact fix it requests is already merged into `main2`/HEAD.

A peer (endolinbot, ~3 hours before this claim) landed commit `d71677bd2` *"gardener: collapse the deadline-overrun double-journal to one accurate entry"*, which does precisely what this job asks:

- The generic transient `printf` ("transient handler outage … no escalation, left in doin for reaper requeue") in `scripts/jobs/gardener.sh` is now gated behind `[ "${deadline_overrun:-0}" -ne 1 ]` (line ~604-605), so on an rc=124 self-wall hit it is suppressed and only the authoritative deadline-overrun entry ("DETERMINISTIC deadline overrun … stamping garden-deadline-overrun", line ~632) is written.
- Every other transient path (external signal-kill, plain sub-wall timeout, empty-capture blip, transient-claude signature) still emits exactly the generic entry, unchanged.
- The local `log`-level breadcrumb was left intact, per the job's allowance.

**Verification:** I confirmed `d71677bd2` is an ancestor of HEAD (`6f0e35c05`), inspected its diff, and ran `scripts/jobs/test/timeout-classifier-test.sh` — **36 passed, 0 failed**, including the commit's added SUBTEST 6, which asserts that on a near-poison-threshold deadline overrun the generic note is suppressed and exactly one deadline-overrun note is emitted.

**Changes made:** None. The tree already satisfies the specification; no new commit or push was warranted (committing a no-op would only add noise).

**Follow-ups:** None. The invariant ("exactly one authoritative journal entry per rc=124 event") holds and is regression-guarded by the existing test.
