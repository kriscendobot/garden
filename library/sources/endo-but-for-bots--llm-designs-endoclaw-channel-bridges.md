---
title: "endoclaw-channel-bridges — Adapt Endo agent to external messaging platforms (Slack, Teams, Discord, Telegram, Google Chat, GitHub, Linear) via Vercel chat SDK"
source-slug: endo-but-for-bots--llm-designs-endoclaw-channel-bridges
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-channel-bridges.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-channel-bridges.md
total-lines: 183
status: Not Started (Parent: endoclaw)
ingest-cycle: 232
ingest-date: 2026-06-08
lane: designs
---

# endoclaw-channel-bridges.md

A 183-line **Not Started** design (2026-03-03; Parent: endoclaw). The §ninth-member of the endoclaw cluster. Adapts an Endo agent (handle + mailbox) to external messaging platforms via the Vercel `chat` SDK.

## Key design moves

- **§The-ninth-member-of-the-endoclaw-cluster** extending the design language established by cycle 226.
- **§Named-third-party-foundation**: the Vercel `chat` SDK (v4.x); §recommend-a-named-third-party-SDK + §explain-the-abstraction-it-provides.
- **§Seven-platform-adapters table** with §per-platform-feature-list revealing asymmetries.
- **§Three-key-SDK-features** (unified event model + thread abstraction + JSX card components).
- **§Architecture-ASCII-diagram** four-layer translation flow (Platform ↔ chat SDK ↔ Bridge ↔ Endo Agent).
- **§Five-step-bridge-plugin-flow** (receives credentials → instantiates SDK → forwards platform→inbox → subscribes follow → maps message types).
- **§Five-named-message-mappings** Endo→platform (package + form + value + request) with §fallback-to-text-prompt for platforms with limited rendering.
- **§Form-bridging via JSX** with §design-the-rich-representation-and-name-the-text-fallback discipline.
- **§Five-named-Endo-Idiom-points** — Bridge-is-a-confined-guest + One-bridge-per-agent-per-account + Platform-credentials-are-capabilities + State-is-Endo-native.
- **§State-is-Endo-native** — §reject-the-SDK's-state-adapter-and-use-the-native-formula-store; fourth member of §no-new-abstractions discipline family.
- **§SES-Compatibility section** with §honest-acknowledgment-of-untested + §three-named-fallback-paths.
- **§Unconfined-plugin-fallback** as §last-resort with §reduced-confinement-in-exchange-for-ecosystem-access named honestly.
- **§Four-named-Depends-On** items with §version-pinning (v4.x) and §OR-between-alternative-paths.

## Section files

- [§named-third-party-foundation + §seven-platform-adapters + §five-message-mappings + §Bridge-is-a-confined-guest + §SES-compatibility-with-three-fallback-paths + §state-is-Endo-native](../sections/endo-but-for-bots--llm-designs-endoclaw-channel-bridges--named-third-party-foundation-and-seven-platform-adapters-and-five-message-mappings-and-Bridge-is-a-confined-guest-and-SES-compatibility-with-three-fallback-paths-and-state-is-Endo-native.md) — full design ingest.

## Ingest scope

Cycle 232 (designs-lane): full 183-line ingest. §Twenty-sixth-honest-design-evolution-record family member with new shape (§later-member-of-an-established-cluster-template). §Eleven-different-shapes-of-design-evolution-record in 2026-06 cluster now.
