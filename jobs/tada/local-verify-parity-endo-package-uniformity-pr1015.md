Inbox empty. Work complete.

## Completion report

**Job:** Close local-verify coverage for the Endo package-uniformity CI check (parity follow-up to endojs/endo-but-for-bots#1015).

**Root cause.** PR #1015 failed on CI's lint-job step `yarn test:package-uniformity && node scripts/check-package-uniformity.mjs`, run *outside* `yarn lint`. The `local-verify` harness only ran the root `lint` script (`lint:prettier && lint:eslint && lint:sh`), so the repo scan never ran locally. The wrinkle: the enforcement half (`node scripts/check-package-uniformity.mjs`) is a repo-root command **no package.json script wraps**, so first-match discovery can't reach it, and folding it into `yarn lint` would *duplicate* the check in CI's own lint leg — which the job explicitly forbade. I confirmed the ava `test:package-uniformity` only self-tests the checker's helpers against fixtures and would **not** have caught #1015.

**What changed** (garden `main2`, commit `2bf8803996`):
- `scripts/jobs/gardening/local-verify.sh` — new additive `package-uniformity` step (placed after `lint`, following the `test-xs` additive-check precedent). Its `discover_package_uniformity` composer reconstructs CI's compound command from the parts present: an `LOCAL_VERIFY_PACKAGE_UNIFORMITY` override, else a single project-declared wrap script (`lint:package-uniformity`/`check:package-uniformity`/…, the preferred durable form), else the self-test script `&&` every present repo-root checker (`scripts/check-package-uniformity.mjs`, run as `node <path>`). Inert (silent) where no part exists.
- `scripts/jobs/test/local-verify-test.sh` — new test group (group 18, +10 assertions): part order, tracked-file rejection failing loud with both halves in the blob, override skip, wrap-script subsumption without duplication, and inertness on unrelated projects. Suite now **74 passed, 0 failed**; `bash -n` + `shellcheck` clean.
- `skills/local-verify/SKILL.md` — step list, the new step's rationale, the Inputs discovery precedence, and the Tests summary; `updated:` bumped.
- `skills/local-verify/field-notes.md` — dated 2026-08-29 entry with the tell and the general lesson.

**Verification.** Ran the new step against the real `endojs/endo-but-for-bots` tree: silent at clean HEAD; a re-introduced tracked `packages/ses/src/types.d.ts` reproduced the exact #1015 rejection, then cleaned back to pristine. Garden probe gate (`pre-push-gates.sh --probes-only`) passed; a repo hook's ASCII-arrow normalization was folded into the commit.

**Follow-up (optional, non-blocking).** The cleanest long-term home is a single project-side wrap script in Endo (e.g. `lint:package-uniformity` = the exact CI command, discovered by the step's `PU_WRAP_SCRIPTS` candidates and *not* added to `yarn lint`); left for the project to adopt. Note the deployed root checkout lags `main2` until the next deliberate deploy, so this coverage is live for jobs running against `main2` now and reaches the deployed harness on deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/local-verify-parity-endo-package-uniformity-pr1015.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (7500052 cached reads)
- Output: 49536 tokens
- Cost: $6.642938000000001
- Wall-clock: 708s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
