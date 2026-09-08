---
kind: panel-run
repo: kriscendobot/endo-but-for-bots
pr: 1227
panel_kind: design
base_ref: 51b99651b63d4e652f9af4eae603422783233182
rounds: 1
disposition: must-fix
must_fix_total: 6
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 7d7cb7cadf16
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/endo-but-for-bots #1227 (design)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `898de272`

seat verdicts (8): copyeditor=comment critic=must-fix decomplector=must-fix ergonomist=comment novice=comment orthographer=comment pedant=comment skeptic=must-fix
must-fix items (6):
- critic: **Crash-loop breaker can be evaded by a "flapping" bot indefinitely** (`## Failure, backoff, and credential expiry`)....
- critic: `## Retention and quotas` makes the daemon's quota-safety conclusion (bounded retained-child count under automatic li...
- decomplector: **[should-fix] Operator-pause is modeled as place-oriented process state, but the design's own prose claims it as if ...
- skeptic: **False premise: `provideHost` does not currently reject an unrecognized `bot` key.** The design states as present-te...
- skeptic: **Unenforced "one incarnation per guest" premise.** Formula shape leans entirely on `provide`'s `controllerForId` mem...
- skeptic: The minion.town per-`iss+sub` quota-slot-once assumption is explicitly flagged as unconfirmed by the design itself (R...
