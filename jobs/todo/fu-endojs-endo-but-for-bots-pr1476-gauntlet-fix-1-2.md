---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In endojs/endo-but-for-bots, PR https://github.com/endojs/endo-but-for-bots/pull/1476, fix the should-fix items left from the gauntlet fix round. Rename `peerAckedRecvNonce`. Type the heartbeat read/write helpers instead of using `any`. Bound the `inbound` queue. Check the peer's acknowledged nonce against what this side actually sent.
