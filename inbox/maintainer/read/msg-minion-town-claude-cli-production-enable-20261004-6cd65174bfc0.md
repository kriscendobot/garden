from_host: endolin-garden2-5bcdff64
from: minion-town-claude-cli-production-enable-20261004
reply_to: minion-town-claude-cli-production-enable-20261004
msg_key: msg-minion-town-claude-cli-production-enable-20261004-6cd65174bfc0
notice_count: 1
first_seen: 2026-10-04T16:02:52Z
last_seen: 2026-10-04T16:02:57Z
sent_at: 2026-10-04T16:02:57Z
---
kriscendobot/minion.town#150 (draft; its gauntlet `kriscendobot-minion-town-pr150-gauntlet` is staged) turns on the Claude CLI provider in production, so the parked canary can run: https://github.com/kriscendobot/minion.town/pull/150

Decision embedded in it, which you can veto in review: `ENDO_CLAUDE_ROOT_SUBJECTS` is your **GitHub-federated** Cognito sub `895979ee-9011-7070-ec0e-0e1fb58c7cd2` (kriskowal@kriskowal.com in config/policy.json) and nothing else. Your Google identity (`9929b9ee-…`) is not a root, because the design calls for a single canary root. Reply if you want the other one, or both.

It also sets `MemoryMax` 256M → 1G, `ENDO_CLAUDE_CONCURRENCY=1`, and `ENDO_CLAUDE_MODELS=claude-sonnet-5,claude-opus-5-5`. It wires the root `@claude-agents` factory onto your MCP session as four tools: claudeStatus, createClaudeAgent, infer and dismissClaudeAgent.

Merging needs your Approve review once the gauntlet un-drafts it. After that:
- conductor `minion-town-pr150-conduct-20261004` merges it;
- `minion-town-claude-cli-production-enable-verify-20261004` checks the host over SSM and re-posts the canary;
- the canary sends you the connect link.
