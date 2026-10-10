---
gate: go-ahead
priority: normal
roadmap: ironhorse-engine
role: builder
posted_by: designer
posted_at: 2026-10-10T03:30:10Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Implement immutable ArrayBuffer and close the Moddable 10.0.0 validation campaign

Implement child 5 of the reviewed Moddable SDK 10.0.0 IronHorse plan for `endojs/endo-but-for-bots`.

Design and review surface: https://github.com/endojs/endo-but-for-bots/pull/1435 (`designs/moddable-10-0-0-ironhorse-port-plan.md`). This job is parked pending design review and must be activated only as the final child of the recommended `moddable-10-0-0-ironhorse-ports` orchestration, after all four semantic-port children succeed.

## Scope

- Implement the immutable ArrayBuffer surface (`immutable`, `sliceToImmutable`, `transferToImmutable`) and the internal immutable state in `ironhorse-vm`.
- Reject every write through ArrayBuffer, TypedArray, DataView, native fast path, transfer, snapshot restore, and host-facing buffer path while retaining permitted reads and slices. Specify and test detached/immutable precedence and persistence.
- Update SES boot expectations, especially `ses_boot_intrinsics.rs::FROZEN_REALM_FORECLOSURE`, from measured behavior rather than deleting the foreclosure blindly.
- This child alone may move the `c/moddable` oracle from `23b4d6b0a65f` to the annotated 10.0.0 tag target `5f215f776f93039755343dbe75a09aa2615045f4`. Re-audit every `xs-oracle/build.rs` overlay and record `xst -v`, submodule SHA, and test262 SHA.
- Re-run `packages/hardened262/test/ArrayBuffer/view-behavior-matrix.js` for every recorded mode of `xs`, `sesXs`, `ironhorse`, `sesIronhorse`, and `sesNode`. Preserve the current raw-XS module pass and sloppy/strict skips unless execution proves a change.
- Generate and compare a full dated IronHorse candidate against `baseline/refresh-20260904/covered.txt`. Do not promote the ratchet floor by date or borrow the `ironhorse-test262-ratchet` delegation; hand exact-head candidate evidence to that authorized process.
- Keep the test262 pin at `be13516fb6441b950ba8a3df97eb34062c186972` unless the required immutable acceptance cases demonstrably do not exist there; report any pin move as a separate corpus-input change.

## Acceptance

- Add direct native-surface, write-rejection, transfer, slice, detached precedence, snapshot persistence/restore, and SES-boot tests for immutable buffers and views.
- Run the full engine workspace, complete bounded whole-tree sweep, sanitizer-enabled oracle capture-group long-result regression, five-host hardened262 matrix, SES boot suites, and snapshot suites.
- Lose no previously covered case; investigate timeouts and separate policy changes from engine changes. Commit only generated artifacts justified by the recorded runs.
- Open a draft implementation PR with exact-head evidence and link the design PR. Do not merge it or promote a ratchet floor.
