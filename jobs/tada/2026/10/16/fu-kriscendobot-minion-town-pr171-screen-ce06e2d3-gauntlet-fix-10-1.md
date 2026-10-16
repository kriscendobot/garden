I fixed all three round-10 items on kriscendobot/minion.town PR #171. The fix is pushed to `feat/claude-arc-prod-validation` as commit `8b727de`, on top of `3b2146c`. The local checks pass.

**(a) Old SSM document versions.** The probe role's `SendCommand` grant covers every saved version of `MinionTown-ObserveClaudeHarness`, because the caller can name any version. Each time `deploy-cd-iam.mjs` reconciles the document, it now:
- moves the default to the newest version;
- lists all versions;
- deletes every version except the default.

The logic is a small function, `documentVersionPlan`, in `cd-iam-documents.mjs`. That function never deletes the default. Two new tests in `cd-iam-documents.test.mjs` cover a fresh update, a run that died before moving the default, and the already-converged case. They also check that the script really deletes the versions the function picks. DEPLOYMENT.md now says this in § AWS/SSM and in the rollout step 2.

**(b) `issue` and `issues`.** The probe summary in `prod-objectives.mjs` now carries only `issues` (garden #58 and #89), and its doc comment matches. Nothing in the repo or the workflow read `issue`. DEPLOYMENT.md now names the `issues` field.

**(c) The observer reporting on its own files.** In DEPLOYMENT.md:
- The `claude-harness-pinned-upgrade-policy` table row no longer says the observer matches the pin.
- § What the harness check compares now lists only the binary and the manifest as checked files. It says the observer's report on its own script and layout module is not a check, because a replaced observer could report anything. Those two files are protected only by `deploy-app.sh` staging them root-owned and read-only (`0444`).

The code still collects that self-report; only the docs changed.

**Checks run:**
- `node --check` on `deploy-cd-iam.mjs`: passes.
- `node --test` on `prod-objectives.test.mjs` and `cd-iam-documents.test.mjs`: 38 passed.
- `vitest` on `deploy-app-artifact.test.ts` and `prod-probe-expectations.test.ts`: 9 passed.
- `npm run typecheck`: clean.
- `prettier --check` reports style differences in the touched files. The repo has no prettier config and CI doesn't run prettier, so I left formatting alone.

**Follow-ups:**
- The new pruning (and the `deploy-cd-iam.mjs` changes generally) has not run against real AWS. It runs the next time an admin runs `deploy-cd-iam.mjs`.
- The round-11 panel review came in when I claimed this job. Its must-fix also concerns the observer wording in that DEPLOYMENT.md table row, and this commit should cover it. Its should-fix, hashing the 249 MB binary through a fixed buffer instead of reading it whole, is not handled here.
- Other open round-10 should-fix items are not addressed: a test that only the `harness` job holds `id-token: write`, and squashing the history into fewer commits.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet-fix-10-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1532060 cached reads)
- Output: 12099 tokens
- Cost: $1.188312
- Wall-clock: 227s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
