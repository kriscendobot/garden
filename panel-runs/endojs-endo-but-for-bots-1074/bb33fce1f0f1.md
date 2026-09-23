---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1074
panel_kind: code
base_ref: origin/llm
rounds: 1
disposition: must-fix
must_fix_total: 7
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: bb33fce1f0f1
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1074 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `89ba052c`

seat verdicts (29): archivist=pass assessor=pass benchmarker=comment breaker=must-fix changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=pass duality-auditor=pass engine-realist=pass fast-checker=comment gateway=pass integrator=pass locksmith=pass migrator=pass packager=comment prover=pass pruner=pass purist=pass releaser=pass saboteur=pass scribe=pass spec-keeper=pass stylist=must-fix surfacer=pass transplanter=pass typist=pass warden=pass wire-watcher=pass
must-fix items (7):
- breaker: `packages/hardened262/test/intrinsics/TypedArray/intrinsic-metadata.js:151-187` claims (comment above `detachBuffer`,...
- breaker: `packages/hardened262/test/intrinsics/TypedArray/intrinsic-metadata.js:168-187`: the shared-superclass check (line 64...
- breaker: Lines 44-51 fold nine unrelated metadata facts into one `'|'`-joined string comparison; a future regression in any si...
- breaker: The documented Float16Array gap (comment lines ~28-33) is transparently flagged as a pre-existing vendored-harness li...
- breaker: No capability/attenuation surface in this diff (the package tests intrinsic *shape*, not object-capability flows), so...
- stylist: `packages/hardened262/test/intrinsics/TypedArray/intrinsic-metadata.js:52,113,168` — the freshly-authored callback ...
- stylist: None. The rest of the naming in the new file is clear and consistent: `TypedArrayPrototype`, `assertSharedSuperclass`...
