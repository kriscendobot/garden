---
orchestration-failed: true
---
orchestration-failed: true

# Gauntlet CLEAN: endojs/endo-but-for-bots PR #1536

CI is red at the PR head, so this stage fails. The red checks are not caused by the PR's diff. They match the ubuntu-26.04 runner breakage on the base that started on 2026-10-22.

**PR:** "chore(lint): reject explicit any, with a shrink-only baseline". It is a draft, head `endojs:no-explicit-any-ratchet` at `6b4326a11`, base `llm-54d3d2a`.

## Coverage and dead-code pass: nothing to change, nothing pushed
- The PR only adds code: two new rules in `packages/eslint-plugin/src/configs/shared.js`, an exemption block in `eslint.config.js`, the new script `scripts/check-no-explicit-any.mjs`, the baseline JSON, a `lint:no-any` script, and a changeset. No code was left orphaned.
- The new tests in `packages/eslint-plugin/test/config.test.js` check the flat and legacy internal configs (`.js`, `.ts` and test files), confirm `flat/strict` is unchanged, and check that an `any` nested in a JSDoc cast is reported. That covers the behavior that changed.
- I ran these locally in an isolated checkout:
  - `packages/eslint-plugin` `yarn test`: 154 tests, all passing.
  - `node scripts/check-no-explicit-any.mjs`: "Explicit any baseline holds: 4976 in 990 files."

## CI (`ci-wait-merge.sh --no-merge`): rc 3, RED
I waited in bounded chunks, about 45 minutes in all, until CI finished. The red checks:
- **`build`** fails at "Check for cycles": `scripts/graph.sh: line 32: tred: command not found` (exit 127). The 26.04 image has no graphviz.
- **`test (22.x, ubuntu-latest)`, `test (24.x, ubuntu-latest)`, `cover (22.x, ubuntu-latest)`, `cover (24.x, ubuntu-latest)` and `sandbox-drivers`** each fail with `packages/sandbox … yarn run test[:c8] exited (1)`. The PR doesn't touch `packages/sandbox`, and every one of these annotations carries the "ubuntu-latest label will migrate to Ubuntu 26" notice. I couldn't confirm the exact `Illegal option -u` line because the job logs weren't downloadable yet (the run was still marked in progress).
- The other required checks passed.

The same breakage has hit PRs #1527, #1534 and #1535. The fix belongs on the base, either by pinning the runner to `ubuntu-24.04` or by installing graphviz and making the sandbox tests work on 26.04. It doesn't belong in this PR. Once the base is fixed, this PR needs a weave onto the new base and the gauntlet resumed.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1536-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1210834 cached reads)
- Output: 6167 tokens
- Cost: $0.8026187999999999
- Wall-clock: 2429s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
