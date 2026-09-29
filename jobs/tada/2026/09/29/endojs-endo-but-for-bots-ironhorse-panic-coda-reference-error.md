I built the Coda leg and opened it as draft PR [endojs/endo-but-for-bots#1382](https://github.com/endojs/endo-but-for-bots/pull/1382). All 35 CI checks pass. Acceptance cases (a) and (c) are met; (b) is only partly met, because no live worker can emit `<panic kind="reference-error">` yet.

**Where it lives:** branch `llm-ironhorse-panic-coda`, commit `c931c767c6`. It is stacked on #1375 (the debugger leg), and only the last commit is new. The PR targets the frozen base `llm-1706e63`, like the other #1018 legs, and the body has `Refs: #1018`.

**What changed**
- **The switch:** a new `Interp::raise_reference_error` sits next to `raise_js`. With the option off it behaves exactly like `raise_js`, a catchable throw. With it on it returns `Halt::Panic(PanicKind::ReferenceError { name, site })` without touching the jump chain. `site` records which of the three read sites fired.
- **Sites converted:** the local TDZ read (`GET_LOCAL`), the unresolved-name read (`GET_VARIABLE`/`GET_THIS_VARIABLE`, including the `with`/eval arm), and the closure TDZ read (`GET_CLOSURE`). The closure site already went through `raise_js` on `llm`, so no separate conversion was needed.
- **The option:** a `ReplayConfig { panic_on_reference_error }` struct, the first entry in the design's replay fingerprint. It is set on the engine's `Machine`, on Endor's `Machine::with_config`, and on the persistent store's options.
- **Replay pinning:** the persistent machine re-applies the option at boot, resume and rewind. When the option is on, its fingerprint is added to the store signature, so a resume under a different setting is refused every time. When it is off nothing is added, so existing stores are unaffected. `ReplayConfig::check_replay` does the same comparison for the transcript's `snapshot` record, which #1376 already stores the flag in.
- **Housekeeping:** the new `Interp` field is registered in the two field registries that must list every field (the snapshot ledger and the boot field order). The new test is added to the CI endo step. The design doc gets an "As built" section.

**Verification**
- **(a) passes:** with the option on, each of the three sites panics past an enclosing `catch` and is classified `Panicked`. With it off, the same code returns `caught ReferenceError`, and an uncaught one is classified `Uncaught`. `typeof` of an undeclared name and guest-thrown `ReferenceError`s are unaffected.
- **(b) partial:** the `catch` never runs (so nothing unwinds before the stop), and the kind is spelled `reference-error`. A daemon test checks that `<panic kind="reference-error">` is reported as a panic under all three exception-break modes.
- **(b) gap:** #1375 emits `<panic>` only from C-XS, which has no Coda switch, and Ironhorse has no debugger transport. So nothing yet tests "a real attached debugger stops at the reference-error line".
- **(c) passes:** a store opened with the option on refuses a resume with it off and still resumes with it on; a default store refuses a resume with it on.
- **Local runs:** the ironhorse runtime, vm, snapshot and compile crate tests, the endo CI test set, clippy 1.88 on `rust/engine` and the daemon panic test all pass. Prettier and eslint are clean.

**Reconciling with #1016:** with the option on, a reference error inside an async function panics instead of rejecting its promise (tested). That settles #1016's Open Question 5 for the armed case. #1016 keeps the rejection-tracking scope.

**Review items in the PR body** (the mentat answers in #1370 don't cover the Coda, so I followed the design's leanings):
1. Only the three read sites panic. `this` before `super()`, `delete` of an unresolvable name, and strict writes to an unresolvable name still throw.
2. The setting is pinned through the store signature, not a new store column. That avoids a schema migration, but a mismatch shows up as a signature error naming the setting.
3. `name` is always filled in at these sites.
4. Nesting every panic variant with its payload (Q8) is left to the Halt shape-unification leg.

**Follow-ups:**
- Closing gap (b) needs either a Coda switch in the C-XS worker (intercepting XS's `fxThrowMessage` without patching the `c/moddable` submodule) or an Ironhorse debugger transport.
- Whichever leg attaches an Ironhorse worker to the transcript should record the worker's real setting in `SnapshotMeta`.

The gauntlet should start automatically from this draft PR.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-coda-reference-error.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 198 tokens (12640764 cached reads)
- Output: 50185 tokens
- Cost: $5.003788799999999
- Wall-clock: 3337s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
