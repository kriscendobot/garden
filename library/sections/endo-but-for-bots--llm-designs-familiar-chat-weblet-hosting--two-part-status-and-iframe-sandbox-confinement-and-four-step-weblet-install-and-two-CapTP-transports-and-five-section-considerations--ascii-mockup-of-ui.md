---
title: §ASCII-mockup-of-UI
source-slug: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting
section-id: two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-chat-weblet-hosting.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-chat-weblet-hosting.md
status: Not Started (with ready Familiar-side infrastructure)
ingest-cycle: 218
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-familiar-chat-weblet-hosting--two-part-status-and-iframe-sandbox-confinement-and-four-step-weblet-install-and-two-CapTP-transports-and-five-section-considerations
---

```
┌──────────────┬──────────────────────────────────┐
│  Inventory   │                                  │
│  ──────────  │                                  │
│  Handles     │                                  │
│  Hubs        │        Weblet iframe             │
│  Everything  │    (localhttp://<id>/ or         │
│              │     http://<id>.localhost:port/) │
│  Inbox       │                                  │
│  ──────────  │                                  │
│  Messages... │                                  │
│              │                                  │
│  Chat input  │                                  │
└──────────────┴──────────────────────────────────┘
```

§ASCII-mockup-of-the-target-UI inside the design. §Borrowable-pattern: §the-ASCII-mockup-shows-the-target-shape; §the-iframe-src-format is shown inline with §two-named-options (localhttp:// in Familiar OR http://<id>.localhost:port/ in development) — §two-environments-with-different-URL-conventions.

§Sibling to cycle 214's §ASCII-tree-diagram of branching transcripts — both designs §use-ASCII-for-shape-illustration.
