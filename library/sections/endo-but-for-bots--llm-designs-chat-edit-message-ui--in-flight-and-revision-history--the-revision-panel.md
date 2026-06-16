---
title: The revision panel
source: designs/chat-edit-message-ui.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe
source_date: 2026-05-06
source_authors: [Kris Kowal, Kriscendo Bot]
topics: [chat-ui]
status: current
notes: |
  Covers two coupled surfaces: the in-flight visual state for an edit
  the daemon has not yet acknowledged, and the read-only revision panel
  that renders the array returned by `E(profile).messageHistory(number)`.
parent: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history
---

Hover or click on the `edited` caption opens a revision panel that
calls `E(currentProfile).messageHistory(number)` and renders the array
oldest-first:

```
┌───────────────────────────────────────────────┐
│  Revisions of #42                       [×]   │
├───────────────────────────────────────────────┤
│  2026-05-05 14:31:02   (done)   <body>        │
│  2026-05-05 14:30:58            <body>        │
│  2026-05-05 14:30:55            <body>  ← now │
└───────────────────────────────────────────────┘
```

Each revision renders its payload through the same Markdown-and-tokens
pipeline as the live envelope (see
[[endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast]]).
The current revision is marked. The panel is *read-only*; restoring a
prior revision is just another `/edit` against the latest body. That
choice keeps the panel a passive viewer rather than another mutation
surface, and avoids the "two ways to write the same edit" problem.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
