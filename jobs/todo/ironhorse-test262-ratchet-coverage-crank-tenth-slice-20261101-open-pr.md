---
posted_at: 2026-11-01T14:47:04Z
arc: ironhorse-test262-ratchet
role: builder
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
Open the DRAFT PR for the tenth Ironhorse test262 ratchet slice on endojs/endo-but-for-bots. Host oros-studio-garden-ce242c49 gets a 403 on createPullRequest. The head is already pushed, so change no code and push nothing.

- Head branch: `ironhorse-test262-ratchet-strict-store-wrappers-20261101`, expected at `80d33e0e32cc9ef4b7b33c286c6b5c5065aae7bc`. Verify this with `git ls-remote` before opening.
- Base branch: the frozen `llm-9a14ddf`, which is also the tip of `llm` at `9a14ddf660912ed624e2d9047671d43e3a2f0cec`.
- Get an isolated checkout of the head with `ensure-project-worktree.sh`. From that checkout, run `ensure-pr.sh` with the PREDECESSOR's base as its first argument, so the PR carries that job's marker:

  `ensure-pr.sh ironhorse-test262-ratchet-coverage-crank-tenth-slice-20261101 endojs/endo-but-for-bots ironhorse-test262-ratchet-strict-store-wrappers-20261101 llm-9a14ddf --title "fix(ironhorse-vm): strict computed-key store rejection, String wrapper integrity, dynamic-function prototype attributes (test262 ratchet)" --body-file <file>`

- `<file>` is a file holding exactly the PR body between the BEGIN/END markers below. It already passed the template check.
- Report the PR number. The PR stays a draft.

----- BEGIN PR BODY -----
Refs: endojs/endo-but-for-bots#1603

## Description

Tenth slice of the Ironhorse test262 ratchet: 15 failing rows across `built-ins/{Object,String,undefined,GeneratorFunction,AsyncGeneratorFunction}` now pass, and a re-sweep of every non-Temporal subtree lost nothing.

**Engine fixes** (`rust/engine/ironhorse-vm`):

- **Strict computed-key store.** In strict code, `o[k] = v` ignored a `false` from `[[Set]]` (a non-writable or frozen property, a new key on a non-extensible object, an inherited getter-only accessor). Both affected sites in `property_at_set` (`interp/property.rs`), the named-key path and the TypedArray named-key path, discarded the result with `let _ =`. They now throw a TypeError, as PutValue step 3.e requires. This matches the named `o.k = v` path and XS. Sloppy code still ignores the failed store.
- **String wrapper `length`.** `delete s.length` on a String wrapper answered `true`, and on a string primitive it did the same. The named `delete` opcode now refuses the non-configurable String-exotic `length` (and units), and throws in strict code, as `mop_delete` / `Reflect.deleteProperty` and XS's `fxStringDeleteProperty` already do.
- **`new String(symbol)`** now throws a TypeError. Only the call form `String(sym)` uses SymbolDescriptiveString (ECMA-262 22.1.1.1).
- **Dynamic-function prototype attributes** (`interp/link.rs`). `constructor` on `%GeneratorFunction.prototype%`, `%AsyncGeneratorFunction.prototype%` and `%AsyncFunction.prototype%` is now non-writable and configurable. `%AsyncGeneratorFunction.prototype%.prototype` is now configurable. This matches ECMA-262 27.3.3, 27.4.3 and 27.7.3, and XS (`slot->flag |= XS_DONT_SET_FLAG` in `fxBuildGenerator` / `fxBuildFunction`).

**Ratchet.**

Rows that went from fail to pass (15):
- `built-ins/Object/{defineProperty/symbol-data-property-default-strict, freeze/frozen-object-contains-symbol-properties-strict, seal/symbol-object-contains-symbol-properties-strict, preventExtensions/symbol-object-contains-symbol-properties-strict}.js` (strict)
- `built-ins/undefined/15.1.1.3-2.js` (strict)
- `built-ins/String/{S15.5.5.1_A3, symbol-wrapping}.js` (both modes)
- `built-ins/GeneratorFunction/prototype/constructor.js` and `built-ins/AsyncGeneratorFunction/prototype/{constructor,prototype}.js` (both modes)

One unrelated row changed its skip reason: `language/module-code/namespace/internals/own-property-keys-sort.js` sloppy went from `skip:unsupported-opcode:module:static-linking` to `skip:module:compiler-byte-divergence`. It reproduces deterministically. This PR touches no compiler code, and that shard predates later compiler and runner commits on `llm` (6223ef7f6, 17c9d7a3b). So it is most likely stale on `llm` already, but I did not confirm that with a base sweep. I recorded the observed value.

I updated nine shards under `expectations/whole-tree`. I did not create a `baseline/refresh-*` floor directory: the open floor-resolution question on kriscendobot/garden#51 governs that.

**Golden re-pins.** The flag change moves the linked heap. I regenerated `state_golden` under both math providers and re-pinned the five metamorphic markers and both blob arms in `metamorphic_determinism.rs`. The fuzz seed corpus is unchanged. Format and geometry are unchanged.

**Not in this slice:**

- `language/{expressions/assignment,statements/for-of}/dstr/*-put-const.js` (20 rows) and `annexB/language/statements/try/catch-redeclared-*` (10 rows) are XS oracle defects. Ironhorse is spec-correct there; the ratchet reports them as over-acceptance because XS rejects them.
- `Math.random` is omitted by design and is waiting on an explicit decision.

Overlap: #1602 and #1605 also move the snapshot goldens, so whichever PR lands second has to regenerate them.

### Security Considerations

None new. Strict code now throws where the spec requires a rejected store or delete to throw. Before, Ironhorse silently ignored the failure, which a hardened program relying on frozen objects could not detect.

### Scaling Considerations

None. Each fix adds one branch to a path that was already taken.

### Documentation Considerations

None. This change brings Ironhorse into line with ECMA-262 and XS.

### Testing Considerations

`ironhorse-262/tests/strict_store_and_wrapper_integrity.rs` runs every case on both Ironhorse and XS and requires them to agree. Four of its five tests fail without the engine change. The fifth, a sloppy-mode control, passes either way.

Checked locally:

- **Whole-tree re-sweep:** every non-Temporal subtree (`built-ins/*`, `annexB`, `language`, `intl402/*`) against the pinned test262 `be13516f`. The only drifts were the 15 fixes and the module row above.
- **Gates:** `try.txt`, and `ironhorse.txt` with `--repeat 3`.
- **Test suites:**
  - `ironhorse-snapshot`, plain and with `deterministic-math,store-integrity`
  - `ironhorse-vm` with `deterministic-math,store-integrity`
  - `ironhorse-262` and `ironhorse-fuzz`
- **Formatting:** `cargo fmt --check`.

### Compatibility Considerations

Guest code that relied on a strict `o[k] = v` silently failing, on `delete s.length` answering `true`, or on overwriting a dynamic-function prototype's `constructor` now behaves as the spec says.

### Upgrade Considerations

Snapshot goldens move, because the boot property flags changed; the format version is unchanged.

<!-- garden-arc: ironhorse-test262-ratchet -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)

----- END PR BODY -----
