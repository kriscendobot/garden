---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 774
panel_kind: code
base_ref: 7ff30afbce95f60d21ff3ae385bd9a17ed0850db
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 12050148bdbc6f1da87e646e6524e6ba4c498fe1
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: cc619fe4cdd8
recorded_by: endolin-garden2-5bcdff64
---

# Panel run — endojs/endo-but-for-bots #774 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `12050148`

seat verdicts (33): archivist=must-fix assessor=must-fix benchmarker=pass breaker=must-fix changeset-auditor=must-fix corner-prober=comment coverage-auditor=must-fix curator=must-fix duality-auditor=pass engine-realist=must-fix fast-checker=comment gateway=pass integrator=must-fix locksmith=must-fix migrator=comment orthographer=must-fix packager=comment procurer=pass prover=comment pruner=must-fix purist=must-fix reexport-auditor=must-fix releaser=pass saboteur=must-fix scribe=must-fix spec-keeper=must-fix stylist=must-fix surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=must-fix wire-watcher=must-fix
must-fix items (20):
- archivist: **Ambiguous historical reference** [should-fix]
- archivist: `packages/sturdyref/test/sturdyref-malformed-global.test.js:925` contains "The retired #774 namespace shape is no lon...
- archivist: [rule: archivist's operating norm on clarity of definite technical claims]
- archivist: **Unverified design document references**
- archivist: `packages/sturdyref/README.md:255` states "the contract is `designs/sturdyref-shim-contract.md`"
- archivist: `packages/sturdyref/test/sturdyref-shim.test.js:1053` references "the layer-1 SturdyRef contract (designs/sturdyref-s...
- archivist: These references should either resolve to an actual file path, or the document should be confirmed to exist before me...
- archivist: [proposed-rule: cross-document references to design files must be verified to exist or hedged as forward references]
- archivist: **README documentation is otherwise thorough and accurate**
- archivist: JSDoc prose accurately mirrors code behavior (handler capture, enliven timing, brand-check semantics).
- archivist: First-wins mechanism clearly documented.
- archivist: Lockdown timing and hardening strategy correctly explained.
- archivist: No stale or contradictory claims detected in prose vs. code.
- archivist: [rule: archivist's operating norm on docs-vs-code consistency]
- assessor: `packages/sturdyref/src/sturdyref-shim.js:214-229` (`selectSturdyRef`, the adopt-and-lock branch): when adopting a pr...
- assessor: None beyond the item above — control flow elsewhere (the `new.target` guard, the captured-WeakMap-methods reads/wri...
- breaker: **must-fix: a no-op `harden` that was already installed leaves the shared constructor mutable, so any later code can ...
- breaker: `Object.isFrozen(S)` returns `false`.
- breaker: After `S.isSturdyRef = () => true`, the ponyfill's `isSturdyRef({})` returns `true`. The brand is forged for every ev...
- breaker: After `S.prototype.then = …`, `await ref` gives the attacker's value. That is the caller-chosen `then` which the `n...
