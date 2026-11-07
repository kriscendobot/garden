## Viability: PR #230 (kriscendobot/minion.town). Proceed

PR #230 can enter the gauntlet. It is still open and nothing newer has replaced it. This stage did no clean, panel, fix, CI-wait or un-draft work.

**PR facts:** The PR is open, unmerged and still a draft. Its title is "design(shell): the governor column, a ladder of increments". The head is `design/clip-governor-column` and the base is the frozen snapshot `main-443519e`. It changes one file, `designs/clip-governor-column.md`.

**Deciding question:** Does current `main` or any newer PR or design already specify the clip governor column (CapTP shell session, governor column, clone, destroy cascade, children), and has the maintainer dropped the governor model?

**Evidence (no to both):**
- `designs/clip-governor-column.md` is not on `main` (404).
- `main` is 119 commits ahead of the base. None of the designs that changed in that range mention "governor": `clip-shell-framework.md`, `new-clip.md`, `api-key-agent-workbench.md` and the guest and invitation designs. None of the commits on `main` since 2026-10-30 is about governors or the shell session.
- No other PR replaces it. #231 ("feat(shell): add authenticated CapTP session", open draft) builds this design's rung 0a, and the design's question (j) was settled to match #231. #247 (gutter ordering and naming, open draft) says it composes with "the lifecycle-controller and governor-cascade designs", so it relies on #230 rather than replacing it.
- The premise still holds. The maintainer's answers of 2026-10-29 and 2026-10-30 (questions a–d and g–j, clone copies powers, destroy cascades, CapTP by default) are all folded into the PR. No comment withdraws the governor model, and it matches the 2026-10-29 "chrome vision" objectives (chrome bar, clips, New Clip zygote).
- The PR has no formal reviews. Its latest activity was on 2026-10-30.

**Follow-up:** The PR body still has two open questions for the maintainer: (f), on whether a governor-controlled wrapper that escaped the subtree stops working when its governor is destroyed, and (k), on whether `GET /account/clips` stays once the gutter reads from `facet.list()`. It also carries the `<!-- garden-design-open-questions -->` marker, which makes it a page for the maintainer to answer on rather than a merge waiting to happen. The later gauntlet stages should keep it a draft until the maintainer answers those two questions, not just un-draft it once the panel passes.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr230-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (252621 cached reads)
- Output: 2239 tokens
- Cost: $0.4934722
- Wall-clock: 44s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
