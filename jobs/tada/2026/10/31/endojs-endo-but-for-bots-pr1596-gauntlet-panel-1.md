PANEL round 1 for endojs/endo-but-for-bots PR #1596 ("fix(exo-npm): preserve minimum version selection", draft) finished with a **must-fix** verdict, and the review is posted on the PR.

- **Pinned pair:** base `9a14ddf660912ed624e2d9047671d43e3a2f0cec`, head `d652db3faaed6c337f781feefd95592fc0be0b22`. The head is on `endojs/endo-but-for-bots`, branch `build/m3-mvs-resolver-reference`. I checked the head out detached in an isolated project worktree (`scratch/project-wt-endojs--7e8ea7c62981-7771b9ac`) and confirmed `HEAD` matches it. The base object is present.
- **Style pre-pass:** `pre-push-gates.sh --no-auto-fix --probes-only` passed (exit 0, no output).
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 0. The PR-body concision probe fired, so the pruner seat also reviewed the description. Because the PR is self-authored, the result went up as a COMMENTED review under the "Must-fix before merge" heading, at 2026-10-31T19:23:48Z.
- **Lead finding (assessor seat):** in `packages/exo-npm/src/mvs-resolver.js`, `parseRangeMajor` puts all 0.x caret ranges into the same major slot `"0"`. That means `^0.1.0` and `^0.2.0` now hard-fail when they should be able to coexist.

I made no fixes and did not un-draft the PR. The fix-loop stage comes next.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1596-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (291679 cached reads)
- Output: 1780 tokens
- Cost: $0.4534078
- Wall-clock: 199s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
