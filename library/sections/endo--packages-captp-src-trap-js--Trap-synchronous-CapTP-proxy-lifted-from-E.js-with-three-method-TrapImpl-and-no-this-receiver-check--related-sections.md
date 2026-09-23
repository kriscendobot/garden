---
section: Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
source: endo--packages-captp-src-trap-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: Related sections
parent: endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
---

- cycle 146
  [[endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets]]
  — the *eventual-send* mirror that this file is lifted from.
  Same baseFreezableProxyHandler / funcTarget / objTarget;
  different dispatch shape (concise-method-syntax-with-this-
  check vs arrow-function).
- cycle 66
  [[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]]
  — the HandledPromise dispatch protocol that E.js routes
  through. Trap routes through a different channel
  (Atomics-based).
- cycle 108
  [[endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio]]
  — same coordinated-update commit `e56bf00f` (@endo/harden
  migration). The cluster grows to 16 files.
- cycle 119
  [[endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting]]
  — the daemon-side §pattern of *same envelope verbs whether
  in-process or cross-process*, which this file's §local-
  fast-path-via-trivial-impl mirrors at the user-facing
  proxy layer.
