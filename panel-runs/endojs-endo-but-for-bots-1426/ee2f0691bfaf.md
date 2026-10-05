---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1426
panel_kind: code
base_ref: 395c48558460c12a553f17ecde15fbfe095e4715
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 418e76967946fd0c988d512ea5021a2e16ed0bed
must_fix_total: 11
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: ee2f0691bfaf
recorded_by: endolin-garden2-5bcdff64
---

# Panel run — endojs/endo-but-for-bots #1426 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `418e7696`

seat verdicts (33): archivist=pass assessor=pass benchmarker=pass breaker=comment changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=pass duality-auditor=pass engine-realist=pass fast-checker=comment gateway=comment integrator=must-fix locksmith=pass migrator=pass orthographer=pass packager=pass procurer=pass prover=pass pruner=must-fix purist=comment reexport-auditor=pass releaser=pass saboteur=pass scribe=comment spec-keeper=pass stylist=pass surfacer=pass thesaurus=pass transplanter=pass typist=pass warden=pass wire-watcher=pass
must-fix items (11):
- integrator: **must-fix: the PR body does not follow the template.** `## Scaling Considerations` and `## Upgrade Considerations` a...
- integrator: **must-fix: the Phase and evidence ledger is missing.** The phase/evidence pre-pass returned `blocked`. It found no l...
- integrator: **should-fix: the commits are not grouped for the reader of the merged history.** The branch has one `feat` commit fo...
- integrator: `feat(familiar)`: deliver warnings on every Chat page load, with preload replay;
- integrator: `feat(chat)`: the banner;
- integrator: `docs`: the design update and changeset.
- integrator: **comment-only: the channel name is duplicated in two places.** `preload.mjs:25` repeats `SECURITY_WARNINGS_CHANNEL` ...
- integrator: **comment-only: the concepts and conventions fit the project.** The banner reuses the design's existing `familiar:sec...
- pruner: **PR body § Testing Considerations: excessive technical justification.** Lines 8–10 of that section expand a routi...
- pruner: **packages/familiar/src/security-warnings.js § module comment: design rationale leakage.** Lines 689–706 spend ~20...
- pruner: **packages/chat/security-warning-banner.js § module comment: implementation narrative.** Lines 177–187 narrate the...
