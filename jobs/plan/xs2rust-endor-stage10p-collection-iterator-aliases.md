---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage10p
priority: normal
posted_by: producer
posted_at: 2026-07-20T09:19:38Z
---

---
model: opus
---
# Stage-10p child 0: collection `@@iterator` alias completion — F1(s46) (PR #600, xs2rust-endor)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor`, PR #600 (DRAFT — keep DRAFT; never un-draft).
**Worktree:** `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`.
Sync to the REAL remote tip first (`git fetch origin xs2rust-endor && git reset --hard FETCH_HEAD`) — the
hourly press advances the branch. Seed caches `cp -al` from a same-tip sibling on endolin-garden
(`scratch/project-wt-port-xs-to-rust-memory-safe-engine-s46-5cd7f36a` is at `139b8561f1` with warm
engine+ROOT target, oracle at pin, real bundles; also the press worktree
`project-wt-xs2rust-endor-press-20260720-083504-5cd7f36a`); seed real bundles from a sibling's
`rust/endo/xsnap/src/*.js`; NEVER commit bundles and never `git add c/moddable`. `cargo` at
`$HOME/.cargo/bin`; `TMPDIR=$HOME/tmp` (mkdir it); capture `cargo test` to a file and check `$?`.

## The finding (F1(s46), pre-existing at anchor `d268092d7b`, verified by the s46 acceptance review)

`Set.prototype[Symbol.iterator] === Set.prototype.values` → endor `false`, oracle `true` (silent
WRONG-completion of an identity read). The pinned C builder table
(`c/moddable/xs/sources/xsMapSet.c`, SET section, `fxNextSlotProperty(the, slot, property,
mxID(_Symbol_iterator), XS_DONT_ENUM_FLAG)`) makes `@@iterator` the SAME function slot as `values`
(which `keys` now also shares, per `139b8561f1`). endor binds a distinct function object.

## Task — reproduce-first, then transliterate the FULL collection alias audit (never guess)

1. Reproduce at tip via dual-run: the Set `@@iterator` identity probe above, plus
   `Set.prototype[Symbol.iterator] === Set.prototype.keys` (oracle `true`).
2. Audit EVERY `fxNextSlotProperty` `@@iterator`-style alias in the pinned builder tables and fix each
   identity divergence the same way (share the ONE function slot; the shared `.name` is the aliased
   target's): Set (`values`), Map (`entries`, xsMapSet.c MAP section), Array
   (`values`, xsArray.c), TypedArray, arguments object, String's own `@@iterator` (NOT an alias — its own
   host function; verify, don't assume), and any others the grep over the pinned tables surfaces
   (`grep -n 'mxID(_Symbol_iterator)' c/moddable/xs/sources/*.c`). Fix ONLY genuine identity divergences
   reproduced by dual-run; record each verified-already-correct case in the report.
3. Do NOT collaterally alias distinct functions (`Map.prototype.keys` stays its own `"keys"` function).
4. Gate tests per fix (endor-262 tests, dual-run agreement), incl. graduating the s46 probe comment:
   `Set.prototype[Symbol.iterator] === Set.prototype.values` must become an `agree` gate.

## Discipline

Push-per-item (each alias fix its own commit, pushed with rebase CAS; verify push by git EXIT CODE).
On EVERY pushed engine change run the full bars and cite measured numbers at the pushed tip: engine
workspace `cargo test --workspace --release` (943/0 at `139b8561f1`, count GROWS with your gates),
compile-diff no-arg (1909/1909 + SYMB 1909/1909), boot gate `cargo test --release --test
boot_bundle_gate` (30/0), ROOT `cargo test -p endo --lib` (111/0), 0 non-oracle warnings, no new
`unsafe`, no new side table. Oracle from the sha-verified moddable pin
`23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (copy `c/` contents from a sibling — beware `cp -al SRC c/moddable`
nesting when the gitlink dir exists; verify `git -C c/moddable rev-parse HEAD`). Accuracy-over-parity:
RESULT agreement gates; computrons advisory; honest-skip over wrong-complete, always. Size the work to
one 2400s invocation; report via your tada ONLY (never inbox-send the parked supervisor). Keep PR DRAFT.
