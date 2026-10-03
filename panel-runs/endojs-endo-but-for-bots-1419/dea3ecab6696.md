---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1419
panel_kind: code
base_ref: 0bdf8951cb009df564a6646fa4d101717caa8302
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 8d7eda22b3cd952a6ec24fd64eb26373ddee459a
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: dea3ecab6696
recorded_by: endolin-garden2-5bcdff64
---

# Panel run — endojs/endo-but-for-bots #1419 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `8d7eda22`

seat verdicts (33): archivist=pass assessor=comment benchmarker=pass breaker=must-fix changeset-auditor=pass corner-prober=must-fix coverage-auditor=comment curator=pass duality-auditor=pass engine-realist=comment fast-checker=comment gateway=comment integrator=must-fix locksmith=must-fix migrator=pass orthographer=pass packager=comment procurer=pass prover=comment pruner=must-fix purist=must-fix reexport-auditor=pass releaser=pass saboteur=pass scribe=pass spec-keeper=pass stylist=pass surfacer=pass thesaurus=pass transplanter=comment typist=comment warden=pass wire-watcher=comment
must-fix items (20):
- breaker: "A tree that matches no layout is rejected and nothing is formulated" (`types.d.ts` `makeFromTree` JSDoc, changeset)....
- breaker: Under the XS supervisor, the `node_modules` layouts "refuse with a diagnosis" (changeset, `host-tool-powers.js`).
- breaker: `entry` is "a module path within the root package" (`types.d.ts` `MakeFromTreeOptions`).
- breaker: With-map compartment locations stay under the tree root (`assertMapLocationsUnderRoot`).
- breaker: `makeMountCanonical` refuses a location that resolves outside the tree root.
- breaker: `runningAs` reports the current incarnation's layout and is absent when nothing is live (`manager.js` `treeLayoutRunn...
- breaker: **should-fix: the XS refusal still leaves a formula and its pet name that can never run (invariant 2).**
- breaker: Attack: on the XS manager, call `makeFromTree(undefined, 'xs-refusal-tree', { resultName: 'x' })`. The call throws, `...
- breaker: The sibling test for a non-matching tree (`rejects a Yarn Plug-n-Play tree and formulates nothing`) asserts `t.false(...
- breaker: Fix: in the host, refuse a resolved `node-modules-*` layout when the stand-in capture is in place, before formulating...
- breaker: [proposed-rule: a refusal that depends only on the supervisor's capabilities, not on the tree's contents, should fire...
- breaker: **comment-only: nothing keeps `entry` inside the root package (invariant 3).**
- breaker: Attack: `entry: './node_modules/dep/index.js'` passes. `mapNodeModules` then roots the graph at `dep`, so a dependenc...
- breaker: Nothing leaves the tree, so there is no capability escape. Either narrow the JSDoc to "a module path under the tree r...
- breaker: [rule: AGENTS.md § Type-assertion discipline, which asks that validated strings carry the contract they claim.]
- breaker: **comment-only: a path name can make an error look like "not found" (`mount.js` `isAbsentPathError`).**
- breaker: Attack: a mount directory literally named `ENOENT` turns an `EACCES` from `realPath` (whose message includes the path...
- breaker: The mount's own `assertConfined` still guards the actual read, so the effect is limited to package identity.
- breaker: Fix: only fall back to the message check when `code === undefined`.
- breaker: [proposed-rule: classify errors by structured `code` first; match on the message only when there is no code.]
