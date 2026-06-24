---
title: §Five-named-message-mappings (Endo to platform)
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

| Endo Message | Platform Rendering |
|--------------|--------------------|
| `package` (text + refs) | Text message; refs rendered as names |
| `form` (fields) | JSX card with input fields (Slack/Teams/Discord) or text prompt (Telegram/GitHub) |
| `value` (reply with value) | Text summary + Chat UI link for inspection |
| `request` (promise) | Text notification; resolution posted as reply |

§Four-row-message-mapping-table. §Each-Endo-message-type-maps-to-a-platform-rendering-with-fallback-when-cards-are-limited.

§Borrowable-pattern: §the-mapping-table-IS-the-protocol-translation-spec. §The-table-makes-the-translation-explicit + §reveals-the-platforms-where-the-translation-degrades.

§Sibling to cycle 228 daemon-os-sandbox-plugin's §named-endowment-to-rule-mapping-table-per-backend — both designs §a-mapping-table-as-the-implementation-contract; §cycle-228-maps-Endo-endowments-to-platform-rules; §cycle-232-maps-Endo-message-types-to-platform-renderings.
