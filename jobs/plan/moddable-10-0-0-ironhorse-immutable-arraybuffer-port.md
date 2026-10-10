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

<!-- garden-annotation: key=pr1435-panel1-split by=endojs-endo-but-for-bots-pr1435-gauntlet-fix-1 at=2026-10-10T07:46:12Z -->

Scope narrowed by the PR #1435 panel round 1 (design commit 7d2d6f8d12): the oracle pin move, the `xs-oracle/build.rs` overlay re-audit, the hardened262 five-host matrix, the sanitizer capture-group oracle run, and the full candidate ratchet comparison moved to the new child `moddable-10-0-0-ironhorse-oracle-validation`. This job now covers ONLY the immutable ArrayBuffer feature: the native surface, write guards, detached/immutable precedence, snapshot persistence, SES-boot tests, and the measured `FROZEN_REALM_FORECLOSURE` update, with targeted Rust tests. Do NOT move `c/moddable`, regenerate the whole-tree expectations, or touch the hardened262 baselines. It now runs in parallel with children 1–4 under `moddable-10-0-0-ironhorse-ports` (`--parallel --on-child-failure continue`); it is not the final child. Size: L, 1.5–2 weeks.

<!-- garden-annotation: key=pr1435-panel2 by=endojs-endo-but-for-bots-pr1435-gauntlet-fix-2 at=2026-10-10T09:38:36Z -->

Snapshot-golden rule (design § Orchestration, PR #1435 panel round 2): children 1 and 5 may both bump the snapshot format version (`ironhorse-snapshot/src/format.rs`) and regenerate `ironhorse-snapshot/tests/fixtures/state_golden*.tsv` (both math providers) and the inline digests. Regenerate these, never hand-merge them; whichever of the two merges second rebases onto the first, regenerates the goldens, takes the next format version, and says so in its PR. When a specified result disagrees with the 8.3.1 oracle, record the row as the run reports it and list it in the PR as an expected oracle divergence citing the spec and the XS 10.0.0 commit; never change the engine toward the oracle. Design row: R22. Additionally (critic, panel round 2): this child's FIRST commit is a short design note, reviewed before any write-path code lands, that decides (a) representation: where the immutable bit lives (buffer row vs side table) and how every write path reaches it; (b) precedence: order of the detached and immutable checks on each write, transfer, and slice path, from the spec; (c) persistence: whether the bit changes the snapshot row format, and if so the format-version bump and the goldens it regenerates.
