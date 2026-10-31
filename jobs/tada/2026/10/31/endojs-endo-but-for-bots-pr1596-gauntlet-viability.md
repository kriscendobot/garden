## PR #1596 viability check: proceed

The gauntlet can start. The PR is still open and nothing has replaced it. The bug it fixes is still in the current `llm` branch. I spent no budget on clean, panel, fix, CI-wait or un-draft.

**Deciding question:** Does the current `llm` code still pick the newest version that fits a requirement, against the accepted design's "least satisfying" rule, and has no other PR or commit fixed that?

**Answer:** Yes, the bug is still there, and nothing else has fixed it.

**Evidence:**
- **PR state:** #1596 "fix(exo-npm): preserve minimum version selection" is OPEN, not merged, and still a draft. It was opened 2026-10-31T19:07Z from the `build-mvs-resolver` job. Its head is `d652db3faa` on `build/m3-mvs-resolver-reference`. It has no comments or reviews yet.
- **Base is current:** the PR's base `llm-9a14ddf` is identical to the `llm` tip `9a14ddf660` (0 commits ahead, 0 behind). So no newer base history exists to have replaced it.
- **The bug is unfixed on `llm`:** the last commits touching `packages/exo-npm/src/mvs-resolver.js` were the original MVS feature commits (2026-08-17). The code there still uses `selectGreatestSatisfying`, which picks the newest version that fits. It also checks only the newest requirement, so earlier ones are dropped.
- **The design still asks for the fix:** `designs/mvs-resolver.md` on `llm` specifies `selectLeastSatisfying`, which "picks the least that satisfies". The PR brings the code into line with that. The design's status is still "Not Started", so the work remains open.
- **No competing PR:** no other open PR touches `exo-npm/mvs-resolver`. The older resolver PRs #564 and #772 are closed, and #1117 and #331 cover registry-as-directory and the registry-capability design, which are different work.
- **Small scope:** the PR changes two files, `mvs-resolver.js` (+22/−15) and its test (+45/−7).

**For the next stages:** the PR description mentions two failures that exist on the base, not caused by this PR. `zizmor` can't parse `depcheck.yml`, and a thixotrope test hit a TCP port collision. The later stages should not treat either as a fault of this PR.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1596-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (300209 cached reads)
- Output: 2120 tokens
- Cost: $0.49335380000000006
- Wall-clock: 31s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
