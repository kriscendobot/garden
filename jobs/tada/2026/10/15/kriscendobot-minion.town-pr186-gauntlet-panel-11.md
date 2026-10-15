Panel round 11 for kriscendobot/minion.town#186 is done and its verdict is posted. The verdict is **must-fix**.

**What I did**
- Checked out PR head `1c7abcd` (`build/root-canary-principal`) into a separate worktree for this job.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 186 main-e3ffcbb`. It exited 0 with disposition `must-fix` and recorded the run at `panel-runs/kriscendobot-minion.town-186/da567e6aabc4.md`.
  - All 34 seats returned verdicts: 11 approve, 20 comment only, 3 request changes (decomplector, integrator, pruner).
  - The decomplector was seated because the PR adds a new mechanism, and it was also asked whether that mechanism is needed at all. The two previous rounds both raised must-fix on the same mechanism.
- Posted the verdict on the PR as a COMMENTED review at 2026-10-15T22:09:09Z. GitHub won't let the bot request changes on its own PR, so the review's title states must-fix, matching earlier rounds.
  - The full report is 88KB, more than one review can hold. The rest of the per-seat reports went in a follow-up PR comment (issuecomment-6203302085).

**Must-fix findings**
1. **Decomplector:** `refreshRootToken` checks every refreshed token against the identity pool's signing keys. That repeats the check in `src/auth/verifier.ts`. It also adds two failure reasons (`mismatched`, `unreachable`) to the design's fixed list of three (`missing|unreadable|refused`, § 2.6), and the design and PR body still say three. The fix is to drop the per-refresh check, or to update § 2.6 to explain why the helper checks again.
2. **Integrator:** the evidence list in the PR body still cites the `.sh` scripts that `1c7abcd` replaced with `.mjs` files.
3. **Pruner:** several added comments only restate the code next to them, and two DEPLOYMENT.md tables repeat what the design already specifies.

**Follow-ups**
- **Decision for the maintainer:** the design said the build stops at the verification spike, but this PR builds items 1–5 before the spike has run and rewrites the design's status line to match. If the spike fails, the design's fallback is to stall, which would strand that work. Someone should confirm that building ahead of the spike was intended.
- **Should-fix items (lower priority):**
  - In `root-canary-mint.mjs`, the error path doesn't clear the 10-minute callback timer.
  - The commit history should be regrouped so the "address round N panel review" commits don't reach the merge history.
  - A test comment at `test/root-canary-scripts.test.ts:98` says "runs it under node", but the helper it writes is bash.
- The bot's GitHub REST quota was used up during this run. The review still went through.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-panel-11.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1007836 cached reads)
- Output: 6086 tokens
- Cost: $0.8128472000000001
- Wall-clock: 322s

<!-- garden-usage-end -->
