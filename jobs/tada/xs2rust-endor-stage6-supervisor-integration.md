PR #600 confirmed still DRAFT. Job complete.

---

## Completion report — stage-6 child 5/6: supervisor suspend/resume integration

**Outcome: landable slice delivered green + structured gap map for the full daemon integration.** Both halves are the honesty-valve success shape — a precise slice landed and a precise remaining-work map, not a pretend-green.

### What I assessed first
The endor engine (`rust/engine/*`) and the endo daemon supervisor (`rust/endo/*`) are **entirely disconnected today** — separate git workspaces (`rust/engine` is an *excluded* nested workspace), zero `endor-*` dependency in any Cargo.toml outside `rust/engine`, and no `-e endor-rs` engine selector anywhere in the repo. So wiring the *literal* daemon `Supervisor` onto endor in one invocation is not reachable; I converted the daemon-level bar to a probe and landed the reachable slice.

### What I landed (green, committed, pushed)
- Commit `ed547e721d` on `endojs/endo-but-for-bots` branch `xs2rust-endor` (PR #600, **still DRAFT** — confirmed).
- New integration test crate `rust/engine/endor-snapshot/tests/supervisor_suspend_resume.rs` (+ `endor-vm` dev-dependency in `endor-snapshot/Cargo.toml`).
- It reconstructs the daemon supervisor's exact `SuspendedWorker` lifecycle (`rust/endo/src/supervisor.rs`: `mark_suspended` → **drop the live machine**, retain only `sha256`+`cas_dir`+`meter` → `take_suspended` + `resume_from_cas` + `restore_meter`) as a handle-keyed `SupervisorHarness` over the endor `Interp`, and proves the row-6 property: a worker suspended to the CAS at a crank boundary (machine genuinely dropped) and resumed on the next message continues in **both result and final computron count** identically to a worker that never suspended. Three cases: single-worker meter continuity, content-addressed blob durability, independent multi-worker suspend/resume.
- This is a supervisor-*shaped* integration (machine does not exist between suspend and resume), not a verb round-trip — distinct from child 3's existing `suspend_to_cas_and_resume_round_trips_through_the_store`.

### Verification (as the job specified)
- `cargo test --workspace -- --test-threads=1` from `rust/engine` → **EXIT=0** (`/tmp/full_verify.log`; 25 suites ok, 0 failed). The new suite: `test result: ok. 3 passed`.
- Precondition: the oracle needs the moddable pin; I set up `c/moddable` via the shallow sha-fetch (`23b4d6b0a65f`, 8.3.1) per `rust/engine/README.md` and **did not** `git add c/moddable`.
- Named command for the landed test: `cargo test -p endor-snapshot --test supervisor_suspend_resume -- --test-threads=1`.

### Structured gap report — reaching the *daemon-level* bar ("`test:rust` passes on `-e endor-rs`"), in dependency order
1. **Engine-selection surface (S).** No `-e`/`endor-rs` exists. Daemon selection is a `platform` string → `Engine::{Separate, Shared}` (`rust/endo/src/engine.rs:30`). Gap: add an `endor-rs` platform → a new `Engine` variant routing to an in-process endor worker. *Small, mechanical* — but blocked on #2/#4.
2. **Cross-workspace dependency edge (M).** `rust/endo` (root workspace) cannot depend on `endor-snapshot`/`endor-vm` — they live in the deliberately *excluded* `rust/engine` workspace. Gap: publish the engine crates into the daemon's dependency graph (un-exclude, path-dep, or a bridge crate) without entangling `forbid(unsafe_code)` engine crates with the daemon's C-FFI `xsnap`. *Medium; an architectural decision, not just plumbing.*
3. **Buildable worker/SES boot path (L, currently the hard blocker for `test:rust`).** `test:rust` (`packages/daemon/package.json:49`) is a JS **ava** suite against a built `endot` binary whose worker boot is **not buildable from this tree** — the worker/SES boot generators (`bus-worker-xs.js`, …) are absent and not in git history (`rust/endo/README.md:164`). Even the *C-XS* worker path can't build here today. Gap: restore/generate the worker-boot artifacts (or a stubbed endor worker binary) so an `endot` with an endor worker can boot at all. *Large; a precondition to any daemon-level green, independent of endor.*
4. **Daemon-boot intrinsics the engine still lacks (L).** The daemon boot sequence is `polyfills.js` → `ses_boot.js` lockdown → HandledPromise shim (`designs/daemon-endor-architecture.md` § Unified runner). The post-stage-4 review ledger enumerates the missing engine surfaces: live `globalThis` binding, `Compartment`/`lockdown` as guest globals, `harden`/`petrify`. Until these run, an endor worker cannot execute the daemon's own boot JS, so `-e endor-rs` cannot reach the point `test:rust` exercises. *Large; this is the stage-7 (Hardened JS/Compartment) frontier feeding back into stage 6.*
5. **Worker transport + control-verb loop (M).** The supervisor is transport-agnostic over `WorkerTransport` (`rust/endo/xsnap/src/worker_io.rs:58`) with an `init_handshake` returning `Init`/`Restore` and a `handle_suspend` streaming to CAS. An endor worker needs an equivalent impl driving `Interp` + the `MachineSnapshot`/`resume_from_cas` surface (already present, children 2–3) through that loop. *Medium; unblocked once #2–#4 land — the snapshot verbs it would call are done and now proven supervisor-shaped by this child.*

**Dependency order:** #3 (buildable boot path) and #4 (boot intrinsics) are the true gating prerequisites; #2 (workspace edge) is the architectural decision; #1 (selector) and #5 (transport loop) are small once the prerequisites exist. What this child proved — the endor snapshot surface satisfies the supervisor's suspend/resume/CAS contract with meter continuity — removes engine-snapshot correctness from that critical path.

### Follow-ups for the stages after 6
- The `endor-rs` platform/`Engine` variant + endor `WorkerTransport` impl (#1/#5) are a clean next child once #2 is decided.
- The workspace-edge decision (#2) and the worker-boot-artifact restoration (#3) are prerequisites worth their own parked jobs; #3 in particular blocks *all* daemon `test:rust` greening, endor or C-XS.
- Intrinsics (#4) overlap the stage-7 Hardened-JS/Compartment work; row 6's daemon bar effectively waits on it.
