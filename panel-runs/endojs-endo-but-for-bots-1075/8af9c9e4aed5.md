---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1075
panel_kind: code
base_ref: origin/llm
rounds: 1
disposition: must-fix
must_fix_total: 4
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 8af9c9e4aed5
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1075 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `65e6a968`

seat verdicts (29): archivist=comment assessor=pass benchmarker=pass breaker=pass changeset-auditor=pass corner-prober=must-fix coverage-auditor=comment curator=pass duality-auditor=pass engine-realist=pass fast-checker=comment gateway=pass integrator=pass locksmith=pass migrator=pass packager=pass prover=pass pruner=pass purist=pass releaser=pass saboteur=pass scribe=pass spec-keeper=pass stylist=pass surfacer=pass transplanter=pass typist=pass warden=pass wire-watcher=pass
must-fix items (4):
- corner-prober: **Claimed "inert stand-in" contract is untested.** The file's own comment states "Lockdown tames the async-function c...
- corner-prober: **No distinctness check against the global `Function` constructor.** The file asserts `AsyncFunction !== AsyncGenerat...
- corner-prober: **Missing syntactic form: class methods.** Declaration/expression/object-method/arrow are covered; instance and stati...
- corner-prober: **No frozen/extensible check on `%AsyncFunctionPrototype%` post-lockdown.** The sibling comment pattern ("lockdown fr...
