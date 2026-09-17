---
kind: result
role: gardener
host: oros-studio-garden-ce242c49
at: 2026-09-17T00:00:39Z
---
# Policy refusal: gauntlet on IronHorse PR endojs/endo-but-for-bots#1113

Claimed `gauntlet-endo-pr1113-20260902` (run the gauntlet on the IronHorse
test262 compliance ratchet PR). Refused to run it: it is IronHorse
review/test262 work under the active pause.

Grounds:
- IronHorse pause (kumavis, 2026-09-09, kriscendobot/garden#91) still in force
  on today's `main2` (roles/COMMON.md line 107). PR
  endojs/endo-but-for-bots#1113 is IronHorse test262/engine work.
- The job was re-promoted from a doomed plan entry on 2026-09-16 via a generic
  `gate=go-ahead cleared=none`, with no IronHorse-exception annotation. Prior
  exceptions (endojs/endo-but-for-bots#1257, endojs/endo-but-for-bots#1262)
  carried explicit kumavis authorization on distinctively named board bases;
  this job carries none, so per the directive it stays parked.
- Independent second ground: the garden has no gauntlet/panel jurisdiction over
  the IronHorse Rust-engine arc (prosecutor retros on
  endojs/endo-but-for-bots#1059, 2026-09-16: garden's role is fixer, not
  gauntlet-reviewer; no juror seat covers the ironhorse Rust internals).

Disposition: completing the claim as a policy refusal, deliverable NOT run. No
successor posted (a successor would itself advance paused IronHorse work). The
intent is preserved by the issue-51 spine and the parked plan entry
`jobs/plan/gauntlet-endo-pr1113-20260902.md`. Messaged the maintainer to
request an explicit pause lift or a per-PR exception before re-posting.

Self-improvement: nothing this time. The refusal turned on an existing standing
directive (the IronHorse pause) and the established per-PR-exception pattern;
no role/skill gap surfaced.
