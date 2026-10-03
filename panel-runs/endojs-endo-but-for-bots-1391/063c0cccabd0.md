---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1391
panel_kind: code
base_ref: ef4662f04b575a1edb0e716a4fc03f847dd7f53f
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 008820366e6d44acb7a19cae585a8cae2eccfe81
must_fix_total: 3
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 063c0cccabd0
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1391 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `00882036`

seat verdicts (33): archivist=comment assessor=pass benchmarker=pass breaker=pass changeset-auditor=pass corner-prober=comment coverage-auditor=pass curator=pass duality-auditor=pass engine-realist=comment fast-checker=comment gateway=comment integrator=must-fix locksmith=comment migrator=pass orthographer=pass packager=pass procurer=pass prover=comment pruner=must-fix purist=pass reexport-auditor=pass releaser=pass saboteur=pass scribe=pass spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=pass warden=pass wire-watcher=pass
must-fix items (3):
- integrator: **[must-fix] This PR locks SES behavior around a second, structurally incompatible "SturdyRef" concept, without recon...
- pruner: **`packages/ses/src/global-object.js` lines 27–30** — The comment block for `firstWinsPropertyNames` includes imp...
- pruner: **`packages/ses/test/_sturdyref-shim-first.js` lines 5–7** — The comment ending *"Like the real shim before `lock...
