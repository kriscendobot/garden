---
section: monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
source: metamask-ocap-kernel--overview
topics: [daemon, captp, persistence]
status: current
title: Related sections
parent: metamask-ocap-kernel--overview--monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
---

- cycle 119
  [[endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting]]
  — the Endo daemon's *capability-bus* is the transport
  layer; ocap-kernel's kernel/vat/channel architecture sits on
  top of an analogous wire substrate.
- cycle 137
  [[endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls]]
  — the §cross-peer-streams-ride-CapTP observation parallels
  ocap-kernel's `BaseDuplexStream` channel substrate.
- cycle 149
  [[endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback]]
  — the §error-path-cannot-depend-on-error-path insight is
  the same family of concern as Ken's output-validity property.
- cycle 156
  [[endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability]]
  — the §weak-value-map for CapTP slot tables; ocap-kernel
  uses *clist* for the analogous role.
- cycle 144
  [[endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap]]
  — Endo's revocation-via-membrane; ocap-kernel has explicit
  `revoke(kref)` on the kernel API.
- cycle 108
  [[endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio]]
  — Endo's exo factory; ocap-kernel wraps this in
  `@metamask/kernel-utils/exo` `makeDefaultExo` (per AGENTS.md
  `Do not use Far from @endo/far`).
