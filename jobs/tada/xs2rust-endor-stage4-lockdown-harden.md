Miri confirms the harden allocation path is UB-free. Every bar item is satisfied. The job is genuinely complete for its scoped deliverable.

## Completion report

**Job:** stage-4b child 4/5 — lockdown/harden. Ported the Hardened-JavaScript surface of `xsLockdown.c` onto endor's stage-4 integrity machinery. Landed on `xs2rust-endor` (PR #600, kept **DRAFT**), two commits pushed via rebase-CAS: `63e6017999` (impl) + `888eb7bf4a` (README).

**What I did**
- **`harden(x)`** (`fx_harden` + `fx_hardenFreezeAndTraverse` + `fx_hardenQueue`): the transitive freeze worklist over the slot arena — prevent-extensions + stamp every own data property non-writable/non-configurable on each reached instance, then queue the prototype and every reference-valued own property, marking each `XS_DONT_MARSHALL_FLAG` (the visited set). Returns its argument; non-reference / already-hardened / no-arg pass through per XS.
- **`petrify(x)`** (`fx_petrify`): the single-object, non-transitive freeze.
- **Oracle shim extended** to install the harden/lockdown/petrify/mutabilities globals `xst.c`/`xstFuzz.c` install (the bare `fxCreateMachine` boot does not) — the minimal audited FFI-seam extension the differential needs.

**Evidence / bars (all green)**
- `stage4-harden.js` (30 programs) locked as `stage4_harden_corpus_agrees_on_results_against_oracle` — **RESULT-gated**, every program completes on both engines to the same value.
- 3 endor-vm unit tests (freeze semantics + `harden_transitive_freeze_is_miri_clean`).
- `cargo test --workspace --test-threads=1` GREEN (endor-262 43/0, endor-vm interp 82/0, all crates 0 failed); `#![forbid(unsafe_code)]` intact.
- **Miri** on the harden allocation path: 1 passed, 0 failed (UB-free).
- **built-ins/Object regression re-run**: `total=3127 covered=176 divergent=0 skipped=2951` (unchanged — freeze machinery introduced no regression).
- README evidence block updated.

**Metering (accuracy-over-parity):** allocation-driven (`xsLockdown.c` calls no `mxMeter`). `petrify` is computron-exact for even key counts (sub-computron boundary wobble at odd). `harden` computron parity over a *transitive* walk is **structurally unavailable** — endor models intrinsics sparsely, so harden's transitive object count diverges from the pin's full intrinsic graph (the same sparse-intrinsics fact the module/compartment children record) — hence result-gating.

**Scope folds (honest `Halt::Unsupported`, reported to supervisor):** `lockdown()` (full intrinsics whitelist/walk, Date/Math secure taming, constructor taming, idempotence throw) and `mutabilities` (the `fxVerify*` mutable-residue report) are sized as a follow-up child on this now-landed harden substrate; an exotic receiver to harden/petrify self-names; accessor getter/setter transitive freeze is a documented gap.

**Follow-ups:** the supervisor inbox `port-xs-to-rust-memory-safe-engine-s10` was gone — my completion report was dead-lettered and will be promoted to a fresh job (intent preserved). `lockdown()` and `mutabilities` remain for the next child.

**Note:** hit (and recovered from) the empty-gitlink footgun early — a `git -C c/moddable` walked up and checked the Moddable pin out over the endo worktree; restored via `git checkout -f xs2rust-endor` and re-cloned `c/moddable` as its own repo. No work lost.
