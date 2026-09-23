---
title: §Future multiple concurrent interaction paths
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

> In the future, this model can support multiple concurrent interaction paths, potentially including direct EVM user wallet access behind a timelock, without changing where assets are held.

§Forward-looking-statement: §the-router-abstraction supports §future-direct-EVM-wallet-access (behind a timelock).

§Borrowable-pattern: §forward-looking-statement-naming-the-future-flexibility for §designs-that-build-room-for-extension.

§Sibling-pattern to cycle 204 weblet-next's §Note-on-the-Next-Rendition and cycle 198 patterns-diagnostic-feedback's §future-helpers-named-not-shipped.
