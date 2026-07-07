Project engine-relevant XS/Moddable upstream changes onto the Rust port (project
xs2rust-endor). This is a PROJECTION job: read the named XS commits, decide what
each implies for the Rust reimplementation's fidelity, and land the corresponding
port work (or file precise follow-up sub-jobs per change). Read-only on Moddable
upstream and endo; experiment only on bot forks; no upstream PRs or comments.

## Synchronization baseline

- endo (endojs/endo-but-for-bots `llm`) vendors the `c/moddable` submodule pinned
  at `5516726818906190d3a042d8be90219ce9d51b45` = **moddable 8.0.1** (2026-04-22,
  "version bump 8.0.1").
- Upstream `Moddable-OpenSource/moddable` branch `public` HEAD is
  `23b4d6b0a65f` = **8.3.1** (2026-07-07).
- Range: 8.0.1 → 8.3.1 (intermediate version bumps 8.1.0, 8.2.2, 8.2.3, 8.3),
  331 commits total; the engine-relevant subset is below.

## Engine-relevant XS changes to mirror (semantics the Rust port reimplements)

Filtered to commits touching `xs/sources` / `xs/includes` that change JS
engine semantics (interpreter, bytecode/compiler, GC/stack, parser/lexer,
value/typed-array/buffer handling). FFI, Pebble-platform, host-buffer-compat, and
compiler-appeasement churn is deliberately excluded as not engine-semantics.

1. **Explicit Resource Management (`using` / `await using`, DisposableStack /
   AsyncDisposableStack)** — the biggest semantic addition.
   - `f3c53dc018` XS: explicit resource management — module body (`xsCode.c`,
     `xsScope.c`): scoping + bytecode for `using`/`await using` declarations.
   - `a3a4761939` XS: explicit resource management — compatible mode.
   - `cf5603f0b2` XS: AsyncDisposableStack use null or undefined await step.
   Implies: the port's parser/scoper/coder and runtime need `using`/`await using`
   declaration handling and the Disposable/AsyncDisposableStack protocol
   (Symbol.dispose / Symbol.asyncDispose, disposal order on scope exit / throw).

2. **Top-level / module-body `for await`** — `c41a35d165` (`xsSyntaxical.c`):
   parser accepts `for await` in a module body. Port's parser must mirror.

3. **Immutable ArrayBuffer proposal conformance** — `0e1c47d81f` (`xsAll.h`,
   `xsAtomics.c`, `xsCommon.c/.h`, `xsDataView.c`, `xsSnapshot.c`): immutable
   ArrayBuffer semantics across DataView/Atomics/snapshot. Port's buffer/typed-
   array layer must reflect immutability flags and the conformance behavior.

4. **ArrayBuffer.prototype.transfer* do not use species constructor** —
   `36aa1485a4` + `eff30ae5ba` (`xsDataView.c`): `transfer`/`transferToFixedLength`
   no longer consult `@@species`. Port must match (no species lookup, fixed ctor).

5. **Array.from / Array.fromAsync don't throw on undefined mapper (#1645)** —
   `d8baa8cdf7` (`xsArray.c`): undefined mapFn is allowed (treated as identity).
   Port's Array.from/fromAsync must not throw on `undefined`.

6. **Private property defined in module namespace object** — `a3da68e484`
   (`xsAll.h`, `xsModule.c`, `xsProperty.c`): private-field semantics interacting
   with module namespace exotic objects.

7. **Native stack overflow reported natively, not as JS (#1635) + parser stack
   handling** — `bc5a1ecfdb` (`xsMemory.c`), `82e80152a3` "more stack margin",
   `ebc286a46c` "one more parser stack check", `da87ebd954` "combine parser chunks
   to reduce overhead" (`xsSyntaxical.c`). Implies: stack-depth guards and the
   RangeError-vs-native-crash boundary the port must replicate for deep recursion /
   deeply nested source; relevant to the port's known deep-nesting / overflow
   fuzz work.

8. **String.prototype.trim optimization** — `f5615ff3fb` (`xsString.c`):
   behavior-neutral fast path; low priority, mirror only if the port tracks
   trim internals.

## Deliverable

For each of items 1–7 (item 8 optional), determine whether xs2rust-endor already
mirrors the new behavior; where it does not, implement it or post a precisely
scoped child build/fix job. Cite the specific XS commit sha(s) and file(s) above
in whatever port changes or child jobs you create. Bump the port's recorded
moddable baseline note toward `23b4d6b0a65f` (8.3.1) only once the engine-relevant
deltas are actually mirrored (or explicitly tracked as follow-ups) — do not bump
the baseline while gaps remain unaddressed.

Basename is keyed by the upstream target sha `23b4d6b0` so next week's watch
(against a newer `public` HEAD) will not duplicate this projection.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 15
  claimed_at: 2026-07-07T22:53:35Z
