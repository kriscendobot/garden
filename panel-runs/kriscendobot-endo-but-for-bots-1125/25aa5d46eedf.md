---
kind: panel-run
repo: kriscendobot/endo-but-for-bots
pr: 1125
panel_kind: code
base_ref: ff3ca7d45d706b55cf56480f36aea4eed67ae540
rounds: 1
disposition: must-fix
must_fix_total: 8
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 25aa5d46eedf
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/endo-but-for-bots #1125 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `12b9bbb5`

seat verdicts (30): archivist=comment assessor=comment benchmarker=pass breaker=must-fix changeset-auditor=pass corner-prober=must-fix coverage-auditor=comment curator=comment duality-auditor=pass engine-realist=must-fix fast-checker=comment gateway=pass integrator=pass locksmith=must-fix migrator=comment orthographer=comment packager=pass prover=must-fix pruner=pass purist=comment releaser=pass saboteur=comment scribe=comment spec-keeper=comment stylist=pass surfacer=comment transplanter=pass typist=comment warden=pass wire-watcher=comment
must-fix items (8):
- breaker: ## Per-juror block — breaker
- corner-prober: **[must-fix-loop]** Leaf-only retention key collision across differently-pathed, same-leaf invitations from one invit...
- corner-prober: **[summary-fix]** No test drives `accept()` through the pre-migration-guest fallback branch (`manager.js:7040-7057`, ...
- corner-prober: **[summary-fix]** `reincarnateMailboxPins`'s two thrown error branches (non-`handle` self id; agent formula neither `...
- engine-realist: ## Per-juror block — engine-realist — PR #1125
- locksmith: Good, confirmed. Now writing the per-juror block.
- prover: `packages/daemon/src/manager.js:6371-6390` (`getAllNetworkAddresses`): the new `readable-directory` unwrap branch —...
- prover: The invitation atomicity work (`invitationJobs` serial queue, `manager.js`'s `accept`/`cancelInvitation`) is well cov...
