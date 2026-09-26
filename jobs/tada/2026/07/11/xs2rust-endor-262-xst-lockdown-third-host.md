PR #600 remains DRAFT and OPEN, as required. Work is complete and pushed. Empty inbox.

## Completion report

**Job:** Builder — endor-xst lockdown/compartment modes + third-host integration (PR #600, test262-convergence child 4/5). Repo `endojs/endo-but-for-bots`, branch `xs2rust-endor` (kept DRAFT). Design § Part 2 + § Staging step 4.

**What I did**

Verified stage-4 ground truth empirically first: endor lands the guest `harden()`/`petrify()` globals and a host-side `Compartment` Rust realm API, but the guest `lockdown()` call and guest `Compartment` intrinsic are documented scope folds (a guest reference throws "undefined variable"). The two real `ses-xs-parity` tests in the checked-in subset both need the guest `Compartment` intrinsic. This shaped an honest, forward-compatible implementation.

*endor-xst runner (`rust/engine/endor-262`):*
- Added `SesMode` enum + `Config.ses_mode` + `-l`/`-lc`/`-c`/`--ses-mode l|lc|c` CLI (the `xst262.c` `-l`/`-lc`/`-c` analogues), surfaced in the report's `mode:` section as `ses-mode:`.
- Because the guest surface a mode needs isn't landed, a case run under any mode is a whole-case **named skip** (`ses-mode:lockdown-unimplemented`, …) — parallel to the existing `onlyStrict` strict skip. A single seam (`SesMode::unimplemented_skip`) flips these to real runs when the guest surface lands; `SesMode::prelude` holds the target lockdown/compartment JS.
- Added guest `lockdown`/`Compartment` to `DEFAULT_ENDOR_SKIP_FEATURES` (the `gxFeatures` analogue), so a `ses-xs-parity` test declaring them self-names `feature:Compartment`/`feature:lockdown`.
- Added `--feature-filter <feat>` (the `test262-harness --features-include` "run only these" semantics) to restrict a whole-tree walk to the parity axis.
- 5 new unit tests; all 14 `xst::` tests + the full `endor-262` suite pass; clippy clean.

*Third-host wiring (`packages/test262-runner`):*
- `scripts/run-endor-host.js` builds `endor-xst` and runs it over `test262/` in lockdown mode filtered to `ses-xs-parity`; `test262:endor` package script; folded into the `test262` aggregate alongside `test262:xs`/`test262:node`; README names endor as the third host.

**Verified end-to-end:** `test262:endor` over the tree filters 15,281 files → the 2 ses-xs-parity cases → both honest `feature:Compartment` skips, **zero failures, exit 0** (green). Plain `-l` over `language/expressions/addition` correctly turns all 48 covered-baseline cases into `ses-mode:lockdown-unimplemented` skips. Coverage lights up automatically when the guest lockdown/Compartment surface lands — no wiring change needed.

**Changed:** `xst.rs` (+225), `bin/endor_xst.rs`, `test262-runner/package.json`, `README.md`, new `scripts/run-endor-host.js`. Committed `4b7fe48680`, pushed to `xs2rust-endor` (CAS, attempt 1). The `c/moddable` submodule (copied locally so the oracle builds) was deliberately not staged.

**Follow-ups:** Step 5/5 (fuzz-trophies regression tree) remains, per the orchestration. When guest `lockdown()`/`Compartment` land, remove their entries from `DEFAULT_ENDOR_SKIP_FEATURES` and the matching arms from `SesMode::unimplemented_skip` to activate real coverage.
