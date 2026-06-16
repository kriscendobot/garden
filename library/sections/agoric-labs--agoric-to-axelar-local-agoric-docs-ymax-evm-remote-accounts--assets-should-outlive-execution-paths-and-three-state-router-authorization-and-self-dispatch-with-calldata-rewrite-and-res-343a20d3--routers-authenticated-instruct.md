---
title: §Routers — authenticated instruction delivery (not dumb pipes)
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

> The router is not just a dumb pipe to Remote Accounts. It exposes high-level instructions that the Ymax orchestration contract uses to provision accounts, process deposits, execute account operations, and administer router authorization.

§The-router-is-the-replaceable-control-path. §Remote-Accounts-do-not-embed-or-trust-a-single-cross-chain-messaging-path-directly.

§The-messaging-layer-or-router-itself-must-ensure-that-messages-are-authentic-non-replayable-and-tied-to-the-correct-source-account. §This-avoids-confused-deputy-problems where a router could be tricked into executing instructions from an impostor.

§Borrowable-pattern: §confused-deputy-defense at §the-messaging-layer + §authentication-as-router-precondition.

§Sibling-pattern to cycle 196 endoclaw's §object-capability-vs-ambient-authority and cycle 212 outliner-design-doc's §reference-scoping-no-upward-traversal. §All-three-designs §confine-authority-at-each-layer.
