## Completion report

**Job:** stage-4 child 4/8 — async/await over the job queue + the promise double-settle keystone (PR #600, branch `xs2rust-endor`).

**What I found.** This job had been reaped once (`garden-deadline-overrun: 1`, `garden-reaped: 1`). The predecessor invocation had already landed the **keystone** — the explicitly-gating "resolve it first" deliverable — and committed it at `49e27a89b`: the promise native-handler double-settle calibration, the two-level `[[AlreadyResolved]]` guard, thenable adoption, long `then`-chains, and the `Promise.resolve(nativePromise)` identity fast path, all bit-exact (result AND computron) against pin `48ee02d8cfe0`. `built-ins/Promise` dual-run stands at `total=474 covered=9 divergent=0`; bars locked (`stage4_async_promises_corpus_*`, `promise_thenable_adoption_is_miri_clean`).

**What I did.**
- Populated the `c/moddable` pin from a sibling worktree (empty-gitlink footgun) and mapped the full async machinery from the C source: `fxNewAsyncInstance`/`fxStepAsync`/`fxResolveAwait`/`fxRejectAwait`, the `START_ASYNC`/`AWAIT`/`BRANCH_STATUS` opcodes, and how they reuse child 3's `SavedFrame` suspend/resume. The critical finding: `await` needs **native reaction handlers** — the exact infra blocker the predecessor folded `finally` + the combinators on, so all three share one prerequisite.
- Verified the committed HEAD is doctrine-coherent: the async opcodes (`async_function`/`start_async`/`await`) fall through to the interpreter's default arm `Halt::Unsupported(op.name())` — honest named skips, never wrong values or divergence.
- **Committed and pushed** (`86bb59fe6`) `rust/engine/ASYNC-AWAIT-HANDOFF.md`: the complete C-XS→endor implementation map (opcode handlers, the `fxStepAsync → step_async` model on `resume_generator`, the 5-slot native-reaction path, `await_schedule`'s native-promise-fast-path vs general-capability branch, `BRANCH_STATUS` status plumbing, the bars to add, and the GC-roots note), plus a README fold-paragraph pointer. Buildable-free, so it survives teardown and lets the next invocation execute directly.
- Reported the scope fold + a sizing recommendation to `port-xs-to-rust-memory-safe-engine-s9` (its inbox was gone → dead-lettered and promoted to a fresh job, intent preserved).

**Scope fold (honest, per the accuracy-over-parity doctrine).** The async-function surface (`XS_CODE_ASYNC_FUNCTION`/`await`, async generators, `for-await-of`) was **not landed** this invocation. I resumed the already-reaped job with ~9 minutes to the 2400s deadline — below a single endor-vm+endor-262+endor-oracle build/calibrate cycle (~5–10 min), and bit-exact async/await needs several. Landing it would have left uncommitted, half-implemented code (torn down on teardown), which the doctrine explicitly forbids. It stays an honest fold.

**Follow-up (routed to s9 via the promoted dead-letter).** Child 4 as specified is two full deliverables; the keystone consumed one whole invocation. The async-function surface needs its **own fresh full-budget child**, starting from `ASYNC-AWAIT-HANDOFF.md`; `finally` + the combinators share the native-reaction prerequisite and can ride the same child. Do not re-queue this exhausted job.

**Changed:** `rust/engine/ASYNC-AWAIT-HANDOFF.md` (new), `rust/engine/README.md` (fold pointer). Branch `xs2rust-endor` remains DRAFT; keystone bars green and unchanged.
