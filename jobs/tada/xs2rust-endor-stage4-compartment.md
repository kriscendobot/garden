The supervisor's `-s10` inbox isn't alive right now, so my report was dead-lettered and will be auto-promoted to a fresh job (intent preserved). My own inbox is empty. The work is complete and pushed.

---

## Completion report — stage-4b child 3/5 (compartment)

**Status: LANDED & PUSHED** to `origin/xs2rust-endor` (3 commits: `4e96fc3cb`, `2f5750b08`, `c6de4a846`). PR #600 kept **DRAFT**.

**What I did.** Grew the stage-1 `Compartment.evaluate` seam into the full native `Compartment` (`endor_vm::compartment`, `xsModule.c`'s compartment half) over the one-intrinsics-per-machine seam:
- **Per-compartment globals** over shared `Rc` intrinsics; **endowments** copied onto the new global at construction.
- **`globalThis`** identity: distinct per compartment (nested included), stable for one compartment (`Compartment::global_this` → `CompartmentId`).
- **Nested compartments** (`Compartment::new_compartment`) minting a child over the *same* machine intrinsics with fresh globals + fresh globalThis identity.
- **Module-map integration**: `new Compartment({ modules, resolveHook, importHook })` surface (`CompartmentOptions`); a compartment owns a `module::ModuleGraph`; static `import { x } from 'm'` resolves through *this* compartment's map (`import_static`), so two maps for one specifier import different modules.
- Per-compartment evaluator (`evaluate_with_symbols`) relinking intrinsic references per compartment.

**Evidence (bar met).**
- `cargo test --workspace -- --test-threads=1` **GREEN, 0 failed**.
- endor-vm: **+12 compartment unit tests** (isolation, shared-intrinsics identity, distinct/stable globalThis, nested chaining, endowments, constructor hook shape, static-import resolution, map isolation, cross-compartment live indirect binding, dynamic-import skip).
- endor-262: **+2 differential bars** — `stage4-compartment.js` (29 programs) compiled on the oracle, exact bytecode evaluated in **two compartments over one machine**: RESULT + computron agreement over one `Rc::ptr_eq` intrinsics graph; plus a global-separation differential (each compartment renders its own seeded global, matching the oracle's `String()` while diverging).
- **Miri-clean** on the compartment seeding path; `#![forbid(unsafe_code)]` intact; README evidence block updated.

**Named skip:** `compartment:dynamic-import` (async host loader not built).
**Scope fold (recorded, not half-implemented):** guest-callable `Compartment` intrinsic — endor models Compartment host-side (Rust realm API), not a guest constructor whose `evaluate` re-enters the compiler (needs the oracle at runtime, which `endor-vm` forbids); programs referencing the `Compartment` intrinsic itself are `compartment:intrinsic-surface`, excluded from the corpus. **`lockdown`/`harden`** (freezing shared intrinsics) is the next child, as the job specified.

**Follow-ups:** the `-s10` supervisor report was dead-lettered (inbox not currently alive) and will be promoted to a fresh job. The `c/moddable` gitlink shows modified in the worktree (the known population footgun) — deliberately not committed, per README §1.
