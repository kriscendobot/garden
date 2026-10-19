**PR #1504 viability gate: proceed.** I ran only read-only checks: no clean, panel, fix, CI-wait or un-draft budget was spent, and nothing was changed.

**PR facts:** The PR is open, unmerged and still a draft. It was opened today (2026-10-19T15:42Z), so there are no comments or reviews yet. Its base is the frozen `llm-330cf99` at `330cf996`, and its head is `d4c1d7f`.

**Deciding question:** Does `llm` still have no sandbox engine for the Shell capability, with no other PR or newer design covering daemon-agent-tools Phase 2c? A "yes" means the PR isn't superseded and the need behind it still holds.

**Evidence:**
- **The premise still holds.** Upstream `llm` has gained 0 commits since this PR's base. `packages/host-spawner/src` on `llm` has only `host-spawner.js`, `index.js` and `types.ts`, so there is no `sandbox-spawner.js`. The last commits touching `packages/exo-shell` date from 2026-07/08 and are unrelated packaging and lint changes. So the gap this PR fills, where an allowlisted host-engine child can read anything the daemon user can read, is still open on the base.
- **Nothing supersedes it.** The PR implements Phase 2c (the sandbox shell engine) from design PR #1497. #1497 is still open, scopes exactly this slice, and has not been replaced by a newer design. A search for "sandbox shell engine" finds only #1504 and #1497. The earlier merged Shell work (#615, Phase 2) is what this PR builds on, not a replacement for it.
- **Pending dependency:** #1497 still has to land before the design's Phase 2c can be checked off, as the PR body itself says. This doesn't block the gauntlet; it's a later step.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1504-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (157960 cached reads)
- Output: 1492 tokens
- Cost: $0.37395999999999996
- Wall-clock: 36s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
