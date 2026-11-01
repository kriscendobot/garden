---
posted_at: 2026-11-01T09:35:07Z
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
arc: ironhorse-test262-ratchet
---
Open the draft PR for the ninth coverage-crank slice of the Ironhorse test262 ratchet: the global object's [[Prototype]] (predecessor job `ironhorse-test262-ratchet-coverage-crank-ninth-slice-20261101`). The head is already pushed. Host oros-studio-garden-ce242c49 cannot create PRs on endojs: createPullRequest returns 403 there.

- repo: endojs/endo-but-for-bots
- head: `ironhorse-test262-ratchet-global-object-proto-20261101` at `9ab51376c48568f42a3487f8accbce7f64020858`
- base: frozen `llm-9a14ddf` (already on the fork; it is current `llm`)

The only task: confirm the head sha with `git ls-remote`, write the body below (between the BODY markers) to a file, and from an `ensure-project-worktree.sh` checkout of that head run:

```sh
scripts/jobs/gardening/ensure-pr.sh ironhorse-test262-ratchet-coverage-crank-ninth-slice-20261101 endojs/endo-but-for-bots \
  ironhorse-test262-ratchet-global-object-proto-20261101 llm-9a14ddf \
  --title 'fix(ironhorse-vm): the global object inherits from %Object.prototype%' \
  --body-file <file>
```

Keep the predecessor's job base as the first argument so the PR carries the predecessor's `garden-job` marker. Do not change the code. The body already passes ensure-pr's template check. Report the PR number so completion stages the gauntlet.

-----BEGIN BODY-----
Refs: https://github.com/kriscendobot/garden/issues/51

## Description

The ninth coverage-crank slice of the Ironhorse test262 ratchet: the global object's `[[Prototype]]`.

**Why this slice.** I grouped the failing rows in the committed `expectations/whole-tree` shards. I left out Temporal (host-excluded), Intl (the pinned XS has no ECMA-402 host) and every in-flight crank slice (#1599–#1605). I first looked at destructuring assignment into a `const` (`for-of/dstr/*-put-const.js`, `assignment/dstr/*-put-const.js`, 20 rows). Those turn out to be an **XS oracle defect**: XS never throws when destructuring writes to a `const`, in any scope, while Ironhorse follows the spec. The runner deliberately keeps oracle-only failures as baselined `fail` rows (`assembled_typed_array_oracle_failures_remain_baselinable_failures`, `source_fragments_cannot_attribute_oracle_failures`), so that cluster is not crankable and I left it alone. The next coherent Ironhorse-side cluster was the known architecture-review gap CORE-4 / PROP-7.

**The defect.** The default global and every `Compartment` global were allocated with a null `[[Prototype]]`. ECMA-262 `SetRealmGlobalObject` creates the global with `OrdinaryObjectCreate(%Object.prototype%)`. XS builds the machine's global (`fxCreateMachine`) and each compartment's global (`fx_Compartment`) over `mxObjectPrototype`. As a result:
- `this.propertyIsEnumerable('parseInt')` in global code threw `call: not a function`;
- `globalThis instanceof Object` was `false`;
- `Object.getPrototypeOf(Object.getPrototypeOf(this))` threw `cannot coerce null to object`.

**The engine change** (`ironhorse-vm`):
- **Boot.** `create_intrinsics` links the global to `%Object.prototype%` as soon as that object exists. The global itself is allocated earlier, so it can't be linked at allocation.
- **Compartments.** `create_environment` allocates each compartment global over `%Object.prototype%`.
- **Bare-name resolution.** Name lookup used to stand in for the missing link by asking `%Object.prototype%` directly. Both the `GET_VARIABLE` read and the `SET_VARIABLE` strict-unresolvable guard now ask the global's *actual* `[[Prototype]]` (`Interp::global_inherits`). A program that replaces the global's prototype, or sets it to `null`, therefore gets the same resolution XS gives. For the default prototype the behavior and metering are unchanged.

**Ratchet.** I ran a whole-tree sweep (`full-run.sh --update-expectations-dir`, all 1,930 batches, pinned test262 `be13516f`) and compared it with the committed shards:
- **18 case/mode rows go fail → pass, across 10 shards:**
  - the `A*.5` enumerability checks of `parseInt`, `parseFloat`, `decodeURI`, `decodeURIComponent`, `encodeURI` and `encodeURIComponent` (12 rows);
  - `Object/getPrototypeOf/15.2.3.2-2-30.js` (2);
  - `Object/defineProperty/15.2.3.6-4-625gs.js` sloppy (1);
  - `language/global-code/decl-lex.js` (2);
  - `language/statements/function/S13.2.2_A19_T7.js` (1).
- **1 row goes fail → `skip:oracle-xs-script-decl-eval-framing`:** `15.2.3.6-4-625gs.js` strict. This is the existing, precise exclusion for the oracle shim's eval framing of a strict Script.
- **No row regresses.**
- **One unrelated drift, not committed.** `language/module-code/namespace/internals/own-property-keys-sort.js` changes skip reason (`unsupported-opcode:module:static-linking` → `module:compiler-byte-divergence`). Base builds without this change report the same, so the committed shard was already stale, and this PR doesn't touch it.
- **No floor directory.** As in #1599–#1605, I didn't create a `baseline/refresh-*` floor directory; the open question on kriscendobot/garden#51 governs that.

**Pinned artifacts.** One boot slot's prototype changes, which moves the boot heap. I regenerated:
- the `state_golden*` fixtures and `math-platform-boot.bin`, under both math providers;
- the `metamorphic_determinism` hashes (both arms);
- the fuzz seed corpus (`write-seed-corpus`).

The snapshot format is unchanged.

**Tests.**
- **New.** `ironhorse-262/tests/global_object_prototype.rs` has three tests, each checking agreement with XS: the default global's prototype, a compartment global's prototype, and bare names resolving through a replaced or nulled global prototype (read, strict store to an inherited name, strict store with no prototype).
- **Local runs, all passing:**
  - `cargo test --release` for `ironhorse-vm`, `ironhorse-snapshot`, `ironhorse-fuzz`, `ironhorse-runtime`, `ironhorse-compile` and `ironhorse-262` (with its `try.txt`/`ironhorse.txt` expectation gates);
  - `ironhorse-vm` and `ironhorse-snapshot` again under `--features ironhorse-vm/deterministic-math`;
  - `cargo fmt --check`;
  - clippy on 1.88.0 (`-p ironhorse-vm -p ironhorse-262 -- -D warnings`), the way CI runs it.

**Follow-ups, not in this PR.**
- **`@@toStringTag`.** XS's global reports `String(globalThis)` as `[object global]`; Ironhorse now gives `[object Object]`.
- **Fixture conflicts.** #1599, #1600, #1602, #1604 and #1605 also move the boot-heap fixtures, so whichever lands later regenerates the goldens, the metamorphic hashes and the fuzz seeds. The expectation shards don't overlap.
- **Remaining failures in nearby rows.** `built-ins/global/global-object.js` strict, `built-ins/undefined/15.1.1.3-2.js` strict and `Object/getOwnPropertyDescriptor/15.2.3.3-4-{109,212..215}` still fail, for unrelated reasons.

### Security Considerations

A compartment global now inherits from the shared `%Object.prototype%`, as it does in XS and in SES. Every compartment already shares that intrinsic, and `lockdown()` freezes it, so no new authority is reachable: only the intrinsic's existing methods become visible through `globalThis` and bare names. A program that replaces its own global's prototype affects only its own name resolution.

### Scaling Considerations

None. One boot slot's prototype field changes. Name lookup asks the same object it asked before, unless a program replaced the global's prototype.

### Documentation Considerations

None for users; this closes a recorded departure from the spec and from XS (architecture review CORE-4 / PROP-7).

### Testing Considerations

New dual-run tests in `ironhorse-262/tests/global_object_prototype.rs`, the regenerated whole-tree shards, and the regenerated snapshot goldens, metamorphic hashes and fuzz seeds. See **Tests** above.

### Compatibility Considerations

Programs now see `Object.prototype` methods on `globalThis`, as on every other engine. A program that relied on `Object.getPrototypeOf(globalThis) === null` sees a change. Existing snapshot images keep their recorded global prototype; only fresh boots change.

### Upgrade Considerations

None. The snapshot format version is unchanged.

<!-- garden-arc: ironhorse-test262-ratchet -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
-----END BODY-----
