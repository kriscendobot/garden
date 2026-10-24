PR #1547 should not enter the gauntlet: another open PR, #1544, already implements the same Phase 7 work, so #1547 duplicates it.

Viability verdict for endojs/endo-but-for-bots#1547 ("feat(claude): provision sandboxed workspace sessions"): **overtaken**.

**PR facts:** The PR is open, draft and unmerged, with head `31ef715be9`. Its base is `build/daemon-agent-tools-sandbox-shell-ee79556`, which is the head of #1504, the sandbox-engine PR it is stacked on. It was opened 2026-10-24T17:28Z and has no reviews or comments.

Deciding question: Is #1547 the only open implementation of `daemon-agent-tools` Phase 7 (the endo-claude acceptance loop with refusal of host-engine shells), with the endo-claude premise behind it still current?

Evidence:
- **An earlier PR already does this.** #1544 ("feat(claude): add sandboxed Git acceptance loop", opened 2026-10-23, still open as a draft) implements the same Phase 7.
  - It cites the same refs: #1497 (the design PR) and #1504.
  - It stacks on the same #1504 head, `ee79556`.
  - Its `@endo/claude` provisioner (`session-provisioner.js`) does the same check: it reads the Shell's own `inspect()` and refuses any engine other than `sandbox`.
  - Its MCP `evaluate` acceptance runs the same loop: edit, build, commit, push, then `filesystemAt`.
  - It is the more complete of the two, with a README and coverage brought to 100% by its clean stage.
- **Why #1544 is stalled.** Its gauntlet halted on 2026-10-23 only because of known Ubuntu 26.04 runner breakage: bwrap `ulimit -u` and missing `tred`. #1542 fixes the bwrap tests. The code itself is not the problem.
- **Where #1547 came from.** It was produced by a second build job, `build-daemon-agent-tools-phase-seven-endo-claude-acceptance-loop` (still in `doin/`, claimed 2026-10-24T16:15Z). That job repeats the completed `build-daemon-agent-tools-endo-claude-acceptance-loop`, which produced #1544. It re-implemented the slice in parallel (`workspace-session.js` / `provisionEndoClaudeGuest`) instead of recognizing the existing PR.
- **The premise is weakening as well.** Design PR #1543 (open since 2026-10-23) marks the `endo-claude` design "Superseded by claude-bare-course-correction" because `claude --bare` rejects subscription credentials. That design is still only proposed, so this is supporting evidence. The decisive fact is the duplicate.
- Phase 7 is not on `llm` yet, so the need for the work still holds. It is already covered by #1544.

Option: close as superseded

Follow-ups for the maintainer:
- Close #1547 as a duplicate of #1544.
- Carry Phase 7 forward on #1544: weave it once #1542 lands, then re-run its gauntlet. Also decide whether Phase 7 still matters once #1543's course correction is settled.
- The duplicate build job is still in `doin/`. If it pushes more to #1547, that work is wasted.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1547-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (631734 cached reads)
- Output: 4612 tokens
- Cost: $0.7496348000000002
- Wall-clock: 62s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
