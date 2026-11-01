---
posted_at: 2026-11-01T06:54:21Z
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
arc: ironhorse-test262-ratchet
---
Open the draft PR for the RegExp.prototype accessor slice of the Ironhorse test262 ratchet (predecessor job `ironhorse-test262-ratchet-coverage-crank-20261101`). The head is already pushed. Host oros-studio-garden-ce242c49 cannot create PRs on endojs: createPullRequest returns 403 there.

- repo: endojs/endo-but-for-bots
- head: `ironhorse-test262-ratchet-regexp-accessors-20261101` at `2ea087e3a276866534ea3d6f0a51bcf75b7e1fc3`
- base: frozen `llm-9a14ddf` (already on the fork; it is current `llm`)

The only task: confirm the head sha with `git ls-remote`, write the body below (between the BODY markers) to a file, and from an `ensure-project-worktree.sh` checkout of that head run:

```sh
scripts/jobs/gardening/ensure-pr.sh ironhorse-test262-ratchet-coverage-crank-20261101 endojs/endo-but-for-bots \
  ironhorse-test262-ratchet-regexp-accessors-20261101 llm-9a14ddf \
  --title 'fix(ironhorse-vm): install the RegExp.prototype source, flags and flag getters' \
  --body-file <file>
```

Keep the predecessor's job base as the first argument so the PR carries the predecessor's `garden-job` marker. Do not change the code. Report the PR number so completion stages the gauntlet.

-----BEGIN BODY-----
Refs: https://github.com/kriscendobot/garden/issues/51

## Description

A coverage-crank slice of the Ironhorse test262 ratchet: the `%RegExp.prototype%` accessors. In the checked-in whole-tree expectations, the ten `built-ins/RegExp/prototype/<accessor>` shards (`dotAll`, `flags`, `global`, `hasIndices`, `ignoreCase`, `multiline`, `source`, `sticky`, `unicode`, `unicodeSets`) held 172 failing rows (86 cases). That is the largest non-Temporal, non-Intl block of supported failures that no in-flight crank slice touches.

Before this PR, `%RegExp.prototype%` had none of these ten properties. `GET_PROPERTY` answered the names for a RegExp instance straight from the side table. But `Object.getOwnPropertyDescriptor(RegExp.prototype, 'global')` was `undefined`, so a getter could not be extracted or called (every `length`/`name`/`prop-desc`/`this-val-*` case threw `cannot coerce undefined to object`), and `RegExp.prototype.flags` read `undefined`.

**The engine change.** The ten names are now real accessor properties (`{ get, set: undefined, enumerable: false, configurable: true }`), transliterated from XS's `fxBuildRegExp` and `fx_RegExp_prototype_get_*` (`xsRegExp.c`):

- **Flag getters** (`RegExpFlagGetter(bit)`): `undefined` for `%RegExp.prototype%` itself, the flag bit for a RegExp instance, and `TypeError: this: not an object` for anything else, as in `fx_RegExp_prototype_get_flag`.
- **`source`**: `(?:)` for `%RegExp.prototype%`, the escaped pattern for an instance, and a `TypeError` otherwise.
- **`flags`**: accepts any object and reads its eight flag properties in `dgimsuvy` order. XS's order puts `unicodeSets` before `sticky`. The order was already single-sourced and is now shared as `REGEXP_FLAG_PROPERTIES`.

The getters are boot natives pushed onto `proto_accessors` with the `RegExp` guard, like `ArrayBuffer.prototype.byteLength`. They are installed when the program names `RegExp` or the property.

**Fast paths keep their metering.** `regexp_getter_uses_default` used to treat any property on `%RegExp.prototype%` as an override. It now accepts the property when it is still the intrinsic getter for that name (`regexp_proto_accessor_is_intrinsic`). `GET_PROPERTY`, `toString`, the RegExp constructor's copy path and the `@@replace` fast-path check therefore still read the side table directly. Two observable fixes come with this:

- `GET_PROPERTY` used to short-circuit `re.global` and the others even when the instance or the prototype had replaced the getter. It now calls the override.
- `re.flags` used to return the compiled flag string even when one flag property was overridden. It now goes through the same per-flag reads as the getter.

**Remaining departure (pinned).** The accessors are installed only for a program that names them, so an absent one cannot be told apart from a deleted one. After `delete RegExp.prototype.global`, a read of `/a/g.global` still takes the side table (`true`, where XS gives `undefined`). This was already the behavior before this PR. It is now a `GAPS` row in `xs_departures.rs` rather than an unrecorded difference. Closing it would mean installing the accessors on every link, which would change every program's boot heap and is a separate decision.

**The ratchet.** I re-measured `built-ins/RegExp`, `built-ins/String`, `annexB`, `language/literals/regexp` and `built-ins/Symbol` against the pinned test262 (`be13516`). Only the ten accessor shards changed, and none lost coverage:

| | before | after |
| --- | --- | --- |
| `fail` rows in the ten shards | 172 | 0 |
| `pass` | — | +154 (77 cases × 2 modes) |
| `skip:shared-positive-test-failure` | — | +18 (the nine `cross-realm.js` cases, which XS also fails) |

The whole-tree totals move from 77067 pass / 2056 fail to 77221 pass / 1884 fail. `built-ins/RegExp/prototype` now reports `ironhorse-failures=0`.

The same change lets `test/intrinsics/RegExpPrototype/intrinsic-metadata.js` pass in the `ironhorse` `sloppy`, `strict`, `lockdownSloppy` and `lockdownStrict` hardened262 scenarios. I moved it to `passed.txt` there, from a `scripts/test.js --report` run of that file. The compartment, module and `sesIronhorse` scenarios still fail it.

**Pins that moved with it.**

- `intrinsic_key_order.rs`: the `RegExp.prototype` row of `KEY_SET_DIFFERENCES` is gone. The ten keys already sat at their XS positions in `intrinsic_order.rs`.
- `xs_departures.rs`: the two `GAPS` rows for the missing accessors are removed, and the deletion row above is added.
- Ten boot natives join the heap. That moves the snapshot goldens (`state_golden*.tsv`, `math-platform-boot.bin`), the `metamorphic_determinism` hashes for both math arms, the epoch-3 geometry (1100 → 1110 slots) and the regenerated `snapshot_decoder` fuzz seeds. Each was regenerated with its own tool (`regenerate_persistence_identities` under both providers, `write-seed-corpus`). The format version is unchanged.

**Overlap with open slices.** #1602 also adds boot natives, so it moves the same golden fixtures, metamorphic hashes and fuzz seeds. Whichever lands second regenerates them; the source changes don't overlap.

### Security Considerations

None. The getters read only the receiver's own RegExp record or its ordinary flag properties, and grant no new authority.

### Scaling Considerations

Ten more boot functions in every realm (1100 → 1110 epoch-3 slots). The intrinsic fast paths, and their metering, are unchanged.

### Documentation Considerations

None. This closes a conformance gap with XS.

### Testing Considerations

- New `ironhorse-262/tests/regexp_prototype_accessors.rs` dual-runs against XS: the descriptor shape and getter `name`/`length`, instance and prototype receivers, rejected receivers, `flags` on a plain object (read order logged), and own and replaced getters reaching reads, `flags`, `toString`, `replace` and `new RegExp`. Every case failed before this change. The own-`global` override case also failed until the `re.flags` fix.
- `cargo test --release -p ironhorse-vm -p ironhorse-262 -p ironhorse-snapshot -p ironhorse-fuzz`, plus `ironhorse-snapshot` with `ironhorse-vm/deterministic-math`: all green.
- `full-run.sh --update-expectations-dir` over the subtrees above. The regenerated shards match the committed ones.
- `cargo fmt --check` and `cargo clippy -D warnings` (1.88, library targets).

### Compatibility Considerations

This is guest-visible: ten new configurable accessors on `%RegExp.prototype%`, matching XS. Persisted images from before this change still restore, because the format is unchanged. The boot heap moves, so the golden digests moved with it.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
-----END BODY-----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-01T07:24:06Z
