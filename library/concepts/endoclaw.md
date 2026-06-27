---
id: endoclaw
aliases: ["endoclaw", "EndoClaw", "OpenClaw parity", "ClawdBot", "Moltbot", "the endoclaw cluster", "endoclaw capability cluster", "a claw"]
topics: [daemon, capability-security, agent-conventions]
---

# endoclaw

The **endoclaw cluster** is a family of `endo-but-for-bots` designs — one
**Reference**-status parent (`designs/endoclaw.md`, "EndoClaw: Feature Parity
with OpenClaw") plus ~12 member designs (`designs/endoclaw-*.md`, mostly **Not
Started**) — that work out what it takes to give an Endo-confined agent the
capabilities of **OpenClaw** (formerly ClawdBot, formerly Moltbot; Peter
Steinberger's free, open-source personal AI assistant). The parent is a
**parity-comparison-as-design-document**: it maps OpenClaw features to Endo
equivalents across thirteen feature categories and tags each with a
status/priority, but proposes no work itself. The members are the concrete
slices — each one design for a single capability or feature surface.

The cluster's **load-bearing anchor** is a named architectural difference stated
at the parent's opening: OpenClaw grants agents **ambient authority** (any tool
runs with the user's full permissions); Endo's **object-capability** model means
an agent holds only the specific `Dir`, `Shell`, `Git`, … capabilities
explicitly granted to it. Every parity row and every member design references
that difference. The members share a six-section design template (Frontmatter +
Summary + Capability Shape + How It Works + Endo Idiom + Depends On) and a
recurring exo shape: a **two-facet control pair** (an action facet + a
`…Control` facet that sets limits, revokes, and exposes `help()`), structural
confinement enforced by an allowlist checked inside the exo, and "no ambient X"
stated explicitly in each Endo Idiom.

## The "capability vs. UI feature" classification

The members are not uniform. The cluster's framing sorts each design into one of
three kinds — a distinction the members make explicitly, and the reason this page
exists as a concept rather than just a source listing:

- **A new capability** (the majority) — a new exo + control facet granting the
  agent authority it did not previously hold (`HttpClient`, `Browser`, `OAuth`,
  `Notify`, `IntervalScheduler`, webhook gateway, channel bridges). These carry
  the two-facet shape and structural confinement.
- **A design pattern, not a new capability** — `proactive-messages`: a
  composition recipe over existing primitives (Timer + data capabilities +
  messaging), granting no new authority.
- **A UI feature, not a capability** — `voice`: voice input flows into the
  existing Chat API; the agent cannot distinguish voice from typed text, so it
  gains no new authority. A UI concern, deliberately kept out of the capability
  surface.

## Member designs

| Member | Kind | One-line shape |
|---|---|---|
| `endoclaw` (parent) | Reference / parity comparison | Maps OpenClaw → Endo across thirteen categories; names the ambient-vs-ocap difference; classifies gaps High/Medium/Low. |
| `endoclaw-network-fetch` | Capability | `HttpClient` / `HttpClientControl` two-facet; origin allowlist + rate limit + max-response-bytes; the foundational network substrate the HTTP-touching members build on. |
| `endoclaw-oauth` | Capability | `OAuth` — authenticated third-party requests where the agent **never sees the token**; authority-to-use, not authority-to-delegate. |
| `endoclaw-browser` | Capability | `Browser` / `Page` / `BrowserControl` (Playwright-backed); origin confinement + read-only toggle + no cookie/credential leakage. |
| `endoclaw-webhooks` | Capability | Webhook gateway routing incoming HTTP to agent inboxes; webhook-as-formula + HMAC verification + capability-controlled creation. |
| `endoclaw-notifications` | Capability | `Notify` / `NotifyControl` — OS desktop notifications via Familiar's Electron API; rate-limited, graceful degradation when headless. |
| `endoclaw-timer` | Capability (In Progress) | `IntervalScheduler` / `IntervalControl` — the heartbeat that lets an SES-locked agent schedule future execution; one of the three High-priority parity gaps. Phase-1 prototype in `packages/genie/src/interval/`. |
| `endoclaw-skill-registry` | Capability (structural) | A skill registry that introduces **no new abstractions** — it is *just an EndoDirectory*; decentralized, federation by reference. |
| `endoclaw-channel-bridges` | Capability | Adapts an Endo agent (handle + mailbox) to external messaging platforms via the Vercel `chat` SDK; seven platform adapters; bridge is a confined guest. |
| `endoclaw-proactive-messages` | Design pattern (not a capability) | Agents initiate conversations on a schedule by composing Timer + data + messaging; a recipe, not a new exo. |
| `endoclaw-voice` | UI feature (not a capability) | Voice input to the Chat UI via three substrate options; grants no new authority. |
| `endoclaw-six-design-cluster` | Ingest wrapper | One-section ingest of six siblings (network-fetch + notifications + proactive-messages + webhooks + voice + browser); documents the shared template as a design language. |

The three High-priority parity gaps the parent names are Web Fetch and Search,
core workspace/memory, and the Heartbeat Timer — "the core engine that
con[s]titutes a claw" and "the core 'there' that makes a claw tick" (the design's
domain vocabulary, typo preserved in source).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [endoclaw/named-architectural-difference-ambient-vs-object-capability](../sections/endo-but-for-bots--llm-designs-endoclaw--parity-comparison-as-design-document-genre-with-thirteen-feature-categories-and-named-architectural-difference--named-architectural-difference-ambient-vs-object-capability.md) | The load-bearing anchor: ambient authority (OpenClaw) vs object-capability confinement (Endo). |
| [endoclaw/gap-priority-classification](../sections/endo-but-for-bots--llm-designs-endoclaw--parity-comparison-as-design-document-genre-with-thirteen-feature-categories-and-named-architectural-difference--gap-priority-classification-high-medium-low.md) | The High/Medium/Low gap-priority scheme and the three High gaps. |
| [endoclaw-six-design-cluster](../sections/endo-but-for-bots--llm-designs-endoclaw-six-design-cluster--two-facet-control-pair-and-structural-confinement-and-help-method-and-composable-capabilities-and-cycle-196-parent.md) | The shared template + two-facet control pair + help() + composability as a design language. |
| [endoclaw-network-fetch](../sections/endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth.md) | `HttpClient` as the foundational network substrate the cluster's HTTP members depend on. |
| [endoclaw-oauth](../sections/endo-but-for-bots--llm-designs-endoclaw-oauth--the-agent-never-sees-the-token-and-authority-to-use-not-authority-to-delegate-and-path-restrictions-structural-and-read-only-mode-and-tenth-member-of-endoclaw-cluster.md) | Credential never reaches the agent; authority-to-use vs authority-to-delegate. |
| [endoclaw-browser](../sections/endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage.md) | Three-facet Playwright wrapper with structural origin confinement. |
| [endoclaw-webhooks](../sections/endo-but-for-bots--llm-designs-endoclaw-webhooks--webhook-as-formula-and-inbox-delivery-and-capability-controlled-creation-and-HMAC-verification-and-Endo-Idiom-section.md) | Webhook-as-formula; incoming HTTP delivered to inboxes; HMAC verification. |
| [endoclaw-notifications](../sections/endo-but-for-bots--llm-designs-endoclaw-notifications--Notify-NotifyControl-two-facet-and-rate-limit-silently-dropped-or-queued-and-graceful-degradation-in-headless--graceful-degradation-in-headless.md) | `Notify` / `NotifyControl` two-facet with graceful headless degradation. |
| [endoclaw-timer](../sections/endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed.md) | The heartbeat capability; heartbeat-vs-cron split; missed ticks coalesced not replayed. |
| [endoclaw-skill-registry](../sections/endo-but-for-bots--llm-designs-endoclaw-skill-registry--no-new-abstractions-and-capability-declaration-via-directory-structure-and-decentralized-by-default-and-federation-by-reference--federation-by-reference.md) | No-new-abstractions discipline: the registry *is* an EndoDirectory. |
| [endoclaw-channel-bridges](../sections/endo-but-for-bots--llm-designs-endoclaw-channel-bridges--named-third-party-foundation-and-seven-platform-adapters-and-five-message-mappings-and-Bridge-is-a-confined-guest-and-SES-compatibility-with-three-fallback-paths-and-state-is-Endo-native.md) | Adapts an agent to seven external messaging platforms; bridge as confined guest. |
| [endoclaw-proactive-messages](../sections/endo-but-for-bots--llm-designs-endoclaw-proactive-messages--a-design-pattern-not-a-new-capability-and-composes-three-existing-primitives-and-code-example-as-the-design--code-example-as-the-design.md) | The "a design pattern, not a new capability" classification, worked as a code example. |
| [endoclaw-voice](../sections/endo-but-for-bots--llm-designs-endoclaw-voice--voice-input-is-UI-concern-not-capability-and-three-Options-with-Pros-Cons-no-preferred-and-the-agent-cannot-distinguish-voice-from-typed.md) | The "UI feature, not a capability" classification; three substrate options, no preferred. |

## See also

- [[object-capability]] — the model whose explicit-grant discipline is the entire premise of the cluster's ambient-vs-ocap anchor.
- [[caretaker-pattern]] — the action/control facet split the member capabilities instantiate as their `…`/`…Control` two-facet shape.
- [[distributed-confinement]] — the broader confinement story the per-capability structural allowlists are a local enactment of.
