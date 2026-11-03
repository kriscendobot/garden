---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-11-03T05:26:32Z
---
# Dependabotany - endojs/endo-but-for-bots PR #1633 - MERGE-NOW blocked on base-red test-xs (non-terminal)

project: endo-but-for-bots
pr: https://github.com/endojs/endo-but-for-bots/pull/1633
verdict: MERGE-NOW (stands; https://github.com/endojs/endo-but-for-bots/pull/1633#issuecomment-6565026878)
state: OPEN, MERGEABLE, head 908d56d62d (woven by the garden onto llm 48d6f3e08b); not merged; auto-merge not enqueued
escalation: base CI red (test-xs, Node 26 LTS rollover), not PR-attributable
next-owner: endojs-endo-but-for-bots-pin-node-version-24 (fixer: pin .node-version to 24 on llm); then the daily backstop dependabotany-recheck-endo-but-for-bots re-conducts

## What happened
- Weave: Dependabot did not regenerate the branch within ~20 min of `@dependabot rebase`. The garden wove it by rebasing onto llm 48d6f3e08b, taking llm's side of the 4 conflicting manifests and re-applying only the preact range (^11.0.2). It regenerated yarn.lock and force-pushed with lease (dc20718e12 → 908d56d62d). The commit author is still dependabot[bot].
- Moved set: a fresh resolve floated to preact@11.1.1, which the verdict does not cover. The lockfile entry was pinned back to the reviewed preact@11.0.2 (same checksum as Dependabot's own commit). The moved set vs llm is exactly one version, preact 10.29.8 → 11.0.2, so the earlier verdict covers it and no re-review was needed. `yarn install --immutable` passes.
- CI: 37/38 checks green. The only red is test-xs, `@endo/hardened262` baseline `sesNode/module test/intrinsics/ThrowTypeError/intrinsic-metadata.js` passed → failed. It failed twice on this PR.
  - Classification: base-attributable, not a flake and not preact. `.node-version` is `lts/*` and now resolves to Node 26.13.0.
  - Proof: the llm base run 41370492445 test-xs, rerun at 2026-11-03T04:02Z (job 125718398161), fails identically. The same flip appears on #1639, #667, #1588 and ci/daemon-test-rust.
- The botanist gate needs green CI, so ci-wait-merge was not driven to a merge.

## Resume
Once the Node pin (or another fix) lands on llm:
1. Re-run CI on #1633. ci-wait-merge rebases a behind head onto the live base itself.
2. Run scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 1633 --dependabot-auto-merge.
3. Re-check that the lockfile still moves only preact@11.0.2.
