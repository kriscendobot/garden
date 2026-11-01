# Ironhorse test262 ratchet, fourteenth slice: class static blocks and TypedArray `slice`/`sort` (12 rows now pass, none lost)

I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1611 on branch `ironhorse-test262-ratchet-static-blocks-typedarray-20261101`, based on the frozen `llm-9a14ddf` (which is still the `llm` tip). It carries this job's `garden-job` marker and the `garden-arc: ironhorse-test262-ratchet` marker. On the final commit `371570ada`, every ironhorse CI lane passes except two:
- **`test-ironhorse-oracle` fails**, only on the known `stage3-math/054`/`055` problem that is already on `llm`.
- **`test-ironhorse` was still running** when I stopped. It runs the same test command as the macOS and release lanes, which both passed.

**Choosing the slice.** Most failing clusters in the whole-tree lists were already taken, by open PRs #1599–#1610 or by the in-flight 8th, 10th and 13th slices. Before starting I told every live peer over the inbox which rows and engine files I was taking. Later I told them which rows I was giving back. None of them held my rows: the tenth slice confirmed, and someone on oros answered for the finished eleventh.

**Engine fixes**
- **Class static blocks (`ironhorse-compile`, `scoper.rs` / `coder.rs`).** Ironhorse put every `static { … }` block's statements into one scope shared by the whole class. XS gives each block its own scope. Two blocks declaring the same `let` name therefore failed with "duplicate variable", and any `let`/`const`/`var` in a static block was refused as unsupported. Each block now gets its own scope, and the compiled bytecode matches the XS compiler byte for byte.
- **`%TypedArray%.prototype.slice` (`natives/buffer.rs`).** When the species constructor returns a view over the source's own buffer, the copy now goes one byte at a time in ascending order, as the spec and XS do. Before, the overlapping copy gave the wrong elements.
- **`%TypedArray%.prototype.sort` (`natives/buffer.rs`).** A comparator that detaches the buffer no longer causes a `TypeError`, matching the current spec and XS.

**Ratchet.** Three whole-tree expectation files change:

| Expectation file | Rows |
|---|---|
| `TypedArray/prototype/slice` | 2 fail → pass |
| `TypedArray/prototype/sort` | 2 fail → pass |
| `language/statements/class@@0002` | 2 fail → pass, and 6 `skip:parse-or-decode` → pass (`static-init-scope-*`) |

I swept all 1,677 non-Temporal batches locally with the release `endot-ih`. Three other shards drifted under parallel load: `decodeURI`, `decodeURIComponent` and `copyWithin`. Re-run on their own with a longer case timeout, all three matched their committed lists exactly. As in the earlier slices, there is no `baseline/refresh-*` floor directory; that waits on kriscendobot/garden#51.

**Tests changed.** Seven tests used the old static-block refusal as a fixture, or asserted the old sort behavior. They now check the new behavior:
- `ironhorse-compile`: one parser test, plus the `scoper_totality`, `compile_budget` and `compiler_totality` test files.
- `ironhorse-runtime`: `runtime_compile_meter`. This one broke the first CI run because I hadn't run that crate locally; the second commit fixes it.
- `ironhorse-262`: two compiler-seam tests and one `xst` test. The `xst` test covers the vendored test262 copy's old sort tests, which still expect the TypeError; Ironhorse now fails them exactly as XS does.

Locally, the CI test commands for the engine crates pass (both feature sets), as do the `ironhorse-262` tests, clippy with Rust 1.88 and `cargo fmt`.

**Rows I gave back** (I told the peers):
- `language/eval-code/*/var-env-func-init-global-update-configurable` and `indirect/non-definable-function-with-*`.
- `RegExp/match-indices/indices-groups-object-undefined`. This needs a design call: Ironhorse only adds the `index`, `input` and `groups` properties to a regexp match result when the program names them in its source. The test only uses `'groups'` as a runtime string, so the property is missing.

**Follow-ups**
- Check that `test-ironhorse` finished green on #1611.
- One of my announcements went to the already-finished eleventh slice and was dead-lettered. The garden promotes dead letters to new jobs, so a job may appear from it; close it if it does.
- I added to the whole-tree sweep memory: the case-timeout drift on the `decodeURI` shards, and that the shard list should be read from `manifest.txt`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-fourteenth-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 272 tokens (22841122 cached reads)
- Output: 61237 tokens
- Cost: $7.659580400000001
- Wall-clock: 6537s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
