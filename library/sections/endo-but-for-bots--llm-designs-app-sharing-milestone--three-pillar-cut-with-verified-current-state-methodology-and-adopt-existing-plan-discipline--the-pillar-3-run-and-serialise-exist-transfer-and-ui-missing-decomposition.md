---
section: three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline
source: endo-but-for-bots--llm-designs-app-sharing-milestone
topics: [daemon, agent-conventions, chat-ui]
status: current
title: The §Pillar-3-run-and-serialise-exist-transfer-and-UI-missing decomposition
parent: endo-but-for-bots--llm-designs-app-sharing-milestone--three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline
---

Pillar 3 is the *richest pillar*. §two-Complete-and-two-
Missing:

- **Complete**: `@endo/endo-fs` Filesystem caps + FsBackend
  seam; `@endo/endo-fs-exec` `tree-view-module.js` →
  `make-from-tree` formula → compartment-mapped
  `make(powers, context, { env }) => exo`. **This is the run
  mechanism.**
- **Complete**: `readable-tree` / `readable-blob` formulas;
  `endo checkin` / `endo checkout` (tree ⇄ fs, zip via
  `-z`). Per-app origin isolation + CSP in Familiar.
- **Missing**: An app handle bundling source + exec + UI.
- **Missing**: Cross-daemon clone (remote-ref vs independent
  copy, shipped as one streamed tree-archive into a pluggable
  durable backing).
- **Missing**: The app-facing partially-sandboxed UI layer.

The three missing pieces are owned by the §new designs
[endo-app-sharing](endo-app-sharing.md),
[familiar-app-ui-hosting](familiar-app-ui-hosting.md)
(= cycle 143's design), and the underlying weblet-hosting
substrate (familiar-unified-weblet-server / familiar-chat-
weblet-hosting / daemon-weblet-application).
