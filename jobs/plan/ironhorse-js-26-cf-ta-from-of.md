---
gate: orchestrated
orchestrated_by: ironhorse-js-26-cf-ta-residual-orch
priority: normal
posted_by: gardener
posted_at: 2026-08-15T01:32:19Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# js-26 cf: TypedArray.from / TypedArray.of + from-object construction protocol

**Scope:** `built-ins/TypedArrayConstructors/from/**` (59), `.../of/**` (27), and the array-like/iterable
first-argument construction path of `.../ctors/object-arg/**` (`new TA(arrayLike|iterable)`).

**Residual (branch tip `89fddc894`, oracle-gated):** `from` 15/59, `of` 12/27; `ctors/object-arg` mostly
`native-call:TypedArray:from-object` (26 across the subtree) + `Array.from:iterator-protocol-metering` (17).

**Engine sites:** the `Native::TypedArray(idx)` ctor arm in interp.rs currently self-names
`native-call:TypedArray:from-object` for any object source that is not a dense Array or source TypedArray.
Close the general **from-object protocol**: (a) if the source has a callable `Symbol.iterator`, drive the
iterator protocol (IteratorToList) and copy; (b) else the array-like path — `ToLength(src.length)`, then
`src[i]` for each i, coerced to the destination element type. `%TypedArray%.from`/`.of` are the static
factories over the same element-set path. This depends on the **iterator-protocol metering** gap
(`Array.from:iterator-protocol-metering`) and the **element-set coercion** path
(`typed-array-set:coerce`/`bigint-coerce`) shared with `ironhorse-js-26-cf-ta-exotic-internals` — land or
coordinate that dependency first. Reuse the parent's dense-array copy in the ctor arm as the fast path.

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
