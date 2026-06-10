---
title: "endoclaw-network-fetch.md — HttpClient/HttpClientControl two facets + structural origin allowlist + rate limit + max response bytes + no ambient DNS or socket + substrate for OAuth"
source-slug: endo-but-for-bots--llm-designs-endoclaw-network-fetch
section-slug: HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-network-fetch.md
source-repo: endojs/endo-but-for-bots
source-path: designs/endoclaw-network-fetch.md
source-author: Kris Kowal (prompted)
total-lines: 69
ingest-cycle: 261
ingest-date: 2026-06-10
lane: designs
---

# `endoclaw-network-fetch.md` — the foundational HTTP-confinement capability that the OAuth/Browser endoclaw designs build on

Full 69-line design ingested. Status **Not Started** (Created 2026-03-03; Updated 2026-03-03). Parent: [endoclaw](endoclaw.md). The §foundational-network-substrate of the endoclaw cluster — every endoclaw design that touches HTTP (OAuth from cycle 234; Browser from cycle 259's Playwright wrapper) names this design as its parent or substrate. Until now the library has ingested four of its children/derivatives (cycles 226 + 234 + 257's proactive-messages + 259) and referenced this design as a sibling/parent across all four; cycle 261 ingests the substrate itself.

## §The foundational network-substrate of the endoclaw cluster

`endoclaw-network-fetch.md` is the §parent-design-the-library-has-referenced-but-not-ingested for **four prior cycles** of the endoclaw cluster:

- §**cycle 226** (the recurring "two-cycles-with-the-setReadOnly-mode-toggle" sibling — this design names the canonical-two-facet pattern that 226 instantiates first);
- §**cycle 234** (endoclaw-oauth — its §Composable-with-OAuth subsection at lines 61-64 explicitly names this design as the substrate that OAuth wraps);
- §**cycle 257** (endoclaw-proactive-messages — references HttpClient as one of the granted data capabilities);
- §**cycle 259** (endoclaw-browser — sibling Playwright substrate, both follow the canonical-two-facet template named here).

§The-substrate-IS-ingested-after-its-derivatives — a §reverse-ingestion-order; §the-library-knows-the-derivatives-better-than-the-substrate; §sibling-pattern-to-cycle-258's-curated-re-export-package-as-abstraction-boundary (the library knew the re-exporting consumers before ingesting the curated package itself); §first-explicit-observation in library of §reverse-ingestion-order-of-cluster-substrate.

## §Canonical two-facet pattern with explicit substrate role

Lines 18-34 establish the canonical-two-facet shape that the entire endoclaw cluster instantiates:

```ts
interface HttpClient {
  fetch(url: string, options?: FetchOptions): Promise<Response>;
  allowedOrigins(): string[];
  help(): string;
}

interface HttpClientControl {
  setAllowedOrigins(origins: string[]): void;
  setMaxRequestsPerMinute(n: number): void;
  setMaxResponseBytes(n: number): void;
  revoke(): void;
  help(): string;
}
```

§Three-use-facet-methods (fetch + allowedOrigins + help) vs §five-control-facet-methods (setAllowedOrigins + setMaxRequestsPerMinute + setMaxResponseBytes + revoke + help):

- §**the-control-facet-has-more-methods-than-the-use-facet** — established here at the substrate; reused by cycles 234 (OAuth: 4-method use vs 5-method control + revoke + help) and 259 (Browser: 2-method use vs 4-method control).
- §**three-named-control-knobs** (origins + rate-cap + size-cap) — each addresses a distinct attack class: origin = data-exfiltration; rate = DoS-against-allowed-origin; size = downloading-large-files-for-DoS-of-the-agent's-environment.
- §**revoke as named permanent-state transition** — sibling pattern to cycle 238 + 244 + 246 + 253 + 259; §six-cycles-with-revocation-as-named-permanent-state when counting this substrate (226 + 234 + 238 + 244 + 246 + 253 + 259 + 261 — actually now seven; the substrate establishes the discipline).
- §**`help()` on both facets** — the §help-method-IS-a-named-convention-from-the-`@endo/exo`-conventions; sibling pattern to the project CLAUDE.md `## Modules and exports` *"The `help()` method is conventional on capabilities and should return a descriptive string"*; §first-explicit-observation in library of §the-help-method-IS-a-named-convention-of-`@endo/exo`-derived-capabilities-named-in-the-project-CLAUDE.md.
- §**`allowedOrigins()` as introspection-on-the-use-facet** — the agent can read the policy that confines it; §self-reflective-capability gives the agent a way to ask "what am I allowed?" without trial-and-error; §a-named-introspection-method-on-the-use-facet; §first-explicit-observation in library.

## §Structural origin allowlist — the discipline named here at the substrate

Lines 46-51 carry the canonical statement:

> **Origin allowlist is structural.** The agent cannot construct a URL that reaches an origin not in the allowlist. There is no wildcard or bypass — the exo parses the URL and checks the origin before making any network call.

§The-structural-confinement-discipline-IS-named-explicitly-here-at-the-substrate:

- §**structural-not-policy** — the rejection happens at the URL-parse step, not at a runtime policy hook; §no-wildcard-no-bypass; the helper does the parsing-and-checking itself.
- §**the-exo-parses-the-URL-and-checks-the-origin-before-making-any-network-call** — §parse-first-act-second; §canonical-sequencing-discipline.
- §**three-cycles-with-structural-confinement-discipline at the substrate root** (234 path-restrictions + 238 origin-allowlist + 259 origin-confinement + 261 = the **substrate** for all three derivatives); §four-cycles-with-structural-confinement-discipline counting cycle 261 itself; §first-explicit-observation that the *substrate* is also where the discipline is *named*.

## §Three orthogonal control knobs on the control facet

Lines 28-30:
- §**`setAllowedOrigins`** — data-exfiltration-defense.
- §**`setMaxRequestsPerMinute`** — DoS-against-allowed-origin-defense and §agent-spam-defense.
- §**`setMaxResponseBytes`** — large-file-DoS-defense + §the-agent-environment-resource-exhaustion-defense.

§Three-orthogonal-attack-classes-each-with-its-own-named-knob:

- §each-knob-addresses-one-attack-class — §the-knob-is-named-after-the-attack-it-defends-against (not "setRateLimit" or "setSizeLimit" but the specific knob).
- §**rate-limit-and-size-limit-as-named-discipline** at lines 53-55 → §named-host-knobs-for-DoS-defense; §the-substrate-names-the-knobs + §the-derivatives-can-extend-or-narrow-them; sibling pattern to cycle 234's setReadOnly + setScopes + setAllowedPaths (four-named-control-knobs).
- §the-substrate-establishes-three-named-knobs + §each-derivative-design-extends-with-its-own-knob (cycle 234 adds setScopes + setAllowedPaths + setReadOnly + refresh; cycle 259 adds setReadOnly + setAllowedOrigins + revoke); §first-explicit-observation of §each-endoclaw-design-extends-the-control-facet-with-its-own-specific-knobs.

## §No ambient DNS or socket access — the named non-exposure discipline at substrate root

Lines 57-59 (one of the most structurally-interesting paragraphs in the file):

> **No ambient DNS or socket access.** The agent has no `net.connect` or `dns.resolve` — only the `fetch` method on its granted `HttpClient`. Protocols other than HTTP/HTTPS are not supported.

§The-named-non-exposure-discipline:

- §**three-named-non-exposures-on-the-network-substrate**: §no-`net.connect` + §no-`dns.resolve` + §no-protocols-other-than-HTTP/HTTPS; sibling pattern to cycle 259's three-named-non-exposures-on-Page-interface (cookies + localStorage + network requests).
- §**confinement-by-omission named at the substrate root**: §the-fetch-method-IS-the-only-network-API + §the-omission-IS-the-defense; §four-cycles-with-explicit-confinement-by-omission (234 + 238 + 259 + 261 substrate); §five-cycles when counting the substrate alongside its three derivatives.
- §**protocol-restriction as named-omission** — HTTPS-and-HTTP-only; §no-FTP-no-WebSocket-no-WebRTC; §the-substrate-IS-the-only-route-out + §the-route-IS-the-protocol-restriction.
- §**named-Node.js-API-non-exposures** — `net.connect` and `dns.resolve` are the §canonical-Node-network-primitives-the-agent-MUST-NOT-receive; §naming-the-thing-NOT-exposed makes the §threat-model-explicit; §first-explicit-observation in library of §named-platform-API-non-exposures-as-evidence-of-confinement-by-omission.

## §Composable with OAuth — the substrate names its principal extension point

Lines 61-64:

> **Composable with OAuth.** The OAuth capability ([endoclaw-oauth](endoclaw-oauth.md)) wraps an `HttpClient` with token injection and path restrictions, adding authentication as a layer on top of network confinement.

§The-substrate-names-its-principal-extension-point — §two-cycles-with-substrate-naming-its-extension (cycle 261 substrate names cycle 234's OAuth-wrapping; sibling to cycle 257's cross-cluster-composition naming endoclaw-notifications from cycle 253); §three-cycles-with-named-cross-design-composition (253 + 257 + 261); §first-explicit-observation in library of §the-substrate-design-names-the-derivative-design-by-link rather than the other way around.

§**Higher-level-capability-wraps-lower-level** is named here for the first time at the substrate — cycle 234 reuses the language verbatim; this is the §canonical-source of the §a-higher-level-capability-is-a-wrapper-around-a-lower-level-capability pattern. §the-substrate-establishes-the-pattern + §the-derivatives-inherit-the-language.

## §Depends On bullets at the substrate root

Lines 66-69:

> - Node.js `fetch` (available in Node 22+) or `undici` for HTTP
> - No other Endo designs required; standalone capability

§Two-bullet Depends-On pattern with §explicit-no-other-Endo-designs-marker — §the-substrate-IS-standalone; §the-substrate-has-no-Endo-substrate-of-its-own; §sibling-pattern to cycle 259's §`Optional:` prefix and cycle 255's conditional-per-option Depends-On variant.

§Four-cycles-with-Depends-On-bullet-list-variants (253 standalone + 255 conditional + 259 Optional-prefix + 261 standalone-with-explicit-no-Endo-designs-required-marker); §each-variant-encodes-a-different-substrate-relationship: §standalone (253, 261) + §conditional-per-implementation-option (255) + §Optional-defense-in-depth (259).

§**Node-22-as-the-LTS-floor for fetch** — §named-platform-LTS-floor-as-Depends-On-bullet; §sibling-pattern to library's existing node-lts-window-watch skill; §first-explicit-observation in library of §Node-LTS-version-floor-named-in-a-Depends-On-bullet-of-a-design-doc.

§**`undici` named as fallback for HTTP** — §two-implementation-paths-named-in-Depends-On (Node 22's built-in fetch OR undici); §two-cycles-with-named-alternative-implementation-paths-in-Depends-On (255 named alternative API providers + 261 named alternative HTTP libraries); §the-substrate-names-its-implementation-degrees-of-freedom.

## §Use-Cases section absent at the substrate — a discriminating signal

Cycle 261's `endoclaw-network-fetch.md` has §no-Use-Cases-section. Compare:

- §**cycle 234 (OAuth)** — has Use-Cases section (five named OAuth targets).
- §**cycle 257 (proactive-messages)** — has Use-Cases section (four named use cases).
- §**cycle 259 (Browser)** — has Use-Cases section (four named Use Cases).
- §**cycle 261 (substrate)** — **NO** Use-Cases section.

§the-substrate-doesn't-name-use-cases-because-its-use-cases-ARE-its-derivatives; §**three-cycles-with-Use-Cases-section-enumerating-named-use-cases** (234 + 257 + 259) describes §derivative-design-shape; §the-substrate's-shape-omits-Use-Cases because §the-substrate-IS-named-by-its-derivatives + §the-derivatives-bring-their-own-Use-Cases; §**the-substrate's-Use-Cases-omission-IS-the-signal-that-this-IS-the-substrate**; §first-explicit-observation in library of §the-Use-Cases-omission-as-substrate-signal.

§Sibling-pattern: §cycle 257's no-Capability-Shape-section-because-no-new-capability — both designs §use-section-omission-as-evidence-of-design-kind; §two-cycles-with-section-omission-as-design-kind-signal (257 + 261).

## §Endo Idiom section as the substrate's named pattern catalog

Lines 46-64 are an §Endo-Idiom-section that names **four** patterns:

1. **§Origin allowlist is structural.**
2. **§Rate limiting and size limits.**
3. **§No ambient DNS or socket access.**
4. **§Composable with OAuth.**

§Four-named-patterns-in-one-Endo-Idiom-section; §sibling-pattern to cycle 232 (Endo-Idiom names channel-bridges patterns) + cycle 246 (Endo-Idiom names familiar-app-ui-hosting patterns) + cycle 257 (Endo-Idiom names design-pattern-not-capability); §four-cycles-with-Endo-Idiom-section-as-recurring-design-doc-shape (232 + 246 + 257 + 261); §the-Endo-Idiom-section-IS-where-the-substrate-names-its-canonical-patterns-for-derivatives-to-borrow.

## §Cycle 261's structural moves

§First-explicit-observations from cycle 261:

1. **§reverse-ingestion-order-of-cluster-substrate** — the library has been working "outside-in" through this cluster, knowing the OAuth wrapper (234), the Browser sibling (259), and the proactive-messages composer (257) before ingesting the substrate they all build on.
2. **§the-help-method-IS-a-named-convention-of-`@endo/exo`-derived-capabilities-named-in-the-project-CLAUDE.md** — the substrate exposes `help()` on both facets per the convention.
3. **§a-named-introspection-method-on-the-use-facet** (`allowedOrigins()`) — the agent can read its own confinement policy.
4. **§each-endoclaw-design-extends-the-control-facet-with-its-own-specific-knobs** — substrate has three knobs (origins + rate + size); OAuth adds three more (scopes + allowedPaths + readOnly + refresh); Browser adds two more (allowed-origins-of-its-own + readOnly).
5. **§named-platform-API-non-exposures-as-evidence-of-confinement-by-omission** (`net.connect` and `dns.resolve` named as the canonical Node primitives the agent MUST NOT receive).
6. **§the-substrate-design-names-the-derivative-design-by-link** (§Composable-with-OAuth subsection links to endoclaw-oauth) — rather than the derivative naming the substrate.
7. **§Node-LTS-version-floor-named-in-a-Depends-On-bullet-of-a-design-doc** (Node 22+).
8. **§the-Use-Cases-omission-as-substrate-signal** — substrates omit Use-Cases because their use-cases ARE their derivatives.
9. **§two-cycles-with-section-omission-as-design-kind-signal** (257 + 261).

## §Recurring meta-patterns counter-bumps at cycle 261

- §**seven-cycles-with-revocation-as-named-permanent-state** (226 + 234 + 238 + 244 + 246 + 253 + 259 + 261 = actually eight when counting 226 as a derivative that established the discipline relative to this substrate); the discipline is now reinforced *at the substrate root* — §the-substrate-establishes-revocation-as-canonical-discipline-for-the-cluster.
- §**four-cycles-with-structural-confinement-discipline** (234 + 238 + 259 + 261) — now four when counting the substrate root itself.
- §**five-cycles-with-explicit-confinement-by-omission** (234 + 238 + 259 + 261 + the §canonical-source named here) — the discipline counter now five.
- §**four-cycles-with-Depends-On-bullet-list-variants** (253 standalone + 255 conditional + 259 Optional-prefix + 261 standalone-with-explicit-no-Endo-designs-required-marker).
- §**four-cycles-with-Endo-Idiom-section-as-recurring-design-doc-shape** (232 + 246 + 257 + 261).
- §**eight-cycles-with-canonical-caretaker-two-facet-pattern** (226 + 234 + 238 + 244 + 246 + 253 + 259 + 261 — eight when counting this substrate).
- §**eight-cycles-with-explicit-capability-by-construction-discipline** (234 + 238 + 244 + 246 + 253 + 257 + 259 + 261).
- §**three-cycles-with-named-cross-design-composition** (253 + 257 + 261).
- §**ninety-fourth consecutive designs-chat alternation cycle 166-250 + 252-261 (251 was out-of-band)**.

## §Synthesis target — slot machine library

§The-foundational-network-substrate-pattern instantiated for game engine:

- §**§game-engine-credential-substrate** with two-facet shape (GameClient/GameClientControl).
- §Three-orthogonal-knobs at substrate root: §setAllowedGameOperations + §setMaxBetsPerMinute + §setMaxPayoutBytes; §each-knob-addresses-one-attack-class (cheating + DoS-against-game + payout-resource-exhaustion).
- §**No ambient game-network-access** — the agent has no §game.connect or §game.broadcast — only the §bet method on its granted §GameClient; §named-platform-API-non-exposures-as-evidence-of-confinement-by-omission for the §canonical-game-API-the-agent-MUST-NOT-receive.
- §**Composable with payment** — the substrate names its principal extension point (§PaymentClient-wraps-GameClient with credential injection and stake restrictions); §the-substrate-design-names-the-derivative-design-by-link.
- §**`help()` and `allowedGameOperations()`** — §the-help-method-IS-a-named-convention + §a-named-introspection-method-on-the-use-facet so the agent can read its own confinement policy.
- §**No Use-Cases section at the substrate** — §the-substrate's-Use-Cases-omission-IS-the-signal-that-this-IS-the-substrate.
- §**Endo-Idiom section** as the §pattern-catalog-for-derivative-designs-to-borrow.

## §Tier-1 borrowing (substrate-level patterns)

- §canonical-two-facet-pattern named at the substrate (HttpClient + HttpClientControl).
- §three-use-facet-methods + §five-control-facet-methods (the control-has-more-than-use discipline established here).
- §structural-origin-allowlist with §parse-first-act-second sequencing.
- §three-orthogonal-control-knobs each addressing one attack class.
- §no-ambient-DNS-or-socket-access as §named-platform-API-non-exposures.
- §confinement-by-omission at substrate root.
- §composable-with-OAuth subsection as the substrate naming its principal extension point.
- §help-method-IS-a-named-convention on both facets.
- §`allowedOrigins()`-as-introspection-on-the-use-facet.

## §Tier-2 borrowing (substrate-establishing patterns)

- §the-substrate-establishes-revocation-as-canonical-discipline-for-the-cluster.
- §each-endoclaw-design-extends-the-control-facet-with-its-own-specific-knobs.
- §the-substrate-design-names-the-derivative-design-by-link (rather than the derivative naming the substrate).
- §node-LTS-version-floor-named-in-Depends-On.
- §two-implementation-paths-named-in-Depends-On (Node 22 fetch OR undici).
- §Endo-Idiom section names four patterns.
- §the-Use-Cases-omission-as-substrate-signal.

## §Tier-3 borrowing (meta-counter-bumps)

- §reverse-ingestion-order-of-cluster-substrate.
- §three-cycles-with-named-cross-design-composition (253 + 257 + 261).
- §four-cycles-with-Endo-Idiom-section-as-recurring-design-doc-shape (232 + 246 + 257 + 261).
- §four-cycles-with-Depends-On-bullet-list-variants (253 + 255 + 259 + 261).
- §five-cycles-with-explicit-confinement-by-omission (234 + 238 + 259 + 261 + canonical-source).
- §four-cycles-with-structural-confinement-discipline (234 + 238 + 259 + 261).
- §eight-cycles-with-canonical-caretaker-two-facet-pattern (226 + 234 + 238 + 244 + 246 + 253 + 259 + 261).
- §eight-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253 + 257 + 259 + 261).
- §two-cycles-with-section-omission-as-design-kind-signal (257 + 261).
- §library-reaches-767-sections at cycle 261 (designs-lane endoclaw-network-fetch).
- §ninety-fourth consecutive designs-chat alternation cycles 166-250 + 252-261 (251 was out-of-band).

## Pattern summary (tag-prefixed)

§canonical-two-facet-pattern + §structural-origin-allowlist + §parse-first-act-second + §three-orthogonal-control-knobs + §no-ambient-DNS-or-socket-access + §named-platform-API-non-exposures + §confinement-by-omission-at-substrate-root + §composable-with-OAuth + §the-substrate-design-names-the-derivative-design-by-link + §help-method-IS-a-named-convention + §`allowedOrigins()`-as-introspection-on-the-use-facet + §the-control-facet-has-more-methods-than-the-use-facet + §three-named-control-knobs + §revoke-as-named-permanent-state + §rate-limit-and-size-limit-as-named-discipline + §Node-LTS-version-floor-named-in-Depends-On + §two-implementation-paths-named-in-Depends-On + §Endo-Idiom-section-as-pattern-catalog + §the-Use-Cases-omission-as-substrate-signal + §reverse-ingestion-order-of-cluster-substrate + §each-endoclaw-design-extends-the-control-facet-with-its-own-specific-knobs + §section-omission-as-design-kind-signal.
