---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In endojs/endo-but-for-bots (branch `llm`), investigate and fix the AVA 8 snapshot-writing bug. Under SES lockdown, AVA 8 writes corrupt `.snap` files because cbor2 encodes a `Uint8Array` as a map. The previous job, `endo-but-for-bots-ocapn-noise-session-reconnect-build`, worked around it by patching `node_modules` locally. Find a committed, repeatable fix or workaround so snapshot updates work in this repo without local patching, and verify it by updating a snapshot.

<!-- garden-productive-cycle -->
<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-16T18:59:51Z
