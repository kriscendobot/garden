## Completion report — `endor-debugger-cdp-devtools-investigation`

Research only, as specified. No engine code written, no PR opened, nothing committed to `main2` (the deliverable is the filed issue plus these findings).

**Issue filed:** https://github.com/endojs/endo-but-for-bots/issues/939

### The finding that reframes the job

The premise moved under the job. **The `endor-debug` crate is not on PR #600's current head** (`33c68104b3`, branch `xs2rust-endor`). Verified three ways: `rust/engine/Cargo.toml` lists seven members with no debug crate; no path under `rust/` matches `*debug*`; the PR's own file list (1834 files via the GitHub API) contains no path matching `debug`. The engine history was **rebuilt on 2026-07-29** — `git log -- rust/engine/Cargo.toml` on the branch shows five commits back to "stage-1 thin slice", and the debugger slices are not among them. A garden press report from 2026-07-21 records nine crates *including* `endor-debug`, so it existed and was dropped in that restage, not reverted by a reviewed commit. This matches the current roadmap in `designs/ironhorse-engine.md`, where **Debugger is stage 7 of 9 and unlanded**.

That changes the answer: the choice is no longer "replace a landed xsbug port" but "choose stage 7's protocol before writing it", which removes the largest cost item from the CDP option.

### What the investigation established

- **Landscape verified, not recalled.** CDP ≠ DAP. VS Code resolves to "be a CDP target" — `vscode-js-debug`'s `OPTIONS.md` documents an attach option `websocketAddress` ("Exact websocket address to attach to"), which bypasses HTTP discovery entirely. A DAP adapter is strictly worse: less client coverage, and it still needs a protocol to reach the engine.
- **Minimum set derived empirically, since CDP has no conformance profile.** Used Hermes' tracked per-method implementation status (cdpstatus.reactnative.dev) as the floor — 15 `Debugger` methods + 4 events, 11 `Runtime` methods + `consoleAPICalled`. `getScriptSource` is *not* in that set, suggesting DevTools degrades rather than refuses without source. I could **not** establish from specification what DevTools refuses to start without, and said so rather than guessing; I named the one-day experiment that settles it (stub CDP server, log what real clients send) and made it slice 0.
- **The object-model gap, grounded.** xsbug pushes the whole world per break (`fxDebugLoop`, `xsDebug.c:608`) and addresses objects by **raw slot pointer** (`fxEchoAddress`, `:1257`), which the client hands back and XS casts straight to a pointer (`(txSlot*)the->idValue`, `:1151`). CDP is pull-based over `objectId` handles with explicit `releaseObject`/`releaseObjectGroup` lifetime. On `ironhorse-vm` this lands on three verified constraints: `SlotIndex(u32)` has no generation tag and the arena has a free list (`value.rs:27,325,450`), so a raw index is an **ABA hazard** — `objectId` must be an opaque serial in a side table; `Heap::collect(roots)` (`gc.rs:57`) means the table **is a GC root**, so release is the only way to stop pinning the guest heap; and `SLOT_ALLOCATION_METERING` (`meter.rs:45`) means the table must not allocate guest slots or attaching a debugger changes computrons (a consensus fault under Agoric).
- **`<toggle>` is the wrong seam** and I said so plainly: it is unreplying view-state that forces a full re-echo, versus `getProperties`' request/response over a handle. The right seam is one level down — a `properties(SlotIndex)` VM query both serializers can sit on.
- **Compartments taken as first-class.** Module identity is `(CompartmentId, specifier)` (`compartment.rs:81,225`, `module.rs:276`), not a path. The good news: `setBreakpointByUrl` returns a `locations` *array* and is designed for exactly the one-source-many-instantiations case, and `executionContextId` maps honestly onto compartments — **the thing CDP gives Endo that xsbug cannot express at all**. The honest concession: synthetic `endo://<compartment>/<specifier>` URLs, and compartments with an `importHook` will simply show "source unavailable".
- **Security treated as first-class**, and the composition problem stated precisely: Endo's surfaces are ocap-disciplined (attenuated `gateway()` bootstrap; unix-socket CapTP), CDP is ambient authority on connect. Proposed shape: the `Debugger` exo stays the authority, the listener is **minted by an attach and dies with it** (no standing `--inspect` port), unix socket by default with a per-session loopback capability URL, **no `ENDO_ADDR`-style escape hatch**, `Host` *and* `Origin` enforced on upgrade (the existing gateway does neither), discovery opt-in.
- **Recommendation: native CDP as stage 7, xsbug deprecated but not dropped.** This contradicts `designs/ironhorse-engine.md` decision 7 ("protocol byte-compatibility over modernization") and I flagged it as an amendment requiring a restated stage-7 acceptance bar. The 11 Rust debug-protocol tests guard the C-XS path and should stay untouched; the 16 CapTP tests test the *exo*, not the wire, and mostly survive.

### On the sibling job (`xs2rust-endor-debugger-caught-vs-uncaught`)

**Adopting CDP subsumes its protocol half and not its VM half.** Verified against the spec: `Debugger.setPauseOnExceptions` takes `state` ∈ `none | caught | uncaught | all` — exactly the four-way choice, already standard, no wire extension, no `uncaughtExceptions` pseudo-breakpoint to invent. That deletes the sibling's entire protocol-shape section along with its hardest constraint (xsbug-client compatibility).

The VM half survives and got sharper from reading `interp.rs`: the handler chain is `jumps: Vec<CatchJump>` with the JS/host flag re-expressed as a *structural* invariant ("every ironhorse jump is a JS jump; the host is the absence of a jump", `:3096`,`:3144`), so the maintainer's predicate is not a walk but `self.jumps.len() > base` — O(1), zero-allocation, metering-neutral, strictly better than the C design. Two live caveats: `yield`/`await` inside a live `try` are currently `Halt::Unsupported` (`:7042`,`:7129`) pending jump-chain snapshot/rebase, and an empty chain does *not* reliably mean uncaught — a throw in a promise reaction is caught by a native `mxTry` (`:15735–15737`), which is why CDP has a separate `promiseRejection` pause reason. Recommendation: keep the jobs separate, retarget the sibling's protocol section to "adopt `setPauseOnExceptions`", keep and sharpen its VM section.

### Follow-ups

1. **Confirm whether the `endor-debug` drop was deliberate deferral or loss in the 2026-07-29 restack.** If slice 1–3 work survives anywhere it is worth recovering as reference — the `DebugTransport` seam and VM break hooks are protocol-agnostic.
2. **Run slice 0** (the handshake experiment) before anyone estimates the work; it gates everything in §2.
3. **Scope column precision separately** — CDP is column-precise, XS's debug records are line-granular, `ironhorse-compile` is mid-port. This is the item most likely to surprise an estimate, and I could not resolve it from the code.
4. **Profiling was out of scope** — CDP's `Profiler` domain versus xsbug's `<pr>`/`<ps>`/`<pt>` needs its own pass.

Also unresolved and stated as open in the issue: whether `getScriptSource` is genuinely optional (evidence is one tracker's omission, which may be incomplete).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endor-debugger-cdp-devtools-investigation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 1552 tokens (6558245 cached reads)
- Output: 51122 tokens
- Cost: $6.2070675
- Wall-clock: 893s

<!-- garden-usage-end -->
