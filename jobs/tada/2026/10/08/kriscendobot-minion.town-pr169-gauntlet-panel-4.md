## Panel round 4: kriscendobot/minion.town PR #169: must-fix

I ran one single-round code panel on head `8040303` against base `d750b09`. I used the PR's `baseRefOid`, and the changed-file list matched GitHub's six files. `panel.sh` exited 0 and gave the disposition **must-fix**. All 32 seats completed: 3 request-changes, 14 comment-only and 15 approve.

The verdict is posted as review https://github.com/kriscendobot/minion.town/pull/169#pullrequestreview-5450180879. It went up as COMMENTED because GitHub doesn't let the bot request changes on its own PR. The body starts with a `disposition: must-fix` header and ends with the `<!-- garden-panel: … round=4 disposition=must-fix -->` marker. It includes every request-changes and comment-only seat in full. GitHub limits a review body to about 65K characters, so 10 approve-seat sections were left out and the review lists them by name.

**Changes since round 3:** the round-3 must-fix (the CD writer that rendered the guest-recovery key) has been removed at this head. The decomplector seat confirms that the remaining read-only check, run before the app restarts, is the smallest piece that keeps the running app up. What's left is mostly about the PR's title and description.

**Must-fix:**
- **integrator:** the PR title still says the key is rendered "in CD", but that CD step was removed and the title will become the merge commit's log line. It should be retitled, for example `fix(deploy): preflight GUEST_RECOVERY_KEY before deploy-app restarts minion-mcp`.
- **pruner:** the PR description is too long. Cut the "no CD writer" history to one line and replace the list of test cases with a link to `test/deploy-secret-preflight.test.ts`.

**Should-fix (not blocking):**
- **stylist:** the function and variable names (`minion_mcp_secret_*`, `MINION_MCP_SECRET_FILE`) say "secret" generically, but the code checks only the one guest-recovery key.
- **decomplector:**
  - `minion_mcp_secret_fetch` is a leftover test hook, and its comment ("Tests redefine it") is no longer true.
  - Two patterns state the same length and character rule.
  - `ACCOUNT_GATE_SHARED_SECRET` is still only checked after the restart.
- **integrator:** the commit history adds the CD writer and then removes it; squash that into one or two logical commits.
- **typist:** a touched comment still has a `→`; use `->`.

I changed no garden files and made no edits to the project; the fix stage is owned by the next gauntlet stage. I deleted the scratch panel run directory.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (612564 cached reads)
- Output: 5161 tokens
- Cost: $0.6896367999999999
- Wall-clock: 219s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
