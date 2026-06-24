---
title: §Assets-should-outlive-execution-paths (separate-asset-holding-from-execution-machinery) + §EIP-1167-minimal-proxy-Remote-Accounts with §deterministic-address-derivation-from-factory-plus-implementation-plus-portfolio-account + §race-tolerant-idempotent-provisioning + §replaceable-control-paths via authenticated-routers + §three-state-router-authorization-state-machine (Unknown / Vetted / Authorized) with §two-factor-mechanism (EVM-multisig-vets + Ymax-orchestration-via-existing-authorized-router-authorizes) + §compromise-of-single-router-does-not-authorize-new-control-path security argument + §deposits-as-intents via Permit2-signed-transfers + §self-dispatch-pattern with §msg.sender==address(this)-check + §two-benefits-of-self-dispatch (error-catching-as-event-not-revert + block-explorer-readability-as-decoded-function-call-not-opaque-bytes) + §calldata-rewrite-replacing-txId-with-authenticated-source-address (same length encoding) + §resolvers-as-bounded-fact-reporters (one bit success/failed not arbitrary state) + §finality-checks-before-settlement + §return-path-independent-of-outgoing-transport + §CREATE2-vs-CREATE3-distinction (CREATE2 for permissionless implementation; CREATE3 for permissioned per-chain-init-data) + §compromise-of-deployment-key-doesn't-alter-contract-behavior + §Atredis-audit-with-three-informational-findings + §five-mermaid-diagrams — Ymax EVM Remote Accounts
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
kind: index
section_count: 21
---

Sections:

- [Source](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-resolvers-as-bounded-fact-reporters--source.md)
- [Single most structurally interesting move](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--single-most-structurally-inter.md)
- [§Three-named-properties preserved in the user intent flow](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--three-named-properties-preserv.md)
- [§EIP-1167 minimal-proxy Remote Accounts with §deterministic address derivation](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-reso-343a20d3--eip-1167-minimal-proxy-remote.md)
- [§Race-tolerant idempotent provisioning](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--race-tolerant-idempotent-provi.md)
- [§Routers — authenticated instruction delivery (not dumb pipes)](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--routers-authenticated-instruct.md)
- [§Three-state Router Authorization state machine](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--three-state-router-authorizati.md)
- [§Compromise-of-single-router argument](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--compromise-of-single-router-ar.md)
- [§Future multiple concurrent interaction paths](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--future-multiple-concurrent-int.md)
- [§Deposits as intents via Permit2 signed transfers](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--deposits-as-intents-via-permit.md)
- [§Self-dispatch pattern with §msg.sender == address(this) check](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--self-dispatch-pattern-with-msg.md)
- [§Calldata rewrite: txId replaced by authenticated source address (same length)](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--calldata-rewrite-txid-replaced.md)
- [§Resolvers as bounded fact reporters](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--resolvers-as-bounded-fact-repo.md)
- [§Return path independent of outgoing transport](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--return-path-independent-of-out.md)
- [§CREATE2 vs CREATE3 distinction — deployment model](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--create2-vs-create3-distinction.md)
- [§OperationResult event common format](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--operationresult-event-common-f.md)
- [§Atredis audit with three informational findings](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--atredis-audit-with-three-infor.md)
- [§Five-mermaid-diagrams in document](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--five-mermaid-diagrams-in-docum.md)
- [§Borrowable patterns (tier-1)](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-resolve-343a20d3--borrowable-patterns-tier-1.md)
- [§Synthesis-target](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-resolvers-as-boun-343a20d3--synthesis-target.md)
- [§First Agoric Labs design ingested](agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts--assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-res-343a20d3--first-agoric-labs-design-inges.md)
