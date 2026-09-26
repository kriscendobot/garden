The gauntlet is complete end-to-end. Here is my completion report.

---

## Gauntlet complete — endojs/endo-but-for-bots#854 merged into `llm`

**PR:** feat(endor): synthesize CJS named exports in the ESM facade (rust/endo/src/cjs_lexer.rs + execute.rs facade + design-doc gap update), base `llm`.

### Local verification (real execution)
Set up an isolated project worktree, `git submodule update --init c/moddable`, and copied the generated xsnap bootstrap JS (`ses_boot.js`/`worker_bootstrap.js`/`daemon_bootstrap.js`) from a sibling scratch worktree at the same HEAD (byte-identical ses/worker bundles confirmed).
- `cargo test -p endo` → **163/163 pass** (serial). A single failure under the default *parallel* run (`nested_module_relative_imports_resolve_against_referrer`, "async work still pending") reproduced on the base commit too and passed 3/3 in isolation — a pre-existing XS-machine concurrency flake, not a PR regression.
- `cargo test -p xsnap` → **120/120 pass** (serial).

### Panel review (3 seats)
Dispatched breaker/corner-prober, engine-realist/integrator, and pedant+copyeditor+coverage-auditor reviewers. They independently converged on two must-fixes plus lower-severity items.

### Fix-loop (one round — commit `eeb7c96501`, all in `cjs_lexer.rs`)
- **must-fix — build hang (infinite loop):** `collect_object_literal_keys` re-called `skip_value` at an index it returns unchanged (a depth-0 `)`/`]`), so `module.exports = { a: b) }` spun forever, hanging the whole archive build on any package containing such a source. The fallback arm now forces forward progress.
- **must-fix — facade-name collision → whole module unloadable:** detected export names `__cjs`/`__cjsO` (facade consts → duplicate-`const` SyntaxError) or `__loadCjs` (compartment global → shadowing `export const` puts the facade's own call in the TDZ → ReferenceError) broke linking of the entire module. Added them to `EXCLUDED_NAMES` (joining `__esModule`), preserving the over-approximation-falls-back-to-`default` bargain; corrected the comment.
- **should-fix — false positives:** `after_module_exports` now rejects a preceding `.` (so `foo.module.exports.bar` isn't mistaken for the CJS `module` binding); regex-vs-division heuristic no longer misreads a regex after `throw`/`yield`.
- **coverage:** added 7 regression tests (facade-internal exclusion, unbalanced-object-literal non-hang, member-access rejection, `module.exports["name"]` bracket form, empty object literal, non-ASCII fallback, throw/yield regex).
- Re-verified: `cargo test -p endo` **170/170 pass** (serial); edited files fmt-clean under the project's `cargo fmt` config (a pre-existing `benches/codec.rs` fmt diff is untouched by this PR). Pushed via `safe-push-pr-head.sh --mode advance` (no rewind).

### Un-draft → CI → merge
- `gh pr ready 854` (un-drafted; only `panel.sh`-equivalent authority un-drafts).
- CI on the new head `eeb7c965011`: **all 24 checks green**, `mergeStateStatus: CLEAN`, `mergeable: MERGEABLE`, zero failures.
- `gh pr merge 854 --rebase` → **MERGED** into `llm` with linear history: `9b773f6c3d7` (feat, rebased) then `e2c6ff853c2` (fix) on top of the prior `llm` tip `0274a5b6670`.

### Follow-ups (non-blocking, out of scope, left for the design record)
- Re-export shapes (`module.exports = require(…)`, `__exportStar`) remain unchased across modules and reach importers only via `default` — a genuine divergence from Node's `cjs-module-lexer` (which Node's ESM translator *does* resolve). Already documented as the remaining sub-gap in `designs/endor-npm-registry-proxy.md`; no code change owed.
- The design doc's recognized-shapes list under-claims (omits `module.exports.name =`, which the code detects) — a cosmetic doc nit, not an inaccuracy.
- The default-parallel `cargo test -p endo` XS-concurrency flake pre-dates this PR and is worth a separate hardening pass (run XS tests serially or serialize XS-machine setup).
