---
title: §Borrowable patterns (tier-1)
source: agoric-labs/agoric-to-axelar-local agoric-docs/ymax-evm-remote-accounts.md
source-slug: agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts
ingest-cycle: 214 (user-requested side-ingest alongside designs-lane)
ingest-date: 2026-06-07
lane: user-requested
status: published with §independent-audit (Atredis Partners; zero critical/high/medium/low; three informational findings; one fixed)
author: Agoric Labs
related:
  - endo-but-for-bots--llm-designs-daemon-cas-management (content-addressed-storage sibling-discipline at different layer)
  - endo-but-for-bots--llm-designs-endor-run-expanded (cycle 202; root-hash-printed-to-stderr / hash-as-stable-handle sibling)
  - endo-but-for-bots--llm-designs-endoclaw (cycle 196; §ambient-vs-object-capability sibling)
  - endo-but-for-bots--llm-designs-worker-rust-xs (cycle 200; §host-compartment-vs-guest-compartment-split sibling — both designs §isolate-guest-code-from-host-authority)
  - endo-but-for-bots--llm-designs-lal-fae-form-provisioning (cycle 210; §existing-user-action-as-consent-mechanism sibling)
  - endo-but-for-bots--llm-designs-familiar-bundled-agents (cycle 208; §The-Powers-Problem-with-three-option-analysis sibling)
  - endo-but-for-bots--llm-designs-outliner-design-doc (cycle 212; §reference-scoping-no-upward-traversal sibling — both designs §confine-authority)
keywords:
  - assets-should-outlive-execution-paths
  - stable-asset-containers-for-cross-chain-portfolio-orchestration
  - per-portfolio-Remote-Account-contracts (vs shared omnibus account)
  - EIP-1167-minimal-proxy
  - deterministic-address-derivation (factory + implementation + portfolio account)
  - race-tolerant-idempotent-provisioning
  - replaceable-control-paths
  - three-state-router-authorization-state-machine (Unknown / Vetted / Authorized)
  - two-factor-authorization (EVM-multisig-vets + Ymax-via-existing-authorized-router-authorizes)
  - compromise-of-single-router-does-not-authorize-new-control-path
  - confused-deputy-defense
  - deposits-as-intents via Permit2-signed-transfers
  - factory-principal-check (only Ymax orchestration can spend)
  - self-dispatch-pattern
  - msg.sender == address(this) check
  - two-benefits-of-self-dispatch (error-catching-as-event + block-explorer-readability)
  - calldata-rewrite-replacing-txId-with-authenticated-source-address (same length encoding)
  - resolvers-as-bounded-fact-reporters (one bit success/failed not arbitrary state)
  - finality-checks-before-settlement (defends against chain reorgs + relayer retries)
  - return-path-independent-of-outgoing-transport
  - CREATE2-vs-CREATE3-distinction
  - permissionless-CREATE2 for implementation
  - permissioned-CREATE3 for router and factory (per-chain init data)
  - compromise-of-deployment-key-doesn't-alter-contract-behavior
  - Atredis-Partners-audit (zero critical/high/medium/low; three informational findings)
  - five-mermaid-diagrams in document
  - OperationResult event common format
  - SubcallOutOfGas revert
  - future-multiple-concurrent-interaction-paths including direct EVM user wallet behind timelock
  - cycle 214 user-requested side-ingest
  - first-Agoric-Labs-design ingested
parent: agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-resolvers-as-bounded-fact-reporters
---

1. **§Assets-should-outlive-execution-paths** — separate-asset-holding-contracts from execution-machinery; asset side is boring and durable, execution side is replaceable.
2. **§Three-named-properties-preserved** as §canonical-Problem-section-shape.
3. **§EIP-1167-minimal-proxy** for §per-instance-addresses-sharing-implementation.
4. **§Deterministic-address-derivation-from-multiple-identities** (factory + implementation + portfolio account) — multi-tier identity anchoring.
5. **§Race-tolerant-idempotent-provisioning** via §the-deterministic-address-IS-the-coordination-primitive.
6. **§Routers-as-authenticated-instruction-delivery (not dumb pipes)** with §confused-deputy-defense.
7. **§Three-state-router-authorization-state-machine** (Unknown / Vetted / Authorized) with §two-factor-mechanism (different-authority-per-transition).
8. **§Honest-disclosure-of-residual-trust-boundaries** — an already-authorized router is still highly privileged.
9. **§Forward-looking-statement-naming-the-future-flexibility** — direct EVM wallet access behind a timelock.
10. **§Permit2-as-intent + §factory-principal-check** for §authorization-routing where §the-permit-target-is-the-system-not-the-individual-account.
11. **§Self-dispatch-pattern with §msg.sender == address(this)** for §two-named-benefits (error-isolation-via-event-not-revert + block-explorer-readability).
12. **§Calldata-rewrite-replacing-routing-field-with-authenticated-source** when §the-two-fields-share-the-same-encoding-length.
13. **§Resolvers-as-bounded-fact-reporters** (one bit per instruction, not arbitrary state) + §finality-checks-before-settlement.
14. **§Decoupled-command-and-result-transports** for multi-transport cross-chain systems.
15. **§CREATE2-vs-CREATE3-distinction** with §named-per-chain-init-data-handling.
16. **§Compromise-of-deployment-key-doesn't-alter-deployed-contract-behavior** — security argument for permissioned deployment.
17. **§OperationResult event common format** with §txId-for-event-reporting + §target-address-for-sender-authentication.
18. **§Independent-audit-section-with-named-findings** + §fix-status-per-finding.
19. **§Five-mermaid-diagrams** as §visual-explanation-density for multi-layer architectures.
20. **§Routed instruction lifecycle** with §seven-named-steps (validate → patch → self-dispatch → checks → perform → emit-or-revert).
21. **§The-factory-IS-the-mediator** — Remote Accounts statically defer to factory for router checks; factory maintains authorization state.
22. **§Atomic-authorization-of-existing-accounts-to-new-router** — controlled upgrade without per-account migration.
