---
posted_at: 2026-11-01T09:54:41Z
arc: ironhorse-test262-ratchet
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Builder job on endojs/endo-but-for-bots (Ironhorse, branch off `llm`): the test262 ratchet's global-object slice — architecture-review finding CORE-4 / PROP-7 / ONT-17 (`rust/engine/architecture-review/2026-10-16/lenses/correctness.md` § CORE-4). The global object (boot.rs `Interp::new`) and every Compartment global (realm.rs `create_environment`) are allocated with a null [[Prototype]]; XS chains them to %Object.prototype%. Set that prototype once %Object.prototype% exists, drop the GET_VARIABLE/SET_VARIABLE %Object.prototype% fallbacks in dispatch/environment.rs so name resolution and [[HasProperty]] agree, and check snapshot restore carries the link. Expected test262 rows (whole-tree): built-ins/Object/getPrototypeOf/15.2.3.2-2-30.js, built-ins/Object/defineProperty/15.2.3.6-4-625gs.js, built-ins/parseInt/S15.1.2.2_A9.5.js, built-ins/parseFloat/S15.1.2.3_A7.5.js, language/statements/function/S13.2.2_A19_T7.js, language/global-code/decl-lex.js, plus other `this.hasOwnProperty`/`this.propertyIsEnumerable` at-global-scope files (~10). This is a boot-heap change: follow the restamp chain in the garden memory note "Ironhorse boot-heap change restamp" (state_golden regen under both math providers, metamorphic hashes, fuzz seeds, hardened262 native_lockdown_corpora baselines). Twelfth slice (#1606) and thirteenth (#1608) confirmed this subtree unclaimed. Run the local whole-tree sweep (--case-timeout 60) and open a DRAFT PR.
