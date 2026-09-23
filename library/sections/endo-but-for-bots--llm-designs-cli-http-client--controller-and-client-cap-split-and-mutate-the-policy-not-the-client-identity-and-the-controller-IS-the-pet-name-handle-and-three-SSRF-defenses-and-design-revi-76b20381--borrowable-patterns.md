---
title: §Borrowable patterns
source-slug: endo-but-for-bots--llm-designs-cli-http-client
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-http-client.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-http-client.md
total-lines: 644
ingest-cycle: 238
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED
---

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
