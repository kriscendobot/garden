---
arc: endo-ocapn-background
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Builder job for endojs/endo-but-for-bots, implementing the M4 design `ocapn-tcp-for-test-extraction` on a frozen `llm-<sha>` base as a draft PR. Move `op:start-session` out of OCapN core (`packages/ocapn/src/client/handshake.js`, still present on `llm`) into the tcp-for-test netlayer, so that networks that authenticate themselves, such as OCapN-Noise, no longer inherit that handshake. First check the design against current `llm`, the merged #1071 one-hint-per-transport design, and the open #684 Noise adapter. If either has already overtaken the design, stop and report that instead of building.
