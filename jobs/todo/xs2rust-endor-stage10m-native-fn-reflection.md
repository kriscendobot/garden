---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-20T04:52:08Z -->

---
model: opus
---
# stage-10m child 1: F1(s43) — native-method `length`/`name` own-property reflection (engine-wide)

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep DRAFT), branch `xs2rust-endor`, base `llm`.
Doctrine: **accuracy-over-parity**; oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` certifies
RESULTS; transliterate from the pinned C where the C defines the shape (`fxNewHostFunction` stamps
`length`/`name`; XS builtins carry spec arities).

**Worktree:** `/home/kris/garden2/scripts/jobs/ensure-project-worktree.sh xs2rust-endor-stage10m-native-fn-reflection endojs/endo-but-for-bots xs2rust-endor`.
Fetch and confirm the REAL remote tip first (child 0 of this orchestration lands `set_property_at` before
you — sync past it; read the latest press tadas; if a press is live, message it to defer). Seed caches
(`cp -al`) from `/home/kris/garden2/scratch/project-wt-port-xs-to-rust-memory-safe-engine-s43-5cd7f36a`
(engine target, ROOT target, `c/moddable` at the pin — `rmdir` empty `c/moddable` first — and
`rust/endo/xsnap/src/*.js` bundles); verify pin sha + clean status. Workspace `rust/engine`; `cargo` at
`$HOME/.cargo/bin`; never commit bundles.

## The finding (F1(s43), s42-probe-attributed PRE-EXISTING — reproduce first)

Every native method reads `.length` and `.name` as `undefined` where the oracle reads the spec arity/name
— a SILENT wrong completion, not a self-skip: `Object.keys.length` → oracle `"1"` endor `"undefined"`;
same class for `Object.getOwnPropertyNames.length` (1), `Object.getOwnPropertyDescriptor.length` (2),
`Reflect.get.length` (2), `Object.assign.length` (2), `Object.freeze.length` (1), `[].push.length` (1),
`''.slice.length` (2), and `.name` (`Object.keys.name` → `"keys"`, …). Repro probes:
`~/tmp/s43-results/s43_diag.rs` (endolin-garden2) — reconstruct, don't copy blindly.

## The fix

Native function objects must expose own `length` and `name` data properties with XS's exact values and
flags (in XS both are configurable, non-writable, non-enumerable — verify against the pinned C's
`fxNewHostFunction`/builder tables, and match the oracle's observable flags via
`Object.getOwnPropertyDescriptor` where that path is covered). Prefer a lazy/synthesized read over
materializing thousands of slots if that fits the existing native-method model — but the observable
results must agree with the oracle either way. Cover at minimum:

- The intrinsic statics and prototype methods across Object/Reflect/Array/String/Number/JSON/Math/
  Symbol/Map/Set/RegExp/Promise as bound today. The arity is per-method (spec/C table) — do NOT guess:
  read the pinned C's builder calls (`mxCallback(fx_...)`, arity argument) or verify per-method against
  the oracle by dual-run.
- `.name` for named natives; Symbol-keyed method names stay anonymous per the existing deliberate ledger
  row (do not regress that).
- Interaction with the own-keys walks: whether `length`/`name` appear in
  `Object.getOwnPropertyNames(Object.keys)` etc. must match the oracle (the ledger's "complete function
  `Reflect.ownKeys` (length/name/prototype prepend)" row — graduate it here if it falls out naturally, or
  leave it self-naming and say so).
- User-defined function `length`/`name` already have coverage — do not regress (`f.name`, inferred
  names, bound functions' `bound ` prefix if covered; check existing tests before touching shared paths).

Dual-run tests for each shape; anything genuinely beyond the model self-names honestly, never fabricates.

## Discipline

Reproduce-first; push-per-item (verify by git EXIT CODE; rebase-and-retry on CAS races); HARD STOP —
size to ONE 2400s invocation, reassess after every pushed item, stop at a green checkpoint. BINDING
no-boot-regression bars on ANY pushed engine change (acceptance-grade clean of endor-compile/endor-vm/
endor-oracle; oracle from the sha-verified pin): engine workspace EXIT=0 (grows only by your tests),
compile-diff 1909/1909 + SYMB 1909/1909, boot gate 30/0, ROOT `cargo test -p endo --lib` 111/0 with the
three markers GREEN. Forbid roots intact, VARIANT_COUNT 35 unless ledgered same-day, 0 non-oracle
warnings, no new `unsafe`, no new side table without a same-day ledger row. Report via tada ONLY; name
commits, skips added/removed, measured bars at your final tip.
