Panel round 4 on endojs/endo-but-for-bots#1406 came back **must-fix**. I posted the verdict and am stopping here, as this stage requires: no fixes, no un-draft.

**What ran:** the single-round panel against PR head `ae036d0535` (branch `bot/build/claude-pinned-cli-bump`), using base `llm-d4124e6` at `d4124e6e40`. I passed the base SHA rather than the branch name because the base is a frozen branch. The panel exited 0 with a must-fix verdict. Of 33 seats, 1 requested changes (breaker), 12 left comments only and 20 approved.

**Verdict posted:** review 5393784557, https://github.com/endojs/endo-but-for-bots/pull/1406#pullrequestreview-5393784557. It's posted as COMMENTED, like rounds 1–3, and begins with `<!-- garden-panel-verdict: must-fix round=4 head=ae036d05… -->`. The full aggregate was 70 KB, over GitHub's review size limit, so the review lists approving seats by name only and includes the full text of the 13 other seats.

**Must-fix items for the next fix stage:**
1. **Extra values slip past the flag checks** (`packages/claude/src/argv.js`). `--tools` and `--mcp-config` take several values per flag, but the checks only catch the flag being repeated. The breaker confirmed this against the real `claude@2.1.280` binary:
   - `--tools "" Bash` re-enabled the Bash tool.
   - `--mcp-config legit.json attacker.json` made the CLI load a second config.

   `assertConfinedArgv` accepts both argvs. The fix is to require that the token after each checked value is absent or starts with `--`, plus tests that insert a bare extra value.
2. **Decorative banner comment** at `packages/claude/test/argv.test.js:145`; change it to a plain comment.

**Recommended in the same pass:**
- Make `--mcp-config` required: a missing one is currently accepted, though that gap predates this PR.
- Correct the "six required flags" count in the docs and comments.
- Cite or soften the "last flag wins" claim about the CLI.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-pinned-cli-bump-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (898810 cached reads)
- Output: 5105 tokens
- Cost: $0.84343
- Wall-clock: 542s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
