---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T13:58:03Z -->

---
model: opus
---
# stage-10k child 0: F1(s41) — accessor→data method-redefine leaves a stale getter (PR #600)

Repo `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, DRAFT — never un-draft, never touch PR state). Get an ISOLATED worktree via `scripts/jobs/ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots xs2rust-endor`; sync to the REAL remote tip (verify `git fetch` + sha). Seed `rust/engine/target/` + `c/moddable` (`cp -al`) from the s41 supervisor sibling `/home/kris/garden2/scratch/project-wt-port-xs-to-rust-memory-safe-engine-s41-5cd7f36a` (endolin-garden2, at `42e4fcdf8e`, fully built cache incl. the oracle at pin `23b4d6b0a65f`; `rmdir` your empty `c/moddable` first); real bundles seed from its `rust/endo/xsnap/src/*.js` — NEVER commit bundles. `cargo clean -p endor-compile -p endor-vm -p endor-oracle` before any acceptance-grade run. `cargo` at `$HOME/.cargo/bin`; capture test runs to a file and check `$?` (a pipe to tail masks the exit code).

**Finding (CONFIRMED, s41 review, issuecomment-5015969926 — pre-existing at `afff3aaf64`):** redefining an accessor property with a data METHOD in the same object literal / class body leaves the stale getter live on the read path:
- `var o={get m(){return 1},m(){return 2}};o.m();` → oracle `"2"`, endor `Throw("call: not a function")` (the read runs the STALE getter → `1`, then `1()` throws).
- `class C{get m(){return 1}m(){return 2}}new C().m();` → same divergence.
- `getOwnPropertyDescriptor` correctly reports the DATA shape (`.get === undefined`, `enumerable:false`) — the slot is internally INCONSISTENT (GETTER/SETTER flag or holder linkage survives the data `instance_put`).
- The data-VALUE redefine (`{get m(){return 1},m:2}` → `o.m` = `"2"`) already works; only the method-define branch misses the accessor-clear.

**Reproduce FIRST** (dual-run both record shapes at your tip), then fix by transliterating XS's `fxOrdinaryDefineOwnProperty` data-over-accessor transition — the same holder-instance machinery `instance_define_accessor` uses, direction reversed: the data define must clear the accessor state (GETTER/SETTER flags + holder linkage) and leave a coherent data slot. Cover: literal + class bodies; method + generator/async method values; computed-key (`NEW_PROPERTY_AT`) variants; set-only→data; get+set→data; data→accessor→data round trips. Metering must stay bit-exact vs the C-XS oracle for every covered shape. The redefine-reflection +1 advisory family (`Object.keys` after duplicate methods 75/76, gopd after accessor→data 57/58) is pre-existing — do not chase it, do not regress it; if your fix incidentally closes it, say so in your tada.

**BINDING no-boot-regression clause — at EVERY push:** engine workspace `cargo test --workspace -- --test-threads=1` EXIT=0 (last: 894/0, 70 result lines); compile-diff no-arg **1909/1909 + SYMB 1909/1909** EXIT=0; ROOT `cargo test -p endo --lib` **111/0** with real bundles and BOTH markers GREEN (`boot_drives_the_real_chain_to_the_worker_bundle_frontier` + `real_handler_decodes_a_real_envelope_to_the_dispatch_path_frontier`). No new `unsafe` (7 forbid roots + oracle exempt), no new side table without a same-day ledger row (VARIANT_COUNT 35), 0 non-oracle warnings.

Commit a dual-run suite (endor-262/tests style: both record shapes + your fresh variants). Push-per-item to `origin/xs2rust-endor` (verify by git EXIT CODE; rebase-CAS on race). Your tada MUST state: the redefine sweep answer (is the stale-accessor-redefine set now EMPTY?), each push sha, and the bar numbers at your tip. Report via your tada completion report ONLY — never inbox-send the parked supervisor.
