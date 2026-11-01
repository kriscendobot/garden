# Ironhorse test262 ratchet, twelfth slice: `built-ins/Object` (8 rows now pass, none lost)

I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1606 on branch `ironhorse-test262-ratchet-object-builtins-20261101`, based on the frozen `llm-9a14ddf`. CI passes except for two oracle lanes, which fail only on a known `Math` issue that's already on `llm`.

**Choosing the slice.** I counted failing rows per directory in the committed whole-tree expectation lists, left out Temporal, and checked with the other crank slices over the inbox. Other slices had already taken the iterator tags (#1604), Promise (#1603), resource management and AsyncFromSync. `built-ins/Object` had several small, separate bugs.

**Engine fixes** (all in `rust/engine/ironhorse-vm`):
- **`hasOwnProperty` argument order** (`property/object.rs`): it now converts the key before converting the receiver, as the spec and XS do. A key whose conversion throws now wins over a `null`/`undefined` receiver.
- **`Object.prototype`'s prototype can't be changed** (`property.rs`): setting it to anything other than its current prototype now fails, as the spec requires and as XS does.
- **Proxy as the script's final value** (`interp.rs`): the end-of-run check mistook a Proxy for an object with no prototype, which the oracle can't print. A script ending in `Object.seal(new Proxy({}, {}))` was misreported as a TypeError.

**Ratchet.** Eight rows went from fail to pass:

| Expectation file | Rows fixed |
| --- | --- |
| `Object/prototype/hasOwnProperty` | 2 |
| `Object/prototype` | 4 |
| `Object/seal` (`seal-proxy.js`) | 2 |

**Coordination.** I had also fixed strict-mode computed-key writes (`obj[k] = v` on a frozen object didn't throw). The tenth slice claimed those 5 rows, so I took that fix out of my PR and messaged them where the bug is. I told the thirteenth slice which rows I'm taking and which `Object` rows are still open. They're now looking at the global object's null prototype.

**Tests.** The new file `ironhorse-262/tests/object_builtin_conformance.rs` has 3 tests, each comparing Ironhorse against XS. All of these passed locally:
- **Whole-tree sweep:** all 1549 non-Temporal batches, using a release build.
  - The sweep ran with the strict-write fix still included. After taking it out, I re-ran every expectation file it touched, and they all match.
  - The only other differences were three `copyWithin` detached-buffer cases where XS itself doesn't finish. My change can't affect XS.
- **Expectation lists:** `try.txt`, and `ironhorse.txt` run three times.
- **Release test suites:** `ironhorse-vm`, `ironhorse-262`, `-runtime`, `-snapshot`, `-compile` and `-fuzz`, plus the deterministic-math tests for vm and snapshot.
- **Formatting:** `cargo fmt --check`.

**CI:**
- **Passing:** every leg except the two oracle lanes below. `cover (22.x)` failed once in the JS `bwrap` cancellation test, a known flake unrelated to this Rust-only change, and passed when re-run.
- **Failing:** `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` fail only on `stage3-math/054` and `055`, where `Math.asinh`/`Math.acosh` differ from XS in the last digit. They fail the same way on `llm`, #1603 and #1604, and #1585 tracks the fix. I explained this in a PR comment.

**Follow-ups:**
- **Proxy-of-Array output:** XS prints a Proxy-of-Array script result as `[object Object]`, while Ironhorse prints `1,2`. That difference was there before this change, and I left it out of the tests.
- **Rows still failing in `built-ins/Object`:** `getOwnPropertyDescriptor` 109 and 212–215 (`Math.random` and the RegExp accessors). The thirteenth slice is looking at `getPrototypeOf/15.2.3.2-2-30` and `defineProperty/15.2.3.6-4-625gs` (the global object's prototype).
- **Shared expectation file:** this PR and the tenth slice's will both edit `Object/seal@@0000.txt`, on different lines.
- **Memory:** I saved a note on coordinating crank slices and the known sweep and CI noise.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-twelfth-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 234 tokens (14885551 cached reads)
- Output: 45524 tokens
- Cost: $5.278678199999999
- Wall-clock: 6160s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
