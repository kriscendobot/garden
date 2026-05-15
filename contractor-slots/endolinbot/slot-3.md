---
slot: 3
status: in-flight
design_path: designs/hardened-text-codecs-shim.md
pr_number: null
current_stage: builder
in_flight_dispatch: 03b9cc
last_update: 2026-05-15T02:42:00Z
started_at: 2026-05-15T02:42:00Z
host: endolinbot
---

Slot 3 refilled with a fresh design from the roadmap branch.

Design: `designs/hardened-text-codecs-shim.md` (Not Started). Adds
hardened `TextEncoder` / `TextDecoder` to SES `universalPropertyNames`.
Declared dependencies are `hardened-url-shim` and `base64-native-fallthrough`,
both annotated "Independent" / "may land in either order" in the design
body. Walk verdict: `start-here` (no stack needed).

Three phases (S each):
1. Permits and sampling in `packages/ses/src/permits.js` and `intrinsics.js`.
2. Tests and changeset.
3. Downstream audit (other packages that take `TextEncoder` / `TextDecoder`).

Implementation base: `master` (per the design/implementation split rule
in `skills/pr-creation-flow/SKILL.md` § Designs versus implementations).

Dispatch root: `dispatches/builder--03b9cc`.
