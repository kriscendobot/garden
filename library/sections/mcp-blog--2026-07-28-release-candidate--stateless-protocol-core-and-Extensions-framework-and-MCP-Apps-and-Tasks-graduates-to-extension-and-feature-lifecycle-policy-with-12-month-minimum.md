---
title: "MCP blog — The 2026-07-28 MCP Specification Release Candidate — stateless protocol core + Extensions framework + MCP Apps + Tasks graduates to extension + feature lifecycle policy with 12-month minimum"
source-slug: mcp-blog--2026-07-28-release-candidate
source-url: https://blog.modelcontextprotocol.io/posts/2026-07-28-release-candidate/
authors: [David Soria Parra (Lead Maintainer), Den Delimarsky (Lead Maintainer)]
publication-date: 2026-05-21
spec-versions: [2025-11-25, 2026-07-28]
ingest-cycle: 251
ingest-date: 2026-06-09
lane: papers
---

# The 2026-07-28 MCP Specification Release Candidate — stateless protocol core + Extensions framework + MCP Apps + Tasks graduates to extension + feature lifecycle policy with 12-month minimum

Maintainers' blog post announcing the release candidate for MCP `2026-07-28` (RC locked 2026-05-21; final ships 2026-07-28; ten-week validation window). The largest revision since launch. §Out-of-band-papers-lane-ingest at maintainer request — §papers-lane-was-blocked-144+-consecutive-cycles before this ingest.

## §Five-named-deliverables of the release

§The-blog-opens-with-a-five-line-bullet-list of the release's deliverables:

1. **a stateless core** that scales on ordinary HTTP infrastructure
2. **extensions** including server-rendered UIs through MCP Apps and long-running work through the Tasks extension
3. **authorization** that aligns more closely with OAuth and OpenID Connect deployments
4. **a formal deprecation policy** so the protocol can evolve without breaking what you've built
5. **and many other changes**

§Five-named-deliverables-of-a-release as named announcement shape. §When-a-release-has-multiple-substantial-changes, §lead-with-a-bulleted-list-of-the-deliverables + §the-bullet-list-IS-the-table-of-contents. §First-explicit-observation in library of §lead-with-bulleted-deliverables-list as named announcement-discipline.

## §The headline change IS statelessness

§The-blog-explicitly-names: *The headline change is that MCP is now stateless at the protocol layer*. §Six-SEPs-work-together-to-get-there — §SEP-2575 (handshake-removed) + §SEP-2567 (session-removed) + §SEP-2260 (server-initiated-requests-only-while-processing-client-request) + §SEP-2322 (Multi-Round-Trip-Requests) + §SEP-2243 (Mcp-Method-and-Mcp-Name-headers) + §SEP-2549 (ttlMs-and-cacheScope).

§When-a-protocol-undergoes-a-major-architectural-change, §enumerate-the-Specification-Enhancement-Proposals-that-collectively-deliver-it + §each-SEP-is-a-self-contained-change-but-they-work-together. §First-explicit-observation in library of §multiple-SEPs-collectively-deliver-an-architectural-change as named-governance-shape.

## §Before-and-after as named code-block comparison shape

§The-blog-uses-§Before-and-after-code-blocks to make the architectural change concrete:

**Before (`2025-11-25`)** — two-request session-pin:

```
POST /mcp HTTP/1.1
Content-Type: application/json
{"jsonrpc":"2.0","id":1,"method":"initialize", ...}
```

then with `Mcp-Session-Id` returned from server:

```
POST /mcp HTTP/1.1
Mcp-Session-Id: 1868a90c-3a3f-4f5b
Content-Type: application/json
{"jsonrpc":"2.0","id":2,"method":"tools/call", ...}
```

**After (`2026-07-28`)** — single self-contained request:

```
POST /mcp HTTP/1.1
MCP-Protocol-Version: 2026-07-28
Mcp-Method: tools/call
Mcp-Name: search
Content-Type: application/json
{"jsonrpc":"2.0","id":1,"method":"tools/call",
 "params":{"name":"search","arguments":{"q":"otters"},
           "_meta":{"io.modelcontextprotocol/clientInfo":{"name":"my-app","version":"1.0"}}}}
```

§Before-and-after-code-block-pair-with-named-version-numbers as named announcement-discipline. §When-a-protocol-version-changes-the-shape-of-its-canonical-request, §show-the-before-and-after-side-by-side + §the-comparison-IS-the-explanation. §First-explicit-observation in library of §Before-and-after-code-block-pair-with-named-version-numbers.

§Sibling-pattern-to-cycle-238's-Comparison-table-with-PR-#144-shape-vs-revised-shape — §two-different-shapes-of-before-and-after: §cycle-238 tabular-comparison + §cycle-251 code-block-comparison. §Two-cycles-with-explicit-before-and-after-comparison.

## §The practical effect on a production deployment IS the value statement

§The-blog-explicitly-names: *A remote MCP server that previously needed sticky sessions, a shared session store, and deep packet inspection at the gateway can now run behind a plain round-robin load balancer, route traffic on an `Mcp-Method` header, and let clients cache `tools/list` responses for as long as the server's `ttlMs` permits.*

§The-practical-effect-IS-the-value-statement + §the-named-infrastructure-changes (sticky sessions removed + shared session store removed + deep packet inspection removed) + §the-replacement-shape (plain round-robin + Mcp-Method routing + ttlMs caching) make the value concrete.

§Three-named-things-removed + §three-named-replacements. §When-a-protocol-change-affects-operations-not-just-API, §name-the-infrastructure-changes-explicitly + §the-replacement-shape-IS-the-evidence-the-change-improves-operations. §First-explicit-observation in library of §the-practical-effect-on-production-IS-the-value-statement.

## §Stateless-protocol-stateful-applications named distinction

§Removing-the-protocol-level-session-does-not-mean-your-application-has-to-be-stateless. §The-blog-explicitly-names: *Servers that need to carry state across calls can do what HTTP APIs have always done: mint an explicit handle (a `basket_id`, a `browser_id`) from a tool and have the model pass it back as an ordinary argument on later calls.*

§The-explicit-handle-pattern — §mint-an-explicit-handle-from-a-tool + §the-model-passes-it-back-as-an-ordinary-argument; §the-state-IS-visible-to-the-model-not-hidden-in-transport-metadata.

§The-explicit-handle-makes-state-visible-to-the-model: *In practice, we've found this pattern (the model threading an identifier from one tool call to the next) to be more than just a workable substitute for session state. It's often a more powerful one. The model can compose handles across tools, reason about them, and hand them off between steps.*

§First-explicit-observation in library of §the-explicit-handle-pattern-makes-state-visible-to-the-model-not-hidden-in-transport-metadata as named architectural discipline.

§Sibling-pattern-to-cycle-244's-the-formula-IS-the-stable-handle (webhook formula-id IS the URL) — §two-cycles-with-handle-makes-substrate-visible-not-hidden: §cycle-244 formula-id-IS-URL + §cycle-251 explicit-handle-IS-state-visible-to-model.

## §Multi-Round-Trip Requests (SEP-2322) — input-required result with requestState echo

§Multi-Round-Trip-Requests-IS-the-new-server-to-client-request-mechanism. §Instead-of-holding-an-SSE-stream-open, §the-server-returns-an-InputRequiredResult:

```json
{
  "resultType": "inputRequired",
  "inputRequests": {
    "confirm": {
      "type": "elicitation",
      "message": "Delete 3 files?",
      "schema": { "type": "boolean" }
    }
  },
  "requestState": "eyJzdGVwIjoxLCJmaWxlcyI6WyJhIiwiYiIsImMiXX0="
}
```

§The-client-gathers-the-answers-and-re-issues-the-original-call-with-inputResponses-and-the-echoed-requestState. §Any-server-instance-can-pick-that-retry-up-because-everything-it-needs-is-in-the-payload.

§The-requestState-IS-the-server-side-state-encoded-in-the-payload + §the-client-doesn't-need-to-understand-it + §the-client-just-echoes-it-back-on-retry. §When-an-async-protocol-must-become-sync-or-stateless, §encode-the-server's-resumption-state-as-an-opaque-payload-the-client-echoes-back.

§First-explicit-observation in library of §opaque-server-state-echoed-by-client-as-resumption-mechanism. §Sibling-pattern-to-cycle-249's-out-of-band-communications-as-named-sync-over-async-mechanism — §two-different-shapes-of-async-to-sync-bridge: §cycle-249 out-of-band-channel + §cycle-251 opaque-state-echoed-by-client-in-retry.

§Sibling-pattern-to-cycle-241's-postponed-handler-pattern — §three-cycles-with-deferred-response-mechanisms (241 postponed-handler + 249 out-of-band-sync + 251 echo-state-on-retry).

## §Mcp-Method-and-Mcp-Name-headers for routing-without-deep-packet-inspection (SEP-2243)

§The-Streamable-HTTP-transport-now-requires-Mcp-Method-and-Mcp-Name-headers + §so-load-balancers-gateways-and-rate-limiters-can-route-on-the-operation-without-inspecting-the-body. §Servers-reject-requests-where-the-headers-and-body-disagree.

§The-headers-IS-the-routing-discriminator-extracted-from-the-body. §When-a-JSON-RPC-protocol-needs-to-be-routable-by-infrastructure-that-doesn't-parse-JSON-bodies, §expose-the-method-and-name-as-HTTP-headers + §the-server-validates-that-the-headers-match-the-body. §First-explicit-observation in library of §expose-the-routing-discriminator-as-an-HTTP-header-not-in-the-body as named architecture-pattern.

§Sibling-pattern-to-cycle-248's-drop-target-table (which mapped UI targets to existing daemon API calls) — §two-different-shapes-of-dispatch-discrimination: §UI-event-to-API-call-mapping (cycle 248) + §HTTP-header-to-JSON-body-method-mapping (cycle 251).

## §ttlMs and cacheScope modeled on HTTP Cache-Control (SEP-2549)

§List-and-resource-read-results-now-carry-ttlMs-and-cacheScope + §modeled-on-HTTP-Cache-Control. §Clients-know-exactly-how-long-a-tools/list-response-is-fresh-and-whether-it's-safe-to-share-across-users + §a-long-lived-SSE-stream-is-no-longer-the-only-way-to-learn-that-a-list-changed.

§The-cache-control-shape-IS-the-replacement-for-SSE-polling. §When-a-stateful-mechanism-can-be-replaced-by-cache-control-semantics, §use-the-cache-control-semantics + §it's-simpler-to-implement-and-debug.

§Two-named-cache-fields: §ttlMs (time-to-live in milliseconds) + §cacheScope (per-user vs shared). §When-a-cache-policy-must-be-communicated-to-the-client, §use-two-orthogonal-fields-for-time-and-scope.

§Sibling-pattern-to-cycle-239's-the-cache-staleness-caveat-as-explicit-warning — §two-cycles-with-explicit-cache-semantics-in-protocol-contract.

## §W3C Trace Context propagation locking-down key names in `_meta` (SEP-414)

§W3C-Trace-Context-propagation-in-_meta-is-now-documented + §locking-down-the-traceparent-tracestate-and-baggage-key-names + §so-distributed-traces-correlate-across-SDKs-and-gateways. §Several-SDKs-and-tools-were-already-doing-this — §the-spec-formalizes-existing-practice.

§Three-named-key-names (traceparent + tracestate + baggage). §When-existing-SDK-practice-uses-particular-key-names-for-distributed-tracing, §formalize-them-in-the-spec + §locking-down-the-key-names-is-the-correlation-mechanism.

§A-trace-that-starts-in-a-host-application-can-follow-a-tool-call-through-the-client-SDK-the-MCP-server-and-whatever-the-server-calls-downstream + §show-up-as-a-single-span-tree-in-an-OpenTelemetry-compatible-backend.

§First-explicit-observation in library of §formalize-existing-key-names-in-spec as named correlation-mechanism. §Sibling-to-cycle-239's-named-protocol-constant — §two-cycles-with-named-protocol-string-key-conventions.

## §Extensions become first-class with reverse-DNS IDs (SEP-2133)

§Extensions-existed-in-2025-11-25-but-had-no-formal-process. §SEP-2133-adds-that: §extensions-are-identified-by-reverse-DNS-IDs + §negotiated-through-an-extensions-map-on-client-and-server-capabilities + §live-in-their-own-ext-*-repositories-with-delegated-maintainers + §version-independently-of-the-specification.

§A-new-Extensions-Track-in-the-SEP-process-gives-them-a-path-from-experimental-to-official. §Two-tracks (Standards-Track for core spec + Extensions-Track for extensions); §each-track-has-its-own-graduation-path.

§Reverse-DNS-IDs as named-identifier-convention (e.g., `io.modelcontextprotocol/clientInfo` seen in the example payload). §When-a-protocol-needs-extension-identifiers-that-don't-collide, §use-reverse-DNS + §the-DNS-namespace-IS-the-uniqueness-guarantee.

§First-explicit-observation in library of §reverse-DNS-IDs-as-named-identifier-convention-for-extensions.

§Sibling-pattern-to-cycle-248's-custom-MIME-type (`application/x-endo-petname`) — §two-cycles-with-named-extension-identifier-conventions: §cycle-248 custom-MIME-type-with-x-prefix + §cycle-251 reverse-DNS-IDs.

## §MCP Apps as server-rendered UI in sandboxed iframe (SEP-1865)

§MCP-Apps-lets-servers-ship-interactive-HTML-interfaces-that-hosts-render-in-a-sandboxed-iframe. §Tools-declare-their-UI-templates-ahead-of-time-so-hosts-can-prefetch-cache-and-security-review-them-before-anything-runs. §The-rendered-UI-talks-back-to-the-host-over-the-same-JSON-RPC-base-protocol-used-everywhere-else-in-MCP + §every-UI-initiated-action-goes-through-the-same-audit-and-consent-path-as-a-direct-tool-call.

§Three-named-defenses: §sandboxed-iframe (browser isolation) + §declared-ahead-of-time (cacheable + reviewable) + §UI-talks-back-via-same-JSON-RPC (same audit/consent path).

§When-a-server-can-render-interactive-UI-in-a-host, §the-isolation-IS-the-sandbox + §the-pre-declaration-IS-the-cacheability-and-review + §the-back-channel-IS-the-same-as-the-direct-tool-call-channel.

§First-explicit-observation in library of §server-rendered-UI-with-three-named-defenses (sandbox + pre-declaration + uniform-back-channel). §Sibling-pattern-to-cycle-238's-three-named-SSRF-vectors-and-three-named-defenses — §two-cycles-with-three-named-defenses-against-a-substrate-risk.

## §Tasks graduates to an extension — named demotion from core

§Tasks-shipped-as-an-experimental-core-feature-in-2025-11-25. §Production-use-surfaced-enough-redesign-that-the-right-home-for-it-is-an-extension-rather-than-the-specification.

§The-named-rationale: §the-protocol-substrate-changed-shape (stateless) + §the-feature's-lifecycle-no-longer-fits-the-core. §Anyone-who-shipped-against-the-2025-11-25-experimental-Tasks-API-will-need-to-migrate-to-the-new-lifecycle.

§Task-creation-is-server-directed: §the-client-advertises-the-extension-and-the-server-decides-when-a-call-should-run-as-a-task. §tasks/list-is-removed-because-it-can't-be-scoped-safely-without-sessions.

§First-explicit-observation in library of §feature-graduates-to-an-extension-as-named-demotion-from-core. §The-direction-is-not-promotion-but-demotion + §the-redesign-IS-the-evidence-the-feature-belongs-elsewhere.

§Sibling-pattern-to-cycle-242's-stops-at-the-filesystem-boundary — §two-different-shapes-of-named-scope-boundary: §cycle-242 explicit-boundary-of-this-design + §cycle-251 explicit-demotion-of-feature-from-core-to-extension.

§Sibling-to-cycle-244's-no-cron-semantics — §three-cycles-with-explicit-refusal-of-conventional-feature-or-graduation (240 no-encoding + 242 no-help + 244 no-cron + 251 tasks-demoted).

## §Authorization hardening — six SEPs for OAuth/OpenID Connect alignment

§Six-SEPs-harden-the-authorization-specification-to-align-more-closely-with-how-OAuth-2.0-and-OpenID-Connect-are-deployed-in-practice. §Six-named-SEPs:

- **SEP-2468**: §iss-parameter-validation-per-RFC-9207 (mix-up-attack mitigation).
- **SEP-837**: §OpenID-Connect-application_type-during-Dynamic-Client-Registration (avoids defaulting CLI clients to `"web"`).
- **SEP-2352**: §clients-bind-registered-credentials-to-the-issuing-authorization-server's-issuer + §re-register-when-a-resource-migrates-between-authorization-servers.
- **SEP-2207**: §how-to-request-refresh-tokens-from-OpenID-Connect-style-authorization-servers.
- **SEP-2350**: §scope-accumulation-during-step-up.
- **SEP-2351**: §the-.well-known-discovery-suffix.

§Each-SEP-cites-a-specific-OAuth-or-OpenID-Connect-real-world-deployment-pain-point. §When-a-protocol-hardens-against-existing-standards, §enumerate-the-SEPs-by-number-and-name-the-real-world-pain-each-addresses.

§The-future-direction-named: *In a future version, clients will be expected to reject responses that omit `iss`, so authorization servers should begin supplying it now if they don't already.*

§First-explicit-observation in library of §the-future-direction-named-in-a-current-release as named forward-compatibility-discipline. §Sibling-pattern-to-cycle-238's-reserved-future-siblings — §two-different-shapes-of-future-direction-naming: §cycle-238 reserved-verb-names + §cycle-251 future-rejection-policy-named-now.

## §Three core features deprecated under new lifecycle policy (SEP-2577)

§Three-core-features-deprecated-under-the-new-feature-lifecycle-policy:

| Feature | Replacement |
|---------|-------------|
| Roots | Tool parameters, resource URIs, or server configuration |
| Sampling | Direct integration with LLM provider APIs |
| Logging | `stderr` for stdio transports; OpenTelemetry for structured observability |

§The-deprecations-are-annotation-only — §the-methods-types-and-capability-flags-continue-to-work-in-this-release-and-in-every-specification-version-published-within-a-year-of-it + §removing-any-of-them-will-require-a-separate-SEP-under-the-lifecycle-policy.

§Each-deprecated-feature-has-a-named-replacement-mechanism — §not-all-replaced-by-the-same-thing + §each-replacement-IS-appropriate-for-the-feature-it-replaces. §When-a-protocol-deprecates-multiple-features, §name-the-replacement-for-each-feature-individually + §don't-use-a-single-blanket-replacement.

§First-explicit-observation in library of §per-deprecated-feature-named-replacement as named deprecation-discipline.

§Sibling-pattern-to-cycle-238's-reserved-future-siblings + cycle-244's-no-cron-semantics — §three-different-shapes-of-feature-management: §reserved-future-siblings + §explicit-refusal + §deprecated-with-named-replacement.

## §Twelve-month minimum between deprecation and removal as named lifecycle policy

§Three-state-lifecycle: §Active + §Deprecated + §Removed. §At-least-twelve-months-between-deprecation-and-the-earliest-possible-removal. §The-feature-lifecycle-policy-gives-every-feature-this-lifecycle.

§Twelve-months-IS-the-named-floor-not-the-target. §When-a-protocol-deprecates-a-feature, §name-the-minimum-time-before-removal + §the-minimum-IS-the-promise-to-existing-implementers.

§First-explicit-observation in library of §twelve-month-minimum-between-deprecation-and-removal as named-lifecycle-policy.

§Sibling-pattern-to-cycle-238's-Alt-C-deferred-as-non-breaking-change — §two-different-shapes-of-deferred-feature-handling: §cycle-238 deferred-as-non-breaking-change + §cycle-251 deprecated-with-twelve-month-floor-before-removal.

## §Full JSON Schema 2020-12 for tool schemas (SEP-2106) with named security constraints

§Tool-inputSchema-and-outputSchema-are-lifted-to-full-JSON-Schema-2020-12. §Input-schemas-keep-the-type-object-root-constraint-but-now-allow-composition (oneOf + anyOf + allOf) + conditionals + references ($ref + $defs). §Output-schemas-are-unrestricted + §structuredContent-can-now-be-any-JSON-value-rather-than-only-an-object.

§Two-named-security-constraints: §implementations-must-not-auto-dereference-external-$ref-URIs + §implementations-should-bound-schema-depth-and-validation-time. §When-a-protocol-adopts-a-more-expressive-schema-language, §name-the-security-constraints-explicitly + §the-power-comes-with-named-bounds.

§First-explicit-observation in library of §named-security-constraints-when-adopting-more-expressive-schema-language. §Sibling-pattern-to-cycle-238's-three-named-SSRF-vectors-and-three-named-defenses — §two-different-shapes-of-named-security-bounds: §cycle-238 named-SSRF-defenses + §cycle-251 named-schema-validation-bounds.

## §Named breaking change for clients matching on literal error code value (SEP-2164)

§The-error-code-for-a-missing-resource-changes-from-the-MCP-custom--32002-to-the-JSON-RPC-standard--32602-Invalid-Params. §If-your-client-matches-on-the-literal--32002-value-update-it.

§Named-breaking-change-with-named-affected-consumer-pattern. §When-a-spec-changes-a-magic-number, §explicitly-call-out-the-pattern-of-consumer-that-must-update + §don't-just-list-the-change + §the-callout-IS-the-migration-aid.

§First-explicit-observation in library of §named-breaking-change-with-named-affected-consumer-pattern as named migration-discipline.

## §The stateless rework needed a clean break — explicit acknowledgment

§The-blog-explicitly-names: *This release contains breaking changes. We don't intend for that to be the norm.* + *The stateless rework in this release is the kind of foundational change that needed a clean break. With it landed, and with deprecation windows and extensions as the standard tools going forward, our expectation is that implementers targeting `2026-07-28` will be able to adopt future revisions without rewriting their transport or lifecycle code.*

§Named-acknowledgment-that-breaking-changes-are-not-the-future + §the-current-breaking-change-IS-the-foundation-for-non-breaking-future-changes. §When-a-protocol-makes-a-breaking-change-that-it-doesn't-want-to-repeat, §name-the-acknowledgment-explicitly + §name-the-future-discipline-that-replaces-breaking-changes.

§Three-named-future-disciplines: §feature-lifecycle-policy + §Extensions-framework + §Standards-Track-SEP-cannot-reach-Final-without-conformance-suite-scenario.

§First-explicit-observation in library of §the-breaking-change-IS-the-foundation-for-non-breaking-future-changes as named-governance-rhetoric.

§Sibling-pattern-to-cycle-236's-state-purge-as-acceptable-design-cost — §two-cycles-with-named-acceptance-of-current-breaking-change-as-investment-in-future-non-breaking-changes.

## §Conformance suite required for Standards Track SEP to reach Final (SEP-2484)

§A-Standards-Track-SEP-can-no-longer-reach-Final-status-until-a-matching-scenario-lands-in-the-conformance-suite. §The-conformance-suite-IS-the-gating-mechanism-for-Final-status.

§The-conformance-suite-IS-the-same-suite-the-new-SDK-tier-system-scores-official-SDKs-against. §The-suite-IS-the-shared-substrate-for-both-spec-evolution-and-SDK-quality.

§First-explicit-observation in library of §conformance-suite-as-gating-mechanism-for-Final-status as named-governance-shape.

§Sibling-pattern-to-cycle-244's-Test-Plan-section + cycle-248's-Test-Plan-section — §three-cycles-with-explicit-test-verification-as-gating-mechanism: §244 design-level test-plan + §248 implementation-level test-plan + §251 governance-level conformance-suite-required-for-Final.

## §Validation window — RC lock + final date with ten-week window

§RC-locked-2026-05-21 + §final-ships-2026-07-28 + §ten-week-validation-window. §Tier-1-SDKs-are-expected-to-ship-support-within-this-window-under-the-SDK-tier-system.

§The-ten-week-window-IS-the-named-validation-period + §the-SDK-tier-system-IS-the-mechanism-for-enforcing-tier-1-SDK-expectations. §When-a-spec-has-a-release-candidate-and-a-final-date, §the-window-between-IS-the-named-validation-period + §the-SDK-tier-system-IS-the-named-discipline-mechanism.

§First-explicit-observation in library of §release-candidate-to-final-as-named-validation-window-with-tier-1-SDK-expectations.

§Sibling-pattern-to-cycle-242's-Roadmap-calibration-per-git-blame — §two-cycles-with-explicit-named-time-windows-in-design-or-release-narrative.

## §Two lead maintainers + reading-time-shown

§Author-byline: §David-Soria-Parra (Lead Maintainer) + §Den-Delimarsky (Lead Maintainer). §Two-co-maintainers-named-with-named-role.

§Reading-time-shown-IS-9-minutes. §Reading-time-as-named-affordance-for-blog-readers + §when-a-blog-post-is-load-bearing-for-implementers, §showing-the-reading-time-IS-a-respect-for-the-reader's-budget.

§Sibling-pattern-to-cycle-244's-two-Author-fields-with-named-roles — §two-cycles-with-named-roles-for-multiple-authors: §cycle-244 (prompted) + (evolving) + §cycle-251 (Lead Maintainer) + (Lead Maintainer). §Two-cycles-with-explicit-author-roles-as-named-discipline.

## §Specification Enhancement Proposals (SEPs) as named-governance-shape

§The-blog-references-many-SEPs-by-number: §SEP-2575 + §SEP-2567 + §SEP-2260 + §SEP-2322 + §SEP-2243 + §SEP-2549 + §SEP-414 + §SEP-2133 + §SEP-1865 + §SEP-2468 + §SEP-837 + §SEP-2352 + §SEP-2207 + §SEP-2350 + §SEP-2351 + §SEP-2577 + §SEP-2596 + §SEP-2484 + §SEP-2106 + §SEP-2164.

§Twenty-named-SEPs in one blog post. §Each-SEP-is-a-numbered-named-decision + §the-SEP-process-IS-the-governance-mechanism. §When-a-protocol-has-a-formal-enhancement-process, §reference-decisions-by-their-process-number + §the-numbers-IS-the-traceable-history.

§First-explicit-observation in library of §SEP-numbering-as-traceable-history-of-protocol-decisions.

§Sibling-to-cycle-238's-PR-#144-review-id-cited and cycle-240's-PR-#128-discussion_r3205660244 — §three-cycles-with-cited-numbered-decision-tokens: §cycle-238 PR + review-id + §cycle-240 PR + discussion-id + §cycle-251 SEP-numbers.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §Five-named-deliverables-of-a-release as named announcement shape.
- §Multiple-SEPs-collectively-deliver-an-architectural-change as named governance shape.
- §Before-and-after-code-block-pair-with-named-version-numbers as named announcement discipline.
- §The-practical-effect-on-production-IS-the-value-statement (three named things removed + three named replacements).
- §Stateless-protocol-stateful-applications named distinction with §the-explicit-handle-pattern.
- §The-explicit-handle-makes-state-visible-to-the-model-not-hidden-in-transport-metadata.
- §Opaque-server-state-echoed-by-client-as-resumption-mechanism (`requestState`).
- §Expose-the-routing-discriminator-as-an-HTTP-header-not-in-the-body (Mcp-Method + Mcp-Name).
- §Cache-control-shape-as-replacement-for-SSE-polling (ttlMs + cacheScope).
- §Formalize-existing-key-names-in-spec as named correlation-mechanism (W3C Trace Context).
- §Reverse-DNS-IDs-as-named-identifier-convention-for-extensions.
- §Server-rendered-UI-with-three-named-defenses (sandbox + pre-declaration + uniform-back-channel).
- §Feature-graduates-to-an-extension-as-named-demotion-from-core (Tasks).
- §Per-deprecated-feature-named-replacement as named deprecation discipline.
- §Twelve-month-minimum-between-deprecation-and-removal as named lifecycle policy.
- §Named-security-constraints-when-adopting-more-expressive-schema-language.
- §Named-breaking-change-with-named-affected-consumer-pattern.
- §The-breaking-change-IS-the-foundation-for-non-breaking-future-changes as named governance rhetoric.
- §Conformance-suite-as-gating-mechanism-for-Final-status.

**Tier-2 (governance / process patterns):**

- §SEP-numbering-as-traceable-history-of-protocol-decisions.
- §Release-candidate-to-final-as-named-validation-window-with-tier-1-SDK-expectations.
- §The-future-direction-named-in-a-current-release as named forward-compatibility discipline.
- §Two-tracks (Standards-Track + Extensions-Track) for separation of stable-core and extension-experimentation.
- §Three-state-lifecycle (Active + Deprecated + Removed) as named policy.
- §Two-co-maintainers-named-with-named-role.
- §Reading-time-shown as named affordance for blog readers.

**Tier-3 (named comparisons):**

- §Sibling-patterns-across-libraries: explicit-handle (244 + 251) + named-extension-identifier (248 + 251) + three-named-defenses (238 + 251) + author-roles (244 + 251) + cited-numbered-decision-tokens (238 + 240 + 251) + named-security-bounds (238 + 251) + state-purge-as-investment (236 + 251).

## §Synthesis target — slot machine library

For a slot machine library:

- §Stateless-game-protocol-stateful-game-application with §game-state-handle-IS-explicit-argument-to-tools.
- §Game-engine-routing-via-HTTP-header-not-body-inspection (Mcp-Method analog).
- §Game-rule-list-with-ttlMs-and-cacheScope for §game-rule-cache-control.
- §Server-rendered-game-UI-in-sandboxed-iframe with §three-named-defenses (sandbox + pre-declaration + uniform-back-channel).
- §Game-feature-graduates-to-an-extension-as-named-demotion-from-core.
- §Reverse-DNS-IDs for §game-extension-namespaces.
- §Twelve-month-minimum-between-deprecation-and-removal for §game-rule-deprecation-policy.
- §Per-deprecated-game-rule-named-replacement.
- §Conformance-suite-as-gating-mechanism for §game-rule-standards-track.
- §Named-breaking-change-with-named-affected-consumer-pattern for §game-rule-migration-aid.
- §SEP-numbering-as-traceable-history for §game-design-decision-record.

## §Library meta-counters

- §Library-reaches-757-sections at cycle 251 (papers-lane MCP-RC-blog-post).
- §**First-papers-lane-ingest-after-144+-blocked-cycles** — §papers-lane-broken-by-out-of-band-maintainer-request.
- §Cycle-251-is-an-out-of-band-cycle, not part of the designs-chat alternation.
- §First-direct-ingest from `https://blog.modelcontextprotocol.io/`.
- §First-protocol-spec-blog-post ingested in library.
- §First-non-Endo-source ingested in library since the long Endo cluster began.
- §First-explicit-observation of nineteen patterns (see Tier-1 borrowing list).
- §Two-cycles-with-explicit-before-and-after-comparison (238 + 251).
- §Two-cycles-with-three-named-defenses-against-a-substrate-risk (238 + 251).
- §Two-cycles-with-explicit-named-time-windows (242 + 251).
- §Two-cycles-with-named-roles-for-multiple-authors (244 + 251).
- §Three-cycles-with-deferred-response-mechanisms (241 + 249 + 251).
- §Three-cycles-with-explicit-refusal-or-graduation-of-conventional-feature (240 + 244 + 251 Tasks demoted).
- §Three-cycles-with-explicit-test-verification-as-gating-mechanism (244 + 248 + 251).
- §Three-cycles-with-cited-numbered-decision-tokens (238 + 240 + 251).
- §Sibling-pattern-to-cycle-236's-state-purge-as-investment — §two-cycles-with-named-acceptance-of-current-breaking-change-as-investment.

(David Soria Parra + Den Delimarsky, Lead Maintainers of MCP, authored)
