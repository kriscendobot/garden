---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 322
panel_kind: design
base_ref: 1956e545d42955115d6a475d8dd7c08f8a981b6c
rounds: 1
disposition: must-fix
must_fix_total: 6
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 3a6ef782aadb
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #322 (design)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `457d1ce0`

seat verdicts (7): copyeditor=pass critic=must-fix decomplector=must-fix ergonomist=must-fix novice=comment pedant=comment skeptic=comment
must-fix items (6):
- critic: `designs/familiar-flatpak-pipeline.md:150-163` and `:1182-1202` (Known Gaps and TODOs) state, with real urgency, that...
- critic: § Release-Blocking Policy (`:1015-1060`) defaults to gating the *whole* `make` job on Flatpak build success, so a Fl...
- decomplector: The design models Familiar-daemon *liveness/identity* by a **place** (whether a socket happens to exist under the cur...
- decomplector: The Electron binary name (`Familiar`, capital-F) is a value duplicated as a literal string in both `launcher.sh` (§ ...
- ergonomist: `§ Build Script: scripts/make-flatpak.mjs` introduces a target-arch selection surface that spells differently from e...
- ergonomist: None — the manifest shape, `finish-args` justification table, npm-script naming (`step:flatpak` matches the `step:*...
