---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-15T01:34:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# js-26 cf: TypedArray integer-indexed exotic internals

**Scope:** `built-ins/TypedArrayConstructors/internals/**` (~238 cases). The integer-indexed
exotic-object internal methods on a TypedArray instance: `[[DefineOwnProperty]]`, `[[GetOwnProperty]]`,
`[[Get]]`, `[[Set]]`, `[[HasProperty]]`, `[[OwnPropertyKeys]]`, `[[PreventExtensions]]`, `[[IsExtensible]]`.

**Residual (measured on branch tip `89fddc894`, oracle-gated):** the `internals` slice is 2/240 covered.
Blocking opcodes are `defineProperty:exotic-object` (38), `getOwnPropertyDescriptor:exotic-object` (22),
`Reflect.set:exotic-object` (21), `Reflect.has:exotic-object` (20), `Reflect.ownKeys:exotic-object` (6),
`isExtensible:exotic-object` (8), `preventExtensions:exotic-object` (8), `typed-array-set:bigint-coerce`
(25), `typed-array-set:coerce` (9), plus ~56 generic `ironhorse-aborted` + ~47 `abort-value-differs` that
resolve once the exotic MOP + element-coercion path lands.

**Engine sites:** the property MOP dispatch in interp.rs (`defineProperty`/`getOwnPropertyDescriptor`/
`Reflect.*` arms that self-name `:exotic-object`) must route a canonical-numeric-string key on a
`typed_arrays` instance through the integer-indexed element behavior (CanonicalNumericIndexString →
IsValidIntegerIndex → element get/set with the destination-type coercion, incl. BigInt for
BigInt64/BigUint64). The `typed-array-set:*` element-set coercion (valueOf/ToNumber/ToBigInt) is shared
with the from-object protocol (sibling `ironhorse-js-26-cf-ta-from-of`).

This is a distinct cluster from the constructor forms (a general exotic-object-model surface), split out
of the parent per the ctor-arm child's handoff.

**Shared branch/PR (do not create a new one):** `feat/ironhorse-262-language-completion`
(PR endojs/endo-but-for-bots#970 — OPEN draft, keep open, do NOT merge). Fetch+preserve prior
commits, stack bounded commits, push with a rebase CAS loop. Serial orchestration — fetch+rebase before push.

**Pins:** engine head is the current branch tip (as of handoff `89fddc894`, which built on
`b3c3ae93` + the parent ArrayBuffer close `1c41b9a61` + a peer's eval/typeof-unresolvable close
`0094e4ca9` + this child's ctor-arm close). test262 `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`;
XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (`git submodule update --init --depth 1 c/moddable`).
PATH: prepend `$HOME/.cargo/bin`; TMPDIR off noexec. Cached test262 at pin:
`/home/kris/garden/scratch/test262-pin-be13516f` (`--test262-dir … --no-fetch`).

**Acceptance bar:** convert cases to **covered** via real execution against the XS differential oracle
(`rust/engine/ironhorse-262/scripts/full-run.sh --subtree <PREFIX> --test262-dir <pin>`), except a
specifically justified standards-grounded host-only/proposal exclusion. Add focused Rust regression
tests under `rust/engine/ironhorse-262/tests/`. Do NOT relabel/suppress/skip-list.

**Regression invariant:** no covered case in `baseline/baseline.json` regresses; exact-metering corpus
stays green (`ironhorse-xst --gate-meter-exact rust/engine/ironhorse-262/cases` + `cargo test --workspace
--release`). Run the affected slice + these gates before EVERY push. Keep the integer/number fast paths
inline so meter-exact stays 1712/1712.

Repository: `endojs/endo-but-for-bots`. issue_spine: issue-kriscendobot-garden-51
Part of the js-26 TypedArray/ArrayBuffer residual-closure effort; sibling to the landed ctor-arm child
`ironhorse-js-26-cf-ta-ctor` (which closed the `new TA(length|buffer,offset,length)` forms, ToIndex
coercion, catchable RangeError/TypeError, newless TypeError, and BYTES_PER_ELEMENT — 48→245 covered on
`built-ins/TypedArrayConstructors`).

<!-- garden-provider-quota-backoff: type=session reset-at=2026-08-15T03:30:00Z -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-15T01:44:41Z
