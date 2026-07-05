All work is committed, pushed, and stable. Final state verified green across all crates. Let me write the completion report.

The job is genuinely complete for its charter bar: the headline deliverables (Promise constructor + executor, then/catch, resolve/reject, the job queue, and the pump-loop latch with reactions bit-exact across resolution chains) are all landed and computron-exact, `built-ins/Promise` is `divergent=0` with covered growth, and the remaining surfaces are honest named skips exactly as the charter's "if calibratable within budget; else keep the honest named skip" clause permits.

---

## Completion report — stage-3b child 7/9: Promises, the job queue, and the pump-loop latch (PR #600)

**Repo/branch:** `endojs/endo-but-for-bots` `xs2rust-endor` (PR #600, still DRAFT). Pushed HEAD `bc785b265`.

**What I built (7 commits, each its own green push):**
1. **Oracle shim pump-loop drain** — the reference side of the latch: the shim now runs `fxRunPromiseJobs` after `fxRunScript` (metering still accumulating), so the oracle's computrons include the microtask drain. A program that queues no jobs is unaffected (non-promise corpora measure identically; stage-1 still 86/86).
2. **Promise constructor + executor + resolve/reject** — `new Promise(fn)` allocates the instance (side-table settlement state), hands the executor its resolve/reject host functions (recognized in the `RUN` dispatch), settles under a shared `[[AlreadyResolved]]` guard. Computron-exact.
3. **then/resolve/reject + the job queue + the endor-side pump-loop drain** — `Promise.resolve`/`reject`, `.then` reaction registration returning a derived promise, the FIFO microtask queue, and `endor_vm::run` draining it the same way the shim does. Reactions fire at the drain; resolution chains, already-settled, pass-through, and rejection routing are all bit-exact **including computrons across the whole crank**.
4. **`.catch`** (`then(undefined, onRejected)`), computron-exact.
5. **Curated `stage3b-promises.js` corpus** + **differential fuzz arm** (`gen_stage3b_promise_program`, 800-seed sweep over fulfilled resolution chains), both bit-exact.
6. **README evidence** block.
7. **Thenable adoption — attempted then reverted.** Native-promise adoption via an `fxOnThenable` job was bit-exact for single-adoption cases (lifted `built-ins/Promise` to covered=9), but the fuzz sweep exposed compound/un-observed adoption chains diverging by a few computrons (a native-handler reaction double-settle nuance I couldn't calibrate within the wall). Since a **silent computron divergence violates the sacred invariant**, I reverted to the honest named skip rather than ship it. The scaffolding is in git history for a clean resume.

**Verification:** `built-ins/Promise` dual-run `total=474 covered=7 divergent=0` (from ~0). All crate tests green: endor-vm 46, endor-oracle 3, endor-262 30, endor-fuzz 21. Stage-1 86/86; `language/expressions/addition` spot-check divergent=0. `#![forbid(unsafe_code)]` intact outside endor-oracle.

**Honest named skips (never a wrong value/meter):** thenable adoption, self-resolving promise, a handler that throws, `.finally`, the `all`/`race`/`allSettled`/`any` combinators, async/await (stage 4).

**Follow-up (sent to supervisor `port-xs-to-rust-memory-safe-engine-s7`, dead-lettered→promoted):** nail the native-handler reaction job's double-settle bit-exact — it unblocks **both** thenable adoption and the combinators (they share the native-function-reaction-handler machinery) in one stroke.
