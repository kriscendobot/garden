---
title: "endoclaw-channel-bridges — §named-third-party-foundation (Vercel chat SDK) + §seven-platform-adapters-table + §five-message-mappings + §Bridge-is-a-confined-guest + §SES-compatibility-with-three-fallback-paths + §State-is-Endo-native + §ninth-member-of-endoclaw-cluster"
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
---

# endoclaw-channel-bridges — Adapt an Endo agent to external messaging platforms

A 183-line **Not Started** design (created and updated 2026-03-03; Parent: endoclaw). The §ninth-member of the endoclaw cluster (after cycles 222 + 226). Adapts an Endo agent (handle + mailbox) to an external messaging platform (Slack / Teams / Discord / Telegram / Google Chat / GitHub / Linear) via the Vercel `chat` SDK.

## §The-ninth-member-of-the-endoclaw-cluster

Adding to the §endoclaw-cluster-membership:

| Cycle | Design | Role |
|-------|--------|------|
| 196 | endoclaw | Parent |
| 222 | endoclaw-skill-registry | Discovery |
| 226 | endoclaw-network-fetch | Network capability |
| 226 | endoclaw-notifications | Notification capability |
| 226 | endoclaw-proactive-messages | Pattern (composition recipe) |
| 226 | endoclaw-webhooks | Webhook capability |
| 226 | endoclaw-voice | UI feature |
| 226 | endoclaw-browser | Browser capability |
| 232 | endoclaw-channel-bridges | Channel-bridge guest |

§Nine-design-cluster for §the-endoclaw-feature. §The-channel-bridges-design extends the §endoclaw-design-language established by cycle 226's cluster to a new application surface (external messaging platforms).

## §Named-third-party-foundation: the Vercel `chat` SDK

> The [`chat`](https://www.npmjs.com/package/chat) package (Vercel) is the recommended foundation. It provides a unified adapter SDK: write bridge logic once against `Chat` + `thread.post()` / `thread.subscribe()`, and platform adapters handle protocol differences for Slack, Teams, Discord, Telegram, Google Chat, GitHub, and Linear.

§Borrowable-pattern: §recommend-a-named-third-party-SDK + §explain-the-abstraction-it-provides + §enumerate-the-platforms-it-covers. §The-design-doesn't-invent-a-bridge-SDK; §it-builds-on-an-existing-one.

§Sibling to cycle 226 endoclaw-cluster's §composable-with-other-capabilities — but cycle 232 §composes-with-external-not-just-Endo-substrates. §Endo-meets-the-broader-ecosystem at this design's boundary.

§Different-from-cycle-228 daemon-os-sandbox-plugin's §three-named-future-stronger-isolation-mechanisms (cycle 228 names future paths; cycle 232 names a current available SDK). §The-design-leans-on-existing-work-rather-than-naming-future-replacements.

## §Seven-platform-adapters table

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

## §Three-key-SDK-features

```
- Unified event model: onNewMention, onSubscribedMessage, onReaction, onButtonClick, onSlashCommand
- Thread abstraction: thread.post(), thread.subscribe(), ephemeral messages, streaming
- JSX card components: Platform-agnostic cards that render as Block Kit (Slack), Adaptive Cards (Teams), or Google Chat Cards
```

§Five-named-event-callbacks (onNewMention + onSubscribedMessage + onReaction + onButtonClick + onSlashCommand). §Five-named-thread-methods (post + subscribe + ephemeral + streaming + ...). §JSX-card-components as §platform-agnostic-renderers.

§Borrowable-pattern: §a-unified-event-model + §a-thread-abstraction + §platform-agnostic-renderers as §the-three-pillars-of-a-cross-platform-messaging-SDK.

## §Architecture-ASCII-diagram (four-layer flow)

```
Platform (Slack, Telegram, ...)
    ↕  platform-specific protocol (handled by chat adapter)
[chat SDK — unified event model]
    ↕  thread.post() / onSubscribedMessage()
[Bridge Guest Plugin]
    ↕  E(host).send() / follow(inbox)
Endo Agent (handle + mailbox)
```

§Four-layer-flow with §named-interface-between-each-pair. §Borrowable-pattern: §when-a-design-bridges-two-substrates, §the-ASCII-diagram-shows-each-layer-and-each-interface; §the-design-doesn't-just-describe-the-endpoints-it-shows-the-translation-steps.

§Sibling to cycle 220 familiar-localhttp-protocol's §ASCII-mermaid-style-flow-diagram. §Both-designs-show-protocol-translation-at-each-layer.

§Six-cycles-with-ASCII-illustration in 2026-06 now: 214 (tree) + 218 (UI mockup) + 220 (flow diagram) + 228 (capability tree) + 230 (architecture overview) + 232 (four-layer translation flow).

## §Five-step-bridge-plugin-flow

```
1. Receives platform credentials as an opaque capability (OAuth or HttpClient).
2. Instantiates the `chat` SDK with the appropriate adapter.
3. On platform message → forwards to the Endo agent's inbox via E(host).send(agentName, text).
4. Subscribes to the agent's inbox (follow) and forwards outgoing messages to the platform thread via thread.post().
5. Maps Endo message types to platform features.
```

§Five-named-bridge-steps. §The-bridge-IS-the-translator + §the-bridge-runs-as-a-confined-guest.

§Borrowable-pattern: §a-bridge-plugin-receives-credentials-as-capability + §instantiates-an-SDK + §forwards-bidirectionally + §maps-domain-types-to-platform-features.

## §Five-named-message-mappings (Endo to platform)

| Endo Message | Platform Rendering |
|--------------|--------------------|
| `package` (text + refs) | Text message; refs rendered as names |
| `form` (fields) | JSX card with input fields (Slack/Teams/Discord) or text prompt (Telegram/GitHub) |
| `value` (reply with value) | Text summary + Chat UI link for inspection |
| `request` (promise) | Text notification; resolution posted as reply |

§Four-row-message-mapping-table. §Each-Endo-message-type-maps-to-a-platform-rendering-with-fallback-when-cards-are-limited.

§Borrowable-pattern: §the-mapping-table-IS-the-protocol-translation-spec. §The-table-makes-the-translation-explicit + §reveals-the-platforms-where-the-translation-degrades.

§Sibling to cycle 228 daemon-os-sandbox-plugin's §named-endowment-to-rule-mapping-table-per-backend — both designs §a-mapping-table-as-the-implementation-contract; §cycle-228-maps-Endo-endowments-to-platform-rules; §cycle-232-maps-Endo-message-types-to-platform-renderings.

## §Form-bridging via JSX with §fallback-to-text-prompt

```tsx
const renderForm = (fields) => (
  <Card>
    <Section>
      {fields.map(f => (
        <TextInput label={f.label} placeholder={f.example} id={f.name} />
      ))}
    </Section>
    <Actions>
      <Button action="submit">Submit</Button>
    </Actions>
  </Card>
);
```

§Endo-form-fields-render-as-platform-cards on Slack/Teams + §fallback-to-text-prompt-listing-the-fields-with-structured-reply on Telegram/GitHub.

§Borrowable-pattern: §design-the-rich-representation-and-name-the-text-fallback for §platforms-with-limited-rendering. §The-design-rejects-lowest-common-denominator (which would deny the rich form to Slack); §but-also-rejects-platform-specific-implementations (which would multiply the work); §the-JSX-abstraction-IS-the-compromise.

§Sibling to cycle 220's §three-mode-address-filtering with §default-is-the-safe-mode — both designs §named-modes-with-fallback-discipline.

## §Five-named-Endo-Idiom-points

```
1. Bridge is a confined guest.
2. One bridge per agent per account.
3. Platform credentials are capabilities.
4. State is Endo-native.
```

§Four-named-disciplines (the design says §**Five** but lists four). §Borrowable-pattern: §the-Endo-Idiom-section-enumerates-the-design-principles-that-emerge-from-the-substrate-choice (consistent with cycle 222's §named-Endo-Idiom-section).

### §Bridge-is-a-confined-guest

> The bridge plugin runs in a SES-locked worker with only its granted capabilities. It cannot read other agents' inboxes, access the filesystem, or make network requests outside the platform API.

§Confinement-via-SES-locked-worker + §no-ambient-X enumeration (consistent with cycle 226's pattern).

### §One-bridge-per-agent-per-account

> This avoids a single bridge becoming a choke point with broad authority.

§Authority-concentration-prevented-by-architecture. §Borrowable-pattern: §one-instance-per-narrow-scope (per-agent-per-account) prevents §authority-aggregation.

### §Platform-credentials-are-capabilities

> The bridge receives an `OAuth` or `HttpClient` capability for the platform API — it never sees the raw bot token. Revocation of the platform credential is instant via `OAuthControl.revoke()`.

§The-bridge-never-sees-the-raw-token + §revocation-is-via-the-control-facet. §Sibling to cycle 226 endoclaw-cluster's §two-facet-control-pair canonical shape.

### §State-is-Endo-native

> Rather than using the `chat` SDK's Redis state adapter, the bridge can persist thread-to-inbox mappings in the Endo formula store via pet names. Each platform thread maps to an Endo message number.

§Reject-the-SDK's-state-adapter-and-use-the-native-formula-store. §Borrowable-pattern: §when-the-SDK-offers-a-state-adapter-but-the-host-has-its-own-storage, §use-the-host's-storage-not-the-SDK's. §The-bridge-keeps-state-in-the-substrate-that-matches-the-rest-of-the-system.

§Sibling to cycle 222 endoclaw-skill-registry's §no-new-abstractions discipline — both designs §use-the-existing-Endo-primitives-rather-than-introduce-foreign-ones. §Four-cycles-on-no-new-abstractions-discipline now (cycles 211 + 214 + 222 + 232).

## §SES-Compatibility section with §three-named-fallback-paths

> The `chat` SDK is a TypeScript package with dependencies on `unified`, `remark-parse`, and `remark-stringify` (Markdown processing). These are pure JavaScript and should be compatible with SES lockdown, but the `chat` SDK itself has not been audited for SES compatibility.

§Honest-acknowledgment-of-untested-SES-compatibility + §three-named-fallback-paths:

```
1. Bundle the `chat` SDK and adapters via esbuild (same pattern as Lal/Fae bundling).
2. Test under SES lockdown for frozen-primordial compatibility.
3. Potentially shim or patch any SES-incompatible patterns (mutable module-level state, prototype mutation).
```

§The-third-path-acknowledges-the-need-for-shims if the SDK turns out to be incompatible.

### §Unconfined-plugin-fallback as §last-resort

> If the `chat` SDK proves incompatible with SES, the bridge could run as an unconfined plugin (like the web server) in an already-locked-down worker, accepting the reduced confinement in exchange for ecosystem access.

§Reduced-confinement-in-exchange-for-ecosystem-access — §the-honest-trade-off-named.

§Borrowable-pattern: §when-SES-compatibility-can't-be-guaranteed, §name-the-unconfined-fallback + §name-the-trade-off-being-accepted. §The-design-doesn't-pretend-confinement-is-unconditional + §names-the-conditions-under-which-it-degrades.

§Sibling to cycle 226 endoclaw-cluster's §two-different-confinement-philosophies + cycle 228's §named-future-stronger-isolation-mechanisms. §Three-cycles-with-graceful-degradation-of-confinement.

## §Four-named-Depends-On items

```
- `chat` (v4.x) and platform adapters
- endoclaw-network-fetch OR endoclaw-oauth for platform API access
- Existing Endo messaging (`send`, `inbox`, `follow`)
- Guest plugin infrastructure (`endo install`)
```

§Borrowable-pattern: §dependencies-list-includes-version-pinning (v4.x) for the third-party-dependency. §The-OR-between-network-fetch-and-oauth-names-the-alternative-paths-for-platform-API-access.

§Sibling to cycle 226 endoclaw-cluster's §composable-with-other-capabilities — cycle 232 names §which-cycle-226-sibling-capabilities-it-composes-with.

## §Library-scope (endoclaw cluster cohesion)

§Cycle 226's-cluster-ingest established §the-endoclaw-design-language. §Cycle-232-is-the-ninth-instance instantiated under that language. §The-design-rhetoric-is-consistent-across-the-cluster (Parent + Status: Not Started + Summary + Capability Shape + How It Works + Endo Idiom + Depends On).

§Borrowable-pattern: §when-a-cluster-establishes-a-template, §later-members-of-the-cluster-follow-it-without-explanation + §the-reader-already-knows-the-shape. §Cycle-232-doesn't-re-explain-the-Endo-Idiom-template; §it-fills-it-in.

## §Twenty-sixth-honest-design-evolution-record family member

§A-new-shape: §later-member-of-an-established-cluster-template. §Eleven-different-shapes-of-design-evolution-record in 2026-06 cluster now:

| Cycle | Shape |
|-------|-------|
| 214 | §within-document self-correcting prose |
| 216 | §parent-Complete + §child-Not-Started extraction via Predecessor |
| 218 | §sibling-Ready + §this-Not-Started via two-part Status |
| 220 | §three-state-Status + §design-deviations-section |
| 222 | §Parent-pointer-as-explicit-frontmatter-field |
| 224 | §Status-Complete-with-explicit-Design-deviations-None-significant |
| 226 | §six-Parent-pointer-children-sharing-a-template (design-document cluster) |
| 227 | §uniform-PassStyleHelper-shape-across-pass-style-kind-files |
| 228 | §Status-Superseded-by-named-successor + §Roadmap-calibration-via-git-blame |
| 230 | §phases-by-number-with-implementation-files-and-remaining-one-line-purposes |
| 232 | §later-member-of-an-established-cluster-template |

§Eleven-different-shapes for naming-the-design-relationship.

## Related material in the library

- **cycle 226 endoclaw-cluster** (six designs): §the-cluster-this-is-part-of; §cycle-232 extends the eight-design cluster to nine.
- **cycle 222 endoclaw-skill-registry**: §earlier sibling in the endoclaw cluster; §no-new-abstractions discipline sibling.
- **cycle 196 endoclaw** (parent): §the-design-this-is-a-component-of.
- **cycle 226 endoclaw-network-fetch + endoclaw-oauth** (named Depends-On): §the-capabilities-this-bridge-receives.
- **cycle 228 daemon-os-sandbox-plugin**: §named-third-party-system-leans-on-existing-work sibling; §honest-acknowledgment-of-untested-compatibility sibling.
- **cycle 220 familiar-localhttp-protocol**: §architecture-ASCII-diagram sibling.
- **cycle 211 @endo/common + cycle 214 lal-reply-chain + cycle 222 endoclaw-skill-registry + cycle 232 endoclaw-channel-bridges**: §four-cycles-on-no-new-abstractions discipline (cycle 232's §State-is-Endo-native makes the fourth member).
- **cycle 208 familiar-bundled-agents**: §bundle-via-esbuild sibling for the SES-Compatibility named pattern.

## §Library-reaches-738-sections at cycle 232 (designs-lane endoclaw-channel-bridges).

## §Sixty-sixth consecutive designs-chat alternation cycles 166-232.

## §Six-cycles-with-ASCII-illustration in 2026-06

| Cycle | Source | Diagram type |
|-------|--------|--------------|
| 214 | lal-reply-chain-transcripts | ASCII tree of branching |
| 218 | familiar-chat-weblet-hosting | ASCII mockup of UI |
| 220 | familiar-localhttp-protocol | ASCII flow diagram (Chat ↔ MessagePort ↔ iframe) |
| 228 | daemon-os-sandbox-plugin | ASCII capability tree |
| 230 | endor-npm-registry-proxy | ASCII architecture overview |
| 232 | endoclaw-channel-bridges | ASCII four-layer translation flow |

§Six-different-uses-of-ASCII-diagrams in the 2026-06 cluster — each shows a different aspect of the design (tree / mockup / flow / capability / architecture / translation).

## §Four-cycles-on-no-new-abstractions discipline

| Cycle | Source | Application |
|-------|--------|-------------|
| 211 | @endo/common | tree-shaking-friendly via one-file-per-export |
| 214 | lal-reply-chain-transcripts | no-daemon-changes-required |
| 222 | endoclaw-skill-registry | the-registry-IS-the-directory |
| 232 | endoclaw-channel-bridges | State-is-Endo-native (reject SDK's state adapter, use formula store) |

§Four-different-substrates-where-the-discipline-applies.

## §Three-cycles-with-graceful-degradation-of-confinement

| Cycle | Source | Mechanism |
|-------|--------|-----------|
| 226 | endoclaw-cluster | §two-different-confinement-philosophies (defense-in-depth vs structural-at-only-call-site) |
| 228 | daemon-os-sandbox-plugin | §named-future-stronger-isolation-mechanisms (Landlock + container + VM) |
| 232 | endoclaw-channel-bridges | §unconfined-plugin-fallback as §last-resort if SES-incompatible |

§Three-different-graceful-degradation-shapes of confinement.
