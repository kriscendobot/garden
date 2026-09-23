---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1264
panel_kind: design
base_ref: ff3ca7d45d706b55cf56480f36aea4eed67ae540
rounds: 1
disposition: must-fix
must_fix_total: 8
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 1b2bbc3ea93e
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1264 (design)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `13e9cd35`

seat verdicts (8): copyeditor=comment critic=must-fix decomplector=must-fix ergonomist=comment novice=comment orthographer=pass pedant=comment skeptic=must-fix
must-fix items (8):
- critic: The migration plan's completeness argument rests on "a repo-wide grep... finds two groups" (in-daemon read/dispatch s...
- critic: `provide(id, 'readable-blob')` at `manager.js:2110` and `:7359` pass the old string as `provide`'s `expectedType` par...
- decomplector: The Migration Path section asserts, directly after Phase 1 step 2, that the deserialization alias "establishes the in...
- decomplector: § Migration Path enumerates seven-plus independent call sites (`collectFormulaHashes`, `getContentIdentityForId`, `e...
- decomplector: The exhaustive external-consumer rekey (Phase 2 step 5) and its four pinning tests are implementation-review territor...
- skeptic: The design's own worst-named failure mode has no test guarding it. § "Migration Path" states plainly that a miss in ...
- skeptic: The reconciliation section's grounding citation is already stale in a way that undercuts the design's own reasoning a...
- skeptic: The `extractLabeledDeps` `case 'readable-tree':` citation gives line 717 (the function's opening line); the actual ca...
