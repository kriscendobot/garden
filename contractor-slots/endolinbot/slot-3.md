---
slot: 3
status: in-flight
design_path: designs/base64-native-fallthrough.md
pr_number: null
current_stage: builder
in_flight_dispatch: 4fb582
last_update: 2026-05-18T05:22:00Z
started_at: 2026-05-18T05:22:00Z
host: endolinbot
---

Slot 3 picks up base64-native-fallthrough — detect and dispatch to the
TC39 `Uint8Array.fromBase64` / `Uint8Array.prototype.toBase64`
intrinsics in `@endo/base64` while keeping the existing JS polyfill as
fallback. Focused single-package change on master base. Sibling
`@endo/hex` design follows the same pattern but is out of scope.

Dispatch root: `dispatches/builder--4fb582`.
