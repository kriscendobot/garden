---
source: packages/netstring/reader.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/netstring/reader.js
source_path: packages/netstring/reader.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mathieu Hofman (prompted)
topics:
  - streams
  - patterns
  - captp
genre: §endo-source-comment-fragment
cycle: 177
lane: chat
status: current
title: §Sanity caps (defense-in-depth)
parent: endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk
---

```js
const maxPrefixLength = `${maxMessageLength | 0}:`.length;
```

§maxMessageLength-default-999999999 (~1 GiB).

§maxPrefixLength derived from maxMessageLength + 1 (for
the colon). §If-we've-accumulated-this-many-digits-the-
message-must-be-too-big-or-malformed.

§Two-level-cap: §reject-prefix-too-long-before-converting
+ §reject-length-too-large-after-converting.

§Defense-in-depth against §protocol-attacks: §a-malicious-
sender-sending-9999999999999999... never gets past the
prefix-length cap.

§Cycle-170's-daemon-capability-filesystem §threat-model-
with-citations has a sibling discipline: §defense-driven-
by-evidence. Here, §cap-the-attack-surface-before-the-
attack-arrives.
