---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-20T03:07:03Z -->

---
model: opus
---
# Stage-10l child 0: fix the two s42 reflection findings (PR #600, endojs/endo-but-for-bots, branch `xs2rust-endor`)

You are an endor-engine fixer. Repo `endojs/endo-but-for-bots`, PR **#600** (DRAFT — leave it DRAFT,
never comment), branch `xs2rust-endor`. Get an isolated checkout with
`scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`,
then **fetch and reset to the REAL remote tip** (the hourly press can rebase the branch; verify
`git rev-parse origin/xs2rust-endor` after a real fetch). Acceptance was at `c34ffd9012`
(s42, issuecomment-5018362782).

**Cache seeding (endolin-garden):** `cp -al` the engine target + ROOT target + `c/moddable`
(oracle pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`) and copy the 5 real bundle JS files
(`rust/endo/xsnap/src/*.js`) from the sibling
`/home/kris/garden/scratch/project-wt-port-xs-to-rust-memory-safe-engine-s42-5cd7f36a` (at
`c34ffd9012`, fully built, clean). `rmdir` your empty `c/moddable` first. Never `git add c/moddable`;
never commit bundles. `cargo` is at `$HOME/.cargo/bin`. Capture test runs to files and check `$?`
(a pipe to `tail` masks the exit code).

## The two findings (both CONFIRMED pre-existing at anchor `c9bafd202`, probe logs in
`/home/kris/garden/tmp/s42-results/{diag-tip,diag-anchor}.log`; probe sources `s42_probe.rs`/`s42_diag.rs` there)

**Item (0) — F1(s42): `Object.getOwnPropertyNames` is UNBOUND.** `typeof Object.getOwnPropertyNames`
→ endor `"undefined"` vs oracle `"function"`; any call throws `"call: not a function"` (an unnamed
wrong-throw, not a self-naming skip). Bind it as the real intrinsic: own STRING-keyed property names
(enumerable AND non-enumerable, symbols excluded), oracle-exact order. Reuse the existing own-keys
machinery (`Object.keys` works; `Reflect.ownKeys` over exotic arrays landed earlier — mind its known
complete-function prepend gap, do not import it here). Dual-run coverage: plain data objects, method
objects, accessor properties (the name appears — this is the `Object.keys:unclassified-property`-adjacent
surface, but gOPN includes non-enumerables so no skip excuse), non-enumerables included, symbol keys
excluded, exotic arrays (indices + `length`), key order vs oracle. If an exotic receiver class is out of
reach, honest named skip — never a wrong completion.

**Item (1) — F2(s42): `Reflect.get` over a live ACCESSOR property returns the internal HOLDER instance
instead of invoking the getter.** `var t={get a(){return 7;}};typeof Reflect.get(t,'a')` → endor
`"object"` vs oracle `"number"` — a WRONG COMPLETION, and a holder-instance encapsulation leak (the
guest gets a reference to an internal model object). F1-class doctrine: every read path must be
coherent. Route `Reflect.get`'s property read through the same accessor-dispatching read path as
ordinary `o.a` (the holder-instance model's getter invocation), including proto-chain accessors and
this-sensitivity (2-arg form: `this` = target). Coverage: getter returning primitive, getter reading
`this`, set-only → `undefined`, data path unregressed (s42 probe B-1 shape), proto-chain accessor via
`Object.create`-free shapes (`__proto__` idioms are fine if supported; else class-free literal chains).
The 3-arg RECEIVER form: implement if the read path already threads a receiver; otherwise an HONEST
NAMED skip (`reflect-get:receiver`) — never the holder leak. Your tada must answer: **is the
holder-leak set EMPTY for `Reflect.get`** (sweep sibling reflective reads: `Reflect.get` was the leak;
check `Reflect.getOwnPropertyDescriptor` still self-names per ledger, and name any OTHER reflective
read that hands the holder to the guest).

## Discipline (all BINDING)

- Reproduce each finding FIRST at the real tip before touching code.
- **Metering doctrine: accuracy-over-parity.** Result agreement gates; do not chase advisory ±1
  computron drift; never regress RESULTS chasing computrons.
- **Push-per-item:** item (0) then item (1), separate commits, separate pushes to
  `origin/xs2rust-endor` (rebase-CAS on race; verify each push by git EXIT CODE).
- **No-boot-regression bars at your final tip, all observed by exit code:** engine workspace
  `cargo test --workspace -- --test-threads=1` EXIT=0 (counts grow ONLY by your new tests — cite
  the grown numbers); compile-diff no-arg 1909/1909 + SYMB 1909/1909; boot gate 30/0; ROOT
  `cargo test -p endo --lib` 111/0 with BOTH markers GREEN
  (`boot_drives_the_real_chain_to_the_worker_bundle_frontier`,
  `real_handler_decodes_a_real_envelope_to_the_dispatch_path_frontier`); 0 non-oracle warnings; no
  new `unsafe`; no new side table (if one proves necessary, ledger it in
  `endor-snapshot/sidetable.rs` the SAME DAY and say so).
- Acceptance-grade runs need `cargo clean -p endor-compile -p endor-vm -p endor-oracle` first and the
  oracle at the declared pin.
- Sized to one 2400s window. If you cannot finish both items, land what is pushed (push-per-item
  protects it) and tada HONESTLY with the remainder named. Report via your tada completion report
  ONLY — never inbox-send the parked supervisor.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 6
  worker_kind: gardener
  claimed_at: 2026-07-20T03:07:07Z
