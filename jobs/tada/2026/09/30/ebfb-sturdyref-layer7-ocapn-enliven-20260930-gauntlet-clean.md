---
orchestration-failed: true
---
orchestration-failed: true

**Gauntlet clean stage for endojs/endo-but-for-bots#1397: failed. CI can't run because the PR conflicts with its base branch.**

**Coverage and dead code (no changes made):**
- The PR is still a draft, head `b0729525d7`. It changes one source file, `packages/ocapn/src/client/sturdyrefs.js`, plus tests and a changeset.
- The change pulls the swiss-number lookup out into a new `lookupSwissnum` helper. The tracker's `lookup` and the at-home path of `enlivenSturdyRefDetails` now both use it.
- Nothing is left orphaned: every import (`thawedBytes`, `decodeSwissnum`, `swissnumToBytes`, `swissnumFromBytes`) is still used.
- By reading `packages/ocapn/test/sturdyref-enliven.test.js`, the new branches look covered: the string-secret path, the bytes path that decode to ASCII, and the fallback for non-ASCII bytes ("non-ASCII secret bytes returns home intact"). I didn't run the coverage tool, because the project checkout never finished setting up (`ensure-project-worktree.sh` hung).
- I pushed nothing.

**CI (`ci-wait-merge.sh --no-merge`, rc=3):**
- GitHub reports the PR as `mergeable=CONFLICTING`, and the check list stays empty. No checks ran, so none failed on their own. CI simply can't start until the head is rebased onto its base.

**Follow-up:** the PR needs a weave (rebase onto the current base and resolve the conflicts) before the gauntlet can go on. The driver should halt here and raise it with the maintainer.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 54 tokens (1252878 cached reads)
- Output: 8847 tokens
- Cost: $1.1247476
- Wall-clock: 1464s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
