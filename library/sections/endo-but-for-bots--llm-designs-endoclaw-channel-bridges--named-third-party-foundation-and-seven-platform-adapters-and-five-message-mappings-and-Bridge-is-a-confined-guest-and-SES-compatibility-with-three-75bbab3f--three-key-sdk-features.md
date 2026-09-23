---
title: §Three-key-SDK-features
source-slug: endo-but-for-bots--llm-designs-endoclaw-channel-bridges
section-id: named-third-party-foundation-and-seven-platform-adapters-and-five-message-mappings-and-Bridge-is-a-confined-guest-and-SES-compatibility-with-three-fallback-paths-and-state-is-Endo-native
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-channel-bridges.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-channel-bridges.md
total-lines: 183
status: Not Started (Parent: endoclaw)
ingest-cycle: 232
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-channel-bridges--named-third-party-foundation-and-seven-platform-adapters-and-five-message-mappings-and-Bridge-is-a-confined-guest-and-SES-compatibility-with-three-fallback-paths-and-state-is-Endo-native
---

```
- Unified event model: onNewMention, onSubscribedMessage, onReaction, onButtonClick, onSlashCommand
- Thread abstraction: thread.post(), thread.subscribe(), ephemeral messages, streaming
- JSX card components: Platform-agnostic cards that render as Block Kit (Slack), Adaptive Cards (Teams), or Google Chat Cards
```

§Five-named-event-callbacks (onNewMention + onSubscribedMessage + onReaction + onButtonClick + onSlashCommand). §Five-named-thread-methods (post + subscribe + ephemeral + streaming + ...). §JSX-card-components as §platform-agnostic-renderers.

§Borrowable-pattern: §a-unified-event-model + §a-thread-abstraction + §platform-agnostic-renderers as §the-three-pillars-of-a-cross-platform-messaging-SDK.
