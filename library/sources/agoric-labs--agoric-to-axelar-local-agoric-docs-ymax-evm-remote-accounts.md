---
title: "Ymax EVM Remote Accounts — Stable Asset Containers for Cross-Chain Portfolio Orchestration"
source-slug: agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts
url: https://github.com/agoric-labs/agoric-to-axelar-local/blob/main/agoric-docs/ymax-evm-remote-accounts.md
authors: [Agoric Labs]
repo: agoric-labs/agoric-to-axelar-local
path: agoric-docs/ymax-evm-remote-accounts.md
total-lines: ~270 (with five mermaid diagrams)
status: published with §independent-audit (Atredis Partners 2026 Ymax Agoric Solidity Contract Assessment; zero critical/high/medium/low; three informational findings; one fixed in router implementation)
ingest-cycle: 214 (user-requested side-ingest)
ingest-date: 2026-06-07
lane: user-requested
---

# Ymax EVM Remote Accounts — Stable Asset Containers for Cross-Chain Portfolio Orchestration

Architectural design document for the Ymax cross-chain portfolio system. Describes how an Agoric orchestration contract turns a single signed user intent into a coordinated sequence of actions across multiple EVM chains while preserving §three-named-properties (asset segregation / no shared omnibus / no manual per-chain operation).

## The thesis

> **Assets should outlive execution paths.**

§The-key-architectural-choice: §separate-the-contracts-that-hold-assets-from-the-machinery-used-to-operate-them. §The-asset-holding-side-needs-to-be-boring-and-durable. §The-execution-side has §different-pressures (cross-chain messaging providers change; instruction formats evolve; new ways of interacting with EVM accounts may become useful).

## Key design moves

- **§Assets-should-outlive-execution-paths** — separate asset-holding contracts from execution machinery.
- **§Three-named-properties** preserved: asset segregation; no shared omnibus; no manual per-chain operation.
- **§EIP-1167 minimal-proxy Remote Accounts** with §deterministic-address-derivation from §three-inputs (factory + implementation + portfolio account).
- **§Race-tolerant idempotent provisioning** via §the-deterministic-address-IS-the-coordination-primitive.
- **§Routers as authenticated instruction delivery** (not dumb pipes) with §confused-deputy-defense.
- **§Three-state Router Authorization state machine** (Unknown / Vetted / Authorized) with §two-factor-mechanism (EVM multisig vets + Ymax via existing authorized router authorizes).
- **§Compromise-of-single-router-does-not-authorize-new-control-path** security argument.
- **§Honest-disclosure-of-residual-trust-boundaries** — an already-authorized router is still highly privileged.
- **§Forward-looking-statement** — multiple concurrent interaction paths including direct EVM wallet access behind timelock.
- **§Deposits as intents** via Permit2 signed transfers with §factory-principal-check (only Ymax orchestration can spend).
- **§Self-dispatch pattern** with §msg.sender == address(this) check + §two-named-benefits (error-isolation-via-event-not-revert + block-explorer-readability).
- **§Calldata rewrite** replacing txId with authenticated source address (same encoding length) — converts out-of-band authentication into in-band argument.
- **§Resolvers as bounded fact reporters** — one bit per instruction (success/failed); not arbitrary state.
- **§Finality-checks-before-settlement** — defends against chain reorgs and relayer retries.
- **§Return-path-independent-of-outgoing-transport** — different cross-chain providers for command vs result.
- **§CREATE2-vs-CREATE3 distinction**: permissionless CREATE2 for implementation; permissioned CREATE3 for router and factory (per-chain init data).
- **§Compromise-of-deployment-key-doesn't-alter-deployed-contract-behavior** — only affects address consistency goal.
- **§OperationResult event common format** with §txId for event reporting + §target address for sender authentication.
- **§Routed instruction lifecycle** with §seven-named-steps (validate → patch → self-dispatch → checks → perform → emit-or-revert).
- **§The-factory-IS-the-mediator** — Remote Accounts statically defer to factory for router checks.
- **§Atomic-authorization-of-existing-accounts-to-new-router** — controlled upgrade without per-account migration.
- **§Independent-audit-section-with-named-findings** + §fix-status-per-finding (Atredis Partners 2026; three informational findings; one fixed).
- **§Five-mermaid-diagrams** in document.

## Ingest scope

User-requested side-ingest during cycle 214 (designs-lane lal-reply-chain-transcripts). One section file. §First-Agoric-Labs-design-ingested into the library.

## Related material in the library

- **cycle 202 endor-run-expanded**: §root-hash-printed-to-stderr / hash-as-stable-handle sibling — both designs use deterministic naming as the coordination primitive.
- **cycle 196 endoclaw**: §ambient-vs-object-capability sibling — both designs §confine-authority at each layer.
- **cycle 200 worker-rust-xs**: §host-compartment-vs-guest-compartment-split sibling — both designs §isolate-guest-code-from-host-authority.
- **cycle 210 lal-fae-form-provisioning**: §existing-user-action-as-consent-mechanism sibling; §inbox-as-durable-config-store sibling (Ymax's deterministic Remote-Account-address is similar — the structure IS the lookup).
- **cycle 208 familiar-bundled-agents**: §The-Powers-Problem-with-three-option-analysis sibling — both designs carefully stage authority transitions.
- **cycle 212 outliner-design-doc**: §reference-scoping-no-upward-traversal sibling — both designs §confine-authority.
- **cycle 197 panic**: §default-erroneous-exit + no-ambient-normal-exit asymmetry with §"no-further-loss-in-security"-historical-note sibling — both designs §name-the-trade-off-explicitly.
- **cycle 203 cache-map**: §don't-establish-entry-until-prior-steps-succeed sibling — both designs §isolate-failure-from-broader-state-changes.
- **cycle 162 daemon-Ken-protocol** (implicit via cycle 178 daemon-xs-worker-snapshot): §atomic-checkpoint sibling — all-or-none discipline.
- **cycle 198 patterns-diagnostic-feedback**: §future-helpers-named-not-shipped sibling.
- **cycle 204 weblet-next**: §Note-on-the-Next-Rendition sibling — both designs name forward flexibility.

## Atredis audit summary

> Atredis reported no critical, high, medium, or low severity findings. The report included three informational findings. [...] The third identified a logic bug in the router's out-of-gas heuristic handling. That bug has since been fixed in the router implementation, and because it has no expected operational impact, the fix will be deployed with a future router upgrade.

§Independent-third-party-validation strengthens the design's claim to soundness.
