**Viability for endojs/endo-but-for-bots#1642: proceed**

PR #1642 is "feat(lal): switch models mid-session with a host-only /model command". It is open, unmerged and still a draft. It was opened at 2026-11-03T02:03Z, and its head is `379dd71d`.

**Deciding question:** Does current `llm`, or any other open or merged PR, already provide a `/model` command that switches a running Lal worker to another provider or model mid-session, as phase 5 of `designs/endopi-provider-registry-and-oauth.md` asks? If not, phase 5 is still unbuilt and nothing has replaced this PR. **Answer: no.**

**Evidence:**
- **The base is current.** The PR's base is `llm-48d6f3e` (`48d6f3e08bc`). Comparing it with live `llm` shows `ahead_by=0`, so nothing has landed on `llm` since this PR was based, and nothing could have displaced it.
- **`llm` still lacks the feature.** On `llm`, the design still lists "Cross-provider handoff (Phase 5)" as **Missing** (line 35), and line 124 still specifies "`/model` mid-session switches the agent". `packages/lal/inbox-loop.js` on `llm` has no `/model` handling.
- **No other PR does this.** Searches for "/model", "lal model switch" and "model switch lal" turned up only this PR on the topic. The other results are unrelated (#1567, #1017, #996, #520) or are phases #1642 itself says it does not own. #1575 (brokered adapters) is phase 2 in the PR's ledger, and the ledger hands phases 1–4 to #1573/#1575/#1587/#670. None of those implement `/model`.
- **The original reason still holds.** The design still lists phase 5 as an open deliverable, and the PR's ledger says this PR is the only one that owns it. There are no reviews or comments that change the scope.

I spent nothing on clean, panel, fix, CI-wait or un-draft work, and made no changes to the PR or the garden repo.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1642-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (183493 cached reads)
- Output: 1555 tokens
- Cost: $0.4487666
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
