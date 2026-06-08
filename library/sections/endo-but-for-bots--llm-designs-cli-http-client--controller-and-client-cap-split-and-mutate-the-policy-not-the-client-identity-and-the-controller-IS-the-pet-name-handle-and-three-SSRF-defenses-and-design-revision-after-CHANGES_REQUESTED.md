---
title: "designs/cli-http-client.md — Controller + client cap split + mutate-the-policy-not-the-client-identity + the-controller-IS-the-pet-name-handle + three SSRF defenses + design-revision-after-CHANGES_REQUESTED"
source-slug: endo-but-for-bots--llm-designs-cli-http-client
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-http-client.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-http-client.md
total-lines: 644
ingest-cycle: 238
ingest-date: 2026-06-08
lane: designs
---

# CLI HTTP client: controller + client cap split + mutate-the-policy-not-the-client-identity + the-controller-IS-the-pet-name-handle + three SSRF defenses + design-revision-after-CHANGES_REQUESTED

A 644-line **Proposed** design (Status: Proposed; Created 2026-05-09; Updated 2026-05-10). §Author Kris Kowal (prompted). §Source-field-cites-the-PR-review-id (PR #144 review id 4256844646 `CHANGES_REQUESTED`). §Supersedes-in-part: [`endoclaw-network-fetch`](endoclaw-network-fetch.md) — §partial-supersession-as-named-relationship.

## §Design-revision-after-CHANGES_REQUESTED as named provenance

The metadata table's `Source` field cites a specific GitHub review id (`4256844646`) that triggered the redesign. The opening paragraphs describe the rejected shape (PR #144's single `HttpClient` formula) and the reason for rejection ("a single capability conflates the policy-bearing authority (which the host retains) with the use-the-policy authority (which is what gets handed to a guest)"). §Twenty-ninth-honest-design-evolution-record family member; §thirteenth-different-shape in 2026-06 cluster: §design-revision-after-CHANGES_REQUESTED-with-named-PR-and-review-id. §When-a-PR-comes-back-with-CHANGES_REQUESTED, §a-design-doc-is-the-canonical-form-of-the-revision; §the-design-doc-cites-the-PR-and-the-review-id-by-number + §the-design-doc-names-the-rejected-shape-explicitly + §the-design-doc-names-why-the-shape-was-rejected. §The-design-doc-doesn't-pretend-the-prior-shape-wasn't-tried — it's named, attributed, and improved on.

## §The controller and client cap split (canonical ocap two-facet pattern)

The host's `make` call returns a kit of two facets: a **controller cap** (policy-bearing authority — the allowlist, rate limit, byte cap, timeout, revoked bit) and a **client cap** (use-the-policy authority — `fetch` and inspection). §The-host-retains-the-controller + §the-host-grants-the-client-to-a-guest. §Disjoint-method-sets + §shared-private-state.

§Property: §A-guest-in-possession-of-the-client-cannot-widen-the-allowlist + §A-host-in-possession-of-the-controller-can-mutate-or-revoke-without-the-guest's-cooperation. §The-revocation-flips-a-shared-bit-and-every-client-method-rejects.

§Sibling to cycle 226's network-fetch six-design-cluster two-facet template; §sibling to cycle 234's endoclaw-oauth's the-agent-never-sees-the-token (where the credential is the analog of policy authority). §This-design-is-the-CLI-surface-for-the-network-fetch-two-facet-shape; §the-design-cluster-grows-by-renaming-and-restructuring-rather-than-by-adding-new-facets.

## §Mutate-the-policy-not-the-client-identity

The §load-bearing-claim of the redesign: §the-controller-can-revise-the-policy-without-re-creating-the-formula-identity, so any existing guest grant continues to work after the host tightens or loosens the allowlist.

§Three-named-benefits over PR #144's one-shot create:

1. Tighten or loosen the allowlist after the fact, in response to the guest's actual usage.
2. Revoke the client without the daemon needing to re-derive its formula identifier from the original origin list.
3. Inspect the live policy without round-tripping through the client's surface.

§The-policy-IS-a-first-class-addressable-thing-not-a-transient-closure-variable. §When-a-capability's-policy-must-evolve-over-time, §make-the-policy-a-first-class-cap-with-its-own-pet-name + §the-policy-cap-survives-across-CLI-invocations.

§Sibling to cycle 236's daemon-make-archive §state-purge-as-acceptable-design-cost (both are §design-decisions-about-identity-stability — cycle 236 chose state-purge over migration; cycle 238 chose policy-mutation-without-identity-change). §Two-cycles-with-explicit-identity-stability-as-a-named-design-axis (cycles 236 + 238).

## §The-controller-IS-the-pet-name-handle

The `endo http mk` verb produces the controller + client pair under §a-pet-name-shape-the-namer-recommends (one user-facing name with synthesized client suffix, or two paired names). The §remaining-verbs-all-take-the-controller's-pet-name + §the-client's-name-is-needed-only-when-granting-it-to-a-guest. §The-controller-IS-the-stable-handle-that-survives-across-CLI-invocations. §When-a-cap's-policy-must-evolve, §the-pet-name-of-the-cap-must-be-stable.

## §`endo http` subcommand tree replaces single verb

The CLI surface migrates from PR #144's `endo http-client --name <petname> --origins <urls>` (single one-shot verb at top level) to an `endo http <verb>` subcommand tree:

```text
endo http mk        <name>  <origins...>      [policy options]
endo http allow     <name>  <origin>
endo http deny      <name>  <origin>
endo http set-rate  <name>  <max-per-minute>
endo http set-bytes <name>  <max-bytes>
endo http set-time  <name>  <timeout-ms>
endo http revoke    <name>
endo http inspect   <name>
```

§Subcommand-tree-IS-the-room-to-grow-pattern + §single-verb-at-top-level-cannot-be-extended-without-collision. §Sibling to cycle 230 endor-npm-registry-proxy's named subcommands. §When-a-CLI-surface-needs-to-grow, §replace-the-flat-verb-with-a-subcommand-tree-and-make-the-creation-verb-one-among-siblings.

§Verb-names-as-placeholders-pending-namer-dispatch — §the-design-doc-uses-placeholders-and-calls-them-out-explicitly; §the-design-and-the-naming-are-two-different-decisions; §the-design-doesn't-block-on-the-namer.

## §Method-placement-table — which methods sit on which facet

A §method-placement-table enumerates each method and its facet:

| Method | Facet | Notes |
|---|---|---|
| `request(req, cancellation)` | client | The use-the-policy authority. |
| `allowedOrigins()` | client | Inspection of own bounds. |
| `help()` | both | Each describes its own surface. |
| `inspect()` | controller | Read the current policy. |
| `setAllowedOrigins(origins)` | controller | Replaces the set. |
| `addAllowedOrigin(origin)` | controller | Convenience. |
| `removeAllowedOrigin(origin)` | controller | Convenience. |
| `setMaxRequestsPerMinute(n)` | controller | |
| `setMaxResponseBytes(n)` | controller | |
| `setTimeoutMs(n)` | controller | |
| `revoke()` | controller | Idempotent; flips the shared bit. |

§The-table-IS-the-cap-discipline-statement. §help-on-both-facets-is-a-named-asymmetry-not-a-symmetry — *each describes its own surface*. §When-each-facet-has-a-help-method, §each-help-describes-its-own-surface-not-the-pair's-surface.

§The-add-and-remove-convenience-methods are §the-CLI-verbs-`endo http allow / deny`-back-onto: without them the CLI would have to read-then-mutate-then-write the set, §which-races-against-any-concurrent-host-side-mutation. §When-a-mutation-naturally-decomposes-into-read-mutate-write, §the-controller-MUST-expose-it-as-an-atomic-operation + §the-CLI-verb-MUST-bind-to-the-atomic-operation + §convenience-methods-prevent-races.

## §Cancellation-promise-as-platform-neutral-interface

The `request` method takes a §`cancellation: Promise<never>` second argument — §the-existing-daemon-convention (cited examples: `waitForExitOrCancel`, `WorkerFacetForDaemon.evaluate`, `SocketPowers.servePort`, `Context.cancelled`). §A-platform-neutral-caller-never-sees-AbortController + §it-only-sees-the-promise.

§AbortController-is-mapped-one-way-at-the-platform-boundary: the daemon's implementation constructs an `AbortController` per request, attaches the `cancellation` rejection to it via `cancellation.catch(reason => controller.abort(reason))`, and uses the controller's `signal` for the underlying `fetch`. §The-mapping-is-from-platform-neutral-to-platform-specific-not-the-reverse. §When-the-platform's-cancellation-shape-is-AbortController-but-the-cap-system's-shape-is-Promise<never>, §map-at-the-boundary-not-throughout.

## §Two-independent-cancellation-channels

The design names §two-independent-cancellation-channels:

1. **§Host-side-cancellation**: the controller's `revoke()` — every in-flight request rejects.
2. **§Caller-side-cancellation**: the per-request `cancellation` promise — one specific in-flight request rejects.

§The-two-channels-are-independent-on-purpose: §the-host-can-revoke-without-coordinating-with-the-guest + §the-guest-can-abort-an-individual-slow-request-without-giving-up-the-whole-client. §When-a-cap-has-both-host-and-caller-cancellation, §design-them-as-two-independent-channels-not-one-channel-with-shared-state.

## §Three-named-SSRF-vectors-and-three-named-defenses

The design preserves PR #144's three SSRF mitigations and clarifies which facet owns each knob:

1. **§Redirect-following defense.** `fetch` is invoked with `redirect: 'manual'` so a `302 Location` from an allowlisted origin to an unallowed one (instance-metadata, RFC1918) is §never-followed-by-the-daemon. §The-client-surfaces-the-Location-to-the-caller + §the-caller-may-re-issue-against-the-new-URL-which-goes-through-the-allowlist-again. §When-redirects-could-pivot-to-private-addresses, §redirect-manual-and-let-the-caller-re-validate.

2. **§Slow-loris defense.** Each `fetch` is wrapped in an `AbortController` with a wall-clock timeout (default 30 seconds; mutable via the controller's `setTimeoutMs`). §The-controller-owns-the-knob + §the-client-owns-the-per-call-wiring. §When-a-defense-is-a-policy-knob, §the-policy-facet-owns-the-knob-and-the-use-facet-owns-the-wiring.

3. **§Response-flooding defense.** Streaming reader accumulates chunks until the byte cap is reached, then aborts the upstream stream and returns a truncated prefix with `truncated: true`. §The-cap-survives-a-Content-Length-lie-because-truncation-runs-at-read-time. §When-the-server-can-lie-about-Content-Length, §truncate-at-read-time-not-at-header-parse-time.

§Origin-allowlist-is-name-based: §a-hostname-whose-A-record-resolves-to-a-private-address-still-passes-if-allowlisted. §The-trust-on-first-bind-addendum-will-offer-an-opt-in-that-pins-the-resolved-IP-at-first-contact. §The-allowlist-is-the-strict-by-default-mode + §future-trust-modes-extend-it.

## §Local-idioms-cited-table

A four-row table cites §established-conventions-rather-than-inventing-new-shapes:

| Idiom | Cited example | Adopted in |
|---|---|---|
| `ReadableBlob` remotable for byte content | `packages/platform/src/fs/interfaces.js` | request/response body fields |
| `cancellation: Promise<never>` | `packages/platform/src/proc.js` `waitForExitOrCancel`, plus daemon evaluate/servePort/Context | `HttpClientInterface.request` second arg |
| `makeExo(name, IFace, methods)` with `M.interface(...)` boundary check | every interface in `packages/daemon/src/interfaces.js` | both facets |
| Async-iterator chunk shape for streamed bytes | `packages/platform/src/fs/types.js` `ReadableStream` typedef | the `streamBase64()` method |

§Local-idioms-cited-as-explicit-discipline + §the-table-IS-the-no-new-abstractions-evidence. §Six-cycles-on-no-new-abstractions discipline now (cycles 211 + 214 + 222 + 232 + 236 + 238). §When-a-new-design-could-invent-a-new-shape-or-cite-an-existing-one, §cite-the-existing-one-and-make-the-citation-table-explicit.

## §Forward-compatibility-with-exo-stream via shim shape

§ReadableBlob-IS-the-forward-compatible-shim. When `exo-stream` lands (the unfinished refactor), the body parameter and result migrate from `M.remotable('ReadableBlob')` to `M.remotable('ExoStream')`. §The-change-is-non-breaking-for-callers because `text()` / `json()` / `streamBase64()` are §the-same-on-ReadableBlob-and-on-the-future-ExoStream — §ReadableBlob-is-the-explicit-forward-compatible-shim. §Callers-that-already-treat-the-body-as-an-opaque-remotable-do-not-change-at-all.

§The-design's-contribution-is-to-choose-the-body-shape-so-that-the-future-lift-is-a-non-breaking-refactor + §the-implementation-surface-becomes-a-thin-identity-once-the-platform-exposes-the-native-shape. §When-an-unfinished-refactor-is-known, §pick-the-shim-shape-now-so-the-future-lift-is-non-breaking + §name-the-future-target-explicitly + §name-the-current-shape-as-shim-not-as-final.

## §Alternatives-considered with rejected/deferred labels

The design enumerates §three-alternatives-with-named-fates:

- **§Alt-A: keep PR #144's single-formula shape; add per-policy CLI commands that re-create the client in place.** §Rejected: §the-rebuild-would-invalidate-any-guest-reference-to-the-old-client — §which-is-the-opposite-of-what-the-host-typically-wants. §Also-forces-the-rate-limit-window-and-any-in-flight-requests-to-reset-on-every-policy-edit.

- **§Alt-B: single facet with a method-level cap split.** §Rejected: §this-is-what-Far-plus-manual-attenuation-looks-like-in-practice + §it-sidesteps-the-makeExo-M.interface-boundary-check + §creates-two-interface-contracts-on-one-object-that-have-to-be-kept-mutually-consistent-by-hand. §The-two-facet-kit-is-the-idiomatic-Endo-expression-of-this-attenuation.

- **§Alt-C: three-way split (controller, client, inspector).** §Deferred: §the-inspection-surface-is-small-for-now + §a-later-split-into-a-separate-inspector-cap-is-a-non-breaking-change-because-no-method-moves-off-the-client-only-onto-a-new-third-facet.

§Alternatives-considered-with-three-fates (rejected + rejected + deferred) + §each-rejection-names-the-specific-failure-mode + §deferral-names-the-non-breaking-property. §When-an-alternative-is-rejected, §name-the-specific-failure-mode-not-just-the-disagreement; §when-an-alternative-is-deferred, §name-the-non-breaking-condition-under-which-it-can-be-revisited.

## §Identifier-conventions-TBD-pending-namer-dispatch

§The-identifiers-section-explicitly-says-TBD-pending-namer-dispatch + §placeholders-are-used-in-code-blocks-and-tables-and-called-out-where-they-appear. §The-document-is-structured-so-that-the-names-can-be-substituted-in-without-reshuffling-sections. §When-the-design-and-the-naming-are-two-decisions-on-different-timelines, §structure-the-design-doc-so-the-names-can-be-substituted-without-restructuring.

§Sibling-to-cycle-227's design-without-implementation-without-deployment three-stage-discipline + §sibling-to-cycle-236's naming-by-source-shape-not-by-product (cycle 236 named the methods; cycle 238 deferred naming to a separate dispatch). §Two-different-postures-on-naming-decisions-in-2026-06-cluster.

## §Open-questions-section as named uncertainty

§Open-questions section enumerates §five-named-decisions-not-yet-made:

1. Single name or paired names for the kit?
2. Should `endo http inspect` show the live rate-limit window state or only the policy? (Default: show only policy; a `--window` flag reveals the state.)
3. What is the host's recourse if `endo http mk` is invoked against an existing name? (Default: error.)
4. Should `request`'s `cancellation` parameter be required or optional? (Document proposes: required.)
5. Should the response body carry a `sha256()` method?

§Each-open-question-has-a-default-or-a-proposal; §the-design-doesn't-leave-the-questions-purely-open + §it-makes-a-recommendation-and-marks-it-as-recommendation-not-decision. §When-uncertainty-remains, §make-a-recommendation-and-mark-it-as-recommendation-not-decision-so-the-next-reviewer-can-push-back-against-a-concrete-shape.

## §Test-plan section

§The-test-plan-section enumerates eight named test scenarios:

1. Controller methods land mutations that subsequent client calls observe.
2. Revoking the controller flips client methods to a structured rejection.
3. The client cannot reach the controller through any method.
4. All PR #144 defenses port unchanged.
5. Cancellation promise rejected mid-request behavior.
6. Request/response bodies pass through `ReadableBlob` correctly.
7. CLI integration: `endo http mk` followed by `endo http allow` followed by guest fetch.
8. CLI integration: `endo http revoke` causes subsequent guest fetch to fail.

§Test-plan-named-in-the-design-doc-not-deferred-to-the-builder + §the-test-plan-IS-the-acceptance-criteria. §Eight-named-test-scenarios-with-PR-defense-port-as-one-line-item. §When-a-design-replaces-an-earlier-shape, §the-test-plan-explicitly-names-the-port-of-the-earlier-shape's-tests.

## §Dependencies-table-with-Relationship-column

| Design | Relationship |
|---|---|
| [endoclaw-network-fetch](endoclaw-network-fetch.md) | Parent; this design replaces its CLI surface and cap-split section. |
| [daemon-agent-tools](daemon-agent-tools.md) | Sibling agent-capability design; the http client is one such tool. |
| `designs/http-client-trust-on-first-bind.md` (forthcoming) | Sibling; owns the trust-mode question deferred from this design. |

§Four-cycles-with-Dependencies-table-with-Relationship-column (cycles 224 + 230 + 236 + 238). §Parent/sibling/sibling-forthcoming as three-relationship-shapes-in-one-table. §When-a-related-design-is-forthcoming, §forward-link-by-path-and-mark-it-forthcoming + §don't-block-on-the-other-design-landing.

## §Prompt-section captures the originating review comment

§Fifth-Prompt-section-instance (cycles 198 + 224 + 230 + 236 + 238). §The-Prompt-section-captures-the-originating-review-comment-not-the-prompt-to-the-LLM. §Three-named-citation-sources in the Prompt section:

1. Inline review comment on `packages/cli/src/endo.js:568` (the specific line).
2. PR #144 review id 4256844646 `CHANGES_REQUESTED` ("Let's take this back to design based on my comments here. Please open a PR that revises the design.").
3. Both linked to specific GitHub URLs.

§The-Prompt-section-anchors-the-design-to-the-PR-comments-that-triggered-it. §Each-named-comment-is-quoted-verbatim + §each-named-comment-has-a-link-to-the-PR. §The-design-doc-IS-the-prose-counterpart-to-the-PR-review-thread.

§Sibling to cycle 236's first-Follow-on-prompt — both designs grow §Prompt-section-shape-variants in 2026-06 cluster. §Twelfth-and-thirteenth-different-shapes of Prompt-section (cycle 236 added Follow-on-prompt; cycle 238 adds Prompt-from-PR-review-id).

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §Design-revision-after-CHANGES_REQUESTED-with-named-PR-and-review-id (twenty-ninth honest-design-evolution-record family member; thirteenth-different-shape in 2026-06 cluster).
- §The-controller-and-client-cap-split (canonical ocap two-facet pattern).
- §Mutate-the-policy-not-the-client-identity — three named benefits over one-shot create.
- §The-controller-IS-the-pet-name-handle that survives across CLI invocations.
- §`endo http` subcommand-tree replaces single verb (room to grow).
- §Method-placement-table as cap-discipline statement.
- §The-add-and-remove-convenience-methods on the controller prevent read-mutate-write races.
- §Cancellation-promise-as-platform-neutral-interface + §AbortController-is-mapped-one-way-at-the-platform-boundary.
- §Two-independent-cancellation-channels (host-side revoke + caller-side cancellation promise).
- §Three-named-SSRF-vectors-and-three-named-defenses (redirect + slow-loris + response-flooding).
- §The-cap-survives-a-Content-Length-lie-because-truncation-runs-at-read-time.

**Tier-2 (design discipline):**

- §Local-idioms-cited-table as no-new-abstractions evidence.
- §ReadableBlob-IS-the-forward-compatible-shim — pick the shim shape now so the future lift is non-breaking.
- §Alternatives-considered-with-three-fates (rejected + rejected + deferred); each rejection names the specific failure mode.
- §Identifier-conventions-TBD-pending-namer-dispatch — placeholders called out where they appear.
- §Open-questions section with §each-question-has-a-default-or-a-proposal.
- §Test-plan-named-in-the-design-doc — eight named scenarios.
- §Dependencies-table-with-Relationship-column (four-cycles).
- §Prompt-section-captures-the-originating-review-comment-not-the-prompt-to-the-LLM.

**Tier-3 (named comparisons):**

- §Comparison-table-with-PR-#144-shape-vs-revised-shape (five rows: names + policy revision + revocation + CLI surface + cap discipline).
- §The-split-is-a-strict-generalization — anything the rejected shape could express, the new shape can express by making one mk call and never mutating.

## §Synthesis-target — slot machine library

For a slot machine library:

- §game-controller-and-game-client-cap-split for §game-policy-vs-game-use-authority.
- §mutate-the-game-rules-not-the-game-engine-identity — game admin can adjust rules without re-deploying the game.
- §the-game-controller-IS-the-pet-name-handle that survives across player sessions.
- §game-subcommand-tree (`game mk`, `game allow-mode`, `game set-payout`, `game revoke`, `game inspect`).
- §game-method-placement-table — which methods sit on which facet (player + admin + spectator).
- §game-add-and-remove-convenience-methods on the controller prevent read-mutate-write races on the rule set.
- §game-cancellation-promise for platform-neutral abort of in-flight bets.
- §two-independent-cancellation-channels for §game-admin-revoke + §player-abort-current-bet.
- §three-SSRF-equivalents-in-game-context: §game-redirect-defense (game-rule cannot pivot to another payout source) + §game-slow-loris-defense (game-rule must respond within wall-clock timeout) + §game-response-flooding-defense (game-payout truncated at threshold).
- §local-idioms-cited-table for §game-rule-builder-uses-established-patterns.
- §game-engine-shim-shape for forward-compat with future game engines.
- §alternatives-considered with rejected/deferred labels for §game-design-doc-discipline.
- §identifier-conventions-TBD-pending-namer-dispatch for §game-content-naming-as-separate-decision.
- §open-questions-with-default-or-proposal for §game-rule-defaults-named-as-recommendations.

## §Library meta-counters

- §Library-reaches-744-sections at cycle 238 (designs-lane cli-http-client).
- §Seventy-second-consecutive designs-chat alternation cycle (cycles 166-238).
- §Twenty-ninth-honest-design-evolution-record family member (new shape: §design-revision-after-CHANGES_REQUESTED-with-named-PR-and-review-id).
- §Thirteenth-different-shape-of-design-evolution-record in 2026-06 cluster (214 + 216 + 218 + 220 + 222 + 224 + 226 + 227 + 228 + 230 + 232 + 236 + 238).
- §Six-cycles-on-no-new-abstractions discipline now (cycles 211 + 214 + 222 + 232 + 236 + 238).
- §Four-cycles-with-Dependencies-table-with-Relationship-column (cycles 224 + 230 + 236 + 238).
- §Fifth-Prompt-section-instance (cycles 198 + 224 + 230 + 236 + 238).
- §Five-cycles-with-Prompt-section-captured (cycles 198 + 224 + 230 + 236 + 238) — bumped to five.
- §Two-different-postures-on-naming-decisions-in-2026-06-cluster (cycle 236 named the methods + cycle 238 deferred naming to separate dispatch).
- §Eleven-design-cluster for the-endoclaw-feature-and-cli-http now (cycle 234's ten + cycle 238's revised CLI HTTP shape, which §partially-supersedes-endoclaw-network-fetch — so the cluster grows by a §partial-supersession-relationship).
- §Endoclaw-cluster's-CLI-surface-extracted-to-cli-http — §cluster-evolution-by-extraction-and-renaming.
- §First-explicit-observation in library of §design-revision-after-CHANGES_REQUESTED with cited PR review id.
- §First-explicit-observation of §Supersedes-in-part as a metadata-table-field-shape.
- §First-explicit-observation of §Alternatives-Considered-section-with-named-fates as a design-doc structural shape.
- §First-explicit-observation of §forward-compatible-shim-with-named-future-target as a design discipline.

(Kris Kowal (prompted) authored)
