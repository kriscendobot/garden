The retcon of kriscendobot/minion.town PR #85 was already done and pushed by the previous attempt, and I've confirmed it's correct, so I made no new push.

**What I found**
- At 2026-10-03T22:13:16Z the branch `feat/clip-upgrade-in-place` was force-pushed from `3f2671e` to `53ff65e`. `3f2671e` was the tip left by the gauntlet: 16 commits covering the feature, its scope expansion and 6 panel/fix rounds.
- **The code didn't change:** `git diff 3f2671e 53ff65e` is empty, so the old and new tips have the same tree. The frozen base `main-ec8db3f` (`ec8db3fc`) is unchanged and is an ancestor of the old tip, so the PR's net diff (20 files, +2160/−146) is the same as before.
- **New history:** three commits with conventional-commit messages, each test file in the same commit as the code it covers, and no file in more than one commit:
  1. `72d24b1` feat(clip): add revocable, attenuable upgrade capabilities. The new `upgrade-capability.ts` and its test.
  2. `95e593a` feat(clip): upgrade a clip's front and back in place on the live @sites path. The publish/registry/vhost/guest-tools/http wiring, the MCP tool names, and their tests.
  3. `53ff65e` docs(clip): document in-place upgrade and re-registration. `DEPLOYMENT.md` and three clip design docs.
- **How it's grouped:** minion.town is a single package, so I split by concern (capability primitive, live-path wiring, docs) rather than by package. The PR doesn't change `package-lock.json`, so there's no lockfile commit.
- **CI is green on `53ff65e`:** test (typecheck + vitest), and Claude harness on amd64 and arm64.

**Follow-ups**
- The gauntlet `kriscendobot-minion.town-pr85-gauntlet-20261003` ended at `review-budget-reached`: it ran 6 fix rounds and the panel review still didn't converge. The PR is still a draft and is waiting for the maintainer to decide whether to review or merge it.
- I squashed the gauntlet's fix commits into the clean history because the job asked for that. The usual rule is to keep fix commits visible after a review has run, so the conductor will have nothing to squash at merge time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-retcon-20261003.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 36 tokens (953529 cached reads)
- Output: 8169 tokens
- Cost: $1.1741018000000003
- Wall-clock: 349s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
