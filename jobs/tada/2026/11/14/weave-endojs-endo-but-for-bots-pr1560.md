I wove PR #1560 (the M3 child-agent factory implementation) onto a fresh `llm` snapshot. The rebase had no conflicts, and the package's tests, type check, lint and formatting all pass on the new base.

- **New base:** the PR's base moved from `design/endo-child-agent-factory-dcf4d60` to `llm-48d6f3e`. That snapshot branch already existed at the current `llm` tip (48d6f3e08b), so I didn't create one. The PR was 8 commits behind `llm`.
- **Head:** `build/exo-agent-factory-core` went from 21d142af2d to 85c61c08ad, pushed with `--force-with-lease` pinned to the old head.
- **Rebase:** all 19 commits replayed with none dropped. That is the 4 commits of the still-open design PR #1558 plus the PR's own 15. The package files and design doc are byte-identical to the old head. The `yarn.lock` merge came through cleanly: the only lockfile change against the new base is the `@endo/exo-agent-factory` workspace entry, and `yarn install --immutable` accepted it.
- **Decision you may want to revisit:** #1558 isn't merged, so `llm` has no copy of the design doc, and the PR's own commits edit it. So I carried the design commits along instead of dropping them. As a result the PR now also shows the design doc and the design's `designs/README.md` roadmap rows: 23 files, up from 22. If #1558 merges first, a later weave will drop those commits automatically, since their changes will already be on `llm`.
- **Checks on the rebased tree:** in `packages/exo-agent-factory`, the tests passed (42), and `tsc`, `eslint` and prettier were clean. That includes the newer `eslint-plugin-unicorn` (73→79) the base brought in. `assert-pinned-base.sh pr` passed, and GitHub reports the PR as MERGEABLE.
- **Not done:** I left no PR comment, because the job didn't authorize one.

**Follow-ups:**
- The stacked PRs (#1563 and #1625, both based on `build/exo-agent-factory-core-21d142a`) still point at the old head's snapshot. They are unaffected for now but will need a weave of their own later.
- The old `design/endo-child-agent-factory-dcf4d60` base branch stays until the PR closes, per the frozen-base convention.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-endojs-endo-but-for-bots-pr1560.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1387616 cached reads)
- Output: 6845 tokens
- Cost: $0.9714472000000001
- Wall-clock: 143s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
