---
source: packages/captp/src/atomics.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/captp/src/atomics.js
source_path: packages/captp/src/atomics.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - captp
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 169
lane: chat
status: current
title: §Pairs-with-cycle-154's-trap.js
parent: endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator
---

§Trap.js-defines-TrapHost-TrapGuest-as-abstract-interface.
§Atomics.js-is-the-SharedArrayBuffer-implementation. §Two-
paired-files-implementing-one-mechanism.

§Cycle-154-noted: trap.js was *lifted from E.js* and
represents the abstract synchronous-trap protocol. This
file is the §concrete-transport for that protocol.

§Abstract-then-concrete pattern: §types-and-interface-
first; §implementation-after. The trap.js file is much
shorter (the interface); atomics.js is longer (the
mechanism). §Inverted-from-typical (where interface is
verbose and implementation is short) because the protocol
is simple but the SharedArrayBuffer wire-format needs
careful bookkeeping.
