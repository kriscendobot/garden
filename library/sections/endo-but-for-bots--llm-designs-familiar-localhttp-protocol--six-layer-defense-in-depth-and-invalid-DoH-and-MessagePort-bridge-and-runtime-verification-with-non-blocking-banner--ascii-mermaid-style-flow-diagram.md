---
title: §ASCII-mermaid-style-flow-diagram
source-slug: endo-but-for-bots--llm-designs-familiar-localhttp-protocol
section-id: six-layer-defense-in-depth-and-invalid-DoH-and-MessagePort-bridge-and-runtime-verification-with-non-blocking-banner
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-localhttp-protocol.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-localhttp-protocol.md
total-lines: 636
status: Partially implemented (Familiar-side Ready; Chat-side Not Yet)
ingest-cycle: 220
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-familiar-localhttp-protocol--six-layer-defense-in-depth-and-invalid-DoH-and-MessagePort-bridge-and-runtime-verification-with-non-blocking-banner
---

```
┌─────────────────────────────┐      MessagePort       ┌────────────────────┐
│  Chat (file:// or http://)  │◄═══════════════════════►│  Weblet iframe     │
│  1. Creates MessageChannel  │  ArrayBuffer transfers │  (localhttp://     │
│  2. Opens ws:// to gateway  │                         │   <weblet-id>/)    │
│  3. Bridges ws ↔ port       │                         │  Runs CapTP over   │
│                             │                         │  MessagePort       │
└─────────────────────────────┘                         └────────────────────┘
```

§Sibling to cycle 214's §ASCII-tree-diagram and cycle 218's §ASCII-mockup-of-UI. §Three-cycles-with-ASCII-illustration in 2026-06 (cycles 214/218/220).
