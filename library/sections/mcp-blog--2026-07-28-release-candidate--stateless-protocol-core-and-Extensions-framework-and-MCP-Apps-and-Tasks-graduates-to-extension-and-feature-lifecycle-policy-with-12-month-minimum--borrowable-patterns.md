---
title: §Borrowable patterns
source-slug: mcp-blog--2026-07-28-release-candidate
source-url: https://blog.modelcontextprotocol.io/posts/2026-07-28-release-candidate/
authors: [David Soria Parra (Lead Maintainer), Den Delimarsky (Lead Maintainer)]
publication-date: 2026-05-21
spec-versions: [2025-11-25, 2026-07-28]
ingest-cycle: 251
ingest-date: 2026-06-09
lane: papers
parent: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum
---

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
