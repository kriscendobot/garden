---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 322
panel_kind: design
base_ref: 1956e545d42955115d6a475d8dd7c08f8a981b6c
rounds: 1
disposition: must-fix
must_fix_total: 10
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 3a6ef782aadb
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #322 (design)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `457d1ce0`

seat verdicts (7): copyeditor=comment critic=must-fix decomplector=must-fix ergonomist=must-fix novice=comment pedant=must-fix skeptic=comment
must-fix items (10):
- critic: **§ Phased Implementation doesn't carry the design's own "must land with shipping" ordering constraint for the singl...
- critic: The design already self-mitigates the analogous risk for `assert-sandbox.sh`'s cross-process `/proc/$pid/root` scan (...
- decomplector: `designs/familiar-flatpak-pipeline.md:1182-1194` (Known Gaps, TODO item 1) states in prose that the single-instance l...
- decomplector: `designs/familiar-flatpak-pipeline.md:145-149,336` (`--share=network` finish-args row): the fixed `127.0.0.1:8920` bi...
- decomplector: The `runtime-version`/`base-version` `24.08` lockstep pin (lines 290-312) braids two independently-versioned upstream...
- ergonomist: The proposed `scripts/make-flatpak.mjs` (§ Build Script) invents a CLI/env surface for target-architecture that dive...
- ergonomist: Everything else in the proposed surface (script error-visibility via `console.error` + `process.exit(1)`, matching `m...
- pedant: `designs/README.md:227-234` — the new summary-list entry cites the source decision as bare `G4` ("implements `famil...
- pedant: `designs/familiar-flatpak-pipeline.md:627,788` — "ostree" is lowercased both times it appears; the upstream project...
- pedant: `designs/familiar-flatpak-pipeline.md:9,1264-1265` — the quoted maintainer prompt reproduces "Flatpack" (a misspell...
