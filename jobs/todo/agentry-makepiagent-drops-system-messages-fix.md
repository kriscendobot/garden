---
posted_at: 2026-11-03T03:28:39Z
arc: moonshots
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: fixer.** Repo endojs/endo-but-for-bots, base `llm` (pin per frozen-base-branch; open a DRAFT PR through ensure-pr.sh).

`makePiAgent` in `packages/agentry/src/harness/pi-agent.js` appears to send no system prompt and no tools to the provider on pi-agent-core 0.87.

Pi 0.87 keeps the system prompt and the tool declarations in `state.messages` as a leading `role: 'system'` message (`createInitialSystemMessage`). The harness's `defaultConvertToLlm` keeps only `user`, `assistant`, and `toolResult`, so that message is filtered out before the request. Upstream's default filter in pi-agent-core `dist/agent.js` keeps `system` too.

Evidence from llm at 48d6f3e, using `makePiAgent` with `systemPrompt: 'SYS'`, one tool, and a scripted stream function:
- `agent.state.messages` before the prompt: roles `['system']`, `toolsAdded: ['probeTool']`.
- Context the stream function received: keys `['messages']`, roles `['user']`, `tools` undefined.
- A `spawnWorkerLoop` run against a local fake OpenAI-compatible endpoint also sent only `user` messages.

Confirm this through a real provider adapter and find which Pi bump introduced it. Fix the filter, and check other `makePiAgent` callers and any custom `convertToLlm`, including `define-agent.js`. Add a regression test that the request carries the system prompt and tools. The likely impact is that Lal workers cannot call tools, so treat this as high priority.

Found while building `endopi-iterative-compaction-build`, whose code neither causes nor depends on this.
