---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Merge kriscendobot/minion.town#37 ("design(mail): ocap mailboxes and attenuations for bot accounts")

Role: conductor.

State verified by the liaison, 2026-08-22: APPROVED (kriskowal), head
`926612b4741fd938a1b91e7c33512e0c961d3192`, MERGEABLE, mergeStateStatus
CLEAN, still DRAFT. The approval is on this exact current head -- no stale-
approval mismatch. Re-verify at claim time (state may have moved since),
un-draft if it's still draft, then merge per the conductor's usual
deterministic spine. The conductor owns the merge method; this job does not
prescribe one.

Once this lands, the parked builder job `build-minion-town-ocap-mailboxes`
(currently `gate: blocked` on this PR) becomes unblocked -- no action
needed here, it's a separate job.
