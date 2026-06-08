---
title: "endoclaw six-design-cluster (network-fetch + notifications + proactive-messages + webhooks + voice + browser) — §two-facet-control-pair + §structural-confinement + §help-method-on-every-interface + §composable-capabilities + §design-pattern-not-a-new-capability + §UI-feature-not-a-capability + §all-sharing-Parent-endoclaw-frontmatter"
source-slug: endo-but-for-bots--llm-designs-endoclaw-six-design-cluster
section-id: two-facet-control-pair-and-structural-confinement-and-help-method-and-composable-capabilities-and-cycle-196-parent
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-{network-fetch,notifications,proactive-messages,webhooks,voice,browser}.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-{network-fetch,notifications,proactive-messages,webhooks,voice,browser}.md
total-lines: 439 (69 + 55 + 74 + 79 + 69 + 93)
status: Not Started (all six; created and updated 2026-03-03; Parent: endoclaw)
ingest-cycle: 226
ingest-date: 2026-06-08
lane: designs
---

# endoclaw six-design-cluster — Children of the endoclaw parent

§Six-designs-with-Parent-endoclaw-in-frontmatter created and updated on the same day (2026-03-03), all **Not Started**. The cluster forms §a-coherent-design-template that the parent endoclaw spec (cycle 196) instantiated six times with different application surfaces. §A-six-design-cluster organized by §a-shared-template.

§Cluster-ingest-as-one-section (sibling to cycle 199's §three-tight-utilities — trampoline / memoize / nat — and cycle 211's §ten-utility-files in @endo/common).

| Design | Lines | Shape |
|--------|-------|-------|
| endoclaw-network-fetch | 69 | §two-facet-control-pair (HttpClient + HttpClientControl) |
| endoclaw-notifications | 55 | §two-facet-control-pair (Notify + NotifyControl) |
| endoclaw-proactive-messages | 74 | §design-pattern-not-a-new-capability |
| endoclaw-webhooks | 79 | §two-facet-control-pair (WebhookEndpoint + WebhookControl) |
| endoclaw-voice | 69 | §UI-feature-not-a-capability + §three-options-A-B-C with pros-cons |
| endoclaw-browser | 93 | §three-facet (Browser + Page + BrowserControl) |

## §The-shared-template

All six designs follow §a-six-section-template:
1. **Frontmatter** with Parent: endoclaw + Status: Not Started + Author + dates.
2. **Summary** — one-paragraph capability description.
3. **Capability Shape** (omitted for voice + proactive-messages) — TypeScript interfaces.
4. **How It Works** — numbered steps.
5. **Endo Idiom** — named principles emerging from the substrate.
6. **Depends On** — list of dependencies (existing or sibling designs).

§Borrowable-pattern: §a-cluster-of-sibling-designs-all-with-Parent-frontmatter + §sharing-the-same-six-section-template makes the cluster easy to scan + §the-Endo-Idiom-section-of-each-becomes-the-shared-vocabulary.

§Sibling to cycle 222 endoclaw-skill-registry's §named-Endo-Idiom-section enumerating emergent principles. §The-cluster-Idiom-sections-cross-reference each other (e.g., network-fetch mentions OAuth as composable-with-it).

## §The-two-facet-control-pair canonical shape

Four of the six designs use §the-two-facet-pair:

```ts
interface Capability {
  // user-facing methods
  help(): string;
}

interface CapabilityControl {
  setLimit(...): void;
  revoke(): void;
  help(): string;
}
```

§Borrowable-pattern: §the-capability-facet-is-narrow (only the methods the user needs) + §the-control-facet-is-where-the-host-tunes-and-revokes. §Two-facets-with-two-different-holders: capability goes to the agent; control stays with the host.

§Three-named-properties-of-the-control-facet across the cluster:
1. §setLimit-style-method (`setMaxPerMinute`, `setMaxRequestsPerMinute`, `setMaxResponseBytes`, `setMaxPayloadBytes`, `setAllowedOrigins`).
2. §revoke()-method that §invalidates-the-capability-irreversibly.
3. §help()-method for §introspection.

§Borrowable-pattern: §every-capability-pair-has-revoke-and-help — these are §the-uniform-baseline-API across all capabilities. §A-host-can-always-revoke + §any-agent-can-call-help-to-learn-its-shape.

## §Structural-confinement

§The-load-bearing-discipline named in §every-cluster-design with a §Capability-Shape:

- **network-fetch**: §origin-allowlist-is-structural — *The agent cannot construct a URL that reaches an origin not in the allowlist. There is no wildcard or bypass — the exo parses the URL and checks the origin before making any network call*.
- **browser**: §structural-origin-confinement — *The agent cannot navigate to evil.example.com to exfiltrate data because the Browser exo rejects URLs outside the allowed origins. This is structural — no URL the agent can construct will reach a disallowed origin*.
- **webhooks**: §HMAC-verification — *The gateway verifies signatures before delivery, preventing spoofed events*.
- **notifications**: §rate-limiting-enforced-in-the-Notify-exo + §the-agent-cannot-discover-or-influence-the-control-facet.

§The-pattern: §the-confinement-is-checked-inside-the-exo-before-the-operation; §no-bypass-because-the-allowlist-is-enforced-at-the-only-call-site.

§Borrowable-pattern: §structural-confinement-via-allowlist-checked-inside-the-exo. §The-confinement-is-a-structural-property-of-the-capability + §not-a-policy-enforced-at-multiple-call-sites.

§Sibling to cycle 220 familiar-localhttp-protocol's §six-layer-defense-in-depth — but cycle-220 layers defenses; cycle-226 cluster says §one-defense-checked-at-the-only-call-site-is-enough. §Two-different-confinement-philosophies: §defense-in-depth-across-substrates (cycle 220) vs §a-single-narrow-API-where-the-check-can't-be-bypassed (cycle 226).

## §No-ambient-X

§Repeating-across-the-cluster:

- **network-fetch**: §No-ambient-DNS-or-socket-access — *The agent has no `net.connect` or `dns.resolve` — only the `fetch` method on its granted HttpClient*.
- **browser**: §No-cookie-credential-leakage — *The Page interface does not expose cookies, localStorage, or network requests. The agent interacts with page content through DOM methods only*.
- **notifications**: §the-agent-cannot-discover-or-influence-the-control-facet.

§Borrowable-pattern: §the-Endo-Idiom-section-names-the-ambient-authorities-the-capability-prevents. §The-design-document-anticipates-the-question: §what-can't-the-agent-do-via-this-capability + §answers-it-explicitly.

§Three-cycles-on-the-host-grants-capabilities-application-doesn't-take-them discipline (cycle 208 + cycle 218 + cycle 222) → §now-four-cycles (cycle 226 cluster reinforces it across six designs).

## §Composable-capabilities

§Capabilities-compose-without-special-glue:

- **network-fetch** composes with **OAuth** (endoclaw-oauth wraps HttpClient with token injection).
- **proactive-messages** composes Timer + data-capabilities + messaging (no new mechanism).
- **webhooks** delivers payloads as §normal-inbox-messages — §the-agent-processes-them-with-the-same-follow-mechanism-it-uses-for-human-messages.
- **proactive-messages** can pair with **notifications** for desktop alert + inbox message.

§Borrowable-pattern: §designs-name-their-composability-partners — §the-capability-IS-composable-with-X-Y-Z. §The-design-document-makes-the-composition-graph-visible.

§Sibling to cycle 222 endoclaw-skill-registry's §federation-by-reference — both designs use §existing-primitives-compose-without-new-glue. §Three-cycles-on-no-new-abstractions discipline (cycles 211 + 214 + 222) → §now-four-cycles (cycle 226 cluster's proactive-messages says §No-new-mechanism-is-needed-this-composes-three-existing-Endo-primitives).

## §Design-pattern-not-a-new-capability (proactive-messages)

§The-novel-shape: a design document that says explicitly §this-is-not-a-capability-it's-a-pattern.

> A design pattern — not a new capability — for agents that initiate conversations with the host on a schedule.

§Borrowable-pattern: §when-a-feature-is-composition-of-existing-capabilities + §a-pattern-for-how-to-compose-them, §name-it-as-a-pattern-not-a-capability. §The-design-document-rejects-the-temptation-to-introduce-a-new-API + §names-the-composition-as-the-deliverable.

§Sibling to cycle 218 familiar-chat-weblet-hosting's §every-UI-action-also-has-a-command (different mechanism, same §don't-introduce-new-when-composing-old-suffices).

## §UI-feature-not-a-capability (voice)

§The-other-novel-shape: a design document that says §this-is-a-UI-concern-not-a-capability-concern.

> Voice input is a UI concern, not a capability concern. The transcribed text enters the system as a normal message — the agent cannot distinguish voice input from typed input. No new capabilities, formula types, or daemon changes are needed for Option A.

§Borrowable-pattern: §when-a-feature-appears-to-need-capability-design-but-is-actually-a-UI-feature, §name-the-distinction-explicitly. §The-agent-cannot-distinguish-voice-input-from-typed-input — §the-uniformity-IS-the-design.

§Three-different-non-capability-design-shapes in the cluster:
1. §Design-pattern-not-a-new-capability (proactive-messages — composition recipe).
2. §UI-feature-not-a-capability (voice — UI concern flowing into existing API).
3. §The-four-capability-designs (network-fetch / notifications / webhooks / browser — actual new capabilities).

§Borrowable-pattern: §a-cluster-of-designs-with-the-same-frontmatter-template-can-still-have-different-deliverable-shapes — §the-shape-of-the-Capability-Shape-section-tells-the-reader-which-kind-this-is (Capability Shape present → new capability; absent → pattern or UI).

## §Three-options-A-B-C with pros-cons (voice)

The voice design names §three-implementation-options with §pros-and-cons-per-option:

| Option | Source | Pros | Cons |
|--------|--------|------|------|
| A: Web Speech API | browser-native | Zero deps; Chrome+Edge; no server | Requires internet; limited languages |
| B: Local Whisper | Familiar | Fully offline; privacy-preserving; better accuracy | Native binary or WASM; ~75MB model; CPU |
| C: Daemon transcription | daemon worker | Offloads compute; works remote/Docker | Latency; daemon bundles Whisper |

§Borrowable-pattern: §when-an-implementation-has-multiple-viable-paths, §name-the-options + §pros-cons-per-option + §let-the-reader-pick. §Different-from-cycle-218's §two-CapTP-transports-with-stretch-goal-marking; cycle-226's voice §names-three-options-without-a-default + §the-options-are-not-mutually-exclusive (they could ship in stages or coexist).

§Sibling to cycle 208 familiar-bundled-agents' §The-Powers-Problem-with-three-option-analysis. §Two-cycles-with-three-named-implementation-options + pros-cons-per-option.

## §help()-method-on-every-interface

Every Capability Shape in the cluster includes `help(): string` on every interface. §Borrowable-pattern: §uniform-introspection-method on every capability + control + sub-interface. §The-agent-can-ask-its-capabilities-what-they-do-by-calling-help-on-them. §No-out-of-band-documentation-needed at runtime.

§Sibling to cycle 217 @endo/errors' §rename-utilities-split-from-assertions — both designs §the-API-is-self-documenting-via-uniform-conventions.

## §The-cluster-as-design-language

The six designs together establish §a-design-language for §endoclaw-style capability ingredients:

1. §Two-facet-control-pair as the default shape.
2. §Structural-confinement as the load-bearing discipline.
3. §No-ambient-X as the §what-can't-the-agent-do enumeration.
4. §Composable-with-other-capabilities as the §designs-name-their-composition-graph discipline.
5. §help()-method as the §uniform-introspection convention.
6. §Design-pattern-not-a-new-capability or §UI-feature-not-a-capability as the §not-every-feature-needs-a-new-capability escape hatches.

§Borrowable-pattern: §a-cluster-of-designs-establishes-a-design-language; §future-designs-in-the-same-cluster-can-elide-the-template + §inherit-the-conventions-from-the-cluster-Idiom.

## §Twenty-second-honest-design-evolution-record family member

§A-new-shape: §six-Parent-pointer-children-sharing-a-template. §The-cluster-IS-the-design-evolution — §each-child-is-a-different-application-of-the-same-pattern.

§Seven-different-shapes-of-design-evolution-record in 2026-06 cluster:
| Cycle | Shape |
|-------|-------|
| 214 | §within-document self-correcting prose |
| 216 | §parent-Complete + §child-Not-Started extraction via Predecessor section |
| 218 | §sibling-Ready + §this-Not-Started via two-part Status |
| 220 | §three-state-Status + §design-deviations-section |
| 222 | §Parent-pointer-as-explicit-frontmatter-field |
| 224 | §Status-Complete-with-explicit-Design-deviations-None-significant + named-implementation-files |
| 226 | §six-Parent-pointer-children-sharing-a-template-as-a-design-language |

§Seven-different-shapes for naming-the-design-relationship.

## §endoclaw-cluster-membership

The endoclaw cluster designs in library now (counting cycle 196 parent + cycle 222 skill-registry child + cycle 226's six children):

| Cycle | Design | Role |
|-------|--------|------|
| 196 | endoclaw | Parent (already ingested) |
| 222 | endoclaw-skill-registry | Discovery child |
| 226 | endoclaw-network-fetch | Network capability child |
| 226 | endoclaw-notifications | Notification capability child |
| 226 | endoclaw-proactive-messages | Pattern child |
| 226 | endoclaw-webhooks | Webhook capability child |
| 226 | endoclaw-voice | UI feature child |
| 226 | endoclaw-browser | Browser capability child |

§Eight-design-cluster for §the-endoclaw-feature now. §Note-the-still-fresh-designs: endoclaw-timer + endoclaw-oauth + endoclaw-channel-bridges (referenced as siblings but not yet ingested).

## Related material in the library

- **cycle 196 endoclaw** (Parent): §the-design-this-cluster-instantiates-six-times.
- **cycle 222 endoclaw-skill-registry**: §sibling-child of endoclaw with §Parent-pointer-as-explicit-frontmatter-field.
- **cycle 218 familiar-chat-weblet-hosting**: §power-levels-as-selectable-options sibling.
- **cycle 208 familiar-bundled-agents**: §The-Powers-Problem-with-three-option-analysis sibling.
- **cycle 220 familiar-localhttp-protocol**: §two-different-confinement-philosophies contrast (defense-in-depth vs structural-confinement-at-the-only-call-site).
- **cycle 199 trampoline/memoize/nat**: §three-tight-utilities sibling (cluster ingest shape).
- **cycle 211 @endo/common**: §ten-utility-files sibling (cluster ingest shape).
- **cycle 217 @endo/errors**: §uniform-introspection-via-named-conventions sibling.

## §Library-reaches-732-sections at cycle 226 (designs-lane endoclaw-six-design-cluster).

## §Sixtieth consecutive designs-chat alternation cycles 166-226.

## §Cluster-ingest-as-one-section pattern

§Borrowable-pattern: §when-six-designs-share-a-template + §the-shared-template-is-the-interesting-content, §ingest-the-cluster-as-one-section. §The-cluster-Idiom-IS-the-borrowable-content; §the-individual-application-surfaces-are-instances. §Different-from-the-cycle-199-trio-ingest (cluster of three tight @endo utility packages with shared code patterns); §cycle-226 is a §cluster-of-six-design-documents-with-shared-rhetorical-template.
