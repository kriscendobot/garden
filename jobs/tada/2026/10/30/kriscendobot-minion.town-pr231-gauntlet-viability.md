**Viability report: kriscendobot/minion.town PR #231 ("feat(shell): add authenticated CapTP session")**

I read the PR, its design PR #230 and the base history. I spent no clean, panel, fix or CI budget on this.

**Deciding question:** Is PR #231 still the only implementation of rung 0a of the governor-column design (the per-tab CapTP session to an owner facet that has `info()`), and does the current #230 design still define rung 0a that way?

**Answer:** Yes to both, so the gauntlet may begin.

**Evidence:**
- **PR state:** open, unmerged and still a draft. It was created 2026-10-30T03:52Z, with head `f63be6e1` and base `main-443519e`. It has no reviews or comments, and nobody has objected to it.
- **Base is current:** the frozen base `443519e` is still the tip of `main` (the #226 merge on 2026-10-26). Nothing has landed on `main` since, so no newer code could have displaced this PR.
- **No other implementation:** `src/auth/shell-session.ts` does not exist on `main`. Of the open PRs, none besides #231 builds a shell CapTP session: #229 is the API-key provider UI, #228 and #230 are designs, and #217 is the Claude CLI proposal.
- **The design still asks for this:** design PR #230 is open, and its latest revision (`5816cf32`, which folds in the maintainer's 2026-10-30 answers) still defines rung 0a as the CapTP session whose owner facet has one method, `info() -> { expiresAt }`. Its exit criterion matches what #231 delivers: a session on page load, reconnect and revoke, and the hostile-fixture suite green on all three browsers. The maintainer's answers relayed on #230 (cloning powers, the nine-rung ladder, destroy cascading through the tree) change later rungs, not rung 0a.

**Follow-up:** #231 implements a design that is still an open draft (#230). If #230's rung 0a definition changes before #231 lands, check #231 against it again.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr231-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (238662 cached reads)
- Output: 1729 tokens
- Cost: $0.45772039999999997
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
