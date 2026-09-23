---
source: designs/hex-package.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/hex-package.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
status_at_ingest: Complete
genre: §endo-but-for-bots-design §canonical-leaf-package-pattern
cycle: 180
lane: designs
status: current
title: §Boundary-sites-explicitly-named-and-defended
parent: endo-but-for-bots--llm-designs-hex-package--ponyfill-with-native-fallthrough-cloned-from-base64-skeleton-and-design-after-implementation
---

Five sites are not migration targets despite using hex:

- `daemon/src/daemon-node-powers.js` line 309 — `digester.digest('hex')`
- `daemon/src/daemon-node-powers.js` line 319 — `randomHex256` via Node `crypto.randomBytes(n).toString('hex')`
- `check-bundle/index.js` line 14 — `hash.digest().toString('hex')`
- `compartment-mapper/src/node-powers.js` lines 162-168 — `hash.digest().toString('hex')`
- `cli/src/random.js` line 9 — `bytes.toString('hex')`

§Design-Decision-4-defends-this: "Forcing them through @endo/hex
would add a Uint8Array allocation without clarity benefit." §The-
policy-named: inside SES-locked compartments and platform-
agnostic code, use @endo/hex; at the Node powers boundary, use
whatever the `crypto` API gives you.

§This-is-§don't-pessimize-the-boundary discipline. §Compare-to-
cycle-167-where/index.js' §platform-fallback-chain that
deliberately uses platform-native conventions at the boundary
rather than forcing portability.
