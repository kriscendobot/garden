---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T12:07:02Z -->

---
model: opus
---
# Fixer: F1(s40) + F2(s40) — class-method DONT_ENUM and inferred `.name` dropped at define time (PR #600, stage 10j)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, DRAFT — keep it DRAFT).
Isolated checkout keyed by THIS base:
`/home/kris/garden/scripts/jobs/ensure-project-worktree.sh xs2rust-endor-stage10j-flag-fixer endojs/endo-but-for-bots xs2rust-endor`
Sync to the REAL remote tip (`git fetch origin xs2rust-endor`, work at FETCH_HEAD — the hourly
press can advance the branch). Seed `rust/engine/target/` `cp -al` from a same-branch sibling
(e.g. `project-wt-port-xs-to-rust-memory-safe-engine-s40-5cd7f36a` at `afff3aaf64`); `rmdir` the
empty `c/moddable` and copy the sibling's (verify pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`,
clean status); then `cargo clean -p endor-compile -p endor-vm -p endor-oracle`. `cargo` at
`$HOME/.cargo/bin`. REAL bundles seed from `/home/kris/garden/tmp/s9r/rust/endo/xsnap/src/`
(packages content-identity `diff -rq … -x node_modules` first; never commit bundles). Verify
pushes by git EXIT CODE. Push-per-item: F1(s40) is one push, F2(s40) is another.

**The findings (supervisor s40, PR #600 issuecomment-5015638801 — CONFIRMED wrong-completions,
independently probe-verified at `afff3aaf64`).** Both are dropped define-flags in the class/
literal DATA-define path — the s34/s37/s39/s40 F1 bug CLASS (binding doctrine: a define path
must preserve/honor property flags end to end):

1. **F1(s40) — `XS_DONT_ENUM_FLAG` (4) dropped on class DATA methods.** The `NEW_PROPERTY`
   define byte carries it (the stage-10i accessor path already honors it) but the data path
   (`instance_put`) stamps flag=0. Observed: `class C{m(){}}` →
   `Object.keys(C.prototype).length` oracle `"0"` / endor `"1"`;
   `Object.getOwnPropertyDescriptor(C.prototype,'m').enumerable` oracle `"false"` / endor
   `"true"`. Object-literal methods must STAY enumerable; class accessors already carry
   `false,true` — do not disturb either.
2. **F2(s40) — inferred `.name` dropped** (`XS_NAME_FLAG`/`XS_METHOD_FLAG` consumers). An
   anonymous function value or shorthand/class method gets no inferred name:
   `({a:function(){}}).a.name` oracle `"a"` / endor `""`; `({m(){}}).m.name` `"m"`/`""`;
   `class C{m(){}}C.prototype.m.name` `"m"`/`""`. Named function expressions are unaffected
   (`"bob"` agrees) and must stay so. Fix via the `fxRenameFunction` transliteration (name-chunk
   alloc + its metered built-in steps), per the existing generator-method rename precedent in
   the tree.

**REPRODUCE FIRST:** land a dual-run suite that reproduces every wrong-completion above (result
+ computrons) BEFORE fixing; then make it agree bit-exact. Transliterate XS (`xsRun.c`
`NEW_PROPERTY_ALL` flag handling; `fxRenameFunction` in xsFunction.c) — never invent semantics.
Metering must be bit-exact vs the oracle for every covered shape (pure-define computron probes,
the stage-10i fixer's pattern). Shapes an increment does not faithfully cover must self-name
(honest named skip) — NEVER wrong-complete.

**Sweep (report in tada):** re-run the define-flag-byte consumer enumeration after the fix —
report any REMAINING dropped-flag consumer with observable divergence (the s40 acceptance
recorded these two as the known set; the tada must say whether the set is now empty).

**BINDING no-boot-regression clause:** at every push — engine workspace all-pass EXIT=0
(`--test-threads=1`, captured to file, check `$?`), compile-diff 1909/1909 + SYMB 1909/1909
EXIT=0 (counts may GROW if the corpus grows — cite what you measure), boot gate 30/0, ROOT
`cargo test -p endo --lib` all-pass with real bundles, and the full-boot marker
`boot_drives_the_real_chain_to_the_worker_bundle_frontier` stays GREEN
(`halted_at == None && handle_command_registered == true`) — the class-method enumerability
change touches property enumeration inside SES lockdown paths; if lockdown regresses, STOP,
diagnose, and report rather than push a red tree. No new side table without a ledger row
(VARIANT_COUNT currently 35); no new `unsafe`; zero new non-oracle warnings.

**Sizing/HARD STOP:** fit one 2400s handler invocation; reassess the clock after every pushed
item; if F2(s40) does not fit after F1(s40) lands, push F1 alone and report the remainder
honestly. Report via your tada completion report ONLY — never inbox-send the parked supervisor.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-19T12:07:06Z
