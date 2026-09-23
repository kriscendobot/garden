---
kind: panel-run
repo: kriscendobot/endo-but-for-bots
pr: 891
panel_kind: design
base_ref: e84a4c83c049f1b113436c0fcceddfb5be9be9a4
rounds: 1
disposition: must-fix
must_fix_total: 10
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: cbdc810aee88
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/endo-but-for-bots #891 (design)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `2d1f26b6`

seat verdicts (7): copyeditor=comment critic=must-fix decomplector=must-fix ergonomist=comment novice=comment pedant=must-fix skeptic=must-fix
must-fix items (10):
- critic: `designs/endo-zone.md` Phase 3 (Design § Phased Implementation, item 3) claims the daemon durable adapter reconciles...
- critic: The claim that "an accessor-bearing or proxied value cannot present one shape to the check and another to persistence...
- decomplector: `designs/endo-zone.md`, Phase 3 (daemon durable adapter): the design complects **place** (the in-worker resolved view...
- decomplector: `designs/endo-zone.md`, "Naming and `makeOnce`" (comment-only): the key-state tracker is described as "a heap `Set`" ...
- decomplector: The injective-label-mapping caveat ("the used-key set runs pre-mapping and cannot catch a mapper-induced alias") is h...
- pedant: **[must-fix]** `designs/endo-zone.md` uses em-dashes pervasively in prose — 28 occurrences (lines 25, 57, 74, 91, 9...
- pedant: **[should-fix]** Heading-capitalization inconsistency within `## Design`: `### A portable allocation contract` (line ...
- pedant: **[should-fix]** `designs/README.md` line 524, "Its M-size (3-4 day) estimate is small enough to absorb within M10's ...
- skeptic: **[must-fix] "Passable remotable" contradicts the never-reached-by-`E()` premise the isolation argument depends on.**
- skeptic: **[should-fix] Phase 3's "resolved local view populated at incarnation start" elides how a synchronous requirement is...
