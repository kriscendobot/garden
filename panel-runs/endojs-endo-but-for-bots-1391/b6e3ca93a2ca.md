---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1391
panel_kind: code
base_ref: ef4662f04b575a1edb0e716a4fc03f847dd7f53f
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 61a08fd144122f9d9464823a56b402dc857bc2b1
must_fix_total: 11
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: b6e3ca93a2ca
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1391 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `61a08fd1`

seat verdicts (33): archivist=pass assessor=pass benchmarker=pass breaker=must-fix changeset-auditor=pass corner-prober=comment coverage-auditor=must-fix curator=pass duality-auditor=pass engine-realist=comment fast-checker=comment gateway=pass integrator=comment locksmith=pass migrator=pass orthographer=pass packager=pass procurer=pass prover=pass pruner=comment purist=pass reexport-auditor=pass releaser=pass saboteur=must-fix scribe=pass spec-keeper=must-fix stylist=comment surfacer=pass thesaurus=pass transplanter=pass typist=pass warden=pass wire-watcher=pass
must-fix items (11):
- breaker: **[should-fix]** `assertSturdyRefShape` (`packages/ses/src/intrinsics.js:98-121`) is meant to verify, per its own thr...
- breaker: **[comment-only]** The `firstWinsPropertyNames` JSDoc (`global-object.js:16-30`) states the invariant precisely ("its...
- coverage-auditor: `packages/sturdyref/package.json` line 43: `"test:xs": "exit 0"`
- coverage-auditor: The actual XS smoke test (`packages/ses/test/_sturdyref-xs-smoke.js`) is in `packages/ses` and runs via `packages/ses...
- coverage-auditor: **Update `packages/sturdyref/package.json`** to delegate its XS test to `packages/ses` (e.g., `"test:xs": "yarn -C .....
- coverage-auditor: **Update the PR body** to explicitly state: "XS testing for `@endo/sturdyref` is covered by `packages/ses`'s `test:xs...
- saboteur: **Must-fix — Proxy-trap reentrancy defeats the shape check.** `assertSturdyRefShape` (packages/ses/src/intrinsics.j...
- saboteur: **Out of scope / already disclosed.** Any function exposing `enliven`/`isSturdyRef` statics passes the guard regardle...
- saboteur: **Mitigated.** The accessor-global case (`_sturdyref-accessor.js`) is correctly rejected by reading the top-level bin...
- spec-keeper: **[should-fix]** The changeset's claim about which `SturdyRef` bindings throw is broader than what the code and tests...
- spec-keeper: **[comment-only]** Relatedly, `assertSturdyRefShape` (`src/intrinsics.js:95-121`) rejects *any* accessor `SturdyRef` ...
