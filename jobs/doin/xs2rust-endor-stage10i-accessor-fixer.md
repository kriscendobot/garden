---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T10:37:05Z -->

---
model: opus
---
# Fixer: literal/class accessor definitions must stop wrong-completing (finding F1(s39), PR #600)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, DRAFT — keep it DRAFT).
**Workspace:** the Rust engine workspace is `rust/engine` (NOT the repo root). Get an ISOLATED
project checkout keyed by THIS job's base:
`/home/kris/garden/scripts/jobs/ensure-project-worktree.sh xs2rust-endor-stage10i-accessor-fixer endojs/endo-but-for-bots xs2rust-endor`
Sync to the REAL remote tip first (`git fetch origin xs2rust-endor` + checkout FETCH_HEAD); verify
pushes by git EXIT CODE. Seed `rust/engine/target/` via `cp -al` from a same-branch sibling
worktree (e.g. `project-wt-xs2rust-endor-stage10g-live-captp-eval-5cd7f36a`), `rmdir` the empty
`c/moddable` and copy the sibling's pinned checkout (verify sha `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`,
clean), then `cargo clean -p endor-compile -p endor-vm -p endor-oracle`. `cargo` at
`$HOME/.cargo/bin`; capture test output to files and check `$?`, never pipe to `tail`.

## The finding (s39, CONFIRMED by dual-run probes at `d911a95894` — issuecomment-5015383357)

The compiler faithfully emits `XS_GETTER_FLAG` (32) / `XS_SETTER_FLAG` (64) in the define-flag
byte of `XS_CODE_NEW_PROPERTY` / `XS_CODE_NEW_PROPERTY_AT` for object-literal and class-body
accessors (`endor-compile/src/coder.rs`, object-literal ~2963 and class ~4130 paths). The VM
handler (`endor-vm/src/interp.rs` `XS_CODE_NEW_PROPERTY`, ~6813) calls
`instance_put(inst, id, value)` and **ignores the flag byte**: a literal accessor is defined as a
plain DATA property holding the accessor function. Every downstream path then silently diverges
from the C-XS oracle:

1. `var log='no';var t={set a(v){log='set:'+v;}};t.a=2;log;` → oracle `set:2`, endor completes `no`
   (the core SET opcode; setter never invoked).
2. `var t={get a(){return 9;}};typeof Object.getOwnPropertyDescriptor(t,'a').get;` → oracle
   `function`, endor completes `undefined`.
3. `var log='no';var t={get a(){return 9;},set a(v){log='set:'+v;}};Object.assign(t,{a:2});'ok get='+t.a+' '+log;`
   → oracle `ok get=9 set:2`, endor completes `ok get=2 no` (the s37 F1 accessor scenario in its
   literal form — `accessor_in_chain` correctly sees no accessor because none was ever defined).
4. `class C{get a(){return 9;}}var c=new C();''+c.a;` self-names only by LUCK
   (`add:toprimitive-no-primitive` on the returned function); a bare `c.a===9` shape completes
   wrongly.

This is the s34/s37 F1 bug CLASS at the DEFINITION path: erasing accessor-ness at define time
poisons every later read/write/reflection. The `defineProperty`-created accessor path
(holder-instance model) is correct and verified — the defect is only the bytecode define path.

## Definition of done

1. **REPRODUCE-FIRST.** Land dual-run suites reproducing the probe matrix above: each scenario
   wrong-completes pre-fix, and post-fix either agrees with the oracle or honestly self-names.
   Never delete or weaken the existing `object_assign.rs` §5 / `array_sort_comparator.rs` §7 suites.
2. **Fix:** at `XS_CODE_NEW_PROPERTY` / `XS_CODE_NEW_PROPERTY_AT`, read the define-flag byte; when
   it carries `XS_GETTER_FLAG`/`XS_SETTER_FLAG`, route the define through the SAME holder-instance
   accessor machinery `Object.defineProperty` uses (get-only, set-only, and get+set pairs — note
   XS merges a later `set a` onto an earlier `get a` for the same key in one literal), so
   downstream get/set/gopd/assign ride the already-verified accessor paths. Meter the covered
   define shape bit-exact vs the oracle (dual-run computron gate); if some sub-shape cannot be
   made bit-exact this slice, an honest named skip is the floor — never a wrong completion.
3. **No boot regression — BINDING.** Literal accessors are common in real code. Before choosing
   any self-name floor, check whether the SES/worker/daemon boot bundles define literal accessors
   (run the boot gate and the worker marker). Whatever the choice: `boot_bundle_gate` stays 30/0
   and the worker-bundle marker (`boot_drives_the_real_chain_to_the_worker_bundle_frontier`)
   stays at `halted_at: ("worker_bootstrap", Unsupported("for_of"))` with
   `handle_command_registered: true` — or advances. Any frontier REGRESSION is a failed fix.
4. **Sweep (doctrine):** enumerate every consumer of the NEW_PROPERTY define-flag byte and report
   what each flag does in the VM today (`XS_METHOD_FLAG`, `XS_NAME_FLAG`, DONT_ENUM et al.) — any
   OTHER silently-dropped flag semantics with observable divergence is a finding to report in your
   tada (fix only if small; do not scope-creep).
5. Bars at EVERY push (push-per-item discipline): engine workspace `cargo test --workspace --
   --test-threads=1` all-pass EXIT=0 at the claimed tip; compile-diff 1909/1909 + SYMB 1909/1909
   EXIT=0 (the compiler is untouched — if compile-diff moves, stop and reassess); boot gate 30/0;
   ROOT `cargo test -p endo --lib` 110/0 with REAL bundles (seed the 3 gitignored bundles from
   `/home/kris/garden/tmp/s9r/rust/endo/xsnap/src/` after `diff -rq` packages content-identity —
   never commit bundles); zero new non-oracle warnings; `VARIANT_COUNT` 35 (no new side table
   expected; ledger any new one the day it lands); no new `unsafe`.

Size to ONE 2400s handler invocation; push each self-contained increment as it lands (the branch
must never be left with unpushed work at deadline). Report via your tada completion report ONLY —
never inbox-send the parked supervisor. Keep PR #600 DRAFT; confirm its state at the end.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 5
  worker_kind: gardener
  claimed_at: 2026-07-19T10:37:13Z
