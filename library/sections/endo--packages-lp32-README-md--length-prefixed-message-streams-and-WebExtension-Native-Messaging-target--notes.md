---
title: Notes
section-slug: endo--packages-lp32-README-md--length-prefixed-message-streams-and-WebExtension-Native-Messaging-target
source-slug: endo--packages-lp32-README-md
url: https://github.com/endojs/endo/blob/master/packages/lp32/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/lp32/README.md
total-lines: 136
ingest-cycle: 315
ingest-date: 2026-06-11
lane: designs
scope: full
parent: endo--packages-lp32-README-md--length-prefixed-message-streams-and-WebExtension-Native-Messaging-target
---

- The named-WebExtension-Native-Messaging-IS-named-target-protocol IS a structurally important pattern: when implementing an external protocol, name the protocol explicitly + link to its spec. Without this, future maintainers and reviewers have to reverse-engineer "why this byte format?"
- The named-host-byte-order-IS-named-deliberate IS unusual; most network protocols use big-endian (network byte order). Host byte order indicates the protocol IS for same-host process communication (WebExtension Native Messaging IS browser-to-native-host on the same machine). **§the-named-protocol-target-determines-byte-order-discipline**.
- The named-worked-byte-sequence-example (`[0x05, 0x00, 0x00, 0x00] [h, e, l, l, o]`) IS pedagogically strong: a reader can verify the protocol works as described by counting bytes. The little-endian convention IS implicit in the example.
- The named-three-named-Reader-options (name + maxMessageLength + initialCapacity) IS a deliberate API shape: required positional argument + optional configuration object. Cycle 311's nat README named seven-named-input-examples-per-function (the pure value examples); cycle 315 names three-named-Reader-options (the configuration values). **§two-named-shapes-of-named-API-input-naming**.
- The named-pivot-IS-named-productive-six-cycles-in: with cycles 310-315 all @endo/* sources, the pattern surface has stayed fresh. The cluster has now ingested two source-and-README pairs (nat + memoize), one source (hex encode), and one README (lp32). The remaining hex decode + lp32 source could complete two more pairs.
