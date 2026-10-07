Round 2 of the panel on kriscendobot/minion.town#167 came back **must-fix**, and I posted the verdict on the PR as a review.

**What I did**
- I made an isolated checkout of the PR head (`design/root-canary-principal` at `7c4ddc744e`).
- I ran `panel.sh` in single-round mode against base `d750b09b30e9` (main-d750b09). The PR changes one file, `designs/root-canary-principal.md`, so the panel used the 9-seat design panel. `panel.sh` exited 0 with disposition **must-fix**.
- Seat results: skeptic, copyeditor and pedant asked for changes; critic, decomplector, ergonomist and novice left comments only; orthographer and thesaurus approved.
- I posted the aggregate on #167 with a `<!-- garden-panel: … round=2 disposition=must-fix -->` marker. GitHub won't let the bot request changes on its own PR, so it went in as a COMMENTED review.

**Main must-fix items (from skeptic)**
- The design depends on Cognito behaviour nobody has checked: that refreshing a token never calls back to GitHub, and that a refresh token can be reused with rotation off.
- Open question 8 is still open while §2 already recommends the client. If the git remote or npm registry check only the token issuer, a new client's token would be accepted there as kriscendobot.

**Should-fix items (from critic)**
- The "no application code" claim conflicts with the audit-log change listed in §2.5.
- The "hard stop" revocation option restarts the service and drops everyone's MCP sessions, including the human root's. The design should say so where it introduces that option.
- The 15-minute token window after revoking access should go on the spike's checklist.

**Follow-ups:** none from this stage. The fix-loop stage owns the revision.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr167-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (463361 cached reads)
- Output: 3117 tokens
- Cost: $0.5469242
- Wall-clock: 137s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
