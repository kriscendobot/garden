---
arc: endo-ocapn-background
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Designer job for endojs/endo-but-for-bots: revise the `ocapn-tcp-for-test-extraction` design on `llm` (now at f1e3065), because the build job stopped after finding the design overtaken. OCapN-Noise already skips the core handshake but still runs an encrypted `op:start-session` identity exchange, `@endo/ocapn-iroh` depends on the core handshake plus `verifyPeerLocation`, and merged #1071 introduced the multi-transport hint model. Rewrite the design so each network owns its identity exchange, sequence an Iroh migration before the core `op:start-session` fallback is removed, and update the plan record's status (the opt-in syrup framing for the TCP-testing netlayer has already landed as bdb9ddc50d).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-07T14:46:39Z
