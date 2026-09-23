---
title: §Seven-platform-adapters table
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

| Package | Platform | Features |
|---------|----------|----------|
| `@chat-adapter/slack` | Slack | Mentions, reactions, cards (Block Kit), modals, streaming, DMs, files |
| `@chat-adapter/teams` | Microsoft Teams | Mentions, cards (Adaptive Cards), DMs |
| `@chat-adapter/discord` | Discord | Mentions, reactions, cards, DMs |
| `@chat-adapter/telegram` | Telegram | Mentions, reactions, DMs |
| `@chat-adapter/gchat` | Google Chat | Mentions, reactions, cards, DMs |
| `@chat-adapter/github` | GitHub | Mentions, reactions (issues/PRs) |
| `@chat-adapter/linear` | Linear | Mentions, reactions (issues) |

§Seven-platforms-with-per-platform-feature-list. §Borrowable-pattern: §when-an-SDK-supports-multiple-platforms, §a-table-shows-per-platform-feature-coverage + §reveals-the-asymmetries-explicitly. §Slack-has-the-most-features; §GitHub-and-Linear-have-the-fewest (issues/PRs only).

§Three-feature-buckets observable: §Mentions (all seven) + §Reactions (six of seven; Teams missing) + §Cards (four of seven; Telegram/GitHub/Linear missing). §The-asymmetry-table-IS-the-feature-comparison-tool.
