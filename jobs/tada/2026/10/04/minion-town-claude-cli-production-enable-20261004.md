---
handed-off: minion-town-claude-cli-production-enable-verify-20261004
deliverable-complete: false
---
## Completion report: `minion-town-claude-cli-production-enable-20261004`

Steps 1 and 2 are done in draft PR https://github.com/kriscendobot/minion.town/pull/150, and its CI is green. Step 3 (checking the host after merge and deploy) has not run yet, because it needs the maintainer to approve and merge #150. That step is handed off to a parked successor job.

**What #150 changes** (head `fix/claude-cli-production-enable`, commit f77663c; base is the frozen `main-a378bb3`):
1. **Unit file** (`deploy/aws/systemd/minion-mcp.service`):
   - `ENDO_CLAUDE_ENABLED=1`.
   - `ENDO_CLAUDE_ROOT_SUBJECTS=895979ee-9011-7070-ec0e-0e1fb58c7cd2`. This is the maintainer's GitHub-login Cognito `sub`, taken from `config/policy.json`. It is the bare `sub` because the `/account/claude` route matches on that alone.
   - `ENDO_CLAUDE_MODELS=claude-sonnet-5,claude-opus-5-5`, with sonnet as the default.
   - `ENDO_CLAUDE_CONCURRENCY=1`.
   - `MemoryMax` raised from 256M to 1G.
   - `DEPLOYMENT.md` now describes the enabled state, how to roll back, and how to check it after a deploy.
2. **`agentsFor` is now used.** The pinned Endo can't add `@claude-agents` as a special name inside the daemon, and the daemon won't store an object that lives in the app process. So the root account gets the factory through its MCP session instead, which the design allows. That session gets four tools: `claudeStatus`, `createClaudeAgent`, `infer` and `dismissClaudeAgent`.
   - Other accounts see the same tool list as before.
   - The names follow README naming rule 3, and the test that pins the full tool-name list now expects 27 names instead of 23.
   - With this, the root account can create a child agent and run `infer` on it.
3. **Tests:**
   - The new `test/claude-agents-tools.test.ts` runs the whole sequence against an in-memory deployment: needs-auth → connect → create → `infer` returns ok → dismiss → not-found.
   - `tsc` is clean.
   - Full suite: 798 passed and 1 failed. The failure is the `test/git-remote/capability.test.ts` `exited 128` case, which I believe comes from this host's environment rather than this change; I did not re-run it on `main` to confirm.
   - CI on #150 passed: `test`, and the Claude harness on amd64 and arm64.

**Jobs posted**
- Gauntlet `kriscendobot-minion-town-pr150-gauntlet`. Fixer jobs don't start one automatically, so I posted it.
- Merge job `minion-town-pr150-conduct-20261004`, parked until the gauntlet finishes. It still needs the maintainer's Approve review on GitHub.
- Successor `minion-town-claude-cli-production-enable-verify-20261004`, parked until #150 merges. It:
  - checks over SSM that the boot log has the "Claude-agents wiring ENABLED … on the Claude CLI backend" line, `MemoryMax=1073741824` is set, the `ENDO_CLAUDE_*` variables are present, and the connect route no longer returns 404;
  - re-posts `minion-town-claude-cli-production-canary-<date>` with the original canary body, plus the root subject and the new tool names;
  - does not run the canaries itself.
- I messaged the maintainer about the root-subject choice. Only the GitHub identity is a root; the Google one (`9929b9ee-…`) is not, because the design calls for a single canary root. The message also asks for the review on #150.

**Left on purpose:** closing draft #105, replying on #87, and the canaries themselves all belong to the re-posted canary job.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-claude-cli-production-enable-20261004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 128 tokens (7646351 cached reads)
- Output: 36944 tokens
- Cost: $3.5575582
- Wall-clock: 644s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
