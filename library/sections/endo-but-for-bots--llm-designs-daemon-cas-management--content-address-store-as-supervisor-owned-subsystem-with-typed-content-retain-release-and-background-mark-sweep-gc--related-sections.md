---
section: content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
source: endo-but-for-bots--llm-designs-daemon-cas-management
topics: [daemon]
status: current
title: Related sections
parent: endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
---

- cycle 119
  [[endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting]]
  — the daemon-as-message-router design that this CAS design
  rides on. The CAS verbs are control messages (handle 0)
  routed through cycle 119's envelope protocol.
- cycle 78
  [[endo-but-for-bots--llm-designs-daemon-content-store-gc--sweep-time-refcount-and-mount-cleanup]]
  — the *superseded* JS-side GC design this Rust CAS replaces.
- cycle 113
  [[endo-but-for-bots--llm-designs-familiar-daemon-bundling--esbuild-single-file-bundle-with-side-effect-mitigations]]
  — the Familiar bundling whose §worker-resolve-relative-to-
  bundle-location idiom uses XS snapshot files (now typed CAS
  entries per this design's §integrates-with-snapshot).
- cycle 137
  [[endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls]]
  — the §streaming-variants `cas-store-stream` and
  `cas-content-stream` echo the §streaming-on-CapTP discipline.
