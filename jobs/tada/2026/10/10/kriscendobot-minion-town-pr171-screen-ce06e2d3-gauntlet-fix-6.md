Fix round 6 for kriscendobot/minion.town PR #171 is done: two commits are pushed to the PR head and CI is green.

**Panel round 6 asked for:**
- **decomplector** (two must-fix):
  - justify the SSM mechanism in the PR body;
  - stop the root-run observer from doubling as the constants module.
- **archivist**: JSDoc on several exported functions (should-fix).
- **pruner**: a shorter PR body and fewer redundant workflow comments.

**Commits pushed to `feat/claude-arc-prod-validation`** (via `safe-push-pr-head.sh`, `ad561a0` → `3af3693`):

1. **`044ca0e` refactor(probe): move the harness layout out of the root-run observer**
   - Added `deploy/probe/claude-harness-layout.cjs`, a data-only module. It holds the deployed paths, the protected files and directories, and the SSM document name, and runs nothing.
   - `claude-harness-observe.cjs`, `claude-harness.mjs`, `deploy-cd-iam.mjs` and the tests now import the layout from this module. The observer exports only `observe` and `describe`.
   - The observer's header comment no longer says "it only reads". It now says it writes nothing and runs one command: the pinned binary's `--version`, and only when the digest matches.
   - Because the observer requires the new module on the box, `deploy-app.sh` ships it beside the observer, root-owned and `0444`. The harness check now also checks this module.
   - Updated the `prod-probe.yml` sparse checkout and the tests: the artifact test checks both files with `it.each`, and the probe tests cover the new `PROTECTED_FILES` list.
   - `DEPLOYMENT.md`: the SSM rationale now opens by saying why the build-time digest pin and `.artifact-sha256` can't answer the check. The layout paragraph and the list of compared files are updated.
2. **`3af3693` docs(probe):**
   - Added JSDoc to `probeSubject`, `deploySubject` and `remaining()`.
   - Trimmed the `prod-probe.yml` job comments; the token-trust detail now points to `DEPLOYMENT.md` § AWS/SSM.

**PR body:**
- Added a one-sentence reason why the check reads through SSM at runtime instead of using the existing digest.
- Cut the "Status: draft" section to one sentence.
- Left the phase and evidence ledger as it was.

**Not changed:**
- Archivist's first item: the "Claude arc objectives of" wording is already in `DEPLOYMENT.md`, so there was nothing to fix.
- decomplector's finding 3 (the merge-order coupling): it is a should-fix and was not addressed. The rollout order stays documented, not enforced.
- Prettier warnings on these files are left alone; CI does not run Prettier.

**Verification:**
- Local: `prod-objectives.test.mjs` and `cd-iam-documents.test.mjs` pass 41/41, `deploy-app-artifact.test.ts` passes 5/5, and `npm run typecheck` and `bash -n deploy-app.sh` are clean.
- CI: `ci-wait-merge.sh --no-merge` returned rc 0 with all 3 checks green.
- My first `ci-wait-merge.sh` run was moved to the background and killed at its time limit. I polled the checks in the foreground instead, then re-ran `ci-wait-merge.sh`, which confirmed green.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2771215 cached reads)
- Output: 20252 tokens
- Cost: $1.802123
- Wall-clock: 1514s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
