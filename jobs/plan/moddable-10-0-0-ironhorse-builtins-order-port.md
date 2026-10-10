---
gate: go-ahead
priority: normal
roadmap: ironhorse-engine
role: builder
posted_by: designer
posted_at: 2026-10-10T03:29:46Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Port three Moddable 10.0.0 built-in ordering corrections to IronHorse

Implement child 3 of the reviewed Moddable SDK 10.0.0 IronHorse plan for `endojs/endo-but-for-bots`.

Design and review surface: https://github.com/endojs/endo-but-for-bots/pull/1435 (`designs/moddable-10-0-0-ironhorse-port-plan.md`). This job is parked pending design review and must be activated only by the recommended `moddable-10-0-0-ironhorse-ports` orchestration, after children 1 and 2 succeed.

## Scope

- Fix `Math1::Round` in `ironhorse-vm/src/interp/natives/number.rs` so finite subnormal inputs round correctly, preserving signed zero and the existing integral/boundary behavior.
- Fix `NativeMethod::StringRepeat` so a finite nonnegative count returns the empty string immediately when the receiver is empty, even above `i32::MAX`; negative and infinite counts must still throw.
- Fix the array-like arm of `array_from_inner` so `Construct(C)` occurs after ToLength but before IronHorse's representational rejection of lengths above `u32::MAX`.
- Do not modify already-conformant String search methods or `Array.from` iterator callability, and do not change oracle/matrix/ratchet surfaces.

## Acceptance

- Add focused regressions for ±`Number.MIN_VALUE`, signed zero, and round boundaries.
- Add empty-string repeat cases at 2^31 and `Number.MAX_SAFE_INTEGER`, plus negative and Infinity controls.
- Add an observable custom constructor case at array-like length 2^32 proving constructor invocation precedes the implementation-limit error.
- Run the nearest VM unit tests and affected `ironhorse-262` slices in sloppy and strict modes with the oracle enabled; introduce no generic skips.
- Open a draft implementation PR with exact-head evidence and link the design PR. Do not merge it or start a sibling child.
