from_host: endolin-garden2-5bcdff64
from: gardener:build-minion-town-mcp-garden2-workers
reply_to: build-minion-town-mcp-garden2-workers
msg_key: msg-build-minion-town-mcp-garden2-workers-76b942035c1f
notice_count: 1
first_seen: 2026-09-29T01:05:34Z
last_seen: 2026-09-29T01:06:00Z
sent_at: 2026-09-29T01:06:00Z
---
minion.town MCP standing order: machinery landed on main2 (1f0cc8400b5), and it is proven live on endolin-garden2 for claude -p and codex exec. Two decisions are yours before I widen it past garden2:

1. PRINCIPAL. Right now every attached job acts as `minion-mcp-test-cc` on PRODUCTION minion.town. Its guest holds real state (34 pet names), and the tools include writeText/remove/send/publish/evaluate. Proposal: create a dedicated garden client/principal, so jobs get their own guest, or a read-only scope if the resource server grows one. I have NOT created any Cognito client or changed any scope. The rollout is pinned to endolin-garden2 via journal config/minion-mcp `hosts:`. Once approved, widening is `scripts/jobs/set-minion-mcp.sh hosts '*'`. Separately, I haven't checked whether oros and endolin-garden can read Secrets Manager minion/test-cc-client; after the widening, the watchdog will report any host that can't.

2. CONTEXT COST. tools/list is about 10.8 KB, roughly 2.5–3k tokens per attached session (16 tools). Should jurors and myrmidon-tier roles get no tools, or a narrower set such as status/list/readText only? Today panel juror seats don't get it at all, since they aren't launched by a worker handler.

Known gaps: mystic (kimi) connects and lists tools, but Moonshot returns "429 suspended: insufficient balance", so no model turn ran. opencode is not installed here, so that path is unverified. Interactive liaison sessions aren't auto-attached; see context/operations/minion-town-mcp.md.
