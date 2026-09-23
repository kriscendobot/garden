---
kind: panel-run
repo: kriscendobot/endo-but-for-bots
pr: 1158
panel_kind: design
base_ref: f109e8f42281556439434b71c9717811185b9155
rounds: 1
disposition: must-fix
must_fix_total: 10
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: c80baa2fcbdd
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/endo-but-for-bots #1158 (design)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `8993aa63`

seat verdicts (7): copyeditor=comment critic=must-fix decomplector=comment ergonomist=must-fix novice=comment pedant=comment skeptic=must-fix
must-fix items (10):
- critic: The `float64` order-preserving byte transform (`## Schema and the three type bands`, "flip the sign bit for non-negat...
- critic: The startup reconciliation step (`## Daemon formulas and durable references`, protocol step 5: "reconcile the ledger ...
- critic: The claim that DynamoDB is "the narrowest widely available" portability target for a managed serverless KV store is a...
- ergonomist: **Inconsistent error-visibility across sibling mutation methods.** `TableWriteInterface`'s three existence-preconditi...
- ergonomist: **`KeyError` conflates two unrelated failure domains.** The Errors section defines `KeyError` as covering "a non-Key,...
- ergonomist: **`update`'s full-row requirement isn't stated where the surprise happens.** `update(row)` requires the complete row ...
- ergonomist: The only sanctioned path to a globally ordered table is a constant partition key, which the design itself flags as a ...
- skeptic: **§ Motivation / § Verification plan — the float64→DynamoDB rationale misstates the actual failure mode.** The ...
- skeptic: **§ Verification plan — the mutation-queue concurrency guarantee is asserted but not in the test catalog.** § Dae...
- skeptic: `provideDatabase(petName)` doesn't say what happens when `petName` already names a *non*-database formula (create-or-...
