---
role: builder
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-07-08T01:54:23Z -->

Bump the endor-oracle `c/moddable` pin from 8.2.3 (`48ee02d8cfe0`) to 8.3.1
(`23b4d6b0a65f`) and mirror the post-8.2.3 engine-relevant deltas onto the
oracle-locked Rust port (endojs/endo-but-for-bots, branch `xs2rust-endor`,
`rust/engine`). Read-only on Moddable upstream and endo; experiment only on
the bot fork; no upstream PRs or comments.

Context and rationale: `rust/engine/README.md` § "Upstream moddable delta
tracking (oracle 8.2.3 → public 8.3.1)" (landed by
project-xs-changes-to-endor-23b4d6b0). The port is byte-identity /
four-valued differential against the oracle, so these behaviors CANNOT be
implemented against the current 8.2.3 oracle without breaking the bar — the
oracle must move to 8.3.1 first, then each surface is mirrored and re-measured.

Step 1 — bump the oracle pin. Update `rust/engine/README.md` § "Building the
oracle" and `designs/xs2rust-endor-engine.md` § Ground Truth from
`48ee02d8cfe0` to `23b4d6b0a65f`, and re-run the full byte-identity /
differential bar (`compile-diff` per subtree; the stage corpora). Expect and
attribute any byte deltas the 8.2.3→8.3.1 range introduces for
already-ported constructs. This is a deliberate re-base of the whole bar and
is the gate for everything below.

Step 2 — mirror the post-8.2.3 deltas as the surfaces exist (cite the sha +
file in each commit):
- Item 2 (surgical, surface exists now): `for await` in a module body sets
  `parser->flags |= mxAwaitingFlag` — moddable 8.3 `c41a35d165`
  (xsSyntaxical.c). In the port add `self.flags |= flags::AWAITING;` in the
  `await_flag` branch of `for_statement` (endor-compile/src/parser/stmt.rs;
  a fold note is already at that site).
- Item 1: explicit-resource-management module-body coding refinement
  `f3c53dc018` (xsCode.c, xsScope.c) + compatible mode `a3a4761939`
  (xsAPI.c, xsCommon.h, xsError.c). Parser/scoper/coder already carry
  Using/XS_CODE_USING(_ASYNC)/DISPOSABLE; the runtime Symbol.dispose /
  Symbol.asyncDispose + DisposableStack/AsyncDisposableStack + scope-exit/
  throw disposal ordering (incl. AsyncDisposableStack null/undefined await
  step `cf5603f0b2`, already in-oracle) land with the VM stage that reaches
  disposal.
- Item 3: immutable ArrayBuffer proposal conformance `0e1c47d81f` (xsAll.h,
  xsAtomics.c, xsCommon.{c,h}, xsDataView.c, xsSnapshot.c) — carry the
  immutability flag + conformance across DataView/Atomics/snapshot; lands
  with the VM buffer stage.
- Item 5: `Array.from`/`Array.fromAsync` don't throw on `undefined` mapFn
  `d8baa8cdf7` (xsArray.c) — mapFn used only when arg present AND not
  undefined (undefined ⇒ identity); honor when these statics leave named-skip.
- Item 6: private property defined in a module namespace object `a3da68e484`
  (xsAll.h, xsModule.c, xsProperty.c) — fxDefine/Get/SetPrivateProperty
  redirect a module instance to mxModuleInstanceExports(instance)->value.
  reference; mirror in the port's private-property path.
- Item 8 (optional): `String.prototype.trim` fast path `f5615ff3fb`
  (xsString.c) — behavior-neutral; mirror only if trim internals are tracked.

Already handled at 8.2.3 (do NOT redo): item 4 transfer* drops @@species
(36aa1485a4, eff30ae5ba) — auto-inherits (named skip today); item 7 native
stack overflow as host abort not JS RangeError (bc5a1ecfdb + parser-stack
82e80152a3/ebc286a46c/da87ebd954) — already mirrored (Halt::StackOverflow).

Several item surfaces (ArrayBuffer/DataView runtime, Array.from, disposal
protocol) are not yet reached by the port's staging; those sub-items are
naturally deferred to the stage that ports them, but must be measured against
the 8.3.1 oracle from that point on. Update the README delta-tracking table as
each item flips from follow-up to mirrored.
