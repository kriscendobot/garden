The panel came back **must-fix** for kriscendobot/minion.town#179 ("feat(shell): real clip names and icons in the gutter").

**What I did**
- Made a separate checkout of the PR branch `gutter-clip-labels` at head `9550ed3`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the base commit `c7bdf20`. The base branch `main-c7bdf20` lives on the bot's own fork, so I passed the commit hash rather than the branch name. The script exited 0 and its last line read "code-panel single-round — must-fix".
- 33 seats ran: 10 approve, 22 comment-only, and 1 request-changes (pruner, about the length of the PR description).

**What was posted**
- The full per-seat write-up is about 82 KB, more than GitHub allows in a single review (65,536 characters). I split it at seat boundaries into two PR comments, 6104796981 and 6104797154.
- The verdict went up as a COMMENTED review, posted at 2026-10-11T02:55:15Z. The PR belongs to the bot, and GitHub refuses a request-changes review on your own PR ("Can not request changes on your own pull request"). I posted it as a plain comment review instead. It is headed "Panel round 1: must-fix" and carries a `garden-panel … disposition=must-fix` marker.

**Findings for the fix stage.** No seat found a defect an attacker could use. Several seats raised the same should-fix items:
1. The clip-name lookup in `publish.ts` `list` reads every clip at once, with no limit or cache, on every listing. When a lookup times out, the read itself keeps running.
2. The name-cleaning rule exists twice, once on the server (`sanitizeClipName`) and once in the browser shell (`clipName`), and no test checks that the two agree.
3. The list of stripped characters misses U+061C, a text-direction control character, and some other invisible characters.
4. The gutter icon logic treats `©`, `®` and `™` as emoji, and an icon can be made arbitrarily long by stacking combining marks.
5. The MCP `sites.list` tool now returns `name`, but its description doesn't mention it.
6. Two behaviors have no real test: the dimmed rendering of clips that aren't being served, and the `http.ts` wiring that hooks in the name lookup.
7. The title reader is handed the whole content store, including write access, when it only needs to read.
8. The PR description is 368 words, over the 300-word limit.

**Follow-up:** the bot's GitHub REST rate limit ran out during this run. Posting comments and the review still worked, but later stages may hit the same limit.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr179-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1656884 cached reads)
- Output: 8327 tokens
- Cost: $1.0802607999999996
- Wall-clock: 238s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
