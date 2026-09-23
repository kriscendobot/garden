---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1067
panel_kind: code
base_ref: origin/llm
rounds: 1
disposition: must-fix
must_fix_total: 6
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: efcaccae71ba
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1067 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `5e46338d`

seat verdicts (29): archivist=must-fix assessor=pass benchmarker=pass breaker=must-fix changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=pass duality-auditor=pass engine-realist=comment fast-checker=comment gateway=pass integrator=must-fix locksmith=pass migrator=pass packager=pass prover=pass pruner=pass purist=pass releaser=pass saboteur=pass scribe=comment spec-keeper=pass stylist=pass surfacer=pass transplanter=pass typist=pass warden=pass wire-watcher=pass
must-fix items (6):
- archivist: `packages/hardened262/test/intrinsics/AsyncGeneratorFunction/intrinsic-metadata.js:519-521` and its mirror `packages/...
- archivist: None. The rest of the two new test files (JSDoc-style `/*--- ... ---*/` header, inline comments describing the shared...
- breaker: `packages/hardened262/test/intrinsics/GeneratorFunction/intrinsic-metadata.js:5-11` and `packages/hardened262/test/in...
- breaker: The rest of the invariant surface (single shared intrinsic across declaration/expression/method forms, sync-vs-async ...
- integrator: **[must-fix]** PR description is stale against the fix-up commit's expanded scope — misleadingly described. [rule: ...
- integrator: **[comment-only]** The body's closing line ("Part of the serial test262-coverage ratchet (kriscendobot/garden#51)" pa...
