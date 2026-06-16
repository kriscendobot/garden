---
source: packages/lp32/{reader,writer}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/lp32
source_path: packages/lp32/reader.js, packages/lp32/writer.js, packages/lp32/src/host-endian.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - streams
  - captp
genre: §endo-source-comment-fragment
cycle: 179
lane: chat
status: current
title: §maxMessageLength-1MB-default (matches WebExtension max)
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

```js
maxMessageLength = 1024 * 1024, // 1MB
```

§Both-reader-and-writer-default to 1 MiB. §This-is-the-
Chrome/Firefox-native-messaging-limit. §Chrome's-limit-is-1MB-
sent-from-extension-to-host-and-1MB-the-other-way; Firefox's
match. §Endo's-defaults-honor-the-spec.

§Configurable-per-instance: callers can raise the limit for
non-WebExtension uses of the protocol (intra-Endo daemon IPC
on stdio, for example).

§Reader-enforces-the-limit-before-allocating-the-envelope:

```js
messageLength <= maxMessageLength ||
  Fail`Messages on ${q(name)} must not exceed ${q(
    maxMessageLength,
  )} bytes in length`;
```

§DOS-protection. §A-malformed-or-malicious-sender-cannot-
trigger-a-multi-GB-allocation by claiming a giant length. §The-
check-runs-before-the-`envelopeLength`-computation, so a
length of 0xFFFFFFFF is rejected on its own merits without
overflowing into envelopeLength arithmetic.

§Writer-enforces-the-same-limit:

```js
message.byteLength <= maxMessageLength ||
  Fail`Messages on ${q(name)} must not exceed ${maxMessageLength} bytes in length`;
```

§Symmetric-enforcement. §A-misbehaving-Endo-caller-cannot-
send-a-message-the-decoder-would-reject. §Cycle-127-
getGuardPayloads named the §spec-driven-discipline; lp32 has
§spec-driven-symmetric-validation.
