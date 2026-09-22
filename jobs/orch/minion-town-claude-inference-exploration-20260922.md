---
child-build-minion-town-claude-agent-sdk-inference-20260922-failure-notified: true
child-build-minion-town-claude-agent-sdk-inference-20260922-host: endolin-garden2-5bcdff64
child-build-minion-town-claude-cli-inference-20260922-host: endolin-garden-ece02cb4
order: parallel
children: build-minion-town-claude-cli-inference-20260922 build-minion-town-claude-agent-sdk-inference-20260922
on-child-failure: continue
state: running
created_by: producer
created_at: 2026-09-22T00:34:07Z
---

# Explore Claude CLI vs Agent SDK inference inside minion.town (item 4 redirect)

Executes kriskowal's 2026-09-22 00:21Z direction on
https://github.com/endojs/endo-but-for-bots/pull/1228: implement the item-4 "unconfined
caplet that shells out to Claude" **tentatively within minion.town**, exploring the Claude
CLI and the Claude Agent SDK **concurrently**, learning from production use, then back-filling
and solidifying the Endo design later.

Two independent tracks, run in **parallel**, each a gap-revealing draft PR that shares one
swappable inference-backend seam so the two can be compared in production:
- `build-minion-town-claude-cli-inference-20260922` — the `claude -p --bare` CLI backend.
- `build-minion-town-claude-agent-sdk-inference-20260922` — the Claude Agent SDK backend.

Failure policy: continue (the tracks are independent; one failing must not halt the other).
