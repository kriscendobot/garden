---
gate: go-ahead
priority: normal
roadmap: ironhorse-engine
role: builder
posted_by: endojs-endo-but-for-bots-pr1435-gauntlet-fix-1
posted_at: 2026-10-10T07:46:00Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Move the IronHorse oracle to Moddable 10.0.0 and validate the port campaign

Implement child 6 of the reviewed Moddable SDK 10.0.0 IronHorse plan for `endojs/endo-but-for-bots`.

Design and review surface: https://github.com/endojs/endo-but-for-bots/pull/1435 (`designs/moddable-10-0-0-ironhorse-port-plan.md`, sections "Orchestration" and "Oracle, matrix, and ratchet change control"). This job is parked at `gate: go-ahead`. Promote it only after the `moddable-10-0-0-ironhorse-ports` orchestration (children 1–5) has a completion record reading `orchestration-status: complete` with no `failed-children`:

    scripts/jobs/promote-plan.sh --require-tada moddable-10-0-0-ironhorse-ports moddable-10-0-0-ironhorse-oracle-validation

## Scope

- Move `c/moddable` from `23b4d6b0a65f` (XS 8.3.1) to the annotated 10.0.0 tag target `5f215f776f93039755343dbe75a09aa2615045f4`. Update the stale pin message, re-audit every `xs-oracle/build.rs` overlay, and record `xst -v`, the submodule SHA, and the test262 SHA.
- Re-run `packages/hardened262/test/ArrayBuffer/view-behavior-matrix.js` for every recorded mode of `xs`, `sesXs`, `ironhorse`, `sesIronhorse`, and `sesNode`. Preserve the current raw-XS module pass and sloppy/strict skips unless execution proves a change; keep `onlyRaw` unless the intended host scope changes.
- Add the long-second-result named-capture case to the differential set only on the 10.0.0 oracle, and run it once against an AddressSanitizer build of that oracle.
- Generate a full dated IronHorse candidate with `ironhorse-262/scripts/full-run.sh` and compare its covered set to `baseline/refresh-20260904/covered.txt`. Do not promote the ratchet floor by date or borrow the `ironhorse-test262-ratchet` delegation; hand exact-head candidate evidence to that authorized process.
- Keep the test262 pin at `be13516fb6441b950ba8a3df97eb34062c186972` unless the required immutable acceptance cases demonstrably do not exist there; report any pin move as a separate corpus-input change.

## Acceptance

- Run the full engine workspace, the complete bounded whole-tree sweep, the five-host hardened262 matrix, and snapshot tests for immutable buffers and revoked proxies, all on the 10.0.0 oracle.
- Lose no previously covered case; investigate timeouts; separate policy changes (the oracle move) from engine changes (children 1–5). Commit only generated artifacts justified by the recorded runs.
- Open a draft PR with exact-head evidence and link the design PR. Do not merge it or promote a ratchet floor.
