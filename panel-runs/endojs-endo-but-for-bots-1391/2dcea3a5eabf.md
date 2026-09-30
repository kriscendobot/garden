---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1391
panel_kind: code
base_ref: ef4662f04b575a1edb0e716a4fc03f847dd7f53f
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 49112da9e15d86466e25a7c199ea46cd050f9c1b
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 2dcea3a5eabf
recorded_by: endolin-garden2-5bcdff64
---

# Panel run — endojs/endo-but-for-bots #1391 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `49112da9`

seat verdicts (33): archivist=pass assessor=pass benchmarker=pass breaker=comment changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=comment duality-auditor=comment engine-realist=pass fast-checker=comment gateway=pass integrator=must-fix locksmith=pass migrator=pass orthographer=pass packager=comment procurer=pass prover=comment pruner=must-fix purist=must-fix reexport-auditor=pass releaser=pass saboteur=comment scribe=must-fix spec-keeper=comment stylist=comment surfacer=pass thesaurus=pass transplanter=pass typist=pass warden=must-fix wire-watcher=comment
must-fix items (20):
- integrator: **should-fix: fix-up commits would land as history under rebase-and-merge** (overlaps with packager). The PR has 9 co...
- integrator: `819203dd53 fix(ses): admit only the @endo/sturdyref constructor as SturdyRef`
- integrator: `b6cbc3ac0f fix(ses): scope the first-wins global skip…`
- integrator: `c78271e1f1 test(ses): narrow … for lint:types`
- integrator: `a05d0fcd77 test(ses): freeze the stand-in…`
- integrator: `5d43b703ad docs(ses): one sentence per line…`
- integrator: `49112da9e1 style(ses): prettier`
- integrator: `feat(ses): permit and share a pre-lockdown SturdyRef`, covering permits, intrinsics, lockdown, global-object and the...
- integrator: `test(ses): …`, covering the Node tests plus the XS smoke and the `test:xs` wiring.
- integrator: `test(sturdyref): a child compartment shares the pre-lockdown SturdyRef`.
- integrator: **comment-only: SturdyRef-specific policy is split across three generic SES modules.** Knowledge of `@endo/sturdyref`...
- integrator: `permits.js`, which holds the permit (the expected place, as for `HandledPromise`).
- integrator: `intrinsics.js`, where `assertSturdyRefShape` sits among the generic intrinsics-collection code.
- integrator: `global-object.js`, which has the `firstWinsPropertyNames` allowlist.
- integrator: **comment-only: two shape predicates that differ slightly and are not tied together.** The shim's `isSturdyRefConstru...
- integrator: **comment-only: the Documentation Considerations section points to docs that don't exist.** It says docs "that list t...
- pruner: **Primary finding: PR body contains a redundant per-file change tour.**
- purist: **should-fix: the shape check promises more than duck-typing can deliver.** `packages/ses/src/intrinsics.js:79-108` (...
- purist: **should-fix: two different definitions of "is the SturdyRef constructor".** The SES predicate accepts only *own data...
- purist: **should-fix: two SturdyRef-specific mechanisms where the precedent needs none.** `HandledPromise`, the family preced...
