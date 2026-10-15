---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1391
panel_kind: code
provider: anthropic
base_ref: dbd2b003e68f02d45ccc347ef8e25bb7dc03510e
pr_body_hash: d38ccb981539af8e310ecf70a37de2ee3f69e645781d24e9f604f6f712813be1
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 17390624a329ddcbe94b985e40760314ddc38314
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: b1bb30b08cbe
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1391 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `17390624`

seat verdicts (34): archivist=must-fix assessor=comment benchmarker=pass breaker=must-fix changeset-auditor=must-fix corner-prober=comment coverage-auditor=comment curator=comment decomplector=must-fix duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=comment locksmith=comment migrator=comment orthographer=pass packager=comment procurer=pass prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=must-fix saboteur=comment scribe=comment spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=must-fix warden=comment wire-watcher=comment
must-fix items (20):
- archivist: **must-fix**: `packages/ses/src/global-object.js:20`. The comment on `firstWinsPropertyNames` says "Any other pre-loc...
- archivist: **must-fix**: `packages/ses/src/tame-parcel-constructor.js:29-30`. The comment says "Constructor emulation is one of ...
- archivist: **comment-only**: `packages/ses/src/intrinsics.js:99` and the changeset/README "constructor" wording. `sampleParcel` ...
- archivist: **comment-only**: `packages/ses/src/tame-parcel-constructor.js:25` returns `{}` when the sample is `undefined`, and t...
- breaker: **should-fix: `sampleParcel` doesn't validate that `prototype.constructor` can be redefined.** (`packages/ses/src/int...
- breaker: The code claims that `Parcel.prototype.constructor` never reveals the powered initial constructor.
- breaker: Attack: a pre-lockdown shim hardens `Parcel.prototype`, or makes its `constructor` non-configurable, before `lockdown`.
- breaker: `sampleParcel` accepts it, because it checks only the locked `prototype` slot on the constructor.
- breaker: `tameParcelConstructor` then throws a bare `TypeError: Cannot redefine property: constructor` from the middle of `rep...
- breaker: The tame step also runs after the earlier `addIntrinsics` calls, so a failed lockdown leaves partial state.
- breaker: Fix: check `constructor` in `sampleParcel`, so rejection comes with the same clear "compatible Parcel" message and ha...
- breaker: [proposed-rule: validate every precondition of a later mutation during the sampling phase, before mutating anything]
- breaker: **should-fix: the `locate` hiding rests on the real shim's instance shape, and no test covers a shim that violates it.**
- breaker: Invariant: a child compartment never gets `locate`. This holds only if the real shim exposes no `locate` on the proto...
- breaker: Attack: a `@endo/parcel` change that adds an instance-level `locate` method.
- breaker: `%ParcelPrototype%` allows only `constructor` and `@@toStringTag`, so the permit pass would strip it. That is good, b...
- breaker: Attack: an instance own property such as a `location` field, which `freeze(this)` does not hide and the permit pass d...
- breaker: Suggest a test or comment that pins the contract: no location on instances or on the prototype.
- breaker: **comment-only: a retried or repeated `repairIntrinsics` is probably safe, but untested.** The first pass mutates `pr...
- breaker: A Proxy candidate re-answering `locate` or `prototype` on `[[Get]]`: handled by the descriptor snapshot and the locke...
