---
arc: endo-ocapn-background
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design step for endojs/endo-but-for-bots, plan design `ocapn-tcp-for-test-extraction` (M4, no dependencies, no existing job or PR). Write the design that moves the `op:start-session` handshake out of OCapN core (`packages/ocapn/src/client/handshake.js`) into a TCP-for-test network, so OCapN-Noise doesn't run a redundant handshake.
