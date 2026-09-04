---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 717
panel_kind: design
base_ref: 4de1c097814845af82662655fed4f84141f2de62
rounds: 1
disposition: must-fix
must_fix_total: 8
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: ae2f97bdb7e4
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #717 (design)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `c4f3fc50`

seat verdicts (7): copyeditor=comment critic=must-fix decomplector=must-fix ergonomist=comment novice=comment pedant=pass skeptic=must-fix
must-fix items (8):
- critic: The "What is the Problem Being Solved?" section presents `forever-pending` as full closure on "a carrier that is garb...
- critic: Gap in "First-listener arrival plumbing" / the flowchart's `MARK` step: both assume the carrier's `retained` entry st...
- critic: Whether `@endo/env-options` should grow numeric-option support (mentioned, deferred to implementation PR) is implemen...
- decomplector: **Duplicated mutable state for one fact, updated at three sites instead of one.** "Delivered" is tracked in two indep...
- decomplector: **The headline invariant is scoped away by a modeling choice the design doesn't own.** The design's central deliverab...
- skeptic: `designs/promise-debug-view.md:304-318` (the `liveSet` bullet under "Structures and entry shape"): the design states ...
- skeptic: Test-catalog completeness, Phase 2 and Phase 4 (`designs/promise-debug-view.md:788-833`): the parent design's own can...
- skeptic: `designs/promise-debug-view.md:721-734` ("Native promises"): the prose states opportunistic native-promise tracking a...
