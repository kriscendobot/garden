---
source: packages/harden/make-selector.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/harden/make-selector.js
source_path: packages/harden/make-selector.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 175
lane: chat
status: current
title: Race to install harden at Object @harden with three-tier lookup and pin on first install
parent: endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install
---

> §Chat-lane after cycle 174's designs-lane. §Endo-source-
> comment-fragment genre. **§Cycle-108's-coordinated-update-
> commit-e56bf00f-anchor**: the §adopt-@endo/harden
> discipline that triggered the 15-file e56bf00f cluster
> (cycles 108/110/115/118/123/125/132/134/138/140/144/167/
> 169/171/173) traces back to this file's selector.

`packages/harden/make-selector.js` (69 lines) implements
the **§race-to-install-harden-at-a-well-known-slot**
mechanism. The single most structurally interesting move
is the **§three-tier-lookup** (`Object[@harden]` →
`globalThis.harden` → fresh make) that lets multiple
harden implementations coexist while §pinning-the-first-
to-arrive.
