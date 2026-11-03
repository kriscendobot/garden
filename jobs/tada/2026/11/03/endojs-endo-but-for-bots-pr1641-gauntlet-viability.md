**Viability report: endojs/endo-but-for-bots PR #1641** ("fix(exo-git): resolve diff and stash paths through the mount")

The gauntlet can begin. The PR is still needed and nothing has replaced it.

**PR facts:** The PR is OPEN, not merged, and still a draft. It was opened 2026-11-03T02:01Z by build job `daemon-git-agent-tool-adapters-build`. The head is `build/daemon-git-tool-paths` @ `be6462bc`, and the base is the frozen `llm-48d6f3e` (`48d6f3e0`). It has no comments or reviews yet.

Deciding question: On current `llm`, do `Git.diff` and `Git.stashPush` still pass a `paths` option to git without resolving it through the worktree mount, with no other open or landed change fixing that?

Evidence:
- `llm` has gained no commits since the PR's base, so nothing newer can have replaced it.
- On current `llm`, `packages/exo-git/src/git.js:711-712` still copies `opts.paths` straight to the backend (`resolved.paths = [...opts.paths]`). `add`, `restore` and `checkoutConflict` go through `designatorsToRepoPaths` (lines 750-773), which shows the gap the PR describes is real.
- That gap leaks the host path to the model: a `..` path returns git's "outside repository at <host path>" error. The design it cites (`designs/daemon-git-capability.md` § Agent-Facing Tool Adapters) still says path inputs must be resolved through the mount.
- I found no other open PR covering the same fix; #1641 is the only match.

I spent no clean, panel, fix, CI-wait or un-draft budget, and made no changes.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1641-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (181661 cached reads)
- Output: 1497 tokens
- Cost: $0.43916820000000006
- Wall-clock: 21s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
