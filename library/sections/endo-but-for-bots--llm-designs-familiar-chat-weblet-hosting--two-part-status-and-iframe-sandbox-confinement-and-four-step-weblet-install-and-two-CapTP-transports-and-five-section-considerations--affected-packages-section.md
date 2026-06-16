---
title: §Affected-packages section
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
- `packages/chat`    — weblet panel UI, install flow, iframe hosting, commands
- `packages/daemon`  — may need a combined "create guest + install weblet" API
                       for atomicity
```

§Borrowable-pattern: §Affected-Packages-section with §named-reason-per-package. §The-daemon-change-is-named-as-tentative ("may need"); §the-chat-change-is-named-as-definite.

§Note-the-atomicity-concern: §combined-create-guest-and-install-weblet-API-for-atomicity. §Borrowable-pattern: §atomicity-as-a-design-driver — §two-steps-that-must-succeed-or-fail-together belong in §a-combined-API. §Sibling to cycle 162 daemon-Ken-protocol's §atomic-checkpoint and cycle 203 cache-map's §don't-establish-entry-until-prior-steps-succeed.
