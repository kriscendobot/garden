---
kind: panel-run
repo: kriscendobot/minion.town
pr: 180
panel_kind: code
provider: openai
base_ref: c7bdf2018897930f413a2caf21191f2b26b4b514
pr_body_hash: e6dff3ba88ae8f7088eb46f6b6fd4d0d5d78173b382aee6adc142d8544dacc3d
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: f9422e0afb87fa9302cc2e18020dbe848ea1adc2
must_fix_total: 14
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: e3dc7ec1c0d7
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #180 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `f9422e0a`

seat verdicts (34): archivist=must-fix assessor=must-fix benchmarker=must-fix breaker=pass changeset-auditor=pass corner-prober=must-fix coverage-auditor=comment curator=pass decomplector=pass duality-auditor=pass engine-realist=must-fix fast-checker=must-fix gateway=comment integrator=comment locksmith=pass migrator=pass orthographer=pass packager=pass procurer=comment prover=pass pruner=comment purist=pass reexport-auditor=pass releaser=pass saboteur=comment scribe=pass spec-keeper=pass stylist=must-fix surfacer=pass thesaurus=pass transplanter=pass typist=must-fix warden=pass wire-watcher=must-fix
must-fix items (14):
- archivist: `DEPLOYMENT.md:603-618` documents `readwrite.url` and `read.url` files but does not state their lifecycle. Clarify th...
- archivist: None.
- assessor: must-fix: `deploy/aws/scripts/deploy-git-remote.sh:69` writes the literal `$(openssl rand -hex 32)` into `control.env...
- assessor: None.
- benchmarker: must-fix-loop — Commit `1a8c9c6` claims that cap-hit creates rescan sidecars only when the directory changes. The a...
- benchmarker: Closed — The earlier `createNamed` index-versus-full-scan claim was explicitly superseded by `b824519`, which drops...
- corner-prober: `src/config.ts:226` adds the deployment gate for mounting Git tools, but no test exercises its boundary contract. Add...
- corner-prober: `src/endo/guest-control.ts:457` claims same-name operations are serialized so only one binding is created, yet the ne...
- engine-realist: must-fix: `src/endo/guest-control.ts:460-508` locks `create` only against another bind, not `remove` at `src/endo/gue...
- fast-checker: `test/git-remote/config.test.ts:60` spot-checks only five invalid port strings despite `portFrom` defining the result...
- fast-checker: `src/endo/guest-control.ts:458` claims that any number of concurrent `git.create` calls for one pet name cannot alloc...
- stylist: **must-fix:** `test/endo-root-host-socket.test.ts:99` introduces rest parameter `args`; rename it to `arguments` and ...
- typist: should-fix: Replace added em dashes in prose comments at `deploy/aws/scripts/deploy-git-remote.sh:61`, `src/endo/git-...
- wire-watcher: must-fix: `src/endo/git-remote/git-caplet.ts:66-75` sends the owner credential before the loopback peer proves it is ...
