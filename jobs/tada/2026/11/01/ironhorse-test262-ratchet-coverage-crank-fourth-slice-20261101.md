# Ironhorse test262 ratchet, fourth slice: separate String and Array iterator prototypes (+12 fail→pass, +2 skip→pass, 0 lost)

The fourth slice is done. Draft PR https://github.com/endojs/endo-but-for-bots/pull/1604 is open on head `ironhorse-test262-ratchet-iterator-tags-20261101`, base `llm-9a14ddf`, with the `garden-arc: ironhorse-test262-ratchet` marker.

**Choosing the slice.** The previous claim of this job timed out after 2 hours on oros and left nothing behind, so I started clean. The other cranks had already taken RegExp flag accessors, AsyncFromSyncIterator (#1599), TypedArray toReversed/toSorted/with (#1600), the deleted-`with`-binding fix (#1601), explicit resource management (#1602) and Promise. I counted failures in the committed whole-tree shards, leaving out Temporal and those directories, and picked the iterator tag gap. `xs_departures.rs` and `intrinsic_key_order.rs` already recorded it as a known gap: String iterators shared `%ArrayIteratorPrototype%`, which had no `Symbol.toStringTag`, so both printed as `[object Iterator]` instead of `Array Iterator` / `String Iterator`. I told the other three cranks I was taking it and that it grows the boot heap.

**Engine change (`ironhorse-vm`).**
- **New prototype.** `%StringIteratorPrototype%` is now its own boot object, chaining to `%IteratorPrototype%`. It has its own `next` (`NativeMethod::StringIteratorNext`), which accepts only String Iterators.
- **Array `next`.** `%ArrayIteratorPrototype%.next` now accepts only array iterators, so calling it on a String Iterator throws a TypeError, as XS does.
- **Tags.** Both prototypes now carry their `Array Iterator` / `String Iterator` tags.
- **Boot heap.** It grows from 1100 to 1105 slots. I followed the usual regeneration procedure:
  - registered the prototype in the state field list, intrinsic key order, GC registry and snapshot ledger;
  - regenerated the state goldens and boot fingerprint under both math providers;
  - re-pinned the metamorphic hashes;
  - rewrote the fuzz seed corpus.

**Ratchet.** Four whole-tree shards change:

| Shard | Change |
| --- | --- |
| `ArrayIteratorPrototype/Symbol.toStringTag` | 6 rows fail → pass |
| `StringIteratorPrototype` | 2 rows fail → pass |
| `Object/prototype/toString` | 4 rows fail → pass |
| `Iterator/from` (`primitives.js`) | 2 rows skip → pass |

I re-ran all 1,930 manifest batches. A few shards differed only because I swept with a shorter timeout; re-run at the default 60 s they matched exactly, so nothing regressed. Temporal stays host-excluded. As in #1599–#1602, I left out the `baseline/refresh-*` floor directory, which waits on the open question in kriscendobot/garden#51.

I also moved two hardened262 `intrinsic-metadata.js` cases (Array and String iterator prototypes) to passed in the four Ironhorse scenarios that run. `native_lockdown_corpora` fails unless that baseline matches.

**Tests.**
- **New file.** `ironhorse-262/tests/string_iterator_prototype.rs` has 3 tests, each compared against XS. XS marks `next` as non-configurable, which differs from the spec, so the tests don't check that field.
- **Local runs.** All of these pass:
  - release test suites for vm, 262, snapshot, fuzz, runtime and compile;
  - snapshot and vm again under deterministic-math;
  - the SES boot and prelude tests, after building their artifacts;
  - the `try.txt` and `ironhorse.txt` expectation gates;
  - `cargo fmt --check`.
- **Clippy.** No warnings in the touched files.

**CI.** `test-ironhorse`, `-release`, `-macos`, `-calibration`, `test-thixotrope-ironhorse`, `fuzz-ironhorse`, `format-ironhorse`, `build-ironhorse-wasm` and the Ubuntu JS legs all pass. `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` fail, but only on `stage3-math/054.js` and `055.js`, which already fail the same way on #1548 and #1599; I noted that on the PR. Because the oracle lane stops at that first failing test binary, CI never ran the later `ironhorse-262` tests there; I ran them locally. The two macOS JS legs were still pending when I stopped; this PR changes no JS.

**Follow-ups.**
- **Fixture conflicts.** #1599, #1600, #1602 and #1604 all change the boot-heap fixtures and will conflict there. Whichever merges later has to rerun the golden regeneration under both providers, `write-seed-corpus` and the hash re-pin. Their expectation shards don't overlap.
- **Autopilot.** The ratchet autopilot halts when more than one crank PR is open, and several are open now, so the maintainer will need to handle that.
- **Memory.** I added the 5-minute whole-tree sweep recipe and the hardened262 and SES gate notes to the boot-heap memory.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-fourth-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 212 tokens (14932322 cached reads)
- Output: 46449 tokens
- Cost: $5.480172399999999 (1 engagement(s) unpriced)
- Wall-clock: 12195s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
