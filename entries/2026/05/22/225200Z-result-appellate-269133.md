---
ts: 2026-05-22T22:52:00Z
kind: result
role: appellate
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/05/22/224820Z-result-barrister-9a97f1.md
---

Appellate audit of barrister-9a97f1's terminating verdict on PR #320 (`feat(familiar): consolidate daemon stop/purge via CapTP control helper`). Reviewed 3 `follow-up` items in the ledger at `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--320.md` plus the aggregated-layer `acknowledge` items in the panel body.

## Audit

PR diff: 7 files, 139/21 lines, new `packages/familiar/daemon-control.js` (58 lines), `daemon-manager.js` rewrites, scripts/resource-paths tweaks. `packages/familiar/` has **no `test/` directory and no `ava` devDep**; lint script exists, test script does not.

### Per-disposition verdicts

- **Follow-up #1 (verb-allowlist unit test)**: small=NO. Adding the first test in the package requires standing up the `ava` test harness (devDep, script wiring, possibly `test.config.cjs`) before writing the test. The PR body already defers test work to G16 (packaged-smoke). Deferral stands.
- **Follow-up #2 (timer-clear regression guard for cleaner-12a8b9 fix)**: small=NO, in-context=PARTIAL. Mocking `child_process.spawn` to assert no stranded `setTimeout` handle is a non-trivial test fixture, again requires the missing harness, and the cleaner fix it would pin is already in the branch as commit `b95d00637` (covered by git history; the regression-evidence gap is real but not loss-track-critical because the fix sits adjacent to the helper it protects). Deferral stands.
- **Follow-up #3 (reconcile `runDaemonControl('restart')` with in-process `restartDaemon()`)**: small=NO, in-context=NO. Explicitly conditional on the future #231 G8 PR that drops `endo-cli.cjs` from the production runtime path. Reconciliation requires deciding the surface, not a one-line patch. Deferral stands; it is already correctly parked against the downstream PR.

### Proposed promotions

None. All three follow-ups fail "small" (no test harness to extend) and #3 additionally fails "in-context" (scoped to a separate downstream PR).

Considered: 3 follow-up + 5 acknowledge items at the aggregated layer (restart-symmetry note; CI-failure context; plus the 26 seat-level acknowledges aggregated into 2 review-body items). Zero promotions warranted.

## Recommendation to contractor

**Un-draft now.** No appellate-driven amendments to the post-loop actions. The contractor's next cycle may run `gh pr ready 320` directly; the ledger entries remain parked and the steward's per-cycle survey revisits at merge time.

Self-improvement: nothing this time. The appellate's rubric handled the harness-absence case cleanly (small=NO short-circuited the audit), and the role file's "small relative to PR's scale" framing made the unit-test-as-first-test cost legible. The judge correctly parked all three; the appeal was warranted but produces an empty promotion list, which the role file already names as a valid outcome.
