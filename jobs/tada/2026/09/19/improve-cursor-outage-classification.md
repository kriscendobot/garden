Done. Summary of the work:

## Completion report

**Problem.** Two independent cursor reads failed simultaneously with `rc=1`, a correlated journal-read outage that escaped the host-shared temporary-outage cooldown. Root cause: the journal clone/repair step (`ensure_clone`) runs *before* any fetch, and in both `cursor-get.sh` and `cursor-set.sh` it sat **outside** the outage classifier. Its comment assumed every clone failure is a local checkout/credentials fault that must stay loud — but a network outage striking during a *needed* (re)clone (a fresh host, a reaped or partial clone) dies `rc=1` before the latch, so simultaneous cursor reads all die loud at once, bypassing the cooldown.

**Fix (all on `main2`, commit `c2f7cac953`).**
- Added `ensure_clone_or_latch_outage` (common.sh): runs `ensure_clone` in a subshell, captures its diagnostic, and on a transient transport outage — a known offline signature, or the bounded ambiguous `rc=1` clone-failure shape — latches the shared cooldown and exits `GARDEN_OFFLINE_RC`; positively-identified **local, auth, corruption, and missing-upstream** failures are re-raised loud with their original rc and never latch.
- Broadened `journal_bounded_fetch_is_ambiguous_outage`'s marker to also recognize the bounded (re)clone failure line (`clone of … failed`), and factored the four exclusion classes into a new `journal_diagnostic_is_definite_failure` so the fetch, clone, and cursor-set push/verify paths share one non-transient boundary and cannot drift.
- Both scripts now consult the host outage latch *before* the clone step, so a live sibling window skips the clone attempt too.
- Refactored cursor-set's two inline four-predicate exclusion blocks onto the shared helper.

**Verification.** Added a Layer 1b unit subtest covering the six clone-classification outcomes (offline→latch, ambiguous→latch, auth/local/gone→loud, healthy→0). Full suite: **55 passed, 0 failed**; `bash -n` and shellcheck clean (only pre-existing info notes).

**Follow-up (not done, optional).** `reclone_clone` still uses a bare `git clone` with no `timeout` wrapper; a *hung* clone during a half-open connection would block rather than return `rc=1`. Bounding it with `GARDEN_FETCH_TIMEOUT` (as `bounded_clone` already does) would make the clone path fully bounded, but carries a legit-large-clone-timeout risk and was out of scope for this rc=1 incident.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-cursor-outage-classification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (3392747 cached reads)
- Output: 37730 tokens
- Cost: $3.8151265000000003
- Wall-clock: 520s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
