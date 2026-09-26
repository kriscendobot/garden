---
orchestration-failed: true
---
All verified and pushed. The read-only family's `:non-dense-array` skips are eliminated; the remaining skips are the allocating/mutating methods and static/named gaps (all still skips, zero failures). 

Let me write the completion report. Since I delivered a large, correct increment but did **not** convert the full 2,330-case slice (map/filter/mutating-method generic receivers, sort/toSorted, from/of, `defineProperty` on array exotics, and fromAsync all remain unsupported), I signal the gated shortfall honestly, following child 09's precedent.

---

## Completion report — `ironhorse-js-10-arrays-species`

**Job:** Close Array construction/prototype/species holes in `endojs/endo-but-for-bots` (Ironhorse engine), garden issue 51. Worked in the shared completion branch `feat/ironhorse-262-language-completion` (PR #970), based off child 09's head `6947d488b8`; remote had not moved, no rebase needed. Pins unchanged: test262 `be13516fb6…`, XS oracle `23b4d6b0a6…`.

**What I did**
- Read every earlier child report; the dense fast paths for the read-only `Array.prototype` methods bailed (`<m>:non-dense-array`) for any receiver that was not a fully-packed array — a sparse array (holes), a plain array-like object, an accessor receiver, or a Proxy — leaving ~1,400 cases skipped.
- Added a spec-faithful **generic array-like/sparse/proxy receiver path** in `rust/engine/ironhorse-vm/src/interp.rs`, driven through the object MOP (`mop_get`/`mop_has`), for the non-allocating read-only family: `forEach`, `some`/`every`, `find`/`findIndex`/`findLast`/`findLastIndex`, `indexOf`, `lastIndexOf`, `includes`, `reduce`/`reduceRight`, `at`. Each honors accessors (getters run through `Get`), prototype-chain hole inheritance (`HasProperty` walks the chain), and proxy traps, in each method's **exact** HasProperty/Get abstract-operation sequence. Bad `this` (null/undefined → `ToObject`), non-callable callbacks, and empty/all-holes `reduce` with no seed throw catchable `TypeError`s; `ToLength`/`ToIntegerOrInfinity` run in spec order.
- Scoped deliberately to the read-only family (no `ArraySpeciesCreate`), so a generic receiver **cannot** diverge on species — eliminating the main regression risk.
- Iteration cap (`1<<24`) so a `length` up to 2^53−1 neither OOMs nor trips the case timeout; over the cap the case keeps its **original** named skip (never a new failure). `reduce`/`reduceRight` decline a length beyond the 2^32 index space, where XS itself mis-folds (`reduceRight/length-near-integer-limit`) — kept as a skip rather than asserting a divergence against a non-compliant oracle (verified: `indexOf`/`lastIndexOf` at the same length agree with XS and stay covered).
- Fixed a latent `None`-unwrap: `array_generic_length` interns the `length` key at runtime, since a source that never mentions `length` statically (e.g. `new Array(4);a[3]='z';a.lastIndexOf('z')`) leaves `self.length_id` unset.
- Added `rust/engine/ironhorse-262/tests/array_generic_receiver.rs` — 14 XS dual-run behavioral cases (array-like, sparse, prototype-inherited holes, accessors, proxy trap sequence, ToObject/IsCallable/empty-reduce TypeErrors, ToLength ordering).

**Totals (official `built-ins/Array/**`, test262 `be13516`, XS oracle `23b4d6b0`, real differential execution)**
- Command: `ironhorse-xst --test262-dir <pin> built-ins/Array`
- Before: **covered 610**, 0 failed, 2472 skipped (of 3082).
- After: **covered 1317** (+707), **0 failed**, 1765 skipped (of 3082). `BAR MET`.
- `built-ins/ArrayIteratorPrototype`: 0 covered / 0 failed — unchanged.
- Changed skip reasons: the read-only `:non-dense-array` buckets (`reduce` 304, `some/every` 223, `indexOf` 105, `forEach` 104, `lastIndexOf` 101, `find`/`findLast`, `includes`, `at`) are **eliminated**. Remaining skips are the allocating/mutating methods (`map` 122, `filter` 115, `splice`/`slice`/`pop`/`push`/`copyWithin`/`shift`/`unshift`) and static/named gaps (`defineProperty:exotic-object` 222, `Array.fromAsync` 80, `native-call:Function` 71, `Array.from` 41, `sort` 29, `toSorted` 14, `Array.of` 11, `concat`). `ironhorse-aborted` 602→727 (+125): cases that now enter the generic path and hit a deeper ironhorse limitation — all still **skips**, never failures.

**Regression invariant — verified**
- `cargo test --workspace --release` (rust/engine): **41 suites, 0 failed** — includes the exact-metering corpus gates (`corpus_conversion_equivalence`, `regressions_dual_run` — every `cases/**` computron expectation unchanged; the generic path runs only for non-dense receivers, which the packed corpus never exercises), the snapshot ledger, `proxy_traps`, and the new `array_generic_receiver` (14/14).
- No case covered in the starting report or by an earlier child regressed; **no new `ironhorse-failure` or `infrastructure`** (0 failed on the whole slice). `clippy` clean on the changed code.

**Pushed / PR:** head `9aab83208b4f45b46bc2207065866b2b98c54d72` on `feat/ironhorse-262-language-completion` (remote tip confirmed = this head); PR https://github.com/endojs/endo-but-for-bots/pull/970 — **OPEN, draft, not merged**.

**Gated-outcome note (honest shortfall):** the read-only-family generic receiver work is complete and correct (+707, 0 failures, fully XS-verified), but the orchestration's bar — convert the *whole* Array slice to covered except for justified host/proposal exclusions — is **not** fully met. Still unsupported: generic-receiver `map`/`filter`/`slice`/`splice`/`concat` and the mutating methods (they need `ArraySpeciesCreate`, deferred to avoid species divergence in this pass); `sort`/`toSorted` (data-dependent comparison metering); `Array.from`/`Array.of`/`Array.fromAsync`; and `Object.defineProperty` on array exotics (222). These are follow-ups for a subsequent pass, so I signal the shortfall rather than overstate.

**Follow-ups:** implement `ArraySpeciesCreate` and extend the generic path to the allocating/mutating family; `Array.prototype.sort`/`toSorted` with a defined comparison-metering model; `Array.from` (iterator protocol + array-like) and `Array.of`; the array-exotic `[[DefineOwnProperty]]` (unblocks `defineProperty:exotic-object` and `verifyProperty`-style tests).

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-10-arrays-species.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 248 tokens (20528323 cached reads)
- Output: 133670 tokens
- Cost: $16.030052500000004
- Wall-clock: 2001s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
