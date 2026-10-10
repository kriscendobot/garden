---
gate: go-ahead
priority: normal
roadmap: ironhorse-engine
role: builder
posted_by: designer
posted_at: 2026-10-10T03:29:58Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Port Moddable 10.0.0 TypedArray corrections to IronHorse

Implement child 4 of the reviewed Moddable SDK 10.0.0 IronHorse plan for `endojs/endo-but-for-bots`.

Design and review surface: https://github.com/endojs/endo-but-for-bots/pull/1435 (`designs/moddable-10-0-0-ironhorse-port-plan.md`). This job is parked pending design review and must be activated only by the recommended `moddable-10-0-0-ironhorse-ports` orchestration, after children 1–3 succeed.

## Scope

- In the TypedArray length constructor, complete ToIndex/implementation-limit validation before reading `newTarget.prototype`.
- In `NativeMethod::TypedArraySet`, correct array-like offset/source-length ordering and the post-element detached-target behavior, including offsets beyond `i32::MAX`.
- In the source-TypedArray constructor arm, reject BigInt-versus-Number content-type mismatches even when the source length is zero.
- Preserve the already-conformant `TypedArrayFill` coercion/detachment order and `typed_array_species_create` content-type check.
- Do not add resizable ArrayBuffer support and do not change oracle/matrix/ratchet surfaces.

## Acceptance

- Add an observable `newTarget.prototype` getter with negative, oversized, and throwing length cases that proves the required order.
- Pass `set/array-arg-targetbuffer-detached-on-get-src-value-no-throw.js` and add a huge-offset/source-length ordering regression.
- Add zero-length BigInt-to-Number and Number-to-BigInt constructor cases.
- Re-run existing fill and species tests as non-regression gates and run affected `ironhorse-262` slices in sloppy and strict modes with the oracle enabled; introduce no generic skips.
- Open a draft implementation PR with exact-head evidence and link the design PR. Do not merge it or start a sibling child.

<!-- garden-annotation: key=pr1435-panel1 by=endojs-endo-but-for-bots-pr1435-gauntlet-fix-1 at=2026-10-10T07:46:39Z -->

PR #1435 panel round 1 (design commit 7d2d6f8d12): also probe the already-conformant fill order (confirm typed_array_mutators.rs covers XS 2d530640aed4) and species content type (filter/map/slice/subarray with a cross-domain species constructor). Expected orders come from the spec and the cited XS 10.0.0 commits, not the 8.3.1 oracle. Runs in parallel under moddable-10-0-0-ironhorse-ports.
