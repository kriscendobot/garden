---
ts: 2026-06-03T01:24:19Z
kind: dispatch
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/fixer--765f0b
short_id: 765f0b
prs:
  - { repo: endojs/endo-but-for-bots, pr: 392, role: target }
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/392
---

# dispatch: fixer — #392 hack acknowledgment + file OCapN/Noise refactor follow-up

kriskowal CHANGES_REQUESTED on #392 inline:

> packages/gateway/src/ocapn-ws.js:293
> This is a hack. Consider the necessary OCapN or OCapN Noise
> Protocol refactor that would allow new sessions to be
> initiated with the already-read information rather than
> obliging them to replay the read.

The "hack" is the `prependFrame` first-frame replay pattern:
the gateway reads the first frame (SYN) to extract the
responder's public key prefix, then has to replay that frame
to the downstream daemon's transport. Cleanly fixing it
requires modifying OCapN/Noise to accept pre-read frames at
session init — protocol-level work affecting every OCapN-Noise
consumer, not just the gateway.

Response shape: acknowledge the hack characterization in a
code comment at line 293; file a follow-up issue on
endo-but-for-bots for the protocol refactor; leave the
prependFrame implementation in place for now.

No code logic change. One small comment + one issue. No
restacking needed (this layer's content doesn't change).
