---
gate: orchestrated
orchestrated_by: ironhorse-js-26-cf-ta-residual-orch
priority: normal
posted_by: gardener
posted_at: 2026-08-15T01:32:24Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# js-26 cf: native lazily-bound data-property descriptors + writability

**Scope:** the `verifyProperty`/`verifyNotWritable`/`verifyNotEnumerable`/`verifyNotConfigurable`
descriptor surface over the TypedArray boot data properties: the per-type
`built-ins/TypedArrayConstructors/<Type>/{BYTES_PER_ELEMENT,name,length,proto}.js` (~6 aborted per type ×
11 = ~66) and the descriptor-shaped `prototype` cases.

**Root cause (general, pre-existing — NOT TypedArray-specific):** ironhorse's lazily-bound native data
properties (`proto_value_data`, e.g. `<TA>.BYTES_PER_ELEMENT` — added by the ctor-arm child — but ALSO
`Number.MAX_VALUE`, `Math.PI`, function `name`/`length`) materialize on a plain read but
`Object.getOwnPropertyDescriptor(Ctor, 'BYTES_PER_ELEMENT')` returns `{value:undefined,...}` and a write
is not rejected. Verify by probe: `Object.getOwnPropertyDescriptor(Number,'MAX_VALUE')` reads back
`,,,` on ironhorse vs `1.79e308,false,false,false` on the oracle; `Uint8Array.BYTES_PER_ELEMENT=5`
mutates instead of being non-writable.

**Engine sites:** the `proto_value_data`/`proto_methods` link-time materialization + the
`getOwnPropertyDescriptor`/`defineProperty`/write MOP must expose these as real own data properties with
their correct `{writable,enumerable,configurable}` attributes (non-writable/non-enumerable for constants;
`configurable:true` for ctor `name`/`length`). Fixing this closes the per-type descriptor cases across the
whole engine, not just TypedArray — coordinate as a general built-ins-Object surface.

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
