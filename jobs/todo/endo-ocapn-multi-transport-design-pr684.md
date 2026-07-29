---
role: designer
---

# Design OCapN multi-transport connection hints before resuming PR 684

Repository: https://github.com/endojs/endo-but-for-bots
Context: https://github.com/endojs/endo-but-for-bots/pull/684#pullrequestreview-4803347200

Design the prerequisite OCapN refactor so a Noise Protocol Network (.np) publishes connection hints for multiple transports and can listen separately on WebSocket and TCP+CBOR-frame ports. Identify the target API and migration plan. Keep PR 684's WebSocket transport work deferred until this design/refactor provides that surface.
