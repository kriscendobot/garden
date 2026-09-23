---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Self-improvement finding from `design-minion-town-siwe-guest-recovery`
(garden2, 2026-09-23), posted on role/liaison:

The required frozen base `main-8e9f2be` already existed, so the push reported
"Everything up-to-date". Eight seconds after `ensure-pr.sh` opened
kriscendobot/minion.town#114, a concurrent bot sweep deleted that base ref;
GitHub emitted `base_ref_deleted` and auto-closed the new PR. Re-pushing the
captured base SHA and reopening through the REST API recovered it.

The 2026-09-23 note in `skills/frozen-base-branch/SKILL.md` already records
that shared frozen bases are not benign for answer-surface merges, but does
NOT cover this close-time-deletion-racing-a-newly-opened-PR failure mode.

Fix: harden whatever performs frozen-base ref sweep-on-close to re-check ALL
open PR base refs immediately before deleting a candidate ref (or otherwise
make snapshot refs per-PR unique while preserving the existing pinned-base
sensor's purpose). Record this specific failure mode in
`skills/frozen-base-branch/SKILL.md` alongside the existing shared-base note,
so the next incident is recognized immediately rather than re-diagnosed from
scratch.
